% 191213_F1_C1
% Cells with steps and ramps
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile'};

sz = [1 length(varNames)];
data = cell(sz);
T_cell = cell2table(data);
T_cell.Properties.VariableNames = varNames;

T_cell{1,:} = {'210302_F1_C2', 'Hot-Cell-Gal4, 50uL ATR mixed in', 'pilot', 'LEDFlashWithPiezoCueControl','empty'};
T_cell{2,:} = {'210319_F2_C1', 'HC-LexA/13XLexAop-ChrimsonR;81A06/pJFRC7 100uL ATR mixed in', 'Fe>proximal tidm', 'LEDFlashWithPiezoCueControl','empty'};
T_cell{3,:} = {'210331_F2_C1', 'HC-LexA/13XLexAop-ChrimsonR;81A06/pJFRC7 100uL ATR mixed in', 'Fe>proximal tidm', 'LEDFlashWithPiezoCueControl','empty'};
T_cell{4,:} = {'210405_F1_C1', 'HC-LexA/13XLexAop-ChrimsonR;81A06/pJFRC7 100uL ATR mixed in', 'Fe>distal tidm', 'LEDFlashWithPiezoCueControl','empty'};
T_cell{5,:} = {'210602_F1_C1', 'HC-LexA/13XLexAop-ChrimsonR;35C09/pJFRC7 75 ATR mixed in, no attenuator on LED', 'Fe>distal tidm', 'LEDFlashWithPiezoCueControl','empty'};
T_cell{6,:} = {'210604_F1_C1', 'HC-LexA/13XLexAop-ChrimsonR;35C09/pJFRC7 75 ATR mixed in, attenuator on LED', 'Fe>distal tidm, slow', 'LEDFlashWithPiezoCueControl','empty'};

T_Reach = T_cell(6,:);

% Script_tableOfReachData

%% Some stuff about the cell in question
Script_CellInfoFromTable

%% Create tables and forceprobe matrix and plot
% Create a parameter table for each cell.
% Downsample force probe at Pyas frame rate, save the matrix
% Find blocks at the rest trials
% Find which block are high force vs low force
% Edit the Table tags (and save tags to trials?)
% Add to T_params whether its a high force, low force or rest trial
% Get rid of excluded trials
% Find extreme where fly lets go.
% Plot the forceprobe Heat Map
% Tagging trials with outcomes, except for movement trials

Script_Process_ParamTable_ForceProbeMat

%%
T_params.Properties.VariableNames(:)
T.Properties.VariableNames(:)
size(T_params)
size(T)
size(fp)

%% Measure movement in trials
Script_MeasurePrePostStimMovement

%% Measure Vm changes during mechstim in trials
Script_MeasureCueResponses

%% Now look at individual flies

outcomes = {'no punishment - static';
    'no punishment - moved';
    'punishment - off';
    'punishment - late';
    'timeout - static';
    'timeout - fail'};

% closeLook_210302_F1_C1_HCGal4_unknown
% closeLook_210319_F2_C1_R81A06_unknown
% closeLook_210331_F2_C1_R81A06_proximalFlexorWithSpikes
% closeLook_210405_F1_C1_R81A06_largeDistalFlexor
% closeLook_210602_F1_C1_R35C09_slowDistalFlexor
% closeLook_210604_F1_C1_R35C09_slowDistalFlexor

%% Links to population level
% some examples
% Script_Columbia_Talk_210615
% Script_R01figures_210617
