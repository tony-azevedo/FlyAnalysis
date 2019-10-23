%% Record - Muscle imaging
%% Table of muscle imaging data

figureoutputfolder = 'G:\My Drive\Tony\Projects\FlySensorimotor\Figures\MatlabFigureOutput\MHC_images';

varNames = {'CellID','Genotype','Protocol','TableFile','ClusterMapping','ClusterMapping_NBCls','ClusterMapping_NoBar'};
sz = [2 length(varNames)];
data = cell(sz);
T_MHC = cell2table(data);
T_MHC.Properties.VariableNames = varNames;

%T_MHC{1,:} = {'181121_F2_C1', 'MHC-LexA,GCaMP6f', 'EpiFlash2CB2T','empty',  [1 2; 2 3; 3 4; 4 1; 5 5; 6 6],     [1 2; 2 4; 3 3; 4 1; 5 5],     [1 2; 2 4; 3 3; 4 1; 5 5; 6 6]};% just 0 position
T_MHC{1,:} = {'181209_F2_C1', 'MHC-LexA,GCaMP6f', 'EpiFlash2CB2T','empty',  [1 1; 2 3; 3 5; 4  4; 5 2; 6 6],    [1 3; 2 6; 3 4; 4 5; 5 1],     [1 3; 2 6; 3 4; 4 5; 5 1; 6 2]}; 
T_MHC{2,:} = {'181210_F1_C1', 'MHC-LexA,GCaMP6f', 'EpiFlash2CB2T','empty',[1 6; 2 2; 3 3; 4  5; 5 1; 6 4],  [1 3; 2 1; 3 2; 4 6; 5 5],     [1 3; 2 1; 3 2; 4 6; 5 5; 6 4]};
T_MHC{end+1,:} = {'190424_F1_C1', 'MHC-LexA,GCaMP6f', 'EpiFlash2CB2T','empty',[1 2; 2 6; 3 5; 4  3; 5 4; 6 1],  [1 2; 2 6; 3 5; 4 3],     [1 2; 2 6; 3 5; 4  3; 5 4; 6 1]};
T_MHC{end+1,:} = {'190424_F2_C1', 'MHC-LexA,GCaMP6f', 'EpiFlash2CB2T','empty',[1 1; 2 2; 3 3; 4  4; 5 5; 6 6],  [1 1; 2 2; 3 3; 4 4; 5 5],     [1 1; 2 2; 3 3; 4  4; 5 5; 6 6]};
T_MHC{end+1,:} = {'190424_F3_C1', 'MHC-LexA,GCaMP6f', 'EpiFlash2CB2T','empty',[1 3; 2 5; 3 2; 4  4; 5 6; 6 1],  [1 3; 2 5; 3 2; 4  4; 5 6],     [1 3; 2 5; 3 2; 4  4; 5 6; 6 1]};
% T_MHC{end+1,:} = {'181011_F3_C1', 'MHC-LexA,GCaMP6f', 'EpiFlash2CB2T','empty',[1 6; 2 2; 3 3; 4  5; 5 1; 6 4],  [1 3; 2 1; 3 2; 4 5; 5 4],     [1 4; 2 1; 3 5; 4 3; 5 6; 6 2]};% just 0 position

DEBUG = 0;
rewrite_yn = 'yes';

Script_tableOfMHCImaging
% head(T_legImagingList)

%% making cluster images for no bar trials
Script_colorNoBarClustersSimilarly

%% checking clusters for no bar trials
Script_colorBar_NoBar_ClustersSimilarly

%%
% Go through all the probe frames
% Plot the histogram of distances, velocities, and accelerations
Script_plotSummariesOfBartrials

%%
% Go through all the probe frames
% Find frames where the leg is extended, average all the frames and collect
% the cluster values.
% Find frames where the leg is flexed extended and average all the frames
Script_calculateFrameForFreeMovements

%%
Script_showInterestingFreeLegTrial

%% Alternative 1: look at phase plots when clusters are active
% Plot relationships of {x,x_dot,x_ddot} with cluster values
Script_conditionPhasePlotOnClusters

%% Alternative 2: look at clusters when probe is in phase plot roi
% Plot clusters of {x,x_dot,x_ddot} with cluster values
Script_conditionClustersOnPhasePlot

