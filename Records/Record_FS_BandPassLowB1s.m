%% Record of BandPass Low Cells
clear all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassLowB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 0
id = 'BPL_';

%%
analysis_grid = {...
'131126_F2_C3'  'pJFRC7;VT30609'      'Complete over harmonics, slight band pass';
'131126_F2_C1'  'pJFRC7;VT30609'      'coarse freq sample, single amplitude, VCLAMP data!';
'131122_F2_C1'  'pJFRC7;VT30609'      'coarse frequency, no current injections';
'131211_F2_C1'  'pJFRC7;VT30609'      'Low pass, first cell with more sine waves.  No clear spiking, sharper tuning';

'140117_F2_C1'  'UAS-ArcLight; VT30609-Gal4'      'coarse frequency, no current injections';
'140602_F2_C1'  'UAS-ArcLight; VT30609-Gal4'      ''
'140603_F1_C1'  'UAS-ArcLight; VT30609-Gal4'      ''  
'150402_F2_C1'  'GH86;pJFRC7'           ''

'150409_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
'150414_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''  
'150502_F1_C1'  'pJFRC7;VT45599'        ''

'150502_F1_C3'  'pJFRC7;VT45599'        ''

};


clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end

reject_cells = {
'150402_F3_C1'  'GH86;pJFRC7'      'Not great for some reason'
}


%% 'pJFRC7;VT30609'

cnt = find(strcmp(analysis_cells,'131126_F2_C3'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\PiezoSine_Raw_131126_F2_C3_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\Sweep_Raw_131126_F2_C3_3.mat';

%% 'pJFRC7;VT30609'

cnt = find(strcmp(analysis_cells,'131126_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\PiezoSine_Raw_131126_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\Sweep_Raw_131126_F2_C1_1.mat';

%% 'pJFRC7;VT30609'

cnt = find(strcmp(analysis_cells,'131122_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\Sweep_Raw_131122_F2_C1_5.mat';

%% pJFRC7;VT30609
cnt = find(strcmp(analysis_cells,'131211_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_1.mat';

analysis_cell(cnt).extratrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\CurrentPlateau_Raw_131211_F2_C1_5.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\CurrentStep_Raw_131211_F2_C1_2.mat';
};

%% 'ArcLight;VT30609'


cnt = find(strcmp(analysis_cells,'140117_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_7.mat';

%% 'ArcLight;VT30609'

cnt = find(strcmp(analysis_cells,'140602_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\PiezoSine_Raw_140602_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentStep_Raw_140602_F2_C1_25.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentChirp_Raw_140602_F2_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'';
%% 'ArcLight;VT30609'

cnt = find(strcmp(analysis_cells,'140603_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140603\140603_F1_C1\CurrentStep_Raw_140603_F1_C1_5.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentChirp_Raw_140602_F2_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'';

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\PiezoSine_Raw_150402_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\CurrentStep_Raw_150402_F2_C1_8.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\CurrentChirp_Raw_150402_F2_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\Sweep_Raw_150402_F2_C1_1.mat';

%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150402_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C1\PiezoSine_Raw_150402_F3_C1_5.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C1\CurrentStep_Raw_150402_F3_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C1\CurrentChirp_Raw_150402_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C1\Sweep_Raw_150402_F3_C1_1.mat';
end

%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150409_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150409\150409_F1_C1\PiezoSine_Raw_150409_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150409\150409_F1_C1\CurrentStep_Raw_150409_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150409\150409_F1_C1\CurrentChirp_Raw_150409_F1_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150409\150409_F1_C1\Sweep_Raw_150409_F1_C1_1.mat';

%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150414_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150414\150414_F1_C1\PiezoSine_Raw_150414_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150414\150414_F1_C1\CurrentStep_Raw_150414_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150414\150414_F1_C1\CurrentChirp_Raw_150414_F1_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150414\150414_F1_C1\Sweep_Raw_150414_F1_C1_3.mat';

%% 'pJFRC7;VT45599'
cnt = find(strcmp(analysis_cells,'150502_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\PiezoSine_Raw_150502_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\CurrentStep_Raw_150502_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\CurrentChirp_Raw_150502_F1_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\Sweep_Raw_150502_F1_C1_8.mat';
analysis_cell(cnt).SweepVClampEx = 'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\Sweep_Raw_150502_F1_C1_3.mat';
analysis_cell(cnt).VoltageStepEx = 'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\VoltageStep_Raw_150502_F1_C1_1.mat';

%% 'pJFRC7;VT45599'
cnt = find(strcmp(analysis_cells,'150502_F1_C3'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\PiezoSine_Raw_150502_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C3\CurrentStep_Raw_150502_F1_C3_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C3\CurrentChirp_Raw_150502_F1_C3_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C3\Sweep_Raw_150502_F1_C3_7.mat';

%%
%Script_FrequencySelectivity

