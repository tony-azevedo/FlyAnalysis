function h = CurrentSineAverageSingleTrode(h,handles,savetag,varargin)
% see also AverageLikeSongs
p = inputParser;
p.PartialMatching = 0;
p.addParameter('trode','',@ischar);
parse(p,varargin{:});

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if isfield(trial.params,'mode_1')
    trodenum = ['_' p.Results.trode];
else trodenum = ''; 
end

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.(['mode' trodenum])))
    y_name = 'voltage';
    y_units = 'mV';
    outname = 'current';
    outunits = 'pA';
elseif sum(strcmp('VClamp',trial.params.(['mode' trodenum])))
    y_name = 'current';
    y_units = 'pA';
    outname = 'voltage';
    outunits = 'mV';
end

y = zeros(length(x),length(trials));

for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.([y_name trodenum])(1:length(x));
end

ax = subplot(3,1,[1 2],'parent',h);
plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);
axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
text(-.09,mean(mean(y(x<0),2),1),...
    [num2str(trial.params.freq) ' Hz ' num2str(trial.params.amp) ' ' outunits],...
    'fontsize',7,'parent',ax,'tag',savetag)

box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]));
set(ax,'tag','response_ax');

ax = subplot(3,1,3,'parent',h);
plot(ax,x,trial.([outname trodenum])(1:length(x)),'color',[0 0 .5],'tag',savetag); hold on;

axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','stimulus_ax');


