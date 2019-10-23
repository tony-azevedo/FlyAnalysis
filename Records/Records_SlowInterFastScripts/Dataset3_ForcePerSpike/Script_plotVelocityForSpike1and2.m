%% If you want to plot the speeds
cellIDs_1 = T_singleSpikes.CellID;
cellIDs_2 = T_doubleSpikes.CellID;
for cidx = 1:length(cellIDs)
    cellid = cellIDs{cidx};
    T_cell_1 = T_singleSpikes(contains(cellIDs_1,cellid),:);
    T_cell_2 = T_doubleSpikes(contains(cellIDs_2,cellid),:);
    [~,a,b] = intersect(T_cell_1.Position,T_cell_2.Position);
    if strcmp(T_cell_1.Cell_label,'fast')
        errorbar(compax_F,...
            T_cell_1.Peak(a),T_cell_2.Peak(b),...
            T_cell_2.PeakErr(b),T_cell_2.PeakErr(b),...
            T_cell_1.PeakErr(a),T_cell_1.PeakErr(a),...
            'Tag',cellid,'Color',[0 0 0],'marker','.','linestyle','none','capsize',0)
    elseif strcmp(T_cell_1.Cell_label,'intermediate')
        errorbar(compax_I,...
            T_cell_1.Peak(a),T_cell_2.Peak(b),...
            T_cell_2.PeakErr(b),T_cell_2.PeakErr(b),...
            T_cell_1.PeakErr(a),T_cell_1.PeakErr(a),...
            'Tag',cellid,'Color',[0 0 0],'marker','.','linestyle','none','capsize',0)
    end
end
plot(compax_F,[0 120],[0 120],'color',[1 1 1]*.8);
plot(compax_F,[0 60],[0 120],'color',[1 1 1]*.8);
axis(compax_F,'square');
compax_F.TickDir = 'out';
compax_F.XLim = [-10 120];
compax_F.YLim = [-10 120];

plot(compax_I,[0 12],[0 12],'color',[1 1 1]*.8);
plot(compax_I,[0 6],[0 12],'color',[1 1 1]*.8);
axis(compax_I,'square');
compax_I.TickDir = 'out';
compax_I.XLim = [-1 12];
compax_I.YLim = [-1 12];

%% Scale the y-axis nicely
k = 0.2234; %N/m;
forceticks = [.1 1 10 40]/k;
ylabel(ax0,'Force (uN)')
ForcePerSpikeAx.YTick = forceticks;
ForcePerSpikeAx.YTickLabel = {'0.1' '1' '10' '40'};
ForcePerSpikeAx.YLim = [.1 180];
ForcePerSpikeAx.YMinorTick = 'off';
ForcePerSpikeAx.XMinorTick = 'off';

ForcePerSpikeAx.XTick = [1 10 60];
ForcePerSpikeAx.XTickLabel = {'1' '10' '60'};

forceticks = [-2 0]/k;

NoSpikeAx.YTick = forceticks;
NoSpikeAx.YTickLabel = {'-2' '0'};

NoSpikeAx.XLim = [-4 24];
NoSpikeAx.YLim = [-10 120];

%%
filename = 'ForcePerSpike';
export_fig(ForcePerSpikeFig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');