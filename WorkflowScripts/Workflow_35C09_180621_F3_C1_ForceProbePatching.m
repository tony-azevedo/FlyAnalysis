%% ForceProbe patcing workflow 180621_F3_C1: strange but interesting off target neuron
trial = load('E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
D = fileparts(trial.name);
cd (D)

%% Current step to get force
trial = load('E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 41:52;
trials{1} = 114:185; % single spikes

%% CurrentStep2T - to get force

% trial = load('E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials bartrials
% spiketrials{1} = 41:52; 
% spiketrials{2} = 53:58; 
% spiketrials{3} = 114:185; % single spikes
% examplespiketrials = {
% 'E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_58.mat'
% 'E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_58.mat'
% 'E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat'
%      };

% bartrials{1} = 41:52;   
% bartrials{2} = 53:58; % out of focus but it works
% bartrials{3} = 114:185;

%% EpiFlash2T - random movements

trial = load('E:\Data\180621\180621_F3_C1\EpiFlash2T_Raw_180621_F3_C1_1.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials bartrials nobartrials
spiketrials{1} = 1:4; % bar
spiketrials{2} = 5:14; % no bar
examplespiketrials = {
'E:\Data\180621\180621_F3_C1\EpiFlash2T_Raw_180621_F3_C1_1.mat'
'E:\Data\180621\180621_F3_C1\EpiFlash2T_Raw_180621_F3_C1_5.mat'
    };

nobartrials{1} = 5:14; 

bartrials{1} = 1:4;
% bartrials{2} = 19:34;

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\180621\180621_F3_C1\PiezoStep2T_Raw_180621_F3_C1_35.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials
spiketrials{1} = 1:60; 

examplespiketrials = {
'E:\Data\180621\180621_F3_C1\PiezoStep2T_Raw_180621_F3_C1_35.mat'
    };


%% PiezoRamp2T - looking for changes in spike rate - no bar movement, just spikes

trial = load('E:\Data\180621\180621_F3_C1\PiezoRamp2T_Raw_180621_F3_C1_1.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials
spiketrials{1} = 1:60;
examplespiketrials = {
'E:\Data\180621\180621_F3_C1\PiezoRamp2T_Raw_180621_F3_C1_1.mat'
    };

%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Correct for transients
% trials = bartrials;
% Script_FixTheTrialsWithRedLEDTransients


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


