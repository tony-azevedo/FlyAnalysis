%% ForceProbe patcing workflow 180628_F2_C1
trial = load('E:\Data\180628\180628_F2_C1\CurrentStep2T_Raw_180628_F2_C1_29.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('B:\Raw_Data\180628\180628_F2_C1\CurrentStep2T_Raw_180628_F2_C1_29.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 17:58;
trials{2} = 59:64;

Nsets = length(trials);

% check the location
trial = load(sprintf(trialStem,35));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

% Done:

%% epi flash random movements

trial = load('B:\Raw_Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:6;
trials{2} = 7:14; % no bar
trials{3} = 15:24; % MLA
Nsets = length(trials);
    
trial = load(sprintf(trialStem,3));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% piezo step

trial = load('E:\Data\180628\180628_F2_C1\PiezoStep2T_Raw_180628_F2_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:244;
trials{2} = 245:328; % MLA
Nsets = length(trials);
    

routine = {
    };

%% piezo ramp

trial = load('E:\Data\180628\180628_F2_C1\PiezoRamp2T_Raw_180628_F2_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:265;
% trials{2} = 266:307; % MLA wash in
trials{2} = 308:349; % MLA
Nsets = length(trials);
    

routine = {
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