%% Plotting a few interesting snippets for 181210
% Plot relationships of {x,x_dot,x_ddot} with cluster values
Script_conditionPhasePlotOnClusters

%% Sent the following to Shaul
Workflow_MHCLexA_GCaMP6f_181011_F3_C1_MuscleImaging % Nice! Use this to explore
Workflow_MHCLexA_GCaMP6f_181121_F2_C1_MuscleImaging % Cleaned the objective
Workflow_MHCLexA_GCaMP6f_181209_F2_C1_MuscleImaging
Workflow_MHCLexA_GCaMP6f_181210_F1_C1_MuscleImaging


%% old stuff


% Preliminary results
% Workflow_MHCGal4_GCaMP6f_170703_F1_C1_CaImControl
% Workflow_MHCGal4_GCaMP6f_170705_F1_C1_CaImControl
% Workflow_MHCGal4_GCaMP6f_170707_F2_C1_CaImControl
% Workflow_MHCGal4_GCaMP6f_170707_F3_C1_CaImControl

% Preliminary controls
Workflow_MHCGal4_pJFRC7_171107_F2_C1_CaImControl
Workflow_MHCGal4_pJFRC7_171109_F1_C1_CaImControl

avi_scaled
caImavi_nobar
caImavi_scaled_noEMG
caImavi

%% 181023: Current acquisition protocol
% 15 trials without the bar at ~50Hz calcium imaging. Use these to define the clusters
% 60 trials without the bar at 100 Hz calcium imaging. Use these trials to compare leg movement, calcium signals
% 60 trials with bar, use these to look at force and clusters

% Step 1: move data to raw_raw_data on cloud
% Step 2: compress movies to h264
% Step 3: delete greyscale movies
% Step 4: Detect bar in videos
% Step 5: Move videos to media beast for tracking
% Step 6: Track legs on media beast
% Step 7: Transfer tracking data back to raw data folder
% Step 8: run the clustering on trials 1-15
% Step 9: get the intensity for all of the clusters for 16-75
% Step 10: Merge leg position and kinematics with calcium data

%% Not worth it
% Workflow_MHCLexA_GCaMP6f_181007_F1_C1_MuscleImaging 
% Workflow_MHCLexA_GCaMP6f_181007_F2_C1_MuscleImaging
% Workflow_MHCLexA_GCaMP6f_181011_F2_C1_MuscleImaging

%% Maybe worth it some 100Hz Gcamp imaging
Workflow_MHCLexA_GCaMP6f_181017_F1_C1_MuscleImaging % No hook, tibia goes to the femur
Workflow_MHCLexA_GCaMP6f_181017_F2_C1_MuscleImaging % Not great, EMG is not large
Workflow_MHCLexA_GCaMP6f_181105_F1_C1_MuscleImaging % Looks fine
Workflow_MHCLexA_GCaMP6f_181111_F1_C1_MuscleImaging % Objective was not washed, ignoring for now, could come back to it.
Workflow_MHCLexA_GCaMP6f_181111_F2_C1_MuscleImaging % 

%% calculate cluster intensity with the entire set from 170705
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
trialnumlist = (26:41); % 1700705 example set for probe extraction
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D);
for tr_idx = trialnumlist %   1:length(data)
    trial = load(sprintf(trialStem,tr_idx));

    if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded)
        fprintf('%s\n',trial.name);
        probeTrackROI_getBarModel(trial) % need to get the barmodel in there
    else
        fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
        continue
    end        
end


%% make cluster images from several flies
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
trialnumlist = (27:41); % 1700705 example set for probe extraction
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D);
batch_avikmeansClusterIntensity_v2


%% Show ca traces from all 5 clusters from trial 170705_F1_C1_25
savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';

trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
CSHL_select_kmeansROI
savePDF(fluof,savedir,[],'All_clusters_and_Bar')

%% show the clusters

