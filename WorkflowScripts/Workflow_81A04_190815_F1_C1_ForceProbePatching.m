%% ForceProbe patcing workflow 190815_F1_C1
trial = load('E:\Data\190815\190815_F1_C1\CurrentStep2T_Raw_190815_F1_C1_1.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

% Not including for now!

%% CurrentStep2T - some spikes in this cell, with an EMG

% 
trial = load('E:\Data\190815\190815_F1_C1\CurrentStep2T_Raw_190815_F1_C1_7.mat');
clear spiketrials bartrials nobartrials
bartrials{1} = 7:53; 

spiketrials{1} = 7:53; 
examplespiketrials = {
'E:\Data\190815\190815_F1_C1\CurrentStep2T_Raw_190815_F1_C1_7.mat'
    };


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190815\190815_F1_C1\EpiFlash2T_Raw_190815_F1_C1_1.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:60; 

spiketrials{1} = 1:60; 
examplespiketrials = {
'E:\Data\190815\190815_F1_C1\EpiFlash2T_Raw_190815_F1_C1_1.mat'
    };

%% EpiFlash2TTrain - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190815\190815_F1_C1\EpiFlash2TTrain_Raw_190815_F1_C1_5.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:5; % no bar trials, one good one

spiketrials{1} = 1:5; % no spikes in this cell
examplespiketrials = {
'E:\Data\190815\190815_F1_C1\EpiFlash2T_Raw_190815_F1_C1_1.mat'
    };

%% PiezoRamp2T - looking for changes in spike rate 

% No spikes here
trial = load('E:\Data\190815\190815_F1_C1\PiezoRamp2T_Raw_190815_F1_C1_10.mat');
clear spiketrials bartrials nobartrials

spiketrials{1} = 1:80; 
examplespiketrials = {
'E:\Data\190815\190815_F1_C1\PiezoRamp2T_Raw_190815_F1_C1_10.mat'
    };


% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190815\190815_F1_C1\PiezoStep2T_Raw_190815_F1_C1_1.mat');
clear spiketrials bartrials nobartrials

spiketrials{1} = 1:42; 
examplespiketrials = {
'E:\Data\190815\190815_F1_C1\PiezoStep2T_Raw_190815_F1_C1_1.mat'
    };


%%
Workflow_0_ForceProbe_routines

