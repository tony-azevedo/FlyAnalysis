%% Set an ROI that avoids the leg, just gets the probe
% I think I only need 1 for now, but I'll keep the option for multiple
% (storing in cell vs matrix)
DEBUG = 1;
HUMPS = 1;

if isfield(trial,'excluded') && trial.excluded
    return
end

vid = VideoReader(trial.imageFile);
N = round(vid.Duration*vid.FrameRate);
h2 = postHocExposure(trial,N);
t = makeInTime(trial.params);
t_f = trial.params.durSweep-5*1/vid.FrameRate;

for cnt = 1:40
    
    frame = readFrame(vid);
end
frame = squeeze(frame(:,:,1));
if sum(frame(:)>10) < numel(frame)/1000
    startAt0 = true;
    t_i = 5*1/vid.FrameRate;
elseif isempty(strfind(trial.params.protocol,'Sweep'))
    startAt0 = false;
    t_i = 5*1/vid.FrameRate -trial.params.preDurInSec;
else
    t_i = 5*1/vid.FrameRate;
end 
frames = find(t(h2.exposure)>t_i & t(h2.exposure)<t_f);
N = length(frames);

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

% Average a few frames
for jj = 1:4
    mov3 = double(readFrame(vid));
    smooshedframe = smooshedframe+mov3(:,:,1);
end
frame = smooshedframe/4;

% Create a larger average for the background
for jj = 1:20
    mov3 = double(readFrame(vid));
    smooshedframe = smooshedframe+mov3(:,:,1);
end
smooshedframe = smooshedframe/24;

%% Smooth out the spot to show
if isfield(trial,'brightSpots2Smooth')
    annulusmask_all = false(size(smooshedframe));
    spotmask_all = false(size(smooshedframe));
    for roi_ind = 1:length(trial.brightSpots2Smooth)
        spot = trial.brightSpots2Smooth{roi_ind};
        centroid = mean(spot,1); centroids = repmat(centroid,size(spot,1),1);
        annulus = (spot-centroids)*2+centroids;
                
        spotmask = poly2mask(spot(:,1),spot(:,2),size(smooshedframe,1),size(smooshedframe,2));
        annulusmask = poly2mask(annulus(:,1),annulus(:,2),size(smooshedframe,1),size(smooshedframe,2));
        annulusvals = smooshedframe(annulusmask&~spotmask);
        I = mean(annulusvals);
        
        frame(spotmask) = I;
        smooshedframe(spotmask) = I;
        
        annulusmask_all = annulusmask_all | annulusmask;
        spotmask_all = spotmask_all | spotmask;
        
    end
end

%% Some knowledge
% probe runs effectively vertically.

%% Probe profile estimation
% Generate a series of points along the probe line

[l,p,l_r,R,p_,p_scalar,barbar,x] = probeCoordinates(trial);

p_(2) = min([p_(2),size(smooshedframe,1)]);

if DEBUG
    showProbeLocation(trial);
end

%% now set up evaluation points

evalpnts = 1:size(smooshedframe,2);
% evalpnts_x = evalpnts-p_(1); % this assumed that the bar tangent was
% important. With the vertical bar, it's not so much.
evalpnts_x = 1:size(smooshedframe,2);
evalpnts = [evalpnts;zeros(1,length(evalpnts))];
moveEvalPntsAlong = 1:p_(2);

ProfileMat = frame(1:p_(2),1:end);
ProfileMat = imgaussfilt(ProfileMat,20);

% Do the Background too
% BackgroundProfiles = ProfileMat;
BackgroundProfiles = smooshedframe(1:p_(2),1:end); 
BackgroundProfiles = imgaussfilt(BackgroundProfiles,20);

%% This section finds areas to the right of the bars to subtract from each frame
% 1) Average along the bar
mu = nanmean(ProfileMat,1);
filtered_mu = mu(:)'; 

if DEBUG
    tempf = figure; hold on;
    ax1 = subplot(1,1,1); hold on;
    plot(ax1,evalpnts_x, filtered_mu);
end

% 2) Find the best guess for Peaks
[pks,locs] = findpeaksWithCurrentModel(filtered_mu);

[~,loc1] = min(abs(evalpnts_x(locs)));
pk1 = pks(loc1);

if HUMPS > 1
    pks_ = pks([1:loc1-1,loc1+1:end]);
    locs_ = locs([1:loc1-1,loc1+1:end]);
    
    [~,loc2] = min(abs(evalpnts_x(locs_)));
    loc2 = find(pks==pks_(loc2));
    pk2 = pks(loc2);
    
    bar_idx_i = locs(max([loc1 loc2]));
