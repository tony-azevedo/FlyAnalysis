%% ForceProbe patcing workflow 180111_F2_C1

trial = load('E:\Data\180111\180111_F2_C1\CurrentStep2T_Raw_180111_F2_C1_2.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

trial = load('E:\Data\180111\180111_F2_C1\CurrentStep2T_Raw_180111_F2_C1_2.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials bartrials
spiketrials{1} = 4:22; %#ok<*NASGU> % no drugs
spiketrials{2} = 23:42; %#ok<*NASGU> % Atropine and MLA
spiketrials{3} = 43:54; %#ok<*NASGU> % Atropine and MLA
examplespiketrials = {
    };

bartrials = spiketrials;

%% EpiFlash2T - random movements

trial = load('E:\Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_8.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

clear trials spiketrials bartrials nobartrials
spiketrials{1} = 1:9; % bar
spiketrials{2} = 10:19; % no bar
examplespiketrials = {
    'E:\Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_8.mat'
    'E:\Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_17.mat'
    };

bartrials{1} = 1:9; 
nobartrials{1} = 10:18; 

%% PiezoStep2T -  looking for changes in spike rate 

% trial = load('E:\Data\180111\180111_F2_C1\PiezoStep2T_Raw_180111_F2_C1_1.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials
% spiketrials{1} = 1:30; 
% 
% examplespiketrials = {
%     'E:\Data\180111\180111_F2_C1\PiezoStep2T_Raw_180111_F2_C1_1.mat'
%     };
% 

%% PiezoRamp2T - looking for changes in spike rate 

% trial = load('E:\Data\180111\180111_F2_C1\PiezoRamp2T_Raw_180111_F2_C1_1.mat');
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% 
% clear trials spiketrials bartrials
% spiketrials{1} = 1:58; 
% 
% examplespiketrials = {
%     'E:\Data\180111\180111_F2_C1\PiezoRamp2T_Raw_180111_F2_C1_13.mat'
%     };
% 
% bartrials{1} = 31:58; 


%% skootch the exposures
    knownSkootch = 1;
    trialnumlist = trials{1};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch


