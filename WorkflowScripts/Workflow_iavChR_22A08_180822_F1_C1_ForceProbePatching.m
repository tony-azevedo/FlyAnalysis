%% ForceProbe patcing workflow 180821_F1_C1
trial = load('E:\Data\180822\180822_F1_C1\EpiFlash2T_Raw_180822_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash iav driven movements

trial = load('E:\Data\180822\180822_F1_C1\EpiFlash2T_Raw_180822_F1_C1_1.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd(D);

clear trials spiketrials bartrials
spiketrials{1} = 1:104; % Low
spiketrials{2} = 105:118; % random epi flash driven movements
examplespiketrials = {
'E:\Data\19XXXX\19XXXX_F1_C1\EpiFlash2T_Raw_19XXXX_F1_C1_20.mat'
'E:\Data\19XXXX\19XXXX_F1_C1\EpiFlash2T_Raw_19XXXX_F1_C1_31.mat'
};

bartrials = spiketrials;

%% Extract spikes
trials = spiketrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Run scripts one at a time

% Create trials variable, safeguard
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

% Find the trials with Red LED transients and mark them down
Script_FindTheTrialsWithRedLEDTransients

% Fix the trials with Red LED transients and mark them down
Script_FixTheTrialsWithRedLEDTransients

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM




