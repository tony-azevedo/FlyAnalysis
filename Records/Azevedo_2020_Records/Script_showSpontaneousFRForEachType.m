
T_RampAndStep_nodrugs = T_RampAndStep(T_RampAndStep.Position<Inf,:);
T_RmpStpSlow_FR_nodrugs = T_RmpStpSlowFR(T_RmpStpSlowFR.Position<Inf,:);

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

cell_labels = unique(T_RampAndStep_nodrugs.Cell_label);
cellids = unique(T_RampAndStep_nodrugs.CellID);
offsets = [-1 0 1];

% loop over {inter,fast}
for cell_label = {'fast','intermediate'}
    % loop over positions
    lblidx = contains(T_RmpStpSlow_FR_nodrugs.Cell_label,cell_label{1});
    clridx = strcmp(cell_labels,cell_label);
    offset = offsets(clridx);
    for cellid = cellids'
        cllidx = strcmp(T_RmpStpSlow_FR_nodrugs.CellID,cellid);

        offset_sig = offset+normrnd(0,.1);

        for position = 0
            % plot(ax,DX+T_Temp.Position/1000 + [0 0.04],[T_Temp.Peak T_Temp.Peak_return],'marker','.','Color',lightclrs(clridx,:));%,'LineStyle','none');
            plot(ax,offset_sig,0,'marker','.','Color',lightclrs(clridx,:));%,'LineStyle','none');
        end
    end
    celllbllines = findobj(ax,'color',lightclrs(clridx,:));
    Adapt_mat = nan(length(celllbllines),1);
    for l = 1:length(celllbllines)
        y_ = celllbllines(l).YData;
        Adapt_mat(l,:) = y_;%-mean(y_);
    end
    errorbar(ax,offset-.4,nanmedian(Adapt_mat,1),nanstd(Adapt_mat,1)/sqrt(sum(~isnan(Adapt_mat))),'marker','none','color',clrs(clridx,:));
end

% Plot peak of 150 ramp responses vs amplitude
wtidx = ~contains(T_RmpStpSlow_FR_nodrugs.Genotype,'78');%'iav-LexA');
dspidx = T_RmpStpSlow_FR_nodrugs.Displacement==-10;
spdidx = T_RmpStpSlow_FR_nodrugs.Speed==150;

cell_labels = unique(T_RampAndStep_nodrugs.Cell_label);
cellids = unique(T_RampAndStep_nodrugs.CellID);
offsets = [-1 0 1];

% loop over {slow}
for cell_label = {'slow'}
    % loop over positions
    lblidx = contains(T_RmpStpSlow_FR_nodrugs.Cell_label,cell_label{1});
    clridx = strcmp(cell_labels,cell_label);
    offset = offsets(3);
    for cellid = cellids'
        cllidx = strcmp(T_RmpStpSlow_FR_nodrugs.CellID,cellid);
        
        for position = 0
            
            posidx = T_RmpStpSlow_FR_nodrugs.Position==position;

            rowsidx = wtidx & lblidx & dspidx & spdidx & cllidx & posidx;
            if ~sum(rowsidx)
                continue
            end
            T_Temp = T_RmpStpSlow_FR_nodrugs(rowsidx,:);
            
            offset_sig = offset+normrnd(0,.1);

            % plot(ax,DX+T_Temp.Position/1000 + [0 0.04],[T_Temp.Peak T_Temp.Peak_return],'marker','.','Color',lightclrs(clridx,:));%,'LineStyle','none');
            plot(ax,offset_sig,T_Temp.Rest,'marker','.','Color',lightclrs(clridx,:));%,'LineStyle','none');
        end
    end
    celllbllines = findobj(ax,'color',lightclrs(clridx,:));
    Adapt_mat = nan(length(celllbllines),1);
    for l = 1:length(celllbllines)
        y_ = celllbllines(l).YData;
        Adapt_mat(l,:) = y_;%-mean(y_);
    end
    errorbar(ax,offset-.4,nanmedian(Adapt_mat,1),nanstd(Adapt_mat,1)/sqrt(sum(~isnan(Adapt_mat))),'marker','.','color',clrs(clridx,:));
end

ylabel(ax,'V_m (mV)')
ax.XTick = offsets;
ax.XTickLabel = {'fast','intermediate','fast'};
ax.XLim = [-1.5 1.5];
