function varargout = EpiFlash2TShowSpikes(fig,handles,savetag,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('closefig',1,@isnumeric);
parse(p,varargin{:});

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(fig) && p.Results.closefig 
    fig = figure(69); clf
elseif isempty(fig) || ~ishghandle(fig) 
    fig = figure(69+trials(1)); clf
else
end

set(fig,'tag',mfilename);
if strcmp(get(fig,'type'),'figure'), set(fig,'name',mfilename);end

if ~isfield(handles.trial,'spikes')
    warning('No spikes')
    return
end
trial = handles.trial;

[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
fprintf('%s %s trial %s has %d Spikes\n', [dateID '_' flynum '_' cellnum], protocol,trialnum,length(trial.spikes));

t = makeInTime(trial.params);
fs = trial.params.sampratein; %% sample rate
switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   

patch = trial.(invec1);
cutoff = 2000;%%cutoff frequencies for high-pass filtering patch
[x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');%%2nd order hp filter
patch_lo = filter(x_lo, y_lo, patch)';

spike_waveform = trial.voltage_1;
spike_waveform(:) = 0;
spikelocs = trial.spikes;
[~,spikelocs] = intersect(t,spikelocs);
spike_waveform(spikelocs) = .2;

%%
ax = subplot(3,1,[1],'parent',fig);
cla(ax,'reset')
title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.stimDurInSec) ' s duration'])

plot(ax,t,patch_lo,'color',[1 .7 .7],'tag',savetag); hold on
spikes = t(spikelocs);
spikelocs_ = spikelocs(spikes>-trial.params.preDurInSec+.1);
spikes = spikes(spikes>-trial.params.preDurInSec+.1);
plot(ax,t(spikelocs_),patch_lo(spikelocs_),'.','color',[.7 0 0])

plot(ax,t(1:length(spike_waveform)),10*(spike_waveform-mean(spike_waveform))+mean(patch)-5,'tag',savetag); hold on
axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
%xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax');

drawnow

%%
ax = subplot(3,1,[2],'parent',fig);
cla(ax,'reset')
title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.stimDurInSec) ' s duration'])

plot(ax,t,trial.(invec2),'color',[1 0 0],'tag',savetag); hold on

plot(ax,t(1:length(spike_waveform)),diff([min(trial.current_2(:)) max(trial.(invec2)(:))])/.5*(spike_waveform-mean(spike_waveform))+min(trial.(invec2)(:))-5,'tag',savetag,'color',[.2 .4 .9]); hold on
axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
%xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax_2');

drawnow


%%
ax = subplot(3,1,3,'parent',fig);
cla(ax)
plot(ax,t,EpiFlashStim(trial.params),'color',[0 0 1],'tag',savetag); hold on
plot(ax,t,trial.exposure,'color',[0 .7 .3],'tag',savetag); hold on
axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
%xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

title([])
box(ax,'off');
set(ax,'TickDir','out');

drawnow

%%
% if ~isfield(trial,'spikes')
%     [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
%     fprintf('Saving %d Spikes for %s %s trial %s\n', length(spikes),[dateID '_' flynum '_' cellnum], protocol,trialnum);
%     
%     trial.spikes = spikes;
%     save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
%     handles.trial = trial;
% end
varargout = {fig,handles,spikes};