function h = DFoverFoverDV(h,handles,savetag)

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

%% assuming the normal structure of the thing
plateau = .6-.46; %empirical
step_times = 0:handles.trial.params.plateauDurInSec:handles.trial.params.stimDurInSec;
voltageplateaux = zeros(length(trials),length(step_times));
dFoverFplateaux = zeros(length(trials),length(step_times));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    for s= 1:length(step_times)
        voltageplateaux(t,s) = mean(trial.voltage(x > step_times(s)-plateau & x < step_times(s)));
        dFoverFplateaux(t,s) = mean(trial.dFoverF(trial.exposure_time > step_times(s)-plateau & trial.exposure_time < step_times(s)));
    end
end
    
dV = voltageplateaux(:,2:2:end) - voltageplateaux(:,1:2:end);
[~,order] = sort(mean(dV));
dV = dV(:,order);
dF = dFoverFplateaux(:,2:2:end) - dFoverFplateaux(:,1:2:end);
dF = dF(:,order);

ax = subplot(1,1,1,'parent',h);
for r = 1:size(dV,1)
    plot(ax,dV(r,:),dF(r,:),'.','color',[0 .7 0],'tag',savetag); hold on
end

plot(ax,mean(dV,1),mean(dF,1),'color',[0 .7 0],'tag',savetag);

[~,dateID,flynum,cellnum,] = extractRawIdentifiers(trial.name);
%   [mfilename '_' protocol '_' dateID '_' flynum '_' cellnum '_' trialnum]


title(ax,['(%\DeltaF/F) / \DeltaV ' dateID '.' flynum '.' cellnum  sprintf('.%d',trials)]);
ylabel(ax,'%\DeltaF / F');
xlabel(ax,'\DeltaV (mV)')
% axis(ax,'tight')
% xlim([-.5 trial.params.stimDurInSec+ min(.5,trial.params.postDurInSec)])
box(ax,'off');
set(ax,'TickDir','out');