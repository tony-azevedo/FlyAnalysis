%% ForceProbe patcing workflow 180320_F1_C1
trial = load('B:\Raw_Data\180320\180320_F1_C1\EpiFlash2T_Raw_180320_F1_C1_3.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Epi Flash stimuli

trial = load('B:\Raw_Data\180320\180320_F1_C1\EpiFlash2T_Raw_180320_F1_C1_3.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:8; % beautiful vidoes of the leg with no bar, but not analyable yet
Nsets = length(trials);


routine = {
    'probeTrackROI_IR'
    };

%% Epi Flash Train stimuli

trial = load('B:\Raw_Data\180320\180320_F1_C1\EpiFlash2TTrain_Raw_180320_F1_C1_18.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:8; % beautiful vidoes of the leg with no bar, but not analyable yet
Nsets = length(trials);
    
trial = load(sprintf(trialStem,30));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR'
    };

%% Ramp stimuli

trial = load('B:\Raw_Data\180320\180320_F1_C1\PiezoRamp2T_Raw_180320_F1_C1_57.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:58;
Nsets = length(trials);
    
trial = load(sprintf(trialStem,30));
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
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% Compare some trials: Inserted the red cube here
trial = load(sprintf(trialStem,31));
showProbeImage(trial)
trial = load(sprintf(trialStem,60));
showProbeImage(trial)

trialnumlist_specific = trials{1};
ZeroForce = 700;
Script_SetTheMinimumCoM_byHand

trial = load(sprintf(trialStem,225));
showProbeImage(trial)
trial = load(sprintf(trialStem,226));
showProbeImage(trial)

trialnumlist_specific = 205:225;
ZeroForce = 700;
Script_SetTheMinimumCoM_byHand

setpoint = mean(trial.forceProbeStuff.CoM(ft_idx' & trial.forceProbeStuff.CoM<quantile(trial.forceProbeStuff.CoM(:),0.05)))

% moved the red cube in. This shifts 0
trialnumlist_specific = 226:258;
ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand


% Extract spikes
Script_ExtractSpikesFromInterestingTrials
