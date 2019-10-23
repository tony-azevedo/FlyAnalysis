%% ForceProbe patcing workflow 180404_F1_C1
trial = load('E:\Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_6.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash random movements

trial = load('E:\Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_6.mat');

clear trials spiketrials bartrials
spiketrials{1} = 2:28; % Low
spiketrials{2} = 29:56; % High
spiketrials{3} = 66:121; % more High
spiketrials{4} = 122:137; % more High
spiketrials{5} = 138:201; % 5HT
   
spiketrials{1} = 1:35; % no drugs
examplespiketrials = {
'E:\Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_38.mat'
};

bartrials = spiketrials;

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
Script_FindTheMinimumCoM