else
    bar_idx_i = locs(loc1);
end

if DEBUG
plot(ax1,evalpnts_x(locs),pks,'ro'); 
plot(ax1,evalpnts_x(locs(1)),pks(1),'b+'); 
plot(ax1,evalpnts_x(locs(2)),pks(2),'k+'); 
end

% 3) Find the location of the darkest spot to the left of the bar (s)
dark = mean(filtered_mu(filtered_mu<quantile(filtered_mu((1:length(filtered_mu))<bar_idx_i),0.12) & (1:length(filtered_mu))<bar_idx_i));
% where the bar dips below dark
left_trough = find(fliplr(filtered_mu(1:bar_idx_i))<dark*1.05,1,'first');
trough = bar_idx_i-left_trough;
% where the bar comes back over dark on the far side (in case there is
% a bright spot in the corner
left_trough = find(fliplr(filtered_mu(1:trough))>dark*2,1,'first');
if ~isempty(left_trough)
    trough = trough-left_trough;
end
trough = max([trough 1]);

if DEBUG
plot(ax1,evalpnts_x(trough)*[1 1],[0 pk1],'color',[.8 .8 .8])
end

% 4) find where the gaussian is near 0 to the right
% lefthash = find(y_right < 1E-2*coef(1) ,1,'first')+sum(evalpnts_x<=zro_fit);
x_right = evalpnts_x(bar_idx_i:end);
y_right = filtered_mu(bar_idx_i:end);
lefthash = find(y_right == min(y_right) ,1,'first')+bar_idx_i;
if DEBUG
plot(ax1,evalpnts_x(lefthash)*[1 1],[0 pk1],'color',[1 .5 .5],'linewidth',3)
end
% 5) delineate that region as empty space
dark_right = mean(filtered_mu((1:length(filtered_mu))>lefthash & filtered_mu<quantile(filtered_mu(lefthash:end),.12)));

% 6) find where the intensity picks up again to the right
righthash = find((filtered_mu(lefthash+1:end))>dark_right,1,'first');
righthash = righthash+lefthash;
if DEBUG
plot(ax1,evalpnts_x(righthash)*[1 1],[0 pk1],'color',[.5 .5 1],'linewidth',2)
ylim(ax1,[-filtered_mu(righthash)/8 filtered_mu(righthash)*4])
end

x2fit = 1:length(filtered_mu);
barshape = filtered_mu-filtered_mu(righthash);
barshape(barshape<0)=0;
barshape(x2fit<trough)=0;
barshape(x2fit>righthash)=0;

barshape = barshape(:);
barshape0 = barshape;

if DEBUG
plot(ax1,evalpnts_x(x2fit),barshape)
end

% 7) Subtract off the background and plot
mask = ~isnan(BackgroundProfiles);
mask(:,evalpnts_x<evalpnts_x(righthash)) = 0;
Background = (BackgroundProfiles-filtered_mu(righthash)).*mask;

ProfileMat_BS = ProfileMat-Background;
filtered_frame_mu = nanmean(ProfileMat_BS,1);
filtered_frame_mu = smooth(filtered_frame_mu,30);

if DEBUG
plot(ax1,evalpnts_x,filtered_frame_mu,'k'); 
end

%% For tracking purposes, choose an initial point. This should be relatively constanst across trials
x2fit = x2fit(:);

% Double Gaussian fit
coef0 = [560 761 13 67 10 56]; % start with peaks at 400 and 600, heights of 10 and widths of 100
lb = [  20      20      1   1   1   1];
ub = [  1260    1260    50  400   50   400];
coef = lsqcurvefit(@doubleGaussian_bar_1at0,coef0,x2fit,barshape,lb,ub);
% coef = lsqcurvefit(@doubleGaussian_bar_1at0,coef,x2fit,barshape,lb,ub);

% Gaussian fit
coef0 = [560 13 67]; % start with peaks at 400 and 600, heights of 10 and widths of 100
lb = [  20   1   1];
ub = [  1260 50  400];
coef = lsqcurvefit(@gaussian_1at0,coef0,x2fit,barshape,lb,ub);

% Just use the right hand bump as 0
anchor0 = coef(2);
anchor = round(anchor0);
% anchor will be updated and will shift as it moves

%% Now find the best correlation with the frame

