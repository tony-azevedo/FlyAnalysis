%% Batch script for calculating intensity values for clusters.

% Assuming I'm in a directory where the movies are to be processed
trial = load(sprintf(trialStem,trialnumlist(1)));
        
vid2 = VideoReader(trial.imageFile2);
wh = [vid2.Width vid2.Height];

clear ax instax

% create a mask for the bar, if it's there
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

origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
origin = p_';

% Find parameters taking green to IR, use them to go in reverse
cam1v2align = trial.cam1v2alignment;
x_offset = cam1v2align.x_offset;
y_offset = cam1v2align.y_offset;
theta = cam1v2align.theta;
% fprintf('Applying IR to Ca Transform\n');
X_offset = cam1v2align.X_offset;
Y_offset = cam1v2align.Y_offset;
T_cam = [X_offset+x_offset; Y_offset + y_offset];
T_camIR = [x_offset;y_offset];

R_cam = [cosd(-theta) -sind(-theta);
    sind(-theta) cosd(-theta)];

% rotate x, origin and bar side
x = (R_cam*x_hat)';
barside = (R_cam*barside')';
origin = R_cam*origin;

% Get an estimate of the bar width
barmodel = trial.forceProbeStuff.barmodel - min(trial.forceProbeStuff.barmodel);
barwidth = [find(barmodel>(max(barmodel)/2),1,'first') find(barmodel>(max(barmodel)/2),1,'last')];
barwidthFWHM = diff(barwidth);

% The bar side should be in the coordinates of the green image
barright = barside+repmat(x*barwidthFWHM*2/3,2,1);
barleft = barside+repmat(x*-barwidthFWHM*2/3,2,1);

% Now transform initial barpoint
bar_i = R_cam * (trial.forceProbeStuff.forceProbePosition(:,1)) + origin - T_camIR;

bar = [barright;flipud(barleft)];

origin_green = origin - T_cam;
bar_i_green = R_cam * (trial.forceProbeStuff.forceProbePosition(:,1)) + origin_green;
barmask = poly2mask(bar(:,1)+origin_green(1),bar(:,2)+origin_green(2),wh(2),wh(1));

%% open the video and create a matrix for the pixels in ROI X total frames
N = vid2.Duration*vid2.FrameRate;
h2 = postHocExposure2(trial,N);
t = makeInTime(trial.params);

t_i = 0.05 + trial.params.preDurInSec; % give it 50 ms after light turns on
t_f = trial.params.stimDurInSec + trial.params.preDurInSec;

ft = t(h2.exposure2);
% ft = ft(ft>t_i-trial.params.preDurInSec & ft<t_f-trial.params.preDurInSec);

N_bar = length(trial.forceProbeStuff.CoM);
h1 = postHocExposure(trial,N_bar);
ft_bar = t(h1.exposure);
% ft_bar = ft_bar(ft_bar>t_i-trial.params.preDurInSec & ft_bar<t_f-trial.params.preDurInSec);

fctr = vid2.FrameRate/50; % pretend you're sampling at 50 hz;
N = floor(length(ft)/fctr); % average over enough frames to make it 50 Hz 

%%

N_Cl_idx = nan(size(trial.clmask,3),1);
for idx = 1:length(N_Cl_idx)
    N_Cl_idx(idx) = length(unique(trial.clmask(:,:,idx)))-1;
end
clmask_N = squeeze(trial.clmask(:,:,N_Cl_idx==N_Cl));

%%

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
%     if isfield(trial,'clustertraces')
%         fprintf('\t * already saved traces\n');
%         continue
%     end

                    
    br2 = waitbar(0,regexprep(sprintf(trialStem,trial.params.trial),'_','\\_'));
    br2.Name = 'Frames';
        
    vid2 = VideoReader(trial.imageFile2);
    N = round(vid2.Duration*vid2.FrameRate);

    abvthresh = clmask_N>0;
    abvthresh1D = abvthresh(:);
    pixels = nan(sum(abvthresh1D>0),N);
    
    frmcnt = 0;
    while hasFrame(vid2)
        frmcnt = frmcnt+1;

        waitbar(frmcnt/N,br2); drawnow
        img3 = double(readFrame(vid2));
        frm = img3(:,:,1);  
        
        % nan out the pixels near the bar;
        
        [~,bar_frm] = min(abs(ft_bar-ft(frmcnt)));
        % nan out the pixels near the bar;
        bar_i_green = R_cam * (trial.forceProbeStuff.forceProbePosition(:,bar_frm)) + origin_green;
        barmask = poly2mask(...
            bar(:,1)+bar_i_green(1),...
            bar(:,2)+bar_i_green(2),...
            wh(2),...
            wh(1));
        frm(~abvthresh|barmask) = nan;        
        pixels(:,frmcnt) = frm(abvthresh1D);
    end
    close(br2)
    
    t_i = 2*1/vid2.FrameRate;
    t_f = trial.params.stimDurInSec-2*1/vid2.FrameRate;
    framesidx = ft>t_i & ft<t_f;

    pixelmeans = nanmean(pixels(:,framesidx),2);
    pixelstds = nanstd(pixels(:,framesidx),0,2);
    
    pixels_zscores = pixels-repmat(pixelmeans,1,N);
    pixels_zscores = pixels_zscores./repmat(pixelstds,1,N);

    clustermask1D = clmask_N(abvthresh1D);
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
    
    
    im = imshow(clmask_N*0,[0 255],'parent',instax);

    clrs = parula(length(clusters));
    clmask = clmask_N;
    cla(ax);
    for cl = 1:length(clusters)
        hold(ax,'on')
        cl_idx = clustermask1D==cl;
        
        I_cluster = pixels_zscores(cl_idx,:);
        I_traces(cl,:) = nanmean(I_cluster,1);
        I_traces(cl,:) = I_traces(cl,:)*mean(pixelstds(cl_idx))+mean(pixelmeans(cl_idx));
        
        % nan out any time points where > 40% of pixels are nans
        N_nanpixels = sum(isnan(pixels_zscores(cl_idx,:)),1);
        N_pixels = sum(cl_idx);
        I_traces(cl,N_nanpixels ./ N_pixels > .4) = nan;
        
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

