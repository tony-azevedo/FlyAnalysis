%% ForceProbe patcing workflow 180313_F1_C1
trial = load('B:\Raw_Data\180313\180313_F1_C1\EpiFlash2TTrain_Raw_180313_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials


%% CurrentStep2T - to get force

% trial = load('E:\Data\180313\180313_F1_C1\CurrentStep2T_Raw_180313_F1_C1_12.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
%
% clear trials spiketrials bartrials
% spiketrials{1} = 12:61;
% examplespiketrials = {
% 'E:\Data\180313\180313_F1_C1\CurrentStep2T_Raw_180313_F1_C1_12.mat'
% };

% bartrials{1} = 12:61; 

%% EpiFlash2T - random movements 

% Not worth looking at spikes
trial = load('E:\Data\180313\180313_F1_C1\EpiFlash2T_Raw_180313_F1_C1_1.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials bartrials nobartrials
spiketrials{1} = 1:4; % bar
examplespiketrials = {
    'E:\Data\180313\180313_F1_C1\EpiFlash2T_Raw_180313_F1_C1_1.mat'
    };

% bartrials{1} = 1:4;

%% EpiFlash2TTrain - random movements 

trial = load('E:\Data\180313\180313_F1_C1\EpiFlash2TTrain_Raw_180313_F1_C1_2.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials bartrials nobartrials
spiketrials{1} = 1:5; % bar
examplespiketrials = {
    'E:\Data\181014\181014_F1_C1\Sweep2T_Raw_181014_F1_C1_34.mat'
    };

% bartrials{1} = 1:5;

%% PiezoRamp2T - looking for changes in spike rate 

% Not worth detecting spikes
trial = load('E:\Data\180313\180313_F1_C1\PiezoStep2T_Raw_180313_F1_C1_1.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
 
clear trials spiketrials
spiketrials{1} = 1:180; 
examplespiketrials = {
'E:\Data\180313\180313_F1_C1\PiezoStep2T_Raw_180313_F1_C1_1.mat'};


%% PiezoStep2T -  looking for changes in spike rate 

% Not worth detecting spikes
trial = load('E:\Data\180313\180313_F1_C1\PiezoStep2T_Raw_180313_F1_C1_1.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials
spiketrials{1} = 1:180; 

examplespiketrials = {
    'E:\Data\180307\180307_F2_C1\PiezoStep2T_Raw_180307_F2_C1_7.mat'
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
