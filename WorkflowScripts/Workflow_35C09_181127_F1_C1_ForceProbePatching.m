%% ForceProbe patcing workflow 181127_F1_C1
trial = load('F:\Acquisition\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_8.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - to get force

% trial = load('E:\Data\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_15.mat');
% 
% clear spiketrials bartrials
% bartrials{1} = 1:35; % no drugs
% no additional MLA trials

% spiketrials{1} = 1:35; % no drugs
% examplespiketrials = {
% 'E:\Data\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_15.mat'
% };

%% EpiFlash2TTrain -

trial = load('E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_4.mat');

clear spiketrials bartrials
spiketrials{1} = 1:4; % no bar
spiketrials{2} = 5:14; % bar
spiketrials{3} = 15:24; % bar
spiketrials{4} = 25:44; % no bar
spiketrials{5} = 45:48; % bar atropine MLA
examplespiketrials = {
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_4.mat'
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_5.mat'
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_5.mat'
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_5.mat'
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_5.mat'
};

bartrials{1} = 5:14;
bartrials{2} = 15:24;
bartrials{3} = 35:48;


%% Sweep2T - looking for changes in spike rate with slow movement of the bar

trial = load('E:\Data\181127\181127_F1_C1\Sweep2T_Raw_181127_F1_C1_16.mat');

clear spiketrials bartrials
spiketrials{1} = 16:25; % slow bar movements
examplespiketrials = {
'E:\Data\181127\181127_F1_C1\Sweep2T_Raw_181127_F1_C1_16.mat'
};

bartrials{1} = 16:25; % 


%% PiezoStep2T - , looking for changes in spike rate 

trial = load('E:\Data\181127\181127_F1_C1\PiezoStep2T_Raw_181127_F1_C1_206.mat');

clear spiketrials bartrials
spiketrials{1} = 10:210; % No MLA
% spiketrials{2} = 211:252; % Atropine, but depolarized and shitty but feed back is larger. Consistent?
examplespiketrials = {
'E:\Data\181127\181127_F1_C1\PiezoStep2T_Raw_181127_F1_C1_206.mat'
};


%% PiezoRamp2T -, looking for changes in spike rate 

trial = load('E:\Data\181127\181127_F1_C1\PiezoRamp2T_Raw_181127_F1_C1_245.mat');

clear spiketrials bartrials
spiketrials{1} = 1:308; % No MLA
% spiketrials{2} = 309:364; % atropine
examplespiketrials = {
'E:\Data\181127\181127_F1_C1\PiezoRamp2T_Raw_181127_F1_C1_245.mat'
};

%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
trials = spiketrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
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

