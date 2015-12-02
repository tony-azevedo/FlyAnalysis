%% Record of Low Frequency Responsive Cells

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_FS_BandPassHighB1s_hyperpolarized';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1
id = 'BPH_Hyp_';


%%

analysis_grid = {...
'150531_F1_C1' '10X-UAS;Fru-Gal4'     'Without perfusion, Very nice cell, tall spikes, also has hyperpolarized responses'
'151125_F1_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'     'hyperpolarized responses'

'151130_F1_C1'  'pJFRC7/+;VT30609/+'     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolarized responses didnt work'
};

clear analysis_cell analysis_cells control_cells control_cells
genotypes = {   '10XUAS-mCD8:GFP/+;FruGal4/+'                           '20XUAS-mCD8:GFP;VT27938-Gal4';
                'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'        'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'
};

for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
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

