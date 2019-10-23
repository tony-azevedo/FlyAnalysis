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
    
    plot(ax,T_cell.Step,T_cell.FiringRate-T_cell.Rest,'Tag',cellid,'Marker','.')
end

%% Firing rate vs Voltage change

ax = subplot(3,1,2,'parent',ForceVsFRFig); ax.NextPlot = 'add';

xlabel(ax,'\Delta V_m');
ylabel(ax,'Firing Rate (Hz)');

cellids = unique(T_FvsFiringRate_0.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
    
    plot(ax,T_cell.DV_m,T_cell.FiringRate-T_cell.Rest,'Tag',cellid,'Marker','.')
end

% %% Force vs Current Step
% ax = subplot(3,1,2,'parent',ForceVsFRFig); ax.NextPlot = 'add';
% ylabel(ax,'pixels');
% xlabel(ax,'Current Step (pA)');
% 
% cellids = unique(T_FvsFiringRate_0.CellID);
% for cididx = 1:length(cellids)
%     cellid = cellids{cididx};
%     T_cell = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
%     
%     plot(ax,T_cell.Step,T_cell.Peak,'Tag',cellid,'Marker','.')
% end

%% Firing rate

ax = subplot(3,1,3,'parent',ForceVsFRFig); ax.NextPlot = 'add';
ylabel(ax,'pixels');
xlabel(ax,'\Delta Firing Rate (Hz)');

cellids = unique(T_FvsFiringRate_0.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
    
    plot(ax,T_cell.FiringRate-T_cell.Rest,T_cell.Peak,'Tag',cellid,'Marker','.')
end

fr = T_FvsFiringRate_0.FiringRate-T_FvsFiringRate_0.Rest;
peak = T_FvsFiringRate_0.Peak(T_FvsFiringRate_0.Step>13);
n_up = fr(T_FvsFiringRate_0.Step>13); % number of spikes is firing rate *stim dur

m_relationship = nlinfit(n_up,peak,@linethrough0,.1);

plot(ax,[min(n_up),max(n_up)],m_relationship*([min(n_up),max(n_up)]),'k');
text(ax,100,-2,sprintf('m = %.3f pixels/Hz',m_relationship),'HorizontalAlignment','right');




