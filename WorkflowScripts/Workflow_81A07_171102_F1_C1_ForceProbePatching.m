%% ForceProbe patcing workflow 171102_F1_C1 NOT A GREAT RECORDING
trial = load('E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_23.mat');
D = fileparts(trial.name);
cd (D)

%% EpiFlash2T - 
clear trials spiketrials bartrials
% EpiFlash Sets - cause spikes and video movement
% Position 0 EpiFlash2T: 
spiketrials{1} = 7:51;
% Position 100 EpiFlash2T: 
spiketrials{2} = 52:81;
% Position 200 EpiFlash2T:
spiketrials{3} = 82:121;
examplespiketrials = {
    'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_25.mat'
    'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_67.mat'
    'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_104.mat'
    };

bartrials = spiketrials;
% ** Went down hill from here, then stimulating in the leg, can see fast
% rates
% Position 
% trials{4} =  132:151;


%% Extract spikes
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% trials = spiketrials;
% exampletrials = examplespiketrials;
% Script_ExtractSpikesFromInterestingTrials

%% Extract spikes
% sgn = -1;
% 
% % load trial
% % spikevars = getacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)]);
% % setacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)],spikevars);
% 
% % trial.current_2_flipped = sgn*trial.current_2; 
% % [trial,spikevars] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');
% 
% trials = spiketrials;
% exampletrials = {
% 'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_10.mat'
% 'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_10.mat'
% 'E:\Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_10.mat'
%             };
% 
% Script_ExtractEMGSpikesFromInterestingTrials


%% Run Bar detection scripts one at a time

trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% Set probe line 
Script_SetProbeLine % showProbeLocation(trial)

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

% trialnumlist_specific = 226:258;
% ZeroForce = 700-(setpoint-700);
% Script_SetTheMinimumCoM_byHand

% Script_FixTheTrialsWithRedLEDTransients

%% skootch the exposures
for set = 1:length(bartrials)
    knownSkootch = 1;
    trialnumlist = bartrials{set};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end

%% Extract spikes


%% Random extra play time: move the manipulator while recording sensory feedback
trial = load('B:\Raw_Data\171101\171101_F1_C1\Sweep2T_Raw_171101_F1_C1_7.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

close all
% Go through all the sets of trials
trialnumlist = 6:8;

br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
br.Position =  [1050    251    270    56];

% set probeline for a few test movies
for tr_idx = trialnumlist
    h = load(sprintf(trialStem,tr_idx));
    
    waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(h.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
    
    fprintf('%s\n',h.name);
    if isfield(h,'excluded') && h.excluded
        fprintf(' * Bad movie: %s\n',trial.name)
        continue
    end
    trial = probeLineROI(h);
end
delete(br)
batch_probeTrackROI


