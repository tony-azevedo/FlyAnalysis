
T_RampAndStep_nodrugs = T_RampAndStep(T_RampAndStep.Position<Inf,:);

fig = figure;
%fig.Position = [];
figure(fig);
set(fig,'color',[1 1 1])
panl = panel(fig);

vdivisions = [1]; vdivisions = num2cell(vdivisions/sum(vdivisions));
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
ax = panl(1).select(); ax.NextPlot = 'add';

% Plot peak of 150 ramp responses vs amplitude
wtidx = ~contains(T_RampAndStep_nodrugs.Genotype,'78');%'iav-LexA');
dspidx = T_RampAndStep_nodrugs.Displacement==-10;
spdidx = T_RampAndStep_nodrugs.Speed==150;

cell_labels = unique(T_RampAndStep_nodrugs.Cell_label);
cellids = unique(T_RampAndStep_nodrugs.CellID);
offsets = [-1 0 1];

X_all = [];
Gs = [];

% loop over {slow,inter,fast}
lblcnt = 0;
for cell_label = cell_labels'
    % loop over positions
    lblcnt = lblcnt+1;
    lblidx = contains(T_RampAndStep_nodrugs.Cell_label,cell_label{1});
    clridx = strcmp(cell_labels,cell_label);
    offset = offsets(clridx);
    for cellid = cellids'
        cllidx = strcmp(T_RampAndStep_nodrugs.CellID,cellid);
        
        for position = 0
            
            posidx = T_RampAndStep_nodrugs.Position==position;

            rowsidx = wtidx & lblidx & dspidx & spdidx & cllidx & posidx;
            if ~sum(rowsidx)
                continue
            end
            T_Temp = T_RampAndStep_nodrugs(rowsidx,:);
            
            offset_sig = offset+normrnd(0,.1);
            plot(ax,offset_sig,T_Temp.V_m,'marker','.','Color',lightclrs(clridx,:));%,'LineStyle','none');
        end
    end
    celllbllines = findobj(ax,'color',lightclrs(clridx,:));
    Adapt_mat = nan(length(celllbllines),1);
    for l = 1:length(celllbllines)
        y_ = celllbllines(l).YData;
        Adapt_mat(l,:) = y_;%-mean(y_);
    end
    X_all = cat(1,X_all,Adapt_mat);
    Gs = cat(1,Gs,Adapt_mat*0+lblcnt);
    errorbar(ax,offset-.4,nanmedian(Adapt_mat,1),nanstd(Adapt_mat,1)/sqrt(sum(~isnan(Adapt_mat))),'marker','.','color',clrs(clridx,:));
end

ylabel(ax,'V_m (mV)')
ax.XTick = offsets;
ax.XTickLabel = {'fast','intermediate','fast'};
ax.XLim = [-1.5 1.5];

% Compare
figure
[P,T,stats] = anovan(X_all,Gs);
results = multcompare(stats);


