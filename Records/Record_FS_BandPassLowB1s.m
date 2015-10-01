%% Record of BandPass Low Cells
clear all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassLowB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1
id = 'BPL_';

%%
analysis_cells = {...
'131126_F2_C3'
'131126_F2_C1'
'131122_F2_C1'
'131211_F2_C1'

'140117_F2_C1'
'140602_F2_C1'
'140603_F1_C1'
'150402_F2_C1'

'150402_F3_C1'  % Not great for some reason
'150409_F1_C1'  % Not great for some reason
'150414_F1_C1'  % Not great for some reason
'150502_F1_C1'

'150502_F1_C3'
};

analysis_cells_comment = {...
    'Complete over harmonics, slight band pass';
    'coarse freq sample, single amplitude, VCLAMP data!';
    'coarse frequency, no current injections';
    'Low pass, first cell with more sine waves.  No clear spiking, sharper tuning';
        
    'coarse frequency, no current injections';
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    'Not great for some reason'
    ''
    ''
    ''
    ''
};

analysis_cells_genotype = {...
'pJFRC7;VT30609'
'pJFRC7;VT30609'
'pJFRC7;VT30609'
'pJFRC7;VT30609'

'ArcLight;VT30609'
'ArcLight;VT30609'
'ArcLight;VT30609'
'GH86;pJFRC7'

'GH86;pJFRC7'
'pJFRC7;VT27938'
'pJFRC7;VT27938'
'pJFRC7;VT27938'

'pJFRC7;VT45599'
'pJFRC7;VT45599'
};


clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

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
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C1\PiezoSine_Raw_150402_F3_C1_5.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C1\CurrentStep_Raw_150402_F3_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C1\CurrentChirp_Raw_150402_F3_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C1\Sweep_Raw_150402_F3_C1_1.mat';

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
Script_FrequencySelectivity

