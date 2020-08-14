%% 191219_F1_C1
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
T{1,:} = {'200705_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
T{1,:} = {'200705_F2_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
T{1,:} = {'200705_F3_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'200712_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};
% T{1,:} = {'200712_F2_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'};

T_Reach = T;

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
        forceProbe(1:length(trial.forceProbeStuff.CoM(1,:)),t) = trial.forceProbeStuff.CoM(1,:);
    end
end

%% Look at different stretches of trials
clear blocks
blocks{1} = [1:40]; % extend (890) % neurtal is around 419
blocks{2} = [47:86]; % extend (890)
blocks{3} = [93:132]; % extend (340)
blocks{4} = [139:178]; % flex (340)
blocks{5} = [185:224]; % flex (340)
blocks{6} = [231:270]; % flex (340)
blocks{7} = [277:316]; % extend (890)

direction = {
    'extend'
    'extend'
    'extend'
    'flex'
    'flex'
    'flex'
    'extend'
    };


probetrials{1} = [41,87,133,179,225,271,317]; % probe trials

blckclrs = fire(length(blocks)+1); blckclrs = blckclrs(2:length(blocks)+1,:);

%% Where is the threshold?
% Weird but the sampling rate was ~160, instead of 170
figure
ax = subplot(1,1,1); ax.NextPlot = 'add';
fp_off = trials*nan;
for t = 1:length(trials)
    if ~isnan(TP.ArduinoDuration(t))
        ft_off = find(ft<TP.ArduinoDuration(t),1,'last');
        if ft_off<799-20
            fp_off(t) = forceProbe(ft_off,t);
            plot(ax,forceProbe(ft_off-20:ft_off+20,t))
        end
    end
end

%% Probe force bins:

ubins = linspace(min(forceProbe(:)),max(forceProbe(:)),60);
vbins = linspace(-6000,6000,40);

%% Where is neutral?

histfig = figure; 
histfig.Position = [[680 243 560 735]];
hax = subplot(3,1,1,'parent',histfig); hax.NextPlot = 'add';
xlabel(hax, 'Force Probe');
ylabel(hax, 'Counts');


% assume it is where the probe is resting when the fly is resting
neutralpnts = forceProbe(:,ft>-.02&ft<=0);
neutral = mean(neutralpnts(:));

histogram(hax,neutralpnts,ubins,'Normalization','countdensity','DisplayStyle','stairs','displayname','neutrpnts');
drawnow
plot(hax,[neutral neutral],[0 hax.YLim(2)],'color','red','displayname','neutral');
ntrl = findobj(hax,'displayname','neutral');

histogram(hax,fp_off,ubins,'Normalization','count','DisplayStyle','stairs','displayname','allthresh');

% delete(findobj(hax,'displayname','allthresh'));
% delete(findobj(hax,'displayname','neutrpnts'));

hbax = subplot(3,1,2,'parent',histfig); hbax.NextPlot = 'add';
n1 = copyobj(ntrl,hbax); n1.YData = [0 10];
hbax = subplot(3,1,3,'parent',histfig); hbax.NextPlot = 'add';
n2 = copyobj(ntrl,hbax); n2.YData = [0 10];

for b = 1:length(blocks)
    btrs = blocks{b};
    if strcmp(direction{b},'extend') 
        hbax = subplot(3,1,2,'parent',histfig);
        histogram(hbax,fp_off(btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b)]);
    elseif strcmp(direction{b},'flex')
        hbax = subplot(3,1,3,'parent',histfig);
        histogram(hbax,fp_off(btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b)]);
    end
end

hbax = subplot(3,1,2,'parent',histfig); hbax.NextPlot = 'add';
legend('toggle')
legend('boxoff')

hbax = subplot(3,1,3,'parent',histfig); 
legend('toggle')
legend('boxoff')

%% Plot the blocks on the heatmap overview.

% ax = fpHm(ft,trials,forceProbe,TP.ArduinoDuration);
% ax = fpHm(ft,trials,forceProbe-neutral,TP.ArduinoDuration);
ax = fpHm(ft,trials,forceProbe,TP.ArduinoDuration);

% Put rectangles on to indicate block number
% for b = 1:length(blocks)-1
%     btrs = blocks{b};
%     rectangle(ax,'Position',[ax.XLim(1) btrs(1) diff(ax.XLim) diff([btrs(1), btrs(end)])],'EdgeColor',blckclrs(b,:),'LineWidth',4)
% end

