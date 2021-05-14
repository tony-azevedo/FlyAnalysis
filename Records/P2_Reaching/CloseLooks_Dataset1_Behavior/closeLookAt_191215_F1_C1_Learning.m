% 191213_F1_C1
% Cells with steps and ramps
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile'};

sz = [1 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

% T{1,:} = {'191107_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191202_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191205_F0_C0', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191212_F0_C0', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191212_F2_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
T{1,:} = {'191213_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191215_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191215_F2_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191219_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};

T_Reach = T;

% Script_tableOfReachData

%% Create a plot ordering trials normally
% Then color force through out trials

CellID = T_Reach.CellID;
cidx = 1;
% for cidx = 1:length(CellID)
T_row = T_Reach(cidx,:);

cid = CellID{cidx};
fprintf('Starting %s\n',cid);

Dir = fullfile('E:\Data',cid(1:6),cid);
cd(Dir);

trialStem = [T_row.Protocol{1} '_Raw_' cid '_%d.mat'];
datastructfile = fullfile(Dir);
datastructfile = fullfile(datastructfile,[T.Protocol{cidx} '_' cid '.mat']);
DataStruct = load(datastructfile);
TP = datastruct2table(DataStruct.data,'DataStructFileName',datastructfile,'rewrite','yes');
TP = addExcludeFlagToDataTable(TP,trialStem);
TP = addArduinoDurationToDataTable(TP);
TP = TP(~TP.Excluded,:);

% for now just make a matrix of the correct size, and imshow it in
% parula
trials = TP.trial;
trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(trials(1)) '.mat']));
forceProbe = zeros(length(trial.forceProbeStuff.CoM),length(trials));
ft = makeFrameTime(trial);
for t = 1:length(trials)
    tr = trials(t);
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
    if isfield(trial,'forceProbeStuff')
        forceProbe(:,t) = trial.forceProbeStuff.CoM;
    end
end

%%
fpHm(ft,trials,forceProbe,TP.ArduinoDuration)

%% Probe force bins:

ubins = linspace(750,1250,60);
vbins = linspace(-6000,6000,40);

%% Where is neutral?

histfig = figure;
hax = subplot(1,1,1,'parent',histfig); hax.NextPlot = 'add';
xlabel(hax, 'Force Probe');
ylabel(hax, 'Counts');


% assume it is where the probe is resting before the stimulus starts
neutralpnts = forceProbe(1:20,ft<0);
neutral = mean(neutralpnts(:));

histogram(hax,neutralpnts,ubins,'Normalization','countdensity','DisplayStyle','stairs','displayname','neutrpnts');
drawnow
plot(hax,[neutral neutral],[0 hax.YLim(2)],'color','red');

%% replot forceProbe as Delta
fpHm(ft,trials,forceProbe-neutral,TP.ArduinoDuration)

%% Where is the threshold?
figure
ax = subplot(1,1,1); ax.NextPlot = 'add';
fp_off = trials*nan;
for t = 1:length(trials)
    if ~isnan(TP.ArduinoDuration(t))
        ft_off = find(ft<TP.ArduinoDuration(t),1,'last');
        if ft_off<845
            fp_off(t) = forceProbe(ft_off,t);
            plot(ax,forceProbe(ft_off-20:ft_off+20,t))
        end
    end
end

histogram(hax,fp_off,ubins,'Normalization','count','DisplayStyle','stairs','displayname','allthresh');

% end

%% Look at different stretches of trials

block{1} = [1:84]; % low forces (336)
block{2} = [85:144]; % high force threshold (276)
block{3} = [145:194]; % low force threshold (336)
block{4} = [195:214]; % high force threshold (276)
block{5} = [215:219]; % resting
block{6} = [220:259]; % kicking

%%
delete(findobj(hax,'displayname','allthresh'));
delete(findobj(hax,'displayname','neutrpnts'));

for b = 1:length(block)
    btrs = block{b};
    a = histogram(hax,fp_off(btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b)]);
end
figure(hax.Parent)
legend('toggle')
legend('boxoff')

