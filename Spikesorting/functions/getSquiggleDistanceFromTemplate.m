function varargout = getSquiggleDistanceFromTemplate(spike_locs,spikeTemplate,fd,ufd,stw,fs)

% pool the detected spike candidates and do spike_params.spiketemplate matching
targetSpikeDist = zeros(size(spike_locs(:)));
norm_spikeTemplate = (spikeTemplate-min(spikeTemplate))/(max(spikeTemplate)-min(spikeTemplate));

%window = (max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)))
% Should have gotten rid of spikes near the beginning or end of the data
window = -floor(stw/2): floor(stw/2);
spikewindow = window-floor(stw/2);
smthwnd = (fs/2000+1:length(spikewindow)-fs/2000);

detectedUFSpikeCandidates = nan(size(window(:),1),size(spike_locs(:),1));
detectedSpikeCandidates = detectedUFSpikeCandidates;
norm_detectedSpikeCandidates = detectedUFSpikeCandidates;

for i=1:length(spike_locs)
    % in the case of a single location, the template doesn't match
    % the one coming out of seed template matching
    if min(spike_locs(i)+stw/2,length(fd)) - max(spike_locs(i)-stw/2,0)< stw
        continue
    else
        curSpikeTarget = fd(spike_locs(i)+window);
        detectedUFSpikeCandidates(:,i) = ufd(spike_locs(i)+spikewindow); % all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0): min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
        detectedSpikeCandidates(:,i) = curSpikeTarget; % all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0): min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
        norm_curSpikeTarget = (curSpikeTarget-min(curSpikeTarget))/(max(curSpikeTarget)-min(curSpikeTarget));
        norm_detectedSpikeCandidates(:,i) = norm_curSpikeTarget;
        [targetSpikeDist(i), ~,~] = dtw_WarpingDistance(norm_curSpikeTarget, norm_spikeTemplate);
    end
end

if numel(targetSpikeDist)>1
    goodSpikes = targetSpikeDist<=quantile(targetSpikeDist,.5);
else
    goodSpikes = 1;
end
idx_i = round(stw/6);
idx_f = round(stw/24);
idx_m = round(stw*2/3);

spikeWaveforms = detectedUFSpikeCandidates-repmat(detectedUFSpikeCandidates(1,:),size(detectedUFSpikeCandidates,1),1);
spikeWaveform = smooth(mean(spikeWaveforms(:,goodSpikes),2),fs/2000);
spikeWaveform_ = smoothAndDifferentiate(spikeWaveform,fs/2000);
spikeWaveform_ = spikeWaveform_-spikeWaveform_(smthwnd(1));
spikeWaveform_ = (spikeWaveform_-min(spikeWaveform_(idx_i:end-idx_f)))/diff([min(spikeWaveform_(idx_i:end-idx_f)) max(spikeWaveform_(idx_i:end-idx_f))]);

[~,inflPntPeak_ave] = findpeaks(spikeWaveform_(idx_i+1:end-idx_f),'MinPeakProminence',0.014);
inflPntPeak_ave = inflPntPeak_ave+idx_i;
inflPntPeak_ave = inflPntPeak_ave(abs(inflPntPeak_ave-idx_m)==min(abs(inflPntPeak_ave-idx_m)));

s_hat = spikeWaveform(inflPntPeak_ave:end-idx_f)- spikeWaveform(inflPntPeak_ave);
s_hat = s_hat/sum(s_hat);
s_hat = s_hat(:);

spikeAmplitude = ...
    (detectedUFSpikeCandidates(inflPntPeak_ave:end-idx_f,:) - ...
    repmat(detectedUFSpikeCandidates(inflPntPeak_ave,:),length(inflPntPeak_ave:stw-idx_f),1))' * s_hat;

if any(isnan(detectedUFSpikeCandidates(:)))
    error('some of the spikes are at the edge of the data');
end

varargout = {...
    detectedUFSpikeCandidates,...
    detectedSpikeCandidates,...
    norm_detectedSpikeCandidates,...
    targetSpikeDist,...
    spikeAmplitude,...
    window,...
    spikewindow};