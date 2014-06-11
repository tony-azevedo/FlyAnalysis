function varargout = DFoverFoverDV_off(h,handles,savetag,varargin)
% See also DFoverFoverDV

p = inputParser;
p.addParameter('BGCorrectImages',false,@islogical);
parse(p,varargin{:});

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
trials = excludeTrials('trials',trials,'name',handles.trial.name);
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
voltageplateaux_off = nan(length(trials),length(step_times));
dFoverFplateaux = nan(length(trials),length(step_times));
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
eval(sprintf('protocol = %s();',trial.params.protocol));    
if isfield(trial.params,'combinedTrialBlock')
    protocol.setParams('-q',rmfield(trial.params,'combinedTrialBlock'));
else
    protocol.setParams('-q',trial.params);
end
 
voltage_stim = protocol.getStimulus.voltage;

for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    if isfield(trial,'dFoverF')
        if 0
            figure
            plot(trial.exposure_time,trial.dFoverF), hold on
        end
        trial_vstim = voltage_stim + mean(voltage_stim(x<0));
        for s= 1:length(step_times)
            % take the points during the step, and after the step
            voltageplateaux_off(t,s) = mean(trial_vstim(x > step_times(s)+diff(step_times(1:2)) - plateau & x < step_times(s)+diff(step_times(1:2))));
            
            if p.Results.BGCorrectImages
                dFoverF_fulltrace = dFoverF_bgcorr_trace(trial);
            else
                dFoverF_fulltrace = dFoverF_withbg_trace(trial);
            end
                        
            dFoverFplateaux(t,s) = mean(dFoverF_fulltrace(trial.exposure_time > step_times(s)+diff(step_times(1:2)) - plateau & trial.exposure_time < step_times(s)+diff(step_times(1:2))));
            if 0 % step through and make sure the differences are calculated correctly
                plot(trial.exposure_time(find(trial.exposure_time > step_times(s)+diff(step_times(1:2)) - plateau,1)),dFoverFplateaux(t,s),...
                    'or'), hold on
                pause
            end

        end
        
    end
end

% voltageplateaux_off = voltageplateaux_off(~isnan(voltageplateaux_off));
% dFoverFplateaux = dFoverFplateaux(~isnan(dFoverFplateaux));

dV = voltageplateaux_off(:,2:2:end) - voltageplateaux_off(:,1:2:end);
[~,order] = sort(nanmean(dV,1));
dV = dV(:,order);
dF = dFoverFplateaux(:,2:2:end) - dFoverFplateaux(:,1:2:end);
dF = dF(:,order);

dV = dV((~isnan(dV(:,1))),:);
dF = dF((~isnan(dF(:,1))),:);

ax = subplot(1,1,1,'parent',h);
cla(ax,'reset')
for r = 1:size(dV,1)
    plot(ax,dV(r,:),dF(r,:),'+','color',[.3 1 .3],'tag',savetag); hold on
end

plot(ax,mean(dV,1),mean(dF,1),'o','color',[0 .7 0],'MarkerFaceColor',[0 .7 0],'tag',savetag);


[~,dateID,flynum,cellnum,] = extractRawIdentifiers(trial.name);

title(ax,[dateID '.' flynum '.' cellnum ' (%\DeltaF/F) / \DeltaV '  sprintf('.%d',trials)]);
ylabel(ax,'%\DeltaF / F');
xlabel(ax,'\DeltaV (mV)')
set(ax,'xlim',[mean(get(ax,'xlim'))-.5*1.1*diff(get(ax,'xlim')) mean(get(ax,'xlim'))+.5*1.1*diff(get(ax,'xlim'))]);
% axis(ax,'tight')
% xlim([-.5 trial.params.stimDurInSec+ min(.5,trial.params.postDurInSec)])
plot(ax,get(ax,'xlim'),[0 0],':k');
plot(ax,[0 0],get(ax,'ylim'),':k');
box(ax,'off');
set(ax,'TickDir','out');
textbp(sprintf('BG corrected: %d',p.Results.BGCorrectImages));

varargout = {h,dV,dF};