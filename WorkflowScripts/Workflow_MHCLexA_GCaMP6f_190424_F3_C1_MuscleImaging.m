%% Muscle Imaging Leg Tracking and ForceProbe Workflow 


%% EpiFlash2CB2T Bar detection
trial = load('E:\Data\190424\190424_F3_C1\EpiFlash2CB2T_Raw_190424_F3_C1_21.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

% if the position of the prep changes, make a new set
bartrials{1} = 36:65; % Crap trials, bar got stuck

nobartrials{1} = 21:35;
% nobartrials{2} = 41:45; % leg broke free here!

%%
Workflow_0_CaImaging_routines