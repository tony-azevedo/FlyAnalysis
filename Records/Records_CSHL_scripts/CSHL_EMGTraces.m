close all
emg_fig = figure;
set(emg_fig,'color',[0 0 0],'units','inches','position',[4 2 8 6]);

panl = panel(emg_fig);
panl.pack('v',{1/6 1/6 1/6})  % Ca, Bar, EMG
% panl(3).pack('h',{1/2 1/2})  % phase plot
% panl(3,2).pack('v',{1/2 1/2})  % trject ex
panl.margin = [18 16 10 10];
panl.descendants.margin = [8 8 8 8];

emg_ax = panl(1).select();
ca_ax = panl(2).select();
bar_ax = panl(3).select();
% tr_ph_ax = panl(3,1).select();
% tr_ca_ax = panl(3,2,1).select();
% tr_bar_ax = panl(3,2,2).select();

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

set(emg_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-.2 4.2],'ylim',[min(trial.current_2(:)) max(trial.current_2(:))],'xtick',[]); hold(emg_ax,'on')
set(ca_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-.2 4.2],'ylim',[.98 max(v2(:))],'xtick',[]); hold(ca_ax,'on')
set(bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-.2 4.2],'ylim',[-5 350],'xtick',[2]); hold(bar_ax,'on')

plot(emg_ax, t,trial.current_2,'color',[1 .2 .2])

plot(ca_ax, frame_times(frame_win),v2(frame_win,2),'color',clrs(2,:))
plot(ca_ax, frame_times(frame_win),v2(frame_win,5),'color',clrs(5,:))

plot(bar_ax, frame_times(frame_win),CoM(frame_win),'color',[1 1 1])
ylabel(bar_ax,'\mum')

% set(tr_ca_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.98 max(v2(:))],'xtick',[]); hold(tr_ca_ax,'on')
% set(tr_bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[-5 350]); hold(tr_bar_ax,'on')
% set(tr_ph_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-20 350],'ylim',1E3*[-6 6]); hold(tr_ph_ax,'on')

% plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
% plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);

savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
savePDF(emg_fig,savedir,[],sprintf('emg_ca_bar'))


