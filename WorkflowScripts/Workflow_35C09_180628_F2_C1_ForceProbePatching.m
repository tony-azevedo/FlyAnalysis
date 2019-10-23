%% ForceProbe patcing workflow 180628_F2_C1
trial = load('E:\Data\180628\180628_F2_C1\CurrentStep2T_Raw_180628_F2_C1_29.mat');
D = fileparts(trial.name);
cd (D)


%% CurrentStep2T - to get force

% trial = load('E:\Data\180628\180628_F2_C1\CurrentStep2T_Raw_180628_F2_C1_29.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials bartrials
% spiketrials{1} = 17:58; %#ok<*NASGU> % no drugs
% spiketrials{2} = 59:64; %#ok<*NASGU> % Atropine and MLA
% examplespiketrials = {
% 'E:\Data\180621\180621_F1_C1\CurrentStep2T_Raw_180621_F1_C1_1.mat'
% 'E:\Data\180621\180621_F1_C1\CurrentStep2T_Raw_180621_F1_C1_1.mat'
%     };
% 
% bartrials = spiketrials; %#ok<*NASGU> % no drugs

%% EpiFlash2T - random movements

trial = load('E:\Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_8.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials bartrials nobartrials
spiketrials{1} = 1:6;
spiketrials{2} = 7:14; % no bar
spiketrials{3} = 15:24; % MLA
spiketrials{4} = 25:26; % MLA still flowing in
spiketrials{5} = 27:29; % MLA still flowing in

examplespiketrials = {
'E:\Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_3.mat'
'E:\Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_7.mat'
'E:\Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_15.mat'
'E:\Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_26.mat'
'E:\Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_27.mat'
    };

nobartrials{1} = 7:14;

bartrials{1} = 1:6;
bartrials{2} = 15:29;

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('E:\Data\180628\180628_F2_C1\PiezoStep2T_Raw_180628_F2_C1_1.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials
% spiketrials{1} = 1:244; % No MLA
% spiketrials{2} = 245:328; % MLA
% 
% examplespiketrials = {
%     };

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('E:\Data\180628\180628_F2_C1\PiezoRamp2T_Raw_180628_F2_C1_1.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials
% spiketrials{1} = 1:265; % No MLA
% spiketrials{2} = 266:307; % MLA wash in
% spiketrials{3} = 308:349; % MLA
% 
% examplespiketrials = {
%     };



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
