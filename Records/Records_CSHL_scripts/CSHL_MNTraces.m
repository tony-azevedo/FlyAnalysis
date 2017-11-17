close all
mn_fig = figure;
set(mn_fig,'color',[0 0 0],'units','inches','position',[4 2 8 6]);

panl = panel(mn_fig);
panl.pack('h',{1/2 1/2})  % MN, EMG, Bar
panl(1).pack('v',{1/6 1/6 1/6})  % MN, EMG, Bar
panl(2).pack('v',{1/6 1/6 1/6})  % MN, EMG, Bar
% panl(3).pack('h',{1/2 1/2})  % phase plot
% panl(3,2).pack('v',{1/2 1/2})  % trject ex
panl.margin = [18 16 10 10];
panl.descendants.margin = [8 8 8 8];

for tr = 1:2

mn_ax = panl(tr,1).select();
emg_ax = panl(tr,2).select();
bar_ax = panl(tr,3).select();
% tr_ph_ax = panl(3,1).select();
% tr_ca_ax = panl(3,2,1).select();
% tr_bar_ax = panl(3,2,2).select();

% clrs = [
%     0       1       1           %c
%     1       0.3     0.945       %m
%     .43      0.5     1           %b
%     0.2     1.00    0.2         %g
%     1       1       0.2           %y
%     ];

t = makeInTime(trials(1).params);
trial2 = postHocExposure(trials(1));

frame_times = t(trial2.exposure); 
ft = frame_times;

t_i_f = [-.05 .2];
t_win = t>-.05&t<.2;
frame_win = frame_times>t_i_f(1)&frame_times<t_i_f(2);

origin = find(trials(tr).forceProbeStuff.EvalPnts(1,:)==0&trials(tr).forceProbeStuff.EvalPnts(2,:)==0);
x_hat = trials(tr).forceProbeStuff.EvalPnts(:,origin+1);
CoM = trials(tr).forceProbeStuff.forceProbePosition';
CoM = CoM*x_hat;
origin = min(CoM(3:end));%handles.trial.forceProbeStuff.Origin'*x_hat;
CoM = CoM - origin;

dCoMdt = diff(CoM)./diff(frame_times);
CoM_s = CoM(2:end);
ft_ph = ft(2:end);

mnylim = mean([min(trials(tr).voltage_1(:)) max(trials(tr).voltage_1(:))])+diff([min(trials(tr).voltage_1(:)) max(trials(tr).voltage_1(:))])*1.1/2*[-1 1];
set(mn_ax,'color',[0 0 0],'xcolor',[0 0 0],'ycolor',[1 1 1],'tickdir','out','xlim',t_i_f,'ylim',mnylim,'xtick',[]); hold(mn_ax,'on')
set(emg_ax,'color',[0 0 0],'xcolor',[0 0 0],'ycolor',[1 1 1],'tickdir','out','xlim',t_i_f,'ylim',[min(trials(tr).current_2(:)) max(trials(tr).current_2(:))],'xtick',[]); hold(emg_ax,'on')
set(bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',t_i_f,'ylim',[-10 120],'xtick',[0 t_i_f(2)]); hold(bar_ax,'on')

plot(mn_ax, t(t_win),trials(tr).voltage_1(t_win),'color',[1 .2 .2])

plot(emg_ax, t(t_win),trials(tr).current_2(t_win),'color',[1 .2 .2])

plot(bar_ax, frame_times(frame_win),CoM(frame_win),'color',[1 1 1])
ylabel(bar_ax,'\mum')
end
%%

% set(tr_ca_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.98 max(v2(:))],'xtick',[]); hold(tr_ca_ax,'on')
% set(tr_bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[-5 350]); hold(tr_bar_ax,'on')
% set(tr_ph_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-20 350],'ylim',1E3*[-6 6]); hold(tr_ph_ax,'on')

% plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
% plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);

savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
savePDF(mn_fig,savedir,[],sprintf('spike_examples_bar'))


