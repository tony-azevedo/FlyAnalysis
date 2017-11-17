
% if isfield(trial,'spikes')
%
%     [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
%     fprintf('%s %s trial %s has %d Spikes\n', [dateID '_' flynum '_' cellnum], protocol,trialnum,length(trial.spikes));
%
%     t = makeInTime(trial.params);
%     fs = trial.params.sampratein; %% sample rate
%     patch = trial.voltage_1;
%     cutoff = 2000;%%cutoff frequencies for high-pass filtering patch
%     [x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');%%2nd order hp filter
%     patch_lo = filter(x_lo, y_lo, patch)';
%
%     spike_waveform = trial.voltage_1;
%     spike_waveform(:) = 0;
%     spikelocs = trial.spikes;
%     [~,spikelocs] = intersect(t,spikelocs);
%     spike_waveform(spikelocs) = .2;
%
%     splcs_p = spikelocs;
%     splcs_m = spikelocs+1;
%
% elseif ~isfield(trial,'spikes')

fs = trial.params.sampratein; %% sample rate
t = makeInTime(trial.params);
patch = trial.current_2-mean(trial.current_2(t<0));

% cutoff = 2000;%%cutoff frequencies for high-pass filtering patch
% [x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');%%2nd order hp filter
% patch_lo = filter(x_lo, y_lo, patch)';
% 
patch_lo = patch;

% cutoff = 75;%%cutoff frequencies for high-pass filtering patch
% [x_hi,y_hi] = butter(2,cutoff/(fs/2),'high');%%2nd order hp filter
% fb_1 = filter(x_hi, y_hi, patch_lo)';
% filtered_patch = conv(diff(fb_1),hanning(7),'same');

filtered_patch = patch_lo;

if ispref('FlyAnalysis','CurrentFilter')
    d1 = getpref('FlyAnalysis','CurrentFilter');
end
if ~ispref('FlyAnalysis','CurrentFilter') || d1.SampleRate ~= trial.params.sampratein
    d1 = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',trial.params.sampratein);
    if ~ispref('FlyAnalysis','CurrentFilter')
        setpref('FlyAnalysis','CurrentFilter',d1);
    end
end

spike_waveform = filtered_patch;
% spike_waveform = filtfilt(d1,spike_waveform);

%     [splcs_p,pks_p] = peakfinder(double(spike_waveform),[],max(spike_waveform)/6,1,false);
%     [splcs_m,pks_m] = peakfinder(double(spike_waveform),[],min(spike_waveform)/6,-1,false);

[splcs_m,pks_m] = peakfinder(double(spike_waveform),[],min(spike_waveform)/4,-1,false);
splcs_m = splcs_m(pks_m<tresh);
pks_m = pks_m(pks_m<tresh);


%% the spikes are the negative peaks


%%
fig = figure(69); clf
ax = subplot(1,1,1,'parent',fig);
cla(ax,'reset')
title(ax,[trial.params.protocol ' - ' num2str(trial.params.stimDurInSec) ' s duration'])

% plot(ax,t,patch_lo/10,'color',[1 .7 .7]); hold on
plot(ax,patch_lo,'color',[1 .7 .7]); hold on
spikes = t(splcs_m);
spikelocs_ = splcs_m(spikes>-trial.params.preDurInSec+.1);
spikes = spikes(spikes>-trial.params.preDurInSec+.1);
%plot(ax,t(spikelocs_),patch_lo(spikelocs_),'.','color',[.7 0 0])
plot(ax,spikelocs_,patch_lo(spikelocs_),'.','color',[.7 0 0])

plot(ax,1:length(spike_waveform),(spike_waveform-mean(spike_waveform))); hold on
plot(ax,splcs_m,(spike_waveform(splcs_m)-mean(spike_waveform)),'.','color',[0 0 .7])
axis(ax,'tight')
% xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
xlim(trial.params.sampratein*[trial.params.preDurInSec-.05 trial.params.preDurInSec+trial.params.stimDurInSec+ min(.1,trial.params.postDurInSec)])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax');

drawnow


%%
% ax = subplot(3,1,3,'parent',fig);
% cla(ax)
% plot(ax,t,EpiFlashStim(trial.params),'color',[0 0 1],'tag',savetag); hold on
% plot(ax,t,trial.exposure,'color',[0 .7 .3],'tag',savetag); hold on
% axis(ax,'tight')
% % xlim([-.4 trial.params.stimDurInSec+ min(.8,trial.params.postDurInSec)])
% %xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
%
% title([])
% box(ax,'off');
% set(ax,'TickDir','out');
%
% drawnow

%%
% if ~isfield(trial,'spikes')
%     [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
%     fprintf('Saving %d Spikes for %s %s trial %s\n', length(spikes),[dateID '_' flynum '_' cellnum], protocol,trialnum);
%
trial.spikes = spikes;
save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
%     handles.trial = trial;
% end
