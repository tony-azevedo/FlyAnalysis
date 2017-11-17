%% Batch script for thresholding regions of interest for k_means
% for faster kmeans clustering of individual movies

% Assuming I'm in a directory where the movies are to be processed

close all;
displayf = figure;
displayf.Position = [40 40 1280 1024];
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';    

for tr_idx = trialnumlist %1:length(data)
    
%     waitbar(tr_idx/length(data),br);
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
    if isfield(trial,'clustertraces')
        fprintf('\t * already saved traces\n');
        continue
    end

                    
    br2 = waitbar(0,regexprep(sprintf(trialStem,trial.params.trial),'_','\\_'));
    br2.Name = 'Frames';
        
    vid = VideoReader(trial.imageFile);
    N = vid.Duration*vid.FrameRate;
    for cnt = 1:5
        frame = readFrame(vid);
    end
    frame = squeeze(frame(:,:,1));
    startAt0 = false;
    if sum(frame(:)>10) < numel(frame)/1000
        startAt0 = true;
    end
    
    h2 = postHocExposure(trial,N);
    t = makeInTime(trial.params);
    t_i = 5*1/vid.FrameRate;
    if ~startAt0
        t_i = trial.params.preDurInSec+t_i;
    end
    t_f = trial.params.stimDurInSec-5*1/vid.FrameRate;
    frames = find(t(h2.exposure)>t_i & t(h2.exposure)<t_f);
    
    kk = 0;
    while kk<frames(1)
        kk = kk+1;
        
        readFrame(vid);
        continue
    end
    
    smooshedframe = double(readFrame(vid));
    smooshedframe = squeeze(smooshedframe(:,:,1));
    smooshedframe(:) = 0;
    readFrame(vid); readFrame(vid);
    
    for jj = 1:4
        mov3 = double(readFrame(vid));
        smooshedframe = smooshedframe+mov3(:,:,1);
    end
    for jj = 1:20
        mov3 = double(readFrame(vid));
        smooshedframe = smooshedframe+mov3(:,:,1);
    end
    smooshedframe = smooshedframe/24;

    % creat a mask for the pixels above threshold
    mask_ = poly2mask(trial.kmeans_ROI{1}(:,1),trial.kmeans_ROI{1}(:,2),size(smooshedframe,1),size(smooshedframe,2));
    abvthresh = smooshedframe<=trial.kmeans_threshold & mask_;
    abvthresh = imgaussfilt(double(abvthresh),3);
    abvthresh = abvthresh>.1;
    abvthresh = ~abvthresh&mask_;
    abvthresh1D = abvthresh(:);
    
    % create a mask for the bar
    % the bar line turns into a rectangle centered on the intersection point
    l = trial.forceProbe_line;
    p = trial.forceProbe_tangent;
    l_0 = l - repmat(mean(l,1),2,1);
    p_0 = p - mean(l,1);
    
    % for my purposes, get the line equation (m,b)
    m = diff(l(:,2))/diff(l(:,1));
    b = l(1,2)-m*l(1,1);
    
    % find y vector
    barbar = l_0(2,:)/norm(l_0(2,:));
    barside = [barbar*norm(l_0(2,:));barbar*-norm(l_0(2,:))];
    
    % project tangent point
    p_scalar = barbar*p_0';
    
    % find intercept, recenter
    p_ = p_scalar*barbar+mean(l,1);
    
    % rotate coordinates
    R = [cos(pi/2) -sin(pi/2);
        sin(pi/2) cos(pi/2)];
    l_r = (R*l_0')'/4;
    upperright_ind = find(l_r(:,1)>l_r(:,2));
    x = l_r(upperright_ind,:)/norm(l_r(upperright_ind,:));
    l_r = l_r + repmat(p_,2,1);
    
    barright = barside+repmat(x*trial.forceProbeStuff.barmodel(3)*2,2,1);
    barleft = barside+repmat(x*-trial.forceProbeStuff.barmodel(3)*2,2,1);
    
    line(barright(:,1)+trial.forceProbeStuff.Origin(1),barright(:,2)+trial.forceProbeStuff.Origin(2),'parent',dispax,'color',[.7 .7 .7]);
    line(barleft(:,1)+trial.forceProbeStuff.Origin(1),barleft(:,2)+trial.forceProbeStuff.Origin(2),'parent',dispax,'color',[1 .7 .7]);
    
    bar = [barright;flipud(barleft)];
    barmask = poly2mask(bar(:,1)+trial.forceProbeStuff.Origin(1),bar(:,2)+trial.forceProbeStuff.Origin(2),size(smooshedframe,1),size(smooshedframe,2));
    
    im = imshow(smooshedframe.*double(abvthresh),[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax); hold(dispax,'on');
    % im = imshow(barmask,[],'parent',dispax);
    barshadow = alphamask(barmask, [1 1 0],.3,dispax);

    % open the video and creat a matrix for the pixels in ROI X total frames    
    vid = VideoReader(trial.imageFile);
    N = vid.Duration*vid.FrameRate;

    kk = 0;

    pixels = nan(sum(abvthresh1D),N);

    while hasFrame(vid)
        kk = kk+1;

        waitbar(kk/N,br2);
        img3 = double(readFrame(vid));
        img = img3(:,:,1);  
        
        % nan out the pixels near the bar;
        if ~any(isnan(trial.forceProbeStuff.forceProbePosition(1,kk)))
            barmask = poly2mask(...
                bar(:,1)+trial.forceProbeStuff.Origin(1)+trial.forceProbeStuff.forceProbePosition(1,kk),...
                bar(:,2)+trial.forceProbeStuff.Origin(2)+trial.forceProbeStuff.forceProbePosition(2,kk),...
                size(smooshedframe,1),size(smooshedframe,2));
            img(~abvthresh|barmask) = nan;
            im.CData = img;
            barshadow.CData(:,:,1) = barmask;
        end
        pixels(:,kk) = img(abvthresh1D);

    end
    close(br2)
    
    h2 = postHocExposure(trial,N);
    t = makeInTime(trial.params);
    t_i = 2*1/vid.FrameRate;
    t_f = trial.params.stimDurInSec-2*1/vid.FrameRate;
    framesidx = t(h2.exposure)>t_i & t(h2.exposure)<t_f;
    
    pixelmeans = nanmean(pixels(:,framesidx),2);
    pixelstds = nanstd(pixels(:,framesidx),0,2);
    
    pixels_zscores = pixels-repmat(pixelmeans,1,N);
    pixels_zscores = pixels_zscores./repmat(pixelstds,1,N);
        
    plotclusterfig = figure;
    plotclusterfig.Position = [1196 44 560 420];
    ax = subplot(1,1,1);
    plot(any(isnan(pixels_zscores),1))
    hold(ax,'on')

    clustermask1D = trial.clmask(abvthresh1D);
    clusters = unique(clustermask1D);
    clusters = clusters(clusters~=0);
    I_traces = nan(length(clusters),N);
    
    clrs = [
    0       1       1           %c
    1       0.3     0.945       %m
    .43      0.5     1           %b
    0.2     1.00    0.2         %g
    1       1       0.2           %y
    ];


    for cl = 1:length(clusters)
        hold(ax,'on')
        cl_idx = clustermask1D==cl;
        %plot(nanmean(pixels_zscores(cl_idx==cl,:),1),'color',clrs(cl,:));
        
        
        I_cluster = pixels_zscores(cl_idx,:);
        I_traces(cl,:) = nanmean(I_cluster,1);
        I_traces(cl,:) = I_traces(cl,:)*mean(pixelstds(cl_idx))+mean(pixelmeans(cl_idx));
        
        plot(I_traces(cl,:),'color',clrs(cl,:));
    end

    trial.clustertraces = I_traces;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    
    [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
    fprintf(1,'Saving %d avi cluster traces for %s %s trial %s\n', ...
        size(I_traces,2),...
        [dateID '_' flynum '_' cellnum], protocol,trialnum);
    
end

% delete(br);

