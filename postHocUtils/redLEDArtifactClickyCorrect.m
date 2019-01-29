% function redLEDArtifactClickyCorrect(trial)
%% This routine doesn't work if there is no probe CoM vector

if ~isfield(trial.forceProbeStuff,'CoM')
    error('trial doesnt have a center of mass vector, problem')
end
vid = VideoReader(trial.imageFile);
N = round(vid.Duration*vid.FrameRate);
h2 = postHocExposure(trial,N);
t = makeInTime(trial.params);
ft = t(h2.exposure);

I_profile = load(regexprep(trial.name,'_Raw_','_keimograph_'),'keimograph');
I_profile = I_profile.keimograph;

fps = trial.forceProbeStuff;

pre_idx = find(ft<0,1,'last');
post_idx = find(ft>trial.params.stimDurInSec,1,'first');

origin_idx = find(fps.EvalPnts(1,:)==0&fps.EvalPnts(2,:)==0);
x_hat = fps.EvalPnts(:,origin_idx+1);

%% Calculate pretrial mean and var for noise later
mu = mean(fps.CoM(ft<0&ft>-12*diff(ft(1:2))));
sigma = std(fps.CoM(ft<0&ft>-12*diff(ft(1:2))));


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
l_0 = l_0/4;


%% Plot the last frame before the start of the stimulus
vid.CurrentTime = ft(pre_idx)-ft(1);
frame = rgb2gray(vid.readFrame);
newfps = fps;

traceFigure = findobj('type','figure','tag','trace_fig');
if isempty(traceFigure)
    traceFigure = figure;
    traceFigure.Position = [1331 421 560 360];
    traceFigure.Tag = 'trace_fig';    
end
traceAxes = subplot(1,1,1,'parent',traceFigure); cla(traceAxes); hold(traceAxes,'on');
plot(ft,fps.CoM,'color',[0 0 .7],'parent',traceAxes);
indicator_0 = plot(traceAxes,ft(pre_idx),fps.CoM(pre_idx),'o','color',[1 0 0],'tag','indicator_0');
indicator = plot(traceAxes,ft(pre_idx),fps.CoM(pre_idx),'o','color',[1 0 0],'tag','indicator');
indicator_new = plot(traceAxes,ft(pre_idx),fps.CoM(pre_idx),'o','color',[0 1 1],'MarkerFaceColor',[0 1 1],'tag','indicator_new');

profileFigure = findobj('type','figure','tag','profile_fig');
if isempty(profileFigure)
    profileFigure = figure;
    profileFigure.Position = [1331 73 560 360];
    profileFigure.Tag = 'profile_fig';    
end
profileAxes = subplot(1,1,1,'parent',profileFigure); cla(profileAxes); hold(profileAxes,'on');
barshape_0 = plot(1:length(fps.EvalPnts_x),I_profile(:,pre_idx),'color',[1 1 1]*.8,'parent',profileAxes);
barshape_f = plot(1:length(fps.EvalPnts_x),I_profile(:,post_idx+1),'color',[.4 1 1],'parent',profileAxes);
barshape = plot(1:length(fps.EvalPnts_x),I_profile(:,pre_idx),'color',[0 0 0],'parent',profileAxes);
bar_location_0 = plot(profileAxes,[fps.CoM(pre_idx), fps.CoM(pre_idx)],[0 max(I_profile(:))],'color',[1 1 1]*.8,'tag','bar_location_0');
bar_location = plot(profileAxes,[fps.CoM(pre_idx), fps.CoM(pre_idx)],[0 max(I_profile(:))],'color',[1 0 1],'tag','bar_location');
bar_location_new = plot(profileAxes,[fps.CoM(pre_idx), fps.CoM(pre_idx)],[0 max(I_profile(:))],'color',[0 1 1],'tag','bar_location');

displayf = findobj('type','figure','tag','big_fig');
if isempty(displayf)
    displayf = figure;
    displayf.Position = [40 20 1280 1040];
    displayf.Tag = 'big_fig';
end
dispax = findobj(displayf,'type','axes','tag','dispax');
if isempty(dispax) 
    dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1040],'tag','dispax');
    dispax.Box = 'off'; dispax.XTick = []; dispax.YTick = []; dispax.Tag = 'dispax';
    colormap(dispax,'gray')
