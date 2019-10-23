%% ForceProbe patcing workflow 190712_F1_C1
trial = load('E:\Data\190712\190712_F1_C1\EpiFlash2T_Raw_190712_F1_C1_8.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190712\190712_F1_C1\EpiFlash2T_Raw_190712_F1_C1_8.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:621; % 
bartrials{1} = 8:247; % Selected, couldn' sort more spikes than this

spiketrials{1} = 8:247; % 
examplespiketrials = {
'E:\Data\190712\190712_F1_C1\EpiFlash2T_Raw_190712_F1_C1_49.mat'
'E:\Data\190712\190712_F1_C1\EpiFlash2T_Raw_190712_F1_C1_27.mat' % EMG spikevars
};

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190619\190619_F3_C1\PiezoRamp2T_Raw_190619_F3_C1_1.mat');

% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190619\190619_F3_C1\PiezoStep2T_Raw_190619_F3_C1_3.mat');

% No spikes here

%%
Workflow_0_ForceProbe_routines

%% Extract EMG spikes - still not great. Have to redo
% spikevars = getacqpref('FlyAnalysis','Spike_params_current_2_flipped_fs50000');

sgn = -1;
examplespiketrials = {
'E:\Data\190712\190712_F1_C1\EpiFlash2T_Raw_190712_F1_C1_38.mat'
};
exampletrials = examplespiketrials;
trial = load(examplespiketrials{1});
trials = {39:247}; %spiketrials(1);
% trial.current_2_flipped = sgn*trial.current_2; 

% [trial,vars_skeleton] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');

REDODETECTION = 1;
interact = 'no';
Script_ExtractEMGSpikesFromInterestingTrials
%%
[trial,vars_skeleton] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');
