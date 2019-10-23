%% ForceProbe CaImaging workflow *** Written as 171109_F1_F1, have to juggle the other 81A06 cell

%% EpiFlash2T Bar detection
trial = load('E:\Data\171109\171109_F1_C1\EpiFlash2T_Raw_171109_F1_C1_1.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

% if the position of the prep changes, make a new set
%bartrials{2} = 1:5; 
bartrials{1} = 6:65;

%%
Workflow_0_CaImaging_routines

% calculates the very small DF/F for flexion vs extension
Script_calculateFrameForBarMovementsWGFP
