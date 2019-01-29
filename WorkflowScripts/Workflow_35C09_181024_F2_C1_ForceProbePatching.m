%% ForceProbe patcing workflow 181024_F2_C1
trial = load('F:\Acquisition\181024\181024_F2_C1\CurrentStep2T_Raw_181024_F2_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% Current step to get force

trial = load('F:\Acquisition\181024\181024_F2_C1\CurrentStep2T_Raw_181024_F2_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials spiketrials bartrials

spiketrials{1} = 6:60; %#ok<*NASGU> % no drugs
spiketrials{2} = 61:110; %atropine MLA

bartrials{1} =  6:60; % no drugs
bartrials{1} =  6:60; % no drugs
% no additional MLA trials



%% EpiFlash2TTrain - random movements

trial = load('F:\Acquisition\181024\181024_F2_C1\EpiFlash2TTrain_Raw_181024_F2_C1_4.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials

spiketrials{1} = 1:4; % bar

bartrials{1} = 1:4; % bar


%% Sweep2T - , looking for changes in spike rate with slow movement of the bar
trial = load('F:\Acquisition\181024\181024_F2_C1\Sweep2T_Raw_181024_F2_C1_20.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:35; % 
spiketrials{2} = 36:55; % atropine, MLA

% bartrials{1} = 16:35; % bar position vs spike rate
% bartrials{2} = 36:55; % bar position vs spike rate

% ***** These 10 s trials are longer than the arbitrary max length for
% spike detection. Fix it.

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('F:\Acquisition\181024\181024_F2_C1\PiezoStep2T_Raw_181024_F2_C1_14.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:210; % control
spiketrials{2} = 211:252; % atropine
spiketrials{3} = 253:336; % atropine MLA



%% PiezoRamp2T - looking for changes in spike rate 

trial = load('F:\Acquisition\181024\181024_F2_C1\PiezoRamp2T_Raw_181024_F2_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:280; % control
spiketrials{2} = 281:336; % atropine
spiketrials{3} = 337:448; % atropine MLA


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