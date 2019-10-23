%% ForceProbe patcing workflow 190812_F1_C1
trial = load('E:\Data\190812\190812_F1_C1\EpiFlash2T_Raw_190812_F1_C1_2.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

% Not including for now!

%% CurrentStep2T - some spikes in this cell, with an EMG

% 
trial = load('E:\Data\190812\190812_F1_C1\CurrentStep2T_Raw_190812_F1_C1_7.mat');
clear spiketrials bartrials nobartrials
bartrials{1} = 12:56; 

spiketrials{1} = 12:56; 
examplespiketrials = {
'E:\Data\190812\190812_F1_C1\CurrentStep2T_Raw_190812_F1_C1_16.mat'
    };


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190812\190812_F1_C1\EpiFlash2T_Raw_190812_F1_C1_2.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:21; 

spiketrials{1} = 1:21; 
examplespiketrials = {
'E:\Data\190812\190812_F1_C1\EpiFlash2T_Raw_190812_F1_C1_2.mat'
    };


%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190812\190812_F1_C1\PiezoRamp2T_Raw_190812_F1_C1_3.mat');
clear spiketrials bartrials nobartrials

spiketrials{1} = 1:80; 
examplespiketrials = {
'E:\Data\190812\190812_F1_C1\PiezoRamp2T_Raw_190812_F1_C1_3.mat'
    };


%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190812\190812_F1_C1\PiezoStep2T_Raw_190812_F1_C1_1.mat');
clear spiketrials bartrials nobartrials

spiketrials{1} = 1:42; 
examplespiketrials = {
'E:\Data\190812\190812_F1_C1\PiezoStep2T_Raw_190812_F1_C1_1.mat'
};

%%
Workflow_0_ForceProbe_routines

