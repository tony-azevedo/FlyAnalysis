%% ForceProbe patcing workflow 181128_F2_C1
trial = load('E:\Data\181128\181128_F2_C1\CurrentStep2T_Raw_181128_F2_C1_50.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

trial = load('E:\Data\181128\181128_F2_C1\CurrentStep2T_Raw_181128_F2_C1_50.mat');

clear trials spiketrials bartrials

% spiketrials{1} = 1:50; %#ok<*NASGU> % no drugs
% spiketrials{2} = 50:100; %#ok<*NASGU> % No drugs, was flowing in but then the manipulator movement routine died!
% spiketrials{3} = 101:155; %#ok<*NASGU> % No drugs, was flowing in but then the manipulator movement routine died!
% examplespiketrials = {
% 'E:\Data\181128\181128_F2_C1\CurrentStep2T_Raw_181128_F2_C1_45.mat'
% 'E:\Data\181128\181128_F2_C1\CurrentStep2T_Raw_181128_F2_C1_90.mat'
% 'E:\Data\181128\181128_F2_C1\CurrentStep2T_Raw_181128_F2_C1_124.mat'
%     };

% bartrials{1} = 1:50; %#ok<*NASGU> % no drugs
% bartrials{2} = 50:100; %#ok<*NASGU> % No drugs, was flowing in but then the manipulator movement routine died!
% bartrials{3} = 101:155; %#ok<*NASGU> % No drugs, was flowing in but then the manipulator movement routine died!



%% EpiFlash2TTrain - random movements

trial = load('F:\Acquisition\181128\181128_F2_C1\EpiFlash2TTrain_Raw_181128_F2_C1_1.mat');

clear spiketrials bartrials

% % spiketrials{1} = 1:10; % no bar
% spiketrials{1} = 16:20; % bar 1-15 Were in Voltage clamp, incorrect units.
% spiketrials{2} = 21:25; % no bar

nobartrials{1} = 1:10; % no bar
nobartrials{1} = 21:30; % no bar

bartrials{1} = 16:20; % bar 10-15 Were in Voltage clamp, incorrect units.

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\181128\181128_F2_C1\PiezoRamp2T_Raw_181128_F2_C1_1.mat');

clear spiketrials bartrials
% spiketrials{1} = 1:280; % control
% spiketrials{2} = 281:336; % moved probe to base and tip. How do these responses compare?
% spiketrials{3} = 337:392; % atropine, atropine MLA
% examplespiketrials = {
% 'E:\Data\181128\181128_F2_C1\PiezoRamp2T_Raw_181128_F2_C1_1.mat'
% 'E:\Data\181128\181128_F2_C1\PiezoRamp2T_Raw_181128_F2_C1_1.mat'
% 'E:\Data\181128\181128_F2_C1\PiezoRamp2T_Raw_181128_F2_C1_1.mat'
%     };

bartrials{1} = 337:392; % atropine, atropine MLA

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('E:\Data\181128\181128_F2_C1\PiezoStep2T_Raw_181128_F2_C1_2.mat');

% clear spiketrials bartrials
% spiketrials{1} = 1:210; % control
% spiketrials{2} = 211:252; % atropine
% spiketrials{3} = 253:294; % atropine MLA
% examplespiketrials = {
% 'E:\Data\181128\181128_F2_C1\PiezoStep2T_Raw_181128_F2_C1_2.mat'
% 'E:\Data\181128\181128_F2_C1\PiezoStep2T_Raw_181128_F2_C1_2.mat'
% 'E:\Data\181128\181128_F2_C1\PiezoStep2T_Raw_181128_F2_C1_2.mat'
%     };

% bartrials{1} = 253:294; % atropine MLA

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

