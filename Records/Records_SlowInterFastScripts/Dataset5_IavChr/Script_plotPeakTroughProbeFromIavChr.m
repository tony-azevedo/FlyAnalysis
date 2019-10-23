% close all

clrs = [0 0 0
    .7 0 .7
    0 .5 0];
lightclrs = [.5 .5 .5
    1 .6 1
    .4 1 .4 ];

%%
DEBUG = 0;

% CellIDs = unique(T_iavChrFlash.CellID);
CellIDs = T_iavChr.CellID;

fsfig = figure;
fsfig.Position = [680 32 689 964];


for cidx = 1:length(CellIDs)
    cellid = CellIDs{cidx};
    
    fprintf('Starting %s\n',cellid);
    
    T_cell = T_iavChrFlash(contains(T_iavChrFlash.CellID,cellid)&strcmp(T_iavChrFlash.Drug,''),:);
    
    clridx = strcmp({'fast','intermediate','slow'},T_cell.Cell_label{1});
    clr = clrs(clridx,:);
    ltclr = lightclrs(clridx,:);
    
%     ax = subplot(4,1,1,'parent',fsfig); ax.NextPlot = 'add';
%     %title(ax,regexprep(cellid,'\_','\\_'));
%     len = nan(size(T_cell.FlashStrength));
%     for r = 1:height(T_cell)
%         len(r) = length(T_cell.Trialnums{r});
%     end
%     plot(ax,T_cell.FlashStrength,len,'color',clr,'marker','.','tag',T_cell.CellID{1}); %,'color',[1 0 0]
%     %     plot(ax,T_cell.FlashStrength,T_cell.Trough_V,'color',ltclr,'marker','.','tag',T_cell.CellID{1}); %,'color',[1 0 0]
%     ylabel(ax,'V_m peak')
%     ax.XScale = 'log';

    ax = subplot(4,1,1,'parent',fsfig); ax.NextPlot = 'add';
    %title(ax,regexprep(cellid,'\_','\\_'));
    plot(ax,T_cell.FlashStrength,T_cell.Peak_V,'color',clr,'marker','.','tag',T_cell.CellID{1}); %,'color',[1 0 0]
    plot(ax,T_cell.FlashStrength,T_cell.Trough_V,'color',ltclr,'marker','.','tag',T_cell.CellID{1}); %,'color',[1 0 0]
    ylabel(ax,'V_m peak')
    ax.XScale = 'log';
    
    ax = subplot(4,1,2,'parent',fsfig); ax.NextPlot = 'add';
    plot(ax,T_cell.FlashStrength,T_cell.Peak_FR,'color',clr,'marker','.','tag',T_cell.CellID{1}); % ,'color',[0 0 1]
    plot(ax,T_cell.FlashStrength,T_cell.Trough_FR,'color',ltclr,'marker','.','tag',T_cell.CellID{1}); % ,'color',[0 0 1]
    ylabel(ax,'Fr Rate')
    ax.XScale = 'log';
    
    ax = subplot(4,1,3,'parent',fsfig); ax.NextPlot = 'add';
    plot(ax,T_cell.FlashStrength,T_cell.Peak_probe,'color',clr,'marker','.','tag',T_cell.CellID{1}); % ,'color',[0 0 1]
    plot(ax,T_cell.FlashStrength,T_cell.Trough_probe,'color',ltclr,'marker','.','tag',T_cell.CellID{1}); % ,'color',[0 0 1]
    ylabel(ax,'ProbeMovement')
    ax.XScale = 'log';
    
    ax = subplot(4,1,4,'parent',fsfig); ax.NextPlot = 'add';
    plot(ax,T_cell.FlashStrength,T_cell.ReleaseDuration,'color',clr,'marker','.','tag',T_cell.CellID{1}); % ,'color',[0 0 1]
    ylabel(ax,'Release duration')
    ax.XScale = 'log';
    
    drawnow
    figure(fsfig)
    %pause
end

axs = fsfig.Children;
linkaxes(axs(:)','x');
axs(1).XLim = [3E-6 1];


