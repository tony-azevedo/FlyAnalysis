%% Group responses to compare

close all

% 1 - enough trials
% 2 - similar leg movements
% 3 - hopefully release the bar
%     {'180404_F1_C1'}
%     {'180410_F1_C1'}
%     {'180703_F3_C1'}

%     {'180328_F4_C1'}
%     {'180821_F1_C1'}
%     {'180822_F1_C1'}
%     {'181220_F1_C1'}

%     {'180328_F1_C1'}
%     {'180329_F1_C1'}
%     {'180702_F1_C1'}
%     {'180806_F2_C1'}  

cellid = '180806_F2_C1';
T_cell = T_iavChrFlash(contains(T_iavChrFlash.CellID,cellid)&strcmp(T_iavChrFlash.Drug,''),:);
CellIDs = T_iavChr.CellID;

%%

T_low = T_iavChrFlash(1:length(CellIDs),:);
T_high = T_iavChrFlash(1:length(CellIDs),:);
T_veryhigh = T_iavChrFlash(1:length(CellIDs),:);

intensities = [
  0.0028    0.0050  0.0300  % 180404_F1_C1
  0.0019    0.0060  0.0600  % 180410_F1_C1
  0.0050    0.0158  0.1000  % 180703_F3_C1
  
  0.0025    0.0038  0.0150   % 180328_F4_C1
  0.0018    0.0056  0.0562  % 180821_F1_C1 - 0.0032 is in between
  0.0010    0.0018  0.0562  % 180822_F1_C1
  0.0010    0.0016  0.0028  % 181220_F1_C1
                    
  0.0025    0.0100  NaN     % 180328_F1_C1 - No big extensions, but some nice in betweens
  0.0036    0.0048  NaN     % 180329_F1_C1 - No big extensions
  0.0005    0.0050  0.0500  % 180702_F1_C1 - 0.0016 is right on the border
  0.0010    0.0032  0.0316  % 180806_F2_C1
];

%% 
for row = 1:length(CellIDs)
    cellid = CellIDs{row};

    T_low(row,:) = T_iavChrFlash(...
        contains(T_iavChrFlash.CellID,cellid) & ...
        round(T_iavChrFlash.FlashStrength*1E4)/1E4 == intensities(row,1) ...
        ,:);
    
    T_high(row,:) = T_iavChrFlash(...
        contains(T_iavChrFlash.CellID,cellid) & ...
        round(T_iavChrFlash.FlashStrength*1E4)/1E4 == intensities(row,2) ...
        ,:);
    if ~isnan(intensities(row,3))
        T_veryhigh(row,:) = T_iavChrFlash(...
            contains(T_iavChrFlash.CellID,cellid) & ...
            round(T_iavChrFlash.FlashStrength*1E4)/1E4 == intensities(row,3) ...
            ,:);
    else
        temp = T_iavChrFlash(contains(T_iavChrFlash.CellID,cellid),:);
        T_veryhigh(row,:) = temp(1,:);
        T_veryhigh{row,6} = {nan};
        T_veryhigh{row,7} = {nan};
        T_veryhigh{row,8} = {nan};
        T_veryhigh{row,[9 11:21]} = nan;
    end
end

%% Probe trough for 180329_F1_C1
T_high.Trough_probe(contains(T_high.CellID,'180329_F1_C1')) = 634.7-618;

%% comparison plot
VvsPfig = figure;
VvsPfig.Position = [680   722   191   256];
ms = 18;

ax = subplot(1,1,1,'parent',VvsPfig); ax.NextPlot = 'add';

for row = 1:height(T_high)        
    clridx = strcmp({'fast','intermediate','slow'},T_high.Cell_label{row});
    clr = clrs(clridx,:);
    ltclr = lightclrs(clridx,:);
        
    if find(clridx)<3
        plot(ax,[1 2],[T_low.Peak_V(row) T_high.Peak_V(row)],'color',clr,'marker','.','markersize',ms)%;,'tag',[T_cell.CellID{1} sprintf(' - %.2e',T_cell.FlashStrength(row))])
    elseif find(clridx)==3
        plot(ax,[1 2],[T_low.Peak_V(row) T_high.Peak_V(row)],'color',ltclr,'marker','.','markersize',ms)%;,'tag',[T_cell.CellID{1} sprintf(' - %.2e',T_cell.FlashStrength(row))])
        plot(ax,[1 2],[T_low.Trough_V(row) T_high.Trough_V(row)],'color',clr,'marker','.','markersize',ms)%;,'tag',[T_cell.CellID{1} sprintf(' - %.2e',T_cell.FlashStrength(row))])
    end
end
ax.XLim = [.5 2.5];
ax.YLim = [-20 10 ];

%% Plot High example as a lead in to the panels

