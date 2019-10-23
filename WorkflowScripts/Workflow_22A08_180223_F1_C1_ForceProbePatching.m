%% ForceProbe patcing workflow 180223_F1_C1 - 
% This cell has somewhat ok spikes during the EpiFlash trials, but no
% spikes during current injection.

trial = load('E:\Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step movements
% No spikes

%% EpiFlash stimuli

trial = load('E:\Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_1.mat');

clear spiketrials bartrials nobartrials

spiketrials{1} = 1:7; % no bar, caffeine
spiketrials{2} = 8:14; % caffeine
examplespiketrials = {
'E:\Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_14.mat'
'E:\Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_14.mat'
    };

bartrials{1} = 1:14; 

%% Piezo ramp stimuli

trial = load('E:\Data\180223\180223_F1_C1\PiezoRamp2T_Raw_180223_F1_C1_1.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:90; % early on
Nsets = length(trials);
    
trial = load(sprintf(trialStem,8));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% Run scripts one at a time

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



trialnumlist_specific = 226:258;
ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand


% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% skootch the exposures
for set = 1:Nsets
    knownSkootch = 1;
    trialnumlist = trials{set};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end

%% Epi flash trials

%% Extract spikes

% This was agonizing for this cell, very annoying

%% Align spikes and bar trajectories



