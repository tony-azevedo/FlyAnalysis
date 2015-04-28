% Record_SynapticTransmission

analysis_cells = {...
'150326_F1_C1'
'150402_F1_C1'
'150402_F2_C1'
'150402_F3_C1'
'150402_F3_C2'
};

analysis_cells_comment = {...
'Low pass cell, Cd and TTX, Cd appeared ineffectual'
'OK cell, not great access.  I let it seal up a bit, the seal itself, was not that clean or fast.'
'Good cell, good electrode, great seal, eveything went well, not a lot of movement. Did MLA first, then TTX, as expected'
'Good cell, great reording, looking strong.  Nope.  The acces wasnt that great, then I tried to improve it and I blew it.  I need to keep getting that motion down.  Im struggling there, but it has to happen.'
'Good cell, no response for TTX, great, went through, fixing it too'
};

analysis_cells_genotype = {...
'pJFRC7;VT27938/TM6b'
'pJFRC7;VT27938/TM6b'
'pJFRC7;VT27938/TM6b'
'pJFRC7;VT27938/TM6b'
'pJFRC7;VT27938/TM6b'
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

