% 191213_F1_C1
% Cells with steps and ramps
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile'};

sz = [1 length(varNames)];
data = cell(sz);
T_cell = cell2table(data);
T_cell.Properties.VariableNames = varNames;

T_cell{1,:} = {'210302_F1_C2', 'Hot-Cell-Gal4, 50uL ATR mixed in', 'pilot', 'LEDFlashWithPiezoCueControl','empty'};
T_cell{1,:} = {'210405_F1_C1', 'HC-LexA/13XLexAop-ChrimsonR;81A06/pJFRC7 100uL ATR mixed in', 'Fe>distal tidm', 'LEDFlashWithPiezoCueControl','empty'};
T_cell{1,:} = {'210604_F1_C1', 'Hot-Cell-Gal4, 50uL ATR mixed in', 'pilot', 'LEDFlashWithPiezoCueControl','empty'};

T_Reach = T_cell;

% Script_tableOfReachData

%% Create tables and forceprobe matrix and plot
Script_Process_ParamTable_ForceProbeMat

%% Measure movement in trials
Script_MeasurePrePostStimMovement

%% Now look at individual flies

% closeLook_210302_F1_C2_HCGal4_unknown;
% closeLook_210319_F2_C1_R81A06_unknown;
% closeLook_210331_F2_C1_R81A06_proximalFlexorWithSpikes;
closeLook_210602_F1_C1_R35C09_slowDistalFlexor;
% closeLook_210405_F1_C1_R81A06_largeDistalFlexor;
closeLook_210602_F1_C1_R35C09_slowDistalFlexor;
closeLook_210604_F1_C1_R35C09_slowDistalFlexor;

%% now try separating cases 1 and 2, and 5 and 6 based on movement
no_stim_trials = outcome_id==1;
timeout_trials = outcome_id==5;

figure
H = histogram(rms_trial_mvmt(no_stim_trials));


%% plot no_stim trials with large movements
T.Properties.UserData.trialStem = trialStem;
T.Properties.UserData.Dir = Dir;
rms_trial_mvmt(no_stim_trials & rms_trial_mvmt>160)

[fig] = plotChunkOfTrials(T(no_stim_trials & rms_trial_mvmt>160,:),'no stim with rms movement > 160 um');

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

ax = fpHm(ft,trials,forceProbe,T_params.ArduinoDuration)
ax = fpHm(ft,trials,forceProbe-neutral,T_params.ArduinoDuration)
ax = fpHm(ft,trials,forceProbe-neutral,T_params.ArduinoDuration)
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


