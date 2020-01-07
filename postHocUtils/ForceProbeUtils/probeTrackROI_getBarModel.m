function trial = probeTrackROI_getBarModel(trial)
%% Set an ROI that avoids the leg, just gets the probe
% I think I only need 1 for now, but I'll keep the option for multiple
% (storing in cell vs matrix)

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

D_shortened = [D 'sampleFrames' filesep];

sampledDataPath = regexprep(trial.name,regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
sampledDataPath = regexprep(sampledDataPath,{'_Raw_','.mat'},{'_Image_', '.mat'});

smpd = load(sampledDataPath);
frame = smpd.sampledImage(:,:,1);
smooshedframe = mean(smpd.sampledImage,3);

%% Some knowledge

% Some knowledge about the probe: 
% The bar is long, longer than the glue will be.
% This means it will be in the image longer, further to the corner
% For now, the bar stretches back to the corner
% The bar is always the same width. If it's wider, then there was some
% motion. It cannot be thinner
% It will be close in neighboring frames
% the tangent line is the direction of motion, the bar line is the
% direction of the bar. 
% From one frame to the next, the number of profiles to compute might
% change

% Only look at when the light comes on
% From the tangent line, select out the ROI to be looking at.
% Some regions are going to be the same intensity the entire time (glue,
% leg)

%% Probe profile estimation
% Generate a series of points along the probe line

% loop through these points
%   get the improfile, centered on the probe line, with the points of
%   measurements at the same intervals

l = trial.forceProbe_line;
p = trial.forceProbe_tangent;

% probe_eval_points = turnLineIntoEvalPnts(l,p);
% recenter
l_0 = l - repmat(mean(l,1),2,1);
p_0 = p - mean(l,1);

% for my purposes, get the line equation (m,b)
m = diff(l(:,2))/diff(l(:,1));
b = l(1,2)-m*l(1,1);

% find y vector
barbar = l_0(2,:)/norm(l_0(2,:));

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


%% now set up evaluation points
% find the edge of the image
if b<0
    p_edge = [-b/m 0];
else
    p_edge = [0  b];
end
l_eval = [p_;p_edge];

tangent_to_edge = l_eval - repmat(l_eval(1,:),2,1);
points2eval = (1:ceil(norm(tangent_to_edge(2,:))))-1;
barbar = tangent_to_edge(2,:)/norm(tangent_to_edge(2,:));

% eval points occur every pxl along l_eval
moveEvalPntsAlong = repmat(p_',1,length(points2eval))+barbar'*points2eval;

x_as_points = [0 0;x]+repmat(p_,2,1);
m_ = diff(x_as_points(:,2))/diff(x_as_points(:,1));
b_ = x_as_points(1,2)-m_*x_as_points(1,1);

p_to_edge_along_tangent = [p_;0 b_];
dist_to_edge(1) = sqrt(diff(p_to_edge_along_tangent(:,1))^2+diff(p_to_edge_along_tangent(:,1))^2);

p_to_edge_along_tangent = [p_;-b_/m_ 0];
dist_to_edge(2) = sqrt(diff(p_to_edge_along_tangent(:,1))^2+diff(p_to_edge_along_tangent(:,1))^2);

% evalpnts should start at the tangent intersection and go out from there,
% + and -
evalpnts_x = -ceil(max(dist_to_edge)):1:ceil(max(dist_to_edge));
evalpnts = x'*evalpnts_x;
% evalN = size(evalpnts,2);
% evalEnds = [evalpnts(:,1) evalpnts(:,end)];

xy = evalpnts+repmat(moveEvalPntsAlong(:,1),1,length(evalpnts));
xy = uint16(xy);
pos_idxs = xy(1,:)>0 & xy(2,:)>0;
evalpnts = evalpnts(:,pos_idxs);
evalpnts_x = evalpnts_x(pos_idxs);

ProfileMat = nan(length(moveEvalPntsAlong),size(evalpnts,2));
BackgroundProfiles = ProfileMat;
Rmap = nan(size(ProfileMat,1),size(ProfileMat,2));
Cmap = nan(size(ProfileMat,1),size(ProfileMat,2));

% move along line back to corner,
% xy = evalpnts+repmat(moveEvalPntsAlong(:,1),1,length(evalpnts));
% pos_idxs = xy(1,:)>0 & xy(2,:)>0;
% xy = xy(:,pos_idxs);
% l = line(xy(1,:),xy(2,:),'parent',dispax,'linestyle','none','marker','.','markerfacecolor',[1 1 1],'markeredgecolor',[1 1 1],'tag','samples');

% profileFigure = figure;
% set(profileFigure,'position',[1331 421 560 420]);
% profileAxes = subplot(1,1,1); hold(profileAxes,'on');
% I = impixel(smpd.sampledImage(:,:,1),xy(1,:),xy(2,:));
% % prfl = plot(evalpnts_x(pos_idxs),I(:,1),'k','parent',profileAxes);

for ep_idx = 1:size(moveEvalPntsAlong,2)
    xy = evalpnts+repmat(moveEvalPntsAlong(:,ep_idx),1,length(evalpnts));
    xy = uint16(xy);
    pos_idxs = xy(1,:)>0 & xy(2,:)>0;
    
    Rmap(ep_idx,pos_idxs) = xy(1,pos_idxs);
    Cmap(ep_idx,pos_idxs) = xy(2,pos_idxs);
    
    pos_idxs_i(pos_idxs) = find(pos_idxs);
    
    for rc = 1:size(xy,2)
        if xy(1,rc)>0 && xy(2,rc)>0
            ProfileMat(ep_idx,pos_idxs_i(rc)) = frame(xy(2,rc),xy(1,rc));
            BackgroundProfiles(ep_idx,pos_idxs_i(rc)) = smooshedframe(xy(2,rc),xy(1,rc));
        end
    end
    
    % set(prfl,'XData',evalpnts_x(pos_idxs),'YData',I(:,1));
    % drawnow
end

% slim down the profile mat and evalpnst

indices_gt4vals = sum(~isnan(ProfileMat),1)>4;

evalpnts_x = evalpnts_x(indices_gt4vals);
evalpnts = evalpnts(:,indices_gt4vals);

BackgroundProfiles = BackgroundProfiles(:,indices_gt4vals);
Rmap = Rmap(:,indices_gt4vals);
Cmap = Cmap(:,indices_gt4vals);
ProfileMat = ProfileMat(:,indices_gt4vals);

%quick check on the profileIndices: in third dim, all entries should either
%be nan or real
% sum(sum(~isnan(ProfileIndices(:,:,1)) & isnan(ProfileIndices(:,:,1))))
% sum(sum(~isnan(ProfileIndices(:,:,1)) & ~isnan(ProfileIndices(:,:,1))))


%% for the first image - assume the first image the bar is far from the body, near 0
% 1) calculate sigma/mu. filter a little

mu = nanmean(ProfileMat,1);
sigma = nanstd(ProfileMat,1);
filtered_mu = smooth(mu,10);
mu_bg = nanmean(BackgroundProfiles,1);

% 2) black areas are going to have high sigma/mu. Find the region near 0
% where s/m is low, <1/3 |min-max|. This is most likely the bar.

