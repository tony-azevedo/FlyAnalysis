function fig = AverageLikeSteps(plotcanvas,handles,savetag)

if isfield(handles,'infoPanel')
    notes = get(handles.infoPanel,'userdata');
else
    a = dir([handles.dir '\notes_*']);

    fclose('all');
    handles.notesfilename = fullfile(handles.dir,a.name);
    notes = fileread(handles.notesfilename);
end

[start,fin] = getTrialBlock(notes,handles.currentPrtcl,handles.params.trial);
trials = findLikeTrials(handles.trial.name,'window',[start,fin],'datastruct',handles.prtclData);

h(trials(1)) = figure(100+trials(1));
set(h,'tag',mfilename);
ax = subplot(3,1,[1 2],'parent',h(trials(1)));
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);
voltage = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    voltage(:,t) = trial.voltage;
end
plot(ax,x,voltage,'color',[1, .7 .7]); hold on
plot(ax,x,mean(voltage,2),'color',[.7 0 0]);

xlim([-.1 handles.params.stimDurInSec+ .15])

%title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
box(ax,'off');
set(ax,'TickDir','out');

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

ax = subplot(3,1,3,'parent',h(trials(1)));
plot(ax,x,trial.sgsmonitor,'color',[0 0 1]); hold on;
text(-.1,5.01,[num2str(trial.params.displacement *3) ' \mum'],'fontsize',7,'parent',ax)

box(ax,'off');
set(ax,'TickDir','out');

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

xlim([-.1 handles.params.stimDurInSec+ .15])
%ylim([4.5 5.5])
