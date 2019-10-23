%% ForceProbe patcing workflow 180328_F4_C1
trial = load('E:\Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials


%% EpiFlash2T - 

trial = load('E:\Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_1.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:32; % Low
spiketrials{2} = 33:48; % High
spiketrials{3} = 49:64; % High long
spiketrials{4} = 65:80; % High short
spiketrials{5} = 81:96; % High long
examplespiketrials = {
'E:\Data\19XXXX\19XXXX_F1_C1\EpiFlash2T_Raw_19XXXX_F1_C1_20.mat'
'E:\Data\19XXXX\19XXXX_F1_C1\EpiFlash2T_Raw_19XXXX_F1_C1_31.mat'
};

bartrials = spiketrials(3);

%% Extract spikes
trials = spiketrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
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

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM

