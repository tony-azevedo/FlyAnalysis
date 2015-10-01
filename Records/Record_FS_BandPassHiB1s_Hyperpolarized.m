%% Record of Low Frequency Responsive Cells

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_FS_BandPassHighB1s_hyperpolarized';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1
id = 'BPH_Hyp_';


%%

analysis_cells = {...
'150531_F1_C1'
};

analysis_cells_comment = {...
    'Without perfusion, Very nice cell, tall spikes, also has hyperpolarized responses'
};

analysis_cells_genotype = {...
'10X-UAS;Fru-Gal4';
};


clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%% 'Genotype'

cnt = find(strcmp(analysis_cells,''));
analysis_cell(cnt).PiezoSineTrial = ...
'';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'';

