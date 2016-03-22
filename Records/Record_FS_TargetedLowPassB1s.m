%% Record of Low Frequency Responsive Cells
clear analysis_cell analysis_cells c cnt id save_log example_cell analysis_grid
savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_FS_TargetedLowPassB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1;
id = 'TLP_';

%%

analysis_grid = {...
    '151103_F3_C1'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'        'Crazy big responses. Beautiful, but wrecks the ShakB stats!'
    '151106_F1_C3'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'Big responses. No drugs!'
    '151211_F2_C1'  '20XUAS-mCD8:GFP;45D07-Gal4'  'Big responses. No drugs!'
    '151211_F3_C1'  '20XUAS-mCD8:GFP;45D07-Gal4'  'Weird hyperpolarized responses!'
   };

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1};
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1};
end
fprintf('LowPass: \n')
fprintf('\t%s\n',analysis_cells{:})


%% Example cell 
example_cell.name = '151211_F2_C1';
example_cell.PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F2_C1\PiezoSine_Raw_151211_F2_C1_187.mat';
example_cell.PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F2_C1\PiezoStep_Raw_151211_F2_C1_32.mat';
example_cell.CurrentStepTrial = ...
'';
example_cell.CurrentChirpTrial = ...
'';
example_cell.SweepTrial = ...
'';

%% 'ShakB2-y/X;pJFRC7;45D07' 'Crazy big responses. Beautiful, but wrecks the ShakB stats!'


cnt = find(strcmp(analysis_cells,'151103_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151103\151103_F3_C1\PiezoSine_Raw_151103_F3_C1_11.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151103\151103_F3_C1\CurrentChirp_Raw_151103_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151103\151103_F3_C1\Sweep_Raw_151103_F3_C1_5.mat';
    analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151103\151103_F3_C1\VoltageStep_Raw_151103_F3_C1_1.mat';
end

%% 'ShakB2-y/X;pJFRC7;45D07'       'Big responses. No drugs!'

cnt = find(strcmp(analysis_cells,'151106_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C3\PiezoSine_Raw_151106_F1_C3_11.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\151106\151106_F1_C3\CurrentChirp_Raw_151106_F1_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\151106\151106_F1_C3\Sweep_Raw_151106_F1_C3_6.mat';
    analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C3\VoltageStep_Raw_151106_F1_C3_1.mat';
end



%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151211_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F2_C1\PiezoSine_Raw_151211_F2_C1_187.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F2_C1\PiezoChirp_Raw_151211_F2_C1_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F2_C1\CurrentChirp_Raw_151211_F2_C1_1.mat';
    analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F2_C1\VoltageStep_Raw_151211_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F2_C1\Sweep_Raw_151211_F2_C1_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151211_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\PiezoSine_Raw_151211_F3_C1_11.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\PiezoChirp_Raw_151211_F3_C1_3.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\CurrentChirp_Raw_151211_F3_C1_1.mat';
    analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\VoltageStep_Raw_151211_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\Sweep_Raw_151211_F3_C1_2.mat';
end


%%
%Script_FrequencySelectivity