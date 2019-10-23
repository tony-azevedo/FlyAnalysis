%% ForceProbe patcing workflow 180702_F1_C1
trial = load('E:\Data\180702\180702_F1_C1\CurrentStep2T_Raw_180702_F1_C1_14.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('E:\Data\180702\180702_F1_C1\CurrentStep2T_Raw_180702_F1_C1_14.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials spiketrials bartrials
trials{1} = 14:7:55;
trials{2} = 15:7:55;
trials{3} = 16:7:55;
trials{4} = 17:7:55;
trials{5} = 18:7:55;
trials{6} = 19:7:55;
trials{7} = 20:7:55;
%trials{2} = 56:98;
% trials{3} = 76:103; % MLA, no spikes, except when current injected


%% EpiFlash2T - iav driven movements

trial = load('E:\Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_7.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials spiketrials bartrials
spiketrials{1} = 11:100; % 
spiketrials{2} = 101:175; % Long pulse
spiketrials{3} = 176:211; % MLA entering
spiketrials{4} = 212:283; % MLA washout no spikes
examplespiketrials = {
'E:\Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_15.mat'
'E:\Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_110.mat'
'E:\Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_176.mat'
'E:\Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_212.mat'
   };
bartrials = spiketrials;

%% PiezoRamp2T - sensory feedback responses and spiking

trial = load('E:\Data\180702\180702_F1_C1\PiezoRamp2T_Raw_180702_F1_C1_1.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:60; 

examplespiketrials = {
'E:\Data\180702\180702_F1_C1\PiezoRamp2T_Raw_180702_F1_C1_1.mat'
   };

%% PiezoStep2T - sensory feedback responses and spiking

trial = load('E:\Data\180702\180702_F1_C1\PiezoStep2T_Raw_180702_F1_C1_1.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:42; 

examplespiketrials = {
'E:\Data\180702\180702_F1_C1\PiezoStep2T_Raw_180702_F1_C1_1.mat'
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
Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM

