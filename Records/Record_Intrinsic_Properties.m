%% Intrinsic Properties Analysis

% 140512_F3_C1
% 140512_F2_C1
% 140512_F1_C1
% 140509_F3_C1
% 140509_F1_C1
% 140508_F2_C1
% 140508_F1_C2
% 140508_F1_C1
% 140506_F2_C2
% 140506_F1_C2
% 140506_F1_C1
% 140428_F1_C1
% 140424_F1_C1
% 140417_F1_C1
% 140403_F1_C1
% 140311_F1_C1
% 140131_F3_C1
% 131119_F2_C2


%% Cells that possibly should be excluded
exclude_cells = {
    '140512_F2_C1',  'Blew up the Wedge PNs, no change to the B1'
    };

%%
cnt = 1;
analysis_cell(cnt).name = {
    '140512_F3_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F3_C1\CurrentSine_Raw_140512_F3_C1_20.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F3_C1\CurrentStep_Raw_140512_F3_C1_40.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'Not the best recording.  A little shaky when hyperpolarized.';
    };

cnt = 1;
analysis_cell(cnt).name = {
    '131211_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F3_C1\CurrentSine_Raw_140512_F3_C1_20.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F3_C1\CurrentStep_Raw_140512_F3_C1_40.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'Not the best recording.  A little shaky when hyperpolarized.';
    };





