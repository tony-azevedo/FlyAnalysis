%% Batch script for thresholding regions of interest for k_means
% But only for trials I've closely looked and that are similar (ie same
% imaging field and length)

% Assuming I'm in a directory where the movies are to be processed
    
% get rid of the excluded trials (should have already done this)
trial = load(sprintf(trialStem,trialnumlist(1)));

if isfield(trial,'clmask')
    fprintf('clmask already run\n');
    %return
end

excluded = zeros(size(trialnumlist));
for tr_idx = 1:length(trialnumlist)
    ex = load(sprintf(trialStem,trialnumlist(tr_idx)),'excluded');
    if isfield(ex,'excluded') && ex.excluded
        excluded(tr_idx) = 1;
    end
end
trialnumlist = trialnumlist(~excluded);
        
trial = load(sprintf(trialStem,trialnumlist(1)));
if ~isfield(trial,'forceProbeStuff')
    error('No model of the bar, this script is not for you!\n')
end

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

%%
% vid2 = VideoReader(trial.imageFile2);
vid2 = VideoReader(trial.imageFile);
t_i = 0.05 + trial.params.preDurInSec; % give it 50 ms after light turns on
t_f = [trial.params.stimDurInSec-5*1/vid2.FrameRate];

vid2.CurrentTime = t_i;
cnt = 1;
frame3 = readFrame(vid2);
frame = double(squeeze(frame3(:,:,1)));
while vid2.CurrentTime<t_f
    cnt = cnt+1;
    frame3 = readFrame(vid2);
    frame = frame+double(squeeze(frame3(:,:,1)));
    if ~mod(cnt,10)
        fprintf('.')
    end
end
fprintf('\n')

smooshedframe_Green = frame./cnt;
wh_Green = size(smooshedframe_Green);

green = (smooshedframe_Green-min(smooshedframe_Green))./max(smooshedframe_Green)>.45;
% green = smooshedframe_Green/max(smooshedframe_Green(:))>.33;


%%
vid = VideoReader(trial.imageFile);
t_i = 0.05 + trial.params.preDurInSec; % give it 50 ms after light turns on
t_f = [trial.params.stimDurInSec-5*1/vid.FrameRate];

vid.CurrentTime = t_i;
cnt = 1;
frame3 = readFrame(vid);
frame = double(squeeze(frame3(:,:,1)));
while vid.CurrentTime<t_f
    cnt = cnt+1;
    frame3 = readFrame(vid);
    frame = frame+double(squeeze(frame3(:,:,1)));
    if ~mod(cnt,10)
        fprintf('.')
    end
end
fprintf('\n')

smooshedframe_IR = frame./cnt;

mask = smooshedframe_IR*0;

wh = size(smooshedframe_IR);

%%
displayf = figure;
displayf.Position = [40 40 fliplr(wh)];
displayf.ToolBar = 'none';
dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(wh)]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

colormap(dispax,'gray')
%im = imshow(smooshedframe,[2 8],'parent',dispax);
im = imshow(smooshedframe_IR,[0 2*quantile(smooshedframe_IR(:),0.975)],'parent',dispax);

% im = imshow(smooshedframe_Green,[0 2*quantile(smooshedframe_Green(:),0.975)],'parent',dispax);

% X_offset = 640;
% Y_offset = 0;
% x_offset = getacqpref('FlyAnalysis','CaImgCam2X_Offset');
% y_offset = getacqpref('FlyAnalysis','CaImgCam2Y_Offset');
% theta = getacqpref('FlyAnalysis','CaImgCam2Rotation');

% mask(Y_offset+1:min([Y_offset+ wh_Green(1),wh(1)]),X_offset+1:min([X_offset+ wh_Green(2),wh(2)])) = green;
% green_1 = green;
% 
% a = alphamask(mask,[0 1 0],.5,dispax);
% drawnow
% pause(.5);

% IR_1 = imrotate(smooshedframe_IR,-theta,'bilinear','crop');
% IR_1 = imtranslate(IR_1,[-x_offset -y_offset],'linear','outputview','same','fillvalue',0);
% im.CData = IR_1;
% mask(Y_offset+1:min([Y_offset+ wh_Green(1),wh(1)]),X_offset+1:min([X_offset+ wh_Green(2),wh(2)])) = green_1;
% a.CData(:,:,2) = mask;
% a.AlphaData = mask*.5;

% txt = text(dispax,size(mask,2)/3,20,'Space bar to continue');
% txt.Position = [20 10 0]*size(mask,2)/640;
% txt.VerticalAlignment = 'top';
% txt.Color = [1 1 1];
% txt.FontSize = 18;
% txt.FontName = 'Ariel';
% 
% drawnow;

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
% cam1v2align = trial.cam1v2alignment;
% x_offset = cam1v2align.x_offset;
% y_offset = cam1v2align.y_offset;
% theta = cam1v2align.theta;
% % fprintf('Applying IR to Ca Transform\n');
% X_offset = cam1v2align.X_offset;
% Y_offset = cam1v2align.Y_offset;
% T_cam = [X_offset+x_offset; Y_offset + y_offset];
% T_camIR = [x_offset;y_offset];
T_cam = [0; 0];
T_camIR = [0;0];

