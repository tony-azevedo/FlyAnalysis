%% ForceProbe patcing workflow 191107_F1_C1

trial = load('E:\Data\191107\191107_F1_C1\EpiFlash2T_Raw_191107_F1_C1_75.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% Want to: 
% Create this file
% Find a trial that will serve as an example
% Run through all the trials with the same protocol

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
DataStruct = load(datastructfile); DataT = datastruct2table(DataStruct.data);
bartrials = {DataT.trial(:)'};

% Coming: Script_TrackForceProbe;

Workflow_0_ForceProbe_routines

%% CurrentStep2T - some spikes in this cell, with an EMG

% 
trial = load('E:\Data\190819\190819_F2_C1\CurrentStep2T_Raw_190819_F2_C1_7.mat');
clear spiketrials bartrials nobartrials
bartrials{1} = 7:44; 

spiketrials{1} = 7:44; 
examplespiketrials = {
'E:\Data\190819\190819_F2_C1\CurrentStep2T_Raw_190819_F2_C1_7.mat'
    };


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190819\190819_F2_C1\EpiFlash2T_Raw_190819_F2_C1_9.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:45; 

spiketrials{1} = 1:45; 
examplespiketrials = {
'E:\Data\190819\190819_F2_C1\EpiFlash2T_Raw_190819_F2_C1_9.mat'
    };

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190819\190819_F2_C1\PiezoRamp2T_Raw_190819_F2_C1_13.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:80; 

spiketrials{1} = 1:80; 
examplespiketrials = {
'E:\Data\190819\190819_F2_C1\PiezoRamp2T_Raw_190819_F2_C1_13.mat'
    };


%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190819\190819_F2_C1\PiezoStep2T_Raw_190819_F2_C1_3.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:42; 

spiketrials{1} = 1:42; 
examplespiketrials = {
'E:\Data\190819\190819_F2_C1\PiezoStep2T_Raw_190819_F2_C1_3.mat'
    };

%%


