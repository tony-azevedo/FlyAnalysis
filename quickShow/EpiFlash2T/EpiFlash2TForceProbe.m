function h = EpiFlash2TForceProbe(h,handles,savetag)

if ~isfield(handles.trial,'forceprobeprofiles');
    fprintf('No profiles\n');
    beep
    return
else
    I_profile = handles.trial.forceprobeprofiles;
end

set(h,'tag',mfilename);
trial = handles.trial;
x = makeTime(trial.params);

switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   

y = trial.(invec1);
ax = subplot(3,1,1,'parent',h);  cla(ax,'reset')
plot(ax,x,y,'color',[.7 0 0],'tag',savetag);
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
text(-.09,mean(mean(y(x<0),2),1),...
    [num2str(trial.params.displacement *3) ' \mum'],...
    'fontsize',7,'parent',ax,'tag',savetag)
box(ax,'off');
set(ax,'TickDir','out');
%ylabel(ax,y_units);
[prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);
title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]));
set(ax,'tag','response_ax');

y = trial.(invec2);
ax = subplot(3,1,2,'parent',h);  cla(ax,'reset')
plot(ax,x,y,'color',[.7 0 0],'tag',savetag);
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
text(-.09,mean(mean(y(x<0),2),1),...
    [num2str(trial.params.displacement *3) ' \mum'],...
    'fontsize',7,'parent',ax,'tag',savetag)
box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax2');

ax = subplot(3,1,3,'parent',h); cla(ax,'reset')
plot(ax,x,EpiFlashStim(trial.params),'color',[0 0 1],'tag',savetag); hold on;
box(ax,'off');
set(ax,'TickDir','out');
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
% xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
set(ax,'tag','stimulus_ax');

h2 = postHocExposure(trial,size(I_profile,2));
frame_times = x(h2.exposure);

r = repmat((1:size(I_profile,1))',1,size(I_profile,2));
CoM = nansum(r.*I_profile,1)./nansum(I_profile,1);
CoM = CoM-mean(CoM(frame_times<0));

ax = subplot(3,1,3,'parent',h);
plot(ax,frame_times,CoM)
axis(ax,'tight')
xlabel(ax,'s')
ylabel(ax,'CoM (pixels)')

