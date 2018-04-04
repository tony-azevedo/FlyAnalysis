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
    fs = trial.params.sampratein; %% sample rate
    patch = trial.voltage;
    cutoff = 2000;%%cutoff frequencies for high-pass filtering patch
    [x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');%%2nd order hp filter
    patch_lo = filter(x_lo, y_lo, patch)';

    spike_waveform = trial.voltage;
    spike_waveform(:) = 0;
    spikelocs = trial.spikes;
    [~,spikelocs] = intersect(t,spikelocs);
    spike_waveform(spikelocs) = .2;

elseif ~isfield(handles.trial,'spikes')
    
    trial = handles.trial;
    patch = trial.voltage;
    fs = trial.params.sampratein; %% sample rate
    t = makeInTime(trial.params);

    cutoff = 2000;%%cutoff frequencies for high-pass filtering patch
    [x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');%%2nd order hp filter
    patch_lo = filter(x_lo, y_lo, patch)';

    
    cutoff = 75;%%cutoff frequencies for high-pass filtering patch
    [x_hi,y_hi] = butter(2,cutoff/(fs/2),'high');%%2nd order hp filter
    fb_1 = filter(x_hi, y_hi, patch_lo)';
    filtered_patch = conv(diff(fb_1),hanning(7),'same');
    
    spike_waveform = filtered_patch;
    
    [pks,spikelocs] = findpeaks(double(spike_waveform),'minpeakheight',mean(spike_waveform)+0.5, 'minpeakdistance',floor(.003*trial.params.sampratein/3));
    
    if ispref('FlyAnalysis','CurrentFilter')
        d1 = getpref('FlyAnalysis','CurrentFilter');
    end
    if ~ispref('FlyAnalysis','CurrentFilter') || d1.SampleRate ~= trial.params.sampratein
        d1 = designfilt('lowpassiir','FilterOrder',12,'PassbandFrequency',3e3,'PassbandRipple',0.2,'SampleRate',10e3);
        if ~ispref('FlyAnalysis','CurrentFilter')
            setpref('FlyAnalysis','CurrentFilter',d1);
        end
    end
    
    spike_waveform = filtfilt(d1,spike_waveform);
end


%%
ax = subplot(3,1,[1 2],'parent',fig);
cla(ax,'reset')
title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.stimDurInSec) ' s duration'])

plot(ax,t,patch_lo,'color',[1 .7 .7],'tag',savetag); hold on
spikes = t(spikelocs);
spikelocs_ = spikelocs(spikes>-trial.params.preDurInSec+.1);
spikes = spikes(spikes>-trial.params.preDurInSec+.1);
plot(ax,t(spikelocs_),patch(spikelocs_),'.','color',[.7 0 0])

plot(ax,t(1:length(spike_waveform)),10*(spike_waveform-mean(spike_waveform))+mean(patch)-5,'tag',savetag); hold on
axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
%xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax');

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
varargout = {fig,handles,trial.spikes};