intermediateOverviewPanel = figure;
ax0 = subplot(5,1,1,'parent',intermediateOverviewPanel); ax0.NextPlot = 'add';
ax1 = subplot(5,1,[2 3],'parent',intermediateOverviewPanel); ax1.NextPlot = 'add';
ax2 = subplot(5,1,[4 5],'parent',intermediateOverviewPanel); ax2.NextPlot = 'add';

row = 6;

trialnums = T_veryhigh.Trialnums{row};
trialnums = [7 26 52];
trialStem = [T_veryhigh.Protocol{row} '_Raw_' T_veryhigh.CellID{row} '_%d.mat'];
Dir = fullfile('E:\Data',T_veryhigh.CellID{row}(1:6),T_veryhigh.CellID{row});

trial = load(fullfile(Dir,sprintf(trialStem,trialnums(1))));

t = makeInTime(trial.params);
v = nan(length(t),length(trialnums));
ft = makeFrameTime(trial);
probe = nan(length(ft),length(trialnums));
for tr = 1:length(trialnums)
    trial = load(fullfile(Dir,sprintf(trialStem,trialnums(tr))));
    v(:,tr) = trial.voltage_1;
    probe(:,tr) = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
        
    plot(ax1,t,v(:,tr),'tag',num2str(trialnums(tr)))
    
    l = plot(ax2,ft,probe(:,tr),'tag',num2str(trialnums(tr)));

    sp = raster(ax0,t(trial.spikes),-tr+.4*[-1 1],[-1 length(trialnums)+1]);
    set(sp,'Color',l.Color);
end

linkaxes([ax0 ax1 ax2],'x')
ax0.XLim = [-.3 1.01];

ax1.YLim = [-50 -15];
ax2.YLim = [-10 300];
set([ax0 ax1 ax2],'TickDir','out');
set([ax0 ax1],'XTick',[]);

ax0.FontSize = 12;
ax1.FontSize = 12;
ax2.FontSize = 12;

%% Plot Exemplars

ExemplarPanels = figure; ExemplarPanels.Position = [680 359 880 619];
panl = panel(ExemplarPanels);
set(ExemplarPanels,'color',[1 1 1])

panl.pack('h',{1/3 1/3 1/3})  % fast, inter, slow
panl.margin = [18 10 2 10];

panl.fontname = 'Arial';
% panl(1).marginbottom = 2;
% panl(2).margintop = 8;

%% fast example
panl(1).pack('v',{1/2 1/2})
T_row_low = T_low(1,:);
T_row_high = T_high(1,:);

panl(1,1).pack('v',{1/2 1/2})
ax1 = panl(1,1,1).select(); ax1.NextPlot = 'add';
ax2 = panl(1,1,2).select(); ax2.NextPlot = 'add';

trialnums = T_row_low.Trialnums{1};
trialStem = [T_row_low.Protocol{1} '_Raw_' T_row_low.CellID{1} '_%d.mat'];
Dir = fullfile('E:\Data',T_row_low.CellID{1}(1:6),T_row_low.CellID{1});

trial = load(fullfile(Dir,sprintf(trialStem,trialnums(1))));

t = makeInTime(trial.params);
v = nan(length(t),length(trialnums));
ft = makeFrameTime(trial);
probe = nan(length(ft),length(trialnums));
for tr = 1:length(trialnums)
    trial = load(fullfile(Dir,sprintf(trialStem,trialnums(tr))));
    v(:,tr) = trial.voltage_1;
    probe(:,tr) = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
        
    l = plot(ax1,t,v(:,tr),'tag',num2str(trialnums(tr)),'color',[1 1 1]*.7);
    if trialnums(tr) == 44
        l.Color = [0 0 0];
    end

    l = plot(ax2,ft,probe(:,tr),'tag',num2str(trialnums(tr)),'color',[.6 .6 1]);
    if trialnums(tr) == 44
        l.Color = [0 0 .5];
    end
end

linkaxes([ax1 ax2],'x')
ax1.XLim = [-.3 1.01];

ax1.YLim = [-54 -24];
ax2.YLim = [-10 300];
set([ax1 ax2],'TickDir','out');
set([ax1],'XTick',[]);

ax1.FontSize = 12;
ax2.FontSize = 12;

% high flashStrength
panl(1,2).pack('v',{1/2 1/2})
ax1 = panl(1,2,1).select(); ax1.NextPlot = 'add';
ax2 = panl(1,2,2).select(); ax2.NextPlot = 'add';

trialnums = T_row_high.Trialnums{1};
trialStem = [T_row_high.Protocol{1} '_Raw_' T_row_high.CellID{1} '_%d.mat'];
Dir = fullfile('E:\Data',T_row_high.CellID{1}(1:6),T_row_high.CellID{1});

