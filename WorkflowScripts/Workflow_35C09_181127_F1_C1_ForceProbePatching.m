%% ForceProbe patcing workflow 181127_F1_C1
trial = load('F:\Acquisition\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_8.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force

trial = load('F:\Acquisition\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_8.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
bartrials{1} = 1:35; % no drugs
% no additional MLA trials

spiketrials{1} = 1:35; % no drugs

% Done:

%% epi flash train random movements

trial = load('F:\Acquisition\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:4; % no bar
spiketrials{2} = 5:14; % bar
spiketrials{3} = 15:24; % bar
spiketrials{4} = 25:34; % no bar
spiketrials{5} = 35:48; % bar atropine MLA

bartrials{1} = 5:14;
bartrials{2} = 15:24;
bartrials{3} = 35:48;

% Done

%% sweep, looking for changes in spike rate with slow movement of the bar

trial = load('F:\Acquisition\181127\181127_F1_C1\Sweep2T_Raw_181127_F1_C1_16.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 16:25; % slow bar movements

bartrials{1} = 16:25; % 


%% PiezoStep2T - , looking for changes in spike rate 

trial = load('F:\Acquisition\181127\181127_F1_C1\PiezoStep2T_Raw_181127_F1_C1_10.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 10:210; % No MLA
spiketrials{2} = 211:252; % No MLA


%% PiezoRamp2T -, looking for changes in spike rate 

trial = load('F:\Acquisition\181014\181014_F1_C1\PiezoRamp2T_Raw_181014_F1_C1_2.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:308; % No MLA
spiketrials{2} = 309:364; % atropine

%% Run scripts one at a time
trials = bartrials;
Nsets = length(trials);

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


%% Extract spikes
trials = spiketrials;
Script_ExtractSpikesFromInterestingTrials

%% Calculate position of femur and tibia from csv files
trial = load('F:\Acquisition\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear legtrials 
legtrials{1} = [1:4 25:34]; % no bar

trialnumlist = legtrials{1};

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


