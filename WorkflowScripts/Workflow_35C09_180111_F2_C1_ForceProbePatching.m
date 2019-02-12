%% ForceProbe patcing workflow 180111_F2_C1

trial = load('E:\Data\180111\180111_F2_C1\CurrentStep2T_Raw_180111_F2_C1_2.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

trial = load('E:\Data\180111\180111_F2_C1\CurrentStep2T_Raw_180111_F2_C1_2.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials bartrials
spiketrials{1} = 4:22; %#ok<*NASGU> % no drugs
spiketrials{2} = 23:42; %#ok<*NASGU> % Atropine and MLA
spiketrials{3} = 43:54; %#ok<*NASGU> % Atropine and MLA
examplespiketrials = {
    };

bartrials = spiketrials;

%% EpiFlash2TTrain - random movements

% trial = load('E:\Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_8.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% clear trials spiketrials bartrials nobartrials
% spiketrials{1} = 1:9; % bar
% spiketrials{2} = 10:19; % no bar
% examplespiketrials = {
%     'E:\Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_8.mat'
%     'E:\Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_17.mat'
%     };

% bartrials{1} = 1:9; 
nobartrials{1} = 10:18; 

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('E:\Data\180111\180111_F2_C1\PiezoStep2T_Raw_180111_F2_C1_1.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials
% spiketrials{1} = 1:30; 
% 
% examplespiketrials = {
%     'E:\Data\180111\180111_F2_C1\PiezoStep2T_Raw_180111_F2_C1_1.mat'
%     };
% 

%% PiezoRamp2T - looking for changes in spike rate 

% trial = load('E:\Data\180111\180111_F2_C1\PiezoRamp2T_Raw_180111_F2_C1_1.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials bartrials
% spiketrials{1} = 1:58; 
% 
% examplespiketrials = {
%     'E:\Data\180111\180111_F2_C1\PiezoRamp2T_Raw_180111_F2_C1_13.mat'
%     };
% 
% bartrials{1} = 31:58; 

%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials


%% Run Bar detection scripts one at a time
trials = bartrials;

% Set probe line 
Script_SetProbeLine 

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand

%% skootch the exposures
% for set = 1:Nsets
%     knownSkootch = 1;
%     trialnumlist = trials{set};
%     % batch_undoSkootchExposure
%     batch_skootchExposure_KnownSkootch
% end


