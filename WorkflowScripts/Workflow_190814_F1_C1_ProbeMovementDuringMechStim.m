%% ForceProbe patcing workflow 190814_F1_C1
trial = load('E:\Data\190814\190814_F1_C1\PiezoRamp2T_Raw_190814_F1_C1_1.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% PiezoRamp2T - Looking for movement of the probe with no leg there.

% No recording just videos
trial = load('E:\Data\190814\190814_F1_C1\PiezoRamp2T_Raw_190814_F1_C1_1.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:40; % no bar trials, one good one

%% PiezoStep2T - Looking for movement of the probe with no leg there.

% No recording
trial = load('E:\Data\190814\190814_F1_C1\PiezoStep2T_Raw_190814_F1_C1_2.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 2:36; % no bar trials, one good one


%%
Workflow_0_ForceProbe_routines