%%
blck3 = findobj(hax,'displayname','block 3');
lowthrsh = blck3.BinEdges(blck3.Values== max(blck3.Values));

blck4 = findobj(hax,'displayname','block 4');
highthrsh = blck4.BinEdges(blck4.Values== max(blck4.Values));

blckthresh = [
    lowthrsh
    highthrsh
    lowthrsh
    highthrsh
    neutral
    850];

blckclrs = [
    0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0    0.4470    0.7410
    0.8500    0.3250    0.0980
    .7 .7 .7
    0.4940    0.1840    0.5560
    ];

earlyclr = [0.8500    0.3250    0.0980];
lateclr = [0    0.4470    0.7410];

lowclr = [0.9290 0.6940 0.1250];
hiclr = [0.4940 0.1840 0.5560];

%% Save the thresholds back in to the trials. Then we can display them in quickshow

% Done
% for b = 1:6
%     btrs = block{b};
%     fprintf('Saving block %d trials with thresh %g\n',b,blckthresh(b));
%
%     for t = 1:length(btrs)
%         tr = btrs(t);
%         trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
%         fprintf('\ttrial %d with thresh %g\n',tr,blckthresh(b));
%         if isfield(trial,'forceProbeStuff')
%             trial.forceProbeStuff.ProbeLimits = [min(forceProbe(:)) max(forceProbe(:))];
%             trial.forceProbeStuff.Neutral = neutral;
%             trial.forceProbeStuff.ArduinoThresh = blckthresh(b);
%             save(trial.name,'-struct','trial');
%         end
%     end
% end

%% Plot the blocks on the heatmap overview.

ax = fpHm(ft,trials,forceProbe,TP.ArduinoDuration)
ax = fpHm(ft,trials,forceProbe-neutral,TP.ArduinoDuration)
ax = fpHm(ft,trials,forceProbe-neutral,TP.ArduinoDuration)
for b = 1:6
    btrs = block{b};
    rectangle(ax,'Position',[ax.XLim(1) btrs(1) diff(ax.XLim) diff([btrs(1), btrs(end)])],'EdgeColor',blckclrs(b,:),'LineWidth',4)
end

%%
% delete(findobj(hax,'displayname','block 1'));
delete(findobj(hax,'displayname','block 6'));
delete(findobj(hax,'displayname','block 5'));
% delete(findobj(hax,'displayname','neutrpnts'));


%% Now look at probe distribution in different blocks.
% Ignore the training period, just compare 2 - high, 3 - low, 4 - high

fphistfig = figure;
hpax = subplot(1,1,1,'parent',fphistfig); hpax.NextPlot = 'add';
xlabel(hpax, 'Force Probe');
ylabel(hpax, 'Counts');

for b = 2:4
    btrs = block{b};
    histogram(hpax,forceProbe(:,btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b)]);
end

plot(hpax,[lowthrsh lowthrsh],[0 hpax.YLim(2)],'displayname','low');
plot(hpax,[highthrsh highthrsh],[0 hpax.YLim(2)],'displayname','high');

legend('toggle')
legend('boxoff')


%% Look at probe distribution in different parts of each block.
% Ignore the training period, just compare 2 - high, 3 - low, 4 - high

