%% ForceProbe patcing workflow 170921_F1_C1 for a single probe vector
trial = load('E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');


%% epi flash Twitch movements

trial = load('E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');

% EpiFlash Sets - cause spikes and video movement
clear trials spiketrials
spiketrials{1} = 22:151;
examplespiketrials = {
'E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_121.mat'
    };

%% Extract spikes
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Extract spikes
trial = load('E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_102.mat');
spikevars = getacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)]);
% setacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)],spikevars);

trial.current_2_flipped = -1*trial.current_2; 
[trial,vars_skeleton] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');

trials = spiketrials(1);
exampletrials = {
    'E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_102.mat'
            };

Script_ExtractEMGSpikesFromInterestingTrials

%% Run scripts one at a time

% Set probe line 
Script_SetProbeLine 

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand


