function h = AverageLikeVoltagePlateaux(h,handles,savetag)

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

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
    outname = 'current';
    outunits = 'pA';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
    outname = 'voltage';
    outunits = 'mV';
end

y = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name);
end
plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

%title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

ax = subplot(3,1,3,'parent',h);
plot(ax,x,trial.(outname),'color',[0 0 1],'tag',savetag); hold on;
text(-.1,5.01,[num2str(trial.params.plateaux(1)) ' ' outunits],'fontsize',7,'parent',ax,'tag',savetag)
ylabel(ax,outunits);

box(ax,'off');
set(ax,'TickDir','out');

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
%ylim([4.5 5.5])
