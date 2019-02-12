%% ForceProbe patcing workflow 180307_F2_C1
trial = load('E:Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_24.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

% trial = load('E:\Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_24.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials bartrials
% spiketrials{1} = 24:73; % not good. Skipping this 190201
% 
% 
% examplespiketrials = {
% 'E:\Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_56.mat'
% 'E:\Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_73.mat'
%     };
% 
% bartrials{1} = 24:73; 

%% EpiFlash2T - random movements

trial = load('E:\Data\180307\180307_F2_C1\EpiFlash2T_Raw_180307_F2_C1_1.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials bartrials nobartrials
spiketrials{1} = 1:20; % bar
examplespiketrials = {
'E:\Data\180307\180307_F2_C1\EpiFlash2T_Raw_180307_F2_C1_16.mat'
    };

bartrials{1} = 1:20;

%% PiezoRamp2T - looking for changes in spike rate 

% trial = load('E:\Data\180307\180307_F2_C1\PiezoRamp2T_Raw_180307_F2_C1_1.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
 
clear trials spiketrials
spiketrials{1} = 1:30; 
spiketrials{2} = 31:60; 
examplespiketrials = {
    'E:\Data\180307\180307_F2_C1\PiezoRamp2T_Raw_180307_F2_C1_2.mat'
     };

bartrials = spiketrials;


%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\180307\180307_F2_C1\PiezoStep2T_Raw_180307_F2_C1_7.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials
spiketrials{1} = 1:60; 
spiketrials{2} = 61:90; 
spiketrials{3} = 91:150; 
spiketrials{4} = 151:180; 
spiketrials{5} = 181:240; 

examplespiketrials = {
    'E:\Data\180307\180307_F2_C1\PiezoStep2T_Raw_180307_F2_C1_7.mat'
    'E:\Data\180307\180307_F2_C1\PiezoStep2T_Raw_180307_F2_C1_7.mat'
    'E:\Data\180307\180307_F2_C1\PiezoStep2T_Raw_180307_F2_C1_7.mat'
    'E:\Data\180307\180307_F2_C1\PiezoStep2T_Raw_180307_F2_C1_7.mat'
    'E:\Data\180307\180307_F2_C1\PiezoStep2T_Raw_180307_F2_C1_7.mat'
    };

%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials


%% Run Bar detection scripts one at a time
trials = bartrials;

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


%% Calculate position of femur and tibia from csv files

% After bringing videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.

% trials = nobartrials;
% trialnumlist = [];
% for idx = 1:length(trials)
%     trialnumlist = [trialnumlist trials{idx}]; %#ok<AGROW>
% end
% close all
% 
% Script_AddTrackedPositions
% Script_UseAllTrialsInSetToCorrectLegPosition;
% Script_AddTrackedLegAngleToTrial
% Script_UseAllTrialsInSetToCalculateLegElevation

%% alternative, look at main frequencies rather than spikes

trial = load('B:\Raw_Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_71.mat');
v = trial.voltage_1;
t = makeInTime(trial.params);
v = v-mean(v(t>-.4&t<0));
figure
plot(v)
spectrogram(v,256,250,(1:200),1e4,'yaxis')



