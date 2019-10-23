%% ForceProbe patcing workflow 180703_F3_C1
trial = load('E:\Data\180703\180703_F3_C1\EpiFlash2T_Raw_180703_F3_C1_21.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash ChR stimulation with Red LED

trial = load('E:\Data\180703\180703_F3_C1\EpiFlash2T_Raw_180703_F3_C1_21.mat');

clear trials spiketrials bartrials
spiketrials{1} = 1:72; % short
spiketrials{2} = 73:108; % longer
       
examplespiketrials = {
'E:\Data\180703\180703_F3_C1\EpiFlash2T_Raw_180703_F3_C1_21.mat'
};

bartrials = spiketrials;


%% Run scripts one at a time
trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

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

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM


