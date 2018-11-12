%% ForceProbe patcing workflow 181021_F1_C1
trial = load('F:\Acquisition\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force

trial = load('F:\Acquisition\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 6:60; % no drugs

Nsets = length(trials);

% check the location
trial = load(sprintf(trialStem,12));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    };


%% epi flash train random movements

trial = load('F:\Acquisition\181021\181021_F1_C1\EpiFlash2TTrain_Raw_181021_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
% trials{1} = 1:4; % bar, but no blue light!
trials{1} = 5:12; % bar
% trials{1} = 11:18; % no bar


Nsets = length(trials);
    
trial = load(sprintf(trialStem,3));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };


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

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand


% Extract spikes
Script_ExtractSpikesFromInterestingTrials

