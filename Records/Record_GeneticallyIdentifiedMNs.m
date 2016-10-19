analysis_grid = {...

% before video or anything else

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
