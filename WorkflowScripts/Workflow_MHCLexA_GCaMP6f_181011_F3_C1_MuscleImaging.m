%% Muscle Imaging Leg Tracking and ForceProbe Workflow 

%% EpiFlash2CB2T Bar detection
trial = load('E:\Data\181011\181011_F3_C1\EpiFlash2CB2T_Raw_181011_F3_C1_3.mat');
[~,~,~,~,~,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

nobartrials{1} = 1:15;
nobartrials{2} = 16:75;

bartrials{1} = 76:120;

%% Run scripts one at a time
trials = bartrials;

% Set probe line 
% Script_SetProbeLine 

% Find an area to smooth out the pixels
% Script_FindAreaToSmoothOutPixels

% Track the bar
% Script_TrackTheBarAcrossTrialsInSet

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

%% Calculate position of femur and tibia from csv files

% After bringing videos back from DeepLabCut, run through all trials, get
% some stats on the dots, do some error correction, make some videos.

% trials = nobartrials;
% trialnumlist = [];
% for idx = 1:length(trials)
%     trialnumlist = [trialnumlist trials{idx}]; %#ok<AGROW>
% end
% close all
% 
% Script_AddTrackedPositions;
% Script_UseAllTrialsInSetToCorrectLegPosition;
% Script_AddTrackedLegAngleToTrial
% Script_UseAllTrialsInSetToCalculateLegElevation

%% EpiFlash2T Calcium clusters calculation without bar
% trial = load('F:\Acquisition\181011\181011_F3_C1\EpiFlash2CB2T_Raw_181011_F3_C1_1.mat');
% [~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
% cd(D);
% 
% clear trials
% 
% % 50 Hz, kmeans clustering
% trials{1} = 1:15;
% 
% Nsets = length(trials);
% 
% for setidx = 1:Nsets
%     trialnumlist = trials{setidx};
%     %batch_avikmeansThreshold 
%     Script_KmeansClusterID_NoBar % this excludes frames when the leg is flexed
% end


%% The previous routine set the clusters for the 50 Hz data. Now add cluster intensit to 100 Hz data
% trial = load('F:\Acquisition\181011\181011_F3_C1\EpiFlash2CB2T_Raw_181011_F3_C1_1.mat');
% % 
% 
% clear trials
% trials{1} = 1:15;
% trials{2} = 16:75;
% Nsets = length(trials);
% 
% % Save the clusters found for the 50Hz trials to all the other trials
% for setidx = 1:Nsets
%     trialnumlist = trials{setidx};
%     for tr_idx = trialnumlist %1:length(data)
%         
%         trial = load(sprintf(trialStem,tr_idx));
%         fprintf('%s: ',trial.name);
%         if ~isfield(trial,'clmask')
%             fprintf('No mask',trial.name);
%         end
%         trial.clmask = getacqpref('quickshowPrefs','clmask');
%         save(trial.name, '-struct', 'trial')
%         fprintf('\n');
%     end
% end

%% Now calculate all the cluster intensities

% N_Cl = 6;
% 
% for setidx = 1:Nsets
%     trialnumlist = trials{setidx};
%     fprintf('\t- Intensity\n');
%     Script_KmeansIntensityCalculation_NoBar
% end

%% showCaImagingROI
trial = load('E:\Data\181011\181011_F3_C1\EpiFlash2CB2T_Raw_181011_F3_C1_3.mat');
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

% trials = bartrials;
% 
% trialnumlist = trials{1};
% batch_avikmeansThreshold
% showCaImagingROI
% Script_KmeansClusterID_Bar
% trial = load(sprintf(trialStem,trialnumlist(1)));
% clmask = trial.clmask;
% 
% %Save the clusters found for the 50Hz trials to all the other trials
% for setidx = 1:length(bartrials)
%     trialnumlist = bartrials{setidx};
%     for tr_idx = trialnumlist %1:length(data)
%         
%         trial = load(sprintf(trialStem,tr_idx));
%         fprintf('%s: \n',trial.name);
%         if ~isfield(trial,'clmask')
%             fprintf('No mask',trial.name);
%             trial.clmask = clmask;
%             save(trial.name, '-struct', 'trial')
%             fprintf('\n');
%         elseif numel(clmask)~=numel(trial.clmask) || any(trial.clmask(:)~=clmask(:))
%             fprintf('Saving correct mask: %s\n',trial.name);
%             trial.clmask = clmask;
%             save(trial.name, '-struct', 'trial')
%         end
% 
%     end
% end

%% 
% N_Cl = 6;
% 
% for setidx = 1:length(bartrials)
%     trialnumlist = bartrials{setidx};
%     fprintf('\t- Intensity\n');
%     Script_KmeansIntensityCalculation_Bar
% end

%% Or, alternatively, use the no bar trial clusters to calculate K_meansIntenstiy
nobartrial = load('E:\Data\181011\181011_F3_C1\EpiFlash2CB2T_Raw_181011_F3_C1_7.mat');

N_Cl = 6;

Script_KmeansIntensityCalculation_BarFromNoBar