% Find the peak of the mean near evalpnts_x = 0;
[pks,locs] = findpeaks(filtered_mu,'MinPeakWidth',length(-filtered_mu)/30);

[~,loc] = min(abs(evalpnts_x(locs)));
zro = evalpnts_x(locs(loc));

filtered_sigma_mu = sigma./mu_bg;
filtered_sigma_mu = smooth(filtered_sigma_mu,100);
% taper both ends
mb = polyfit((50:100)',filtered_sigma_mu(50:100),1);
filtered_sigma_mu(1:49) = mb(2)+mb(1)*(1:49);
mb = polyfit((length(evalpnts_x)-100:length(evalpnts_x)-50)',filtered_sigma_mu(length(evalpnts_x)-100:length(evalpnts_x)-50),1);
filtered_sigma_mu(end-49+1:end) = mb(2)+mb(1)*(length(evalpnts_x)-(49:-1:1));

[dark,trough] = max(filtered_sigma_mu(evalpnts_x>zro));
trough = trough+sum(evalpnts_x<=zro);
dark = mean(mu(filtered_sigma_mu>=.925*dark));

% 3) fit a gaussian to this part of the curve.
% [pks,locs] = findpeaks(mu,'MinPeakWidth',length(-filtered_sigma_mu)/20);
% [~,loc] = min(abs(locs));
pk = pks(loc);

bar_sigma = abs(evalpnts_x(find(mu>.7*pk,1,'first'))-zro);
threesigma = abs(evalpnts_x-zro)<=3*bar_sigma;

coef = nlinfit(evalpnts_x(threesigma),mu(threesigma)-dark,@gaussian_1at0,[pk,zro,bar_sigma]);

% 4) find where the gaussian is near 0 to the right
lefthash = find(gaussian_1at0(coef,evalpnts_x(evalpnts_x>zro))< 1E-4*coef(1) ,1,'first')+sum(evalpnts_x<=zro);
lefthashadjust = min([lefthash,trough]);

