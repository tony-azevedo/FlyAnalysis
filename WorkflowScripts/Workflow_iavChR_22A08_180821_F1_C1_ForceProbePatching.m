%% ForceProbe patcing workflow 180821_F1_C1
trial = load('E:\Data\180821\180821_F1_C1\EpiFlash2T_Raw_180821_F1_C1_4.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash iav driven movements

trial = load('E:\Data\180821\180821_F1_C1\EpiFlash2T_Raw_180821_F1_C1_4.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd(D);

clear trials spiketrials bartrials
spiketrials{1} = 1:181; % Low
spiketrials{2} = 182:191; % random epi flash driven movements
examplespiketrials = {
'E:\Data\19XXXX\19XXXX_F1_C1\EpiFlash2T_Raw_19XXXX_F1_C1_20.mat'
'E:\Data\19XXXX\19XXXX_F1_C1\EpiFlash2T_Raw_19XXXX_F1_C1_31.mat'
};

bartrials = spiketrials;

%% Run Bar detection scripts one at a time

% Create trials variable, safeguard
trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% Set probe line 
Script_SetProbeLine 

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Remove the LED artefact through offset and subtraction
Script_FixTheTrialsWithRedLEDTransients

% Setting the ZeroForce point for different trials
Script_FindTheMinimumCoM