% Or put rectangles on to indicate direction
direction_clrs = [
    1 0 0
    0 1 1
    ];
directions = unique(direction);
for b = 1:length(blocks)
    btrs = blocks{b};
    rectangle(ax,'Position',[ax.XLim(1) btrs(1) diff(ax.XLim) diff([btrs(1), btrs(end)])],...
        'EdgeColor',direction_clrs(contains(directions,direction{b}),:),'LineWidth',4)
end



%% Plot blocks minus neutral, if such a thing makes sense
blckclrs = fire(12); %blckclrs = [blckclrs(1:3,:);blckclrs(2:5,:)];
ax = fpHm(ft,trials,forceProbe-neutral,TP.ArduinoDuration);
for b = 4:10
    btrs = blocks{b};
    rectangle(ax,'Position',[ax.XLim(1) btrs(1) diff(ax.XLim) diff([btrs(1), btrs(end)])],'EdgeColor',blckclrs(b,:),'LineWidth',4)
end


%% Calculate thresholds

pullthrsh = 978.8;
kickthrsh = 843;

% pulling blocks
for blck = find(contains(direction,'flex'))
    blck3 = findobj(hax,'displayname','block 3');
    blckthresh(blck) = pullthrsh;
end

for blck = [5 6]
    blck3 = findobj(hax,'displayname','block 3');
    blckthresh(blck) = kickthrsh;
end

% from the notes, blck 5 and 6 were around 874, block 9 was not clear. Then block 2 ~819 and 3 ~834 
blckthresh(2) = 928;
blckthresh(3) = 911;

kickclr = [.2 1 .5];
pullclr = [0 .7 .8];


%% Save the thresholds back in to the trials. Then we can display them in quickshow
% 
% for b = 1:7
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

%% Now look at probe distribution in different blocks.
% Ignore the training period, just compare 4 - pull, 5 - kick, 6 - kick, 7
% - pull

hpax = blckHistFig();
xlabel(hpax, 'Force Probe');
ylabel(hpax, 'Counts');

for b = 4:7
    btrs = blocks{b};
    histogram(hpax,forceProbe(:,btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b)],'edgecolor',blckclrs(b,:));
end

plot(hpax,[kickthrsh kickthrsh],[0 hpax.YLim(2)],'displayname','low','color',kickclr);
plot(hpax,[pullthrsh pullthrsh],[0 hpax.YLim(2)],'displayname','high','color',pullclr);

l = legend('show');
l.Box = 'off';
l.TextColor = [1 1 1];
    
[pullax,kickax] = blckTrcFig;
title(pullax,'pull','color',[1 1 1])
for b = [4, 7]
    trs = blocks{b};
    putTraces(pullax, Dir, trialStem, trs,blckclrs(b,:))
end

title(kickax,'kick','color',[1 1 1])
for b = [6,5]
    trs = blocks{b};
    putTraces(kickax, Dir, trialStem, trs,blckclrs(b,:))
end

plot(pullax,pullax.XLim,pullthrsh *[1, 1],'displayname','pull','color',[.5 .85 1],'linewidth',2);
plot(kickax,pullax.XLim,pullthrsh *[1, 1],'displayname','pull','color',[.5 .85 1],'linewidth',2);
plot(pullax,kickax.XLim,kickthrsh *[1, 1],'displayname','kick','color',[.5 1 .95],'linewidth',2);
plot(kickax,kickax.XLim,kickthrsh *[1, 1],'displayname','kick','color',[.5 1 .95],'linewidth',2);

ylims = [min([pullax.YLim,kickax.YLim]), max([pullax.YLim,kickax.YLim])];
pullax.YLim = ylims; kickax.YLim = ylims;

xlabel('Time (s)')
ylabel('Probe')

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

function ax = putTraces(ax, Dir, trialStem, trs, clr)
trial = load(fullfile(Dir,sprintf(trialStem, trs(1))));
ft = makeFrameTime(trial);
for tr = trs
    trial = load(fullfile(Dir,sprintf(trialStem, tr)));
    if trial.forceProbeStuff.CoM(1,:) > trial.forceProbeStuff.CoM(2,:)
        l = plot(ax,ft,trial.forceProbeStuff.CoM(1,:),'color',clr);
    else
        l = plot(ax,ft,trial.forceProbeStuff.CoM(2,:),'color',clr);
    end
    if tr == trs(1)
        l.LineWidth = 2;
    end
end
end

