%% ForceProbe patcing workflow 181024_F2_C1
trial = load('E:\Data\181024\181024_F2_C1\CurrentStep2T_Raw_181024_F2_C1_23.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% Current step to get force
% 
% trial = load('E:\Data\181024\181024_F2_C1\CurrentStep2T_Raw_181024_F2_C1_23.mat');
% clear trials spiketrials bartrials
% 
% spiketrials{1} = 6:60; %#ok<*NASGU> % no drugs
% spiketrials{2} = 61:110; %atropine MLA
% examplespiketrials = {
% 'E:\Data\181024\181024_F2_C1\CurrentStep2T_Raw_181024_F2_C1_20.mat'
% 'E:\Data\181024\181024_F2_C1\CurrentStep2T_Raw_181024_F2_C1_108.mat'
% };
% bartrials{1} =  6:60; % no drugs
% bartrials{2} =  61:110; % atropine MLA


%% EpiFlash2TTrain - random movements
% 
% trial = load('E:\Data\181024\181024_F2_C1\EpiFlash2TTrain_Raw_181024_F2_C1_4.mat');
% 
% clear spiketrials bartrials
% spiketrials{1} = 1:4; % bar
% 
% bartrials{1} = 1:4; % bar

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar 
% for some reason there is just too much noise, with too small of spikes
% likely the manipulator is making to much noise
trial = load('E:\Data\181024\181024_F2_C1\Sweep2T_Raw_181024_F2_C1_16.mat');

clear spiketrials bartrials
spiketrials{1} = 16:35; % 
spiketrials{2} = 36:55; % atropine, MLA
examplespiketrials = {
    'E:\Data\181024\181024_F2_C1\EpiFlash2TTrain_Raw_181024_F2_C1_4.mat'
};
% bartrials{1} = 16:35; % bar position vs spike rate
% bartrials{2} = 36:55; % bar position vs spike rate

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('E:\Data\181024\181024_F2_C1\PiezoStep2T_Raw_181024_F2_C1_4.mat');
% 
% clear spiketrials bartrials
% spiketrials{1} = 1:210; % control
% spiketrials{2} = 211:252; % atropine
% spiketrials{3} = 253:336; % atropine MLA
% examplespiketrials = {
% 'E:\Data\181024\181024_F2_C1\PiezoStep2T_Raw_181024_F2_C1_34.mat'
% 'E:\Data\181024\181024_F2_C1\PiezoStep2T_Raw_181024_F2_C1_221.mat'
% 'E:\Data\181024\181024_F2_C1\PiezoStep2T_Raw_181024_F2_C1_253.mat'
% };



%% PiezoRamp2T - looking for changes in spike rate 

% trial = load('E:\Data\181024\181024_F2_C1\PiezoRamp2T_Raw_181024_F2_C1_211.mat');
% 
% clear spiketrials bartrials
% spiketrials{1} = 1:280; % control
% spiketrials{2} = 281:336; % atropine
% spiketrials{3} = 337:392; % atropine MLA % beyond 392, the cell is depolarized
% examplespiketrials = {
% 'E:\Data\181024\181024_F2_C1\PiezoRamp2T_Raw_181024_F2_C1_211.mat'
% 'E:\Data\181024\181024_F2_C1\PiezoRamp2T_Raw_181024_F2_C1_285.mat'
% 'E:\Data\181024\181024_F2_C1\PiezoRamp2T_Raw_181024_F2_C1_337.mat'
% };

%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes

trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Run Bar detection scripts one at a time

trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
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

% Correct for transients after spike detection
Script_FixTheTrialsWithRedLEDTransients


%% Calculate position of femur and tibia from csv files
% None here