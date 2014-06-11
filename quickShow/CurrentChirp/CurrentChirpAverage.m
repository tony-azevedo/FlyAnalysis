function h = PiezoChirpAverage(h,handles,savetag)

% see also AverageLikeSongs
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
ax = subplot(3,1,[1 2],'parent',h);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

y_name = 'voltage';
y_units = 'mV';

if length(trial.(y_name))<length(x)
    x = x(1:length(trial.(y_name)));
end
y = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name)(1:length(x));
end
plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);
axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.25,trial.params.postDurInSec)])
xlabel('Time (s)');

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
title(ax,sprintf('%s : %d-%d Hz %.2f \\mum',...
    [prot '.' d '.' fly '.' cell '.' trialnum],...
    trial.params.freqStart,...
    trial.params.freqEnd,...
    trial.params.amp));
%title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
set(ax,'tag','response_ax');

ax = subplot(6,1,5,'parent',h);
freqramp = (trial.params.freqEnd-trial.params.freqStart)/trial.params.stimDurInSec * x + trial.params.freqStart;
freqramp(x<0 & x>=trial.params.stimDurInSec) = 0;

plot(ax,x,freqramp,'color',[0 0 1],'tag',savetag); hold on;
text(-.1,5.01,...
    [num2str(trial.params.freqStart) '-' ...
    num2str(trial.params.freqEnd) ' Hz ' ...
    num2str(trial.params.amp) ' pA'],...
    'fontsize',7,'parent',ax,'tag',savetag)

box(ax,'off');
set(ax,'TickDir','out');
axis(ax,'tight');
ylabel('Hz');

xlim([-.1 trial.params.stimDurInSec+ min(.25,trial.params.postDurInSec)])
set(ax,'tag','ramp_ax');

ax = subplot(6,1,6,'parent',h);
plot(ax,x,trial.current(1:length(x)),'color',[0 0 1],'tag',savetag); hold on;

box(ax,'off');
set(ax,'TickDir','out');
axis(ax,'tight');

xlim([-.1 trial.params.stimDurInSec+ min(.25,trial.params.postDurInSec)])
set(ax,'tag','stimulus_ax');

