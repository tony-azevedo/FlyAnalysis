%% Plotting the average twitches for single and double spikes
% Calculating onset speed, slope, etc. Set

TwitchVPositionFig = figure;
ax = subplot(2,1,1); ax.NextPlot = 'add';
compax_F = subplot(2,2,3); compax_F.NextPlot = 'add';
compax_I = subplot(2,2,4); compax_I.NextPlot = 'add';

% T_singleSpikes = T_FperSpike_0(T_FperSpike_0.NumSpikes==1,:);
% T_doubleSpikes = T_FperSpike_0(T_FperSpike_0.NumSpikes==2,:);
% 
% L = 419.9858; %um, approximate length of lever arm
% position_est = [-150 -75 0 75 150];
% th = asin(position_est/L);
% positions = th/(2*pi)*360;
% 
% 
% estdst = abs(T_singleSpikes.Position-repmat([-150 -75 0 75 150],height(T_singleSpikes),1));
% [mn,estidx] = min(estdst,[],2);
% T_singleSpikes.Position = position_est(estidx)';
% 
% estdst = abs(T_doubleSpikes.Position-repmat([-150 -75 0 75 150],height(T_doubleSpikes),1));
% [mn,estidx] = min(estdst,[],2);
% T_doubleSpikes.Position = position_est(estidx)';
% 
% 
% cellIDs = T_doubleSpikes.CellID;
% for cidx = 1:length(cellIDs)
%     cellid = cellIDs{cidx};
%     T_cell = T_doubleSpikes(contains(cellIDs,cellid),:);
%     plot(ax,T_cell.Position,T_cell.Peak,'Tag',cellid,'Color',[1 1 1]*.8,'marker','.');
% end
% 
% cellIDs = T_singleSpikes.CellID;
% for cidx = 1:length(cellIDs)
%     cellid = cellIDs{cidx};
%     T_cell = T_singleSpikes(contains(cellIDs,cellid),:);
%     plot(ax,T_cell.Position,T_cell.Peak,'Tag',cellid,'Color',[0 0 0],'marker','.');
% end
% 
% ax.XLim = [-160 160];
% ax.XTick = position_est;
% 
% axticklabel = cell(size(positions'));
% axticklabel(:) = cellstr(num2str(round(positions')));
% ax.XTickLabel = axticklabel';
% ylabel(ax,'twitch')
% xlabel(ax,'degrees')

%%

hexclrs = [
    '3C489E'
    'D64C90'
    'F9A61A'
    '00FF00'
    '47DDFF'
    '03AC72'
];
clrs = hex2rgb(hexclrs);

T_singleSpikes = T_FperSpike_0(T_FperSpike_0.NumSpikes==1&T_FperSpike_0.Position==0,:);
T_doubleSpikes = T_FperSpike_0(T_FperSpike_0.NumSpikes==2&T_FperSpike_0.Position==0,:);

cellIDs_1 = T_singleSpikes.CellID;
cellIDs_2 = T_doubleSpikes.CellID;
for cidx = 1:length(cellIDs)
    cellid = cellIDs{cidx};
    T_cell_1 = T_singleSpikes(contains(cellIDs_1,cellid),:);
    T_cell_2 = T_doubleSpikes(contains(cellIDs_2,cellid),:);
    [~,a,b] = intersect(T_cell_1.Position,T_cell_2.Position);
    if strcmp(T_cell_1.Cell_label,'fast')
        %         errorbar(compax_F,...
        %             T_cell_1.Peak(a),T_cell_2.Peak(b),...
        %             T_cell_2.PeakErr(b),T_cell_2.PeakErr(b),...
        %             T_cell_1.PeakErr(a),T_cell_1.PeakErr(a),...
        %             'Tag',cellid,'Color',[0 0 0],'marker','.','linestyle','none','capsize',0)
        plot(compax_F,...
            T_cell_1.Peak(a),T_cell_2.Peak(b),...
            'Tag',cellid,'Color',clrs(1,:),'marker','.','linestyle','none')
    elseif strcmp(T_cell_1.Cell_label,'intermediate')
%         errorbar(compax_I,...
%             T_cell_1.Peak(a),T_cell_2.Peak(b),...
%             T_cell_2.PeakErr(b),T_cell_2.PeakErr(b),...
%             T_cell_1.PeakErr(a),T_cell_1.PeakErr(a),...
%             'Tag',cellid,'Color',[0 0 0],'marker','.','linestyle','none','capsize',0)
        plot(compax_I,...
            T_cell_1.Peak(a),T_cell_2.Peak(b),...
            'Tag',cellid,'Color',clrs(2,:),'marker','.','linestyle','none')
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
