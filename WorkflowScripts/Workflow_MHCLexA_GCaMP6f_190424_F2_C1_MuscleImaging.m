%% Muscle Imaging Leg Tracking and ForceProbe Workflow 


%% EpiFlash2CB2T Bar detection
trial = load('E:\Data\190424\190424_F2_C1\EpiFlash2CB2T_Raw_190424_F2_C1_40.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

% if the position of the prep changes, make a new set
bartrials{1} = 16:30;
bartrials{2} = 31:60; 

nobartrials{1} = 1:15;

%%
Workflow_0_CaImaging_routines