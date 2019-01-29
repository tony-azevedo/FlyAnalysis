%% ForceProbe patcing workflow 181021_F1_C1
trial = load('F:\Acquisition\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% Current step to get force

trial = load('F:\Acquisition\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_1.mat');
% clear spiketrials bartrials

% spiketrials{1} = 6:60; %#ok<*NASGU> % no drugs % Done

% bartrials{1} =  6:60; % no drugs % Done
% no additional MLA trials



%% EpiFlash2TTrain - random movements

trial = load('F:\Acquisition\181021\181021_F1_C1\EpiFlash2TTrain_Raw_181021_F1_C1_5.mat');
% clear spiketrials bartrials

% spiketrials{1} = 1:12; % bar % No all of the trials are good, depolarization block

% bartrials{1} = 1:12; % bar


%% Sweep2T - , looking for changes in spike rate with slow movement of the bar
% None for this cell
% trial = load('F:\Acquisition\');
% [~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);
% 
% clear spiketrials bartrials
% spiketrials{1} = ; % 
% 
% bartrials{1} = ; % 
% 

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('F:\Acquisition\181021\181021_F1_C1\PiezoStep2T_Raw_181021_F1_C1_173.mat');
% [~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);
% 
% clear spiketrials bartrials
% spiketrials{1} = 6:173; % No MLA


%% PiezoRamp2T -, looking for changes in spike rate 

% trial = load('F:\Acquisition\181021\181021_F1_C1\PiezoRamp2T_Raw_181021_F1_C1_220.mat');
% clear spiketrials bartrials
% spiketrials{1} = 2:191; % No MLA
% spiketrials{2} = 192:219; % No MLA
% 

%% Run scripts one at a time
trials = bartrials;
Nsets = length(trials);

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

% Find the trials with Red LED transients and mark them down
% Script_FindTheTrialsWithRedLEDTransients % Using UV Led

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand


%% Extract spikes
trials = spiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Calculate position of femur and tibia from csv files
% None here