% 5) delineate that region as empty space
% 6) find where the intensity picks up again to the right
[~,righthash] = max(filtered_mu(trough+1:end));
righthash = find((filtered_mu(trough+1:end)-dark)>1.2*dark,1,'first');
righthash = righthash+trough;
% This might be very close to "darkness" if there is no body, so if it is
% at "trough", make it a little to the right of trough.
% at most it should be about 80% of the full line, bar will definitely not
% be over there
righthashadjust = max([righthash round(0.80*size(evalpnts_x,2))]);

% 7) this is the region where the background is

% 8) get this region of the smooshed frame as the background, subtract off
% the point at left hash

mask = ~isnan(BackgroundProfiles);
mask(:,evalpnts_x<evalpnts_x(lefthashadjust)) = 0;
Background = (BackgroundProfiles-filtered_mu(lefthashadjust)).*mask;

ProfileMat_BS = ProfileMat-Background;
filtered_frame_mu = nanmean(ProfileMat_BS,1);
filtered_frame_mu = smooth(filtered_frame_mu,30);
% taper both ends
mb = polyfit((50:100)',filtered_frame_mu(50:100),1);
filtered_frame_mu(1:49) = mb(2)+mb(1)*(1:49);
mb = polyfit((length(evalpnts_x)-100:length(evalpnts_x)-50)',filtered_frame_mu(length(evalpnts_x)-100:length(evalpnts_x)-50),1);
filtered_frame_mu(end-49+1:end) = mb(2)+mb(1)*(length(evalpnts_x)-(49:-1:1));


[pk,loc] = max(filtered_frame_mu(1:righthashadjust));

% 9) Assume the shape of the bar doesn't change and get the CoM of the
% fullwidth @ 67% max, hopefully this will eliminate the weird jumping of
% the bar
left = find(filtered_frame_mu(1:loc)<pk*2/3,1,'last');
right = find(filtered_frame_mu(loc:end)<pk*2/3,1,'first')+loc;

r_idx = left+1:right-1;
com = round(sum(r_idx'.*filtered_frame_mu(r_idx))./sum(filtered_frame_mu(r_idx)));

bar_loc = evalpnts(:,com);
bar_loc_ontangent = evalpnts_x(com);



%%
profileFigure = findobj('type','figure','tag','profile_fig');
if isempty(profileFigure)
    profileFigure = figure;
    set(profileFigure,'position',[1331 421 560 420],'tag','profile_fig');
end
profileAxes = subplot(1,1,1); cla(profileAxes); hold(profileAxes,'on');
plot(evalpnts_x,filtered_sigma_mu/max(filtered_sigma_mu)*max(filtered_mu),'g','parent',profileAxes);
plot(evalpnts_x,filtered_mu,'color',[0 .7 0],'parent',profileAxes);
plot(evalpnts_x(locs),pks,'markeredgecolor',[0 0 0],'marker','o','linestyle','none','parent',profileAxes);

plot(evalpnts_x(evalpnts_x>zro),gaussian_1at0(coef,evalpnts_x(evalpnts_x>zro)),'color',[0 0 1],'parent',profileAxes);
% plot(evalpnts_x(lefthash),0,'markeredgecolor',[1 0 0],'marker','o','linestyle','none','parent',profileAxes);
plot(evalpnts_x(lefthashadjust),1E-3*coef(1),'markeredgecolor',[0 1 0],'marker','o','linestyle','none','parent',profileAxes);
plot([evalpnts_x(righthashadjust) evalpnts_x(righthashadjust)],[0 max(filtered_mu)],'color',[1 1 1]*.8,'parent',profileAxes);

profmu = plot(evalpnts_x,filtered_frame_mu,'color',[0 0 0],'parent',profileAxes);
bar_ontangent = plot([evalpnts_x(loc),evalpnts_x(loc)],[0 max(filtered_mu)],'color',[0 0 0],'parent',profileAxes);

% 
% displayf = findobj('type','figure','tag','big_fig');
% if isempty(displayf)
%     displayf = figure;
%     set(displayf,'position',[40 2 640 530],'tag','big_fig');
% end
% dispax = findobj(displayf,'type','axes','tag','dispax');
% if isempty(dispax) 
%     dispax = axes('parent',displayf,'units','pixels','position',[0 0 640 512],'tag','dispax');
%     set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
%     colormap(dispax,'gray')
% end
% hold(dispax,'off')
% im = imshow(frame,[0 2*quantile(frame(:),0.975)],'parent',dispax);
% hold(dispax,'on');
% % find limits projected along x
% line(trial.forceProbe_line(:,1),trial.forceProbe_line(:,2),'parent',dispax,'color',[1 0 0]);
% % line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);
% line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3]);
% %line(moveEvalPntsAlong(1,1),moveEvalPntsAlong(2,1),'parent',dispax,'marker','o','markeredgecolor',[0 0 1],'markerfacecolor',[1 1 1]);
% bar_spot = line(moveEvalPntsAlong(1,1)+bar_loc(1),moveEvalPntsAlong(2,1)+bar_loc(2),'parent',dispax,'marker','o','markeredgecolor',[0 0 1],'markerfacecolor',[1 1 1]);
% 
% 
% displayf2 = findobj('type','figure','tag','big_fig2');
% if isempty(displayf2)
%     displayf2 = figure;
%     set(displayf2,'position',[640 100 size(ProfileMat_BS,2)/2 3.1*size(ProfileMat_BS,1)/2],'tag','big_fig2');
% end
% delete(findobj(displayf2,'type','axes'));
% 
% dispax1 = axes('parent',displayf2,'units','pixels','position',[0 2*size(ProfileMat_BS,1)/2 size(ProfileMat_BS,2)/2 size(ProfileMat_BS,1)/2]);
% dispax2 = axes('parent',displayf2,'units','pixels','position',[0 1*size(ProfileMat_BS,1)/2 size(ProfileMat_BS,2)/2 size(ProfileMat_BS,1)/2]);
% dispax3 = axes('parent',displayf2,'units','pixels','position',[0 0*size(ProfileMat_BS,1)/2 size(ProfileMat_BS,2)/2 size(ProfileMat_BS,1)/2]);
% % set(dispax2,'box','off','xtick',[],'ytick',[],'tag','dispax');
% colormap(dispax2,'gray')
% 
% im = imshow(BackgroundProfiles,[0 2*quantile(BackgroundProfiles(:),0.975)],'parent',dispax2);
% im = imshow(Background,[0 2*quantile(Background(:),0.975)],'parent',dispax2);
% 
% pm = imshow(ProfileMat,[0 2*quantile(Background(:),0.975)],'parent',dispax1);
% bk = imshow(Background,[0 2*quantile(Background(:),0.975)],'parent',dispax2);
% pm_bs = imshow(ProfileMat_BS,[0 2*quantile(ProfileMat_BS(:),0.975)],'parent',dispax3);
% bar = line([loc,loc],[1 size(ProfileMat_BS,1)],'parent',dispax3,'color',[1 0 1]);

