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
% T{1,:} = {'191213_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191215_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191215_F2_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'191219_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'201215_F1_C1', 'Hot-Cell-Gal4',            'pilot', 'LEDArduinoFlashControl','empty'};
T{1,:} = {'201218_F1_C1', 'Hot-Cell-Gal4',            'pilot', 'LEDArduinoFlashControl','empty'};
T{1,:} = {'210105_F1_C1', 'Hot-Cell-Gal4',            'pilot', 'LEDArduinoFlashControl','empty'};
T{1,:} = {'210105_F2_C1', 'Hot-Cell-Gal4',            'pilot', 'LEDArduinoFlashControl','empty'};
T{1,:} = {'210105_F4_C1', 'Hot-Cell-Gal4',            'pilot', 'LEDArduinoFlashControl','empty'};

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

%Dir = fullfile('E:\Data',cid(1:6),cid);
Dir = fullfile('F:\Acquisition\',cid(1:6),cid);
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

%% downsample force probe at Pyas frame rate
dsmp = min(diff(find(diff(trial.probe_position)>0))); 
probe_comb = 1:dsmp:length(trial.probe_position);
forceProbe = zeros(length(probe_comb),length(trials));
target = zeros(2,length(trials));

t = makeInTime(trial.params);
ft = t(probe_comb);
for t = 1:length(trials)
    tr = trials(t);
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
    forceProbe(:,t) = trial.probe_position(probe_comb);
    target(1,t) = trial.target_location(1);
    target(2,t) = sum(trial.target_location);
end

%% Finds blocks at the rest trials
% assume some rest trials
resttrialstart = find(diff(isnan(TP.ArduinoDuration))>0)+1;
resttrialend = find(diff(isnan(TP.ArduinoDuration))<0);
blocks = [[1; resttrialend + 1],[resttrialstart-1;length(TP.ArduinoDuration)]];

% assuming trial is not changing between blocks
btrgts_x = target(1,blocks(:,1));
btrgts_x2 = target(2,blocks(:,1));
[extlim,~] = max([btrgts_x,btrgts_x2]);
[flexlim,~] = min([btrgts_x,btrgts_x2]);
[~,minidx] = min([btrgts_x-flexlim;extlim-btrgts_x2] ,[],1);
flexiontarget = minidx==1;

%% Edit the tags and save data
for tr = 1:size(TP,1)
    fprintf('Trial %d: \t',tr);
    blck_idx = find(TP.trial(tr)>=blocks(:,1) & TP.trial(tr)<=blocks(:,2));
    if isempty(blck_idx)
        if any(strcmp(TP.tags{tr},'rest'))
            fprintf('Already have a rest tag\n');
        elseif TP.ndf==0
            fprintf('Tagging as rest\n');
            trtags = TP.tags{tr};
            trtags{end+1} = 'rest';
            TP.tags{tr} = trtags;
        else
            fprintf('Trial %s: what is this case?\n')
            error
        end
    elseif any(strcmp(TP.tags{tr},'out of control'))
        if TP.ArduinoDuration(tr) >= 4 && TP.ArduinoDuration(tr) < 4.001
            fprintf('Found a probe trial\n')
        else
            fprintf('This is not a probe trial!\n')
            error
        end
    elseif TP.ArduinoDuration(tr) >= 4 && TP.ArduinoDuration(tr) < 4.001
        fprintf('This might have been a control trial!\n')
        error
    elseif flexiontarget(blck_idx)
        trtags = TP.tags{tr};
        flxidx = find(contains(trtags,'flex'));
        trtags{flxidx} = 'flex';
        TP.tags{tr} = trtags;
        fprintf('Replacing trial tags with flex\n');
    elseif ~flexiontarget(blck_idx)
        trtags = TP.tags{tr};
        flxidx = find(contains(trtags,'extend'));
        if isempty(flxidx)
            flxidx = find(contains(trtags,'flex'));
            if isempty(flxidx)
                fprintf('No current tag.\t');
                flxidx = length(trtags)+1;
            end
        end
        trtags{flxidx} = 'extend';
        TP.tags{tr} = trtags;
        fprintf('Replacing trial tags with extend\n');
    end        
end

%% forceprobe Heat Map
fpHm(ft,trials,forceProbe,TP.ArduinoDuration,blocks,flexiontarget)


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

function [ax1] = fpHm(ft,trials,forceProbe,ad,blocks,flexiontarget)

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

% draw blocks and what color
cmap = colormap(ax1);
for b = 1:size(blocks,1)
    ti = blocks(b,:);
    if flexiontarget(b)
        %indx = round((btrgts_x2(b)-ax1.CLim(1))/diff(ax1.CLim)*size(cmap,1));
        indx = 1;
    else
        %indx = round((btrgts_x(b)-ax1.CLim(1))/diff(ax1.CLim)*size(cmap,1));
        indx = size(cmap,1);
    end
    trgclr = cmap(indx,:);
    rectangle(ax1,'Position',[ax1.XLim(1) ti(1) diff(ax1.XLim) diff(ti)],'EdgeColor',trgclr,'LineWidth',2)
    %rectangle(ax1,'Position',[ax1.XLim(1) ti(1) diff(ax1.XLim) diff(ti)],'EdgeColor',[.2 .2 .2],'LineWidth',.5)
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


