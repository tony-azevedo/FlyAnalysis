function h = EpiFlash2TForceProbeOnKeimograph(h,handles,savetag)

if ~isfield(handles.trial,'forceProbeStuff')
    fprintf('No profiles\n');
    beep
    return
else
    I_profile = load(regexprep(handles.trial.name,'_Raw_','_keimograph_'),'keimograph');
    I_profile = I_profile.keimograph;
end

ax = subplot(1,1,1,'parent',h);  cla(ax,'reset')
% im = imshow(I_profile,[0 2*quantile(I_profile(:),0.975)],'parent',ax);
h = pcolor(I_profile);
set(h,'EdgeColor','none');
colormap(ax,'gray')
hold(ax,'on')

% where the bar line is initially
origin = find(handles.trial.forceProbeStuff.EvalPnts(1,:)==0&handles.trial.forceProbeStuff.EvalPnts(2,:)==0);

% The direction of movement
x_hat = handles.trial.forceProbeStuff.EvalPnts(:,origin+1);

CoM = handles.trial.forceProbeStuff.forceProbePosition';
CoM = CoM*x_hat;

% forceProbeStuff.Origin is actually a useless number. A more useful number
% is the position of the handdrawn prob line

plot([1 size(I_profile,2)],[origin origin],'color',[1    0.6    0.3]);

plot(1:size(I_profile,2),CoM+origin,'marker','o','markersize',2,'markerfacecolor',[0.3    0.6    1],'markeredgecolor',[0.3    0.6    1],'linestyle','none');

