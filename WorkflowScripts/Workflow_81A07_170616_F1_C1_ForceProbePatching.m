%% ForceProbe patcing workflow 190116_F1_C1
trial = load('E:\Data\170616\170616_F1_C1\EpiFlash2T_Raw_170616_F1_C1_74.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% EpiFlash2T -

trial = load('E:\Data\170616\170616_F1_C1\EpiFlash2T_Raw_170616_F1_C1_71.mat');

clear spiketrials bartrials trials nobartrials
spiketrials{1} = 9:59; % bar
spiketrials{2} = 59:88; % bar, caffeine
examplespiketrials = {
'E:\Data\170616\170616_F1_C1\EpiFlash2T_Raw_170616_F1_C1_71.mat'
'E:\Data\170616\170616_F1_C1\EpiFlash2T_Raw_170616_F1_C1_71.mat'
};

bartrials = spiketrials;

