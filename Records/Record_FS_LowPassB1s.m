%% Record of Low Frequency Responsive Cells
clear all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_LowPassB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1
id = 'LP_';

%%

analysis_cells = {...
'131015_F3_C1'
'130911_F2_C1'
'140122_F2_C1'
'140128_F1_C1'
'150326_F1_C1'
'150402_F3_C2'
'150402_F1_C1'
'150502_F1_C2'
'150504_F1_C1'
'150504_F1_C2'
'150504_F1_C3'
'150623_F1_C1'
};

analysis_cells_comment = {...
    'coarse frequency, no current injections';                  % 130911_F2_C1
    'coarse frequency, no current injections';                  % 131015_F3_C1    
    'coarse freq sample, single amplitude, VCLAMP data!';       % 140122_F2_C1
    'Complete over harmonics, slight band pass';                %'140128_F1_C1'
    '';                  % 150326_F1_C1
    '';                  % 150402_F3_C2
    '';                  % 150402_F1_C1
    'no sag current, not a lot of K current, chirp low pass-ish';  % '150502_F1_C2'
    'Very low pass, large, largest response to low frequencies';  % '150504_F1_C2'
    'Very low pass, large, largest response to low frequencies';  % '150504_F1_C2'
    'Very low pass, large, largest response to low frequencies';  % '150504_F1_C3'
    'Very low pass, large, largest response to low frequencies';  % '150504_F1_C3'
};

analysis_cells_genotype = {...
'GH86;pJFRC7'
'GH86;pJFRC7'
'pJFRC7;VT30609'
'pJFRC7;VT30609'
'pJFRC7;VT27938'
'pJFRC7;VT27938'
'pJFRC7;VT27938'
'pJFRC7;VT45599'
'ArcLight;45D07-Gal4'
'ArcLight;45D07-Gal4'
'ArcLight;45D07-Gal4'
'pJFRC7/[UAS-ort];45D07-Gal4/+' % not responsive to histamine, so, not sure.
};

%%
clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%% 'GH86;pJFRC7'
cnt = find(strcmp(analysis_cells,'130911_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\130911\130911_F2_C1\PiezoSine_Raw_130911_F2_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'';

%% 'GH86;pJFRC7'

cnt = find(strcmp(analysis_cells,'131015_F3_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\PiezoSine_Raw_131015_F3_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_1.mat';

%% 'pJFRC7;VT30609'

cnt = find(strcmp(analysis_cells,'140122_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_12.mat';
analysis_cell(cnt).PiezoSineTrial_VClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_9.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'';

%% 'pJFRC7;VT30609'

cnt = find(strcmp(analysis_cells,'140128_F1_C1'));

analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_61.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_6.mat';


%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150326_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\CurrentStep_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\CurrentChirp_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\Sweep_Raw_150326_F1_C1_3.mat';

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F3_C2'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C2\PiezoSine_Raw_150402_F3_C2_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C2\CurrentChirp_Raw_150402_F3_C2_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C2\Sweep_Raw_150402_F3_C2_1.mat';

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\PiezoSine_Raw_150402_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\CurrentStep_Raw_150402_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\CurrentChirp_Raw_150402_F1_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\Sweep_Raw_150402_F1_C1_1.mat';

%% VT45599
cnt = find(strcmp(analysis_cells,'150502_F1_C2'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C2\PiezoSine_Raw_150502_F1_C2_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C2\CurrentStep_Raw_150502_F1_C2_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C2\CurrentChirp_Raw_150502_F1_C2_2.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C2\Sweep_Raw_150502_F1_C2_5.mat';

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C1\PiezoSine_Raw_150504_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C1\Sweep_Raw_150504_F1_C1_3.mat';

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C2'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C2\PiezoSine_Raw_150504_F1_C2_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C2\CurrentStep_Raw_150504_F1_C2_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C2\CurrentChirp_Raw_150504_F1_C2_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C2\Sweep_Raw_150504_F1_C2_3.mat';

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C3'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C3\PiezoSine_Raw_150504_F1_C3_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C3\CurrentStep_Raw_150504_F1_C3_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C3\Sweep_Raw_150504_F1_C3_4.mat';

%% 
%Script_FrequencySelectivity