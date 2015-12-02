% Controls without drugs

analysis_grid = {...
'150602_F3_C1' 'y;pJFRC7/[CyO];45D07-Gal4/+'	''
'150602_F3_C2' 'y;pJFRC7/[CyO];45D07-Gal4/+'	''
'150625_F2_C1' 'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+' 'Nice cell, no drugs here, though'
};

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150602_F3_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\PiezoStep_Raw_150602_F3_C1_12.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\PiezoSine_Raw_150602_F3_C1_1.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150602_F3_C2'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C2\PiezoStep_Raw_150602_F3_C2_31.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C2\PiezoSine_Raw_150602_F3_C2_1.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150625_F2_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150625\150625_F2_C1\PiezoStep_Raw_150625_F2_C1_3.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150625\150625_F2_C1\PiezoSine_Raw_150625_F2_C1_1.mat';

