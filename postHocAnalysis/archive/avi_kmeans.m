function h = avi_kmeans(h,varargin)
% Goal of this function is to find a mask for the original video that will
% segment the video into constituent clusters.

% Has the data been batch processed?
persistent batchprocessed
if isfield(h,'kmeans_ROI') && isfield(h,'kmeans_threshold') && ~isempty(batchprocessed) && batchprocessed

elseif isfield(h,'kmeans_ROI') && isfield(h,'kmeans_threshold') && (isempty(batchprocessed) || batchprocessed)
    button = questdlg('Kmeans has been run, possibly batched. Redo clusters?','Batched?','No');
    switch button
        case 'No'
            batchprocessed = 1;
        case 'Yes' 
            batchprocessed = 0;
        otherwise
    end
    
else
    batchprocessed = 0;
end


[protocol,dateID,flynum,cellnum,trialnum,D] = extractRawIdentifiers(h.name);
figpath = [D 'figs']; 
if ~exist(figpath,'dir')
    mkdir(figpath)
end
set(0, 'DefaultAxesFontName', 'Arial');

% look for movie file
checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(h.params.trial) '_' datestr(h.timestamp,29) '*.avi']));

if ~length(checkdir)
    moviename = [regexprep(h.name, {'Acquisition','_Raw_'},{'Raw_Data','_Images_'}) '.avi'];
    foldername = regexprep(moviename, '.mat.avi','\');
    moviename = dir([foldername protocol '_Image_*']);
    moviename = [foldername moviename(1).name];
    fprintf(1,'Looking for a folder named %s\n',foldername);
else
    moviename = checkdir(1).name;
end
filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];

t = makeInTime(h.params);

t_win = [t(1) t(end)];
t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];

% import movie
vid = VideoReader(moviename);
N = vid.Duration*vid.FrameRate;
h2 = postHocExposure(h,N);


%% Reduce the amount of data, 
% collapse the pixels into bins ~100 ms apart, and take only pixels crossing
% threshold. Save the reduced data temporarily in a new folder. This is so
% that I can batch run the data compression step and then quickly load in
% a compressed file and run the k_means clustering on that.

D_shortened = [D 'compressed' filesep];
if ~exist(D_shortened,'dir')
    mkdir(D_shortened)
