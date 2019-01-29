%% ForceProbe patcing workflow 190123_F3_C1
trial = load('F:\Acquisition\190123\190123_F3_C1\EpiFlash2T_Raw_190123_F3_C1_78.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - to get force

%% EpiFlash2T - random movements

trial = load('F:\Acquisition\190123\190123_F3_C1\EpiFlash2T_Raw_190123_F3_C1_78.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials

spiketrials{1} = 1:287;
spiketrials{2} = 288:381; 
examplespiketrials = {
    'F:\Acquisition\190123\190123_F3_C1\EpiFlash2T_Raw_190123_F3_C1_99.mat'
    'F:\Acquisition\190123\190123_F3_C1\EpiFlash2T_Raw_190123_F3_C1_333.mat'
    };

bartrials{1} = 1:287; 
bartrials{2} = 288:381; % MLA

%% PiezoRamp2T - looking for changes in spike rate 

%% PiezoStep2T -  looking for changes in spike rate 

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar

%% Run scripts one at a time
trials = bartrials;

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
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand


%% Extract spikes
% trials = spiketrials;
% exampletrials = examplespiketrials;
% Script_ExtractSpikesFromInterestingTrials
% Script_FixTheTrialsWithRedLEDTransients % I'm convinced that with 10 ms
% flashes, nothing happens during the flash


