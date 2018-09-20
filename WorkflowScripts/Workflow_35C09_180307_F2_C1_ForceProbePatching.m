%% ForceProbe patcing workflow 180307_F2_C1
trial = load('B:\Raw_Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_24.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('B:\Raw_Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_24.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
% trials{1} = 7:12;
% trials{2} = 13:17;
% trials{3} = 18:22;
trials{1} = 24:73;

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

trial = load('B:\Raw_Data\180307\180307_F2_C1\EpiFlash2T_Raw_180307_F2_C1_5.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:20;
Nsets = length(trials);
    
showProbeImage(load(sprintf(trialStem,20)))
showProbeImage(load('B:\Raw_Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_13.mat'))
% These are the same image, so the ZeroForce Routine will work
   
routine = {
    'probeTrackROI_IR' 
    };

%% Piezo Ramp stimuli

trial = load('B:\Raw_Data\180307\180307_F2_C1\PiezoRamp2T_Raw_180307_F2_C1_1.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:30; 
trials{2} = 31:60; 
Nsets = length(trials);
    
trial = load(sprintf(trialStem,30));
showProbeImage(trial)

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

%% alternative, look at main frequencies rather than spikes

trial = load('B:\Raw_Data\180307\180307_F2_C1\CurrentStep2T_Raw_180307_F2_C1_71.mat');
v = trial.voltage_1;
t = makeInTime(trial.params);
v = v-mean(v(t>-.4&t<0));
figure
plot(v)
spectrogram(v,256,250,(1:200),1e4,'yaxis')



