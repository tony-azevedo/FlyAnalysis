%% ForceProbe patcing workflow 190619_F2_C1
trial = load('E:\Data\190619\190619_F2_C1\EpiFlash2T_Raw_190619_F2_C1_13.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

% Not including for now!

%% CurrentStep2T - some spikes in this cell, with an EMG

% No current injection, membrane potential was weird.


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190619\190619_F1_C1\EpiFlash2T_Raw_190619_F1_C1_12.mat');
clear spiketrials bartrials nobartrials

nobartrials{1} = 9:12; % Not many trials, blew up after this
bartrials{1} = 1:8; % no bar trials, one good one

spiketrials{1} = 1:12; % no spikes in this cell
examplespiketrials = {
'E:\Data\190619\190619_F1_C1\EpiFlash2T_Raw_190619_F1_C1_9.mat'
    };

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190605\190605_F1_C1\PiezoRamp2T_Raw_190605_F1_C1_1.mat');

% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190619\190619_F2_C1\PiezoStep2T_Raw_190619_F2_C1_1.mat');

% No spikes here


