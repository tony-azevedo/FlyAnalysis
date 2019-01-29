%% ForceProbe patcing workflow 190110_F2_C1
trial = load('F:\Acquisition\190110\190110_F2_C1\EpiFlash2T_Raw_190110_F2_C1_14.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - to get force

%% EpiFlash2T - random movements

trial = load('F:\Acquisition\190110\190110_F2_C1\EpiFlash2T_Raw_190110_F2_C1_14.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials

spiketrials{1} = 13:136; %
spiketrials{1} = 137:166; %

bartrials{1} = 13:166; % bar 10-15 Were in Voltage clamp, incorrect units.

%% PiezoRamp2T - looking for changes in spike rate 

%% PiezoStep2T -  looking for changes in spike rate 

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar

%% Run scripts one at a time
% trials = bartrials;
% 
% % Set probe line 
% Script_SetProbeLine 
% 
% % double check some trials
% trial = load(sprintf(trialStem,66));
% showProbeLocation(trial)
% 
% % trial = probeLineROI(trial);
% 
% % Find an area to smooth out the pixels
% Script_FindAreaToSmoothOutPixels
% 
% % Track the bar
% Script_TrackTheBarAcrossTrialsInSet
% 
% % Find the trials with Red LED transients and mark them down
% % Script_FindTheTrialsWithRedLEDTransients % Using UV Led
% 
% % Fix the trials with Red LED transients and mark them down
% % Script_FixTheTrialsWithRedLEDTransients % Using UV Led
% 
% % Find the minimum CoM, plot a few examples from each trial block and check.
% % Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
% Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand


%% Extract spikes
trials = spiketrials;
Script_ExtractSpikesFromInterestingTrials