trial = load(fullfile(Dir,sprintf(trialStem,trialnums(1))));

t = makeInTime(trial.params);
v = nan(length(t),length(trialnums));
ft = makeFrameTime(trial);
probe = nan(length(ft),length(trialnums));
for tr = 1:length(trialnums)
    trial = load(fullfile(Dir,sprintf(trialStem,trialnums(tr))));
    v(:,tr) = trial.voltage_1;
    probe(:,tr) = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
        
    l = plot(ax1,t,v(:,tr),'tag',num2str(trialnums(tr)),'color',[1 1 1]*.7);
    if trialnums(tr) == 59
        l.Color = [0 0 0];
    end

    l = plot(ax2,ft,probe(:,tr),'tag',num2str(trialnums(tr)),'color',[.6 .6 1]);
    if trialnums(tr) == 59
        l.Color = [0 0 .5];
    end

end

linkaxes([ax1 ax2],'x')
ax1.XLim = [-.3 1.01];

ax1.YLim = [-54 -24];
ax2.YLim = [-10 300];
set([ax1 ax2],'TickDir','out');
set([ax1],'XTick',[]);

ax1.FontSize = 12;
ax2.FontSize = 12;


%% inter example
panl(2).pack('v',{1/2 1/2})
T_row_low = T_low(4,:);
T_row_high = T_high(4,:);

panl(2,1).pack('v',{1/2 1/2})
ax1 = panl(2,1,1).select(); ax1.NextPlot = 'add';
ax2 = panl(2,1,2).select(); ax2.NextPlot = 'add';

trialnums = T_row_low.Trialnums{1};
% select 7 to be consistent
trialnums = trialnums(randperm(length(trialnums),7));

trialStem = [T_row_low.Protocol{1} '_Raw_' T_row_low.CellID{1} '_%d.mat'];
Dir = fullfile('E:\Data',T_row_low.CellID{1}(1:6),T_row_low.CellID{1});

trial = load(fullfile(Dir,sprintf(trialStem,trialnums(1))));

t = makeInTime(trial.params);
v = nan(length(t),length(trialnums));
ft = makeFrameTime(trial);
probe = nan(length(ft),length(trialnums));
for tr = 1:length(trialnums)
    trial = load(fullfile(Dir,sprintf(trialStem,trialnums(tr))));
    v(:,tr) = trial.voltage_1;
    probe(:,tr) = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
        
    l = plot(ax1,t,v(:,tr),'tag',num2str(trialnums(tr)),'color',[1 1 1]*.7);
    if tr == 3
        l.Color = [0 0 0];
    end

    l = plot(ax2,ft,probe(:,tr),'tag',num2str(trialnums(tr)),'color',[.6 .6 1]);
    if tr == 3
        l.Color = [0 0 .5];
    end

end

linkaxes([ax1 ax2],'x')
ax1.XLim = [-.3 1.01];

ax1.YLim = [-54 -24];
ax2.YLim = [-10 300];
set([ax1 ax2],'TickDir','out');
set([ax1],'XTick',[]);

ax1.FontSize = 12;
ax2.FontSize = 12;

% high flashStrength
panl(2,2).pack('v',{1/2 1/2})
ax1 = panl(2,2,1).select(); ax1.NextPlot = 'add';
ax2 = panl(2,2,2).select(); ax2.NextPlot = 'add';

trialnums = T_row_high.Trialnums{1};
trialnums = trialnums(randperm(length(trialnums),7));
trialStem = [T_row_high.Protocol{1} '_Raw_' T_row_high.CellID{1} '_%d.mat'];
Dir = fullfile('E:\Data',T_row_high.CellID{1}(1:6),T_row_high.CellID{1});

trial = load(fullfile(Dir,sprintf(trialStem,trialnums(1))));

t = makeInTime(trial.params);
v = nan(length(t),length(trialnums));
ft = makeFrameTime(trial);
probe = nan(length(ft),length(trialnums));
for tr = 1:length(trialnums)
    trial = load(fullfile(Dir,sprintf(trialStem,trialnums(tr))));
    v(:,tr) = trial.voltage_1;
    probe(:,tr) = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
        
    l = plot(ax1,t,v(:,tr),'tag',num2str(trialnums(tr)),'color',[1 1 1]*.7);
    if tr == 3
        l.Color = [0 0 0];
    end
    
    l = plot(ax2,ft,probe(:,tr),'tag',num2str(trialnums(tr)),'color',[.6 .6 1]);
    if tr == 3
        l.Color = [0 0 0];
    end
    
end

linkaxes([ax1 ax2],'x')
ax1.XLim = [-.3 1.01];

ax1.YLim = [-54 -24];
ax2.YLim = [-10 300];
set([ax1 ax2],'TickDir','out');
set([ax1],'XTick',[]);

