%% Record of High Frequency Responsive B1 cells
clear analysis_cell analysis_cells c cnt id save_log example_cell analysis_grid
savedir = '/Users/tony/Dropbox/RAnalysis_Data/Record_FS_HighPassB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1;
id = 'HP_';

%%

vm_analysis_grid = {
    '151030_F1_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Beautiful cell, current isolation'
'151119_F2_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Pretty good!'
'151119_F3_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Not great cell, unsteady, but worth including'
'151121_F1_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Nice cell'
'151201_F2_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'Nice cell'
'151203_F3_C3'      '20XUAS-mCD8:GFP;VT30609-Gal4'              'No piezo sine, only steps to confirm'
'151203_F4_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'               'No piezo sine, only steps to confirm'
'151207_F1_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Nice recording, cell in the nerve, quick dissection'
'151207_F2_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Nice recording, cell in the nerve, quick dissection'
};

clear analysis_cell analysis_cells
for c = 1:size(vm_analysis_grid,1)
    analysis_cell(c).name = vm_analysis_grid{c,1}; 
    analysis_cell(c).genotype = vm_analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = vm_analysis_grid{c,3};
    analysis_cells{c} = vm_analysis_grid{c,1}; 
end

fprintf('A2 High Preferring: \n')
fprintf('\t%s\n',analysis_cells{:})

% %% Example cell 
% example_cell.name = '151121_F1_C1';
% example_cell.PiezoSineTrial = ...
% '/Users/tony/Raw_Data/151121/151121_F1_C1/PiezoSine_Raw_151121_F1_C1_3.mat';
% example_cell.CurrentStepTrial = ...
% '/Users/tony/Raw_Data/151121/151121_F1_C1/CurrentStep_Raw_151121_F1_C1_1.mat';
% example_cell.CurrentChirpTrial = ...
% '';
% example_cell.SweepTrial = ...
% '/Users/tony/Raw_Data/151121/151121_F1_C1/Sweep_Raw_151121_F1_C1_2.mat';
% 
% % % other possibility
% % example_cell.name = '151119_F2_C1';
% % example_cell.PiezoSineTrial = ...
% % '/Users/tony/Raw_Data/151119/151119_F2_C1/PiezoSine_Raw_151119_F2_C1_3.mat';
% % example_cell.CurrentStepTrial = ...
% % '';
% % example_cell.CurrentChirpTrial = ...
% % '';
% % example_cell.SweepTrial = ...
% % '';
% 
% %% Figure 3 example

% fig3example_cell.name = '151121_F1_C1';
% fig3example_cell.PiezoStepTrialAnt = ...
% 'C:\Users\tony\Raw_Data\151121\151121_F1_C1\PiezoStep_Raw_151121_F1_C1_8.mat';
% fig3example_cell.PiezoStepTrialPost = ...
% 'C:\Users\tony\Raw_Data\151121\151121_F1_C1\PiezoStep_Raw_151121_F1_C1_7.mat';
% fig3example_cell.genotype = '20XUAS-mCD8:GFP;VT30609-Gal4'; %#ok<*SAGROW>


% %% 'UAS-ArcLight; VT30609-Gal4
% cnt = find(strcmp(analysis_cells,'131211_F1_C2'));
% if ~isempty(cnt)
% analysis_cell(cnt).PiezoSineTrial = ...
% '/Users/tony/Raw_Data/131211/131211_F1_C2/PiezoSine_Raw_131211_F1_C2_56.mat';
% analysis_cell(cnt).CurrentStepTrial = ...
% '';
% analysis_cell(cnt).CurrentChirpTrial = ...
% '';
% analysis_cell(cnt).SweepTrial = ...
% '/Users/tony/Raw_Data/131211/131211_F1_C2/CurrentPlateau_Raw_131211_F1_C2_3.mat';
% end
% 
% %% 'UAS-ArcLight; VT30609-Gal4
% cnt = find(strcmp(analysis_cells,'140530_F1_C1'));
% if ~isempty(cnt)
% analysis_cell(cnt).PiezoSineTrial = ...
% '';
% analysis_cell(cnt).CurrentStepTrial = ...
% '';
% analysis_cell(cnt).CurrentChirpTrial = ...
% '';
% analysis_cell(cnt).SweepTrial = ...
% '/Users/tony/Raw_Data/140530/140530_F1_C1/PiezoStep_Raw_140530_F1_C1_31.mat';
% end
% 
% 
% %% 'UAS-ArcLight; VT30609-Gal4
% cnt = find(strcmp(analysis_cells,'140530_F2_C1'));
% if ~isempty(cnt)
% analysis_cell(cnt).PiezoSineTrial = ...
% '/Users/tony/Raw_Data/140530/140530_F2_C1/PiezoSine_Raw_140530_F2_C1_74.mat';
% analysis_cell(cnt).CurrentStepTrial = ...
% '';
% analysis_cell(cnt).CurrentChirpTrial = ...
% '';
% analysis_cell(cnt).SweepTrial = ...
% '/Users/tony/Raw_Data/140530/140530_F2_C1/PiezoStep_Raw_140530_F2_C1_1.mat';
% end

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
'/Users/tony/Raw_Data/151119/151119_F3_C1/PiezoSine_Raw_151119_F3_C1_213.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/151119/151119_F3_C1/PiezoLongCourtshipSong_Raw_151119_F3_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151121_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'/Users/tony/Raw_Data/151121/151121_F1_C1/PiezoSine_Raw_151121_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'/Users/tony/Raw_Data/151121/151121_F1_C1/CurrentStep_Raw_151121_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/151121/151121_F1_C1/Sweep_Raw_151121_F1_C1_2.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151201_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'/Users/tony/Raw_Data/151201/151201_F2_C1/PiezoSine_Raw_151201_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'/Users/tony/Raw_Data/151201/151201_F2_C1/CurrentStep_Raw_151201_F2_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/151201/151201_F2_C1/Sweep_Raw_151201_F2_C1_3.mat';
end

%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,'151203_F3_C3'));

if ~isempty(cnt)
    analysis_cell(cnt).SweepTrial = ...
        '/Users/tony/Raw_Data/151203/151203_F3_C3/PiezoStep_Raw_151203_F3_C3_1.mat';
end

%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,'151203_F4_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/151203/151203_F4_C1/PiezoStep_Raw_151203_F4_C1_1.mat';
end


%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,'151207_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/151207/151207_F1_C1/Sweep_Raw_151207_F1_C1_2.mat';
end

%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,'151207_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).SweepTrial = ...
'/Users/tony/Raw_Data/151207/151207_F2_C1/Sweep_Raw_151207_F2_C1_2.mat';
end


%% 
%Script_FrequencySelectivity