%% ShakB controls MLA

analysis_grid = {
'150629_F1_C1'  	'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+'   ''  
'150629_F2_C1'  	'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+'   ''  
'150629_F3_C1'  	'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+'   ''  
'150701_F1_C1'  	'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+'   ''  
'151015_F2_C1'      'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+'   ''  
'151103_F3_C1'      'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+'   'A bizarre low pass neuron'    
'151106_F1_C1'      'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+'   ''       
};

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end


%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150629_F1_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\tony\Raw_Data\150629\150629_F1_C1\PiezoStep_Raw_150629_F1_C1_26.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\150629\150629_F1_C1\PiezoSine_Raw_150629_F1_C1_1.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'MLA 0.5 uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\150629\150629_F1_C1\PiezoStep_Raw_150629_F1_C1_50.mat'; % 'C:\Users\tony\Raw_Data\150629\150629_F1_C1\PiezoStep_Raw_150629_F1_C1_98.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\150629\150629_F1_C1\PiezoSine_Raw_150629_F1_C1_133.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150629_F2_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\tony\Raw_Data\150629\150629_F2_C1\PiezoStep_Raw_150629_F2_C1_5.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\150629\150629_F2_C1\PiezoSine_Raw_150629_F2_C1_1.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'MLA 0.5uM Cd 200uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\150629\150629_F2_C1\PiezoStep_Raw_150629_F2_C1_30.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\150629\150629_F2_C1\PiezoSine_Raw_150629_F2_C1_67.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150629_F3_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\tony\Raw_Data\150629\150629_F3_C1\PiezoStep_Raw_150629_F3_C1_1.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\150629\150629_F3_C1\PiezoSine_Raw_150629_F3_C1_1.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'MLA 0.5uM Cd 200uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\150629\150629_F3_C1\PiezoStep_Raw_150629_F3_C1_25.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\150629\150629_F3_C1\PiezoSine_Raw_150629_F3_C1_67.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150701_F1_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\tony\Raw_Data\150701\150701_F1_C1\PiezoStep_Raw_150701_F1_C1_7.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\150701\150701_F1_C1\PiezoSine_Raw_150701_F1_C1_12.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'MLA 0.5uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\150701\150701_F1_C1\PiezoStep_Raw_150701_F1_C1_55.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\150701\150701_F1_C1\PiezoSine_Raw_150701_F1_C1_144.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'151015_F2_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151015\151015_F2_C1\PiezoStep_Raw_151015_F2_C1_6.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151015\151015_F2_C1\PiezoSine_Raw_151015_F2_C1_1.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'Curare 50 uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\151015\151015_F2_C1\PiezoStep_Raw_151015_F2_C1_150.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\151015\151015_F2_C1\PiezoSine_Raw_151015_F2_C1_81.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'151103_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoStepTrial_IClamp = ...
        'C:\Users\tony\Raw_Data\151103\151103_F3_C1\PiezoStep_Raw_151103_F3_C1_1.mat';
    analysis_cell(cnt).PiezoSineTrial_IClamp = ...
        'C:\Users\tony\Raw_Data\151103\151103_F3_C1\PiezoSine_Raw_151103_F3_C1_8.mat';
    
    % --------------- MLA ------------------
    analysis_cell(cnt).Drug = 'Curare 50 uM';
    analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
        'C:\Users\tony\Raw_Data\151103\151103_F3_C1\PiezoStep_Raw_151103_F3_C1_193.mat';
    analysis_cell(cnt).PiezoSineTrial_IClamp_Drug = ...
        'C:\Users\tony\Raw_Data\151103\151103_F3_C1\PiezoSine_Raw_151103_F3_C1_252.mat';
end

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'151106_F1_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C1\PiezoStep_Raw_151106_F1_C1_7.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C1\PiezoSine_Raw_151106_F1_C1_16.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'Curare 50 uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C1\PiezoStep_Raw_151106_F1_C1_109.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp_Drug = ...
'C:\Users\tony\Raw_Data\151106\151106_F1_C1\PiezoSine_Raw_151106_F1_C1_180.mat';

% %% 'pJFRC7;VT27938/TM6b'
% 
% cnt = find(strcmp(analysis_cells,'150326_F1_C1'));
% analysis_cell(cnt).PiezoStepTrial_IClamp = ...
% 'C:\Users\tony\Raw_Data\150326\150326_F1_C1\PiezoStep_Raw_150326_F1_C1_6.mat';
% 
% % --------------- Cd ------------------
% analysis_cell(cnt).Drug = 'Cd 200 uM';
% analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
% 'C:\Users\tony\Raw_Data\150326\150326_F1_C1\PiezoStep_Raw_150326_F1_C1_78.mat';
% 
% %% 'pJFRC7;VT27938/TM6b'
% 
% cnt = find(strcmp(analysis_cells,'150402_F1_C1'));
% analysis_cell(cnt).PiezoStepTrial_IClamp = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F1_C1\PiezoStep_Raw_150402_F1_C1_6.mat';
% 
% % --------------- Cd ------------------
% analysis_cell(cnt).Drug = 'Cd 200 uM';
% analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F1_C1\PiezoStep_Raw_150402_F1_C1_54.mat';
% 
% %% 'pJFRC7;VT27938/TM6b'
% 
% cnt = find(strcmp(analysis_cells,'150402_F2_C1'));
% analysis_cell(cnt).PiezoStepTrial_IClamp = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F2_C1\PiezoStep_Raw_150402_F2_C1_6.mat';
% 
% % --------------- MLA ------------------
% analysis_cell(cnt).Drug = 'MLA 0.5 uM';
% analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F2_C1\PiezoStep_Raw_150402_F2_C1_54.mat';
% 
% %% 'pJFRC7;VT27938/TM6b'
% 
% cnt = find(strcmp(analysis_cells,'150402_F3_C2'));
% analysis_cell(cnt).PiezoStepTrial_IClamp = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F3_C2\PiezoStep_Raw_150402_F3_C2_1.mat';
% 
% % --------------- MLA ------------------
% analysis_cell(cnt).Drug = 'MLA 0.5 uM';
% analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
% 'C:\Users\tony\Raw_Data\150402\150402_F3_C2\PiezoStep_Raw_150402_F3_C2_25.mat';

% analysis_cells = {...
% '150629_F1_C1'
% '150629_F2_C1'
% '150629_F3_C1'
% '150701_F1_C1'
% 
% % other female examples
% % '150326_F1_C1'
% % '150402_F1_C1'
% % '150402_F2_C1'
% % '150402_F3_C2'
% };
% 
% 
% 
% analysis_cells_comment = {...   
% '';
% '';
% '';
% '';
% 
% % females
% % 'Cd and TTX, Cd appeared ineffectual'
% % 'Cd 200mM.  Cd was followed by MLA, according to notes. Not clear though'
% % 'MLA first, then TTX, as expected, saw small reduction'
% % 'MLA .5 uM, TTX, slight reduction.'
% };
% 
% analysis_cells_genotype = {...
%     'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';
%     'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';
%     'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';
%     'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';
% 
%     % females
% %     'pJFRC7;VT27938/TM6b'
% %     'pJFRC7;VT27938/TM6b'
% %     'pJFRC7;VT27938/TM6b'
% %     'pJFRC7;VT27938/TM6b'
%     };
% 
% clear analysis_cell
% for c = 1:length(analysis_cells)
%     analysis_cell(c).name = analysis_cells(c); 
%     analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
%     analysis_cell(c).comment = analysis_cells_comment(c);
% end
