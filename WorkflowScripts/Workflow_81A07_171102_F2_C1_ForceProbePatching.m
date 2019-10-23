%% ForceProbe patcing workflow 171102_F2_C1
trial = load('E:\Data\171102\171102_F2_C1\EpiFlash2T_Raw_171102_F2_C1_47.mat');
D = fileparts(trial.name);
cd (D)
%%
clear trials spiketrials bartrials

% EpiFlash Sets - cause spikes and video movement
% Position 0 EpiFlash2T: 
spiketrials{1} = 47:91; % before this the EMG was not great
% Position 100 EpiFlash2T: 
spiketrials{2} = 92:119;
% Position 200 EpiFlash2T: 
spiketrials{3} = 120:133;
% Position -100 EpiFlash2T: 
spiketrials{4} = 134:147;
% Position -200 EpiFlash2T: 
spiketrials{5} =  148:161;
% Position 0 EpiFlash2T more spikes: 
spiketrials{6} = 162:173;
exampletrials = {
    'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_10.mat'
    'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_10.mat'
    'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_10.mat'
    };


%% Extract spikes
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% trials = spiketrials;
% exampletrials = examplespiketrials;
% Script_ExtractSpikesFromInterestingTrials

%% Extract spikes
sgn = -1;

% load trial
% spikevars = getacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)]);
% setacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)],spikevars);

% trial.current_2_flipped = sgn*trial.current_2; 
% [trial,spikevars] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');

trials = spiketrials(1:4);
exampletrials = {
'E:\Data\171102\171102_F2_C1\EpiFlash2T_Raw_171102_F2_C1_47.mat'
'E:\Data\171102\171102_F2_C1\EpiFlash2T_Raw_171102_F2_C1_93.mat'
'E:\Data\171102\171102_F2_C1\EpiFlash2T_Raw_171102_F2_C1_125.mat'
'E:\Data\171102\171102_F2_C1\EpiFlash2T_Raw_171102_F2_C1_135.mat'
'E:\Data\171102\171102_F2_C1\EpiFlash2T_Raw_171102_F2_C1_150.mat'
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
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end
