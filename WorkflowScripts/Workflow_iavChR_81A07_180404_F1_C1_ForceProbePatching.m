%% ForceProbe patching workflow 180404_F1_C1 IAV CHR stimulation with LED
trial = load('E:\Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_15.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% epi flash random movements

trial = load('E:\Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_13.mat');

clear spiketrials bartrials
% Detailed
spiketrials{1} = 13:44; % Low
spiketrials{2} = 45:68; % High
spiketrials{3} = 69:88; % more High caffeine
spiketrials{4} = 89:108; % more High
spiketrials{4} = 109:115; % longer caffeine
spiketrials{5} = 116:150; % more low 

% simplified
clear spiketrials
spiketrials{1} = 13:68; 
spiketrials{2} = 69:115; % more High caffeine
spiketrials{3} = 116:150; % washout

examplespiketrials = {
    'E:\Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_57.mat'
    'E:\Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_107.mat'
    'E:\Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_149.mat'
};

bartrials = spiketrials;

%% Extract spikes
trials = spiketrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials


%% Run Bar detection scripts one at a time

trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% Set probe line 
Script_SetProbeLine % showProbeLocation(trial)

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

Script_FixTheTrialsWithRedLEDTransients