ffm_bs = filtered_frame_mu-filtered_frame_mu(righthash);
xc = 20;
[r,lags] = xcorr(ffm_bs,barshape,xc); r = r-r(xc-4);
[r1,x1] = max(r);
r2 = r(x1+1);
rm1 = r(x1-1);
if r2-rm1 > 0
    tmp = rm1;
    rm1 = r2;
    r2 = tmp;
    x0 = x1 - 1/2 *(rm1 - r2)/(r2-r1) - (xc+1);
elseif r2-rm1 < 0
    x0 = x1 + 1/2 *(rm1 - r2)/(r2-r1) - (xc+1);
else
    x0 = 0; % assume it is from x1 = 0;
end
com = x0+anchor;

%%
if DEBUG
close(tempf)
end

%%
profileFigure = findobj('type','figure','tag','profile_fig');
if isempty(profileFigure)
    profileFigure = figure;
    profileFigure.Position = [1331 421 560 420];
    profileFigure.Tag = 'profile_fig';    
end
profileAxes = subplot(1,1,1,'parent',profileFigure); cla(profileAxes); hold(profileAxes,'on');
% plot(evalpnts_x,filtered_sigma_mu/max(filtered_sigma_mu)*max(filtered_mu),'g','parent',profileAxes);
plot(evalpnts_x,filtered_mu,'color',[0 .7 0],'parent',profileAxes);
brshp = plot(evalpnts_x,barshape,'color',[1 1 1]*.8,'parent',profileAxes);
% plot(zro,pk+dark,'markeredgecolor',[1 1 1]*0,'markerfacecolor',[1 1 1]*0,'marker','o','linestyle','none','parent',profileAxes);

plot([evalpnts_x(lefthash) evalpnts_x(lefthash)],[0 max(filtered_mu)],'color',[1.2 1 1]*.8,'parent',profileAxes);
plot([evalpnts_x(righthash) evalpnts_x(righthash)],[0 max(filtered_mu)],'color',[1 1 1.2]*.8,'parent',profileAxes);

profmu = plot(evalpnts_x,filtered_frame_mu,'color',[0 0 0],'parent',profileAxes);
darkln = plot([evalpnts_x(1) evalpnts_x(end)],[dark dark],'color',[1,1,1]*.8,'parent',profileAxes);
bar_ontangent = plot([evalpnts_x(round(com)),evalpnts_x(round(com))],[0 max(filtered_mu)],'color',[0 0 0],'parent',profileAxes);


displayf2 = findobj('type','figure','tag','big_fig2');
if isempty(displayf2)
    displayf2 = figure;
    displayf2.Position = [640 100 size(ProfileMat_BS,2)/2 3.1*size(ProfileMat_BS,1)/2];
    displayf2.Tag = 'big_fig2';
end
delete(findobj(displayf2,'type','axes'));

dispax1 = axes('parent',displayf2,'units','pixels','position',[0 2*size(ProfileMat_BS,1)/2 size(ProfileMat_BS,2)/2 size(ProfileMat_BS,1)/2]);
dispax2 = axes('parent',displayf2,'units','pixels','position',[0 1*size(ProfileMat_BS,1)/2 size(ProfileMat_BS,2)/2 size(ProfileMat_BS,1)/2]);
dispax3 = axes('parent',displayf2,'units','pixels','position',[0 0*size(ProfileMat_BS,1)/2 size(ProfileMat_BS,2)/2 size(ProfileMat_BS,1)/2]);
% set(dispax2,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax2,'gray')

pm = imshow(ProfileMat,[0 2*quantile(Background(:),0.975)],'parent',dispax1);
bk = imshow(Background,[0 2*quantile(Background(:),0.975)],'parent',dispax2);
lr = line([lefthash,lefthash],[1 size(Background,1)],'parent',dispax2,'color',[1 .5 .5]);
pm_bs = imshow(ProfileMat_BS,[0 2*quantile(ProfileMat_BS(:),0.975)],'parent',dispax3);
rr = line([righthash,righthash],[1 size(ProfileMat_BS,1)],'parent',dispax3,'color',[.5 .5 1]);
bar = line([com,com],[1 size(ProfileMat_BS,1)],'parent',dispax3,'color',[1 0 1]);

trial.forceProbeStuff.line = trial.forceProbe_line;
trial.forceProbeStuff.tangent = trial.forceProbe_tangent;
trial.forceProbeStuff.EvalPnts = evalpnts;
trial.forceProbeStuff.EvalPnts_x = evalpnts_x;
trial.forceProbeStuff.EvalPnts_y = moveEvalPntsAlong;


%%

% go through the movie
% 1) substract off the background region
% 2) find the peak of the mean trace. That's where the bar is

% figure(displayf)
% figure(displayf2)
figure(profileFigure)


% look for movie file

% import movie
vid = VideoReader(trial.imageFile);
N = round(vid.Duration*vid.FrameRate);
h2 = postHocExposureRaw(trial,N);
t = makeInTime(trial.params);

kk = 0;

% find the first frame  for calcium imaging
% k0 = find(t(h2.exposure)>0,2,'first');
% k0 = k0(end);

% find the first frame for IR illumination
k0 = 1;

% find the last frame
% kf = find(t(h2.exposure)<h.params.stimDurInSec,1,'last');
kf = find(t(h2.exposure)<trial.params.durSweep,1,'last');

br_trial = waitbar(0,sprintf('%d',kk));
br_trial.Name = 'Frames';

forceProbePosition = nan(2,N);
CoM = nan(1,N);
% CoM = nan(1,N);
keimograph = nan(length(evalpnts_x),N);

tic
while hasFrame(vid)
    kk = kk+1;
    
    if kk<k0
        readFrame(vid);
        continue
    elseif kk>kf
        break
    end
    mov3 = double(readFrame(vid));
    frame = mov3(:,:,3);
    if exist('annulusvals','var')
        annulusvals = frame(annulusmask_all&~spotmask_all);
        I = mean(annulusvals);
        frame(spotmask_all) = I;
    end
    
    ProfileMat = frame(1:p_(2),1:end);
    % ProfileMat = imgaussfilt(ProfileMat,30);    
    
    ProfileMat_BS = ProfileMat-Background;
    filtered_frame_mu = nanmean(ProfileMat_BS,1);
    % filtered_frame_mu = smooth(filtered_frame_mu,30);

    
    % taper both ends
    mb = polyfit((50:100),filtered_frame_mu(50:100),1);
    filtered_frame_mu(1:49) = mb(2)+mb(1)*(1:49);
    mb = polyfit((length(evalpnts_x)-100:length(evalpnts_x)-50),filtered_frame_mu(length(evalpnts_x)-100:length(evalpnts_x)-50),1);
    filtered_frame_mu(end-49+1:end) = mb(2)+mb(1)*(length(evalpnts_x)-(49:-1:1));
    
    % find the dark values
    %     dark = mean(filtered_frame_mu(filtered_frame_mu<quantile(filtered_frame_mu(:),0.12)));
    %     darkln.YData = [dark dark];

    %% correlate with bar shape, assuming barshape doesn't change
    ffm_bs = filtered_frame_mu-filtered_frame_mu(righthash);

    % calculate xc = +- 20 lags
    xc = 20;
    [r,lags] = xcorr(ffm_bs,barshape,xc);
    [r1,x1] = max(r);
    r2 = r(x1+1);
    rm1 = r(x1-1);
    if r2-rm1 > 0
        tmp = rm1;
        rm1 = r2;
        r2 = tmp; 
        x0 = x1 - 1/2 *(rm1 - r2)/(r2-r1) - (xc+1);
    elseif r2-rm1 < 0
        x0 = x1 + 1/2 *(rm1 - r2)/(r2-r1) - (xc+1); 
    else 
        x0 = 0; % assume it is from x1 = 0;
    end
    com = x0+anchor;
    
    shft = round(x0);
    anchor = anchor+shft;
    barshape = wshift('1d',barshape,-shft);
    % shift both bar shape and anchor a little bit
    
    x_hat = evalpnts(:,2)-evalpnts(:,1);
    forceProbePosition(:,kk) = x_hat.*(com);

    keimograph(:,kk) = filtered_frame_mu;
    CoM(1,kk) = com;
    
    if ~mod(kk,5)
        % lower the number of times I update
        brshp.YData = barshape;
        profmu.YData = filtered_frame_mu;
        waitbar(kk/N,br_trial,sprintf('%d',kk));
        bar_ontangent.XData = [com com];

        drawnow
    end
end
delete(br_trial);
    
trial.forceProbeStuff.forceProbePosition = forceProbePosition;
trial.forceProbeStuff.CoM = CoM;
fprintf('Saving bar position\n')
save(trial.name,'-struct','trial')

save(regexprep(trial.name,'_Raw_','_keimograph_'),'keimograph');

% close(displayf)
% close(displayf2)
% close(profileFigure)
toc

function [pks,locs] = findpeaksWithCurrentModel(ffm)

[pks,locs] = findpeaks(ffm,'MinPeakWidth',1280/50,'MinPeakProminence',2); 

end