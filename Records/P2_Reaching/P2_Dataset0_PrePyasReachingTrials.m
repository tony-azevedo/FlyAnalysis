%% Cells with steps and ramps
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile'};

sz = [1 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

T{1,:} = {'191107_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
T{1,:} = {'191202_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
T{1,:} = {'191205_F0_C0', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
T{1,:} = {'191212_F0_C0', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
T{1,:} = {'191212_F2_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
T{1,:} = {'191213_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191215_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191215_F2_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191219_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};

T_Reach = T;

% Script_tableOfReachData

%% Scripts analyzing individual cells
closeLookAt_191213_F1_C1_Learning_Leg_glued_to_bar
Script_closeLookAt_191219_F1_C1









