%% Record of Low Frequency Responsive Cells

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_FS_BandPassLoB1s_hyperpolarized';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1
id = 'BPL_Hyp_';


%%

analysis_grid = {...
'151208_F2_C1'   '20XUAS-mCD8:GFP;VT27938-Gal4';     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolarized responses didnt work'
'151209_F1_C3'   '20XUAS-mCD8:GFP;VT27938-Gal4';     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolarized responses didnt work'
'151209_F2_C1'   '20XUAS-mCD8:GFP;VT27938-Gal4';     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolarized responses didnt work'
'151209_F2_C2'   '20XUAS-mCD8:GFP;VT27938-Gal4';     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolarized responses didnt work'
'151209_F2_C3'   '20XUAS-mCD8:GFP;VT27938-Gal4';     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolarized responses didnt work'
};
% LOW PASS '151209_F1_C1'
% LOW PASS '151209_F1_C2'

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

