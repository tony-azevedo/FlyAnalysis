%% ForceProbe patcing workflow 181118_F1_C1
trial = load('E:\Data\181118\181118_F1_C1\EpiFlash2TTrain_Raw_181118_F1_C1_8.mat');
D = fileparts(trial.name);
cd (D)

%% EpiFlash2TTrain - random movements

trial = load('E:\Data\181118\181118_F1_C1\EpiFlash2TTrain_Raw_181118_F1_C1_13.mat');

clear trials spiketrials bartrials
% spiketrials{1} = 1:20; % no bar
% spiketrials{2} = 21:35; % bar

bartrials{1} = 21:35;

%%  Sweep2T - looking for changes in spike rate with slow movement of the bar

trial = load('E:\Data\181118\181118_F1_C1\Sweep2T_Raw_181118_F1_C1_29.mat');

clear trials spiketrials bartrials
% spiketrials{1} = 1:25; 
% spiketrials{1} = 26:35; % bar, slow movements
% 
% bartrials{1} = 26:35;

%% Extract spikes
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials


%% Run scripts one at a time
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
trials = bartrials;

% Set probe line 
Script_SetProbeLine 

% double check some trials
% trial = load(sprintf(trialStem,66));
% showProbeLocation(trial)

% trial = probeLineROI(trial);

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

Script_FixTheTrialsWithRedLEDTransients


%% Calculate position of femur and tibia from csv files

% Done!

% After brining videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.
% trial = load('E:\Data\181118\181118_F1_C1\EpiFlash2TTrain_Raw_181118_F1_C1_8.mat');
% [~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);
% trialnumlist = 1:20; % no bar
% 
% close all
% 
% Script_AddTrackedPositions
% Script_UseAllTrialsInSetToCorrectLegPosition;
% Script_AddTrackedLegAngleToTrial
% Script_UseAllTrialsInSetToCalculateLegElevation

