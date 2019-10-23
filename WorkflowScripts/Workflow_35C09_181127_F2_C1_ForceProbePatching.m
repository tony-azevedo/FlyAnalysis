%% ForceProbe patcing workflow 181127_F2_C1
trial = load('E:\Data\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_1.mat');
D = fileparts(trial.name);
cd (D)

%% CurrentStep2T - to get force

% trial = load('E:\Data\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_1.mat');
% 
% clear trials spiketrials bartrials
% 
% spiketrials{1} = 1:35; %#ok<*NASGU> % no drugs
% spiketrials{2} = 36:70; %#ok<*NASGU> % MLA, but slightly ineffective, still spiking
% examplespiketrials = {
% 'E:\Data\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_9.mat'
% 'E:\Data\181127\181127_F2_C1\CurrentStep2T_Raw_181127_F2_C1_65.mat'
%     };
% 
% bartrials{1} =  1:35; % no drugs
% bartrials{2} =  36:70; %#ok<*NASGU> % MLA, but slightly ineffective, still spiking


%% EpiFlash2TTrain - random movements

trial = load('E:\Data\181127\181127_F2_C1\EpiFlash2TTrain_Raw_181127_F2_C1_16.mat');

clear spiketrials bartrials nobartrials

spiketrials{1} = 1:16; % no bar
spiketrials{2} = 17:26; % bar
spiketrials{3} = 27:31; % bar, atropine
examplespiketrials = {
'E:\Data\181127\181127_F2_C1\EpiFlash2TTrain_Raw_181127_F2_C1_1.mat'
'E:\Data\181127\181127_F2_C1\EpiFlash2TTrain_Raw_181127_F2_C1_17.mat'
'E:\Data\181127\181127_F2_C1\EpiFlash2TTrain_Raw_181127_F2_C1_27.mat'
    };

nobartrials{1} = 1:16; % no bar
bartrials{1} = 17:26; % no bar
bartrials{2} = 27:31; % bar, atropine

%% PiezoRamp2T - looking for changes in spike rate 

% trial = load('E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_420.mat');

% clear spiketrials bartrials
% spiketrials{1} = 1:280; % control
% spiketrials{2} = 281:336; % moved probe to base and tip. How do these responses compare?
% spiketrials{3} = 337:448; % atropine, atropine MLA
% examplespiketrials = {
% 'E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_29.mat'
% 'E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_329.mat'
% 'E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_420.mat'
%     };

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_1.mat');

clear spiketrials bartrials
spiketrials{1} = 1:210; % control
spiketrials{2} = 211:252; % atropine
spiketrials{3} = 253:294; % atropine MLA
examplespiketrials = {
'E:\Data\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_7.mat'
 'E:\Data\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_216.mat'
'E:\Data\181127\181127_F2_C1\PiezoStep2T_Raw_181127_F2_C1_259.mat'
   };

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar
trial = load('E:\Data\181024\181024_F2_C1\Sweep2T_Raw_181024_F2_C1_20.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials
spiketrials{1} = 1:25; % 
spiketrials{2} = 36:55; % atropine, MLA

bartrials{1} = 16:25; % bar position vs spike rate




