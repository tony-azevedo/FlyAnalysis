%% Run each section above in turn, then run the sections below on each protocol
clear trials

%% Extract spikes
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name); cd(D)
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Run Bar detection scripts one at a time

trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name); cd(D)

% Set probe line 
Script_SetProbeLine % showProbeLocation(trial)

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

Script_FixTheTrialsWithRedLEDTransients

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated


%% Calculate position of femur and tibia from csv files

% After bringing videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.

trials = nobartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name); cd(D)

trialnumlist = [];
for idx = 1:length(trials)
    trialnumlist = [trialnumlist trials{idx}]; %#ok<AGROW>
end
close all

Script_AddTrackedPositions
Script_UseAllTrialsInSetToCorrectLegPosition;
% Between these two steps, I'm missing the fastest swings. Need to fill in
% the frames with high speed. Use 180628_F2_C1 to look at this
Script_AddTrackedLegAngleToTrial
Script_UseAllTrialsInSetToCalculateLegElevation

