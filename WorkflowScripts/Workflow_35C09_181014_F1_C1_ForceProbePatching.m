%% ForceProbe patcing workflow 181014_F1_C1
trial = load('F:\Acquisition\181014\181014_F1_C1\CurrentStep2T_Raw_181014_F1_C1_12.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force

trial = load('F:\Acquisition\181014\181014_F1_C1\CurrentStep2T_Raw_181014_F1_C1_12.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 12:66; % no drugs
trials{2} = 67:171; % Atropine and MLA


Nsets = length(trials);

% check the location
trial = load(sprintf(trialStem,12));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

% Done: 181014

%% epi flash train random movements

trial = load('F:\Acquisition\181014\181014_F1_C1\EpiFlash2TTrain_Raw_181014_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
% trials{1} = 1:10; % bar
% trials{2} = 11:18; % no bar
trials{1} = 19:34; % atropine
% trials{4} = 23:30; % atropine MLA
% trials{5} = 31:34; % atropine MLA


Nsets = length(trials);
    
trial = load(sprintf(trialStem,3));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

% Done

%% sweep, looking for changes in spike rate with slow movement of the bar

trial = load('F:\Acquisition\181014\181014_F1_C1\Sweep2T_Raw_181014_F1_C1_6.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 6:15; % bar
trials{2} = 16:30; % atropine in
trials{3} = 31:45; % MLA and atropine

Nsets = length(trials);
    
trial = load(sprintf(trialStem,6));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% Piezo Steps, looking for changes in spike rate 

trial = load('F:\Acquisition\181014\181014_F1_C1\PiezoStep2T_Raw_181014_F1_C1_4.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 4:213; % No MLA
trials{2} = 214:255; % atropine in
trials{3} = 256:297; % MLA and atropine

Nsets = length(trials);
    
trial = load(sprintf(trialStem,6));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };


%% Piezo Ramps, looking for changes in spike rate 

trial = load('F:\Acquisition\181014\181014_F1_C1\PiezoRamp2T_Raw_181014_F1_C1_2.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:308; % No MLA
trials{2} = 309:364; % atropine in
trials{3} = 365:420; % MLA and atropine

Nsets = length(trials);
    
trial = load(sprintf(trialStem,6));
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
% Script_FindTheTrialsWithRedLEDTransients % Using UV Led

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand


% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% Calculate position of femur and tibia from csv files
trial = load('F:\Acquisition\181014\181014_F1_C1\EpiFlash2TTrain_Raw_181014_F1_C1_11.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

% 50 Hz, kmeans clustering
trials{1} = 11:18;
trialnumlist = trials{1};

close all

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));
    waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
    Script_AddTrackedPostitionsAndLegAngle    
end

Script_UseAllTrialsInSetToCalculateLegElevation

delete(br);
