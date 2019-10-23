%% ForceProbe patcing workflow 171122_F1_C1 
trial = load('E:\Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_8.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_8.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 1:14; % 
bartrials{2} = 15:24; % 
bartrials{3} = 25:39; %

spiketrials{1} = 1:14; % 
spiketrials{2} = 15:24; % no spikes in this cell
spiketrials{3} = 25:39; % no spikes in this cell
examplespiketrials = {
'E:\Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_14.mat'
'E:\Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_23.mat'
'E:\Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_23.mat'
    };

%% skootch the exposures
for s = 1:length(bartrials)
    knownSkootch = 2;
    trialnumlist = bartrials{s};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end

%% PiezoRamp2T - looking for changes in spike rate - no bar movement, just spikes

% No spikes here

%%
Workflow_0_ForceProbe_routines

