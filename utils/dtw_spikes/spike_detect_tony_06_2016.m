%clear all;

patch = trial.voltage;
fs = trial.params.sampratein; %% sample rate
time_vec = (1:length(patch))./fs;
spiketemplate = [];

cutoff = 2000;%%cutoff frequencies for high-pass filtering patch
[x_lo,y_lo] = butter(2,cutoff/(fs/2),'low');%%2nd order hp filter
patch = filter(x_lo, y_lo, patch)';


cutoff = 75;%%cutoff frequencies for high-pass filtering patch
[x,y] = butter(2,cutoff/(fs/2),'high');%%2nd order hp filter 
fb_1 = filter(x, y, patch)';
filtered_patch = conv(diff(fb_1),hanning(7)); 

spikes.approval = 1; %%approval (== 0) to run without asking for the spike distance threshold
spikes.approval_time = 4;%% time given to approve spikes
spikes.threshold_factor = 1.5; %%threshold over which to find peaks (# of sds)
spikes.sd = std(filtered_patch(4:end)); %%%made up standard deviation of the patch (complicated by steady state deflection)
spikes.threshold = spikes.threshold_factor*spikes.sd;
spikes.cutoff = cutoff;%%cutoff frequencies for high-pass filtering patch
spikes.spike_count_range = 1:length(patch); %%range from which to extract spikes
spikes.filts = spikes.cutoff/(fs/2);
spikes.spikeDist_threshold = 10; %% default spike distance threshold
spikes.spikeTemplateWidth = 40; %%number of samples for the spike template
spikes.spikes2avg = 1;

full_length = length(patch);
num_conditions = 1;

for j = 1:num_conditions  % 36 conditions, create an array of the four important variables for each condition
    Spikes(j).patch = [];  
    Spikes(j).spike_locs = [];
    Spikes(j).spike_locs_inds = [];
    Spikes(j).num_spikes = [];
    Spikes(j).spike_ts = [];
end

Index = 1;
Spikes(Index).patch    =   [Spikes(Index).patch; patch'];

[spike_locs, spikesBelowThresh, spiketemplate, spikeDist_threshold] = wendy_spike_extractor_08_2013(-filtered_patch(spikes.spike_count_range)', patch(spikes.spike_count_range)',...
    spikes.threshold,spiketemplate, spikes.spikeTemplateWidth, spikes.spikes2avg, spikes.spikeDist_threshold, spikes.approval, spikes.approval_time);
Spikes(Index).num_spikes =   [Spikes(Index).num_spikes; length(spike_locs)];%%each row is a list of spike locations
Spikes(Index).spike_ts =   [Spikes(Index).spike_ts; spikesBelowThresh'];%%each row is a single spike
Spikes(Index).spike_locs =   [Spikes(Index).spike_locs; spike_locs];%%the first column gives the spike location
trial_num = size(Spikes(Index).patch,1);
Spikes(Index).spike_locs_inds =   [Spikes(Index).spike_locs_inds; trial_num*ones(length(spike_locs),1)];%%the 2nd column gives the trial in which that spike location resides

spikes.spikeDist_threshold = spikeDist_threshold; %%use the new threshold for the remainder of this cell

%        
figure;hold on;
plot(patch(spikes.spike_count_range), 'b');
plot(spike_locs, patch(length(spike_locs)), 'ro');
