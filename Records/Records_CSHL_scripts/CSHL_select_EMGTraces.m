close all
emg_traject_fig = figure;
set(emg_traject_fig,'color',[0 0 0],'units','inches','position',[4 2 8 6]);

panl = panel(emg_traject_fig);
panl.pack('v',{1/2 1/2})  % phase plot on top
panl(1).pack('h',{1/2 1/2})  % phase plot at left
panl(2).pack('h',{1/2 1/2})  % two examples
panl(2,1).pack('v',{1/3 1/3 1/3})  % emg, ca, bar 1
panl(2,2).pack('v',{1/3 1/3 1/3})  % emg, ca, bar 2

panl.margin = [18 16 10 10];
panl.descendants.margin = [8 8 8 8];

clrs = [
    0       1       1           %c
    1       0.3     0.945       %m
    .43      0.5     1           %b
    0.2     1.00    0.2         %g
    1       1       0.2           %y
    ];

t = makeInTime(trial.params);
trial2 = postHocExposure(trial);
if size(trial2.clustertraces,1)<size(trial2.clustertraces,2)
    trial2.clustertraces = trial2.clustertraces';
end

frame_times = t(trial2.exposure); 
ft = frame_times;

t_win = t>0&t<trial.params.stimDurInSec;
frame_win = frame_times>0&frame_times<trial.params.stimDurInSec;
F_win = find(frame_win,5,'first');

v2 = trial2.clustertraces;
v2 = v2./repmat(mean(v2(F_win(2:end),:),1),size(v2,1),1);

origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
CoM = trial.forceProbeStuff.forceProbePosition';
CoM = CoM*x_hat;
origin = min(CoM);%handles.trial.forceProbeStuff.Origin'*x_hat;
CoM = CoM - origin;

dCoMdt = diff(CoM)./diff(frame_times);
CoM_s = CoM(2:end);
ft_ph = ft(2:end);


tr_ph_ax = panl(1,1).select();

% set(tr_ca_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.98 max(v2(:))],'xtick',[]); hold(tr_ca_ax,'on')
% set(tr_bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[-5 350]); hold(tr_bar_ax,'on')
set(tr_ph_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-20 350],'ylim',1E3*[-6 6]); hold(tr_ph_ax,'on')

plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);

savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% savePDF(emg_fig,savedir,[],sprintf('emg_ca_bar'))

%% 2nd to last trajectory
trjct_t = [3.1 3.8];

tr_emg_ax = panl(2,2,1).select();
tr_ca_ax = panl(2,2,2).select();
tr_bar_ax = panl(2,2,3).select();

set(tr_emg_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[min(trial.current_2(:)) max(trial.current_2(:))],'xtick',[]); hold(tr_emg_ax,'on')
set(tr_ca_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.98 max(v2(:))],'xtick',[]); hold(tr_ca_ax,'on')
set(tr_bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[-5 350]); hold(tr_bar_ax,'on')

trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
emgtrjct = plot(tr_emg_ax, t(trjct_twin),trial.current_2(trjct_twin),'color',[1 0 0]);

cl1trjct = plot(tr_ca_ax, ft(trjct_win),v2(trjct_win,2),'color',clrs(2,:));
cl2trjct = plot(tr_ca_ax, ft(trjct_win),v2(trjct_win,5),'color',clrs(5,:));

brtrjct = plot(tr_bar_ax, ft(trjct_win),CoM(trjct_win),'color',[1 1 1]);

trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',[1 1 1]);

set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);

%savePDF(emg_traject_fig,savedir,[],sprintf('Trajectory_EMG_%.2f_%.2f',trjct_t(1),trjct_t(2)))

%% 2nd trajectory
trjct_t = [1.02 1.77];

tr_emg_ax = panl(2,1,1).select();
tr_ca_ax = panl(2,1,2).select();
tr_bar_ax = panl(2,1,3).select();

set(tr_emg_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[min(trial.current_2(:)) max(trial.current_2(:))],'xtick',[]); hold(tr_emg_ax,'on')
set(tr_ca_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.98 max(v2(:))],'xtick',[]); hold(tr_ca_ax,'on')
set(tr_bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[-5 350]); hold(tr_bar_ax,'on')

trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
emgtrjct = plot(tr_emg_ax, t(trjct_twin),trial.current_2(trjct_twin),'color',[1 0 0]);

cl1trjct = plot(tr_ca_ax, ft(trjct_win),v2(trjct_win,2),'color',clrs(2,:));
cl2trjct = plot(tr_ca_ax, ft(trjct_win),v2(trjct_win,5),'color',clrs(5,:));

brtrjct = plot(tr_bar_ax, ft(trjct_win),CoM(trjct_win),'color',[1 1 1]);

trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',[1 1 1]);

set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);

savePDF(emg_traject_fig,savedir,[],sprintf('Trajectory_EMG_%.2f_%.2f',trjct_t(1),trjct_t(2)))

