%% Batch script for calculating intensity values for clusters.

% Assuming I'm in a directory where the movies are to be processed
trial = load(sprintf(trialStem,trialnumlist(1)));
        
vid = VideoReader(trial.imageFile2);
wh = [vid.Width vid.Height];

clear ax instax

N_Cl_idx = nan(size(trial.clmask,3),1);
for idx = 1:length(N_Cl_idx)
    N_Cl_idx(idx) = length(unique(trial.clmask(:,:,idx)))-1;
end
clmask_N = squeeze(trial.clmask(:,:,N_Cl_idx==N_Cl));

for tr_idx = trialnumlist
    
    trial = load(sprintf(trialStem,tr_idx));
    fprintf('%s\n',trial.name);

    if isfield(trial,'excluded') && trial.excluded
        fprintf('Trial excluded\n')
        continue
    end
    
    if isfield(trial,'badmovie')
        fprintf('\t ** Bad movie, moving on\n');
        continue
    end

    if ~isfield(trial,'clmask')
        error('You need to run avi_kmeans first, or batch process')
    end
%     if isfield(trial,'clustertraces') && ~any(size(trial.clustertraces)==N_Cl)
%         fprintf('\t * already saved traces\n');
%         continue
%     end

                    
    br2 = waitbar(0,regexprep(sprintf(trialStem,trial.params.trial),'_','\\_'));
    br2.Name = 'Frames';
        
    vid = VideoReader(trial.imageFile2); %#ok<TNMLP>
    N = round(vid.Duration*vid.FrameRate);

    abvthresh = clmask_N>0;
    abvthresh1D = abvthresh(:);
    pixels = nan(sum(abvthresh1D>0),N);
    
    kk = 0;
    while hasFrame(vid)
        kk = kk+1;

        waitbar(kk/N,br2); drawnow
        img3 = double(readFrame(vid));
        img = squeeze(img3(:,:,1));  
        
        % nan out the pixels near the bar;
        pixels(:,kk) = img(abvthresh1D);
    end
    close(br2)
    
    h2 = postHocExposure(trial,size(pixels,2));
    t = makeInTime(trial.params);
    t_i = 2*1/vid.FrameRate;
    t_f = trial.params.stimDurInSec-2*1/vid.FrameRate;
    framesidx = t(h2.exposure)>t_i & t(h2.exposure)<t_f;

    pixelmeans = nanmean(pixels(:,framesidx),2);
    pixelstds = nanstd(pixels(:,framesidx),0,2);
    
    pixels_zscores = pixels-repmat(pixelmeans,1,N);
    pixels_zscores = pixels_zscores./repmat(pixelstds,1,N);

    clmask = trial.clmask(:,:,N_Cl_idx==N_Cl);
    clustermask1D = clmask(abvthresh1D);
    clusters = unique(clustermask1D);
    clusters = clusters(clusters~=0);
    I_traces = nan(length(clusters),N);
    
    if ~exist('ax','var')
        plotclusterfig = figure;
        plotclusterfig.Position = [1196 44 560 420];
        ax = subplot(1,1,1);
        hold(ax,'on')
    end

    if ~exist('instax','var')
        
        clusterfig = figure;
        clusterfig.Position = [1196 500 wh];
        clusterfig.ToolBar = 'none';
        instax = axes('parent',clusterfig,'units','pixels','position',[0 0 wh]);
        instax.Box = 'off';
        instax.XTick = [];
        instax.YTick = [];
        instax.Tag = 'instax';
        colormap(instax,'gray')
    end
    
    clrs = parula(length(clusters));
    im = imshow(clmask*0,[0 255],'parent',instax);
    
    cla(ax);
    
    smoothD = round(vid.FrameRate/50);
    for cl = 1:length(clusters)
        hold(ax,'on')
        cl_idx = clustermask1D==cl;
        
        I_cluster = pixels_zscores(cl_idx,:);
        I_traces(cl,:) = smooth(nanmean(I_cluster,1),smoothD);
        I_traces(cl,:) = I_traces(cl,:)*mean(pixelstds(cl_idx))+mean(pixelmeans(cl_idx));
        
        plot(ax,I_traces(cl,:),'color',clrs(cl,:));
        
        alphamask(clmask==cl,clrs(cl,:),1,instax);
    end

    trial.clustertraces = I_traces';
    save(trial.name, '-struct', 'trial');
    
    [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
    fprintf(1,'Saving %d avi cluster traces for %s %s trial %s\n', ...
        size(I_traces,2),...
        [dateID '_' flynum '_' cellnum], protocol,trialnum);
    
end

% delete(br);

