%% ForceProbe patcing workflow 190811_F1_C1
trial = load('E:\Data\190811\190811_F1_C1\CurrentStep2T_Raw_190811_F1_C1_1.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

% Not including for now!

%% CurrentStep2T - some spikes in this cell, with an EMG

% No spikes this time
trial = load('E:\Data\190811\190811_F1_C1\CurrentStep2T_Raw_190811_F1_C1_1.mat');


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190811\190811_F1_C1\EpiFlash2T_Raw_190811_F1_C1_2.mat');
clear spiketrials bartrials nobartrials

% nobartrials{1} = 1:6; % Not many trials, blew up after this
bartrials{1} = 6:15; % no bar trials, one good one
bartrials{2} = 16:56; % no bar trials, one good one

spiketrials{1} = 6:56; % no spikes in this cell
examplespiketrials = {
'E:\Data\190811\190811_F1_C1\EpiFlash2T_Raw_190811_F1_C1_6.mat'
    };

%% EpiFlash2TTrain - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190811\190811_F1_C1\EpiFlash2TTrain_Raw_190811_F1_C1_1.mat');
clear spiketrials bartrials nobartrials

% nobartrials{1} = 1:6; % Not many trials, blew up after this
bartrials{1} = 1:38; % no bar trials, one good one

spiketrials{1} = 1:38; % no spikes in this cell
examplespiketrials = {
'E:\Data\190811\190811_F1_C1\EpiFlash2T_Raw_190811_F1_C1_6.mat'
    };

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190811\190811_F1_C1\PiezoRamp2T_Raw_190811_F1_C1_1.mat');

% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190811\190811_F1_C1\PiezoStep2T_Raw_190811_F1_C1_4.mat');

% No spikes here

%% Passive forces
% Sweep2T - In TTX, measuring passive movements

trial = load('E:\Data\190811\190811_F1_C1\Sweep2T_Raw_190811_F1_C1_12.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
clear spiketrials bartrials nobartrials
bartrials{1} = 11:38; 



%%
Workflow_0_ForceProbe_routines

