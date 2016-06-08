%% Record of Low Frequency Responsive Cells
clear analysis_cell analysis_cells c cnt id save_log example_cell analysis_grid
savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_FS_LowPassB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1;
id = 'LP_';

%%

analysis_grid = {...
%     '130911_F2_C1'  'GH86;pJFRC7'                   'coarse frequency, no current injections';                 
%     '131015_F3_C1'  'GH86;pJFRC7'                   'coarse frequency, no current injections';                  
%     '140122_F2_C1'  'UAS-ArcLight/VT30609-Gal4'           'coarse freq sample, single amplitude, VCLAMP data!';      
%     '140128_F1_C1'  'UAS-ArcLight/VT30609-Gal4'           'Complete over harmonics, slight band pass';                
    '150326_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                  
    '150402_F3_C2'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                 
    '150402_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                 
    '150502_F1_C2'  '20XUAS-mCD8:GFP;VT45599-Gal4'           'no sag current, not a lot of K current, chirp low pass-ish';  

%     '150504_F1_C1'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
%     '150504_F1_C2'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
%     '150504_F1_C3'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  

%     '150623_F1_C1'  'pJFRC7/[UAS-ort];45D07-Gal4/+' 'Very low pass, large, largest response to low frequencies';  

    '151103_F3_C1'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'        'Crazy big responses. Beautiful, but wrecks the ShakB stats!'
    '151106_F1_C1'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'More normal sized'
    '151106_F1_C3'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'Big responses. No drugs!'

    '151209_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'
    '151209_F1_C2'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'
    '151209_F2_C3'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'

    '151211_F2_C1'  '20XUAS-mCD8:GFP;45D07-Gal4'  'Big responses. No drugs!'
    '151211_F3_C1'  '20XUAS-mCD8:GFP;45D07-Gal4'  'Weird hyperpolarized responses!'
   };

vm_analysis_grid = {...
%     '130911_F2_C1'  'GH86;pJFRC7'                   'coarse frequency, no current injections';                 
     '131015_F3_C1'  'GH86;pJFRC7'                   'coarse frequency, no current injections';                  
%     '140122_F2_C1'  'UAS-ArcLight/VT30609-Gal4'           'coarse freq sample, single amplitude, VCLAMP data!';      
%      '140128_F1_C1'  'UAS-ArcLight/VT30609-Gal4'           'Complete over harmonics, slight band pass';                
    '150326_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                  
    '150402_F3_C2'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                 
    '150402_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  '';                 
    '150502_F1_C2'  '20XUAS-mCD8:GFP;VT45599-Gal4'           'no sag current, not a lot of K current, chirp low pass-ish';  

%     '150504_F1_C1'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
%     '150504_F1_C2'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
%     '150504_F1_C3'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  

%     '150623_F1_C1'  'pJFRC7/[UAS-ort];45D07-Gal4/+' 'Very low pass, large, largest response to low frequencies';  

    '151103_F3_C1'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'        'Crazy big responses. Beautiful, but wrecks the ShakB stats!'
    '151106_F1_C1'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'More normal sized'
    '151106_F1_C3'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'Big responses. No drugs!'

    '151209_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'
    '151209_F1_C2'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'
    '151209_F2_C3'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'Big responses. No drugs!'

    '151211_F2_C1'  '20XUAS-mCD8:GFP;45D07-Gal4'  'Big responses. No drugs!'
    '151211_F3_C1'  '20XUAS-mCD8:GFP;45D07-Gal4'  'Weird hyperpolarized responses!'
   };

suspect_grid = {
    '150504_F1_C1'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
    '150504_F1_C2'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
    '150504_F1_C3'  'UAS-ArcLight;45D07-Gal4'           'Very low pass, large, largest response to low frequencies';  
    '151103_F3_C1'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'        'Crazy big responses. Beautiful, but wrecks the ShakB stats!'
    '151106_F1_C1'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'More normal sized'
    '151106_F1_C3'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'Big responses. No drugs!'
};

male_grid = { ...
    '151103_F3_C1' 'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'        'Crazy big responses. Beautiful, but wrecks the ShakB stats!'
    '151106_F1_C1'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'More normal sized'
    '151106_F1_C3'  'ShakB2-y/X;20XUAS-mCD8:GFP;45D07-Gal4'       'Big responses. No drugs!'
    };

clear analysis_cell analysis_cells
for c = 1:size(vm_analysis_grid,1)
    analysis_cell(c).name = vm_analysis_grid{c,1};
    analysis_cell(c).genotype = vm_analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = vm_analysis_grid{c,3};
    analysis_cells{c} = vm_analysis_grid{c,1};
end
fprintf('LowPass: \n')
fprintf('\t%s\n',analysis_cells{:})