for b = 1
    block_fphistfig = figure;
    bhpax = subplot(1,1,1,'parent',block_fphistfig); bhpax.NextPlot = 'add';
    xlabel(bhpax, 'Force Probe');
    ylabel(bhpax, 'Counts');
    btrs = block{b};
    pt1 = floor(length(btrs)*1/10);
    
    % take pieces of the block trials
    btrs(1:pt1)
    btrs(end-pt1:end)
    
    % take snippets of the time frames
    ft_win = ft>.5;
    
    %     histogram(bhpax,forceProbe(ft_win,btrs(1:pt1)),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt 1']);
    histogram(bhpax,forceProbe(ft_win,btrs(end-pt1:end)),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt end']);
    
    plot(bhpax,[lowthrsh lowthrsh],[0 bhpax.YLim(2)],'displayname','low','color',lowclr);
    plot(bhpax,[highthrsh highthrsh],[0 bhpax.YLim(2)],'displayname','high','color',hiclr);
    
    if blckthresh(b)==lowthrsh
        set(findobj(bhpax,'displayname','low'),'linewidth',4);
    else
        set(findobj(bhpax,'displayname','high'),'linewidth',4);
    end
    
    legend('toggle')
    legend('boxoff')
    
    % Show when this narrow threshold like set of points comes from.
    ax = fpHm(ft,trials,forceProbe);
    ax.NextPlot = 'add';
    intr_win = [995 1030];
    for tr = btrs(end-pt1:end)
        pntsofint = ft_win & forceProbe(:,tr)>=intr_win(1) & forceProbe(:,tr)<=intr_win(2);
        plot(ax,ft(pntsofint),tr*ones(sum(pntsofint),1),'.','MarkerEdgeColor',[1,1,1])
    end
    
    rectangle(ax,'Position',[.5 btrs(end-pt1) 4.5 diff([btrs(end-pt1), btrs(end)])],'EdgeColor',lateclr,'LineWidth',4)
    
    blcktrfig = figure;
    latetrax = subplot(2,1,2,'parent',blcktrfig); latetrax.NextPlot = 'add';
    title('late')
    for tr = btrs(end-pt1:end) 
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        ft = makeFrameTime(trial);
        plot(ft,trial.forceProbeStuff.CoM,'color',lateclr);
    end
    plot([ft(1), ft(end)],trial.forceProbeStuff.ArduinoThresh*[1, 1],'color',[0 0 0]);
    
    ylims = [min([earlytrax.YLim,latetrax.YLim]), max([earlytrax.YLim,latetrax.YLim])];
    earlytrax.YLim = ylims; latetrax.YLim = ylims;
    
    xlabel('Time (s)')
    ylabel('Probe')

end

%% Now look at probe distribution in different parts of each block.
% Ignore the training period, just compare 2 - high, 3 - low, 4 - high
close all

for b = 4%2:4
    bhpax = blckHistFig();
    xlabel(bhpax, 'Force Probe');
    ylabel(bhpax, 'Counts');
    btrs = block{b};
    pt1 = floor(length(btrs)*1/6);
    pt1 = 5
        
    % take snippets of the time frames
    ft_win = ft>.5;
    
    histogram(bhpax,forceProbe(ft_win,btrs(1:pt1)),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt 1'],'EdgeColor',earlyclr);
    histogram(bhpax,forceProbe(ft_win,btrs(end-pt1:end)),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt end'],'EdgeColor',lateclr);
    
    plot(bhpax,[lowthrsh lowthrsh],[0 bhpax.YLim(2)],'displayname','low','color',lowclr);
    plot(bhpax,[highthrsh highthrsh],[0 bhpax.YLim(2)],'displayname','high','color',hiclr);
    
    if blckthresh(b)==lowthrsh
        set(findobj(bhpax,'displayname','low'),'linewidth',4);
    else
        set(findobj(bhpax,'displayname','high'),'linewidth',4);
    end
    
    l = legend('show');
    l.Box = 'off';
    l.TextColor = [1 1 1];
    l.Location = 'northwest';

    %     % Show when this narrow threshold like set of points comes from.
    ax = fpHm(ft,trials,forceProbe);
    ax.NextPlot = 'add';
    
    rectangle(ax,'Position',[0.5 btrs(1) diff([0.5 ax.XLim(2)]) diff([btrs(1), btrs(pt1)])],'EdgeColor',earlyclr,'LineWidth',4)
    rectangle(ax,'Position',[0.5 btrs(end-pt1) diff([0.5 ax.XLim(2)]) diff([btrs(end-pt1), btrs(end)])],'EdgeColor',lateclr,'LineWidth',4)
    
    %     intr_win = [995 1030];
    %     for tr = btrs(end-pt1:end)
    %         pntsofint = ft_win & forceProbe(:,tr)>=intr_win(1) & forceProbe(:,tr)<=intr_win(2);
    %         plot(ax,ft(pntsofint),tr*ones(sum(pntsofint),1),'.','MarkerEdgeColor',[1,1,1])
    %     end
    
    [earlytrax,latetrax] = blckTrcFig;
    title(earlytrax,'early','color',[1 1 1])
    for tr = btrs(1:pt1) 
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        ft = makeFrameTime(trial);
        plot(earlytrax,ft,trial.forceProbeStuff.CoM,'color',earlyclr);
    end
    title(latetrax,'late','color',[1 1 1])
    for tr = btrs(end-pt1:end) 
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        ft = makeFrameTime(trial);
        plot(latetrax,ft,trial.forceProbeStuff.CoM,'color',lateclr);
    end
    l1 = plot(earlytrax,[ft(1), ft(end)],trial.forceProbeStuff.ArduinoThresh*[1, 1]);
    l2 = plot(latetrax,[ft(1), ft(end)],trial.forceProbeStuff.ArduinoThresh*[1, 1]);
    if blckthresh(b)==lowthrsh
        set([l1,l2],'color',lowclr);
    else
        set([l1,l2],'color',hiclr);
    end

    ylims = [min([earlytrax.YLim,latetrax.YLim]), max([earlytrax.YLim,latetrax.YLim])];
    earlytrax.YLim = ylims; latetrax.YLim = ylims;
    
    xlabel('Time (s)')
    ylabel('Probe')
end

%% Now look at probe distribution in early part of each block.
% Ignore the training period, just compare 2 - high, 3 - low, 4 - high


for b = 2:4
    
    bhpax = blckHistFig();
    xlabel(bhpax, 'Force Probe');
    ylabel(bhpax, 'Counts');
    btrs = block{b};
    pt1 = floor(length(btrs)*1/6);
    pt1 = 7
        
    % take snippets of the time frames
    ft_win = ft<0;
    
    histogram(bhpax,forceProbe(ft_win,btrs(1:pt1)),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt 1'],'EdgeColor',earlyclr);
    histogram(bhpax,forceProbe(ft_win,btrs(end-pt1:end)),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt end'],'EdgeColor',lateclr);
    
    plot(bhpax,[lowthrsh lowthrsh],[0 bhpax.YLim(2)],'displayname','low','color',lowclr);
    plot(bhpax,[highthrsh highthrsh],[0 bhpax.YLim(2)],'displayname','high','color',hiclr);
    
    if blckthresh(b)==lowthrsh
        set(findobj(bhpax,'displayname','low'),'linewidth',4);
    else
        set(findobj(bhpax,'displayname','high'),'linewidth',4);
    end
    
    l = legend('show');
    l.Box = 'off';
    l.TextColor = [1 1 1];
    
    %     % Show when this narrow threshold like set of points comes from.
    ax = fpHm(ft,trials,forceProbe);
    ax.NextPlot = 'add';
    
    rectangle(ax,'Position',[-.5 btrs(1) .5 diff([btrs(1), btrs(pt1)])],'EdgeColor',earlyclr,'LineWidth',4)
    rectangle(ax,'Position',[-.5 btrs(end-pt1) .5 diff([btrs(end-pt1), btrs(end)])],'EdgeColor',lateclr,'LineWidth',4)
        
    [earlytrax,latetrax] = blckTrcFig;
    title(earlytrax,'early','color',[1 1 1])
    for tr = btrs(1:pt1) 
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        ft = makeFrameTime(trial);
        plot(earlytrax,ft,trial.forceProbeStuff.CoM,'color',earlyclr);
    end
    title(latetrax,'late','color',[1 1 1])
    for tr = btrs(end-pt1:end) 
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        ft = makeFrameTime(trial);
        plot(latetrax,ft,trial.forceProbeStuff.CoM,'color',lateclr);
    end
    l1 = plot(earlytrax,[ft(1), ft(end)],trial.forceProbeStuff.ArduinoThresh*[1, 1]);
    l2 = plot(latetrax,[ft(1), ft(end)],trial.forceProbeStuff.ArduinoThresh*[1, 1]);
    if blckthresh(b)==lowthrsh
        set([l1,l2],'color',lowclr);
    else
        set([l1,l2],'color',hiclr);
    end

    ylims = [min([earlytrax.YLim,latetrax.YLim]), max([earlytrax.YLim,latetrax.YLim])];
    earlytrax.YLim = ylims; latetrax.YLim = ylims;
    
    xlabel('Time (s)')
    ylabel('Probe')
    
end

%% Now look at the rest trials real quick

for b = 5
    
    bhpax = blckHistFig();
    xlabel(bhpax, 'Force Probe');
    ylabel(bhpax, 'Counts');
    btrs = block{b};
        
    % take snippets of the time frames
    ft_win = true(size(ft));
    
    histogram(bhpax,forceProbe(ft_win,btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt 1'],'EdgeColor',earlyclr);
    
    plot(bhpax,[lowthrsh lowthrsh],[0 bhpax.YLim(2)],'displayname','low','color',lowclr);
    plot(bhpax,[highthrsh highthrsh],[0 bhpax.YLim(2)],'displayname','high','color',hiclr);
    plot(bhpax,[neutral neutral],[0 bhpax.YLim(2)],'displayname','neutral','color',hiclr);
        
    l = legend('show');
    l.Box = 'off';
    l.TextColor = [1 1 1];
            
    [earlytrax,latetrax] = blckTrcFig;
%     title(earlytrax,'early','color',[1 1 1])
    for tr = btrs
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        ft = makeFrameTime(trial);
        plot(earlytrax,ft,trial.forceProbeStuff.CoM,'color',earlyclr);
    end
%     title(latetrax,'late','color',[1 1 1])
%     for tr = btrs(end-pt1:end) 
%         trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
%         ft = makeFrameTime(trial);
%         plot(latetrax,ft,trial.forceProbeStuff.CoM,'color',lateclr);
%     end
    l1 = plot(earlytrax,[ft(1), ft(end)],neutral*[1, 1]);
%     l2 = plot(latetrax,[ft(1), ft(end)],trial.forceProbeStuff.ArduinoThresh*[1, 1]);
%     if blckthresh(b)==lowthrsh
%         set([l1,l2],'color',lowclr);
%     else
%         set([l1,l2],'color',hiclr);
%     end
% 
%     ylims = [min([earlytrax.YLim,latetrax.YLim]), max([earlytrax.YLim,latetrax.YLim])];
    earlytrax.YLim = [900 1000]; % latetrax.YLim = ylims;
    delete(latetrax);
    xlabel('Time (s)')
    ylabel('Probe')
    
end


%% Finally, compare sets 4 and 6.

% bhpax = blckHistFig();
% xlabel(bhpax, 'Force Probe');
% ylabel(bhpax, 'Counts');
% btrs = block{b};
% 
% % take snippets of the time frames
% ft_win = true(size(ft));
% 
% histogram(bhpax,forceProbe(ft_win,btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt 1'],'EdgeColor',earlyclr);
% 
% plot(bhpax,[lowthrsh lowthrsh],[0 bhpax.YLim(2)],'displayname','low','color',lowclr);
% plot(bhpax,[highthrsh highthrsh],[0 bhpax.YLim(2)],'displayname','high','color',hiclr);
% plot(bhpax,[neutral neutral],[0 bhpax.YLim(2)],'displayname','neutral','color',hiclr);
% 
% l = legend('show');
% l.Box = 'off';
% l.TextColor = [1 1 1];

[earlytrax,latetrax] = blckTrcFig;

title(earlytrax,'Block 4','color',[1 1 1])
for tr = block{4}
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
    ft = makeFrameTime(trial);
    plot(earlytrax,ft,trial.forceProbeStuff.CoM,'color',earlyclr);
end

title(latetrax,'Block 6','color',[1 1 1])
for tr = 222:231
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
    ft = makeFrameTime(trial);
    plot(latetrax,ft,trial.forceProbeStuff.CoM,'color',lateclr);
end

l1 = plot(earlytrax,[ft(1), ft(end)],neutral*[1, 1]);
l2 = plot(latetrax,[ft(1), ft(end)],trial.forceProbeStuff.ArduinoThresh*[1, 1],'color',lowclr);

ylims = [min([earlytrax.YLim,latetrax.YLim]), max([earlytrax.YLim,latetrax.YLim])];
earlytrax.YLim = ylims; latetrax.YLim = ylims;
xlabel('Time (s)')
ylabel('Probe')
    
[earlytrax,latetrax] = blckTrcFig;



%% Functions

function [ax1] = fpHm(ft,trials,forceProbe,varargin)
if nargin > 3
    ad = varargin{1};
end

figure;
set(gcf,'Position',[65    32   826   964])
ax1 = subplot(1,1,1);
s1 = pcolor(ax1,ft,trials,forceProbe');
s1.EdgeColor = 'flat';
colormap(ax1,'parula')
clrbr = colorbar(ax1);
xlabel(ax1,'Time (s)');
ylabel(ax1,'Trial #');

ax1.YDir = 'reverse';
ax1.NextPlot = 'add';
if nargin > 3
    plot(ax1,ad,trials,'.','color',[1,1,1])
end

ax1.Parent.Color = [1 1 1]*0;
ax1.YColor = [1 1 1];
ax1.XColor = [1 1 1];
clrbr.Color = [1 1 1];
clrbr.Label.String = '\mum';
end

function bhpax = blckHistFig()
block_fphistfig = figure;
set(block_fphistfig,'Color',[0 0 0])
bhpax = subplot(1,1,1,'parent',block_fphistfig); bhpax.NextPlot = 'add';
bhpax.Color = [0 0 0];
bhpax.YColor = [1 1 1];
bhpax.XColor = [1 1 1];

end

function [ax1, ax2] = blckTrcFig()
block_fphistfig = figure;
set(block_fphistfig,'Color',[0 0 0])
ax1 = subplot(2,1,1,'parent',block_fphistfig); ax1.NextPlot = 'add';
ax2 = subplot(2,1,2,'parent',block_fphistfig); ax2.NextPlot = 'add';

ax1.Color = [0 0 0];
ax1.YColor = [1 1 1];
ax1.XColor = [1 1 1];

ax2.Color = [0 0 0];
ax2.YColor = [1 1 1];
ax2.XColor = [1 1 1];

end


%% Snippets
% %% Block 3, low thresh, early points, before light turns on
% for b = 3
%     block_fphistfig = figure;
%     bhpax = subplot(1,1,1,'parent',block_fphistfig); bhpax.NextPlot = 'add';
%     xlabel(bhpax, 'Force Probe');
%     ylabel(bhpax, 'Counts');
%     btrs = block{b};
%
%     div = 5;
%     pt1 = floor(length(btrs)*1/div);
%     curi = 1; cnt = 1;
%
%     cmap = cbrewer('seq', 'PuBu', div);
%
%     while curi<length(btrs)
%
%         btrs(curi:curi+pt1)
%         if curi+pt1+pt1 > length(btrs)
%             pt1 = length(btrs)-curi;
%         end
%
%         % take snippets of the time frames
%         ft_win = ft<0;
%         histogram(bhpax,forceProbe(ft_win,btrs(curi:curi+pt1)),ubins,...
%             'Normalization','count','DisplayStyle','stairs',...
%             'displayname',['block ' num2str(b) ' pt end'],...
%             'EdgeColor',cmap(cnt,:));
%
%
%         curi = curi+pt1+1;
%         cnt = cnt+1;
%     end
%     plot(bhpax,[lowthrsh lowthrsh],[0 bhpax.YLim(2)],'displayname','low');
%     plot(bhpax,[highthrsh highthrsh],[0 bhpax.YLim(2)],'displayname','high');
%
%     if blckthresh(b)==lowthrsh
%         set(findobj(bhpax,'displayname','low'),'linewidth',4);
%     else
%         set(findobj(bhpax,'displayname','high'),'linewidth',4);
%     end
%
%     legend('toggle')
%     legend('boxoff')
% end
