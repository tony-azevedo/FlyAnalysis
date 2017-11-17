%clear all; close all;
%% init file and folders

% init.filename = '17217007.abf';
% init.rootfolder = 'C:\Users\tony\Code\FlyAnalysis\Spikesorting\';
% init.datapath = [init.rootfolder 'ephys_data\'];
% init.spikepath = [init.rootfolder 'spikes\'];
% init.stimpath = [init.rootfolder 'stim_metadata\'];
% init.summpath = [init.rootfolder 'ephys_metadata\'];
% init.outputpath = [init.rootfolder 'figures\'];
% init.funcpath = [init.rootfolder 'functions'];
% addpath(init.funcpath);

%% init analysis params
init.manual = 0;%% if spike sorting is to be done manually
init.other_piezo = 0; %% if 2nd piezo is the primary one, == 1; currently just one piezo
init.firing_bin_ms = 100;%% window in which to calculate firing rate (in samples)

%% load data
% [data,si,h]=abfload([init.datapath '/' init.filename]);
fs = trial.params.sampratein;
%spikefile = [init.spikepath filename(1:end-4) '_bristlespikes.mat'];
patch_1 = data(:,1); %%patch primary signal
% piezo = data(:,2); %%currently meaningless, but could be used to only look at particular windows in the data;
piezo = data(:,1);

%% initialize spike ID params
spikes.fs = fs;%% sampling rate
% firing_bin = init.firing_bin_ms*(spikes.fs/1000); 
spikes.approval = 1; %%approval (== 0) to run without asking for the spike distance threshold
spikes.approval_time = 10;
spikes.Distance_threshold = 10;
spikes.spikeTemplateWidth = 50; %%number of samples for the spike template
spikes.spikes2avg = 3;
spikes.spiketemplate = [];
spikes.spike_count_range = 1:length(patch_1); %%range from which to extract spikes
spikes.type = '';%% for naming spike files

%% run spike ID
[spike_inds, spikesBelowThresh, spiketemplate, spikeDist_threshold, vars] = spike_extractor_170930(patch_1(spikes.spike_count_range),piezo(spikes.spike_count_range), spikes, init);

%% plot the results
figure(1); plot(patch_1, 'b');hold on;
plot(spike_inds, patch_1(spike_inds),'ro');

%% save the spikes
Spikes.num_spikes =   [length(spike_inds)];%%each row is a list of spike locations
Spikes.spike_ts =   [spikesBelowThresh'];%%each row is a single spike      
Spikes.spike_inds =   [spike_inds];%%the first column gives the spike location
Spikes.spike_locs(Spikes(1).spike_inds) = 1; %% make a binary vector for all spike locations
Spikes.spikeDist_threshold = spikeDist_threshold; %%use the new threshold for the remainder of this abf
Spikes.vars = vars;%% filtering parameters
       
%save([init.spikepath init.filename(1:end-4) '_spikes'], 'Spikes');
