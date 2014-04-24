function h = CurrentStepAverage(h,handles,savetag)

if isfield(handles,'infoPanel')
    notes = get(handles.infoPanel,'userdata');
else
    a = dir([handles.dir '\notes_*']);

    fclose('all');
    handles.notesfilename = fullfile(handles.dir,a.name);
    notes = fileread(handles.notesfilename);
end

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
ax = subplot(3,1,[1 2],'parent',h);  cla(ax,'reset')
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
    out_name = 'current';
    out_units = 'pA';
    
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
    out_name = 'voltage';
    out_units = 'mV';
end

if length(trial.(y_name))<length(x)
    x = x(1:length(trial.(y_name)));
end

y = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name);
end
plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);
title(ax,sprintf('%s',[mfilename '.' protocol '.' dateID '.' flynum '.' cellnum '.' trialnum]));

ax = subplot(3,1,3,'parent',h); cla(ax,'reset')
plot(ax,x,trial.(out_name),'color',[1 1 1]*.7,'tag',savetag); hold on;

ylabel(ax,out_units);
xlabel(ax,'Time(s)')
box(ax,'off');
set(ax,'TickDir','out');
axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
%ylim([4.5 5.5])
