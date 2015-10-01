%% Record of High Frequency Responsive B1 cells
clear all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_HighPassB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1
id = 'HP_';

%%

analysis_cells = {...
    '131211_F1_C2';
    '140530_F1_C1';
    '140530_F2_C1';
};

analysis_cells_comment = {...
'UAS-ArcLight; VT30609-Gal4'
'UAS-ArcLight; VT30609-Gal4'
'UAS-ArcLight; VT30609-Gal4'
};

analysis_cells_genotype = {...
'Original finding in ArcLight line'
'Nice cell, but no Piezo Sine collection, wah wah'
'Nice cell in ArcLight'
};


clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end


%% 'UAS-ArcLight; VT30609-Gal4
cnt = find(strcmp(analysis_cells,'131211_F1_C2'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_56.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_3.mat';

%% 'UAS-ArcLight; VT30609-Gal4
cnt = find(strcmp(analysis_cells,'140530_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_3.mat';


%% 'UAS-ArcLight; VT30609-Gal4
cnt = find(strcmp(analysis_cells,'140530_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_74.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_3.mat';

%% 
Script_FrequencySelectivity_HP