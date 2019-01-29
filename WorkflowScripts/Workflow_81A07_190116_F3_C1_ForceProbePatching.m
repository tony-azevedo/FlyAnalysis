%% ForceProbe patcing workflow 190116_F1_C1
trial = load('F:\Acquisition\190116\190116_F3_C1\EpiFlash2TTrain_Raw_190116_F1_C1_77.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% EpiFlash2T - random movements

trial = load('F:\Acquisition\190116\190116_F3_C1\EpiFlash2T_Raw_190116_F3_C1_16.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials

% Never any spikes in these data for this fly
nobartrials{1} = 48:77; % no bar

bartrials{1} = 1:47; % bar 10-15 Were in Voltage clamp, incorrect units.
bartrials{1} = 78:92; % bar 10-15 Were in Voltage clamp, incorrect units.

%% EpiFlash2TTrain - random movements

trial = load('F:\Acquisition\190116\190116_F1_C1\EpiFlash2TTrain_Raw_190116_F1_C1_77.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials

% Never any spikes in these data for this fly
nobartrials{1} = 48:77; % no bar

bartrials{1} = 1:47; % bar 10-15 Were in Voltage clamp, incorrect units.
bartrials{1} = 78:92; % bar 10-15 Were in Voltage clamp, incorrect units.

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('F:\Acquisition\190116\190116_F1_C1\PiezoRamp2T_Raw_190116_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

% No spikes here
% spiketrials{1} = 1:263; % control
% spiketrials{2} = 264:319; % MLA
% spiketrials{3} = 320:375; % TTX

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('F:\Acquisition\190116\190116_F1_C1\PiezoStep2T_Raw_190116_F1_C1_1.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

% No spikes here
% spiketrials{1} = 1:210; % control
% spiketrials{2} = 215:256; % MLA
% spiketrials{3} = 257:298; % TTX

%% Sweep2T - no spikes here but could check it out



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


