analysis_cells = {...
'150602_F3_C1' % Non shak b example
'150602_F3_C2'
'150625_F2_C1' % cross with shakB males
};

analysis_cells_comment = {...   
'';
'';
'Nice cell, no drugs here, though'
};

analysis_cells_genotype = {...
    'y;pJFRC7/[CyO];45D07-Gal4/+';
    'y;pJFRC7/[CyO];45D07-Gal4/+';
    'ShakB2-y/X;pJFRC7/Sp;45D07-Gal4/+';
};

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150602_F3_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\PiezoStep_Raw_150602_F3_C1_12.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150602_F3_C2'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C2\PiezoStep_Raw_150602_F3_C2_31.mat';

%% 'ShakB2/y;pJFRC7/Sp;45D07-Gal4/+'

cnt = find(strcmp(analysis_cells,'150625_F2_C1'));
analysis_cell(cnt).PiezoStepTrial_IClamp = ...
'C:\Users\Anthony Azevedo\Raw_Data\150625\150625_F2_C1\PiezoStep_Raw_150625_F2_C1_3.mat';
