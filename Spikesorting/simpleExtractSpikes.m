
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
    patch = trial.voltage_1-mean(trial.voltage_1(t<0));

    cutoff = 2000;%%cutoff frequencies for high-pass filtering patch
    [x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');%%2nd order hp filter
    patch_lo = filter(x_lo, y_lo, patch)';

    
    cutoff = 75;%%cutoff frequencies for high-pass filtering patch
    [x_hi,y_hi] = butter(2,cutoff/(fs/2),'high');%%2nd order hp filter
    fb_1 = filter(x_hi, y_hi, patch_lo)';
    filtered_patch = conv(diff(fb_1),hanning(7),'same');
    
    spike_waveform = filtered_patch;
%     spike_waveform = filtfilt(d1,spike_waveform);
    

    
    
    % A spike is a positive peak, followed by a negative peak. neg window
    % is 50 points or 5 ms
    
    % In other cases, a spike is a negative peak followed by a positive
    % peak!
    if polarity==-1
        spike_waveform = spike_waveform*-1;
    end
    
    [splcs_p,pks_p] = peakfinder(double(spike_waveform),[],max(spike_waveform)/6,1,false);
    [splcs_m,pks_m] = peakfinder(double(spike_waveform),[],min(spike_waveform)/6,-1,false);
%     [splcs_p,pks_p] = peakfinder(double(spike_waveform),[],.2,1,false);
%     [splcs_m,pks_m] = peakfinder(double(spike_waveform),[],-1,-1,false);

    
    sp_window = 50;
    
    mp_events = zeros(size(splcs_m));
    pm_events = zeros(size(splcs_p));
    for i = 1:length(splcs_m)
        p_i = find(splcs_p-splcs_m(i)>-sp_window & splcs_p-splcs_m(i)<0);
        if ~isempty(p_i)
            mp_events(i) = 1;
            if length(p_i)>1
                pm_events(p_i(end)) = 1;
            else 
                pm_events(p_i) = 1;
            end
        elseif i>1
            [splcs_p_,pks_p_] = peakfinder(double(spike_waveform(splcs_m(i-1):splcs_m(i))),[],.2,1,false);
            if any(diff([splcs_m(i-1) splcs_m(i)])-splcs_p_<sp_window/2)
                p_ = find(diff([splcs_m(i-1) splcs_m(i)])-splcs_p_<sp_window/2);
                if (pks_p_(p_(end))>mean(pks_p)*.3)
                    p_ = p_(end);
                    mp_events(i) = 1;
                    
                    insrt = find(splcs_p<splcs_p_(p_)+splcs_m(i-1),1,'last')+1;
                    splcs_p = [splcs_p(1:insrt); splcs_p_(p_)+splcs_m(i-1)-1; splcs_p(insrt+1:end)];
                    pks_p = [pks_p(1:insrt); pks_p_(p_); pks_p(insrt+1:end)];
                    pm_events = [pm_events(1:insrt); 1; pm_events(insrt+1:end)];
                    
                end
            else
                [splcs_p__,pks_p__] = peakfinder(double(spike_waveform(splcs_m(i-1)+splcs_p_(1):splcs_m(i))),[],.2,1,false);
                if any(diff([splcs_m(i-1)+splcs_p_(1) splcs_m(i)])-splcs_p__<sp_window/2)
                    p_ = find(diff([splcs_m(i-1)+splcs_p_(1) splcs_m(i)])-splcs_p__<sp_window/2);
                    if (pks_p__(p_(end))>mean(pks_p)*.3)
                        p_ = p_(end);
                        mp_events(i) = 1;
                        
                        insrt = find(splcs_p<splcs_p__(p_)+splcs_m(i-1),1,'last')+1;
                        splcs_p = [splcs_p(1:insrt); splcs_p__(p_)+splcs_m(i-1)+splcs_p_(1)-1; splcs_p(insrt+1:end)];
                        pks_p = [pks_p(1:insrt); pks_p__(p_); pks_p(insrt+1:end)];
                        pm_events = [pm_events(1:insrt); 1; pm_events(insrt+1:end)];
                        
                    end
                end
            end
        else
            [splcs_p_,pks_p_] = peakfinder(double(spike_waveform(find(t==0):splcs_m(i))),[],.2,1,false);
            if any(diff([find(t==0) splcs_m(i)])-splcs_p_<sp_window/2)
                p_ = find(diff([find(t==0) splcs_m(i)])-splcs_p_<sp_window/2);
                if (pks_p_(p_(end))>mean(pks_p)*.3)
                    mp_events(i) = 1;

                    splcs_p = [splcs_p_(p_)+find(t==0)-1; splcs_p];
                    pks_p = [pks_p_(p_); pks_p];
                    pm_events = [1; pm_events];
                    
                end
            end
        end
                
    end
    
    %%
    splcs_p = splcs_p(logical(pm_events));
    % pks_p = pks_p(pm_events);
    
    splcs_m = splcs_m(logical(mp_events));
    % pks_m = pks_m(pm_events);

    if length(splcs_p) ~= length(splcs_m)
        error
    end
        

%%
fig = figure(69); clf
ax = subplot(1,1,1,'parent',fig);
cla(ax,'reset')
title(ax,[trial.params.protocol ' - ' num2str(trial.params.stimDurInSec) ' s duration'])

% plot(ax,t,patch_lo/10,'color',[1 .7 .7]); hold on
plot(ax,patch_lo/10,'color',[1 .7 .7]); hold on
spikes = t(splcs_p);
spikelocs_ = splcs_p(spikes>-trial.params.preDurInSec+.1);
spikes = spikes(spikes>-trial.params.preDurInSec+.1);
% plot(ax,t(spikelocs_),patch_lo(spikelocs_)/10,'.','color',[.7 0 0])
plot(ax,spikelocs_,patch_lo(spikelocs_)/10,'.','color',[.7 0 0])

% plot(ax,t(1:length(spike_waveform)),(spike_waveform-mean(spike_waveform))); hold on
plot(ax,1:length(spike_waveform),(spike_waveform-mean(spike_waveform))); hold on
% plot(ax,t(splcs_p),(spike_waveform(splcs_p)-mean(spike_waveform)),'.','color',[.7 0 0])
plot(ax,splcs_p,(spike_waveform(splcs_p)-mean(spike_waveform)),'.','color',[.7 0 0])
% plot(ax,t(splcs_m),(spike_waveform(splcs_m)-mean(spike_waveform)),'.','color',[0 0 .7])
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
