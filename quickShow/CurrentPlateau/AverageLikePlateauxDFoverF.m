function h = AverageLikePlateauxDFoverF(h,handles,savetag)

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

min_exposures = Inf;
hasDFoverF = 0;
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    if isfield(trial,'dFoverF')
        min_exposures = min(min_exposures,length(trial.dFoverF));
        hasDFoverF = hasDFoverF+1;
    end
end

dFoverF = zeros(hasDFoverF,min_exposures);
exposures = zeros(hasDFoverF,length(trial.exposure));
hasDFoverF = 0;
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name);
    if isfield(trial,'dFoverF')
        hasDFoverF = hasDFoverF+1;
        dFoverF(hasDFoverF,:) = trial.dFoverF(1:min_exposures);
        exposures(hasDFoverF,:) = trial.exposure;
    end
end

ax = subplot(3,1,1,'parent',h);
plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

ax = subplot(3,1,2,'parent',h);
dFoverF_x = x(exposures(1,:)>0);
dFoverF_x = dFoverF_x(1:min_exposures);

plot(ax,dFoverF_x,dFoverF,'color',[.7, 1 .7],'tag',savetag); hold on
plot(ax,dFoverF_x,mean(dFoverF,1),'color',[0 .7 0],'tag',savetag);

axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

%title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

ax = subplot(3,1,3,'parent',h);
cla(ax,'reset')
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
plot(ax,x,trial.(outname),'color',[0 0 1],'tag',savetag); hold on;
text(-.1,5.01,[num2str(trial.params.plateaux(1)) ' ' outunits],'fontsize',7,'parent',ax,'tag',savetag)
ylabel(ax,outunits);
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
ylims = get(ax,'ylim');

plot(ax,x,trial.exposure*diff(ylims)+ylims(1),'color',[1 1 1]*.9,'tag',savetag); hold on;
set(ax,'children',flipud(get(ax,'children')));


box(ax,'off');
set(ax,'TickDir','out');

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

