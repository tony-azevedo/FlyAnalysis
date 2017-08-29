analysis_grid = {...
% Calcium imaging in the leg
'170314_F1_C1'  'MHC-Gal4;Td-tom/20XUAS-GCaMP6f'      '2X, dim'
}


bummerreject_grid = {...
% EMG
'161116_F1_C2'  '' 'Early example. Nice units, but Im not sure its really movement and stuff';
'170222_F1_C1'  '' 'No exposure!! Great signals though. Entered with right electrode, parallel to leg' 
'170224_F1_C1'  ''      'no exposure again! there are videos those'


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

%%