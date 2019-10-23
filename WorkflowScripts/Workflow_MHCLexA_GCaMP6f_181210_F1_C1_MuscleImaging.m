%% Muscle Imaging Leg Tracking and ForceProbe Workflow 


%% EpiFlash2CB2T Bar detection
trial = load('E:\Data\181210\181210_F1_C1\EpiFlash2CB2T_Raw_181210_F1_C1_1.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

% if the position of the prep changes, make a new set
bartrials{1} = 21:40; 

nobartrials{1} = 1:20;
% nobartrials{2} = 41:45; % leg broke free here!


%%
Workflow_0_CaImaging_routines