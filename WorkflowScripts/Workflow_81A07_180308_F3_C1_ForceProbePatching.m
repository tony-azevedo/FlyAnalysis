%% ForceProbe patcing workflow 180308_F3_C1
trial = load('E:\Data\180308\180308_F3_C1\EpiFlash2T_Raw_180308_F3_C1_5.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step: No spikes in this cell
trial = load('E:\Data\180308\180308_F3_C1\CurrentStep2T_Raw_180308_F3_C1_18.mat');

%% epi flash Twitch movements

trial = load('E:\Data\180308\180308_F3_C1\EpiFlash2T_Raw_180308_F3_C1_5.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials 
trials{1} = 4:66; % 0
trials{2} = 70:99; % 0 
trials{3} = 100:129; % 75
trials{4} = 130:159; % 150
trials{5} = 161:190; % -75
trials{6} = 191:220; % -150
trials{7} = 221:242; % 0
trials{8} = 243:262; % 0 more spikes

dists = [0 0 75 150 -75 -150 0 0];

% trials{2} = 10:19; % these trials have no probe. No sense in doing
% running this now
Nsets = length(trials);
    
trial = load(sprintf(trialStem,3));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% Sweep Trials, no bar, just strange movements

trial = load('B:\Raw_Data\180308\180308_F3_C1\Sweep2T_Raw_180308_F3_C1_8.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

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

ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand

% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% Epi flash trials

%% Extract spikes

