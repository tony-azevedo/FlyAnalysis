close all
examplefig = figure('color',[1 1 1],'units','inches','position',[4 1 9 9]);

panl = panel(examplefig);
panl.pack('h',{1/3 1/3 1/3})  % phase plot on top
panl.margin = [18 16 10 10];
panl.descendants.margin = [8 8 8 8];

ofinterest = {
    '190527_F1_C1'
    '181118_F1_C1' % 28, 22
    '180628_F2_C1' % 1,2,3, 4, 5!, and then 7 or 9 for free movement
    };

T_fast = T_SM(contains(T_SM.CellID,ofinterest{1}) & T_SM.bar_good,:);
T_inter = T_SM(contains(T_SM.CellID,ofinterest{2}) & T_SM.bar_good,:);
T_slow = T_SM(contains(T_SM.CellID,ofinterest{3}) & T_SM.bar_good,:);

% 190227_F1_C1
% T_fast.bar_trialnums = [18 20];
% T_fast.no_bar_trialnums = [31];
% T_fast.xstarts = [2.3 2.5];

% 190527_F1_C1
T_fast.bar_trialnums = [71 57]; % 70 (2) 82 85 65(2) 63(2) 57(-.05) 71 (1.25 or 1)
T_fast.no_bar_trialnums = [1];
T_fast.xstarts = [1 -0.05];

T_inter.bar_trialnums = [22 28];
T_inter.no_bar_trialnums = [2];
T_inter.xstarts = [ .2 .5 ];

T_slow.bar_trialnums = [5 3];
T_slow.no_bar_trialnums = [7];
T_slow.xstarts = [ 0 -.1];

T_lbl = [T_fast;T_inter;T_slow];

for lbl = 1:3

    panl(lbl).pack('v',{1/3 1/3 1/3})  % phase plot at left
    cellid = T_lbl.CellID{lbl};
    Dir = fullfile('E:\Data',cellid(1:6),cellid);
    cd(Dir);
    trialStem = [T_lbl.Protocol{lbl} '_Raw_' cellid '_%d.mat'];
    nobargroup = T_lbl.no_bar_trialnums(lbl);
    bargroup = T_lbl.bar_trialnums(lbl,:);

    %% no bar
    if lbl<3
        panl(lbl,1).pack('v',{2/5 1/5 2/5});
        ax1 = panl(lbl,1,1).select(); ax1.XTick = []; ax1.Visible = 'off';
        ax3 = panl(lbl,1,3).select(); ax3.Visible = 'off';
    elseif lbl==3
        panl(lbl,1).pack('v',{2/5 1/5 2/5});
        ax1 = panl(lbl,1,1).select(); ax1.TickDir = 'out'; %ax1.Visible = 'off'; 
        ax2 = panl(lbl,1,2).select(); ax2.TickDir = 'out'; %ax2.Visible = 'off';
        ax3 = panl(lbl,1,3).select(); ax3.TickDir = 'out';
    end
    
    nobartrial = load(fullfile(Dir,sprintf(trialStem,nobargroup(1))));
    
    t = makeInTime(nobartrial.params); t = t(:);
    ft = makeFrameTime(nobartrial);
    
    plot(ax1,t,nobartrial.voltage_1);
    raster(ax1,t(nobartrial.spikes),[-18 -14]);
    
    if lbl==2
        plot(ax3,ft,nobartrial.legPositions.Tibia_Angle);
    elseif lbl==3
        plot(ax2,t,nobartrial.current_2);
        plot(ax3,ft,nobartrial.legPositions.Tibia_Angle);
    end
    ax1.YLim = [-60 -14];
    ax3.YLim = [10 125];

    if lbl==1
        ax1.Visible = 'on'; ax1.TickDir = 'out';
        ax3.Visible = 'on'; ax3.TickDir = 'out';
    end
    
    %% bar trial 1
    panl(lbl,2).pack('v',{2/5 1/5 2/5});
    ax1 = panl(lbl,2,1).select(); ax1.XTick = []; ax1.Visible = 'off'; ax1.NextPlot = 'add';
    ax2 = panl(lbl,2,2).select(); ax2.Visible = 'off'; ax2.NextPlot = 'add';
    ax3 = panl(lbl,2,3).select(); ax3.XTick = []; ax3.Visible = 'off'; ax3.NextPlot = 'add';
    
    bartrial = load(fullfile(Dir,sprintf(trialStem,bargroup(1))));
    
    t = makeInTime(bartrial.params); t = t(:);
    ft = makeFrameTime(bartrial);
    
    plot(ax1,t,bartrial.voltage_1);
    raster(ax1,t(bartrial.spikes),[-18 -14]);
    
    plot(ax2,t,bartrial.current_2); 
    scl = 10^(floor(log10(diff([min(bartrial.current_2) max(bartrial.current_2)]))));
    plot(ax2,T_lbl.xstarts(lbl,1)*[1 1]+.1,[-1 0]*scl,'linewidth',3,'color',[0 0 0]);
    text(ax2,T_lbl.xstarts(lbl,1)+.2,0,num2str(scl));
    
    plot(ax3,ft,bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce);
    plot(ax3,[ft(1) ft(end)],[0 0],'color',[.8 .8 .8]);
    
    if lbl==1
        ax1.Visible = 'on'; ax1.TickDir = 'out';
        %ax2.Visible = 'on';
        ax3.Visible = 'on'; ax3.TickDir = 'out';
    end
    ax1.YLim = [-60 -14];
    ylims2 = ax2.YLim;
    ax3.YLim = [-5 300];

    set([ax1,ax2,ax3],'XLim',T_lbl.xstarts(lbl,1) + [0 2]);
    
    %% bar trial 2
    panl(lbl,3).pack('v',{2/5 1/5 2/5});
    ax1 = panl(lbl,3,1).select(); ax1.XTick = []; ax1.Visible = 'off'; ax1.NextPlot = 'add';
    ax2 = panl(lbl,3,2).select(); ax2.Visible = 'off'; ax2.NextPlot = 'add';
    ax3 = panl(lbl,3,3).select(); ax3.Visible = 'off'; ax3.NextPlot = 'add';
    
    bartrial = load(fullfile(Dir,sprintf(trialStem,bargroup(2))));
    
    t = makeInTime(bartrial.params); t = t(:);
    ft = makeFrameTime(bartrial);
    
    plot(ax1,t,bartrial.voltage_1);
    raster(ax1,t(bartrial.spikes),[-18 -14]);

    plot(ax2,t,bartrial.current_2); 
    scl = 10^(floor(log10(diff([min(bartrial.current_2) max(bartrial.current_2)]))));
    plot(ax2,T_lbl.xstarts(lbl,2)*[1 1]+.1,[-1 0]*scl,'linewidth',3,'color',[0 0 0]);
    text(ax2,T_lbl.xstarts(lbl,2)+.2,0,num2str(scl));
    
    plot(ax3,ft,bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce);
    plot(ax3,[ft(1) ft(end)],[0 0],'color',[.8 .8 .8]);

    ax1.YLim = [-60 -14];
    ax2.YLim = ylims2;
    ax3.YLim = [-5 300];

    if lbl==1
        ax1.Visible = 'on'; ax1.TickDir = 'out';
        %ax2.Visible = 'on';
        ax3.Visible = 'on'; ax3.TickDir = 'out';
    end
    
    set([ax1,ax2,ax3],'XLim',T_lbl.xstarts(lbl,2) + [0 2]);

end