% R_cam = [cosd(-theta) -sind(-theta);
%     sind(-theta) cosd(-theta)];
R_cam = [1 0;
   0 1];


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
line(bar_i(1),bar_i(2),'parent',dispax,'marker','o','color',[0 1 0]);

line(barright(:,1)+bar_i(1),barright(:,2)+bar_i(2),'parent',dispax,'color',[.7 .7 .7]);
line(barleft(:,1)+bar_i(1),barleft(:,2)+bar_i(2),'parent',dispax,'color',[.7 .7 .7]);

bar = [barright;flipud(barleft)];

origin_green = origin - T_cam;
bar_i_green = R_cam * (trial.forceProbeStuff.forceProbePosition(:,1)) + origin_green;
barmask = poly2mask(bar(:,1)+origin_green(1),bar(:,2)+origin_green(2),size(smooshedframe_Green,1),size(smooshedframe_Green,2));

displayf = figure;
displayf.Position = [40 40 fliplr(wh_Green)];
displayf.ToolBar = 'none';
dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(wh_Green)]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

im = imshow(smooshedframe_Green,[3 30],'parent',dispax);
barshadow = alphamask(barmask, [1 1 0],.3,dispax);

% create a mask for the pixels above threshold
mask_ = poly2mask(trial.kmeans_ROI{1}(:,1),trial.kmeans_ROI{1}(:,2),size(smooshedframe_Green,1),size(smooshedframe_Green,2));
abvthresh = smooshedframe_Green<=trial.kmeans_threshold & mask_;
abvthresh = imgaussfilt(double(abvthresh),3);
abvthresh = abvthresh>.1;
abvthresh = ~abvthresh&mask_;
abvthresh1D = abvthresh(:);

hOVM = alphamask(abvthresh, [0 0 1],.1,dispax);

%% open the video and create a matrix for the pixels in ROI X total frames
N = vid2.Duration*vid2.FrameRate;
h2 = postHocExposure(trial,N);
t = makeInTime(trial.params);

t_i = 0.05 + trial.params.preDurInSec; % give it 50 ms after light turns on
t_f = trial.params.stimDurInSec + trial.params.preDurInSec;

ft = t(h2.exposure);
ft = ft(ft>t_i-trial.params.preDurInSec & ft<t_f-trial.params.preDurInSec);

N_bar = vid.Duration*vid.FrameRate;
h1 = postHocExposure(trial,N_bar);
ft_bar = t(h1.exposure);
% ft_bar = ft_bar(ft_bar>t_i-trial.params.preDurInSec & ft_bar<t_f-trial.params.preDurInSec);

% fctr = vid2.FrameRate/50; % pretend you're sampling at 50 hz;
% N = floor(length(ft)/fctr); % average over enough frames to make it 50 Hz 
N = length(ft);

chnksz = floor(20000/N);
totalframes = N*length(trialnumlist);
pixels = nan(sum(abvthresh1D),min([chnksz*N,totalframes]));

frm = smooshedframe_Green;

%%

barposfig = figure;
barposfig.Position = [700 40 fliplr(wh_Green)];
barposax = subplot(1,1,1);
barposax.Box = 'off';
barposax.Tag = 'dispax';
barposax.NextPlot = 'add';

plot(barposax,ft_bar,trial.forceProbeStuff.CoM);
frpos = plot(barposax,[t_i,t_i],[min(trial.forceProbeStuff.CoM), max(trial.forceProbeStuff.CoM)],'r');

%%
for chnk_idx = 1:chnksz:length(trialnumlist)
    for tr_idx = chnk_idx:min([length(trialnumlist)-chnk_idx+1,chnk_idx+chnksz-1])
        tr_num = trialnumlist(tr_idx);
        trial = load(sprintf(trialStem,tr_num));
        fprintf('%s\n',trial.name);
        
%         waitbar((tr_num-trialnumlist(1)+1)/length(trialnumlist),br);
        % br_frame = waitbar(0,regexprep(sprintf(trialStem,tr_num),'_','\\_'));
        % br_frame.Name = 'Frames';
        
        vid2 = VideoReader(trial.imageFile); %#ok<TNMLP>
        vid2.CurrentTime = t_i;       

        barposax.NextPlot = 'replace';        
        plot(barposax,ft_bar,trial.forceProbeStuff.CoM);
        barposax.NextPlot = 'add';
        frpos = plot(barposax,[t_i,t_i],[min(trial.forceProbeStuff.CoM), max(trial.forceProbeStuff.CoM)],'r');

        frmcnt = 0;
        while frmcnt < N 
            frmcnt = frmcnt+1;
            %             fprintf('frmcnt %d: ',frmcnt);
            
            frm = double(rgb2gray(readFrame(vid2)));
