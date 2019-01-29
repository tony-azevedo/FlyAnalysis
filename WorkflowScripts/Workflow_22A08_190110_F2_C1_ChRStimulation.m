%% ForceProbe patcing workflow 190110_F2_C1
trial = load('F:\Acquisition\190110\190110_F2_C1\EpiFlash2T_Raw_190110_F2_C1_14.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% CurrentStep2T - to get force

%% EpiFlash2T - random movements

trial = load('F:\Acquisition\190110\190110_F2_C1\EpiFlash2T_Raw_190110_F2_C1_136.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials

% spiketrials{1} = 1:10; % no bar
spiketrials{1} = 13:137; % in voltage clamp, have to change that first (factor of 10)
spiketrials{2} = 138:166; % in voltage clamp, have to change that first (factor of 10)
examplespiketrials = {
    'F:\Acquisition\190110\190110_F2_C1\EpiFlash2T_Raw_190110_F2_C1_68.mat'
    'F:\Acquisition\190110\190110_F2_C1\EpiFlash2T_Raw_190110_F2_C1_138.mat'
    };


% bartrials{1} = 13:166; % bar 10-15 Were in Voltage clamp, incorrect units.

% trialnumlist = spiketrials{1};
% for tr = trialnumlist
%     trial = load(fullfile(D,sprintf(trialStem,tr)));
%     
%     if strcmp(trial.params.mode_1,'IClamp')
%         continue
%     end
%     fprintf('Changing VClamp to IClamp: %d\n',tr);
%     trial.params.mode_1 = 'IClamp';
%     trial.params.gain_1 = 100;
%     temp = trial.voltage_1;
%     trial.voltage_1 = trial.current_1/10;
%     save(trial.name, '-struct', 'trial');
% end

% for some reason, running spike extraction twice causes problem.
% start over
% trialnumlist = spiketrials{1};
% for tr = 107:166
%     trial = load(fullfile(D,sprintf(trialStem,tr)));
%     trial = rmfield(trial,'spikes');
%     trial = rmfield(trial,'spikes_uncorrected');
%     trial = rmfield(trial,'spikeDetectionParams');
%     fprintf('Deleting spikes: %d\n',tr);
% 
%     save(trial.name, '-struct', 'trial');
% end
% 


%% PiezoRamp2T - looking for changes in spike rate 

%% PiezoStep2T -  looking for changes in spike rate 

%% Sweep2T - , looking for changes in spike rate with slow movement of the bar

%% Run scripts one at a time
trials = bartrials;

% Set probe line 
Script_SetProbeLine 

% double check some trials
trial = load(sprintf(trialStem,66));
showProbeLocation(trial)

% trial = probeLineROI(trial);

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


%% Extract spikes
% trials = spiketrials;
% exampletrials = examplespiketrials;
% Script_ExtractSpikesFromInterestingTrials
% Script_FixTheTrialsWithRedLEDTransients
