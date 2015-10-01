% Record_SynapticTransmission

analysis_cells = {...
'150326_F1_C1'
'150402_F1_C1'
'150402_F2_C1'
'150402_F3_C2'
'150602_F2_C1'
};

analysis_cells_comment = {...
'Cd and TTX, Cd appeared ineffectual'
'Cd 200mM.  Cd was followed by MLA, according to notes. Not clear though'
'MLA first, then TTX, as expected, saw small reduction'
'MLA .5 uM, TTX, slight reduction.'
'MLA .5 uM, slight reduction.'
};

analysis_cells_genotype = {...
'pJFRC7;VT27938/TM6b'
'pJFRC7;VT27938/TM6b'
'pJFRC7;VT27938/TM6b'
'pJFRC7;VT27938/TM6b'
'10XUAS-GFP;FruGal4'
};

%%
clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c);
    analysis_cell(c).genotype = analysis_cells_genotype(c);
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%%

cnt = find(strcmp(analysis_cells,'150326_F1_C1'));
% Cd first, then TTX.  Control is Cd
analysis_cell(cnt).CdTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_109.mat';
analysis_cell(cnt).ControlTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';

%%

cnt = find(strcmp(analysis_cells,'150402_F1_C1'));
% Cd first, then TTX.  Control is Cd
analysis_cell(cnt).CdMLATrial = 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\PiezoSine_Raw_150402_F1_C1_217.mat';
analysis_cell(cnt).CdTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\PiezoSine_Raw_150402_F1_C1_109.mat';   
analysis_cell(cnt).ControlTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150402\150402_F1_C1\PiezoSine_Raw_150402_F1_C1_1.mat';