end
downsampledDataPath = regexprep(h.name,regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
if exist(downsampledDataPath ,'file')
    tic
    trial = load(downsampledDataPath); % ~1 sec
    toc
else
    
    kk = 0;
    
    % find the first frame
    k0 = find(t(h2.exposure)>0,3,'first');
    k0 = k0(end);
    
    % find the last frame
    kf = find(t(h2.exposure)<=h.params.stimDurInSec,1,'last');
    % Delta frames is enough to make 10 ms;
    Dframes = floor(vid.FrameRate/10);
    % Frame_bins is the minimum frames
    Frame_bins = floor((sum(t(h2.exposure)>0&t(h2.exposure)<=h.params.stimDurInSec)-3)/Dframes);
    
    br = waitbar(0,'Frames');
    while hasFrame(vid)
        kk = kk+1;
        
        if kk<k0
            readFrame(vid);
            continue
        elseif kk>kf
            break
        end
        
        % Now that I've reached time 0;
        
        % read the first frame (unlikely to be very good, can throw it out)
        mov3 = readFrame(vid);
        % create a local matrix and a matrix of bins
        mov_bin = nan(size(mov3,1),size(mov3,2),Dframes);
        trial.downsampledImage = nan(size(mov3,1),size(mov3,2),Frame_bins);
        
        % start at the first bin
        frame_bin = 0;
        while frame_bin<Frame_bins
            frame_bin = frame_bin+1;
            waitbar(frame_bin/Frame_bins,br);
            
            % get X bins and average
            for jj = 1:Dframes
                mov3 = readFrame(vid);
                mov_bin(:,:,jj) = mov3(:,:,1);
            end
            trial.downsampledImage(:,:,frame_bin) = mean(mov_bin,3);
        end
        
        break
    end
    tic
    br.Children.Title.String = 'Saving';
    save(downsampledDataPath, '-struct', 'trial') % ~12 sec
    close(br)    
    toc
end


%% Set an ROI that avoids the trace of the probe
% I think I only need 1 for now, but I'll keep the option for multiple

displayf = figure;
set(displayf,'position',[100 10 1280 1024]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

smooshedframe = mean(trial.downsampledImage,3);
scale = [quantile(smooshedframe(:),0.75) 2*quantile(smooshedframe(:),0.975)];
% im = imshow(smooshedframe,scale,'parent',dispax);
im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);

hold(dispax,'on');

if ~batchprocessed
    if isfield(h,'kmeans_ROI')
        for roi_ind = 1:length(h.kmeans_ROI)
            line(...
                [h.kmeans_ROI{roi_ind}(:,1);h.kmeans_ROI{roi_ind}(1,1)],...
                [h.kmeans_ROI{roi_ind}(:,2);h.kmeans_ROI{roi_ind}(1,2)],...
                'parent',dispax,'color',[1 0 0]);
        end
        if ~batchprocessed
            button = questdlg('Make new ROI?','ROI','No');
        else
            button = 'No';
        end
    else
        temp.ROI = getpref('quickshowPrefs','avi_kmeans_roi');
        for roi_ind = 1:length(temp.ROI)
            line(...
                [temp.ROI{roi_ind}(:,1);temp.ROI{roi_ind}(1,1)],...
                [temp.ROI{roi_ind}(:,2);temp.ROI{roi_ind}(1,2)],...
                'parent',dispax,'color',[1 0 0]);
        end
        button = questdlg('Make new ROI?','ROI','No');
        if strcmp(button,'No');
            h.kmeans_ROI = temp.ROI;
        end
    end
    if strcmp(button,'Yes');
        h.kmeans_ROI = {};
        roihand = impoly(dispax,'Closed',1);
        roi_temp = wait(roihand);
        h.kmeans_ROI{1} = roi_temp;
        
        % Only need 1? Comment out the code below
        %     while ishandle(displayf) && sum(roi_temp(3:end)>2)
        %         roihand = impoly(dispax,'Closed',1);
        %         roi_temp = wait(roihand);
        %         if size(roi_temp,1)<=2
        %             break
        %         end
        %         h.kmeans_ROI{end+1} = roi_temp;
        %     end
        setpref('quickshowPrefs','avi_kmeans_roi',h.kmeans_ROI)
        
    elseif strcmp(button,'No');
    elseif strcmp(button,'Cancel');
        return
    end
end
for roi_ind = 1:length(h.kmeans_ROI)
    mask{roi_ind} = poly2mask(h.kmeans_ROI{roi_ind}(:,1),h.kmeans_ROI{roi_ind}(:,2),size(smooshedframe,1),size(smooshedframe,2));
end
    
    
    %% Set a threshold for pixel values for the mean
if ~batchprocessed
    if isfield(h,'kmeans_threshold')
        % Set based on kmeans_threshold
        blwthresh = smooshedframe<h.kmeans_threshold & mask{1};
        blwthresh = smoothThreshold(blwthresh);
        hOVM = alphamask(blwthresh, [0 0 1],.1,dispax);
        
        if ~batchprocessed
            button = questdlg('Change threshold?','Threshold','No');
        else
            button = 'No';
        end
    else
        temp.threshold = getpref('quickshowPrefs','avi_kmeans_thresh');
        % Set scale on the threshold
        blwthresh = smooshedframe<temp.threshold & mask{1};
        blwthresh = smoothThreshold(blwthresh);

        hOVM = alphamask(blwthresh, [0 0 1],.1,dispax);
        
        button = questdlg('Change threshold?','Threshold','No');
        h.kmeans_threshold = temp.threshold;
    end
    
    if strcmp(button,'Yes');
        threshcontrolfigure = figure;
        set(threshcontrolfigure,'position',[1433 564 133 420],'menu','none')
        sldr = uicontrol('Style','slider','parent',threshcontrolfigure);
        edtr = uicontrol('Style','edit','parent',threshcontrolfigure);
        sldr.Position = [20 20 20 380];
        edtr.Position = [60 380 60 20];
        edtr.Value = h.kmeans_threshold;
        edtr.String = num2str(edtr.Value);
        
        sldr.Max = 2*quantile(smooshedframe(:),0.975);
        sldr.Min = 0;
        sldr.Value = h.kmeans_threshold;
        
        sldr.Callback = @updateThreshold;
        edtr.Callback = @updateThreshold;
        uiwait(threshcontrolfigure)
        
        abvthresh = ~blwthresh;
        setpref('quickshowPrefs','avi_kmeans_thresh',h.kmeans_threshold)
        
        hold(dispax,'off');
        im = imshow(smooshedframe.*abvthresh,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);
        
    elseif strcmp(button,'No');
    elseif strcmp(button,'Cancel');
        return
    end
    
    im.Parent.CLim(1) = h.kmeans_threshold; drawnow    
    delete(hOVM);
end

abvthresh = ~blwthresh & mask{1};


% Callback function
    function updateThreshold(src,evnt)
        if strcmp(src.Style,'edit')
            src.Value = str2double(src.String);
        end
        h.kmeans_threshold = src.Value;
        sldr.Value = src.Value;
        edtr.Value = src.Value;
        edtr.String = num2str(edtr.Value);
        delete(hOVM);
        blwthresh = smooshedframe<h.kmeans_threshold & mask{1};
        blwthresh = smoothThreshold(blwthresh);

        hold(dispax,'on');

        hOVM = alphamask(blwthresh, [0 0 1],.3,dispax);
    end

    function out = smoothThreshold(in)
        out = imgaussfilt(double(in),3);
        out = out>.9;
    end

%% Now use the thresholded image to creat clusters.

% img = nan(size(trial.downsampledImage));
img = reshape(trial.downsampledImage,numel(abvthresh),size(trial.downsampledImage,3))-repmat(smooshedframe(:),1,size(trial.downsampledImage,3));
img = img(abvthresh(:),:);

N_cl = 4;

[idx1,C1]=kmeans(img,N_cl,'Distance','correlation','Replicates',4);

clmask = zeros(size(smooshedframe));
clmask(abvthresh) = idx1;

plotclusterfig = figure;
set(plotclusterfig,'Position',[1196 44 560 420]);

ls = cell(N_cl,1);
clrs = parula(N_cl);

for cl = 1:N_cl
    hold on
    ls{cl} = plot(mean(img(idx1==cl,:),1),'color',clrs(cl,:));
end

for cl = 1:N_cl
    hold(dispax,'on')
    alphamask(clmask==cl,ls{cl}.Color,.1,dispax);
end

%% Then watershed the k_means clusters
% Actually, the 4 clusters is working really well at the moment, such that
% one of the clusters is fairly flat
for cl = 1:N_cl
    currcl = clmask==cl;
    currcl = imgaussfilt(double(currcl),3);
    currcl = currcl>.9;
    alphamask(currcl,ls{cl}.Color,.5,dispax);
    
    clmask(clmask==cl) = 0;
    clmask(currcl) = cl;
end

%% Store the cluster pixels, 
% these will be used to plot the clusters for all frames in the movie.

line(...
    [h.kmeans_ROI{1}(:,1);h.kmeans_ROI{1}(1,1)],...
    [h.kmeans_ROI{1}(:,2);h.kmeans_ROI{1}(1,2)],...
    'parent',dispax,'color',[1 0 0]);

pause(1)

clusterImagePath = regexprep(h.name,{'_Raw_','.mat'},{'_kmeansCluster_', ''});
saveas(displayf,clusterImagePath,'png')
close(displayf)

trial = h;
trial.clmask = clmask;
save(trial.name, '-struct', 'trial') 

close(plotclusterfig)

end
