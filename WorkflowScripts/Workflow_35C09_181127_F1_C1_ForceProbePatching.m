%% ForceProbe patcing workflow 181127_F1_C1
trial = load('E:\Data\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_8.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - to get force

% trial = load('E:\Data\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_15.mat');
% 
% clear spiketrials bartrials
% bartrials{1} = 1:35; % no drugs
% no additional MLA trials

% spiketrials{1} = 1:35; % no drugs
% examplespiketrials = {
% 'E:\Data\181127\181127_F1_C1\CurrentStep2T_Raw_181127_F1_C1_15.mat'
% };

%% EpiFlash2TTrain -

trial = load('E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_4.mat');

clear spiketrials bartrials trials nobartrials
spiketrials{1} = 1:4; % no bar
spiketrials{2} = 5:14; % bar
spiketrials{3} = 15:24; % bar
spiketrials{4} = 25:44; % no bar
spiketrials{5} = 45:48; % bar atropine MLA
examplespiketrials = {
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_4.mat'
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_5.mat'
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_16.mat'
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_5.mat'
'E:\Data\181127\181127_F1_C1\EpiFlash2TTrain_Raw_181127_F1_C1_5.mat'
};

bartrials{1} = 5:14;
bartrials{2} = 15:24;

%nobartrials{1} = 1:4;
nobartrials{1} = 25:44;


%% Sweep2T - looking for changes in spike rate with slow movement of the bar

trial = load('E:\Data\181127\181127_F1_C1\Sweep2T_Raw_181127_F1_C1_16.mat');

clear spiketrials bartrials
spiketrials{1} = 16:25; % slow bar movements
examplespiketrials = {
'E:\Data\181127\181127_F1_C1\Sweep2T_Raw_181127_F1_C1_16.mat'
};

bartrials{1} = 16:25; % 


%% PiezoStep2T - , looking for changes in spike rate 

trial = load('E:\Data\181127\181127_F1_C1\PiezoStep2T_Raw_181127_F1_C1_206.mat');

clear spiketrials bartrials
spiketrials{1} = 10:210; % No MLA
% spiketrials{2} = 211:252; % Atropine, but depolarized and shitty but feed back is larger. Consistent?
examplespiketrials = {
'E:\Data\181127\181127_F1_C1\PiezoStep2T_Raw_181127_F1_C1_206.mat'
};


%% PiezoRamp2T -, looking for changes in spike rate 

trial = load('E:\Data\181127\181127_F1_C1\PiezoRamp2T_Raw_181127_F1_C1_245.mat');

clear spiketrials bartrials
spiketrials{1} = 1:308; % No MLA
% spiketrials{2} = 309:364; % atropine
examplespiketrials = {
'E:\Data\181127\181127_F1_C1\PiezoRamp2T_Raw_181127_F1_C1_245.mat'
};


