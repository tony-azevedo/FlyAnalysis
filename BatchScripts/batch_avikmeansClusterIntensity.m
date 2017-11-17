%% Batch script for thresholding regions of interest for k_means
% for faster kmeans clustering of individual movies

% Assuming I'm in a directory where the movies are to be processed
protocol = 'EpiFlash2T';

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(h.name);

% br = waitbar(0,'Batch');
% br.Position =  [1050    612    270    56];
% 
for tr_idx = 25 %trialnumlist %1:length(data)
    
%     waitbar(tr_idx/length(data),br);
    h = load(sprintf(trialStem,tr_idx));
    fprintf('%s\n',h.name);
    if isfield(h,'excluded') && h.excluded
        fprintf('Trial excluded\n')
        continue
    end
    
    if isfield(h,'badmovie')
        fprintf('\t ** Bad movie, moving on\n');
        continue
    end

    if ~isfield(h,'clmask')
        error('You need to run avi_kmeans first, or batch process')
    end
            
    t = makeInTime(h.params);
    
    t_win = [t(1) t(end)];
    t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];
    
    % import movie
    vid = VideoReader(h.imageFile);
    N = vid.Duration*vid.FrameRate;
        
    kk = 0;
    
    clusters = unique(h.clmask);
    clusters = clusters(clusters~=0);
    I_traces = nan(N,length(clusters));
    
    %     br2 = waitbar(0,regexprep(sprintf(trialStem,h.params.trial),'_','\\_'));
    %     br2.Name = 'Frames';
    %
    
    
    % create a mask for the bar
    % the bar line turns into a rectangle centered on the intersection point
    l = h.forceProbe_line;
    p = h.forceProbe_tangent;
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
    
    barright = barside+repmat(x*h.forceProbeStuff.barmodel(3)*2,2,1);
    barleft = barside+repmat(x*-h.forceProbeStuff.barmodel(3)*2,2,1);
    
    line(barright(:,1)+h.forceProbeStuff.Origin(1),barright(:,2)+h.forceProbeStuff.Origin(2),'parent',dispax,'color',[.7 .7 .7]);
    line(barleft(:,1)+h.forceProbeStuff.Origin(1),barleft(:,2)+h.forceProbeStuff.Origin(2),'parent',dispax,'color',[1 .7 .7]);
    
    bar = [barright;flipud(barleft)];
    barmask = poly2mask(bar(:,1)+h.forceProbeStuff.Origin(1),bar(:,2)+h.forceProbeStuff.Origin(2),size(smooshedframe,1),size(smooshedframe,2));
    
    im = imshow(smooshedframe.*double(abvthresh),[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax); hold(dispax,'on');
    % im = imshow(barmask,[],'parent',dispax);
    barshadow = alphamask(barmask, [1 1 0],.3,dispax);


    while hasFrame(vid)
        kk = kk+1;
        waitbar(kk/N,br2);
        mov3 = double(readFrame(vid));
        mov = mov3(:,:,1);
        for cl = 1:length(clusters)
            I_masked = mov;
            I_cluster = I_masked(h.clmask==cl);            
            I_traces(kk,cl) = mean(I_cluster);
        end
    end
    close(br2)
        
    
    h.clustertraces = I_traces;
    trial = h;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    
    fprintf(1,'Saving %d avi cluster traces for %s %s trial %s\n', ...
        size(I_traces,2),...
        [dateID '_' flynum '_' cellnum], protocol,trialnum);
    
    
    handles.trial = h;
    handles.prtclData = load(dataFile);
    handles.prtclData = handles.prtclData.data;
end

% delete(br);

