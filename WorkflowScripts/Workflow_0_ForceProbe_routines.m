%% Run each section above in turn, then run the sections below on each protocol

%% Extract spikes
% trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);
% trials = spiketrials;
% exampletrials = examplespiketrials;
% Script_ExtractSpikesFromInterestingTrials


%% Run Bar detection scripts one at a time

trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% Set probe line 
Script_SetProbeLine % showProbeLocation(trial)

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

Script_FixTheTrialsWithRedLEDTransients

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated


%% Calculate position of femur and tibia from csv files

% After bringing videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.

trials = nobartrials;
trialnumlist = [];
for idx = 1:length(trials)
    trialnumlist = [trialnumlist trials{idx}]; %#ok<AGROW>
end
close all

Script_AddTrackedPositions
Script_UseAllTrialsInSetToCorrectLegPosition;
Script_AddTrackedLegAngleToTrial
Script_UseAllTrialsInSetToCalculateLegElevation



%% Extract EMG spikes - 
clear trial

trial
spkvarstr = ['Spike_params_current_2_flipped_fs' num2str(trial.params.sampratein)];
spikevars = getacqpref('FlyAnalysis',spkvarstr);

emgspktype = 'Intermediate'; % 'Fast'
sgn = -1;
trial.current_2_flipped = sgn*trial.current_2; 
         
[trial,vars_skeleton] = spikeDetection(...
    trial,'current_2_flipped',spikevars,...
    'interact','yes',...
    'alt_spike_field',[emgspktype 'EMGspikes']...'IntermediateEMGspikes'...'FastEMGspikes'...
    );
spikevars = getacqpref('FlyAnalysis',spkvarstr);

%% Now do it for the rest of the trials
spkvarstr = ['Spike_params_current_2_flipped_fs' num2str(trial.params.sampratein)];
spikevars = getacqpref('FlyAnalysis',spkvarstr);
trialStem = extractTrialStem(trial.name);
trialnumlist = [1:21];

for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));

    if isfield(trial,'spikes') && length(trial.spikes)<1
        continue
    end
    
    trial.current_2_flipped = sgn*trial.current_2;
    % Now do the detection
    [trial,vars_skeleton] = spikeDetection(...
        trial,'current_2_flipped',spikevars,...
        'interact','yes',...
        'alt_spike_field',[emgspktype 'EMGspikes']...
        );
    spikevars = getacqpref('FlyAnalysis',spkvarstr);
end

%% correct  mistakes:
    if isfield(trial,'FastEMGspikes')
        %trial.FastEMGspikes = trial.EMGspikes;
        trial = rmfield(trial,'FastEMGspikes');
    end
    if isfield(trial,'FastEMGspikes_uncorrected')
        %trial.FastEMGspikes_spikes_uncorrected = trial.EMGspikes_spikes_uncorrected;
        trial = rmfield(trial,'FastEMGspikes_uncorrected');
    end
    if isfield(trial,'FastEMGspikeDetectionParams')
        %trial.FastEMGspikeDetectionParams = trial.EMGspikeDetectionParams;
        trial = rmfield(trial,'FastEMGspikeDetectionParams');
    end
    if isfield(trial,'FastEMGspikeSpotChecked')
        %trial.FastEMGspikeSpotChecked = trial.EMGspikeSpotChecked;
        trial = rmfield(trial,'FastEMGspikeSpotChecked');
    end
    save(trial.name, '-struct', 'trial');

    if isfield(trial,'IntermediateEMGspikes')
        %trial.FastEMGspikes = trial.EMGspikes;
        trial = rmfield(trial,'IntermediateEMGspikes');
    end
    if isfield(trial,'IntermediateEMGspikes_uncorrected')
        %trial.FastEMGspikes_spikes_uncorrected = trial.EMGspikes_spikes_uncorrected;
        trial = rmfield(trial,'IntermediateEMGspikes_uncorrected');
    end
    if isfield(trial,'IntermediateEMGspikeDetectionParams')
        %trial.FastEMGspikeDetectionParams = trial.EMGspikeDetectionParams;
        trial = rmfield(trial,'IntermediateEMGspikeDetectionParams');
    end
    if isfield(trial,'IntermediateEMGspikeSpotChecked')
        %trial.FastEMGspikeSpotChecked = trial.EMGspikeSpotChecked;
        trial = rmfield(trial,'IntermediateEMGspikeSpotChecked');
    end
    save(trial.name, '-struct', 'trial');
