%% ForceProbe patcing workflow 180821_F1_C1
trial = load('B:\Raw_Data\180821\180821_F1_C1\EpiFlash2T_Raw_180821_F1_C1_4.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash iav driven movements

trial = load('B:\Raw_Data\180821\180821_F1_C1\EpiFlash2T_Raw_180821_F1_C1_4.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd(D);

clear trials
trials{1} = 1:181; % Low
trials{2} = 182:191; % random epi flash driven movements
Nsets = length(trials);
    
trial = load(sprintf(trialStem,33));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
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
Script_FindTheTrialsWithRedLEDTransients

% Fix the trials with Red LED transients and mark them down
Script_FixTheTrialsWithRedLEDTransients

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM


%% Epi flash trials

%% Extract spikes


