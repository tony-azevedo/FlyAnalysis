%% ForceProbe patcing workflow 180329_F1_C1
trial = load('E:\Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_11.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('E:\Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_11.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
% trials{1} = 11:15; Not worth analysing
% trials{1} = (33:75); % the probe is not in focus
trials{1} = 34:75; % before this (33:75) the probe is not in focus
% trials{2} = 76:91; % MLA, no spikes, except when current injected
% trials{3} = 92:103; % MLA, longer current injection, no spikes during baseline


%% EpiFlash2T iav Chr activation

trial = load('E:\Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_9.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials spiketrials bartrials
spiketrials{1} = 9:40; % Low
spiketrials{2} = 41:69; % High
spiketrials{3} = 70:101; % MLA, early, low intensity
spiketrials{4} = 102:133; % MLA, late, high intensity
spiketrials{5} = 134:165; % MLA washout no spikes
examplespiketrials = {
'E:\Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_11.mat'
'E:\Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_50.mat'
'E:\Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_106.mat'
'E:\Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_145.mat'
'E:\Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_145.mat'
   };

bartrials = spiketrials;

%% PiezoRamp2T - sensory feedback responses and spiking

trial = load('E:\Data\180329\180329_F1_C1\PiezoRamp2T_Raw_180329_F1_C1_1.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:60; 

examplespiketrials = {
'E:\Data\180329\180329_F1_C1\PiezoRamp2T_Raw_180329_F1_C1_1.mat'
   };

%% PiezoStep2T - sensory feedback responses and spiking

trial = load('E:\Data\180329\180329_F1_C1\PiezoStep2T_Raw_180329_F1_C1_1.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:42; 

examplespiketrials = {
'E:\Data\180329\180329_F1_C1\PiezoStep2T_Raw_180329_F1_C1_1.mat'
   };

%% Extract spikes
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Run scripts one at a time
trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% Set probe line 
Script_SetProbeLine 

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

%% Interesting things for this fly
% include addition of MLA. Useful to compare forces on the bar with or
% without input to the motor neuron spiking. 

% MLA is an important manipulation
trialStem = 'CurrentStep2T_Raw_180329_F1_C1_%d.mat';
showProbeImage(load(sprintf(trialStem,75)))
showProbeImage(load(sprintf(trialStem,76)))

% Trials before and after MLA are in the same position, so it is possible
% to compare probe positions






