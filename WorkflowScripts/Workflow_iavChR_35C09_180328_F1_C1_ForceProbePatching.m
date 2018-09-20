%% ForceProbe patcing workflow 180328_F1_C1
trial = load('B:\Raw_Data\180328\180328_F1_C1\CurrentStep2T_Raw_180328_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('B:\Raw_Data\180328\180328_F1_C1\CurrentStep2T_Raw_180328_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
% trials have similar shapes and spikes sizes
trials{1} = 1:5:50;
trials{2} = 2:5:50;
trials{3} = 3:5:50;
trials{4} = 4:5:50;
trials{5} = 5:5:50;

Nsets = length(trials);

% check the location
trial = load(sprintf(trialStem,35));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% epi flash random movements

trial = load('B:\Raw_Data\180328\180328_F1_C1\EpiFlash2T_Raw_180328_F1_C1_19.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear trials
% trials{1} = 16:66; % Low !! Bar is in focus need to fix double gaussian
% routine
trials{1} = 67:114; % High
Nsets = length(trials);
    
trial = load(sprintf(trialStem,68));
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

trialnumlist_specific = 226:258;
ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand


% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% Epi flash trials

%% Extract spikes


