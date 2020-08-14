%% Plot Force vs Firing rate for slow neurons
close all
ForceVsFRFig = figure; ForceVsFRFig.Position = [680    54   560   924];

%% Firing rate vs Current Step

ax = subplot(3,1,1,'parent',ForceVsFRFig); ax.NextPlot = 'add';

xlabel(ax,'Current Step (pA)');
ylabel(ax,'Firing Rate (Hz)');

cellids = unique(T_FvsFiringRate_0.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
    %-T_cell.Rest
    plot(ax,T_cell.Step,T_cell.FiringRate,'Tag',cellid,'color',[1 .7 1],'marker','.')
end

cellids = unique(T_FvsFiringRate_mla.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_mla(contains(T_FvsFiringRate_mla.CellID,cellid),:);
    % -T_cell.Rest
    plot(ax,T_cell.Step,T_cell.FiringRate,'Tag',cellid,'color',[1 0 1]*.3,'marker','.')
end


%% Force vs Current Step
% ax = subplot(3,1,2,'parent',ForceVsFRFig); ax.NextPlot = 'add';
% ylabel(ax,'pixels');
% xlabel(ax,'Current Step (pA)');
% 
% cellids = unique(T_FvsFiringRate_0.CellID);
% for cididx = 1:length(cellids)
%     cellid = cellids{cididx};
%     T_cell = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
%     
%     plot(ax,T_cell.Step,T_cell.Peak,'Tag',cellid,'color',[1 .7 1],'marker','.')
% end
% 
% cellids = unique(T_FvsFiringRate_mla.CellID);
% for cididx = 1:length(cellids)
%     cellid = cellids{cididx};
%     T_cell = T_FvsFiringRate_mla(contains(T_FvsFiringRate_mla.CellID,cellid),:);
%     
%     plot(ax,T_cell.Step,T_cell.Peak,'Tag',cellid,'color',[1 0 1]*.3,'marker','.')
% end

%% OR 
%% Force vs Firing rate
ax = subplot(3,1,2,'parent',ForceVsFRFig); ax.NextPlot = 'add';
ylabel(ax,'pixels');
xlabel(ax,'\Delta Firing Rate (Hz)');

cellids = unique(T_FvsFiringRate_0.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
    
    plot(ax,T_cell.FiringRate-T_cell.Rest,T_cell.Peak,'Tag',cellid,'color',[1 .7 1],'marker','.')
end

cellids = unique(T_FvsFiringRate_mla.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_mla(contains(T_FvsFiringRate_mla.CellID,cellid),:);
    
    plot(ax,T_cell.FiringRate-T_cell.Rest,T_cell.Peak,'Tag',cellid,'color',[1 0 1]*.3,'marker','.')
end
ax.YLim = [-9.5 22.5]
%% Compare force at each step vs control for each cell
ax = subplot(3,4,9:11,'parent',ForceVsFRFig); ax.NextPlot = 'add';
ylabel(ax,'pixels_mla');
xlabel(ax,'pixels_0');

cellids_mla = unique(T_FvsFiringRate_mla.CellID);
for cididx = 1:length(cellids_mla)
    cellid = cellids_mla{cididx};
    T_cell_mla = T_FvsFiringRate_mla(contains(T_FvsFiringRate_mla.CellID,cellid),:);
    T_cell_0 = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
    
    [steps,idxmla,idxctr] = intersect(T_cell_mla.Step,T_cell_0.Step);
    
    %     for step = steps'
    %         mlaidx = T_cell_mla.Step==step;
    %         ctridx = T_cell_0.Step==step;
    %
    %         plot(ax,T_cell_0.Peak(ctridx),T_cell_mla.Peak(mlaidx),'Tag',cellid,'color',[1 0 1]*.3,'marker','.')
    %     end
    plot(ax,T_cell_0.Peak(idxctr),T_cell_mla.Peak(idxmla),'Tag',cellid,'color',[1 0 1]*.3,'marker','.')

end
axis(ax,'equal')
xlims = [min([T_FvsFiringRate_mla.Peak;T_FvsFiringRate_0.Peak]) max([T_FvsFiringRate_mla.Peak;T_FvsFiringRate_0.Peak])];
plot(ax,xlims,xlims,'color',[1 1 1]*.8)

%% Compare Resting spike rates
ax = subplot(3,4,12,'parent',ForceVsFRFig); ax.NextPlot = 'add';
ylabel(ax,'Resting FR (Hz)');

cellids_mla = unique(T_FvsFiringRate_mla.CellID);
for cididx = 1:length(cellids_mla)
    cellid = cellids_mla{cididx};
    T_cell_mla = T_FvsFiringRate_mla(contains(T_FvsFiringRate_mla.CellID,cellid),:);
    T_cell_0 = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
    
    % [steps,idxmla,idxctr] = intersect(T_cell_mla.Step,T_cell_0.Step);
    %     x = [T_cell_0.Rest(idxctr)*0-.5; T_cell_mla.Rest(idxmla)*0+.5];
    x = [-.5; .5];
    % plot(ax,x,[T_cell_0.Rest(idxctr); T_cell_mla.Rest(idxmla)],'Tag',cellid,'color',[1 0 1]*.3,'marker','.')
    plot(ax,x,[mean(T_cell_0.Rest), mean(T_cell_mla.Rest)],'Tag',cellid,'color',[1 0 1]*.3,'marker','.')
end

% Plotting the other cells for which there was no mla condition. This is a
% little confusing, the spike rate are lower 
% cellids_notmla = setdiff(unique(T_FvsFiringRate_0.CellID),unique(T_FvsFiringRate_mla.CellID));
% for cididx = 1:length(cellids_notmla)
%     cellid = cellids_notmla{cididx};
%     T_cell_0 = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
%     x = -.5;
%     % plot(ax,x,[T_cell_0.Rest(idxctr); T_cell_mla.Rest(idxmla)],'Tag',cellid,'color',[1 0 1]*.3,'marker','.')
%     plot(ax,x,mean(T_cell_0.Rest),'Tag',cellid,'color',[1 0 1]*.3,'marker','o')
% end
ax.XLim = [-.6 .6];