ax1.FontSize = 12;
ax2.FontSize = 12;


%% slow example
panl(3).pack('v',{1/2 1/2})
T_row_low = T_low(end,:);
T_row_high = T_high(end,:);

panl(3,1).pack('v',{1/4 3/8 3/8})
ax0 = panl(3,1,1).select(); ax0.NextPlot = 'add';
ax1 = panl(3,1,2).select(); ax1.NextPlot = 'add';
ax2 = panl(3,1,3).select(); ax2.NextPlot = 'add';

trialnums = T_row_low.Trialnums{1}; 

% just take the first block
trialnums = trialnums(trialnums>6 & trialnums<=71);

trialStem = [T_row_low.Protocol{1} '_Raw_' T_row_low.CellID{1} '_%d.mat'];
Dir = fullfile('E:\Data',T_row_low.CellID{1}(1:6),T_row_low.CellID{1});

trial = load(fullfile(Dir,sprintf(trialStem,trialnums(1))));

t = makeInTime(trial.params);
v = nan(length(t),length(trialnums));
ft = makeFrameTime(trial);
probe = nan(length(ft),length(trialnums));
for tr = 1:length(trialnums)
    trial = load(fullfile(Dir,sprintf(trialStem,trialnums(tr))));
    v(:,tr) = trial.voltage_1;
    sp = raster(ax0,t(trial.spikes),-tr+.4*[-1 1],[-1 length(trialnums)+1]);
    if tr == 3
        set(sp,'Color',[1 0 0]);
    else
        set(sp,'Color',[0 0 0]);
    end
    
    probe(:,tr) = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
        
    l = plot(ax1,t,v(:,tr),'tag',num2str(trialnums(tr)),'color',[1 1 1]*.7);
    if tr == 3
        l.Color = [0 0 0];
    end

    l = plot(ax2,ft,probe(:,tr),'tag',num2str(trialnums(tr)),'color',[.6 .6 1]);
    if tr == 3
        l.Color = [0 0 .5];
    end

end

linkaxes([ax0 ax1 ax2],'x')
ax1.XLim = [-.3 1.01];

ax0.YLim = [-8 0];
ax1.YLim = [-54 -24];
ax2.YLim = [-10 75];
set([ax0 ax1 ax2],'TickDir','out');
set([ax0 ax1],'XTick',[]);
set([ax0],'YTick',[]);

ax0.FontSize = 12;
ax1.FontSize = 12;
ax2.FontSize = 12;

% high flashStrength
panl(3,2).pack('v',{1/4 3/8 3/8})
ax0 = panl(3,2,1).select(); ax0.NextPlot = 'add';
ax1 = panl(3,2,2).select(); ax1.NextPlot = 'add';
ax2 = panl(3,2,3).select(); ax2.NextPlot = 'add';

trialnums = T_row_high.Trialnums{1};
% just take the first block
trialnums = trialnums(trialnums>1 & trialnums<=71);

trialStem = [T_row_high.Protocol{1} '_Raw_' T_row_high.CellID{1} '_%d.mat'];
Dir = fullfile('E:\Data',T_row_high.CellID{1}(1:6),T_row_high.CellID{1});

trial = load(fullfile(Dir,sprintf(trialStem,trialnums(1))));

t = makeInTime(trial.params);
v = nan(length(t),length(trialnums));
ft = makeFrameTime(trial);
probe = nan(length(ft),length(trialnums));
for tr = 1:length(trialnums)
    trial = load(fullfile(Dir,sprintf(trialStem,trialnums(tr))));
    v(:,tr) = trial.voltage_1;
    sp = raster(ax0,t(trial.spikes),-tr+.4*[-1 1],[-1 length(trialnums)+1]);
    if tr == 3
        set(sp,'Color',[1 0 0]);
    else
        set(sp,'Color',[0 0 0]);
    end

    probe(:,tr) = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
        
    l = plot(ax1,t,v(:,tr),'tag',num2str(trialnums(tr)),'color',[1 1 1]*.7);
    if tr == 3
        l.Color = [0 0 0];
    end

    l = plot(ax2,ft,probe(:,tr),'tag',num2str(trialnums(tr)),'color',[.6 .6 1]);
    if tr == 3
        l.Color = [0 0 0];
    end

end

linkaxes([ax0 ax1 ax2],'x')
ax1.XLim = [-.3 1.01];

ax0.YLim = [-8 0];
ax1.YLim = [-54 -24];
ax2.YLim = [-10 75];
set([ax0 ax1 ax2],'TickDir','out');
set([ax0 ax1],'XTick',[]);
set([ax0],'YTick',[]);

set(ExemplarPanels.Children,'FontSize',12)