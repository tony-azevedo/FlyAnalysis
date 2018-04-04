%% Batch script for thresholding regions of interest for k_means
% for faster kmeans clustering of individual movies

% Assuming I'm in a directory where the movies are to be processed
if ~isempty(regexp(pwd,'compressed'))
    error('Not in the right directory')
end
    
protocol = 'EpiFlash2T';

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);
data = load(datastructfile); data = data.data;

D_shortened = [D 'compressed' filesep];

displayf = figure;
set(displayf,'position',[40 10 1280 1024]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')
        
br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

tr_idx =  trialnumlist(1);
while tr_idx <= trialnumlist(end)
    h = load(sprintf(trialStem,data(tr_idx).trial));
    fprintf('%s\n',h.name);

    trials = findLikeTrials('name',h.name,'datastruct',data);
    if isempty(trials)
        tr_idx = tr_idx+1;
    end
    waitbar(tr_idx/length(data),br);
    
    h = load(sprintf(trialStem,trials(1)));

    downsampledDataPath = regexprep(h.name,regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
    if isfield(h,'badmovie')
        fprintf('\t ** Bad movie, moving on\n');
        tr_idx = trials(end)+1;
        continue
    end
    if exist(downsampledDataPath ,'file')
        tic
        trial = load(downsampledDataPath); % ~1 sec
        if isfield(trial,'trial')
            trial = trial.trial;
        end
        dsi = repmat(trial.downsampledImage,1,1,length(trials));
        
        for t_idx = 1:length(trials);
            downsampledDataPath = regexprep([D,sprintf(trialStem,trials(t_idx))],regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
            trial = load(downsampledDataPath); % ~1 sec
            dsi(:,:,(t_idx-1)*size(trial.downsampledImage,3)+1:t_idx*size(trial.downsampledImage,3)) = trial.downsampledImage;
        end
        
        smooshedframe = mean(dsi,3);
        
        % Compromise on the threshold and mask across trials in the block
        mask = zeros(size(smooshedframe));
        for t_idx = 1:length(trials);
            roi = load(sprintf(trialStem,trials(t_idx)),'kmeans_ROI');
            theta = load(sprintf(trialStem,trials(t_idx)),'kmeans_threshold');
            mask_ = poly2mask(roi.kmeans_ROI{1}(:,1),roi.kmeans_ROI{1}(:,2),size(smooshedframe,1),size(smooshedframe,2));
            abvthresh = smooshedframe<=theta.kmeans_threshold & mask_;
            abvthresh = imgaussfilt(double(abvthresh),3);
            abvthresh = abvthresh>.1;
            abvthresh = ~abvthresh&mask_;
            mask = mask+double(abvthresh);
        end
        % all but two trials in the block include these pixels
        abvthresh = mask>round(numel(trials))/2;
        
        % 170830 - try just using the mask instead of thresholding it. - update, This didn't work
        % abvthresh = mask;
        
        hold(dispax,'off');
        im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);
        %im = imshow(smooshedframe.*abvthresh,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);
        hold(dispax,'on');
        
        % Subtract off the mean flucutations
        img = reshape(dsi,numel(abvthresh),size(dsi,3))-repmat(smooshedframe(:),1,size(dsi,3));
        img = img(abvthresh(:),:);
        
        % 170830 - trying to increase the clusters when the background is
        % in - update, This didn't work
        N_cl = 5;
        
        %% Kmeans calculated
        [idx1,C1]=kmeans(img,N_cl,'Distance','correlation','Replicates',4);
        
        %%
        clmask0 = zeros(size(smooshedframe));
        clmask = zeros(size(smooshedframe));
        clmask0(abvthresh) = idx1;
                
        clrs = parula(N_cl);
        
        for cl = 1:N_cl
            hold(dispax,'on')
            alphamask(clmask0==cl,clrs(cl,:),.3,dispax);
        end
        
        % Then watershed the k_means clusters
        
        % calculate the density of the cluster points
        for cl = 1:N_cl
            currcl = clmask0==cl;
            currcl = imgaussfilt(double(currcl),3);
            currcl = currcl>.75;
            alphamask(currcl,clrs(cl,:),.5,dispax);   
            
            clmask(clmask==cl) = 0;
            clmask(currcl) = cl;
        end
        
       
        plotclusterfig = figure;
        set(plotclusterfig,'Position',[1196 44 560 420]);
        ax = subplot(1,1,1);
        
        for cl = 1:N_cl
            hold(ax,'on')
            plot(mean(img(idx1==cl,:),1),'color',clrs(cl,:));
        end
        
        
        % Store the cluster pixels,
        % these will be used to plot the clusters for all frames in the movie.
        
        line(...
            [h.kmeans_ROI{1}(:,1);h.kmeans_ROI{1}(1,1)],...
            [h.kmeans_ROI{1}(:,2);h.kmeans_ROI{1}(1,2)],...
            'parent',dispax,'color',[1 0 0]);
                
        clusterImagePath = sprintf(regexprep(trialStem,{'_Raw_','.mat','_%d'},{'_kmeansCluster_', '','_Block_%d'}),h.params.trialBlock);
        text(10,1000,regexprep(clusterImagePath,'\_','\\_'),'parent',dispax,'fontsize',18,'color',[1 1 1],'verticalAlignment','bottom')
        saveas(displayf,[D,clusterImagePath],'png')
        hold(dispax,'off');
        
        for t_idx = 1:length(trials);
            h = load(sprintf(trialStem,trials(t_idx)));
            trial = h;
            trial.clmask = clmask;
            save(trial.name, '-struct', 'trial')
        end
        
        tr_idx = max(trials)+1;

    else
        error('Down sampled file not available');
    end
    close(plotclusterfig)
end

delete(br);

