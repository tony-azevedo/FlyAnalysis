close all
examplefig = figure('color',[1 1 1],'units','inches','position',[4 1 9 9]);

panl = panel(examplefig);
panl.pack('h',{1/3 1/3 1/3})  % phase plot on top
panl.margin = [18 16 10 10];
panl.descendants.margin = [8 8 8 8];

ofinterest = {
    %     '190227_F1_C1'    
    '190527_F1_C1'
    '181118_F1_C1' % 28, 22
    '180628_F2_C1' % 1,2,3, 4, 5!, and then 7 or 9 for free movement
    };

T_fast = T_SM(contains(T_SM.CellID,ofinterest{1}) & T_SM.bar_good,:);
T_inter = T_SM(contains(T_SM.CellID,ofinterest{2}) & T_SM.bar_good,:);
T_slow = T_SM(contains(T_SM.CellID,ofinterest{3}) & T_SM.bar_good,:);

% T_fast.bar_trialnums = [18 20];
T_fast.bar_trialnums = [71 57]; % 70 (2) 82 85 65(2) 63(2) 57(-.05) 71 (1.25)
T_fast.xstarts = [1 -0.05];
% T_fast.no_bar_trialnums = [31];
% T_fast.xstarts = [2.3 2.5];
T_fast.Trajectories = {
%     [
%     20      4.096       4.096+.3
%     20      2.772       2.772+.27
%     18      3.78       3.78+.3
%     ]
    [
    71      1.9       1.9+.3
    57      0.12       0.12+.3
    57      0.758       0.758+.3
    ]
    };


T_inter.bar_trialnums = [22 28];
T_inter.no_bar_trialnums = [2];
T_inter.xstarts = [ .2 .5 ];
T_inter.Trajectories = {
    [
    28       1.6        1.6+.3
    22       0.5571     0.5571+.3
    22       1.343      1.343+.3
    ]
    };

T_slow.bar_trialnums = [5 3];
T_slow.no_bar_trialnums = [7];
T_slow.xstarts = [ 0 -.1];
T_slow.Trajectories = {
    [
%     3       0.742       0.742+.3
    5       1.638       1.638+.3
    5       1.16        1.16+.4
    5       0.48-.3     0.48
    ]
    };

T_lbl = [T_fast;T_inter;T_slow];

ubins = linspace(-10,370,24);
vbins = linspace(-6000,6000,40);

uctrs = ubins(1:end-1)+diff(ubins(1:2)/2);
vctrs = vbins(1:end-1)+diff(vbins(1:2)/2);

%%
for lbl = 1:3

    panl(lbl).pack('v',{1/3 1/3 1/3})  % phase plot at left
    cellid = T_lbl.CellID{lbl};
    Dir = fullfile('E:\Data',cellid(1:6),cellid);
    cd(Dir);
    trialStem = [T_lbl.Protocol{lbl} '_Raw_' cellid '_%d.mat'];
    bargroup = T_lbl.bar_trialnums(lbl,:);

    %% bar trial 1
    panl(lbl,2).pack('v',{2/5 1/5 2/5});
    ax1 = panl(lbl,2,3).select(); ax1.Visible = 'off'; ax1.NextPlot = 'add';
    
    bartrial = load(fullfile(Dir,sprintf(trialStem,bargroup(1))));
    
    t = makeInTime(bartrial.params); t = t(:);
    ft = makeFrameTime(bartrial);
    
    plot(ax1,ft,bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce);
    plot(ax1,[ft(1) ft(end)],[0 0],'color',[.8 .8 .8]);

    ax1.YLim = [-5 300];

%     if lbl==1
%         ax1.Visible = 'on'; ax1.TickDir = 'out';
%         %ax2.Visible = 'on';
%         ax3.Visible = 'on'; ax3.TickDir = 'out';
%     end
    
    set([ax1],'XLim',T_lbl.xstarts(lbl,1) + [0 2]);
    
    clrs = ax1.ColorOrder;
    
    %% bar trial 2
    panl(lbl,3).pack('v',{2/5 1/5 2/5});
    ax2 = panl(lbl,3,3).select(); ax2.Visible = 'off'; ax2.NextPlot = 'add';
    
    bartrial = load(fullfile(Dir,sprintf(trialStem,bargroup(2))));
    
    t = makeInTime(bartrial.params); t = t(:);
    ft = makeFrameTime(bartrial);
    
    plot(ax2,ft,bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce);
    plot(ax2,[ft(1) ft(end)],[0 0],'color',[.8 .8 .8]);

    ax2.YLim = [-5 300];

%     if lbl==1
%         ax1.Visible = 'on'; ax1.TickDir = 'out';
%         %ax2.Visible = 'on';
%         ax3.Visible = 'on'; ax3.TickDir = 'out';
%     end
    
    set([ax2],'XLim',T_lbl.xstarts(lbl,2) + [0 2]);

    %% Plot trajectories
    panl(lbl,1).pack('v',{2/3});
    ax3 = panl(lbl,1,1).select(); ax3.Visible = 'on';  ax3.NextPlot = 'add';
    ax3.YLim = [-10 370];
    ax3.XLim = [-6000 6000];
        
    traject_ts = T_lbl.Trajectories{lbl};
    for trjidx = 1:size(traject_ts,1)
        bartrial = load(fullfile(Dir,sprintf(trialStem,traject_ts(trjidx,1))));
        
        t = makeInTime(bartrial.params); t = t(:);
        ft = makeFrameTime(bartrial);
        dt = diff(ft(1:2));
        p = bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce;
        dp = cat(2,nan,diff(p)/dt);
        wind = ft>=traject_ts(trjidx,2) & ft<=traject_ts(trjidx,3);
        spkft = 0*ft;
        for tspk = bartrial.spikes(:)'
            i = find(ft<t(tspk),1,'last');
            i = find(ft>=t(tspk),1,'first');
            spkft(i) = 1;
        end
        
        spkft = logical(spkft);
        plot(ax3,dp(wind),p(wind),'color',clrs(trjidx,:));
        plot(ax3,dp(spkft & wind),p(spkft & wind),'color',clrs(trjidx,:),'marker','.','markersize',14,'linestyle','none');
            
        axidx = find(T_lbl.bar_trialnums(lbl,:)==traject_ts(trjidx,1));
        eval(['ax = ax' num2str(axidx),';']);
        plot(ax,ft(wind),p(wind),'linewidth',2,'color',clrs(trjidx,:))
    end
end