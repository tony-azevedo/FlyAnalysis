%% Record of BandPass Low Cells
clear analysis_cell analysis_cells c cnt id save_log example_cell analysis_grid
savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_FS_BandPassLowB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1;
id = 'BPL_';

%%
analysis_grid = {...
%     '131122_F2_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'       'coarse frequency, no current injections';
%     '131126_F2_C3'  '20XUAS-mCD8:GFP;VT30609-Gal4'       'Complete over harmonics, slight band pass';
%     '131126_F2_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'       'coarse freq sample, single amplitude, VCLAMP data!';
%     '131211_F2_C1'  'UAS-ArcLight/VT30609-Gal4'       'Low pass, first cell with more sine waves.  No clear spiking, sharper tuning';
    
%     '140117_F2_C1'  'UAS-ArcLight/VT30609-Gal4'      'coarse frequency, no current injections';
%     '140602_F2_C1'  'UAS-ArcLight/VT30609-Gal4'      ''
%     '140603_F1_C1'  'UAS-ArcLight/VT30609-Gal4'      'Has no PiezoSine data'

'150402_F2_C1'  'GH86-Gal4;20XUAS-mCD8:GFP;'          ''
%    '150408_F1_C1'  'GH86-Gal4;20XUAS-mCD8:GFP;'      'Larger amplitudes produce lower amplitude responses'    
%    '150408_F2_C1'  'GH86-Gal4;20XUAS-mCD8:GFP;'      'Larger amplitudes produce lower amplitude responses'
    '150409_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '150414_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '150417_F1_C1'  'GH86-Gal4;20XUAS-mCD8:GFP;'        ''
    
    '150502_F1_C1'  '20XUAS-mCD8:GFP;VT45599-Gal4'        ''
    '150502_F1_C3'  '20XUAS-mCD8:GFP;VT45599-Gal4'        ''
    
    '151203_F2_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'        ''
    '151203_F3_C1'  '20XUAS-mCD8:GFP;VT30609-Gal4'        ''
    
    '151205_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '151208_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '151208_F2_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        'Great recording, have to throw out the first blocks, starting at , cell sealed up'

    '151209_F1_C3'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '151209_F2_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''
    '151209_F2_C2'  '20XUAS-mCD8:GFP;VT27938-Gal4'        ''

    '151211_F1_C4'  '20XUAS-mCD8:GFP;45D07-Gal4'        ''
    };

possible_examples_grid = {
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

% analysis_grid = possible_examples_grid;

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1};
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1};
end
fprintf('BandPass-Low: \n')
fprintf('\t%s\n',analysis_cells{:})

%%
reject_cells = {
    '150402_F3_C1'  'GH86;pJFRC7'      'Responses are small and strange'
    };

%% Example cell 
example_cell.name = '151208_F1_C1 ';
example_cell.PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151208\151208_F1_C1\PiezoSine_Raw_151208_F1_C1_22.mat';
example_cell.CurrentStepTrial = ...
'';
example_cell.CurrentChirpTrial = ...
'';
example_cell.SweepTrial = ...
'';

% other possibility
% example_cell.name = '';
% example_cell.PiezoSineTrial = ...
% '';
% example_cell.CurrentStepTrial = ...
% '';
% example_cell.CurrentChirpTrial = ...
% '';
% example_cell.SweepTrial = ...
% '';

%% Figure 3 example

fig3example_cell0.name = '151211_F1_C4';
fig3example_cell0.PiezoStepTrialAnt = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\PiezoStep_Raw_151211_F1_C4_7.mat';
fig3example_cell0.PiezoStepTrialPost = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\PiezoStep_Raw_151211_F1_C4_6.mat';

fig3example_cell0.PiezoSine25 = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\PiezoSine_Raw_151211_F1_C4_7.mat';
fig3example_cell0.PiezoSine50 = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\PiezoSine_Raw_151211_F1_C4_15.mat';
fig3example_cell0.PiezoSine100 = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\PiezoSine_Raw_151211_F1_C4_23.mat';
% fig3example_cell180.PiezoSine200 = ...
% 'C:\Users\tony\Raw_Data\151211\151211_F1_C4\PiezoSine_Raw_151211_F1_C4_31.mat';

fig3example_cell0.genotype = '20XUAS-mCD8:GFP;45D07-Gal4'; %#ok<*SAGROW>


fig3example_cell180.name = '151209_F1_C3';
fig3example_cell180.PiezoStepTrialAnt = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\PiezoStep_Raw_151209_F1_C3_7.mat';
fig3example_cell180.PiezoStepTrialPost = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\PiezoStep_Raw_151209_F1_C3_6.mat';

