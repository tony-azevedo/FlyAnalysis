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
    '131126_F2_C3'  '20XUAS-mCD8:GFP;VT30609-Gal4'       'Complete over harmonics, slight band pass';
    '131126_F2_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'       'coarse freq sample, single amplitude, VCLAMP data!';
    '131122_F2_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'       'coarse frequency, no current injections';
    '131211_F2_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'       'Low pass, first cell with more sine waves.  No clear spiking, sharper tuning';
    
    '140117_F2_C1'  'UAS-ArcLight; VT30609-Gal4'      'coarse frequency, no current injections';
    '140602_F2_C1'  'UAS-ArcLight; VT30609-Gal4'      ''
    '140603_F1_C1'  'UAS-ArcLight; VT30609-Gal4'      ''
    '150402_F2_C1'  'GH86;pJFRC7'           ''
    
    '150409_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '150414_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    
    '150502_F1_C1'  '20XUAS-mCD8:GFP;VT45599-Gal4'        ''
    '150502_F1_C3'  '20XUAS-mCD8:GFP;VT45599-Gal4'        ''
    
    '151203_F2_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'        ''
    '151203_F3_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'        ''
    
    '151205_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '151208_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '151208_F2_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        'Great recording, have to throw out the first blocks, cell sealed up'

    '151209_F1_C3'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '151209_F2_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '151209_F2_C2'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''

    };

no_nerve_grid = {
    % No nerve
    '151007_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. crapped out after TEA,NO TTX' % Should I throw this one out?
    '151007_F3_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. Should be good enough for gvt work'
    '151009_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
    '151022_F2_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
    '151029_F3_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
    '151118_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'   'LP'
    '151121_F3_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'   'Did the ramp at a different potential. What to do?' % For this cell, the voltage changed during the curare, I've untagged the curare traces and excluded the cntrl trials
};

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1};
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1};
end
analysis_cells
reject_cells = {
    '150402_F3_C1'  'GH86;pJFRC7'      'Not great for some reason'
    }

%% '20XUAS-mCD8:GFP;VT30609-Gal4'

