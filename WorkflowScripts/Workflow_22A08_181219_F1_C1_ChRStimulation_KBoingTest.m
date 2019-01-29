%% ForceProbe patcing workflow 181024_F2_C1
trial = load('F:\Acquisition\181219\181219_F1_C1\EpiFlash2T_Raw_181219_F1_C1_108.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials


%% EpiFlash2T - ChR stimulation, Red artifact!

trial = load('F:\Acquisition\181219\181219_F1_C1\EpiFlash2T_Raw_181219_F1_C1_108.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials

% spiketrials{1} = 1:4; % bar

bartrials{1} = 17:159; % bar
% bartrials{2} = 160:162; % bar
% bartrials{3} = 163:165; % bar
% bartrials{4} = 166:168; % bar
% bartrials{5} = 169:174; % bar
% bartrials{6} = 175:177; % bar
% bartrials{7} = 178:180; % bar
% 

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar
trial = load('F:\Acquisition\181219\181219_F1_C1\Sweep2T_Raw_181219_F1_C1_6.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:18; % 

bartrials{1} = 1:18; % bar position vs spike rate


%% PiezoRamp2T - looking for changes in spike rate 
trial = load('F:\Acquisition\181219\181219_F1_C1\PiezoRamp2T_Raw_181219_F1_C1_5.mat');


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

% Find the trials with Red LED transients and mark them down
% Script_FindTheTrialsWithRedLEDTransients % Using UV Led

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand


%% Extract spikes
trials = spiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Calculate position of femur and tibia from csv files
% None here