%% ForceProbe patcing workflow 180328_F1_C1
trial = load('E:\Data\180328\180328_F1_C1\CurrentStep2T_Raw_180328_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('E:\Data\180328\180328_F1_C1\CurrentStep2T_Raw_180328_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials spiketrials bartrials
% trials have similar shapes and spikes sizes
spiketrials{1} = 1:5:50;
spiketrials{2} = 2:5:50;
spiketrials{3} = 3:5:50;
spiketrials{4} = 4:5:50;
spiketrials{5} = 5:5:50;

examplespiketrials = {
'E:\Data\180328\180328_F1_C1\EpiFlash2T_Raw_180328_F1_C1_16.mat'
'E:\Data\180328\180328_F1_C1\EpiFlash2T_Raw_180328_F1_C1_99.mat'
   };

bartrials = spiketrials;


%% EpiFlash2T - iav driven movements

trial = load('E:\Data\180328\180328_F1_C1\EpiFlash2T_Raw_180328_F1_C1_19.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear trials spiketrials bartrials
spiketrials{1} = 16:66; % Low !! Bar is in focus need to fix double gaussian routine
spiketrials{2} = 67:114; % High

examplespiketrials = {
'E:\Data\180328\180328_F1_C1\EpiFlash2T_Raw_180328_F1_C1_16.mat'
'E:\Data\180328\180328_F1_C1\EpiFlash2T_Raw_180328_F1_C1_99.mat'
   };

bartrials = spiketrials;

%% PiezoRamp2T - sensory feedback responses and spiking

trial = load('E:\Data\180328\180328_F1_C1\PiezoRamp2T_Raw_180328_F1_C1_114.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear trials spiketrials bartrials
spiketrials{1} = 1:195; % Low !! Bar is in focus need to fix double gaussian routine

examplespiketrials = {
'E:\Data\180328\180328_F1_C1\PiezoRamp2T_Raw_180328_F1_C1_114.mat'
   };

%% PiezoStep2T - sensory feedback responses and spiking

trial = load('E:\Data\180328\180328_F1_C1\PiezoStep2T_Raw_180328_F1_C1_3.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:162; 

examplespiketrials = {
'E:\Data\180328\180328_F1_C1\PiezoStep2T_Raw_180328_F1_C1_3.mat'
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

% double check some trials
trial = load(sprintf(trialStem,66));
showProbeLocation(trial)

% trial = probeLineROI(trial);

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% Epi flash trials

%% Extract spikes


