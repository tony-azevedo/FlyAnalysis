%% ForceProbe patcing workflow 190619_F3_C1
trial = load('E:\Data\190619\190619_F3_C1\EpiFlash2T_Raw_190619_F3_C1_10.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

% Not including for now!

%% CurrentStep2T - some spikes in this cell, with an EMG

% No spikes this time
trial = load('E:\Data\190619\190619_F3_C1\CurrentStep2T_Raw_190619_F3_C1_5.mat');


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190619\190619_F3_C1\EpiFlash2T_Raw_190619_F3_C1_17.mat');
clear spiketrials bartrials nobartrials

nobartrials{1} = 1:6; % Not many trials, blew up after this
bartrials{1} = 7:69; % no bar trials, one good one

spiketrials{1} = 1:69; % no spikes in this cell
examplespiketrials = {
'E:\Data\190619\190619_F3_C1\EpiFlash2T_Raw_190619_F3_C1_64.mat'
    };

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190619\190619_F3_C1\PiezoRamp2T_Raw_190619_F3_C1_1.mat');

% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190619\190619_F3_C1\PiezoStep2T_Raw_190619_F3_C1_3.mat');

% No spikes here

%%
Workflow_0_ForceProbe_routines

