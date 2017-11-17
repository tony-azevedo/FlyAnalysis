function h = Sweep2TForceProbe(h,handles,savetag)

if ~isfield(handles.trial,'forceProbeStuff')
    fprintf('No profiles\n');
    beep
    return
else
    I_profile = handles.trial.forceProbeStuff.keimograph;
end

set(h,'tag',mfilename);
trial = handles.trial;
x = makeTime(trial.params);

switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   

y = trial.(invec1);
ax = subplot(3,1,1,'parent',h);  cla(ax,'reset')
plot(ax,x,y,'color',[.7 0 0],'tag',savetag);
xlim([0 trial.params.durSweep])
box(ax,'off');
set(ax,'TickDir','out');
%ylabel(ax,y_units);
[prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);
title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]));
set(ax,'tag','response_ax');

y = trial.(invec2);
ax = subplot(3,1,2,'parent',h);  cla(ax,'reset')
plot(ax,x,y,'color',[.7 0 0],'tag',savetag);
xlim([0 trial.params.durSweep])
box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax2');

ax = subplot(3,1,3,'parent',h); cla(ax,'reset')

h2 = postHocExposure(trial,size(I_profile,2));
frame_times = x(h2.exposure);

origin = find(handles.trial.forceProbeStuff.EvalPnts(1,:)==0&handles.trial.forceProbeStuff.EvalPnts(2,:)==0);
x_hat = handles.trial.forceProbeStuff.EvalPnts(:,origin+1);
CoM = handles.trial.forceProbeStuff.forceProbePosition';
CoM = CoM*x_hat;

ax = subplot(3,1,3,'parent',h);
plot(ax,frame_times,CoM(1:length(frame_times))), hold(ax,'on');
plot(ax,frame_times,CoM(1:length(frame_times)),'.b'), hold(ax,'off');
axis(ax,'tight')
xlim([0 trial.params.durSweep])
xlabel(ax,'s')
ylabel(ax,'CoM (pixels)')

