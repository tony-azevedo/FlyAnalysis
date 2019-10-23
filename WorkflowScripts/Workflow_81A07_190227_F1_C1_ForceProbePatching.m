%% ForceProbe patcing workflow 190227_F1_C1
trial = load('E:\Data\190227\190227_F1_C1\EpiFlash2T_Raw_190227_F1_C1_15.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - to get force
% Take a look at this trial!
trial = load('E:\Data\190227\190227_F1_C1\CurrentStep2T_Raw_190227_F1_C1_8.mat');
% 
% clear spiketrials bartrials
% bartrials{1} = 1:35; % no drugs
% no additional MLA trials

% spiketrials{1} = 1:35; % no drugs
% examplespiketrials = {
% 'E:\Data\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_15.mat'
% };

%% EpiFlash2TTrain -

trial = load('E:\Data\190227\190227_F1_C1\EpiFlash2TTrain_Raw_190227_F1_C1_1.mat');

clear spiketrials bartrials
% No spikes for these trials,
% No bar either
nobartrials{1} = 1:15;

%% EpiFlash2T - 

trial = load('E:\Data\190227\190227_F1_C1\EpiFlash2T_Raw_190227_F1_C1_15.mat');

clear spiketrials bartrials
spiketrials{1} = 14:28; % bar
spiketrials{2} = 29:38; % no bar
examplespiketrials = {
'E:\Data\190227\190227_F1_C1\EpiFlash2T_Raw_190227_F1_C1_20.mat'
'E:\Data\190227\190227_F1_C1\EpiFlash2T_Raw_190227_F1_C1_31.mat'
};

bartrials{1} = 14:28;
nobartrials{1} = 29:38;

%% Sweep2T - looking for changes in spike rate with slow movement of the bar

trial = load('E:\Data\190227\190227_F1_C1\Sweep2T_Raw_190227_F1_C1_2.mat');

clear spiketrials bartrials
spiketrials{1} = 1:10; % slow bar movements
examplespiketrials = {
'E:\Data\190227\190227_F1_C1\Sweep2T_Raw_190227_F1_C1_2.mat'
};

bartrials{1} = 1:10; % 


%% PiezoStep2T - , looking for changes in spike rate 

% No spikes here

%% PiezoRamp2T -, looking for changes in spike rate 

% No spikes here

%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
trials = spiketrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Extract EMG spikes
spikevars = getacqpref('FlyAnalysis','Spike_params_current_2_flipped_fs50000');

trial = load(examplespiketrials{1});
trial.current_2_flipped = -1*trial.current_2; 
[trial,vars_skeleton] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');

trials = spiketrials(1);
exampletrials = examplespiketrials;

Script_ExtractEMGSpikesFromInterestingTrials

%% Run Bar detection scripts one at a time

trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% Set probe line 
Script_SetProbeLine % showProbeLocation(trial)

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand

% Script_FixTheTrialsWithRedLEDTransients


%% Calculate position of femur and tibia from csv files

% After bringing videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.

% trials = nobartrials;
% trialnumlist = [];
% for idx = 1:length(trials)
%     trialnumlist = [trialnumlist trials{idx}]; %#ok<AGROW>
% end
% close all
% 
% Script_AddTrackedPositions
% Script_UseAllTrialsInSetToCorrectLegPosition;
% Script_AddTrackedLegAngleToTrial
% Script_UseAllTrialsInSetToCalculateLegElevation

