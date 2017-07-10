function varargout = extractSpikes(fig,handles,savetag,varargin)

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
    patch = trial.voltage;
    spike_waveform = trial.voltage;
    spike_waveform(:) = 0;
    spikelocs = trial.spikes;
    [~,spikelocs] = intersect(t,spikelocs);
    spike_waveform(spikelocs) = .2;

elseif ~isfield(handles.trial,'spikes')
    
    trial = handles.trial;
    patch = trial.voltage;
    fs = 50000; %% sample rate
    t = makeInTime(trial.params);
    
    cutoff = 75;%%cutoff frequencies for high-pass filtering patch
    [x,y] = butter(2,cutoff/(fs/2),'high');%%2nd order hp filter
    fb_1 = filter(x, y, patch)';
    filtered_patch = conv(diff(fb_1),hanning(7),'same');
    
    spike_waveform = filtered_patch;
    
    [pks,spikelocs] = findpeaks(double(spike_waveform),'minpeakheight',mean(spike_waveform)+0.13, 'minpeakdistance',floor(.003*trial.params.sampratein/3));
    
    d1 = getpref('FigureMaking','CurrentFilter');
    if d1.SampleRate ~= trial.params.sampratein
        d1 = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',trial.params.sampratein);
    end
    
    spike_waveform = filtfilt(d1,spike_waveform);
end


%%
ax = subplot(3,1,[1 2],'parent',fig);
cla(ax,'reset')
title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.freq) ' Hz, ' num2str(handles.trial.params.displacement) ' V'])

plot(ax,t,patch,'color',[1 .7 .7],'tag',savetag); hold on
spikes = t(spikelocs);
spikelocs_ = spikelocs(spikes>-trial.params.preDurInSec+.1);
spikes = spikes(spikes>-trial.params.preDurInSec+.1);
plot(ax,t(spikelocs_),patch(spikelocs_),'.','color',[.7 0 0])

plot(ax,t(1:length(spike_waveform)),10*(spike_waveform-mean(spike_waveform))+mean(patch)-5,'tag',savetag); hold on
axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax');

drawnow

%%
ax = subplot(3,1,3,'parent',fig);
cla(ax)
plot(ax,t,trial.sgsmonitor,'color',[0 0 1],'tag',savetag); hold on
axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

title([])
box(ax,'off');
set(ax,'TickDir','out');

drawnow

%%
if ~isfield(trial,'spikes')
    [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
    fprintf('Saving %d Spikes for %s %s trial %s\n', length(spikes),[dateID '_' flynum '_' cellnum], protocol,trialnum);
    
    trial.spikes = spikes;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    handles.trial = trial;
end
varargout = {fig,handles,trial.spikes};