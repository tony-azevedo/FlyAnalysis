% 35C09 Typical workflow
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials
%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
trials = spiketrials;
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
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand

Script_FixTheTrialsWithRedLEDTransients


%% Calculate position of femur and tibia from csv files

% After bringing videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.

trials = nobartrials;
trialnumlist = [];
for idx = 1:length(trials)
    trialnumlist = [trialnumlist trials{idx}]; %#ok<AGROW>
end
close all

Script_AddTrackedPositions
Script_UseAllTrialsInSetToCorrectLegPosition;
Script_AddTrackedLegAngleToTrial
Script_UseAllTrialsInSetToCalculateLegElevation