%% Example cell 
example_cell.name = '151209_F1_C1';
example_cell.PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C1\PiezoSine_Raw_151209_F1_C1_3.mat';
example_cell.CurrentStepTrial = ...
'';
example_cell.CurrentChirpTrial = ...
'';
example_cell.SweepTrial = ...
'';

% other possibility
example_cell.name = '151209_F1_C2';
example_cell.PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\PiezoSine_Raw_151209_F1_C2_7.mat';

example_cell.name = '150502_F1_C3';
example_cell.SweepTrial = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C3\Sweep_Raw_150502_F1_C3_6.mat';
example_cell.SpikeTrial = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C3\Sweep_Raw_150502_F1_C3_22.mat';
example_cell.SpikeInterval = ...
        [2 3];
example_cell.CurrentStepTrialDown = ...
'/Users/tony/Raw_Data/151121/151121_F1_C1/CurrentStep_Raw_151121_F1_C1_1.mat';
example_cell.CurrentStepTrialUp = ...
'C:\Users\tony\Raw_Data\151121\151121_F1_C1\CurrentStep_Raw_151121_F1_C1_9.mat';

% % other possibilities
example_cell.name = '131126_F2_C1';
example_cell.SweepTrial = ...
'C:\Users\tony\Raw_Data\150326\150326_F1_C1\Sweep_Raw_150326_F1_C1_1.mat';
example_cell.SpikeTrial = ...
'C:\Users\tony\Raw_Data\131126\131126_F2_C1\Sweep_Raw_131126_F2_C1_6.mat';
example_cell.SpikeInterval = ...
    [2 3];

example_cell.name = '150502_F1_C2';
example_cell.SweepTrial = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C2\Sweep_Raw_150502_F1_C2_2.mat';
example_cell.SpikeTrial = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C2\Sweep_Raw_150502_F1_C2_35.mat';
example_cell.SpikeInterval = ...
    [2 3];
example_cell.CurrentStepTrialWayDown = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C2\CurrentStep_Raw_150502_F1_C2_2.mat';
example_cell.CurrentStepTrialDown = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C2\CurrentStep_Raw_150502_F1_C2_5.mat';
example_cell.CurrentStepTrialUp = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C2\CurrentStep_Raw_150502_F1_C2_8.mat';

% example_cell.CurrentStepTrialWayDown = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F1_C1\CurrentStep_Raw_150402_F1_C1_2.mat';
% example_cell.CurrentStepTrialDown = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F1_C1\CurrentStep_Raw_150402_F1_C1_5.mat';
% example_cell.CurrentStepTrialUp = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F1_C1\CurrentStep_Raw_150402_F1_C1_8.mat';


% example_cell.CurrentStepTrialWayDown = ...
% %'C:\Users\tony\Raw_Data\150402\150402_F2_C1\CurrentStep_Raw_150402_F2_C1_1.mat';
% example_cell.CurrentStepTrialDown = ...
% 'C:\Users\tony\Raw_Data\150326\150326_F1_C1\CurrentStep_Raw_150326_F1_C1_2.mat';
% example_cell.CurrentStepTrialUp = ...
% 'C:\Users\tony\Raw_Data\150326\150326_F1_C1\CurrentStep_Raw_150326_F1_C1_8.mat';
% %'C:\Users\tony\Raw_Data\150402\150402_F2_C1\CurrentStep_Raw_150402_F2_C1_20.mat';

%% Figure 3 example

fig3example_cell0.name = '151209_F1_C2';
fig3example_cell0.PiezoStepTrialAnt = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\PiezoStep_Raw_151209_F1_C2_19.mat';
fig3example_cell0.PiezoStepTrialPost = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\PiezoStep_Raw_151209_F1_C2_18.mat';

fig3example_cell0.PiezoSine25 = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\PiezoSine_Raw_151209_F1_C2_7.mat';
fig3example_cell0.PiezoSine50 = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\PiezoSine_Raw_151209_F1_C2_15.mat';
fig3example_cell0.PiezoSine100 = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\PiezoSine_Raw_151209_F1_C2_23.mat';

fig3example_cell0.genotype = '20XUAS-mCD8:GFP;45D07-Gal4'; %#ok<*SAGROW>


fig3example_cell180.name = '151211_F3_C1';
fig3example_cell180.PiezoStepTrialAnt = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\PiezoStep_Raw_151211_F3_C1_1.mat';
fig3example_cell180.PiezoStepTrialPost = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\PiezoStep_Raw_151211_F3_C1_6.mat';

fig3example_cell180.PiezoSine25 = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\PiezoSine_Raw_151211_F3_C1_7.mat';
fig3example_cell180.PiezoSine50 = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\PiezoSine_Raw_151211_F3_C1_15.mat';
fig3example_cell180.PiezoSine100 = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\PiezoSine_Raw_151211_F3_C1_23.mat';

fig3example_cell180.genotype = '20XUAS-mCD8:GFP;45D07-Gal4'; %#ok<*SAGROW>