trial.forceProbeStuff.barmodel = coef;
fprintf('Saving bar model\n')
save(trial.name,'-struct','trial')

% h.forceProbeStuff.TransformMap = cat(3,Cmap,Rmap);
% h.forceProbeStuff.Background = Background;
% h.forceProbeStuff.lefthash = Background;

%% one more check
% take in a frame,
% extract the pixels needed
% place them in ProfileMat
% calculate mu, that's the bar, move on

% figure(displayf)
% figure(displayf2)
% figure(profileFigure)
% 
% for fr = 1:size(smpd.sampledImage,3)
%     frame = smpd.sampledImage(:,:,fr);
%     
%     ProfileMat(:) = nan;
%     for r = 1:size(ProfileMat,1);
%         for c = 1:size(ProfileMat,2);
%             if isnan(Rmap(r,c)) && isnan(Cmap(r,c))
%                 continue
%             end
%             ProfileMat(r,c) = frame(Cmap(r,c),Rmap(r,c));
%             
%         end
%     end
%     ProfileMat_BS = ProfileMat-Background;
%     filtered_frame_mu = nanmean(ProfileMat_BS,1);
%     filtered_frame_mu = smooth(filtered_frame_mu,10);
%     
%     [~,loc] = max(filtered_frame_mu(1:righthashadjust));
%     bar_loc = evalpnts(:,loc);
%     bar_loc_ontangent = evalpnts_x(loc);
%     
%     im.CData = frame;
%     bar.XData = [loc loc];
%     pm_bs.CData = ProfileMat_BS;
%     bar_spot.XData = moveEvalPntsAlong(1,1)+bar_loc(1);
%     bar_spot.YData = moveEvalPntsAlong(2,1)+bar_loc(2);
% 
%     profmu.YData = filtered_frame_mu;
%     bar_ontangent.XData = [evalpnts_x(loc) evalpnts_x(loc)];
%     
%     drawnow
%     pause(.2)
% end    
% 
% 
% button = questdlg('Is that going to work? Movie, good bar AND tangent?','forceProbeTangent','Yes');
% switch button
%     case 'Yes';
%         trial = h;
%         fprintf('Saving bar and tangent in trial\n')
%         % save(trial.name,'-struct','trial')
%     case  'No'
%         trial = h;
%         trial.exclude = 1;
%         trial.badmovie = 1;
%         fprintf('Bad movie: Not setting tangent in trial\n')
%         % save(trial.name,'-struct','trial')
%     case 'Cancel'
%         fprintf('Not setting tangent in trial\n')
%         return
% end

