close all
traject_fig = figure;
set(traject_fig,'color',[0 0 0],'units','inches','position',[4 2 8 6]);

panl = panel(traject_fig);
panl.pack('v',{1/6 1/6 2/3})  % Ca, Bar
panl(3).pack('h',{1/2 1/2})  % phase plot
panl(3,2).pack('v',{1/2 1/2})  % trject ex
panl.margin = [18 16 10 10];
panl.descendants.margin = [8 8 8 8];

ca_ax = panl(1).select();
bar_ax = panl(2).select();
tr_ph_ax = panl(3,1).select();
tr_ca_ax = panl(3,2,1).select();
tr_bar_ax = panl(3,2,2).select();

clrs = [
    0       1       1           %c
    1       0.3     0.945       %m
    .43      0.5     1           %b
    0.2     1.00    0.2         %g
    1       1       0.2           %y
    ];

set(ca_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.98 max(v2(:))],'xtick',[]); hold(ca_ax,'on')
set(bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[-5 350],'xtick',[2]); hold(bar_ax,'on')

t = makeInTime(trial.params);
trial2 = postHocExposure(trial);
if size(trial2.clustertraces,1)<size(trial2.clustertraces,2)
    trial2.clustertraces = trial2.clustertraces';
end

frame_times = t(trial2.exposure); 
ft = frame_times;

frame_win = frame_times>0&frame_times<trial.params.stimDurInSec;
F_win = find(frame_win,5,'first');

v2 = trial2.clustertraces;
v2 = v2./repmat(mean(v2(F_win(2:end),:),1),size(v2,1),1);

plot(ca_ax, frame_times(frame_win),v2(frame_win,2),'color',clrs(2,:))
plot(ca_ax, frame_times(frame_win),v2(frame_win,5),'color',clrs(5,:))

origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
CoM = trial.forceProbeStuff.forceProbePosition';
CoM = CoM*x_hat;
origin = min(CoM);%handles.trial.forceProbeStuff.Origin'*x_hat;
CoM = CoM - origin;

dCoMdt = diff(CoM)./diff(frame_times);
CoM_s = CoM(2:end);
ft_ph = ft(2:end);

plot(bar_ax, frame_times(frame_win),CoM(frame_win),'color',[1 1 1])
ylabel(bar_ax,'\mum')

set(tr_ca_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.98 max(v2(:))],'xtick',[]); hold(tr_ca_ax,'on')
set(tr_bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[-5 350]); hold(tr_bar_ax,'on')
set(tr_ph_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-20 350],'ylim',1E3*[-6 6]); hold(tr_ph_ax,'on')

plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);


%% 1st trajectory
trjct_t = [0.0152 0.75];
% trjct_patch = patch([trjct_t(1) trjct_t(2) trjct_t(2) trjct_t(1)],[0 0 400 400],[1 1 1],'parent',bar_ax);
% trjct_patch.FaceAlpha = .2;
% trjct_patch.EdgeColor = 'none';
roi = plot(bar_ax,[trjct_t(1) trjct_t(1) trjct_t(2) trjct_t(2)],[0 300 300 0],'color',[1 1 1]);

trjct_win = ft>trjct_t(1)&ft<trjct_t(2);
cl1trjct = plot(tr_ca_ax, ft(trjct_win),v2(trjct_win,2),'color',clrs(2,:));
cl2trjct = plot(tr_ca_ax, ft(trjct_win),v2(trjct_win,5),'color',clrs(5,:));

brtrjct = plot(tr_bar_ax, ft(trjct_win),CoM(trjct_win),'color',[1 1 1]);

trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',[1 1 1]);

set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);

savePDF(traject_fig,savedir,[],sprintf('Trajectory_%.2f_%.2f',trjct_t(1),trjct_t(2)))

%% last trajectory
trjct_t = [3.7 4];
trjct_win = ft>trjct_t(1)&ft<trjct_t(2);
trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);

roi.XData = [trjct_t(1) trjct_t(1) trjct_t(2) trjct_t(2)];
cl1trjct.XData = ft(trjct_win);cl1trjct.YData = v2(trjct_win,2);
cl2trjct.XData = ft(trjct_win);cl2trjct.YData = v2(trjct_win,5);

brtrjct.XData = ft(trjct_win);brtrjct.YData = CoM(trjct_win);
phtrjct.XData = CoM_s(trjct_ph_win);phtrjct.YData = dCoMdt(trjct_ph_win);

set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);

savePDF(traject_fig,savedir,[],sprintf('Trajectory_%.2f_%.2f',trjct_t(1),trjct_t(2)))

%% 2nd to last trajectory
trjct_t = [3.1 3.8];
trjct_win = ft>trjct_t(1)&ft<trjct_t(2);
trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);

roi.XData = [trjct_t(1) trjct_t(1) trjct_t(2) trjct_t(2)];
cl1trjct.XData = ft(trjct_win);cl1trjct.YData = v2(trjct_win,2);
cl2trjct.XData = ft(trjct_win);cl2trjct.YData = v2(trjct_win,5);

brtrjct.XData = ft(trjct_win);brtrjct.YData = CoM(trjct_win);
phtrjct.XData = CoM_s(trjct_ph_win);phtrjct.YData = dCoMdt(trjct_ph_win);

set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);

savePDF(traject_fig,savedir,[],sprintf('Trajectory_%.2f_%.2f',trjct_t(1),trjct_t(2)))

%% 2nd trajectory
trjct_t = [1.02 1.49];
trjct_win = ft>trjct_t(1)&ft<trjct_t(2);
trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);

roi.XData = [trjct_t(1) trjct_t(1) trjct_t(2) trjct_t(2)];
cl1trjct.XData = ft(trjct_win);cl1trjct.YData = v2(trjct_win,2);
cl2trjct.XData = ft(trjct_win);cl2trjct.YData = v2(trjct_win,5);

brtrjct.XData = ft(trjct_win);brtrjct.YData = CoM(trjct_win);
phtrjct.XData = CoM_s(trjct_ph_win);phtrjct.YData = dCoMdt(trjct_ph_win);

set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);

savePDF(traject_fig,savedir,[],sprintf('Trajectory_%.2f_%.2f',trjct_t(1),trjct_t(2)))


%% 2nd and 3rd trajectory
trjct_t = [1.02 1.66];
trjct_win = ft>trjct_t(1)&ft<trjct_t(2);
trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);

roi.XData = [trjct_t(1) trjct_t(1) trjct_t(2) trjct_t(2)];
cl1trjct.XData = ft(trjct_win);cl1trjct.YData = v2(trjct_win,2);
cl2trjct.XData = ft(trjct_win);cl2trjct.YData = v2(trjct_win,5);

brtrjct.XData = ft(trjct_win);brtrjct.YData = CoM(trjct_win);
phtrjct.XData = CoM_s(trjct_ph_win);phtrjct.YData = dCoMdt(trjct_ph_win);

set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);

savePDF(traject_fig,savedir,[],sprintf('Trajectory_%.2f_%.2f',trjct_t(1),trjct_t(2)))
