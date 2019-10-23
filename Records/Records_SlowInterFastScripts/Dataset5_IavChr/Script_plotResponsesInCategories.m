

%% comparison plot

DEBUG = 0;

% CellIDs = unique(T_iavChrFlash.CellID);
CellIDs = T_iavChr.CellID;

VvsPfig = figure;
VvsPfig.Position = [680 32 689 964];

ms = 10

for cidx = 1:length(CellIDs)
    cellid = CellIDs{cidx};
    
    
    T_cell = T_iavChrFlash(contains(T_iavChrFlash.CellID,cellid)&strcmp(T_iavChrFlash.Drug,''),:);
    
    clridx = strcmp({'fast','intermediate','slow'},T_cell.Cell_label{1});
    clr = clrs(clridx,:);
    ltclr = lightclrs(clridx,:);
    
    ax1 = subplot(2,1,1,'parent',VvsPfig); ax1.NextPlot = 'add';
    %title(ax,regexprep(cellid,'\_','\\_'));
    if find(clridx)<3
        plot(ax1,T_cell.Trough_probe,T_cell.Peak_V,'color',clr,'marker','o','markersize',4,'tag',T_cell.CellID{1})
        plot(ax1,T_cell.Start_probe,T_cell.Peak_V,'color',ltclr,'marker','o','markersize',4,'tag',T_cell.CellID{1})
    elseif find(clridx)==3
        plot(ax1,T_cell.Trough_probe,T_cell.Trough_V,'color',clr,'marker','o','markersize',4,'tag',T_cell.CellID{1}); %,'color',[1 0 0]
        plot(ax1,T_cell.Start_probe,T_cell.Peak_V,'color',ltclr,'marker','o','markersize',4,'tag',T_cell.CellID{1})
    end
    
    ax2 = subplot(2,2,3,'parent',VvsPfig); ax2.NextPlot = 'add';
    for row = 1:height(T_cell)
        if T_cell.Trough_probe(row) <3 %um
            if find(clridx)<3
                plot(ax2,T_cell.Trough_probe(row),T_cell.Peak_V(row),'color',clr,'marker','.','markersize',ms,'tag',[T_cell.CellID{1} sprintf(' - %.2e',T_cell.FlashStrength(row))])
            elseif find(clridx)==3
                plot(ax2,T_cell.Trough_probe(row),T_cell.Trough_V(row),'color',clr,'marker','.','markersize',ms,'tag',[T_cell.CellID{1} sprintf(' - %.2e',T_cell.FlashStrength(row))])
            end
        end
    end
    ax3 = subplot(2,2,4,'parent',VvsPfig); ax3.NextPlot = 'add';
    for row = 1:height(T_cell)
        if isnan(T_cell.Trough_probe(row)) %um
            %            plot(ax3,T_cell.Peak_probe(row)-T_cell.Start_probe(row),T_cell.Peak_V(row),'color',clr,'marker','.','markersize',ms,'tag',[T_cell.CellID{1} sprintf(' - %.2e',T_cell.FlashStrength(row))],'UserData',T_cell.Trialnums{row})
            if find(clridx)<3
                plot(ax3,T_cell.Start_probe(row),T_cell.Peak_V(row),'color',clr,'marker','.','markersize',ms,'tag',[T_cell.CellID{1} sprintf(' - %.2e',T_cell.FlashStrength(row))],'UserData',T_cell.Trialnums{row})
            elseif find(clridx)==3
                amp = abs([T_cell.Peak_V(row) T_cell.Trough_V(row)]);
                maxidx = max(amp);
                plot(ax3,T_cell.Start_probe(row),maxidx,'color',clr,'marker','.','markersize',ms,'tag',[T_cell.CellID{1} sprintf(' - %.2e',T_cell.FlashStrength(row))])
            end
            
        end
    end

    drawnow
    figure(VvsPfig)
    %pause
end
%ylabel(ax,'V_m peak')

% axs = fsfig.Children;
% linkaxes(axs(:)','x');
% axs(1).XLim = [3E-6 1];
