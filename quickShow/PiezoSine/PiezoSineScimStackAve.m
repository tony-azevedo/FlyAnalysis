function h = PiezoSineScimStackAve(h,handles,savetag,varargin)

% see also CurrentSineAverage
p = inputParser;
p.PartialMatching = 0;
p.addParameter('callingfile','',@ischar);
parse(p,varargin{:});

% setupStimulus
panl = panel(h);
panl.pack('v',{1/2 1/4 1/4})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
    delete(get(h,'children'));
end

set(h,'tag',mfilename);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

outname = 'sgsmonitor';
outunits = 'V';
stackTraceName = 'scimStackTrace';
if isfield(trial,'roiScimStackTrace') 
    stackTraceName = 'roiScimStackTrace';
    handles.trial.roiScimStackTrace = squeeze(handles.trial.roiScimStackTrace(:,:,1));
end

%y = zeros(length(x),length(trials));
exp_t = handles.trial.exposureTimes;
redtraces = nan(size(repmat(handles.trial.(stackTraceName)(:,1),1,length(trials))));
greentraces = nan(size(repmat(handles.trial.(stackTraceName)(:,1),1,length(trials))));

for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    %y(:,t) = trial.(y_name)(1:length(x));
    %     redtraces(1:length(trial.(stackTraceName)(:,1)),t) = ...
    %         trial.(stackTraceName)(:,1)/mean(trial.(stackTraceName)(exp_t<=0,1)) *100 -100;
    greentraces(1:length(trial.(stackTraceName)(:,2)),t) = ...
        trial.(stackTraceName)(:,2)/mean(trial.(stackTraceName)(exp_t<=0,2))*100 -100;
    %     redtraces(:,t) = trial.(stackTraceName)(:,1);
    %     greentraces(:,t) = trial.(stackTraceName)(:,2);
end

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
panl.title([mfilename '\_' d '\_' fly '\_' cell '\_' trialnum])

%plot(panl(1).select(),exp_t,traces(:,1),'color',[1, 0 1],'tag',savetag); hold on
%plot(panl(1).select(),exp_t,greentraces,'color',[.6, 1 .6],'tag',savetag); hold on
greentraces_sem = std(greentraces,[],2)/sqrt(size(greentraces,2));
greentrace = mean(greentraces,2);

sem_up = greentrace+greentraces_sem;
sem_dn = greentrace-greentraces_sem;

ptch = patch(...
    [trial.exposureTimes';flipud(trial.exposureTimes')],...
    [sem_dn;flipud(sem_up)],...
    [.9 .9 .9],...
    'EdgeColor','none','parent',panl(1).select(),'displayname','SEM');
hold(panl(1).select(),'on')
    
%plot(panl(1).select(),exp_t,traces(:,1),'color',[1, 0 1],'tag',savetag); hold on
plot(panl(1).select(),exp_t,nanmean(greentraces,2),'color',[0, .6 0],'tag',savetag); hold on
%plot(panl(1).select(),exp_t,nanmean(redtraces,2),'color',[1, .4 .4 ],'tag',savetag); hold on

ylims = [...
    min(sem_dn(trial.exposureTimes>exp_t(1)+.5 & trial.exposureTimes<exp_t(end)-.5)),...
    max(sem_up(trial.exposureTimes>exp_t(1)+.5 & trial.exposureTimes<exp_t(end)-.5))];
axis(panl(1).select(),'tight')

ylim(ylims);
box(panl(1).select(),'off');
set(panl(1).select(),'TickDir','out');
ylabel(panl(1).select(),'%\DeltaF/F');
set(panl(1).select(),'tag','imaging_ax');

% plot(panl(2).select(),x,y,'color',[1, .7 .7],'tag',savetag); hold on
% plot(panl(2).select(),x,mean(y,2),'color',[.7 0 0],'tag',savetag);
% axis(panl(2).select(),'tight')
% xlim([exp_t(1) exp_t(end)])
% box(panl(2).select(),'off');
% set(panl(2).select(),'TickDir','out');
% ylabel(panl(2).select(),y_units);
% set(panl(2).select(),'tag','response_ax');

plot(panl(3).select(),x,trial.(outname)(1:length(x)),'color',[0 0 .5],'tag',savetag); hold on;
axis(panl(3).select(),'tight')
box(panl(3).select(),'off');
set(panl(3).select(),'TickDir','out');
xlim([exp_t(1)+.5 exp_t(end)-.5])
set(panl(3).select(),'tag','stimulus_ax');
xlabel(panl(3).select(),'Time (s)');
ylabel(panl(3).select(),'pA');
text(exp_t(1),4.7,[sprintf('%.2f Hz',trial.params.freq)],'fontsize',8)


