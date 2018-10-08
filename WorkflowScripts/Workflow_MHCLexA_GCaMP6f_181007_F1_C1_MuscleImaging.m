%% Muscle Imaging Leg Tracking and ForceProbe Workflow 

%% EpiFlash2T Bar detection
trial = load('F:\Acquisition\181007\181007_F1_C1\EpiFlash2CB2T_Raw_181007_F1_C1_1.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

% if the position of the prep changes, make a new set
trials{1} = 133:252;

routine = {
    'probeTrackROI_IR' 
    };

Nsets = length(trials);

%% Run scripts one at a time

% Set probe line 
Script_SetProbeLine 

% double check some trials
trial = load(sprintf(trialStem,215));
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
Script_ExtractSpikesFromInterestingTrials%% skootch the exposures

for setidx = 1:Nsets
    knownSkootch = 3;
    trialnumlist = trials{setidx};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end

%% EpiFlash2T Calcium clusters calculation with bar
trial = load('F:\Acquisition\181007\181007_F1_C1\EpiFlash2CB2T_Raw_181007_F1_C1_1.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

% if the position of the prep changes, make a new set
trials{1} = 133:252;

routine = {
    'probeTrackROI_IR' 
    };

Nsets = length(trials);


%% 
for setidx = 1:Nsets
    trialnumlist = trials{setidx};
%     fprintf('\t Decimate\n');    
%     batch_avikmeansDecimate
%     fprintf('\t- Extract\n');
%     batch_avikmeansExtract
    fprintf('\t- Threshold\n');
    batch_avikmeansThreshold
    fprintf('\t- Cluster\n');
    batch_avikmeansCalculation_v2
    fprintf('\t- Intensity\n');
    batch_avikmeansClusterIntensity_v2
end


%% EpiFlash2T Calcium clusters calculation without bar
trial = load('F:\Acquisition\181007\181007_F1_C1\EpiFlash2CB2T_Raw_181007_F1_C1_1.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

% if the position of the prep changes, make a new set
trials{1} = 133:252;

routine = {
    'probeTrackROI_IR' 
    };

Nsets = length(trials);


%% 
for setidx = 1:Nsets
    trialnumlist = trials{setidx};
%     fprintf('\t Decimate\n');    
%     batch_avikmeansDecimate
    fprintf('\t- Extract\n');
    batch_avikmeansExtract
    fprintf('\t- Threshold\n');
    batch_avikmeansThreshold
    fprintf('\t- Cluster\n');
    batch_avikmeansCalculation_v2
    fprintf('\t- Intensity\n');
    batch_avikmeansClusterIntensity_v2
end
