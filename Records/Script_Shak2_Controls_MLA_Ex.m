%% ShakB controls MLA
analysis_cells = {...
'150629_F1_C1'
'150629_F2_C1'
'150629_F3_C1'
'150701_F1_C1'

% other female examples
% '150326_F1_C1'
% '150402_F1_C1'
% '150402_F2_C1'
% '150402_F3_C2'
};

analysis_cells_comment = {...   
'';
'';
'';
'';

% females
% 'Cd and TTX, Cd appeared ineffectual'
% 'Cd 200mM.  Cd was followed by MLA, according to notes. Not clear though'
% 'MLA first, then TTX, as expected, saw small reduction'
% 'MLA .5 uM, TTX, slight reduction.'
};

analysis_cells_genotype = {...
    'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';
    'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';
    'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';
    'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';

    % females
%     'pJFRC7;VT27938/TM6b'
%     'pJFRC7;VT27938/TM6b'
%     'pJFRC7;VT27938/TM6b'
%     'pJFRC7;VT27938/TM6b'
    };

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150629_F1_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150629\150629_F1_C1\PiezoStep_Raw_150629_F1_C1_26.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'MLA 0.5 uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\Anthony Azevedo\Raw_Data\150629\150629_F1_C1\PiezoStep_Raw_150629_F1_C1_50.mat'; % 'C:\Users\Anthony Azevedo\Raw_Data\150629\150629_F1_C1\PiezoStep_Raw_150629_F1_C1_98.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150629_F2_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150629\150629_F2_C1\PiezoStep_Raw_150629_F2_C1_5.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'MLA 0.5uM Cd 200uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\Anthony Azevedo\Raw_Data\150629\150629_F2_C1\PiezoStep_Raw_150629_F2_C1_30.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150629_F3_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150629\150629_F3_C1\PiezoStep_Raw_150629_F3_C1_1.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'MLA 0.5uM Cd 200uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\Anthony Azevedo\Raw_Data\150629\150629_F3_C1\PiezoStep_Raw_150629_F3_C1_25.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150701_F1_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150701\150701_F1_C1\PiezoStep_Raw_150701_F1_C1_7.mat';

% --------------- MLA ------------------
analysis_cell(cnt).Drug = 'MLA 0.5uM';
analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
'C:\Users\Anthony Azevedo\Raw_Data\150701\150701_F1_C1\PiezoStep_Raw_150701_F1_C1_55.mat';


% %% 'pJFRC7;VT27938/TM6b'
% 
% cnt = find(strcmp(analysis_cells,'150326_F1_C1'));
% analysis_cell(cnt).PiezoStepTrial_IClamp = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoStep_Raw_150326_F1_C1_6.mat';
% 
% % --------------- Cd ------------------
% analysis_cell(cnt).Drug = 'Cd 200 uM';
% analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoStep_Raw_150326_F1_C1_78.mat';
% 
% %% 'pJFRC7;VT27938/TM6b'
% 
% cnt = find(strcmp(analysis_cells,'150402_F1_C1'));
% analysis_cell(cnt).PiezoStepTrial_IClamp = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\PiezoStep_Raw_150402_F1_C1_6.mat';
% 
% % --------------- Cd ------------------
% analysis_cell(cnt).Drug = 'Cd 200 uM';
% analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\PiezoStep_Raw_150402_F1_C1_54.mat';
% 
% %% 'pJFRC7;VT27938/TM6b'
% 
% cnt = find(strcmp(analysis_cells,'150402_F2_C1'));
% analysis_cell(cnt).PiezoStepTrial_IClamp = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\PiezoStep_Raw_150402_F2_C1_6.mat';
% 
% % --------------- MLA ------------------
% analysis_cell(cnt).Drug = 'MLA 0.5 uM';
% analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F2_C1\PiezoStep_Raw_150402_F2_C1_54.mat';
% 
% %% 'pJFRC7;VT27938/TM6b'
% 
% cnt = find(strcmp(analysis_cells,'150402_F3_C2'));
% analysis_cell(cnt).PiezoStepTrial_IClamp = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C2\PiezoStep_Raw_150402_F3_C2_1.mat';
% 
% % --------------- MLA ------------------
% analysis_cell(cnt).Drug = 'MLA 0.5 uM';
% analysis_cell(cnt).PiezoStepTrial_IClamp_Drug = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F3_C2\PiezoStep_Raw_150402_F3_C2_25.mat';


