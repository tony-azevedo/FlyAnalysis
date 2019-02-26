
clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

ampVsPosF = figure;
ampVsPosF.Position = [680 80 1177 898];
panl = panel(ampVsPosF);
panl.pack('v',{1/6 1/6 1/6 1/6 2/6});
panl.margin = [18 10 10 10];
panl.fontname = 'Arial';

L = 419.9858; %um, approximate length of lever arm
positions = [-150 -75 0 75 150];
deg = [-10 -3 -1 1 3 10]' * 6;
th = asin(deg/L);
deg = th/(2*pi)*360;
th = asin(positions/L);
positions = th/(2*pi)*360;

gapratio = 2;
xtick = repmat(deg,1,5)./gapratio+repmat(positions,length(deg),1);
xticklabels = num2str(repmat(round(deg),6,1));

for a = 1:4
    ax = panl(a).select(); hold(ax,'on');
    plot(ax,max(xtick(:))*[-1 1],[0 0],'color',[1 1 1]*.8)
    ax.XTick = xtick(:);
    ax.XTickLabel = {};
    ax.XTickLabelRotation = 45;
    ax.TickDir = 'out';
end
ax.XTickLabel = xticklabels;

panl(2).ylabel('PSP peak (mV)');
panl(4).ylabel('\DeltaFR (Hz)');
panl(4).xlabel(' (degrees)');
panl(5).margintop = 20;

% ax = panl(4).select(); hold(ax,'on');

T_Step_noIav = T_Step(~contains(T_Step.Genotype,'iav-LexA'),:);
cids = unique(T_Step_noIav.CellID);
clbls = unique(T_Step_noIav.Cell_label);

for cidx = 1:length(cids)    
   
    idx = strcmp(T_Step_noIav.CellID,cids{cidx});
    typ = find(strcmp(clbls,T_Step_noIav.Cell_label{find(idx,1)}));
    ax = panl(typ).select(); hold(ax,'on'); %#ok<FNDSB>
    
    positions = T_Step_noIav.Positions{find(idx,1)};
    if length(positions)==1
        continue
    end
    cell_y = nan(size(positions));
    cell_x = positions;
    for pos = positions
        posidx = idx & T_Step_noIav.Position == pos;
        if ~sum(posidx)
            fprintf('%s is missing data for position %d\n',cids{cidx},pos);
            continue
        end
        x = T_Step_noIav.Displacement(posidx) *6; % 6um/V, speed in V/sec, 
        y = T_Step_noIav.Peak(posidx);
        %y = y.*-sign(x);
                    
        [x,o] = sort(x);
        y = y(o);

        th = x/L;
        deg = th/(2*pi)*360;
        
        clr = clrs(strcmp(clbls,T_Step_noIav.Cell_label{find(posidx,1)}),:);
        ltclr = lightclrs(strcmp(clbls,T_Step_noIav.Cell_label{find(posidx,1)}),:);
        plot(ax,deg/gapratio+asin(pos/L)/(2*pi)*360,y,'color',clr,'marker','.','tag',cids{cidx});

        step10atposidx = posidx & T_Step_noIav.Displacement==-10;
        if sum(step10atposidx)
            % cell_x(pos == positions) = pos;
            cell_y(pos == positions) = nanmean(T_Step_noIav.Peak(step10atposidx));
        end
    end
    if typ~=3
        ax = panl(5).select(); hold(ax,'on');
        plot(ax,cell_x,cell_y/max(cell_y),'color',ltclr,'marker','.','tag',['type' num2str(typ)],'linestyle','none');
    end
end

% Plot firing rate of 35C09 neurons
T_StpSlowFR_noIav = T_StpSlowFR(~contains(T_StpSlowFR.Genotype,'iav-LexA'),:);
cids = unique(T_StpSlowFR_noIav.CellID);
%clbls = unique(SlowRampRows.Cell_label);

for cidx = 1:length(cids)    
   
    idx = strcmp(T_StpSlowFR_noIav.CellID,cids{cidx});
    typ = find(strcmp(clbls,T_StpSlowFR_noIav.Cell_label{find(idx,1)}));
    ax = panl(4).select(); hold(ax,'on'); %#ok<FNDSB>
    
    positions = T_StpSlowFR_noIav.Positions{find(idx,1)};
    if length(positions)==1
        continue
    end
    cell_y = nan(size(positions));
    cell_x = positions;
    for pos = positions
        posidx = idx & T_StpSlowFR_noIav.Position == pos;
        if ~sum(posidx)
            fprintf('%s is missing data for position %d\n',cids{cidx},pos);
            continue
        end
        x = T_StpSlowFR_noIav.Displacement(posidx) *6; % 6um/V, speed in V/sec, 
        y = T_StpSlowFR_noIav.Peak(posidx)-T_StpSlowFR_noIav.Rest(posidx);
        %y = y.*-sign(x);
                    
        [x,o] = sort(x);
        y = y(o);

        th = asin(x/L);
        deg = th/(2*pi)*360;
        
        clr = clrs(strcmp(clbls,T_StpSlowFR_noIav.Cell_label{find(posidx,1)}),:);
        ltclr = lightclrs(strcmp(clbls,T_StpSlowFR_noIav.Cell_label{find(posidx,1)}),:);
        plot(ax,deg/gapratio+asin(pos/L)/(2*pi)*360,y,'color',clr,'marker','.','tag',cids{cidx});
        
        step10atposidx = posidx & T_StpSlowFR_noIav.Displacement==-10;
        if sum(step10atposidx)
            % cell_x(pos == positions) = pos;
            cell_y(pos == positions) = nanmean(T_StpSlowFR_noIav.Peak(step10atposidx)-T_StpSlowFR_noIav.Rest(step10atposidx));
        end
    end
    ax = panl(5).select(); hold(ax,'on');
    plot(ax,cell_x,cell_y/max(cell_y),'color',ltclr,'marker','.','tag',['type' num2str(3)]);%,'linestyle','none');
end

% Plot normalized peaks
ax = panl(5).select(); hold(ax,'on');
for typ = 1:length(clbls)
    lns = findobj(ax,'type','line','tag',['type' num2str(typ)]);
    xs = lns(1).XData;
    ys = nan(length(lns),length(xs));
    for ln = 1:length(lns)
        if length(lns(ln).YData)==length(xs)
            ys(ln,:) = lns(ln).YData;
        else
            [~,idx] = intersect(xs,lns(ln).XData);
            ys(ln,idx) = lns(ln).YData;
        end
    end
    plot(ax,xs,nanmean(ys,1),'color',clrs(typ,:),'marker','.','tag',['type' num2str(typ)],'linewidth',2,'markersize',10);
end

ax.XLim = [-200 200];
ax.YLim = [-.1 1.1];
ax.XTick = xs;

% angle calculation based on Methods_LegMeasurements
tl = {};
for pos = positions
    tl{pos==positions} = num2str(round(asind(pos/L)*10)/10);
end
ax.XTickLabel = tl;
xlabel(ax,'Leg Angle (Degrees)');

