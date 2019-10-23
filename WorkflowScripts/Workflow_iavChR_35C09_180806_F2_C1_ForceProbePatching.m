%% ForceProbe patcing workflow 180806_F2_C1
trial = load('E:\Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_23.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% CurrentStep2T - to get force
trial = load('E:\Data\180806\180806_F2_C1\CurrentStep2T_Raw_180806_F2_C1_5.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 5:4:32;
trials{2} = 6:4:32;
trials{3} = 7:4:32;
trials{4} = 8:4:32;
% trials{2} = 33:60; % MLA, no spikes, except when current injected


%% EpiFlash2T - iav driven movements

trial = load('E:\Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_23.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials spiketrials bartrials
spiketrials{1} = 1:72; % 
spiketrials{2} = 73:144; 
spiketrials{3} = 145:216; 

examplespiketrials = {
'E:\Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_2.mat'
'E:\Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_74.mat'
'E:\Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_176.mat'
   };
bartrials = spiketrials;

%% PiezoRamp2T - sensory feedback responses and spiking

trial = load('E:\Data\180806\180806_F2_C1\PiezoRamp2T_Raw_180806_F2_C1_1.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:60; 

examplespiketrials = {
'E:\Data\180806\180806_F2_C1\PiezoRamp2T_Raw_180806_F2_C1_1.mat'
   };

%% PiezoStep2T - sensory feedback responses and spiking

trial = load('E:\Data\180806\180806_F2_C1\PiezoStep2T_Raw_180806_F2_C1_1.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:42; 

examplespiketrials = {
'E:\Data\180806\180806_F2_C1\PiezoStep2T_Raw_180806_F2_C1_1.mat'
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

