%% ForceProbe patcing workflow 180821_F1_C1
trial = load('E:\Data\181220\181220_F1_C1\EpiFlash2T_Raw_181220_F1_C1_39.mat');
D = fileparts(trial.name);
cd (D)

%% EpiFlash2T - iav driven movements

trial = load('E:\Data\181220\181220_F1_C1\EpiFlash2T_Raw_181220_F1_C1_39.mat');

clear trials spiketrials bartrials

spiketrials{1} = 34:156;
spiketrials{2} = 157:270; % 5HT
spiketrials{3} = 271:325; % MLA
examplespiketrials = {
'E:\Data\181220\181220_F1_C1\EpiFlash2T_Raw_181220_F1_C1_39.mat'
'E:\Data\181220\181220_F1_C1\EpiFlash2T_Raw_181220_F1_C1_159.mat'
'E:\Data\181220\181220_F1_C1\EpiFlash2T_Raw_181220_F1_C1_283.mat'
   };

bartrials = spiketrials;

%% PiezoRamp2T - looking for changes in spike rate 

% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

% No spikes here

%% Extract spikes
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

Script_FixTheTrialsWithRedLEDTransients

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM

%% Epi flash trials

%% Extract spikes





