function h = CurrentStepAverage(h,handles,savetag,varargin)
% see also CurrentSineAverage
p = inputParser;
p.PartialMatching = 0;
p.addParameter('callingfile','',@ischar);
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
    end1 = '_1';
    end2 = '_2';   
else
    end1 = '';
end
dual = exist('end2','var');

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.(['mode' end1])))
    y_name = 'voltage';
    y_units = 'mV';
    outname = 'current';
    outunits = 'pA';
elseif sum(strcmp('VClamp',trial.params.(['mode' end1])))
    y_name = 'current';
    y_units = 'pA';
    outname = 'voltage';
    outunits = 'mV';
end
if dual
    if sum(strcmp({'IClamp','IClamp_fast'},trial.params.(['mode' end2])))
        y_name2 = 'voltage';
        y_units2 = 'mV';
        outname2 = 'current';
        outunits2 = 'pA';
    elseif sum(strcmp('VClamp',trial.params.(['mode' end2])))
        y_name2 = 'current';
        y_units2 = 'pA';
        outname2 = 'voltage';
        outunits2 = 'mV';
    end
end

y = zeros(length(x),length(trials));
if dual, y2 = y; end

for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.([y_name end1])(1:length(x));
    if dual
        y2(:,t) = trial.([y_name2 end2])(1:length(x));
    end
end

if dual 
    if isempty(p.Results.callingfile)
        ax = subplot(3,1,1,'parent',h);
    elseif strcmp(p.Results.callingfile,'CurrentStepFamMatrix')
        ax = subplot(3,2,[1 3],'parent',h);
    end
else
    ax = subplot(3,1,[1 2],'parent',h);
end
plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);
axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]));
text(-.09,mean(mean(y(x<0),2),1),...
    [prot '.' d '.' fly '.' cell '.' trialnum ': ' num2str(trial.params.step) ' ' outunits],...
    'fontsize',7,'parent',ax,'tag',savetag)

set(ax,'tag','response_ax');

if dual
    if isempty(p.Results.callingfile)
        ax = subplot(3,1,2,'parent',h);
    elseif strcmp(p.Results.callingfile,'CurrentStepFamMatrix')
        ax = subplot(3,2,[2 4],'parent',h);
    end

    plot(ax,x,y2,'color',[1, .7 .7],'tag',savetag); hold on
    plot(ax,x,mean(y2,2),'color',[.7 0 0],'tag',savetag);
    axis(ax,'tight')
    xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
    
    box(ax,'off');
    set(ax,'TickDir','out');
    ylabel(ax,y_units2);
    set(ax,'tag','response_ax');

end

if dual && strcmp(p.Results.callingfile,'CurrentStepFamMatrix')
    ax = subplot(3,2,5,'parent',h);
else
    ax = subplot(3,1,3,'parent',h);
end
plot(ax,x,trial.([outname end1])(1:length(x)),'color',[0 0 .5],'tag',savetag); hold on;
axis(ax,'tight')
box(ax,'off');
set(ax,'TickDir','out');
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
set(ax,'tag','stimulus_ax');

if dual
    if strcmp(p.Results.callingfile,'CurrentStepFamMatrix')
        ax = subplot(3,2,6,'parent',h);
    end
    plot(ax,x,trial.([outname2 end2])(1:length(x)),'color',[.5 .5 1],'tag',savetag); hold on;
    axis(ax,'tight')
    box(ax,'off');
    set(ax,'TickDir','out');
    xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
    set(ax,'tag','stimulus_ax');
end