%% 'GH86;pJFRC7'

cnt = find(strcmp(analysis_cells,'131015_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\131015\131015_F3_C1\PiezoSine_Raw_131015_F3_C1_2.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_1.mat';
end

%% 'GH86;pJFRC7'
cnt = find(strcmp(analysis_cells,'130911_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\130911\130911_F2_C1\PiezoSine_Raw_130911_F2_C1_1.mat';
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
'C:\Users\tony\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_25.mat';
    analysis_cell(cnt).PiezoSineTrial_VClamp = ...
        'C:\Users\tony\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_9.mat';
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
        'C:\Users\tony\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_61.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_6.mat';
end


%% 'pJFRC7;VT27938'
cnt = find(strcmp(analysis_cells,'150326_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150326\150326_F1_C1\CurrentStep_Raw_150326_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150326\150326_F1_C1\CurrentChirp_Raw_150326_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150326\150326_F1_C1\Sweep_Raw_150326_F1_C1_3.mat';
end

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F3_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150402\150402_F3_C2\PiezoSine_Raw_150402_F3_C2_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F3_C2\CurrentChirp_Raw_150402_F3_C2_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F3_C2\Sweep_Raw_150402_F3_C2_1.mat';
end

%% 'pJFRC7;VT27938'

cnt = find(strcmp(analysis_cells,'150402_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150402\150402_F1_C1\PiezoSine_Raw_150402_F1_C1_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F1_C1\CurrentStep_Raw_150402_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F1_C1\CurrentChirp_Raw_150402_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150402\150402_F1_C1\Sweep_Raw_150402_F1_C1_1.mat';
end

%% VT45599
cnt = find(strcmp(analysis_cells,'150502_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150502\150502_F1_C2\PiezoSine_Raw_150502_F1_C2_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C2\CurrentStep_Raw_150502_F1_C2_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C2\CurrentChirp_Raw_150502_F1_C2_2.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150502\150502_F1_C2\Sweep_Raw_150502_F1_C2_5.mat';
end

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C1\PiezoSine_Raw_150504_F1_C1_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C1\Sweep_Raw_150504_F1_C1_3.mat';
end

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C2\PiezoSine_Raw_150504_F1_C2_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C2\CurrentStep_Raw_150504_F1_C2_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C2\CurrentChirp_Raw_150504_F1_C2_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C2\Sweep_Raw_150504_F1_C2_3.mat';
end

%% 'ArcLight;45D07-Gal4'

cnt = find(strcmp(analysis_cells,'150504_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C3\PiezoSine_Raw_150504_F1_C3_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C3\CurrentStep_Raw_150504_F1_C3_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150504\150504_F1_C3\Sweep_Raw_150504_F1_C3_4.mat';
end

%% 'pJFRC7/[UAS-ort];45D07-Gal4/+'     'Very low pass, large, largest response to low frequencies';  % not responsive to histamine, so, not sure.
cnt = find(strcmp(analysis_cells,'150623_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150623\150623_F1_C1\PiezoSine_Raw_150623_F1_C1_6.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\150623\150623_F1_C1\CurrentChirp_Raw_150623_F1_C1_4.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\150623\150623_F1_C1\Sweep_Raw_150623_F1_C1_4.mat';
end
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
end
%% 'ShakB2-y/X;pJFRC7;45D07'       'More normal sized'

cnt = find(strcmp(analysis_cells,'151106_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C1\PiezoSine_Raw_151106_F1_C1_11.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C1\CurrentChirp_Raw_151106_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C1\Sweep_Raw_151106_F1_C1_2.mat';
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
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'

cnt = find(strcmp(analysis_cells,'151209_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C1\PiezoSine_Raw_151209_F1_C1_11.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C1\CurrentChirp_Raw_151209_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C1\Sweep_Raw_151209_F1_C1_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'

cnt = find(strcmp(analysis_cells,'151209_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\PiezoSine_Raw_151209_F1_C2_11.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\CurrentChirp_Raw_151209_F1_C2_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F1_C2\Sweep_Raw_151209_F1_C2_2.mat';
end

%% '20XUAS-mCD8:GFP;VT27938-Gal4'
cnt = find(strcmp(analysis_cells,'151209_F2_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C3\PiezoSine_Raw_151209_F2_C3_11.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C3\PiezoChirp_Raw_151209_F2_C3_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C3\CurrentChirp_Raw_151209_F2_C3_1.mat';
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C3\VoltageStep_Raw_151209_F2_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151209\151209_F2_C3\Sweep_Raw_151209_F2_C3_2.mat';
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
    analysis_cell(cnt).VoltgageStepTrial = ...
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
    analysis_cell(cnt).VoltgageStepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\VoltageStep_Raw_151211_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151211\151211_F3_C1\Sweep_Raw_151211_F3_C1_2.mat';
end


%%
%Script_FrequencySelectivity