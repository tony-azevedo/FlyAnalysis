
positions = [-150 -75 0 75 150];
posInDeg = pos2deg(positions);
deg = pos2deg([-10 -3 -1 1 3 10]' * 6);
xlims = [-28 28];

fig = figure;
%fig.Position = [];
figure(fig);
set(fig,'color',[1 1 1])
panl = panel(fig);

vdivisions = [1 1 1]; vdivisions = num2cell(vdivisions/sum(vdivisions));
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

% Now do the firing rate for slow neurons
% Plot peak of 150 ramp responses vs amplitude
wtidx = ~contains(T_RmpStpSlowFR.Genotype,'iav-LexA');
dspidx = T_RmpStpSlowFR.Displacement==-10;
spdidx = T_RmpStpSlowFR.Speed==150;

cellids = unique(T_RmpStpSlowFR.CellID);
clridx = 3; %strcmp(cell_labels,'slow');
for cellid = cellids'
    cllidx = strcmp(T_RmpStpSlowFR.CellID,cellid);
    
    for position = positions
        
        posidx = T_RmpStpSlowFR.Position==position;
        
        rowsidx = wtidx & dspidx & spdidx & cllidx & posidx;
        if ~sum(rowsidx)
            continue
        end
        T_Temp = T_RmpStpSlowFR(rowsidx,:);
        
        DX = deg(end);
        % plot(ax,DX+T_Temp.Position/1000 + [0 0.04],[T_Temp.Peak T_Temp.Peak_return],'marker','.','Color',lightclrs(clridx,:));%,'LineStyle','none');
        plot(ax,[0 DX + [0 0.3]],[T_Temp.Rest T_Temp.Peak T_Temp.Peak_return],'marker','.','Color',lightclrs(clridx,:),'tag',[cellid{1} '_' num2str(position)]);%,'LineStyle','none');
    end
end
celllbllines = findobj(ax,'color',lightclrs(clridx,:));
Adapt_mat = nan(length(celllbllines),3);
for l = 1:length(celllbllines)
    y_ = celllbllines(l).YData;
    Adapt_mat(l,:) = y_;%-mean(y_);
end
plot(ax,[0 DX + [0 0.3]],nanmedian(Adapt_mat,1),'marker','.','color',clrs(clridx,:));


ylabel(ax,'\DeltaFR (Hz)')
% ax.XTick = positions_;
% ax.XTickLabel = num2str(positions_(:));
ax.XLim = xlims;

%% Panel 2
% First plot the firing rate for -8 degrees and 8 degrees
% ramps
% assume flextion steps (-10) start at 0 deg, extensions (+10V) start at 8 deg
ax = panl(2).select(); ax.NextPlot = 'add';

wtidx = ~contains(T_RmpStpSlowFR.Genotype,'iav-LexA');
dspidx = T_RmpStpSlowFR.Displacement==-10;
spdidx = T_RmpStpSlowFR.Speed==150;

cellids = unique(T_RmpStpSlowFR.CellID);
clridx = 3; %strcmp(cell_labels,'slow');
for cellid = cellids'
    cllidx = strcmp(T_RmpStpSlowFR.CellID,cellid);
    
    for displacement = [-10 10] % displacements
        dspidx = T_RmpStpSlowFR.Displacement==displacement;
        for speed = [0 100 150 300]
            spdidx = T_RmpStpSlowFR.Speed==speed;
            
            for position = positions
                
                posidx = T_RmpStpSlowFR.Position==position;
                
                rowsidx = wtidx & dspidx & spdidx & cllidx & posidx;
                if ~sum(rowsidx)
                    continue
                end
                T_Temp = T_RmpStpSlowFR(rowsidx,:);
                
                DX = deg(end)/2 * sign(displacement);
                % plot(ax,DX+T_Temp.Position/1000 + [0 0.04],[T_Temp.Peak T_Temp.Peak_return],'marker','.','Color',lightclrs(clridx,:));%,'LineStyle','none');
                plot(ax,pos2deg(T_Temp.Position)+DX,T_Temp.Rest,'marker','.','Color',lightclrs(clridx,:),'tag',[cellid{1} '_' num2str(position)]);%,'LineStyle','none');
            end
        end

    end
end
rest = 1:2;
pstn = 1:2;
for position = positions
    for displacement = [-10 10]
        DX = deg(end)/2 * sign(displacement);
        celllbllines = findobj(ax,'color',lightclrs(clridx,:),'XData',pos2deg(position)+DX);
        Rest_mat = nan(length(celllbllines),1);
        for l = 1:length(celllbllines)
            y_ = celllbllines(l).YData;
            Rest_mat(l) = y_;%-mean(y_);
        end
        rest((sign(displacement)+1)/2+1) = nanmedian(Rest_mat,1);%
        pstn((sign(displacement)+1)/2+1) = celllbllines(1).XData;
    end
    plot(ax,pstn,rest,'marker','.','color',clrs(clridx,:));
end
% plot the membrane potential at the start of a sweep and once the probe has
% crossed approximately the entire range of angles
ylabel(ax,'FR_{rest} (Hz)')
ax.XLim = xlims;


%% Panel 3
ax = panl(3).select(); ax.NextPlot = 'add';
% Plot resting membrane potential starting with second trial of a group
wtidx = ~contains(T_RmpStpSlowFR.Genotype,'iav-LexA');
dspidx = T_RmpStpSlowFR.Displacement==-10;
spdidx = T_RmpStpSlowFR.Speed==150;

cell_labels = unique(T_RmpStpSlowFR.Cell_label);
cellids = unique(T_RmpStpSlowFR.CellID);

% loop over positions
clridx = 3; %strcmp(cell_labels,'slow');
for cellid = cellids'
    cllidx = strcmp(T_RmpStpSlowFR.CellID,cellid);
    
    rowsidx = wtidx & dspidx & spdidx & cllidx;
    if sum(rowsidx)<3
        continue
    end
    T_Temp = T_RmpStpSlowFR(rowsidx,:);
    
    plot(ax,pos2deg(T_Temp.Position),T_Temp.Rest,'marker','.','Color',lightclrs(clridx,:),'LineStyle','none');
end
celllbllines = findobj(ax,'color',lightclrs(clridx,:));
Rest_mat = nan(length(celllbllines),length(posInDeg));
for l = 1:length(celllbllines)
    x_ = celllbllines(l).XData;
    y_ = celllbllines(l).YData;
    [~,x_idx] = intersect(posInDeg,x_);
    Rest_mat(l,x_idx) = y_;%-mean(y_);
    celllbllines(l).XData = x_;%+(find(clridx)-1)*1;
    celllbllines(l).YData = y_;-mean(y_);
end
plot(ax,posInDeg,nanmedian(Rest_mat,1),'marker','.','color',clrs(clridx,:));

ylabel(ax,'FR_{rest} (Hz)')
% ax.XTick = positions;
% ax.XTickLabel = num2str(positions_(:));
ax.XLim = xlims;

function deg = pos2deg(x)
L = 419.9858; %um, approximate length of lever arm
th = asin(x/L);
deg = th/(2*pi)*360;
end
