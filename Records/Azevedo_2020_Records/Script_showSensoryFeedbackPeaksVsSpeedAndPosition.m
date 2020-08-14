
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
xtick = repmat(dps,1,5)+repmat(positions,length(dps),1)*gapratio;
dps(1) = dps(1)*bringinstepspeedfactor;
dps(end) = dps(end)*bringinstepspeedfactor;
xticklabels = num2str(repmat(round(dps),6,1));
xticklabels = num2str(repmat(round(dps),6,1));

for a = 1:4
    ax = panl(a).select(); hold(ax,'on');
    plot(ax,[-180*gapratio 180*gapratio],[0 0],'color',[1 1 1]*.8)
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
T_RampAndStep_noIav = T_RampAndStep(~contains(T_RampAndStep.Genotype,'iav-LexA')&~(contains(T_RampAndStep.Genotype,'ChR')&contains(T_RampAndStep.Genotype,'81A07')),:);
cids = unique(T_RampAndStep_noIav.CellID);
clbls = unique(T_RampAndStep_noIav.Cell_label);

%%
for cidx = 1:length(cids)    
   
    idx = strcmp(T_RampAndStep_noIav.CellID,cids{cidx});
    typ = find(strcmp(clbls,T_RampAndStep_noIav.Cell_label{find(idx,1)}));
    ax = panl(typ).select(); hold(ax,'on'); %#ok<FNDSB>
    
    positions = T_RampAndStep_noIav.Positions{find(idx,1)};
%     if length(positions)==1
%         continue
%     end
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
        plot(ax,dps(~stepspeeds)+pos*gapratio,y(~stepspeeds),'color',clr,'marker','.','tag',cids{cidx});
        plot(ax,dps(stepspeeds)+pos*gapratio,y(stepspeeds),'linestyle','none','color',clr,'marker','.','tag',cids{cidx});
        
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
        plot(ax,dps(~stepspeeds)+pos*gapratio,y(~stepspeeds),'color',clr,'marker','.','tag',cids{cidx});
        plot(ax,dps(stepspeeds)+pos*gapratio,y(stepspeeds),'linestyle','none','color',clr,'marker','.','tag',cids{cidx});
        
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
    lns = findobj(ax,'type','line','tag',['type' num2str(typ)]); lns = flipud(lns);
    lnslgnth = nan(size(lns));
    for ln = 1:length(lns)
        lnslgnth(ln) = length(lns(ln).XData);
    end
    xs = lns(lnslgnth==max(lnslgnth)).XData;
    ys = nan(length(lns),length(xs));
    for ln = 1:length(lns)
        if length(lns(ln).YData)==length(xs)
            ys(ln,:) = lns(ln).YData;
        elseif length(lns(ln).YData)>1
            [~,idxa,idxb] = intersect(xs,lns(ln).XData);
            ys(ln,idxa) = lns(ln).YData;
        else
            continue
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

%% Plot just position 0
rampPos0 = figure;
rampPos0.Units = 'inches';
rampPos0.Position = [2 2 8 2];
panl0 = panel(rampPos0);
panl0.pack('h',{1/4 1/4 1/4 1/4});
panl0.margin = [18 10 10 10];
panl0.fontname = 'Arial';

for a = 1:4
    ax = panl(a).select(); hold(ax,'on');
    ax0 = panl0(a).select();
    ax0.Units = 'inches';
    ax0.Position = [0.5+(a-1)*2 0.2 1.6 1.7];
    ax0.TickDir = 'out';
    ax0.XTick = [-340 -200 -100 0 100 200 340];
    ax0.XTickLabel = {'' '-200' '-100' '0' '100' '200' ''};
    ax0.XLim = [-380 380];
    
    chs = ax.Children;
    for ch = 1:length(chs)
        if all(abs(chs(ch).XData)<370)
            copyobj(chs(ch),ax0);
        elseif all(abs(chs(ch).YData)==0)
            p = copyobj(chs(ch),ax0);
            p.XData = [-360 360];
        end
    end
    ax0.YLim = [-10 15];
end
ax0.YLim = [-110 130];

%% Stats from the last fig

steps = [];
stepsg = [];
ramps150 = [];
ramps150g = [];
for a = 1:3
    ax0 = panl0(a).select();
    chs = ax0.Children;
    for ch = 1:length(chs)
        c = chs(ch);
        if length(c.XData)>2
            [~,xidx] = min(abs(c.XData+11.16));
            ramps150 = cat(1,ramps150,c.YData(xidx));
            ramps150g = cat(1,ramps150g,a);
        elseif length(c.XData)==2
            if all(c.YData==0)
                continue
            end
            [~,xidx] = min(c.XData);
            steps = cat(1,steps,c.YData(xidx));
            stepsg = cat(1,stepsg,a);
        end
    end
end
ranksum(steps(stepsg==1),steps(stepsg==2))
ranksum(ramps150(ramps150g==1),ramps150(ramps150g==2))


% [P,ANOVATAB,STATS] = anovan(steps,stepsg);
% results = multcompare(STATS);
% 
% [P,ANOVATAB,STATS] = kruskalwallis(steps,stepsg);
% results = multcompare(STATS);
% % 
[P,ANOVATAB,STATS] = kruskalwallis(ramps150,ramps150g);
results = multcompare(STATS);

[P,ANOVATAB,STATS] = anovan(ramps150,ramps150g);
results = multcompare(STATS);
% [~,~,stats] = anovan(cavals,{clustnum extflx},'model','interaction',...
%     'varnames',{'clustnum','extflx'});
% 
% results = multcompare(stats,'Dimension',[2 1]);


    