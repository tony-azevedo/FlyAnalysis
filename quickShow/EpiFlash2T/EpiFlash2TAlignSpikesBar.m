function varargout = EpiFlash2TAlignSpikesBar(fig,handles,savetag,varargin)

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

if ~isfield(handles.trial,'forceProbeStuff') || isempty(handles.trial.forceProbeStuff)
    warning('No profile')
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
altin = trial.(invec2);
bar = trial.forceProbeStuff.CoM;


ft = postHocExposure(trial);
sri = trial.params.sampratein;
ft = ft.exposure;
frametimes = t(ft);
frames = find(ft);
fr = sri/median(diff(frames));

DT = .1;
DT_pre = 0.02;
DT_pre = ceil(DT_pre*fr)/fr;
DT = ceil(DT*fr)/fr; % 20 ms window
DT_post = DT-DT_pre;
DF_pre = DT_pre*fr;
DF_post = DT_post*fr;

spike_trajects = nan(ceil(DT*sri),length(trial.spikes));
alt_trajects = spike_trajects;
ctr_trajects = spike_trajects;

bar_trajects = nan(DT*fr,length(trial.spikes)); 
bar_t_trajects = bar_trajects;
bar_ctr_trajects = bar_trajects;

spikes = trial.spikes;
if any(trial.spikes>50)
    spikes = t(spikes);
end;
for sp_idx = 1:length(spikes)        
    spidx = find(t==spikes(sp_idx));
    [~,fridx] = min(abs(frametimes-t(spidx)));
    if spidx+DT_post*sri>length(altin)
        break
    end
    if fridx+DF_post>length(bar)
        break
    end
    spike_trajects(:,sp_idx) = patch(spidx-DT_pre*sri+1:spidx+DT_post*sri);
    alt_trajects(:,sp_idx) = altin(spidx-DT_pre*sri+1:spidx+DT_post*sri);
    
    randidx = randi([round(trial.params.sampratein*DT) length(altin)-round(trial.params.sampratein*DT)],1);
    ctr_trajects(:,sp_idx) = altin(randidx-DT_pre*sri+1: randidx+DT_post*sri);
    
    fridx_rnd = randi([round(fr*DT) length(bar)-round(fr*DT)],1);
    
    % There is a fence post problem here, for some reason.
    sp_idx
    bar_trajects(:,sp_idx) = bar(fridx-DF_pre+1:fridx+DF_post)-bar(fridx);
    bar_t_trajects(:,sp_idx) = frametimes(fridx-DF_pre+1:fridx+DF_post)-t(spidx);
    bar_ctr_trajects(:,sp_idx) = bar(fridx_rnd-DF_pre+1:fridx_rnd+DF_post)-bar(fridx_rnd);
end


t_win = (0-DT_pre*sri+1:0+DT_post*sri)/sri;

%%
ax = subplot(3,1,[1],'parent',fig);
cla(ax,'reset')
title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.stimDurInSec) ' s duration'])

plot(ax,t_win,spike_trajects,'color',[1 .7 .7],'tag',savetag); hold on
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
bar_traject_bar = bar_trajects(:);
bar_traject_bar_t = bar_t_trajects(:);
[t,order] = sort(bar_traject_bar_t);
bar_traject_bar = bar_traject_bar(order);
bar_traject_bar = smooth(bar_traject_bar,28);
bar_traject_ctr = bar_ctr_trajects(order);
bar_traject_ctr = smooth(bar_traject_ctr,28);

ax = subplot(3,1,3,'parent',fig);
cla(ax)
plot(ax,bar_t_trajects,bar_trajects,'color',[.7 .7 1],'tag','unlink'); hold on
plot(ax,t,bar_traject_bar,'color',[0 0 .7],'tag','unlink'); hold on
plot(ax,t,bar_traject_ctr,'color',[0 0 0],'tag','unlink'); hold on
axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
%xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

title([])
box(ax,'off');
set(ax,'TickDir','out');

drawnow