%             cnt = 2;
%             while cnt<=fctr
%                 cnt = cnt+1;
%                 frm = frm+rgb2gray(double(readFrame(vid2)));
%             end 
            % fprintf('\n');
            % waitbar(frmcnt/N,br_frame);

%             [~,bar_frm] = min(abs(ft_bar-ft(frmcnt*fctr)));
            [~,bar_frm] = min(abs(ft_bar-ft(frmcnt)));
            % nan out the pixels near the bar;
            if any(isnan(trial.forceProbeStuff.forceProbePosition(:,bar_frm)))
                % skip this frame
            else

                bar_i_green = R_cam * (trial.forceProbeStuff.forceProbePosition(:,bar_frm)) + origin_green;
                barmask = poly2mask(...
                    bar(:,1)+bar_i_green(1),...
                    bar(:,2)+bar_i_green(2),...
                    size(smooshedframe_Green,1),...
                    size(smooshedframe_Green,2));
                frm(~abvthresh|barmask) = nan;
                im.CData = frm;
                barshadow.CData(:,:,1) = barmask;
                
                frpos.XData = [ft_bar(bar_frm) ft_bar(bar_frm)];
                drawnow
                % pause
                
                pixels(:,((tr_idx-1)+chnk_idx)*N+frmcnt) = frm(abvthresh1D);
            end
           
        end
        
    end
    Ns_cl = 3:8;
    clmask = zeros([size(smooshedframe_Green) length(Ns_cl)]);
    excludeframes = any(isnan(pixels),1);
    
    %% ************** --------- *************** %
    for N_cl = 5:6%Ns_cl
        fprintf('Running kmeans on pixel data (%d clusters): ',N_cl); tic
        [idx1,C1]=kmeans(pixels(:,~excludeframes),N_cl,'Distance','correlation','Replicates',4);
        toc
        
        clmask0 = zeros(size(smooshedframe_Green));
        clmask_N = zeros(size(smooshedframe_Green));
        clmask0(abvthresh) = idx1;
        
        % clrs = parula(N_cl);
        hexclrs = [
            '3C489E'
            'D64C90'
            'F9A61A'
            '00FF00'
            '47DDFF'
            'ED4545'
            '03AC72'
            '3304AC'
            ];

        clrs = hex2rgb(hexclrs);
        clrs = clrs(1:N_cl,:);% 4.8982 in 6.1249 in

        
        hold(dispax,'off')
        im = imshow(smooshedframe_Green,[0 2*quantile(smooshedframe_Green(:),0.975)],'parent',dispax); hold(dispax,'on');
        
        for cl = 1:N_cl
            hold(dispax,'on')
            alphamask(clmask0==cl,clrs(cl,:),.3,dispax);
        end
        
        % Then watershed the k_means clusters
        
        % calculate the density of the cluster points
        % NOTE: here I'm not filtering!
        for cl = 1:N_cl
            currcl = clmask0==cl;
            %             currcl = imgaussfilt(double(currcl),3);
            %             currcl = currcl>.75;
            alphamask(currcl,clrs(cl,:),.5,dispax);
            
            clmask_N(clmask_N==cl) = 0;
            clmask_N(currcl) = cl;
        end
        
        % line(...
        %     [h.kmeans_ROI{1}(:,1);h.kmeans_ROI{1}(1,1)],...
        %     [h.kmeans_ROI{1}(:,2);h.kmeans_ROI{1}(1,2)],...
        %     'parent',dispax,'color',[1 0 0]);
        
        clusterImagePath = sprintf(regexprep(trialStem,{'_Raw_','.mat','_%d'},{'_kmeansCluster_', '','_SelectTrials_%dCl_%d-%d'}),N_cl,trialnumlist(chnk_idx),trialnumlist(tr_idx));
        text(10,1000,regexprep(clusterImagePath,'\_','\\_'),'parent',dispax,'fontsize',10,'color',[1 1 1],'verticalAlignment','bottom')
        
        if ~exist([D,'clusters\'],'dir')
            mkdir([D,'clusters\'])
        end
        saveas(displayf,[D,'clusters\',clusterImagePath],'png')
        hold(dispax,'off');
        
        plotclusterfig = figure;
        plotclusterfig.Position = [1196 44 560 420];
        ax = subplot(1,1,1);
        
        for cl = 1:N_cl
            hold(ax,'on')
            plot(nanmean(pixels(idx1==cl,:),1),'color',clrs(cl,:));
        end
        
        clmask(:,:,Ns_cl==N_cl) = clmask_N;
    end
    
    % ************** save clmask for all the trials *************** %
    fprintf('Saving clustermasks: ');

    for t_idx = chnk_idx:tr_idx
        trial = load(sprintf(trialStem,trialnumlist(t_idx)));
        trial.clmask = clmask;
        save(trial.name, '-struct', 'trial')
    end
    
    setacqpref('quickshowPrefs','clmask',trial.clmask);
    delete(br);
end

