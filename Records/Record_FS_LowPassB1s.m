%% Record of Low Frequency Responsive Cells
clear all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_LowPassB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1
id = 'LP_';

%%

analysis_grid = {...
    '131015_F3_C1'  'GH86;pJFRC7'                   'coarse frequency, no current injections';                  
    '130911_F2_C1'  'GH86;pJFRC7'                   'coarse frequency, no current injections';                 
    '140122_F2_C1'  'pJFRC7;VT30609-Gal4'           'coarse freq sample, single amplitude, VCLAMP data!';      
    '140128_F1_C1'  'pJFRC7;VT30609-Gal4'           'Complete over harmonics, slight band pass';                
    '150326_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                  
    '150402_F3_C2'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                 
    '150402_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                 
    '150502_F1_C2'  'pJFRC7;VT45599-Gal4'           'no sag current, not a lot of K current, chirp low pass-ish';  

    '150504_F1_C1'  'ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
    '150504_F1_C2'  'ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
    '150504_F1_C3'  'ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  

    '150623_F1_C1'  'pJFRC7/[UAS-ort];45D07-Gal4/+' 'Very low pass, large, largest response to low frequencies';  

    '151103_F3_C1'  'ShakB2-y/X;pJFRC7;45D07'        'Crazy big responses. Beautiful, but wrecks the ShakB stats!'
    '151106_F1_C1'  'ShakB2-y/X;pJFRC7;45D07'       'More normal sized'
    '151106_F1_C3'  'ShakB2-y/X;pJFRC7;45D07'       'Big responses. No drugs!'

    '151209_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'
    '151209_F1_C2'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'
    '151209_F2_C3'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'

    '151211_F2_C1'  '20XUAS-mCD8:GFP;45D07-Gal4'  'Big responses. No drugs!'
    '151211_F3_C1'  '20XUAS-mCD8:GFP;45D07-Gal4'  'Weird hyperpolarized responses!'
   };

suspect_grid = {
    '150504_F1_C1'  'ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
    '150504_F1_C2'  'ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
    '150504_F1_C3'  'ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
    '151103_F3_C1'  'ShakB2-y/X;pJFRC7;45D07'        'Crazy big responses. Beautiful, but wrecks the ShakB stats!'
    '151106_F1_C1'  'ShakB2-y/X;pJFRC7;45D07'       'More normal sized'
    '151106_F1_C3'  'ShakB2-y/X;pJFRC7;45D07'       'Big responses. No drugs!'
};

male_grid = { ...
    '151103_F3_C1' 'ShakB2-y/X;pJFRC7;45D07'        'Crazy big responses. Beautiful, but wrecks the ShakB stats!'
    '151106_F1_C1'  'ShakB2-y/X;pJFRC7;45D07'       'More normal sized'
    '151106_F1_C3'  'ShakB2-y/X;pJFRC7;45D07'       'Big responses. No drugs!'
    }

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1};
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1};
end
analysis_cells

%% 'GH86;pJFRC7'

