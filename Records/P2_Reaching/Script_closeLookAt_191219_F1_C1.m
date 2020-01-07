%% 191219_F1_C1

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
forceProbe = nan(length(trial.forceProbeStuff.CoM),length(trials));
ft = makeFrameTime(trial);
for t = 1:length(trials)
    tr = trials(t);
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
    if isfield(trial,'forceProbeStuff')
        if length(trial.forceProbeStuff.CoM(1,:))==size(forceProbe,1)
            if trial.forceProbeStuff.CoM(1,:) > trial.forceProbeStuff.CoM(2,:)
                forceProbe(:,t) = trial.forceProbeStuff.CoM(1,:);
            else
                forceProbe(:,t) = trial.forceProbeStuff.CoM(2,:);
            end
            
        else
            forceProbe(1:length(trial.forceProbeStuff.CoM(1,:)),t) = trial.forceProbeStuff.CoM(1,:);
        end
    end
end

figure;
ax1 = subplot(1,1,1);
s1 = pcolor(ax1,ft,trials,forceProbe');
s1.EdgeColor = 'flat';
colormap(ax1,'parula')
clrbr = colorbar(ax1);
xlabel(ax1,'Time (s)');
ylabel(ax1,'Trial #');

ax1.NextPlot = 'add';
ad = TP.ArduinoDuration;
plot(ax1,ad,trials,'.','color',[1,1,1])

ax1.Parent.Color = [0 0 0];
ax1.YColor = [1 1 1];
ax1.XColor = [1 1 1];
clrbr.Color = [1 1 1];
clrbr.Label.String = '\Delta (\mum)';

%% Probe force bins:

ubins = linspace(750,1250,60);
vbins = linspace(-6000,6000,40);

%% Where is neutral?

histfig = figure;
hax = subplot(1,1,1,'parent',histfig); hax.NextPlot = 'add';
xlabel(hax, 'Force Probe');
ylabel(hax, 'Counts');


% assume it is where the probe is resting when the fly is resting
neutralpnts = forceProbe(:,144:148);
neutral = mean(neutralpnts(:));

histogram(hax,neutralpnts,ubins,'Normalization','countdensity','DisplayStyle','stairs','displayname','neutrpnts');
drawnow
plot(hax,[neutral neutral],[0 hax.YLim(2)],'color','red');

%% Where is the threshold?
figure
ax = subplot(1,1,1); ax.NextPlot = 'add';
fp_off = trials*nan;
for t = 1:length(trials)
    if ~isnan(TP.ArduinoDuration(t))
        ft_off = find(ft<TP.ArduinoDuration(t),1,'last');
        if ft_off<845-20
            fp_off(t) = forceProbe(ft_off,t);
            plot(ax,forceProbe(ft_off-20:ft_off+20,t))
        end
    end
end

histogram(hax,fp_off,ubins,'Normalization','count','DisplayStyle','stairs','displayname','allthresh');


% end

%% Look at different stretches of trials

block{1} = [1:40]; % low forces (349)
block{2} = [52:91]; % Kick (276)
block{3} = [98:137]; % low force threshold (336)
block{4} = [149:188]; % high force threshold (276)
block{5} = [215:219]; % resting
block{6} = [220:259]; % kicking
block{7} = [41,92,138];
%%
delete(findobj(hax,'displayname','allthresh'));
delete(findobj(hax,'displayname','neutrpnts'));

for b = 1:length(block)
    btrs = block{b};
    histogram(hax,fp_off(btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b)]);
end

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

%% Save the thresholds back in to the trials. Then we can display them in quickshow

for b = 1:6
    btrs = block{b};
    fprintf('Saving block %d trials with thresh %g\n',b,blckthresh(b));

    for t = 1:length(btrs)
        tr = btrs(t);
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        fprintf('\ttrial %d with thresh %g\n',tr,blckthresh(b));
        if isfield(trial,'forceProbeStuff')
            trial.forceProbeStuff.ProbeLimits = [min(forceProbe(:)) max(forceProbe(:))];
            trial.forceProbeStuff.Neutral = neutral;
            trial.forceProbeStuff.ArduinoThresh = blckthresh(b);
            save(trial.name,'-struct','trial');
        end
    end
end    

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



%% Now look at probe distribution in different parts of each block.
% Ignore the training period, just compare 2 - high, 3 - low, 4 - high

for b = 3%:4
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
    
    histogram(bhpax,forceProbe(ft_win,btrs(1:pt1)),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt 1']);
    histogram(bhpax,forceProbe(ft_win,btrs(end-pt1:end)),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt end']);

    plot(bhpax,[lowthrsh lowthrsh],[0 bhpax.YLim(2)],'displayname','low');
    plot(bhpax,[highthrsh highthrsh],[0 bhpax.YLim(2)],'displayname','high');

    if blckthresh(b)==lowthrsh
        set(findobj(bhpax,'displayname','low'),'linewidth',4);
    else
        set(findobj(bhpax,'displayname','high'),'linewidth',4);        
    end
    
    legend('toggle')
    legend('boxoff')
    
    
end








