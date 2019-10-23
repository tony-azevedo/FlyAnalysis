%% ForceProbe patcing workflow 171101_F1_C1
trial = load('E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_303.mat');
D = fileparts(trial.name);
cd (D)

%%
clear trials spiketrials bartrials

% EpiFlash Sets - cause spikes and video movement
% Position 0 EpiFlash2T: 16:195
spiketrials{1} = 16:195;
% Position 0 EpiFlash2T more spikes: 196:210
spiketrials{2} = 196:210;
% Position 100 EpiFlash2T: 211:240
spiketrials{3} = 211:240;
% Position 200 EpiFlash2T: 241:270
spiketrials{4} = 241:270;
% Position -100 EpiFlash2T: 271:300
spiketrials{5} =  271:300;
% Position -200 EpiFlash2T: 301:330
spiketrials{6} = 301:330;

examplespiketrials = {
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_18.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_200.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_212.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_242.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_272.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_303.mat'
    };

bartrials = spiketrials;

%% Extract spikes
trials = spiketrials;
exampletrials = examplespiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Extract spikes
trial = load('E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_17.mat');
spikevars = getacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)]);
% setacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)],spikevars);

sgn = -1;
trial.current_2_flipped = sgn*trial.current_2; 
[trial,vars_skeleton] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');

trials = spiketrials;
exampletrials = {
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_17.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_204.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_214.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_249.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_291.mat'
'E:\Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_306.mat'
            };

Script_ExtractEMGSpikesFromInterestingTrials

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

ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand

% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% skootch the exposures
for set = 1:Nsets
    knownSkootch = 1;
    trialnumlist = trials{set};
    %batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end


