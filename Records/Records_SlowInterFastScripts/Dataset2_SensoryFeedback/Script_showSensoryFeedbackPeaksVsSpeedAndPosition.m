
clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

rampVsPosF = figure;
rampVsPosF.Position = [680 80 1177 898];
panl = panel(rampVsPosF);
panl.pack('v',{1/6 1/6 1/6 1/6 2/6});
panl.margin = [18 10 10 10];
panl.fontname = 'Arial';

positions = [-150 -75 0 75 150];
bringinstepspeedfactor = 5;
dps = [-1700/bringinstepspeedfactor
  -245.5616
  -122.7808
  -40.9269
  40.9269
  122.7808
  245.5616
  1700/bringinstepspeedfactor];
gapratio = 11;
xtick = repmat(dps,1,5)/gapratio+repmat(positions,length(dps),1);
dps(1) = dps(1)*bringinstepspeedfactor;
dps(end) = dps(end)*bringinstepspeedfactor;
xticklabels = num2str(repmat(round(dps),6,1));
xticklabels = num2str(repmat(round(dps),6,1));

for a = 1:4
    ax = panl(a).select(); hold(ax,'on');
    plot(ax,[-180 180],[0 0],'color',[1 1 1]*.8)
    ax.XTick = xtick(:);
    ax.XTickLabel = {};
    ax.XTickLabelRotation = 45;
    ax.TickDir = 'out';
end
ax.XTickLabel = xticklabels;

panl(2).ylabel('PSP peak (mV)');
panl(4).ylabel('\DeltaFR (Hz)');
panl(4).xlabel('Angular velocity (degree/s)');
panl(5).margintop = 20;

% ax = panl(4).select(); hold(ax,'on');

L = 419.9858; %um, approximate length of lever arm
T_RampAndStep_noIav = T_RampAndStep(~contains(T_RampAndStep.Genotype,'iav-LexA'),:);
cids = unique(T_RampAndStep_noIav.CellID);
clbls = unique(T_RampAndStep_noIav.Cell_label);

for cidx = 1:length(cids)    
   
    idx = strcmp(T_RampAndStep_noIav.CellID,cids{cidx});
    typ = find(strcmp(clbls,T_RampAndStep_noIav.Cell_label{find(idx,1)}));
    ax = panl(typ).select(); hold(ax,'on'); %#ok<FNDSB>
    
    positions = T_RampAndStep_noIav.Positions{find(idx,1)};
    if length(positions)==1
        continue
    end
    cell_y = nan(size(positions));
    cell_x = positions;
    for pos = positions
        posidx = idx & T_RampAndStep_noIav.Position == pos;
        if ~sum(posidx)
            fprintf('%s is missing data for position %d\n',cids{cidx},pos);
            continue
        end
        x = T_RampAndStep_noIav.Speed(posidx) .* sign(T_RampAndStep_noIav.Displacement(posidx)) *6; % 6um/V, speed in V/sec, 
        y = T_RampAndStep_noIav.Peak(posidx);
        %y = y.*-sign(x);
                    
        [x,o] = sort(x);
        y = y(o);

        w = x/L;
        dps = w/(2*pi)*360;
        stepspeeds = abs(dps)>300;
        dps(stepspeeds) = dps(stepspeeds)/bringinstepspeedfactor;

        clr = clrs(strcmp(clbls,T_RampAndStep_noIav.Cell_label{find(posidx,1)}),:);
        ltclr = lightclrs(strcmp(clbls,T_RampAndStep_noIav.Cell_label{find(posidx,1)}),:);
        plot(ax,dps(~stepspeeds)/gapratio+pos,y(~stepspeeds),'color',clr,'marker','.','tag',cids{cidx});
        plot(ax,dps(stepspeeds)/gapratio+pos,y(stepspeeds),'linestyle','none','color',clr,'marker','.','tag',cids{cidx});
        
        step10atposidx = posidx & T_RampAndStep_noIav.Displacement==-10;
        if sum(step10atposidx)
            % cell_x(pos == positions) = pos;
            cell_y(pos == positions) = nanmean(T_RampAndStep_noIav.Peak(step10atposidx));
        end
    end
    if typ~=3
        ax = panl(5).select(); hold(ax,'on');
        plot(ax,cell_x,cell_y/max(cell_y),'color',ltclr,'marker','.','tag',['type' num2str(typ)],'linestyle','none');
    end
end

%% Plot firing rate of 35C09 neurons
T_RmpStpSlowFR_noIav = T_RmpStpSlowFR(~contains(T_RmpStpSlowFR.Genotype,'iav-LexA'),:);

cids = unique(T_RmpStpSlowFR_noIav.CellID);
%clbls = unique(SlowRampRows.Cell_label);

for cidx = 1:length(cids)    
   
    idx = strcmp(T_RmpStpSlowFR_noIav.CellID,cids{cidx});
    typ = find(strcmp(clbls,T_RmpStpSlowFR_noIav.Cell_label{find(idx,1)}));
    ax = panl(4).select(); hold(ax,'on'); %#ok<FNDSB>
    
    positions = T_RmpStpSlowFR_noIav.Positions{find(idx,1)};
    if length(positions)==1
        continue
    end
    cell_y = nan(size(positions));
    cell_x = positions;
    for pos = positions
        posidx = idx & T_RmpStpSlowFR_noIav.Position == pos;
        if ~sum(posidx)
            fprintf('%s is missing data for position %d\n',cids{cidx},pos);
            continue
        end
        x = T_RmpStpSlowFR_noIav.Speed(posidx) .* sign(T_RmpStpSlowFR_noIav.Displacement(posidx)) *6; % 6um/V, speed in V/sec, 
        y = T_RmpStpSlowFR_noIav.Peak(posidx)-T_RmpStpSlowFR_noIav.Rest(posidx);
        %y = y.*-sign(x);
                    
        [x,o] = sort(x);
        y = y(o);

        w = x/L;
        dps = w/(2*pi)*360;
        stepspeeds = abs(dps)>300;
        dps(stepspeeds) = dps(stepspeeds)/bringinstepspeedfactor;

        clr = clrs(strcmp(clbls,T_RmpStpSlowFR_noIav.Cell_label{find(posidx,1)}),:);
        ltclr = lightclrs(strcmp(clbls,T_RmpStpSlowFR_noIav.Cell_label{find(posidx,1)}),:);
        plot(ax,dps(~stepspeeds)/gapratio+pos,y(~stepspeeds),'color',clr,'marker','.','tag',cids{cidx});
        plot(ax,dps(stepspeeds)/gapratio+pos,y(stepspeeds),'linestyle','none','color',clr,'marker','.','tag',cids{cidx});
        
        step10atposidx = posidx & T_RmpStpSlowFR_noIav.Displacement==-10;
        if sum(step10atposidx)
            % cell_x(pos == positions) = pos;
            cell_y(pos == positions) = nanmean(T_RmpStpSlowFR_noIav.Peak(step10atposidx));
        end
    end
    ax = panl(5).select(); hold(ax,'on');
    plot(ax,cell_x,cell_y/max(cell_y),'color',ltclr,'marker','.','tag',['type' num2str(3)],'linestyle','none');
end

%% Plot normalized peaks
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
    errorbar(ax,xs,nanmean(ys,1),nanstd(ys,1)./sqrt(sum(~isnan(ys),1)),'color',clrs(typ,:),'marker','.','tag',['type' num2str(typ)],'linewidth',2,'markersize',10);
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

