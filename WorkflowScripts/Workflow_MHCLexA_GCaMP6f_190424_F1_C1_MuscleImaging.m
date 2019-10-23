%% Muscle Imaging Leg Tracking and ForceProbe Workflow 


%% EpiFlash2CB2T Bar detection
trial = load('E:\Data\190424\190424_F1_C1\EpiFlash2CB2T_Raw_190424_F1_C1_22.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

% if the position of the prep changes, make a new set
bartrials{1} = 19:63; 

nobartrials{1} = 4:18;

%%
Workflow_0_CaImaging_routines