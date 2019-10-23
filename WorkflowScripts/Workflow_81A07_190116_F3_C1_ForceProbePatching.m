%% ForceProbe patcing workflow 190116_F3_C1
trial = load('E:\Data\190116\190116_F3_C1\Sweep2T_Raw_190116_F3_C1_8.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190116\190116_F3_C1\EpiFlash2T_Raw_190116_F3_C1_18.mat');

clear spiketrials bartrials nobartrials

nobartrials{1} = 1:15; % no bar

spiketrials{1} = 1:15; % no bar, caffeine
spiketrials{2} = 16:30; % caffeine
examplespiketrials = {
'E:\Data\190116\190116_F3_C1\EpiFlash2T_Raw_190116_F3_C1_7.mat'
'E:\Data\190116\190116_F3_C1\EpiFlash2T_Raw_190116_F3_C1_18.mat'
    };

bartrials{1} = 16:30; 

%% EpiFlash2TTrain - random movements

trial = load('E:\Data\190116\190116_F3_C1\EpiFlash2TTrain_Raw_190116_F3_C1_75.mat');

clear spiketrials bartrials nobartrials

spiketrials{1} = 1:30; % no bar, caffeine
spiketrials{2} = 30:75; % caffeine
examplespiketrials = {
'E:\Data\190116\190116_F3_C1\EpiFlash2T_Raw_190116_F3_C1_7.mat'
'E:\Data\190116\190116_F3_C1\EpiFlash2T_Raw_190116_F3_C1_18.mat'
    };

% No spikes in these data for this fly
nobartrials{1} = 1:15; % no bar
nobartrials{1} = 46:75; % no bar

bartrials{1} = 16:45; 

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190116\190116_F3_C1\PiezoRamp2T_Raw_190116_F3_C1_1.mat');

% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190116\190116_F3_C1\PiezoStep2T_Raw_190116_F3_C1_4.mat');

% No spikes here


%% Sweep2T -  looking for changes in spike rate 

trial = load('E:\Data\190116\190116_F3_C1\Sweep2T_Raw_190116_F3_C1_8.mat');
clear spiketrials bartrials nobartrials
bartrials{1} = 6:15; 

% No spikes here

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

Script_FixTheTrialsWithRedLEDTransients


%% Calculate position of femur and tibia from csv files

% After bringing videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.

trials = nobartrials;
trialnumlist = [];
for idx = 1:length(trials)
    trialnumlist = [trialnumlist trials{idx}]; %#ok<AGROW>
end
close all

Script_AddTrackedPositions
Script_UseAllTrialsInSetToCorrectLegPosition;
Script_AddTrackedLegAngleToTrial
Script_UseAllTrialsInSetToCalculateLegElevation
