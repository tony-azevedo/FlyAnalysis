%% ForceProbe patcing workflow 180328_F4_C1
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials


%% epi flash random movements

trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_1.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd(D);

clear trials
trials{1} = 1:32; % Low
trials{2} = 33:48; % High
trials{3} = 49:64; % High long
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

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM

%% Epi flash trials

%% Extract spikes


