function varargout = EpiFlash2TAlignSpikes(fig,handles,savetag,varargin)

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

if ~isfield(handles.trial,'spikes') || isempty(handles.trial.spikes)
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

patch = trial.(invec1); if strcmp(trial.params.mode_1,'IClamp'), patch = filterMembraneVoltage(patch,trial.params.sampratein);end
altin = trial.(invec2);

DT = 0.02; % 20 ms window
DT_pre = 0.003;
DT_post = 0.017;

spike_trajects = nan(DT*trial.params.sampratein,length(trial.spikes));
alt_trajects = nan(DT*trial.params.sampratein,length(trial.spikes));
ctr_trajects = nan(DT*trial.params.sampratein,length(trial.spikes));

spikes = trial.spikes;
if any(trial.spikes>50)
    spikes = t(spikes);
end
for sp_idx = 1:length(spikes)        
    spidx = find(t==spikes(sp_idx));
    if spidx+DT_post*trial.params.sampratein>length(altin)
        break
    end
    spike_trajects(:,sp_idx) = patch(spidx-DT_pre*trial.params.sampratein+1:spidx+DT_post*trial.params.sampratein);
    alt_trajects(:,sp_idx) = altin(spidx-DT_pre*trial.params.sampratein+1:spidx+DT_post*trial.params.sampratein);
    
    randidx = randi([200 length(altin)-200],1);
    ctr_trajects(:,sp_idx) = altin(randidx-DT_pre*trial.params.sampratein+1:randidx+DT_post*trial.params.sampratein);
end


t_win = ((1:DT_pre*trial.params.sampratein+DT_post*trial.params.sampratein)-DT_pre*trial.params.sampratein)/trial.params.sampratein;

%% Random plot index
i = randi(size(spike_trajects,2),1);

%%
delete(findobj(fig,'type','axes'));
ax = subplot(3,1,[1],'parent',fig);
cla(ax,'reset')
title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.stimDurInSec) ' s duration'])

plot(ax,t_win,spike_trajects,'color',[1 .7 .7],'tag',savetag); hold on
plot(ax,t_win,spike_trajects(:,i),'color',[1 0 .0],'tag',num2str(i)); hold on
plot(ax,t_win,nanmean(spike_trajects,2),'color',[.1 0 0],'tag',savetag); hold on

axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
%xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','unlink');

drawnow

%%
ax = subplot(3,1,[2],'parent',fig);
cla(ax,'reset')

plot(ax,t_win,alt_trajects,'color',[.7 .7 1],'tag',savetag); hold on
plot(ax,t_win,alt_trajects(:,i),'color',[0 0 1],'tag',num2str(i)); hold on
plot(ax,t_win,nanmean(ctr_trajects,2),'color',[0 0 0],'tag',savetag); hold on
plot(ax,t_win,nanmean(alt_trajects,2),'color',[0 0 .7],'tag',savetag); hold on

axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
%xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','unlink');

drawnow


%%
% ax = subplot(3,1,3,'parent',fig);
% cla(ax)
% plot(ax,t,EpiFlashStim(trial.params),'color',[0 0 1],'tag','unlink'); hold on
% % plot(ax,t,trial.exposure,'color',[0 .7 .3],'tag',savetag); hold on
% axis(ax,'tight')
% % xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
% %xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
% 
% title([])
% box(ax,'off');
% set(ax,'TickDir','out');

drawnow

