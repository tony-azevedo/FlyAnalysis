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

trial = load('B:\Raw_Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_205.mat');
trial = load('B:\Raw_Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_9.mat');

%% init analysis params
init.manual = 1;%% if spike sorting is to be done manually
init.other_piezo = 0; %% if 2nd piezo is the primary one, == 1; currently just one piezo
init.firing_bin_ms = 100;%% window in which to calculate firing rate (in samples)


%% load data
% [data,si,h]=abfload([init.datapath '/' init.filename]);
fs = trial.params.sampratein;
%spikefile = [init.spikepath filename(1:end-4) '_bristlespikes.mat'];
patch_1 = trial.voltage_1(:,1); %%patch primary signal
% piezo = data(:,2); %%currently meaningless, but could be used to only look at particular windows in the data;
patch_2 = trial.current_2(:,1); %%patch primary signal

%% initialize spike ID params
spike_params.fs = fs;%% sampling rate
% firing_bin = init.firing_bin_ms*(spikes.fs/1000); 
spike_params.approval = 1; %%approval (== 0) to run without asking for the spike distance threshold
spike_params.approval_time = 10;
spike_params.Distance_threshold = 10;
spike_params.spikeTemplateWidth = 50; %%number of samples for the spike template
spike_params.spikes2avg = 3;
spike_params.spiketemplate = [];
spike_params.spike_count_range = 1:length(patch_1); %%range from which to extract spikes
spike_params.type = '';%% for naming spike files

%% run spike ID
unfiltered_data = patch_1(spike_params.spike_count_range);
piezo = patch_2(spike_params.spike_count_range);
% [spike_inds, spikesBelowThresh, spiketemplate, spikeDist_threshold, vars] = ...
%     spike_extractor_170930(patch_1(spike_params.spike_count_range),patch_2(spike_params.spike_count_range), spike_params, init);


% spike_extractor_171106

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
