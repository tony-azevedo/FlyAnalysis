%% ForceProbe patcing workflow 180404_F1_C1
trial = load('B:\Raw_Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_6.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash random movements

trial = load('B:\Raw_Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_6.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd(D);

clear trials
trials{1} = 2:28; % Low
trials{2} = 29:56; % High
trials{3} = 66:121; % more High
trials{4} = 122:137; % more High
trials{5} = 138:201; % 5HT
Nsets = length(trials);
    
trial = load(sprintf(trialStem,33));
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



