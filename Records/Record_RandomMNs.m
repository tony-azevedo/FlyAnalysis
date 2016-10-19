analysis_grid = {...

% before video or anything else
'160518_F1_C1'      'Mi{}-Vglut-Gal4/+;pJFRC7'      'Fast Spontaneously spking'
'160518_F1_C2'      'Mi{}-Vglut-Gal4/+;pJFRC7'      'spiking with current injection, change in state?'
'160520_F1_C1'      'Mi{}-Vglut-Gal4/+;pJFRC7'      'Nice spiking cell, this was early on'
'160520_F2_C1'      'Mi{}-Vglut-Gal4/+;pJFRC7'      'Spontaneously spking, some motor neurons can look like this'
'160622_F1_C1'      '89C10-Gal4/20XUAS-mCD8:GFP'    'Interneuron? Non-green. Huge spikes Posterior cortex'
'160622_F1_C2'      '89C10-Gal4/20XUAS-mCD8:GFP'    'Interneuron? Non-green.'
'160622_F1_C2'      '89C10-Gal4/20XUAS-mCD8:GFP'    'Green Cell. HOLY MAMA SPIKES!'

% Totally random
'160720_F1_C2'      '22H10-Gal4/20XUAS-mCD8:GFP'    'spontaneously active, wonderful cell, beautiful spikes, no movement'
'160720_F1_C3'      '22H10-Gal4/20XUAS-mCD8:GFP'    'right next to green cell, maybe some spikes? Big startle artefact'
'160721_F3_C1'      '81A07-Gal4/20XUAS-mCD8:GFP'    'Spiking flexor, video evidence, current plateau with no spikes'
'160722_F3_C3'      '22H10-Gal4/20XUAS-mCD8:GFP'    'startle artifact, spiking but not much from current injection, have to go really high'
'160729_F1_C1'      '22H10-Gal4/20XUAS-mCD8:GFP'    'startle artifact'

% Random but useful
'160909_F2_C1'      'Mi{}-Vglut-Gal4/+;pJFRC7'      'Nice tibia MN, controls Tarsus motion'

}

clear analysis_cell analysis_cells
% analysis_grid = cesiumPara_grid
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end
genotypes = analysis_grid(:,2);
[genotype_set,~,genotype_idx] = unique(genotypes);


%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,''));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageSine = ...
        '';
    analysis_cell(cnt).trials.Sweep = ...
        '';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA'};
    
    analysis_cell(cnt).trials.CurrentChirp = ...
        '';
    analysis_cell(cnt).trials.VoltageStep = ...
        '';
    analysis_cell(cnt).trials.VoltageStep_Drugs = {
        '';
        };
    analysis_cell(cnt).VSdrugs = ...
        '';
end
