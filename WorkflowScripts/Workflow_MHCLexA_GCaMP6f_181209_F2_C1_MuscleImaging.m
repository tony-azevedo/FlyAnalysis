%% Muscle Imaging Leg Tracking and ForceProbe Workflow 


%% EpiFlash2CB2T Bar detection
trial = load('E:\Data\181209\181209_F2_C1\EpiFlash2CB2T_Raw_181209_F2_C1_4.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

% if the position of the prep changes, make a new set
bartrials{1} = 31:50; % Crap trials, bar got stuck
bartrials{2} = 71:90; % Crap trials, bar got stuck, moving the bar

nobartrials{1} = 1:30;
nobartrials{2} = 51:70;
nobartrials{3} = 91:100; % after that lost the solution

%%
Workflow_0_CaImaging_routines