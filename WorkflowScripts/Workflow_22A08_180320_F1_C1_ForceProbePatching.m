%% ForceProbe patcing workflow 180320_F1_C1
trial = load('E:\Data\180320\180320_F1_C1\EpiFlash2T_Raw_180320_F1_C1_3.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% EpiFlash2T - 

trial = load('E:\Data\180320\180320_F1_C1\EpiFlash2T_Raw_180320_F1_C1_3.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials nobartrials trials
spiketrials{1} = 1:8; % beautiful vidoes of the leg with no bar, but not analyable yet
examplespiketrials = {
'E:\Data\180320\180320_F1_C1\EpiFlash2T_Raw_180320_F1_C1_3.mat'
};
bartrials = spiketrials(1);


%% EpiFlash2TTrain - stimuli

trial = load('E:\Data\180320\180320_F1_C1\EpiFlash2TTrain_Raw_180320_F1_C1_18.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear spiketrials bartrials nobartrials trials
spiketrials{1} = 1:11; % control
spiketrials{2} = 12:53; % moved probe to base and tip. How do these responses compare?
spiketrials{3} = 74:91; % atropine, atropine MLA
examplespiketrials = {
    'E:\Data\180320\180320_F1_C1\EpiFlash2TTrain_Raw_180320_F1_C1_7.mat'
    'E:\Data\180320\180320_F1_C1\EpiFlash2TTrain_Raw_180320_F1_C1_18.mat'
    'E:\Data\180320\180320_F1_C1\EpiFlash2TTrain_Raw_180320_F1_C1_74.mat'
    };

bartrials = spiketrials(1:2);
nobartrials = spiketrials(3);

%% Ramp stimuli

trial = load('E:\Data\180320\180320_F1_C1\PiezoRamp2T_Raw_180320_F1_C1_57.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:58;
Nsets = length(trials);
    
trial = load(sprintf(trialStem,30));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR'
    };


