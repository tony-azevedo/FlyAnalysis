%% ForceProbe patcing workflow 190815_F1_C1
trial = load('E:\Data\190813\190813_F1_C1\CurrentStep2T_Raw_190813_F1_C1_15.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

% Not including for now!

%% CurrentStep2T - some spikes in this cell, with an EMG

% 
trial = load('E:\Data\190813\190813_F1_C1\CurrentStep2T_Raw_190813_F1_C1_15.mat');
clear spiketrials bartrials nobartrials
bartrials{1} = 11:45; 

spiketrials{1} = 11:45; 
examplespiketrials = {
'E:\Data\190813\190813_F1_C1\CurrentStep2T_Raw_190813_F1_C1_15.mat'
    };


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190813\190813_F1_C1\EpiFlash2T_Raw_190813_F1_C1_2.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:49; 

spiketrials{1} = 1:49; 
examplespiketrials = {
'E:\Data\190813\190813_F1_C1\EpiFlash2T_Raw_190813_F1_C1_2.mat'
    };

%% EpiFlash2TTrain - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190813\190813_F1_C1\EpiFlash2TTrain_Raw_190813_F1_C1_16.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:16; % no bar trials, one good one

spiketrials{1} = 1:16; % no spikes in this cell
examplespiketrials = {
'E:\Data\190813\190813_F1_C1\EpiFlash2T_Raw_190813_F1_C1_2.mat'
    };

%% PiezoRamp2T - looking for changes in spike rate 

% No spikes here
trial = load('E:\Data\190813\190813_F1_C1\PiezoRamp2T_Raw_190813_F1_C1_27.mat');
% clear spiketrials bartrials nobartrials
% 
% spiketrials{1} = 1:80; 
% examplespiketrials = {
% 'E:\Data\190813\190813_F1_C1\PiezoStep2T_Raw_190813_F1_C1_1.mat'
%     };


% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190813\190813_F1_C1\PiezoStep2T_Raw_190813_F1_C1_1.mat');
clear spiketrials bartrials nobartrials

spiketrials{1} = 1:84; 
examplespiketrials = {
'E:\Data\190813\190813_F1_C1\PiezoStep2T_Raw_190813_F1_C1_1.mat'
    };

%% Passive forces
% Sweep2T - In TTX, measuring passive movements

trial = load('E:\Data\190813\190813_F1_C1\Sweep2T_Raw_190813_F1_C1_17.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
clear spiketrials bartrials nobartrials
bartrials{1} = 4:17; 


%%
Workflow_0_ForceProbe_routines

