%% ForceProbe patcing workflow 171102_F1_C1 NOT A GREAT RECORDING
trial = load('B:\Raw_Data\171102\171102_F1_C1\EpiFlash2T_Raw_171102_F1_C1_23.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials
% EpiFlash Sets - cause spikes and video movement
% Position 0 EpiFlash2T: 
trials{1} = 23:51;
% Position 100 EpiFlash2T: 
trials{2} = 52:81;
% Position 200 EpiFlash2T:
trials{3} = 82:121;

% ** Went down hill from here, then stimulating in the leg, can see fast
% rates
% Position 
% trials{4} =  132:151;

Nsets = length(trials);

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% Run scripts one at a time

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

% Find the trials with Red LED transients and mark them down
% Script_FindTheTrialsWithRedLEDTransients % Using UV Led

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand

% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% skootch the exposures
for set = 1:Nsets
    knownSkootch = 1;
    trialnumlist = trials{set};
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


