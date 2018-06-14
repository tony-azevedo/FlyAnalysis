function h = EpiFlash2TFamProbeTraces(h,handles,savetag)

% setupStimulus
delete(get(h,'children'));
panl = panel(h);
panl.pack('v',{1/3 1/3 1/3})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

ax1 = panl(1).select();
ax2 = panl(2).select();
ax3 = panl(3).select();

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);
h2 = postHocExposure(handles.trial,length(trial.forceProbeStuff.CoM));
ft = x(h2.exposure);

ax1.XLim = [-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec];
ax2.XLim = [-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec];
ax3.XLim = [-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec];

blocktrials = findBlockTrials(handles.trial,handles.prtclData);

switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   
switch trial.params.mode_1; case 'VClamp', y_units = 'pA'; case 'IClamp', y_units = 'mV'; otherwise; y_units = 'mV'; end   
switch trial.params.mode_2; case 'VClamp', y_units2 = 'pA'; case 'IClamp', y_units2 = 'mV'; otherwise; y_units2 = 'mV'; end   

clrs = parula(length(blocktrials)+2);
clrs = flipud(clrs(1:length(blocktrials),:));

for bt_ind = 1:length(blocktrials)
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(bt_ind))));
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
    for t_ind = 1:length(trials)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))));
        plot(ax1,x,trial.(invec1),'color',clrs(bt_ind,:),'tag',savetag);  hold(ax1,'on')
        plot(ax2,x,trial.(invec2),'color',clrs(bt_ind,:),'tag',savetag); hold(ax2,'on')
        plot(ax3,ft,trial.forceProbeStuff.CoM(:),'color',clrs(bt_ind,:),'tag',savetag);  hold(ax3,'on')
    end 
end

ax1.YLabel.String = y_units;
ax2.YLabel.String = y_units2;
ax3.YLabel.String = 'CoM';
ax3.XLabel.String = '(s)';