end
hold(dispax,'off')
im = imshow(frame,[0 2*quantile(frame(:),0.975)],'parent',dispax);
hold(dispax,'on');

instructions = text(20,980,'Click on the spot and press space bar','parent',dispax);
instructions.Color = [.7 .7 1];

l_1 = l_0 + repmat(fps.forceProbePosition(:,pre_idx)'+p_,2,1);
bar_line_0 = line(l_1(:,1),l_1(:,2),'parent',dispax,'color',[1 1 1]*.8);
l_f = l_0 + repmat(fps.forceProbePosition(:,post_idx)'+p_,2,1);
bar_line_f = line(l_f(:,1),l_f(:,2),'parent',dispax,'color',[.3 .3 .7]);

% line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);
bar_spot_new = line(fps.forceProbePosition(1,pre_idx)+p_(1),fps.forceProbePosition(2,pre_idx)+p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 0 1],'markerfacecolor',[1 1 1]*.5,'tag','bar_spot_0');
bar_spot = line(fps.forceProbePosition(1,pre_idx)+p_(1),fps.forceProbePosition(2,pre_idx)+p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 0 1],'markerfacecolor',[1 1 1]);

figure(profileFigure)
figure(traceFigure)
figure(displayf)

%%

% go through the movie around this point
idx = pre_idx;
while vid.CurrentTime <= ft(post_idx)-ft(1)
    % show the bar spot in each frame
    idx = idx+1;
    im.CData = rgb2gray(vid.readFrame);
    
    bar_spot.XData = fps.forceProbePosition(1,idx)+p_(1);
    bar_spot.YData = fps.forceProbePosition(2,idx)+p_(2);
    
    bar_location.XData = [fps.CoM(idx), fps.CoM(idx)];
    bar_location_new.XData = [fps.CoM(idx), fps.CoM(idx)];

    barshape.YData = I_profile(:,idx);
    
    indicator.XData = ft(idx);
    indicator.YData = fps.CoM(idx);
    indicator_new.XData = ft(idx);
    indicator_new.YData = fps.CoM(idx);
    
    % ask for a click on the correct spot
    pnt = drawpoint(dispax,'Position',[fps.forceProbePosition(1,idx)+p_(1),fps.forceProbePosition(2,idx)+p_(2)]);
    figure(profileFigure)
    figure(traceFigure)
    figure(displayf)

    keydown = waitforbuttonpress;
    while keydown==0 || ~any(strcmp({' ','s'},displayf.CurrentCharacter))
        if keydown==0 && contains(get(get(gca,'parent'),'tag'),'big_fig')
            butt_pnt = get(gca,'CurrentPoint');
            pnt.Position = butt_pnt(1,1:2);
            newcom = ((pnt.Position - p_) * x_hat);
            newcom_xy = newcom .* x_hat' + p_;
            newcom = newcom + origin_idx;
            
            bar_location_new.XData = [newcom, newcom];
            bar_spot_new.XData = newcom_xy(1);
            bar_spot_new.YData = newcom_xy(2);
            indicator_new.YData = newcom;
        end
        keydown = waitforbuttonpress;
    end
    cmd_key = displayf.CurrentCharacter;
    
    switch cmd_key
        case ' ' 
            newfps.CoM(idx) = newcom;
            newfps.forceProbePosition(:,idx) = newcom_xy;
        case 's'
            % Bar hasn't moved
            newcom = normrnd(mu,sigma/1.5);
            newcom_xy = (newcom-origin_idx)*x_hat;
            newfps.forceProbePosition(:,idx) = newcom_xy;
            newfps.CoM(idx) = newcom;
        otherwise
    end
    delete(pnt)
end

plot(ft,newfps.CoM,'color',[.7 0 0],'parent',traceAxes);
plot(ft,newfps.CoM,'color',[.7 0 0],'parent',traceAxes);

newbutton = questdlg('Save trial?','CoM fixed?','Yes');

if strcmp(newbutton,'Yes')
    trial.forceProbeStuff = newfps;
    save(trial.name, '-struct', 'trial')
    
elseif strcmp(newbutton,'Cancel')
   error('stopping entire redArtifact clicky routine') 
end