cnt = find(strcmp(analysis_cells,'131122_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\Sweep_Raw_131122_F2_C1_5.mat';
    analysis_cell(cnt).extratrials = {...
        'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\Sweep_Raw_131122_F2_C1_5.mat'; % early cells, not great recordings
        };

end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'

cnt = find(strcmp(analysis_cells,'131126_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\PiezoSine_Raw_131126_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\Sweep_Raw_131126_F2_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'

cnt = find(strcmp(analysis_cells,'131126_F2_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\PiezoSine_Raw_131126_F2_C3_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        '';
    
    analysis_cell(cnt).extratrials = {...
        'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\Sweep_Raw_131126_F2_C3_3.mat'; % endo of the cell, not great
        };

end


%% pJFRC7;VT30609
cnt = find(strcmp(analysis_cells,'131211_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        '';
    
    analysis_cell(cnt).extratrials = {...
        'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_1.mat'; % early recording, not that great
        'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\CurrentPlateau_Raw_131211_F2_C1_5.mat';
        'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\CurrentStep_Raw_131211_F2_C1_2.mat';
        };
end

%% 'ArcLight;VT30609'


cnt = find(strcmp(analysis_cells,'140117_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\CurrentStep_Raw_140117_F2_C1_1.mat';
end

%% 'ArcLight;VT30609'

cnt = find(strcmp(analysis_cells,'140602_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\PiezoSine_Raw_140602_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentStep_Raw_140602_F2_C1_25.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentChirp_Raw_140602_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentStep_Raw_140602_F2_C1_1.mat';
end

%% 'ArcLight;VT30609'

cnt = find(strcmp(analysis_cells,'140603_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        '';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140603\140603_F1_C1\CurrentStep_Raw_140603_F1_C1_5.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentChirp_Raw_140602_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140603\140603_F1_C1\CurrentStep_Raw_140603_F1_C1_5.mat';
end

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\PiezoSine_Raw_150402_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\CurrentStep_Raw_150402_F2_C1_8.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\CurrentChirp_Raw_150402_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\Sweep_Raw_150402_F2_C1_1.mat';
end

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
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150409\150409_F1_C1\PiezoSine_Raw_150409_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150409\150409_F1_C1\CurrentStep_Raw_150409_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150409\150409_F1_C1\CurrentChirp_Raw_150409_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150409\150409_F1_C1\Sweep_Raw_150409_F1_C1_1.mat';
end

%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150414_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150414\150414_F1_C1\PiezoSine_Raw_150414_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150414\150414_F1_C1\CurrentStep_Raw_150414_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150414\150414_F1_C1\CurrentChirp_Raw_150414_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150414\150414_F1_C1\Sweep_Raw_150414_F1_C1_4.mat';
end

%% 'pJFRC7;VT45599'
cnt = find(strcmp(analysis_cells,'150502_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\PiezoSine_Raw_150502_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\CurrentStep_Raw_150502_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\CurrentChirp_Raw_150502_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\Sweep_Raw_150502_F1_C1_6.mat';
    analysis_cell(cnt).SweepVClampEx = 'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\Sweep_Raw_150502_F1_C1_3.mat';
    analysis_cell(cnt).VoltageStepEx = 'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\VoltageStep_Raw_150502_F1_C1_1.mat';
end

%% 'pJFRC7;VT45599'
cnt = find(strcmp(analysis_cells,'150502_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C1\PiezoSine_Raw_150502_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C3\CurrentStep_Raw_150502_F1_C3_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C3\CurrentChirp_Raw_150502_F1_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C3\Sweep_Raw_150502_F1_C3_7.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151203_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151203\151203_F2_C1\PiezoSine_Raw_151203_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151203\151203_F2_C1\Sweep_Raw_151203_F2_C1_4.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151203_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151203\151203_F3_C1\PiezoSine_Raw_151203_F3_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151203\151203_F3_C1\Sweep_Raw_151203_F3_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151205_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151205\151205_F1_C1\PiezoSine_Raw_151205_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151205\151205_F1_C1\CurrentChirp_Raw_151205_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151205\151205_F1_C1\Sweep_Raw_151205_F1_C1_4.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151208_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151208\151208_F1_C1\PiezoSine_Raw_151208_F1_C1_17.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151208\151208_F1_C1\CurrentChirp_Raw_151208_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151208\151208_F1_C1\Sweep_Raw_151208_F1_C1_9.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151208_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151208\151208_F2_C1\PiezoSine_Raw_151208_F2_C1_242.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151208\151208_F2_C1\PiezoChirp_Raw_151208_F2_C1_3.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151209_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C3\PiezoSine_Raw_151209_F1_C3_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C3\VoltageStep_Raw_151209_F1_C3_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C3\CurrentChirp_Raw_151209_F1_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C3\Sweep_Raw_151209_F1_C3_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151209_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C1\PiezoSine_Raw_151209_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C1\CurrentChirp_Raw_151209_F2_C1_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C1\VoltageStep_Raw_151209_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C1\Sweep_Raw_151209_F2_C1_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151209_F2_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C2\PiezoSine_Raw_151209_F2_C2_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C2\CurrentChirp_Raw_151209_F2_C2_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C2\VoltageStep_Raw_151209_F2_C2_32.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C2\Sweep_Raw_151209_F2_C2_2.mat';
end


%% No nerve (Voltage Clamp experiments)

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151007_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F1_C1\VoltageCommand_Raw_151007_F1_C1_4.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F1_C1\Sweep_Raw_151007_F1_C1_5.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151007_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F3_C1\VoltageCommand_Raw_151007_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F3_C1\Sweep_Raw_151007_F3_C1_3.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end


%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151009_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151009\151009_F1_C1\VoltageCommand_Raw_151009_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151009\151009_F1_C1\Sweep_Raw_151009_F1_C1_6.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end

%%  pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151022_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151022\151022_F1_C1\VoltageCommand_Raw_151022_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151022\151022_F1_C1\Sweep_Raw_151022_F1_C1_3.mat';
end


%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151029_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151029\151029_F3_C1\VoltageCommand_Raw_151029_F3_C1_3.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151029\151029_F3_C1\Sweep_Raw_151029_F3_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151118_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151118\151118_F1_C1\VoltageCommand_Raw_151118_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151118\151118_F1_C1\Sweep_Raw_151118_F1_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151121_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151121\151121_F3_C1\VoltageCommand_Raw_151121_F3_C1_4.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151121\151121_F3_C1\Sweep_Raw_151121_F3_C1_4.mat';

    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end

%%
%Script_FrequencySelectivity

