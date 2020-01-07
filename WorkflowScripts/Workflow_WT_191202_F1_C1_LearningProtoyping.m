%% ForceProbe patcing workflow 191107_F1_C1

trial = load('E:\Data\191202\191202_F1_C1\EpiFlash2T_Raw_191202_F1_C1_49.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% Want to: 
% Create this file
% Find a trial that will serve as an example
% Run through all the trials with the same protocol

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
DataStruct = load(datastructfile); 
DataT = datastruct2table(DataStruct.data);
DataT = addExcludeFlagToDataTable(DataT,trialStem);
bartrials = {DataT.trial(~DataT.Excluded)'};

% Coming: Script_TrackForceProbe;

%%
Workflow_0_ForceProbe_routines


