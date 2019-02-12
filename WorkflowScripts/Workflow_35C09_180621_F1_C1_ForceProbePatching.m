%% ForceProbe patcing workflow 180621_F1_C1
trial = load('E:\Data\180621\180621_F1_C1\CurrentStep2T_Raw_180621_F1_C1_1.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

% trial = load('E:\Data\180621\180621_F1_C1\CurrentStep2T_Raw_180621_F1_C1_1.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% clear trials spiketrials bartrials
% spiketrials{1} = 1:50;
% examplespiketrials = {
% 'E:\Data\180621\180621_F1_C1\CurrentStep2T_Raw_180621_F1_C1_1.mat'
%     };

% bartrials{1} = 1:50; 

%% EpiFlash2T - random movements

% trial = load('E:\Data\180621\180621_F1_C1\EpiFlash2T_Raw_180621_F1_C1_24.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
 
% clear trials spiketrials bartrials nobartrials
% spiketrials{1} = 1:10;
% spiketrials{2} = 11:22;
% spiketrials{3} = 23:36; % no bar, not much movement, not going to work on this
% spiketrials{4} = 37:46;
% examplespiketrials = {
% 'E:\Data\180621\180621_F1_C1\EpiFlash2T_Raw_180621_F1_C1_12.mat'
% 'E:\Data\180621\180621_F1_C1\EpiFlash2T_Raw_180621_F1_C1_12.mat'
% 'E:\Data\180621\180621_F1_C1\EpiFlash2T_Raw_180621_F1_C1_24.mat'
% 'E:\Data\180621\180621_F1_C1\EpiFlash2T_Raw_180621_F1_C1_24.mat'
% };

nobartrials{1} = 23:36; % Nice Tibia angles calculated

% bartrials{1} = 1:10;
% bartrials{2} = 11:22;
% spiketrials{4} = 37:46;

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\180621\180621_F1_C1\PiezoStep2T_Raw_180621_F1_C1_2.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials
spiketrials{1} = 2:218; % No MLA

examplespiketrials = {
    'E:\Data\180621\180621_F1_C1\PiezoRamp2T_Raw_180621_F1_C1_43.mat'
    };


%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\180621\180621_F1_C1\PiezoRamp2T_Raw_180621_F1_C1_43.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials
spiketrials{1} = 2:277; % No MLA

examplespiketrials = {
    'E:\Data\180621\180621_F1_C1\PiezoRamp2T_Raw_180621_F1_C1_43.mat'
    };


%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Run Bar detection scripts one at a time

trials = bartrials;

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
