%% Record of High Frequency Responsive B1 cells
clear all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_HighPassB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1
id = 'HP_';

%%

analysis_grid = {
'131211_F1_C2'      'UAS-ArcLight; VT30609-Gal4'        'Original finding in ArcLight line'
'140530_F1_C1'      'UAS-ArcLight; VT30609-Gal4'        'Nice cell, but no Piezo Sine collection, wah wah'
'140530_F2_C1'      'UAS-ArcLight; VT30609-Gal4'        'Nice cell in ArcLight'
'151030_F1_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Beautiful cell, current isolation'
'151119_F2_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Pretty good!'
'151119_F3_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Not great cell, unsteady, but worth including'
'151121_F1_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Nice cell'
'151201_F2_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Nice cell'

%no piezo sine, VClamp
'151203_F3_C3'      '20XUAS-mCD8:GFP;VT30609-Gal4'              'No piezo sine, only steps to confirm'
'151203_F4_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'No piezo sine, only steps to confirm'
'151207_F1_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Nice recording, cell in the nerve, quick dissection'
'151207_F2_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Nice recording, cell in the nerve, quick dissection'

};

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end

%% 'UAS-ArcLight; VT30609-Gal4
cnt = find(strcmp(analysis_cells,'131211_F1_C2'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'/Users/tony/Raw_Data/131211/131211_F1_C2/PiezoSine_Raw_131211_F1_C2_56.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/131211/131211_F1_C2/CurrentPlateau_Raw_131211_F1_C2_3.mat';
end

%% 'UAS-ArcLight; VT30609-Gal4
cnt = find(strcmp(analysis_cells,'140530_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/140530/140530_F1_C1/PiezoStep_Raw_140530_F1_C1_31.mat';
end


%% 'UAS-ArcLight; VT30609-Gal4
cnt = find(strcmp(analysis_cells,'140530_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'/Users/tony/Raw_Data/140530/140530_F2_C1/PiezoSine_Raw_140530_F2_C1_74.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/140530/140530_F2_C1/PiezoStep_Raw_140530_F2_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151030_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'/Users/tony/Raw_Data/151030/151030_F1_C1/PiezoSine_Raw_151030_F1_C1_14.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/151030/151030_F1_C1/Sweep_Raw_151030_F1_C1_8.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151119_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'/Users/tony/Raw_Data/151119/151119_F2_C1/PiezoSine_Raw_151119_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/151119/151119_F2_C1/Sweep_Raw_151119_F2_C1_3.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151119_F3_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151119\151119_F3_C1\PiezoSine_Raw_151119_F3_C1_213.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_3.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151121_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151121\151121_F1_C1\PiezoSine_Raw_151121_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151121\151121_F1_C1\CurrentStep_Raw_151121_F1_C1_4.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151121\151121_F1_C1\Sweep_Raw_151121_F1_C1_4.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151201_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151201\151201_F2_C1\PiezoSine_Raw_151201_F2_C1_2.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151201\151201_F2_C1\CurrentStep_Raw_151201_F2_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151201\151201_F2_C1\Sweep_Raw_151201_F2_C1_4.mat';
end

%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,'151203_F3_C3'));

if ~isempty(cnt)
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151203\151203_F3_C3\PiezoStep_Raw_151203_F3_C3_3.mat';
end

%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,'151203_F4_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151203\151203_F4_C1\PiezoStep_Raw_151203_F4_C1_1.mat';
end


%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,'151207_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151207\151207_F1_C1\Sweep_Raw_151207_F1_C1_2.mat';
end

%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,'151207_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151207\151207_F2_C1\Sweep_Raw_151207_F2_C1_2.mat';
end


%% 
%Script_FrequencySelectivity