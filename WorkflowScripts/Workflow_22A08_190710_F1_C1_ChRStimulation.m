%% ForceProbe patcing workflow 190710_F1_C1
trial = load('E:\Data\190710\190710_F1_C1\EpiFlash2T_Raw_190710_F1_C1_89.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials spiketrials bartrials

%% EpiFlash2T - random movements

trial = load('E:\Data\190710\190710_F1_C1\EpiFlash2T_Raw_190710_F1_C1_89.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);


clear spiketrials bartrials
bartrials{1} = 22:474; 

spiketrials{1} = 22:474; 
examplespiketrials = {
'E:\Data\190710\190710_F1_C1\EpiFlash2T_Raw_190710_F1_C1_24.mat'
    };

%%
Workflow_0_ForceProbe_routines


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

%% Extract spikes
% trials = spiketrials;
% exampletrials = examplespiketrials;
% Script_ExtractSpikesFromInterestingTrials

%% Extract spikes
sgn = -1; % not going to work very well
% 
% % load trial
% spikevars = getacqpref('FlyAnalysis',['Spike_params_current_2_flipped_fs', num2str(trial.params.sampratein)]);
% 
trial.current_2_flipped = sgn*trial.current_2; 
[trial,spikevars] = spikeDetection(trial,'current_2_flipped',spikevars,'alt_spike_field','EMGspikes');
% 
% trials = spiketrials(1);
% exampletrials = examplespiketrials;

% Script_ExtractEMGSpikesFromInterestingTrials

%%
%             31    38    41    46    49    53    56    58    64    70    73
%     76    79    82    83    85    88    92    95    98   100   101   103   104   111
%    113   114   122   123   127   134   137
emgspk = find(trial.EMGspikes>trial.spikes,1);
cv = diff(t([trial.spikes trial.EMGspikes(emgspk)]))
%%
%    16.0000    0.0009
%    25.0000    0.0006
%    28.0000    0.0009
%    31.0000    0.0004
%    38.0000    0.0006
%    41.0000    0.0005
%    46.0000    0.0005
%    49.0000    0.0005
%    53.0000    0.0005
%    56.0000    0.0003
%    58.0000    0.0004
%    64.0000    0.0005
%    70.0000    0.0006
%    73.0000    0.0004
%    76.0000    0.0005
%    79.0000    0.0005
%    82.0000    0.0005
%    83.0000    0.0005
%    85.0000    0.0005
%    88.0000    0.0006
%    92.0000    0.0004
%    95.0000    0.0004
%    98.0000    0.0004
%   100.0000    0.0005
%   101.0000    0.0005
%   103.0000    0.0005
%   104.0000    0.0005
%   111.0000    0.0034
%   113.0000    0.0258
%   114.0000    0.0005
%   122.0000    0.0276
%   123.0000    0.0004
%   127.0000    0.0304
%   134.0000    0.0354
%   137.0000    0.0038

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
