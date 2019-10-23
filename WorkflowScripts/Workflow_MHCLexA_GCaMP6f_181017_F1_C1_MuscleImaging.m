%% Muscle Imaging Leg Tracking and ForceProbe Workflow 

%% EpiFlash2CB2T Bar detection
trial = load('F:\Acquisition\181017\181017_F1_C1\EpiFlash2CB2T_Raw_181017_F1_C1_1.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials bartrials

% if the position of the prep changes, make a new set
bartrials{1} = 61:105;

%% Run Bar detection scripts one at a time

% Create trials variable, safeguard
trials = bartrials;
trialStem = extractTrialStem(trial.name); D = fileparts(trial.name);

% Set probe line 
Script_SetProbeLine % showProbeLocation(trial)

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Setting the ZeroForce point for different trials
Script_FindTheMinimumCoM

% Script_FixTheTrialsWithRedLEDTransients


%% Now calculate clusters for trials with bars

trials = bartrials;

trialnumlist = trials{1};
batch_avikmeansThreshold
showCaImagingROI
Script_KmeansClusterID_Bar
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


%% EpiFlash2T Calcium clusters calculation with bar
trial = load('F:\Acquisition\181011\181011_F2_C1\EpiFlash2CB2T_Raw_181011_F2_C1_1.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

% 50 Hz, kmeans clustering
trials{1} = 1:15;

Nsets = length(trials);

for setidx = 1:Nsets
    trialnumlist = trials{setidx};
    fprintf('\t- Threshold\n');
    batch_avikmeansThreshold 
    trialnumlist = trials{setidx};
    fprintf('\t- Cluster\n');
    batch_avikmeansCalculation_v2
end

%% The previous routine set the clusters for the 50 Hz data. Now add cluster intensit to 100 Hz data
trial = load('F:\Acquisition\181011\181011_F3_C1\EpiFlash2CB2T_Raw_181011_F3_C1_1.mat');
setacqpref('quickshowPrefs','clmask',trial.clmask);

clear trials
trials{1} = 1:15;
trials{2} = 16:75;
Nsets = length(trials);

%% Save the clusters found for the 50Hz trials to all the other trials
for setidx = 1:Nsets
    trialnumlist = trials{setidx};
    for tr_idx = trialnumlist %1:length(data)
        
        trial = load(sprintf(trialStem,tr_idx));
        fprintf('%s: ',trial.name);
        if ~isfield(trial,'clmask')
            fprintf('No mask',trial.name);
        end
        trial.clmask = getacqpref('quickshowPrefs','clmask');
        save(trial.name, '-struct', 'trial')
        fprintf('\n');
    end
end

%% Now calculate all the cluster intensities

for setidx = 1:Nsets
    trialnumlist = trials{setidx};
    fprintf('\t- Intensity\n');
    batch_avikmeansClusterIntensity_nobar
end

