function varargout = SweepSpikeRate(fig,handles,savetag,varargin)

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


if isfield(handles.trial,'spikes')
    trial = handles.trial;
    
    [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
    fprintf('%s %s trial %s has %d Spikes\n', [dateID '_' flynum '_' cellnum], protocol,trialnum,length(trial.spikes));
    
    t = makeInTime(trial.params);
    fs = trial.params.sampratein; %% sample rate
    patch = trial.voltage-mean(trial.voltage);
    cutoff = 2000;%%cutoff frequencies for high-pass filtering patch
    [x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');%%2nd order hp filter
    patch = filter(x_lo, y_lo, patch)';
    
    spike_waveform = trial.voltage;
    spike_waveform(:) = 0;
    spikelocs = trial.spikes;
    [~,spikelocs] = intersect(t,spikelocs);
    spike_waveform(spikelocs) = 1;
    
elseif ~isfield(handles.trial,'spikes')
    
    error('No spikes field');
        
end

fr = spike_waveform;
% slide a window along
% count the number of spikes
% divide by the window length, that give #/s
DT = .05; % 50 ms window;
N = fs*DT; % # number of samples
fr = smooth(fr,N)*N/DT;

ax = subplot(3,1,1,'parent',fig);
cla(ax,'reset')
title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.durSweep) ' s duration'])

hold(ax,'on')
plot(ax,t,patch,'color',[1 .7 .7],'tag',savetag);
% spikes = t(spikelocs);
% spikelocs_ = spikelocs(spikes>.1);
% spikes = spikes(spikes>-trial.params.preDurInSec+.1);
% plot(ax,t(spikelocs_),patch(spikelocs_),'.','color',[.7 0 0],'tag',savetag)
% plot(ax,t,spike_waveform,'tag',savetag); hold on

ax = subplot(3,1,2,'parent',fig);
plot(ax,t,fr,'tag',savetag); hold on

axis(ax,'tight')
% xlim(ax,[-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax');

drawnow

%
ax = subplot(3,1,3,'parent',fig);
cla(ax)
plot(repmat(t(spikelocs),1,2)',repmat([0 1],length(spikelocs),1)','color',[0 0 0])
axis(ax,'tight')
% xlim(ax,[-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])

title([])
box(ax,'off');
set(ax,'TickDir','out');

drawnow

varargout = {fig,handles,trial.spikes};