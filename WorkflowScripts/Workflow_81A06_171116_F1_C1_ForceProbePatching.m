%% ForceProbe patcing workflow 171116_F1_C1 
trial = load('E:\Data\171116\171116_F1_C1\CurrentStep2T_Raw_171116_F1_C1_99.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

% Probe position analyzed on the current step trials below, see cells at
% bottom

% Spikes not yet analyzed

% feedback vs location not yet analyzed

cd (D)
clear bartrials
bartrials{1} = 96:133; % subesquent trials are with caffeine and not so good

spiketrials{1} = 96:133; % 
examplespiketrials = {
'E:\Data\171116\171116_F1_C1\CurrentStep2T_Raw_171116_F1_C1_100.mat'
    };

%% PiezoRamp2T - looking for changes in spike rate - no bar movement, just spikes

trial = load('E:\Data\171116\171116_F1_C1\PiezoRamp2T_Raw_171116_F1_C1_9.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials
spiketrials{1} = 1:60;
examplespiketrials = {
'E:\Data\171116\171116_F1_C1\PiezoRamp2T_Raw_171116_F1_C1_9.mat'
    };

%%
Workflow_0_ForceProbe_routines

