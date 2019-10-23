%% ForceProbe patcing workflow 181021_F1_C1
trial = load('F:\Acquisition\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_1.mat');
D = fileparts(trial.name);
cd (D)

%% Current step to get force

% trial = load('F:\Acquisition\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_1.mat');
% clear spiketrials bartrials

% spiketrials{1} = 6:60; %#ok<*NASGU> % no drugs % Done

% bartrials{1} =  6:60; % no drugs % Done
% no additional MLA trials



%% EpiFlash2TTrain - random movements

trial = load('E:\Data\181021\181021_F1_C1\EpiFlash2TTrain_Raw_181021_F1_C1_11.mat');
clear spiketrials bartrials

spiketrials{1} = 1:12; % bar 
examplespiketrials = {
'E:\Data\181021\181021_F1_C1\EpiFlash2TTrain_Raw_181021_F1_C1_11.mat'
    };

bartrials{1} = 1:12; % bar


%% Sweep2T - , looking for changes in spike rate with slow movement of the bar
% None for this cell
% trial = load('F:\Acquisition\');
% 
% clear spiketrials bartrials
% spiketrials{1} = ; % 
% 
% bartrials{1} = ; % 
% 

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('F:\Acquisition\181021\181021_F1_C1\PiezoStep2T_Raw_181021_F1_C1_173.mat');
% 
% clear spiketrials bartrials
% spiketrials{1} = 6:173; % No MLA


%% PiezoRamp2T -, looking for changes in spike rate 

% trial = load('F:\Acquisition\181021\181021_F1_C1\PiezoRamp2T_Raw_181021_F1_C1_220.mat');
% clear spiketrials bartrials
% spiketrials{1} = 2:191; % No MLA
% spiketrials{2} = 192:219; % No MLA
% 

%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% trials = spiketrials;
% exampletrials = examplespiketrials;
% Script_ExtractSpikesFromInterestingTrials
% 
%% Correct for transients
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% trials = bartrials;
% Script_FixTheTrialsWithRedLEDTransients
% 

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


%% Calculate position of femur and tibia from csv files
% None here