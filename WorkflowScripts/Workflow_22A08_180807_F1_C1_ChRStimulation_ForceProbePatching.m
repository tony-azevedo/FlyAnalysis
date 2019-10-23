%% ForceProbe patcing workflow 180807_F1_C1
trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_26.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash Twitch movements

trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_26.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear bartrials spiketrials trials 
bartrials{1} = 10:204; % Low
bartrials{2} = 205:258; % High 

spiketrials{1} = 10:204; % Low
spiketrials{2} = 205:258; % High 

examplespiketrials = {
'E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_150.mat'
    };

%% Sweep, random movments % Not that informative

trial = load('B:\Raw_Data\180807\180807_F1_C1\Sweep2T_Raw_180807_F1_C1_10.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear trials 
% Trials 1:5 show twitches in the muscle 
trials{1} = 6:10; % Low

%% Extract spikes
% trials = spiketrials;
% exampletrials = examplespiketrials;
% Script_ExtractSpikesFromInterestingTrials

%% Extract spikes
sgn = 1;

% load trial
% spikevars = getacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)]);

trial.current_2_flipped = sgn*trial.current_2; 
[trial,spikevars] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');

% trials = spiketrials(1);
% exampletrials = examplespiketrials;
% 
% Script_ExtractEMGSpikesFromInterestingTrials


%% Run scripts one at a time

% Set probe line 
Script_SetProbeLine 

% double check some trials
trial = load(sprintf(trialStem,66));
showProbeLocation(trial)

% trial = probeLineROI(trial);

% Find an area to smooth out the pixels
% Script_FindAreaToSmoothOutPixels

% Track the bar
% Script_TrackTheBarAcrossTrialsInSet

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% Compare some trials: Inserted the red cube here
% trial = load(sprintf(trialStem,31));
% showProbeImage(trial)
% trial = load(sprintf(trialStem,60));
% showProbeImage(trial)

trialnumlist_specific = trials{1};
ZeroForce = 700;
Script_SetTheMinimumCoM_byHand

trial = load(sprintf(trialStem,225));
showProbeImage(trial)
trial = load(sprintf(trialStem,226));
showProbeImage(trial)

trialnumlist_specific = 205:225;
ZeroForce = 700;
Script_SetTheMinimumCoM_byHand

setpoint = mean(trial.forceProbeStuff.CoM(ft_idx' & trial.forceProbeStuff.CoM<quantile(trial.forceProbeStuff.CoM(:),0.05)))

% moved the red cube in. This shifts 0
trialnumlist_specific = 226:258;
ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand


%% Extract spikes
% Script_ExtractSpikesFromInterestingTrials
% Script_FixTheTrialsWithRedLEDTransients



