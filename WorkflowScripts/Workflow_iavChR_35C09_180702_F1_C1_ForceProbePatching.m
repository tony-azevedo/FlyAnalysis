%% ForceProbe patcing workflow 180702_F1_C1
trial = load('B:\Raw_Data\180702\180702_F1_C1\CurrentStep2T_Raw_180702_F1_C1_14.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('B:\Raw_Data\180702\180702_F1_C1\CurrentStep2T_Raw_180702_F1_C1_14.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 14:55;
trials{2} = 56:98;
% trials{3} = 76:103; % MLA, no spikes, except when current injected

Nsets = length(trials);

% check the location
trial = load(sprintf(trialStem,35));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% epi flash random movements

trial = load('B:\Raw_Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_7.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 11:100; % 
% trials{2} = 101:175; % Long pulse
% trials{3} = 176:211; % MLA entering
% trials{4} = 212:283; % MLA washout no spikes
Nsets = length(trials);
    
trial = load(sprintf(trialStem,101));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% Run scripts one at a time

% Set probe line 
Script_SetProbeLine 

% double check some trials
trial = load(sprintf(trialStem,67));
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
Script_FindTheMinimumCoM

% Extract spikes
Script_ExtractSpikesFromInterestingTrials
