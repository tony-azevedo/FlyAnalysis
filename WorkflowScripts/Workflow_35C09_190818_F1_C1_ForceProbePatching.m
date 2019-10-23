%% ForceProbe patcing workflow 190818_F1_C1
trial = load('E:\Data\190818\190818_F1_C1\CurrentStep2T_Raw_190818_F1_C1_4.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

% Not including for now!

%% CurrentStep2T - some spikes in this cell, with an EMG

% 
trial = load('E:\Data\190818\190818_F1_C1\CurrentStep2T_Raw_190818_F1_C1_4.mat');
clear spiketrials bartrials nobartrials
bartrials{1} = 1:54; 

spiketrials{1} = 1:54; 
examplespiketrials = {
'E:\Data\190818\190818_F1_C1\CurrentStep2T_Raw_190818_F1_C1_4.mat'
    };


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190818\190818_F1_C1\EpiFlash2T_Raw_190818_F1_C1_11.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:11; 

spiketrials{1} = 1:11; 
examplespiketrials = {
'E:\Data\190818\190818_F1_C1\EpiFlash2T_Raw_190818_F1_C1_11.mat'
    };

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190818\190818_F1_C1\PiezoRamp2T_Raw_190818_F1_C1_1.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:48; 

spiketrials{1} = 1:48; 
examplespiketrials = {
'E:\Data\190818\190818_F1_C1\PiezoRamp2T_Raw_190818_F1_C1_1.mat'
    };


%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190818\190818_F1_C1\PiezoStep2T_Raw_190818_F1_C1_1.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:42; 

spiketrials{1} = 1:42; 
examplespiketrials = {
'E:\Data\190818\190818_F1_C1\PiezoStep2T_Raw_190818_F1_C1_1.mat'
    };

%%
Workflow_0_ForceProbe_routines

