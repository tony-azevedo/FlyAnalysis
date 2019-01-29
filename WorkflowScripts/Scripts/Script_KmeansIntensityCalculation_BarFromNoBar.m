%% Batch script for calculating intensity values for clusters.

% Assuming I'm in a directory where the movies are to be processed
trial = load(sprintf(trialStem,bartrials{1}(1)));
        
%% First, get a transformation from IR to Ca imaging.
wh = size(trial.clmask);
wh = wh(1:2);

displayf = figure;
displayf.Position = [40 40 fliplr(wh)];
displayf.ToolBar = 'none';
dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(wh)]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

if length(size(trial.clmask))>2
    N_Cl_idx = nan(size(trial.clmask,3),1);
    for idx = 1:length(N_Cl_idx)
        N_Cl_idx(idx) = length(unique(trial.clmask(:,:,idx)))-1;
    end
    clmask = squeeze(trial.clmask(:,:,N_Cl_idx==min(size(trial.clustertraces))));
else
    clmask = trial.clmask;
end

clrs = parula(size(trial.clustertraces,2)+1);
clrs = clrs(1:end-1,:);

imshow(clmask*0,[0 255],'parent',dispax);
for cl = 1:size(trial.clustertraces,2)
    alphamask(clmask==cl,clrs(cl,:),.5,dispax);
end

if length(size(nobartrial.clmask))>2
    N_Cl_idx = nan(size(nobartrial.clmask,3),1);
    for idx = 1:length(N_Cl_idx)
        N_Cl_idx(idx) = length(unique(nobartrial.clmask(:,:,idx)))-1;
    end
    clmask_nobar = squeeze(nobartrial.clmask(:,:,N_Cl_idx==min(size(nobartrial.clustertraces))));
else
    clmask_nobar = nobartrial.clmask;
end

green = clmask_nobar>0;
wh_Green = size(green);
a = alphamask(green>0,[0, 1 0],.5);
mask = green;


X_offset = 0;
Y_offset = 0;
x_offset = 0;
y_offset = 0;
theta = 0;

txt = text(10,10,'coords');
txt.Color = [1 1 1];

%%
while 1
    keydown = waitforbuttonpress;
    while keydown==0 || ~any(strcmp({' ','j','J','k','K','i','I','l','L','e','E','r','R'},displayf.CurrentCharacter))
        %disp(displayf.CurrentCharacter);
        keydown = waitforbuttonpress;
    end
    cmd_key = displayf.CurrentCharacter;
    
    switch cmd_key
        case ' '
            fprintf('Done\n');
            break
        case 'j'
            x_offset = x_offset - .5;
        case 'J'
            x_offset = x_offset - 5;
        case 'k'
            y_offset = y_offset + .5;
        case 'K'
            y_offset = y_offset + 5;
        case 'i'
            y_offset = y_offset - .5;
        case 'I'
            y_offset = y_offset - 5;
        case 'l'
            x_offset = x_offset + .5;
        case 'L'
            x_offset = x_offset + 5;
        case 'e'
            theta = theta+.5;
        case 'E'
            theta = theta+2;
        case 'r'
            theta = theta-.5;
        case 'R'
            theta = theta-2;
        otherwise
    end
    green_1 = imrotate(green,theta,'bilinear','crop');
    green_1 = imtranslate(green_1,[x_offset y_offset],'linear','outputview','same','fillvalue',0);
    mask(Y_offset+1:min([Y_offset+ wh_Green(1),wh(1)]),X_offset+1:min([X_offset+ wh_Green(2),wh(2)])) = green_1;
    a.CData(:,:,2) = mask;
    a.AlphaData = mask*.5;
    txt.String = sprintf('{x = %.1f, y = %.1f, theta = %.1f',x_offset,y_offset,theta);
    drawnow;
end

roi_ind = 1;
roimask = poly2mask(trial.kmeans_ROI{roi_ind}(:,1),trial.kmeans_ROI{roi_ind}(:,2),wh(1),wh(2));

clmask_nobar_l = imrotate(clmask_nobar,theta,'bilinear','crop');
clmask_nobar_l = imtranslate(clmask_nobar_l,[x_offset y_offset],'linear','outputview','same','fillvalue',0);

clmask_nobar_l(clmask_nobar_l~=round(clmask_nobar_l)) = 0;

% rotating and translating tends to distort the view a little, now get rid
% of non-integers
CaClMaskFromNonBarTrials = double(roimask) .*  clmask_nobar_l;
trial.clmaskFromNonBarTrials = CaClMaskFromNonBarTrials;

a.CData(:,:,2) = trial.clmaskFromNonBarTrials>0;
a.AlphaData = (trial.clmaskFromNonBarTrials>0)*.5;
drawnow

nobarVsBarAlignment.X_offset = 0;
nobarVsBarAlignment.Y_offset = 0;
nobarVsBarAlignment.x_offset = x_offset;
nobarVsBarAlignment.y_offset = y_offset;
nobarVsBarAlignment.theta = theta;


%%

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

clmask_N = trial.clmaskFromNonBarTrials;

%%
for setidx = 1:length(bartrials)
    trialnumlist = bartrials{setidx};
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
        cl = 0;
        for cluster = clusters(:)'
            cl = cl+1;
            hold(ax,'on')
            cl_idx = clustermask1D==cluster;
            
            I_cluster = pixels_zscores(cl_idx,:);
            I_traces(cl,:) = nanmean(I_cluster,1);
            I_traces(cl,:) = I_traces(cl,:)*mean(pixelstds(cl_idx))+mean(pixelmeans(cl_idx));
            
            % nan out any time points where > 40% of pixels are nans
            N_nanpixels = sum(isnan(pixels_zscores(cl_idx,:)),1);
            N_pixels = sum(cl_idx);
            I_traces(cl,N_nanpixels ./ N_pixels > .4) = nan;
            
            plot(ax,I_traces(cl,:),'color',clrs(cl,:));
            
            alphamask(clmask==cluster,clrs(cl,:),1,instax);
        end
        
        trial.clmaskFromNonBarTrials = clmask_N;
        trial.clustertraces_NBCls = I_traces';
        trial.nobarVsBarAlignment = nobarVsBarAlignment;
        save(trial.name, '-struct', 'trial');
        
        [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
        fprintf(1,'Saving %d avi cluster traces for %s %s trial %s\n', ...
            size(I_traces,2),...
            [dateID '_' flynum '_' cellnum], protocol,trialnum);
        
    end
end

% delete(br);