fig3example_cell180.PiezoSine25 = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\PiezoSine_Raw_151209_F1_C3_7.mat';
fig3example_cell180.PiezoSine50 = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\PiezoSine_Raw_151209_F1_C3_15.mat';
fig3example_cell180.PiezoSine100 = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\PiezoSine_Raw_151209_F1_C3_23.mat';
% fig3example_cell0.PiezoSine200 = ...
% 'C:\Users\tony\Raw_Data\151209\151209_F1_C3\PiezoSine_Raw_151209_F1_C3_31.mat';

fig3example_cell180.genotype = '20XUAS-mCD8:GFP;VT27938-Gal4'; %#ok<*SAGROW>


%% '20XUAS-mCD8:GFP;VT30609-Gal4'

cnt = find(strcmp(analysis_cells,'131122_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_8.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\131122\131122_F2_C1\Sweep_Raw_131122_F2_C1_5.mat';
    analysis_cell(cnt).extratrials = {...
        'C:\Users\tony\Raw_Data\131122\131122_F2_C1\Sweep_Raw_131122_F2_C1_5.mat'; % early cells, not great recordings
        };

end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'

cnt = find(strcmp(analysis_cells,'131126_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\131126\131126_F2_C1\PiezoSine_Raw_131126_F2_C1_8.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\131126\131126_F2_C1\Sweep_Raw_131126_F2_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'

cnt = find(strcmp(analysis_cells,'131126_F2_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\131126\131126_F2_C3\PiezoSine_Raw_131126_F2_C3_8.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        '';
    
    analysis_cell(cnt).extratrials = {...
        'C:\Users\tony\Raw_Data\131126\131126_F2_C3\Sweep_Raw_131126_F2_C3_3.mat'; % endo of the cell, not great
        };

end


%% 'ArcLight;VT30609'
cnt = find(strcmp(analysis_cells,'131211_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_14.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        '';
    
    analysis_cell(cnt).extratrials = {...
        'C:\Users\tony\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_1.mat'; % early recording, not that great
        'C:\Users\tony\Raw_Data\131211\131211_F2_C1\CurrentPlateau_Raw_131211_F2_C1_5.mat';
        'C:\Users\tony\Raw_Data\131211\131211_F2_C1\CurrentStep_Raw_131211_F2_C1_2.mat';
        };
end

%% 'ArcLight;VT30609'


cnt = find(strcmp(analysis_cells,'140117_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_11.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\140117\140117_F2_C1\CurrentStep_Raw_140117_F2_C1_1.mat';
end

%% 'ArcLight;VT30609'

cnt = find(strcmp(analysis_cells,'140602_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\140602\140602_F2_C1\PiezoSine_Raw_140602_F2_C1_14.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\140602\140602_F2_C1\CurrentStep_Raw_140602_F2_C1_25.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\140602\140602_F2_C1\CurrentChirp_Raw_140602_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\140602\140602_F2_C1\CurrentStep_Raw_140602_F2_C1_1.mat';
end

%% 'ArcLight;VT30609'

cnt = find(strcmp(analysis_cells,'140603_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        '';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\140603\140603_F1_C1\CurrentStep_Raw_140603_F1_C1_5.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\140602\140602_F2_C1\CurrentChirp_Raw_140602_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\140603\140603_F1_C1\CurrentStep_Raw_140603_F1_C1_5.mat';
end

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150402\150402_F2_C1\PiezoSine_Raw_150402_F2_C1_16.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F2_C1\CurrentStep_Raw_150402_F2_C1_8.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F2_C1\CurrentChirp_Raw_150402_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F2_C1\Sweep_Raw_150402_F2_C1_1.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\150402\150402_F2_C1\PiezoBWCourtshipSong_Raw_150402_F2_C1_1.mat';
    analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\150402\150402_F2_C1\PiezoCourtshipSong_Raw_150402_F2_C1_3.mat';
    analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\150402\150402_F2_C1\PiezoLongCourtshipSong_Raw_150402_F2_C1_1.mat';

end

%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150402_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150402\150402_F3_C1\PiezoSine_Raw_150402_F3_C1_16.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F3_C1\CurrentStep_Raw_150402_F3_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F3_C1\CurrentChirp_Raw_150402_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F3_C1\Sweep_Raw_150402_F3_C1_1.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\150402\150402_F3_C1\PiezoBWCourtshipSong_Raw_150402_F3_C1_4.mat';
    analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\150402\150402_F3_C1\PiezoCourtshipSong_Raw_150402_F3_C1_1.mat';
    analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\150402\150402_F2_C1\PiezoLongCourtshipSong_Raw_150402_F2_C1_1.mat';
end

%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150409_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150409\150409_F1_C1\PiezoSine_Raw_150409_F1_C1_16.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150409\150409_F1_C1\CurrentStep_Raw_150409_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150409\150409_F1_C1\CurrentChirp_Raw_150409_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150409\150409_F1_C1\Sweep_Raw_150409_F1_C1_1.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\150409\150409_F1_C1\PiezoBWCourtshipSong_Raw_150409_F1_C1_1.mat';
    analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\150409\150409_F1_C1\PiezoCourtshipSong_Raw_150409_F1_C1_1.mat';
    analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\150409\150409_F1_C1\PiezoLongCourtshipSong_Raw_150409_F1_C1_1.mat';
end

%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150414_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150414\150414_F1_C1\PiezoSine_Raw_150414_F1_C1_16.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150414\150414_F1_C1\CurrentStep_Raw_150414_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150414\150414_F1_C1\CurrentChirp_Raw_150414_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150414\150414_F1_C1\Sweep_Raw_150414_F1_C1_4.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\150414\150414_F1_C1\PiezoBWCourtshipSong_Raw_150414_F1_C1_1.mat';
    analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\150414\150414_F1_C1\PiezoCourtshipSong_Raw_150414_F1_C1_1.mat';
    analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\150414\150414_F1_C1\PiezoLongCourtshipSong_Raw_150414_F1_C1_1.mat';
end

%% GH86-Gal4
cnt = find(strcmp(analysis_cells,'150417_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150417\150417_F1_C1\PiezoSine_Raw_150417_F1_C1_16.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\tony\Raw_Data\150417\150417_F1_C1\CurrentStep_Raw_150417_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\150417\150417_F1_C1\CurrentChirp_Raw_150417_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\150417\150417_F1_C1\Sweep_Raw_150417_F1_C1_1.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'';
analysis_cell(cnt).PiezoCourtshipSong = ...
'';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'';
end

%% 'pJFRC7;VT45599'
cnt = find(strcmp(analysis_cells,'150502_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C1\PiezoSine_Raw_150502_F1_C1_16.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C1\CurrentStep_Raw_150502_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C1\CurrentChirp_Raw_150502_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C1\Sweep_Raw_150502_F1_C1_6.mat';
    analysis_cell(cnt).SweepVClampEx = 'C:\Users\tony\Raw_Data\150502\150502_F1_C1\Sweep_Raw_150502_F1_C1_3.mat';
    analysis_cell(cnt).VoltageStepEx = 'C:\Users\tony\Raw_Data\150502\150502_F1_C1\VoltageStep_Raw_150502_F1_C1_1.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'';
analysis_cell(cnt).PiezoCourtshipSong = ...
'';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'';
end

%% 'pJFRC7;VT45599'
cnt = find(strcmp(analysis_cells,'150502_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C3\PiezoSine_Raw_150502_F1_C3_16.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C3\CurrentStep_Raw_150502_F1_C3_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C3\CurrentChirp_Raw_150502_F1_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C3\Sweep_Raw_150502_F1_C3_7.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'';
analysis_cell(cnt).PiezoCourtshipSong = ...
'';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151203_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151203\151203_F2_C1\PiezoSine_Raw_151203_F2_C1_23.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\151203\151203_F2_C1\Sweep_Raw_151203_F2_C1_4.mat';
end

%% '20XUAS-mCD8:GFP;VT30609-Gal4'
cnt = find(strcmp(analysis_cells,'151203_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151203\151203_F3_C1\PiezoSine_Raw_151203_F3_C1_23.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\151203\151203_F3_C1\Sweep_Raw_151203_F3_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151205_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151205\151205_F1_C1\PiezoSine_Raw_151205_F1_C1_23.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\151205\151205_F1_C1\CurrentChirp_Raw_151205_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\151205\151205_F1_C1\Sweep_Raw_151205_F1_C1_4.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\151205\151205_F1_C1\PiezoBWCourtshipSong_Raw_151205_F1_C1_1.mat';
analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\151205\151205_F1_C1\PiezoCourtshipSong_Raw_151205_F1_C1_1.mat';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\151205\151205_F1_C1\PiezoLongCourtshipSong_Raw_151205_F1_C1_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151208_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151208\151208_F1_C1\PiezoSine_Raw_151208_F1_C1_30.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151208\151208_F1_C1\CurrentChirp_Raw_151208_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151208\151208_F1_C1\Sweep_Raw_151208_F1_C1_9.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\151208\151208_F1_C1\PiezoBWCourtshipSong_Raw_151208_F1_C1_1.mat';
analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\151208\151208_F1_C1\PiezoCourtshipSong_Raw_151208_F1_C1_1.mat';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\151208\151208_F1_C1\PiezoLongCourtshipSong_Raw_151208_F1_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151208_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151208\151208_F2_C1\PiezoSine_Raw_151208_F2_C1_266.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151208\151208_F2_C1\PiezoChirp_Raw_151208_F2_C1_3.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\151208\151208_F2_C1\PiezoBWCourtshipSong_Raw_151208_F2_C1_1.mat';
analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\151208\151208_F2_C1\PiezoCourtshipSong_Raw_151208_F2_C1_1.mat';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\151208\151208_F2_C1\PiezoLongCourtshipSong_Raw_151208_F2_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151209_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\PiezoSine_Raw_151209_F1_C3_23.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\VoltageStep_Raw_151209_F1_C3_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\CurrentChirp_Raw_151209_F1_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C3\Sweep_Raw_151209_F1_C3_2.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\PiezoBWCourtshipSong_Raw_151209_F2_C1_1.mat';
analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\PiezoCourtshipSong_Raw_151209_F2_C1_1.mat';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\PiezoLongCourtshipSong_Raw_151209_F2_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151209_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\PiezoSine_Raw_151209_F2_C1_27.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\CurrentChirp_Raw_151209_F2_C1_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\VoltageStep_Raw_151209_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\Sweep_Raw_151209_F2_C1_2.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\PiezoBWCourtshipSong_Raw_151209_F2_C1_1.mat';
analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\PiezoCourtshipSong_Raw_151209_F2_C1_1.mat';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C1\PiezoLongCourtshipSong_Raw_151209_F2_C1_1.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151209_F2_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C2\PiezoSine_Raw_151209_F2_C2_23.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C2\CurrentChirp_Raw_151209_F2_C2_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C2\VoltageStep_Raw_151209_F2_C2_32.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C2\Sweep_Raw_151209_F2_C2_2.mat';
    analysis_cell(cnt).PiezoBWCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C2\PiezoBWCourtshipSong_Raw_151209_F2_C2_1.mat';
analysis_cell(cnt).PiezoCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C2\PiezoCourtshipSong_Raw_151209_F2_C2_1.mat';
analysis_cell(cnt).PiezoLongCourtshipSong = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C2\PiezoLongCourtshipSong_Raw_151209_F2_C2_1.mat';
end

%% '20XUAS-mCD8:GFP;45D07-Gal4'
cnt = find(strcmp(analysis_cells,'151211_F1_C4'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\PiezoSine_Raw_151211_F1_C4_23.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\CurrentChirp_Raw_151211_F1_C4_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\VoltageStep_Raw_151211_F1_C4_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F1_C4\Sweep_Raw_151211_F1_C4_5.mat';
end


%% No nerve (Voltage Clamp experiments)

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151007_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151007\151007_F1_C1\VoltageCommand_Raw_151007_F1_C1_4.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151007\151007_F1_C1\Sweep_Raw_151007_F1_C1_5.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151007_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151007\151007_F3_C1\VoltageCommand_Raw_151007_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151007\151007_F3_C1\Sweep_Raw_151007_F3_C1_3.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end


%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151009_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151009\151009_F1_C1\VoltageCommand_Raw_151009_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151009\151009_F1_C1\Sweep_Raw_151009_F1_C1_6.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end

%%  pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151022_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151022\151022_F1_C1\VoltageCommand_Raw_151022_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151022\151022_F1_C1\Sweep_Raw_151022_F1_C1_3.mat';
end


%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151029_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151029\151029_F3_C1\VoltageCommand_Raw_151029_F3_C1_3.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151029\151029_F3_C1\Sweep_Raw_151029_F3_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151118_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151118\151118_F1_C1\VoltageCommand_Raw_151118_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151118\151118_F1_C1\Sweep_Raw_151118_F1_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151121_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151121\151121_F3_C1\VoltageCommand_Raw_151121_F3_C1_4.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151121\151121_F3_C1\Sweep_Raw_151121_F3_C1_4.mat';

    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end

%%
%Script_FrequencySelectivity

