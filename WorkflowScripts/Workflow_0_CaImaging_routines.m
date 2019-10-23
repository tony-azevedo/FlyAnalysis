
%% Run scripts one at a time
trials = bartrials;

% Set probe line 
Script_SetProbeLine 

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet
Script_CalculateAModelOfTheBarFromKeimograph

% Find the trials with Red LED transients and mark them down
% Script_FindTheTrialsWithRedLEDTransients % Using UV Led

% Fix the trials with Red LED transients and mark them down
Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

%%
for set = 1:length(trials)
    knownSkootch = 2;
    trialnumlist = trials{set};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end

%% Calculate position of femur and tibia from csv files

% After brining videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.

trials = nobartrials;
trialnumlist = [];
for idx = 1:length(trials)
    trialnumlist = [trialnumlist trials{idx}]; %#ok<AGROW>
end
close all
% 
Script_AddTrackedPositions
Script_UseAllTrialsInSetToCorrectLegPosition;
Script_AddTrackedLegAngleToTrial
Script_UseAllTrialsInSetToCalculateLegElevation

%% EpiFlash2T Calcium clusters calculation without bar

% calculate nobartrials trialsnumlist on which to run the Kmeans
% clustering, mostly just the first few

trialnumlist = [nobartrials{1}];
% 
batch_avikmeansThreshold
Script_KmeansClusterID_NoBar_AngleRestrictedWithHook
clmask = getacqpref('quickshowPrefs','clmask');
if any(trial.clmask(:)~=clmask(:))
    error('WTF: the mask in the acq prefs is not the right one')
end

%% The previous routine set the clusters for the 50 Hz data. Now add cluster intensit to 100 Hz data

% Save the clusters found for the 50Hz trials to all the other trials
for setidx = 2:length(nobartrials)
    trialnumlist = nobartrials{setidx};
    for tr_idx = trialnumlist %1:length(data)
        
        trial = load(sprintf(trialStem,tr_idx));
        fprintf('%s: \n',trial.name);
        if ~isfield(trial,'clmask')
            fprintf('No mask',trial.name);
            trial.clmask = getacqpref('quickshowPrefs','clmask');
            save(trial.name, '-struct', 'trial')
            fprintf('\n');
        elseif any(trial.clmask(:)~=clmask(:))
            fprintf('Saving correct mask: %s\n',trial.name);
            trial.clmask = getacqpref('quickshowPrefs','clmask');
            save(trial.name, '-struct', 'trial')
        end

    end
end

%% Now calculate all the cluster intensities

N_Cl = 6;

for setidx = 1:length(nobartrials)
    trialnumlist = nobartrials{setidx};
    fprintf('\t- Intensity\n');
    Script_KmeansIntensityCalculation_NoBar
end

% Occasionally you may need to calculate the actual F values for the
% clusters for a particular trial
% Trial_KmeansIntensityCalculation_RawF_NoBar

%% showCaImagingROI
trial = load(sprintf(trialStem,trialnumlist(end)));
Script_AlignCaImagingCameraWithIRCamera

cam1v2alignment.X_offset = 640;
cam1v2alignment.Y_offset = 0;
cam1v2alignment.x_offset = getacqpref('FlyAnalysis','CaImgCam2X_Offset');
cam1v2alignment.y_offset = getacqpref('FlyAnalysis','CaImgCam2Y_Offset');
cam1v2alignment.theta = getacqpref('FlyAnalysis','CaImgCam2Rotation');

% Save the alignment to the trials, as well
for setidx = 1:length(bartrials)
    trialnumlist = bartrials{setidx};
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        fprintf('%s: \n',trial.name);
        trial.cam1v2alignment = cam1v2alignment;
        save(trial.name, '-struct', 'trial')
        
    end
end

%% Now calculate clusters for trials with bars

trials = bartrials;

% trialnumlist = [trials{1} trials{2}];
trialnumlist = trials{1};
batch_avikmeansThreshold
showCaImagingROI
% Script_KmeansClusterID_Bar
Script_KmeansClusterID_Bar_1video
trial = load(sprintf(trialStem,trialnumlist(1)));
clmask = trial.clmask;

%Save the clusters found for the 50Hz trials to all the other trials
for setidx = 1:length(bartrials)
    trialnumlist = bartrials{setidx};
    for tr_idx = trialnumlist %1:length(data)
        
        trial = load(sprintf(trialStem,tr_idx));
        fprintf('%s: \n',trial.name);
        if ~isfield(trial,'clmask')
            fprintf('No mask',trial.name);
            trial.clmask = clmask;
            save(trial.name, '-struct', 'trial')
            fprintf('\n');
        elseif numel(clmask)~=numel(trial.clmask) || any(trial.clmask(:)~=clmask(:))
            fprintf('Saving correct mask: %s\n',trial.name);
            trial.clmask = clmask;
            save(trial.name, '-struct', 'trial')
        end

    end
end

N_Cl = 6;

for setidx = 1:length(bartrials)
    trialnumlist = bartrials{setidx};
    fprintf('\t- Intensity\n');
    Script_KmeansIntensityCalculation_Bar
end

%% Or, alternatively, use the no bar trial clusters to calculate K_meansIntenstiy
%trial = load(sprintf(trialStem,nobartrial{1}(end)));

N_Cl = 6;
trials = bartrials;

Script_KmeansIntensityCalculation_BarFromNoBar

%% Now just find the floor of the fluorescence
trials = nobartrials;
clfield = 'clustertraces';
Script_FindTheMinimumF

% trials = bartrials;
% clfield = 'clustertraces';
% Script_FindTheMinimumF

trials = bartrials;
clfield = 'clustertraces_NBCls';
Script_FindTheMinimumF

