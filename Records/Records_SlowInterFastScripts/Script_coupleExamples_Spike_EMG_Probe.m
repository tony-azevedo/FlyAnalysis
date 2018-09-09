
mn_fig = figure('color',[1 1 1],'units','inches','position',[4 2 8 6]);
% set(mn_fig,'color',[0 0 0],'units','inches','position',[4 2 8 6]);

panl = panel(mn_fig);
panl.pack('h',{1/2 1/2})  % MN, EMG, Bar
panl(1).pack('v',{1/6 1/6 1/6})  % MN, EMG, Bar
panl(2).pack('v',{1/6 1/6 1/6})  % MN, EMG, Bar
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

CoM = trials(tr).forceProbeStuff.CoM;

dCoMdt = diff(CoM)./diff(frame_times);
CoM_s = CoM(2:end);
ft_ph = ft(2:end);

mnylim = mean([min(trials(tr).voltage_1(:)) max(trials(tr).voltage_1(:))])+diff([min(trials(tr).voltage_1(:)) max(trials(tr).voltage_1(:))])*1.1/2*[-1 1];
mn_ax.TickDir = 'out';
mn_ax.XLim = t_i_f;
mn_ax.YLim = mnylim;
mn_ax.XTick = []; 
hold(mn_ax,'on')

emg_ax.TickDir = 'out';
emg_ax.XLim = t_i_f;
emg_ax.YLim = [min(trials(tr).current_2(:)) max(trials(tr).current_2(:))];
emg_ax.XTick = []; 
hold(emg_ax,'on')

bar_ax.TickDir = 'out';
bar_ax.XLim = t_i_f;
% bar_ax.YLim = [-10 120];
bar_ax.XTick = [0 t_i_f(2)]; 
hold(bar_ax,'on')

plot(mn_ax, t(t_win),trials(tr).voltage_1(t_win),'color',[.7 0 0])

plot(emg_ax, t(t_win),trials(tr).current_2(t_win),'color',[.7 0 0])

plot(bar_ax, frame_times(frame_win),CoM(frame_win),'color',[0 0 0])
ylabel(bar_ax,'\mum')
end