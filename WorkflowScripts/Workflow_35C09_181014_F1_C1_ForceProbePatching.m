%% ForceProbe patcing workflow 181014_F1_C1
% trial = load('E:\Data\181014\181014_F1_C1\CurrentStep2T_Raw_181014_F1_C1_12.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

% trial = load('E:\Data\181014\181014_F1_C1\CurrentStep2T_Raw_181014_F1_C1_12.mat');
% 
% clear trials spiketrials bartrials
% spiketrials{1} = 12:66; %#ok<*NASGU> % no drugs
% spiketrials{2} = 67:171; %#ok<*NASGU> % Atropine and MLA
% examplespiketrials = {
%     'E:\Data\181014\181014_F1_C1\CurrentStep2T_Raw_181014_F1_C1_66.mat'
%     'E:\Data\181014\181014_F1_C1\CurrentStep2T_Raw_181014_F1_C1_169.mat'
%     };

% bartrials{1} = 12:66; %#ok<*NASGU> % no drugs
% bartrials{2} = 67:171; % Atropine and MLA

%% EpiFlash2TTrain - random movements

% trial = load('E:\Data\181014\181014_F1_C1\EpiFlash2TTrain_Raw_181014_F1_C1_1.mat');
% 
% clear trials spiketrials bartrials nobartrials
% spiketrials{1} = 1:10; % bar
% spiketrials{2} = 11:18; % no bar
% spiketrials{3} = 19:34; % atropine/MLA
% examplespiketrials = {
%     'E:\Data\181014\181014_F1_C1\Sweep2T_Raw_181014_F1_C1_34.mat'
%     };

% nobartrials{1} = 11:18; % Nice Tibia angles calculated

% bartrials{1} = 1:10;
% bartrials{2} = 19:34;

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar
% 
% trial = load('E:\Data\181014\181014_F1_C1\Sweep2T_Raw_181014_F1_C1_6.mat');
% 
% clear trials spiketrials
% spiketrials{1} = 6:15; % bar
% spiketrials{2} = 16:30; % atropine in
% spiketrials{3} = 31:45; % MLA and atropine
% 
% examplespiketrials = {
%     'E:\Data\181014\181014_F1_C1\Sweep2T_Raw_181014_F1_C1_15.mat'
%     'E:\Data\181014\181014_F1_C1\Sweep2T_Raw_181014_F1_C1_18.mat'
%     'E:\Data\181014\181014_F1_C1\Sweep2T_Raw_181014_F1_C1_34.mat'
%     };
% 
% bartrials = spiketrials;

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('E:\Data\181014\181014_F1_C1\PiezoStep2T_Raw_181014_F1_C1_4.mat');
% 
% clear trials spiketrials
% spiketrials{1} = 4:213; % No MLA
% spiketrials{2} = 214:255; % atropine in
% spiketrials{3} = 256:297; % MLA and atropine

% examplespiketrials = {
%     };


%% PiezoRamp2T - looking for changes in spike rate 

% trial = load('E:\Data\181014\181014_F1_C1\PiezoRamp2T_Raw_181014_F1_C1_2.mat');
% 
% clear trials spiketrials
% spiketrials{1} = 1:308; % No MLA
% spiketrials{2} = 309:364; % atropine in
% spiketrials{3} = 365:420; % MLA and atropine
% 
% examplespiketrials = {
%     };

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

