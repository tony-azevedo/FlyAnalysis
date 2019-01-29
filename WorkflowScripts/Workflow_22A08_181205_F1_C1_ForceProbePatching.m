%% ForceProbe patcing workflow 181205_F1_C1
trial = load('F:\Acquisition\181205\181205_F1_C1\EpiFlash2TTrain_Raw_181205_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - to get force

trial = load('F:\Acquisition\181205\181205_F1_C1\CurrentStep2T_Raw_181205_F1_C1_104.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials spiketrials bartrials

spiketrials{1} = 6:72;
spiketrials{2} = 73:92; % waiting on MLA
spiketrials{3} = 93:117; % MLA

bartrials{1} = 1:72; 
bartrials{2} = 73:92; 
bartrials{3} = 93:117; 

%% EpiFlash2TTrain - random movements

trial = load('F:\Acquisition\181205\181205_F1_C1\EpiFlash2TTrain_Raw_181205_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials

% spiketrials{1} = 1:10; % no bar
spiketrials{1} = 1:15; % no bar
spiketrials{2} = 21:25; % no bar

nobartrials{1} = 1:10; % no bar
nobartrials{1} = 21:30; % no bar

bartrials{1} = 16:20; % bar 10-15 Were in Voltage clamp, incorrect units.

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('F:\Acquisition\181205\181205_F1_C1\PiezoRamp2T_Raw_181205_F1_C1_13.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

% No spikes here
% spiketrials{1} = 1:263; % control
% spiketrials{2} = 264:319; % MLA
% spiketrials{3} = 320:375; % TTX

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('F:\Acquisition\181205\181205_F1_C1\PiezoStep2T_Raw_181205_F1_C1_10.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

% No spikes here
% spiketrials{1} = 1:210; % control
% spiketrials{2} = 215:256; % MLA
% spiketrials{3} = 257:298; % TTX


%% Run scripts one at a time
trials = bartrials;

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
trial = load('F:\Acquisition\181127\181127_F2_C1\EpiFlash2TTrain_Raw_181127_F2_C1_16.mat');
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