cnt = find(strcmp(analysis_cells,'131015_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\PiezoSine_Raw_131015_F3_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_1.mat';
end

%% 'GH86;pJFRC7'
cnt = find(strcmp(analysis_cells,'130911_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\130911\130911_F2_C1\PiezoSine_Raw_130911_F2_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        '';
end


%% 'pJFRC7;VT30609'

cnt = find(strcmp(analysis_cells,'140122_F2_C1'));
if ~isempty(cnt)
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
end

%% 'pJFRC7;VT30609'

cnt = find(strcmp(analysis_cells,'140128_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_61.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_6.mat';
end


%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150326_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\CurrentStep_Raw_150326_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\CurrentChirp_Raw_150326_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\Sweep_Raw_150326_F1_C1_3.mat';
end

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F3_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C2\PiezoSine_Raw_150402_F3_C2_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C2\CurrentChirp_Raw_150402_F3_C2_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C2\Sweep_Raw_150402_F3_C2_1.mat';
end

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\PiezoSine_Raw_150402_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\CurrentStep_Raw_150402_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\CurrentChirp_Raw_150402_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\Sweep_Raw_150402_F1_C1_1.mat';
end

%% VT45599
cnt = find(strcmp(analysis_cells,'150502_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C2\PiezoSine_Raw_150502_F1_C2_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C2\CurrentStep_Raw_150502_F1_C2_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C2\CurrentChirp_Raw_150502_F1_C2_2.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150502\150502_F1_C2\Sweep_Raw_150502_F1_C2_5.mat';
end

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C1\PiezoSine_Raw_150504_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C1\Sweep_Raw_150504_F1_C1_3.mat';
end

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C2\PiezoSine_Raw_150504_F1_C2_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C2\CurrentStep_Raw_150504_F1_C2_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C2\CurrentChirp_Raw_150504_F1_C2_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C2\Sweep_Raw_150504_F1_C2_3.mat';
end

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C3\PiezoSine_Raw_150504_F1_C3_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C3\CurrentStep_Raw_150504_F1_C3_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150504\150504_F1_C3\Sweep_Raw_150504_F1_C3_4.mat';
end

%% 'pJFRC7/[UAS-ort];45D07-Gal4/+'     'Very low pass, large, largest response to low frequencies';  % not responsive to histamine, so, not sure.
cnt = find(strcmp(analysis_cells,'150623_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150623\150623_F1_C1\PiezoSine_Raw_150623_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150623\150623_F1_C1\CurrentChirp_Raw_150623_F1_C1_4.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150623\150623_F1_C1\Sweep_Raw_150623_F1_C1_4.mat';
end
%% 'ShakB2-y/X;pJFRC7;45D07' 'Crazy big responses. Beautiful, but wrecks the ShakB stats!'


cnt = find(strcmp(analysis_cells,'151103_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151103\151103_F3_C1\PiezoSine_Raw_151103_F3_C1_25.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151103\151103_F3_C1\CurrentChirp_Raw_151103_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151103\151103_F3_C1\Sweep_Raw_151103_F3_C1_5.mat';
end
%% 'ShakB2-y/X;pJFRC7;45D07'       'More normal sized'

cnt = find(strcmp(analysis_cells,'151106_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151106\151106_F1_C1\PiezoSine_Raw_151106_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151106\151106_F1_C1\CurrentChirp_Raw_151106_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151106\151106_F1_C1\Sweep_Raw_151106_F1_C1_2.mat';
end
%% 'ShakB2-y/X;pJFRC7;45D07'       'Big responses. No drugs!'

cnt = find(strcmp(analysis_cells,'151106_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151106\151106_F1_C3\PiezoSine_Raw_151106_F1_C3_4.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151106\151106_F1_C3\CurrentChirp_Raw_151106_F1_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151106\151106_F1_C3\Sweep_Raw_151106_F1_C3_6.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'

cnt = find(strcmp(analysis_cells,'151209_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C1\PiezoSine_Raw_151209_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C1\CurrentChirp_Raw_151209_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C1\Sweep_Raw_151209_F1_C1_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'

cnt = find(strcmp(analysis_cells,'151209_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C2\PiezoSine_Raw_151209_F1_C2_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C2\CurrentChirp_Raw_151209_F1_C2_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F1_C2\Sweep_Raw_151209_F1_C2_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151209_F2_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C3\PiezoSine_Raw_151209_F2_C3_1.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C3\PiezoChirp_Raw_151209_F2_C3_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C3\CurrentChirp_Raw_151209_F2_C3_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C3\VoltageStep_Raw_151209_F2_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151209\151209_F2_C3\Sweep_Raw_151209_F2_C3_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151211_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F2_C1\PiezoSine_Raw_151211_F2_C1_177.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F2_C1\PiezoChirp_Raw_151211_F2_C1_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F2_C1\CurrentChirp_Raw_151211_F2_C1_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F2_C1\VoltageStep_Raw_151211_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F2_C1\Sweep_Raw_151211_F2_C1_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151211_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F3_C1\PiezoSine_Raw_151211_F3_C1_1.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F3_C1\PiezoChirp_Raw_151211_F3_C1_3.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F3_C1\CurrentChirp_Raw_151211_F3_C1_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F3_C1\VoltageStep_Raw_151211_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\151211\151211_F3_C1\Sweep_Raw_151211_F3_C1_2.mat';
end


%%
%Script_FrequencySelectivity