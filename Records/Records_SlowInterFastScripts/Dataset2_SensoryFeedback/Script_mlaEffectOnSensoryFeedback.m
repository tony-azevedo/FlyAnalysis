
fig = figure;
%fig.Position = [];
figure(fig);
set(fig,'color',[1 1 1])
panl = panel(fig);

vdivisions = [1 1]; vdivisions = num2cell(vdivisions/sum(vdivisions));
panl.pack('v',vdivisions)  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

% panel 1
axPeak = panl(1).select(); axPeak.NextPlot = 'add';
axVm = panl(2).select(); axVm.NextPlot = 'add';

% Plot peak of 150 ramp responses vs amplitude
wtidx = ~contains(T_RampAndStep.Genotype,'iav-LexA');
cellhasmlaidx = logical(T_RampAndStep.mla);
cellids = unique(T_RampAndStep.CellID(cellhasmlaidx));

dspidx = T_RampAndStep.Displacement==-10;
posidx = T_RampAndStep.Position==0 | T_RampAndStep.Position==Inf;
mlaidx = logical(T_RampAndStep.mla);

cell_labels = unique(T_RampAndStep.Cell_label);
offsets = [-1 0 1];

speeds = unique(T_RampAndStep.Speed); speeds = speeds(speeds<400);

% loop over {slow,inter,fast}
for cell_label = cell_labels'
    % loop over positions
    lblidx = contains(T_RampAndStep.Cell_label,cell_label{1});
    clridx = find(strcmp(cell_labels,cell_label));
    offset = offsets(clridx);
    for cellid = cellids'
        cllidx = strcmp(T_RampAndStep.CellID,cellid);
        
        for speed = speeds'
            
            spdidx = T_RampAndStep.Speed==speed;

            rowsidx = wtidx & lblidx & dspidx & spdidx & cllidx & posidx;
            if sum(rowsidx)<2
                continue
            end
            Row_ctrl = T_RampAndStep(rowsidx & ~mlaidx,:);
            Row_mla = T_RampAndStep(rowsidx & mlaidx,:);
            plot(axPeak,Row_ctrl.Speed + [-20 20]+clridx*350,[Row_ctrl.Peak Row_mla.Peak],'marker','.','Color',clrs(clridx,:));%,'LineStyle','none');

            plot(axVm,clridx + [-.33 .33],[Row_ctrl.V_m Row_mla.V_m],'marker','.','Color',clrs(clridx,:),'tag',cellid{1});%,'LineStyle','none');
        end
    end
end
axPeak.XTick = repmat([50 100 150 300],1,3) + [1 1 1 1 2 2 2 2 3 3 3 3]*350;
axPeak.XTickLabel = {'50' '100' '150' '300' '50' '100' '150' '300' '50' '100' '150' '300'};
axVm.XTick = [1 2 3];
axVm.XTickLabel = {'fast' 'intermediate' 'slow'};
