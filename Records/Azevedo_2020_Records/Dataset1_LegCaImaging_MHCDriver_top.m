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

DEBUG = 0;
rewrite_yn = 'yes';

Script_tableOfMHCImaging
% head(T_legImagingList)

%% Figure 1 - figure supplement 1C - making cluster images for no bar trials
Script_colorNoBarClustersSimilarly

%% checking clusters for no bar trials
Script_colorBar_NoBar_ClustersSimilarly

%% Figure 1C
% Go through all the probe frames
% Find frames where the leg is extended, average all the frames and collect
% the cluster values.
% Find frames where the leg is flexed extended and average all the frames
Script_calculateFrameForFreeMovements

%% Figure 1F
% Go through all the probe frames
% Plot the histogram of distances, velocities, and accelerations
Script_plotSummariesOfBartrials

%% Figure 1E
Script_showInterestingFreeLegTrial

%% Figure G-J
% Plot relationships of {x,x_dot,x_ddot} with cluster values
Script_conditionPhasePlotOnClusters


%% GFP controls Fig 1
Workflow_MHCGal4_pJFRC7_171107_F2_C1_CaImControl
Workflow_MHCGal4_pJFRC7_171109_F1_C1_CaImControl

