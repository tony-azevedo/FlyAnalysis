function varargout = extractSpikes_v2(fig,handles,savetag,varargin)

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
    spike_waveform = spike_waveform-5;
    
elseif ~isfield(handles.trial,'spikes')
    
    trial = handles.trial;
    t = makeInTime(trial.params);
    
    patch = trial.voltage-mean(trial.voltage);
    fs = trial.params.sampratein; 
    spiketemplate = []; % find this in the cell folder?
    
    cutoff = 2000;
    [x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');
    patch = filter(x_lo, y_lo, patch)';
    % about 1 sample of a delay
    
    cutoff = 75;
    [x,y] = butter(2,cutoff/(fs/2),'high');
    filtered_patch = filter(x, y, patch)';
    spike_waveform = filtered_patch;
    % get rid of slow stuff, repolarizations begin to look like AHPs
    
    filtered_patch(1:end-1) = conv(diff(filtered_patch),hanning(7),'same');
    filtered_patch(end) = filtered_patch(end-1);    
    % advance the peak slightly by differentating and finding where the
    % spike takes off
    
    spikes.approval = 1; %%approval (== 0) to run without asking for the spike distance threshold
    spikes.approval_time = 1;%% time given to approve spikes
    spikes.threshold_factor = 1.5; %%threshold over which to find peaks (# of sds)
    spikes.sd = std(filtered_patch(4:end)); %%%made up standard deviation of the patch (complicated by steady state deflection)
    spikes.threshold = spikes.threshold_factor*spikes.sd;
    spikes.cutoff = cutoff;%%cutoff frequencies for high-pass filtering patch
    spikes.spike_count_range = 1:length(patch); %%range from which to extract spikes
    spikes.filts = spikes.cutoff/(fs/2);
    spikes.spikeDist_threshold = 10; %% default spike distance threshold
    spikes.spikeTemplateWidth = 40; %%number of samples for the spike template
    spikes.spikes2avg = 1;
    [~,spikes.analysiswindow] = max(patch);
    
    spikes.analysiswindow = spikes.analysiswindow + [-fs/5  fs/5];
        
    [spikelocs, spikesBelowThresh, spiketemplate, spikeDist_threshold] = wendy_spike_extractor_08_2013(...
        filtered_patch(spikes.spike_count_range)',...
        patch(spikes.spike_count_range)',...
        spikes.threshold,...
        spiketemplate, ...
        spikes.spikeTemplateWidth, ...
        spikes.analysiswindow,...
        spikes.spikes2avg, ...
        spikes.spikeDist_threshold,...
        spikes.approval,...
        spikes.approval_time);
        
end

ax = subplot(3,1,[1 2],'parent',fig);
cla(ax,'reset')
title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.stimDurInSec) ' s duration'])

hold(ax,'on')

plot(ax,t,spike_waveform,'tag',savetag); hold on
plot(ax,t,patch,'color',[1 .7 .7],'tag',savetag);
spikes = t(spikelocs);
spikelocs_ = spikelocs(spikes>-trial.params.preDurInSec+.1);
% spikes = spikes(spikes>-trial.params.preDurInSec+.1);
plot(ax,t(spikelocs_),patch(spikelocs_),'.','color',[.7 0 0])

axis(ax,'tight')
% xlim(ax,[-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax');

drawnow

%
ax = subplot(3,1,3,'parent',fig);
cla(ax)
plot(ax,t,EpiFlashStim(trial.params),'color',[0 0 1],'tag',savetag); hold(ax,'on')
plot(ax,t,trial.exposure,'color',[0 .7 .3],'tag',savetag); hold(ax,'on')
axis(ax,'tight')
% xlim(ax,[-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])

title([])
box(ax,'off');
set(ax,'TickDir','out');

drawnow

if ~isfield(trial,'spikes')
    [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
    fprintf(1,'Saving %d Spikes for %s %s trial %s\n', length(spikes),[dateID '_' flynum '_' cellnum], protocol,trialnum);
    
    trial.spikes = spikes;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    handles.trial = trial;
end
varargout = {fig,handles,trial.spikes};