%% ForceProbe patcing workflow 181128_F1_C1
trial = load('F:\Acquisition\181128\181128_F1_C1\CurrentStep2T_Raw_181128_F1_C1_12.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

% trial = load('E:\Data\181128\181128_F1_C1\CurrentStep2T_Raw_181128_F1_C1_39.mat');
% 
% clear trials spiketrials bartrials
% 
% spiketrials{1} = 1:55; %#ok<*NASGU> % no drugs
% spiketrials{2} = 56:105; %#ok<*NASGU> % No drugs, was flowing in but then the manipulator movement routine died!
% examplespiketrials = {
% 'E:\Data\181128\181128_F1_C1\CurrentStep2T_Raw_181128_F1_C1_104.mat'
% 'E:\Data\181128\181128_F1_C1\CurrentStep2T_Raw_181128_F1_C1_75.mat'
%     };
% 
% bartrials{1} =  1:55; % no drugs
% bartrials{2} =  56:105; %#ok<*NASGU> % No drugs,



%% EpiFlash2TTrain - random movements

trial = load('F:\Acquisition\181128\181128_F1_C1\EpiFlash2TTrain_Raw_181128_F1_C1_1.mat');

clear spiketrials bartrials

spiketrials{1} = 1:5; % no bar

bartrials{1} = 1:5; % bar

%% PiezoRamp2T - looking for changes in spike rate 

% trial = load('E:\Data\181128\181128_F1_C1\PiezoRamp2T_Raw_181128_F1_C1_169.mat');
% 
% clear spiketrials bartrials
% spiketrials{1} = 169:224; % control
% examplespiketrials = {
% 'E:\Data\181128\181128_F1_C1\PiezoRamp2T_Raw_181128_F1_C1_169.mat'
%     };


%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('E:\Data\181128\181128_F1_C1\PiezoStep2T_Raw_181128_F1_C1_130.mat');
% 
% clear spiketrials bartrials
% spiketrials{1} = 127:147; % control
% examplespiketrials = {
% 'E:\Data\181128\181128_F1_C1\PiezoStep2T_Raw_181128_F1_C1_130.mat'
%     };

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar
trial = load('F:\Acquisition\181024\181024_F2_C1\Sweep2T_Raw_181024_F2_C1_20.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:25; % 
spiketrials{2} = 36:55; % atropine, MLA

bartrials{1} = 16:25; % bar position vs spike rate

%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials


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



