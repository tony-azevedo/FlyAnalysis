function h = EpiFlash2TCorrelation(h,handles,savetag)

set(h,'tag',mfilename);
ax = subplot(3,1,[1 2],'parent',h);  cla(ax,'reset')
trial = handles.trial;
x = makeInTime(trial.params);

if strcmp('IClamp',trial.params.mode_1)
    y_name = 'voltage_1';
    y_units = 'mV';
elseif strcmp('VClamp',trial.params.mode_1)
    y_name = 'current_1';
    y_units = 'pA';
end
if strcmp('IClamp',trial.params.mode_2)
    y_name2 = 'voltage_2';
    y_units2 = 'mV';
elseif strcmp('VClamp',trial.params.mode_2)
    y_name2 = 'current_2';
    y_units2 = 'pA';
end

[corr1to2,lags] = xcorr(trial.(y_name)-mean(trial.(y_name)),trial.(y_name2)-mean(trial.(y_name2)));

    
ax = subplot(1,1,1);
plot(ax,lags,corr1to2,'color',[1, .7 .7],'tag',savetag); hold on
% xlim([-.5*trial.params.sampratein .5*trial.params.sampratein])

% box(ax,'off');
% set(ax,'TickDir','out');
% ylabel(ax,y_units);
% [prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);
% %title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]));
% set(ax,'tag','response_ax');


% ax = subplot(3,1,3,'parent',h); cla(ax,'reset')
% plot(ax,x,EpiFlashStim(trial.params),'color',[0 0 1],'tag',savetag); hold on;
% box(ax,'off');
% set(ax,'TickDir','out');
% xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
% % xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
% set(ax,'tag','stimulus_ax');

