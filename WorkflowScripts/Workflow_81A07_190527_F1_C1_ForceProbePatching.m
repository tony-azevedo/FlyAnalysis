%% ForceProbe patcing workflow 190527_F1_C1
trial = load('E:\Data\190527\190527_F1_C1\Sweep2T_Raw_190527_F1_C1_30.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190527\190527_F1_C1\EpiFlash2T_Raw_190527_F1_C1_40.mat');

clear spiketrials bartrials nobartrials

bartrials{1} = 13:42; % bar

spiketrials{1} = 13:42; % bar, no caffeine
examplespiketrials = {
'E:\Data\190527\190527_F1_C1\EpiFlash2TTrain_Raw_190527_F1_C1_37.mat'
    };


%% EpiFlash2TTrain - random movements

trial = load('E:\Data\190527\190527_F1_C1\EpiFlash2TTrain_Raw_190527_F1_C1_37.mat');

clear spiketrials bartrials nobartrials

% Note: had to get the fly moving by moving the bar with hand
spiketrials{1} = 1:90; % bar, caffeine
examplespiketrials = {
'E:\Data\190527\190527_F1_C1\EpiFlash2TTrain_Raw_190527_F1_C1_37.mat'
    };

bartrials{1} = 1:90; 

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190527\190527_F1_C1\PiezoRamp2T_Raw_190527_F1_C1_1.mat');

% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190527\190527_F1_C1\PiezoStep2T_Raw_190527_F1_C1_42.mat');

% No spikes here


%% Sweep2T - In TTX, measuring passive movements

trial = load('E:\Data\190527\190527_F1_C1\Sweep2T_Raw_190527_F1_C1_30.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
clear spiketrials bartrials nobartrials
bartrials{1} = 11:30; 

% No spikes here
trialnumlist = 16:25;
for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));
    if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
        probeTrackROI_inFocus;
    elseif isfield(trial,'forceProbeStuff')
        fprintf('%s\n',trial.name);
        fprintf('\t*Has profile: passing over trial for now\n')
    end
end

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
Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
% Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

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