% close(displayf)
% close(displayf2)


%%

% % go through the movie
% % 1) substract off the background region
% % 2) find the peak of the mean trace. That's where the bar is
% 
% % figure(displayf)
% % figure(displayf2)
% figure(profileFigure)
% 
% 
% % look for movie file
% checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(trial.params.trial) '_' datestr(trial.timestamp,29) '*.avi']));
% moviename = checkdir(1).name;
% 
% % import movie
% vid = VideoReader(moviename);
% N = vid.Duration*vid.FrameRate;
% h2 = postHocExposureRaw(trial,N);
% t = makeInTime(trial.params);
% 
% kk = 0;
% 
% % find the first frame  for calcium imaging
% % k0 = find(t(h2.exposure)>0,2,'first');
% % k0 = k0(end);
% 
% % find the first frame for IR illumination
% k0 = 1;
% 
% % find the last frame
% kf = find(t(h2.exposure)<trial.params.stimDurInSec,1,'last');
% kf = find(t(h2.exposure)<trial.params.durSweep,1,'last');
% 
% br = waitbar(0,sprintf('%d',kk));
% br.Name = 'Frames';
% 
% forceProbePosition = nan(2,N);
% I_profile = nan(length(evalpnts_x),N);
% 
% while hasFrame(vid)
%     kk = kk+1;
%     waitbar(kk/N,br,sprintf('%d',kk));
% 
%     if kk<k0
%         readFrame(vid);
%         continue
%     elseif kk>kf
%         break
%     end
%     
%     mov3 = readFrame(vid);
%     frame = mov3;
%     
%     ProfileMat(:) = nan;
%     for r = 1:size(ProfileMat,1);
%         for c = 1:size(ProfileMat,2);
%             if isnan(Rmap(r,c)) && isnan(Cmap(r,c))
%                 continue
%             end
%             ProfileMat(r,c) = frame(Cmap(r,c),Rmap(r,c));
%             
%         end
%     end
%     ProfileMat_BS = ProfileMat-Background;
%     filtered_frame_mu = nanmean(ProfileMat_BS,1);
%     filtered_frame_mu = smooth(filtered_frame_mu,30);
%     % taper both ends
%     mb = polyfit((50:100)',filtered_frame_mu(50:100),1);
%     filtered_frame_mu(1:49) = mb(2)+mb(1)*(1:49);
%     mb = polyfit((length(evalpnts_x)-100:length(evalpnts_x)-50)',filtered_frame_mu(length(evalpnts_x)-100:length(evalpnts_x)-50),1);
%     filtered_frame_mu(end-49+1:end) = mb(2)+mb(1)*(length(evalpnts_x)-(49:-1:1));
%     
%     [pk,loc] = max(filtered_frame_mu(1:righthashadjust));
%     
%     left = find(filtered_frame_mu(1:loc)<pk*2/3,1,'last');
%     right = find(filtered_frame_mu(loc:end)<pk*2/3,1,'first')+loc;
%     if isempty(left) || isempty(right)
%         continue
%     end
%         
%     r_idx = left+1:right-1;
%     com = round(sum(r_idx'.*filtered_frame_mu(r_idx))./sum(filtered_frame_mu(r_idx)));
%     
%     bar_loc = evalpnts(:,com);
%     
%     forceProbePosition(:,kk) = bar_loc;
%     I_profile(:,kk) = filtered_frame_mu;
% 
% %     im.CData = frame;
% %     bar.XData = [loc loc];
% %     pm_bs.CData = ProfileMat_BS;
% %     bar_spot.XData = moveEvalPntsAlong(1,1)+bar_loc(1);
% %     bar_spot.YData = moveEvalPntsAlong(2,1)+bar_loc(2);
% 
%     profmu.YData = filtered_frame_mu;
%     bar_ontangent.XData = [evalpnts_x(com) evalpnts_x(com)];
%     
%     drawnow
% 
% end
% delete(br);
%     
% trial.forceProbeStuff.forceProbePosition = forceProbePosition;
% trial.forceProbeStuff.keimograph = I_profile;
% trial = trial;
% fprintf('Saving bar position\n')
% save(trial.name,'-struct','trial')
% 
% % close(displayf)
% % close(displayf2)
% close(profileFigure)

end