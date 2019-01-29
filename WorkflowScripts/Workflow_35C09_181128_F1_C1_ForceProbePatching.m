%% ForceProbe patcing workflow 181127_F2_C1
trial = load('F:\Acquisition\181128\181128_F1_C1\CurrentStep2T_Raw_181128_F1_C1_12.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - to get force

trial = load('F:\Acquisition\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_5.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials spiketrials bartrials

spiketrials{1} = 1:55; %#ok<*NASGU> % no drugs
spiketrials{2} = 56:105; %#ok<*NASGU> % No drugs, was flowing in but then the manipulator movement routine died!

bartrials{1} =  1:55; % no drugs
bartrials{2} =  56:105; %#ok<*NASGU> % No drugs,



%% EpiFlash2TTrain - random movements

trial = load('F:\Acquisition\181128\181128_F1_C1\EpiFlash2TTrain_Raw_181128_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials

spiketrials{1} = 1:5; % no bar

bartrials{1} = 1:5; % bar

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('F:\Acquisition\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:280; % control
spiketrials{2} = 281:336; % moved probe to base and tip. How do these responses compare?
spiketrials{3} = 337:448; % atropine, atropine MLA

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('F:\Acquisition\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:210; % control
spiketrials{2} = 211:252; % atropine
spiketrials{3} = 253:294; % atropine MLA

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar
trial = load('F:\Acquisition\181024\181024_F2_C1\Sweep2T_Raw_181024_F2_C1_20.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:25; % 
spiketrials{2} = 36:55; % atropine, MLA

bartrials{1} = 16:25; % bar position vs spike rate

% ***** These 10 s trials are longer than the arbitrary max length for
% spike detection. Fix it.


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


