function h = EpiFlash2TAveProbeTraces(h,handles,savetag)

% setupStimulus
delete(get(h,'children'));
panl = panel(h);
panl.pack('v',{1/3 1/3 1/3})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

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

switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   
switch trial.params.mode_1; case 'VClamp', y_units = 'pA'; case 'IClamp', y_units = 'mV'; otherwise; y_units = 'mV'; end   
switch trial.params.mode_2; case 'VClamp', y_units2 = 'pA'; case 'IClamp', y_units2 = 'mV'; otherwise; y_units2 = 'mV'; end   

y = zeros(length(x),length(trials));
y_2 = zeros(length(x),length(trials));
prb = zeros(length(ft),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(invec1);
    y_2(:,t) = trial.(invec2);
    prb(:,t) = trial.forceProbeStuff.CoM;
%     prb(:,t) =  prb(:,t)- mean(prb(ft<0,t));
end

clrs = parula(length(trials)+2);
clrs = clrs(1:length(trials),:);

ax = panl(1).select();
for t = 1:length(trials)
    plot(ax,x,y(:,t),'color',clrs(t,:),'tag',savetag); hold on
    %plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);
end
% xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
set(ax,'tag','response_ax');

ax = panl(2).select();
for t = 1:length(trials)
    plot(ax,x,y_2(:,t),'color',clrs(t,:),'tag',savetag); hold on
    % plot(ax,x,mean(y_2,2),'color',[.7 0 0],'tag',savetag);
end
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
set(ax,'tag','response_ax_2');
ylabel(ax,y_units2);

ax = panl(3).select();
for t = 1:length(trials)
    plot(ax,ft,prb(:,t),'color',clrs(t,:),'tag',savetag); hold on;
end
box(ax,'off');
set(ax,'TickDir','out');
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
set(ax,'tag','stimulus_ax');

