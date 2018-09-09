%% ForceProbe patcing workflow 180621_F1_C1
trial = load('B:\Raw_Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('B:\Raw_Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 41:52;
trials{1} = 114:185; % single spikes

Nsets = length(trials);

% check the location
trial = load(sprintf(trialStem,52));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% epi flash random movements

trial = load('B:\Raw_Data\180621\180621_F3_C1\EpiFlash2T_Raw_180621_F3_C1_8.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:4;
trials{1} = 5:14;
Nsets = length(trials);
    
trial = load(sprintf(trialStem,3));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    };

%% ramps cause spikes for this neuron
% just spikes

trial = load('B:\Raw_Data\180621\180621_F3_C1\PiezoRamp2T_Raw_180621_F3_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:60;
Nsets = length(trials);
    
% showProbeImage(trial)

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

% Compare some trials: Inserted the red cube here
trial = load(sprintf(trialStem,31));
showProbeImage(trial)
trial = load(sprintf(trialStem,60));
showProbeImage(trial)

trialnumlist_specific = trials{1};
ZeroForce = 666;
Script_SetTheMinimumCoM_byHand


% Extract spikes
Script_ExtractSpikesFromInterestingTrials