trial = load('B:\Raw_Data\170703\170703_F1_C1\EpiFlash2T_Raw_170703_F1_C1_12.mat');
[~,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
clustid = [1 2 3 4 5];

% trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
% [~,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
% clustid = [1 2 3 4 5];
% 
% trial = load('B:\Raw_Data\170707\170707_F3_C1\EpiFlash2T_Raw_170707_F3_C1_11.mat');
% [~,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
% clustid = [2 3 4 5 1];
% 
% trial = load('B:\Raw_Data\170707\170707_F2_C1\EpiFlash2T_Raw_170707_F2_C1_35.mat');
% [~,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
% clustid = [5 1 3 2 4];
% 
clrs = [
    0 1 1           %c
    1 0.3 0.945       %m
    .43 0.5  1           %b
    0.2 1.00 0.2         %g
    1 1 0.2           %y
    ];

smooshedImagePath = regexprep(trial.name,{'_Raw_','.mat'},{'_smooshed_', '.mat'});
iostr = load(smooshedImagePath);

displayf = figure;
set(displayf,'position',[40 10 640 512],'color',[0 0 0]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 640 512]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax','color',[0 0 0]);
colormap(dispax,'gray')

clustf = figure;
set(clustf,'position',[40 10 640 512],'color',[0 0 0]);
clustax = axes('parent',clustf,'units','pixels','position',[0 0 640 512]);
set(clustax,'box','off','xtick',[],'ytick',[],'tag','dispax','color',[0 0 0]);
colormap(clustax,'gray')

scale = [quantile(iostr.smooshedframe(:),0.05) 1*quantile(iostr.smooshedframe(:),0.999)];
im = imshow(iostr.smooshedframe,scale,'parent',dispax);

for cl_d_idx = 1:5
    cl_idx = clustid(cl_d_idx);
    clmask = trial.clmask==cl_idx;
    ii = find(sum(clmask,1),1,'first');
    jj = find(clmask(:,ii),1,'first');
    clmask_b = bwtraceboundary(clmask,[jj,ii],'E',8);
    
    line(clmask_b(:,2),clmask_b(:,1),'parent',dispax,'color',clrs(cl_d_idx,:),'tag',num2str(cl_idx));
    line(clmask_b(:,2),clmask_b(:,1),'parent',clustax,'color',clrs(cl_d_idx,:),'tag',num2str(cl_idx));
    
    while size(clmask_b,1)<75
        clmask(min(clmask_b(:,1))-2:max(clmask_b(:,1))+2,min(clmask_b(:,2))-2:max(clmask_b(:,2))+2) = 0;
        ii = find(sum(clmask,1),1,'first');
        jj = find(clmask(:,ii),1,'first');
        try clmask_b = bwtraceboundary(clmask,[jj,ii],'E',8);
        catch
            clmask_b = bwtraceboundary(clmask,[jj,ii],'W',8);
        end
        line(clmask_b(:,2),clmask_b(:,1),'parent',dispax,'color',clrs(cl_d_idx,:),'tag',num2str(cl_idx));
        line(clmask_b(:,2),clmask_b(:,1),'parent',clustax,'color',clrs(cl_d_idx,:),'tag',num2str(cl_idx));
    end
end

xlim(clustax,[400 1200])
axis(clustax,'equal');

% savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro\clusters';
% savePDF(displayf,savedir,[],sprintf('ClusterMasks_%s',[dateID '_' flynum '_' cellnum '_' trialnum]))
% saveas(displayf,[savedir,filesep,sprintf('ClusterMasks_%s',[dateID '_' flynum '_' cellnum '_' trialnum])],'png')
% savePDF(clustf,savedir,[],sprintf('ClusterMasks_only_%s',[dateID '_' flynum '_' cellnum '_' trialnum]))



%% now mess around with the bar dynamics
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
CSHL_select_trajectories;

%% Plot the EMG and the clusters
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
CSHL_EMGTraces;
CSHL_select_EMGTraces;

%% For 170705_F1_C1, look at various trajectories and look at the fluorescnece for different types
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D);

% First find all the spikes
trialnumlist = (27:41);% trialnumlist = 120;
tresh = -150
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if  isfield(trial,'excluded') && trial.excluded
        continue;
    end

    simplerExtractSpikes_EMG

end

% Then go through and average wherever there is a spike
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if  isfield(trial,'excluded') && trial.excluded
        continue;
    end

    simplerExtractSpikes_EMG

end



