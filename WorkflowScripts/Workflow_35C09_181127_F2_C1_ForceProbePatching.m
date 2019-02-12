%% ForceProbe patcing workflow 181127_F2_C1
trial = load('E:\Data\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_1.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

% trial = load('E:\Data\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_1.mat');
% 
% clear trials spiketrials bartrials
% 
% spiketrials{1} = 1:35; %#ok<*NASGU> % no drugs
% spiketrials{2} = 36:70; %#ok<*NASGU> % MLA, but slightly ineffective, still spiking
% examplespiketrials = {
% 'E:\Data\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_9.mat'
% 'E:\Data\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_65.mat'
%     };
% 
% bartrials{1} =  1:35; % no drugs
% bartrials{2} =  36:70; %#ok<*NASGU> % MLA, but slightly ineffective, still spiking


%% EpiFlash2TTrain - random movements

trial = load('F:\Acquisition\181127\181127_F2_C1\EpiFlash2TTrain_Raw_181127_F2_C1_16.mat');

clear spiketrials bartrials

spiketrials{1} = 1:16; % no bar
spiketrials{2} = 17:26; % bar
spiketrials{3} = 27:31; % bar, atropine
examplespiketrials = {
    };

nobartrials{1} = 1:16; % no bar
bartrials{2} = 17:26; % no bar
bartrials{3} = 27:31; % bar, atropine

%% PiezoRamp2T - looking for changes in spike rate 

% trial = load('E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_420.mat');

% clear spiketrials bartrials
% spiketrials{1} = 1:280; % control
% spiketrials{2} = 281:336; % moved probe to base and tip. How do these responses compare?
% spiketrials{3} = 337:448; % atropine, atropine MLA
% examplespiketrials = {
% 'E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_29.mat'
% 'E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_329.mat'
% 'E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_420.mat'
%     };

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('F:\Acquisition\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_1.mat');

clear spiketrials bartrials
spiketrials{1} = 1:210; % control
spiketrials{2} = 211:252; % atropine
spiketrials{3} = 253:294; % atropine MLA
examplespiketrials = {
'E:\Data\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_7.mat'
 'E:\Data\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_216.mat'
'E:\Data\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_259.mat'
   };

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



