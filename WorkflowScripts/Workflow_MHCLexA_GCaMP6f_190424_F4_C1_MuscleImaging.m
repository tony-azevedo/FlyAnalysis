%% Muscle Imaging Leg Tracking and ForceProbe Workflow 


%% EpiFlash2CB2T Bar detection
trial = load('F:\Acquisition\190424\190424_F4_C1\EpiFlash2CB2T_Raw_190424_F4_C1_21.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

% if the position of the prep changes, make a new set
bartrials{1} = 21:41; % Crap trials, bar got stuck

nobartrials{1} = 1:15;
% nobartrials{2} = 41:45; % leg broke free here!

%%
Workflow_0_CaImaging_routines