%% ForceProbe patcing workflow 180806_F2_C1
trial = load('B:\Raw_Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_23.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('B:\Raw_Data\180806\180806_F2_C1\CurrentStep2T_Raw_180806_F2_C1_5.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 5:4:32;
trials{2} = 6:4:32;
trials{3} = 7:4:32;
trials{4} = 8:4:32;
% trials{2} = 33:60; % MLA, no spikes, except when current injected

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
    'probeTrackROI_IR' 
    };

%% epi flash random movements

trial = load('B:\Raw_Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_23.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:72; % 
trials{2} = 73:144; 
% trials{3} = 176:211; 
% trials{4} = 212:283; 
Nsets = length(trials);
    
trial = load(sprintf(trialStem,36));
showProbeImage(trial)

routine = {
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
Script_FindTheMinimumCoM

% Extract spikes
Script_ExtractSpikesFromInterestingTrials