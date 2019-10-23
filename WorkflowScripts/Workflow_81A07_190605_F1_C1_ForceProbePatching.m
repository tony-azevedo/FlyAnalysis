%% ForceProbe patcing workflow 190605_F1_C1
trial = load('E:\Data\190605\190605_F1_C1\EpiFlash2T_Raw_190605_F1_C1_17.mat');
D = fileparts(trial.name);
cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - some spikes in this cell, with an EMG

% hypothesis here. If I were to just wait, and not inject current for a
% while, and then injected current, would I still see spikes? 
trial = load('E:\Data\190605\190605_F1_C1\CurrentStep2T_Raw_190605_F1_C1_4.mat');


%% EpiFlash2T - random movements
% Free movement is interesting but bar gets stuck

trial = load('E:\Data\190605\190605_F1_C1\EpiFlash2T_Raw_190605_F1_C1_17.mat');
clear spiketrials bartrials nobartrials

bartrials{1} = 12:41; % bar
bartrials{2} = 42:91; % bar

spiketrials{1} = 12:41; % bar, no caffeine
spiketrials{2} = 42:91; % bar, caffeine
examplespiketrials = {
'E:\Data\190605\190605_F1_C1\EpiFlash2T_Raw_190605_F1_C1_17.mat'
'E:\Data\190605\190605_F1_C1\EpiFlash2T_Raw_190605_F1_C1_17.mat'
    };

nobartrials{1} = 1:11;

%% PiezoRamp2T - looking for changes in spike rate 

trial = load('E:\Data\190605\190605_F1_C1\PiezoRamp2T_Raw_190605_F1_C1_1.mat');

% No spikes here

%% PiezoStep2T -  looking for changes in spike rate 

trial = load('E:\Data\190605\190605_F1_C1\PiezoStep2T_Raw_190605_F1_C1_1.mat');

% No spikes here


%% Sweep2T - In TTX, measuring passive movements

trial = load('E:\Data\190605\190605_F1_C1\Sweep2T_Raw_190605_F1_C1_6.mat');
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
clear spiketrials bartrials nobartrials
bartrials{1} = 6:23; 
% No spikes here

% RUN THE Workflow_0 first

trialnumlist = 16:25;
for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));
    if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
        probeTrackROI_inFocus;
    elseif isfield(trial,'forceProbeStuff')
        fprintf('%s\n',trial.name);
        fprintf('\t*Has profile: passing over trial for now\n')
    end
end

