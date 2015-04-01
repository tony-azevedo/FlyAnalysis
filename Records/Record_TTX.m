% Record_TTX

%% Checklist

analysis_cells = {...
'150326_F1_C1'
};

analysis_cells_comment = {...
'Low pass cell, Cd and TTX, Cd appeared ineffectual'
};

analysis_cells_genotype = {...
};

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c);
    analysis_cell(c).genotype = analysis_cells_genotype(c);
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%%
cnt = find(strcmp(analysis_cells,'150205_F2_C1'));
% Cd first, then TTX.  Control is Cd
analysis_cell(cnt).ControlTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).TTXTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F2_C1\PiezoChirp_Raw_150205_F2_C1_11.mat';
analysis_cell(cnt).ExtraControlTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';

%%