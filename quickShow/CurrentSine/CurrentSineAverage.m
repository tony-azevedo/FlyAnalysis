function h = CurrentSineAverage(h,handles,savetag)
% see also AverageLikeSongs

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
    end2 = '_1';   
else
    end1 = '';
end
dual = exist('var','end2');

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
    ax = subplot(3,1,1,'parent',h);
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



ax = subplot(3,1,3,'parent',h);
plot(ax,x,trial.(outname)(1:length(x)),'color',[0 0 1],'tag',savetag); hold on;
text(-.1,5.01,...
    [num2str(trial.params.freq) ' Hz ' num2str(trial.params.amp) ' ' outunits],...
    'fontsize',7,'parent',ax,'tag',savetag)

box(ax,'off');
set(ax,'TickDir','out');

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
