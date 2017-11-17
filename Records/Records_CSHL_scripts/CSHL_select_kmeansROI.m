fluof = figure;
set(fluof,'color',[0 0 0],'position',[680    86   854   892]);

panl = panel(fluof);
panl.pack('v',5)  % response panel, stimulus panel
panl.margin = [18 16 20 10];
panl.fontname = 'Arial';

tidmax = panl(1).select();
tidexmax = panl(2).select();
tilexmax = panl(3).select();
tilmax = panl(4).select();

barmax = panl(5).select();

clrs = [
    0       1       1           %c
    1       0.3     0.945       %m
    .43      0.5     1           %b
    0.2     1.00    0.2         %g
    1       1       0.2           %y
    ];

set(tidmax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.9 max(v2(:))]); hold(tidmax,'on')
set(tilmax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.9 max(v2(:))]); hold(tilmax,'on')
set(tidexmax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.9 max(v2(:))]); hold(tidexmax,'on')
set(tilexmax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','ylim',[.9 max(v2(:))]); hold(tilexmax,'on')

set(barmax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out'); hold(barmax,'on')

t = makeInTime(trial.params);
trial2 = postHocExposure(trial);
if size(trial2.clustertraces,1)<size(trial2.clustertraces,2)
    trial2.clustertraces = trial2.clustertraces';
end

frame_times = t(trial2.exposure); 
frame_win = frame_times>0&frame_times<trial.params.stimDurInSec;
F_win = find(frame_win,5,'first');

v2 = trial2.clustertraces;
v2 = v2./repmat(mean(v2(F_win(2:end),:),1),size(v2,1),1);

plot(tidmax, frame_times(frame_win),v2(frame_win,2),'color',clrs(2,:))
plot(tidmax, frame_times(frame_win),v2(frame_win,5),'color',clrs(5,:))
plot(tidexmax, frame_times(frame_win),v2(frame_win,3),'color',clrs(3,:))
plot(tilexmax, frame_times(frame_win),v2(frame_win,4),'color',clrs(4,:))
plot(tilmax, frame_times(frame_win),v2(frame_win,1),'color',clrs(1,:))

plot(tilmax, frame_times(frame_win),v2(frame_win,1),'color',clrs(1,:))

origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
CoM = trial.forceProbeStuff.forceProbePosition';
CoM = CoM*x_hat;
origin = min(CoM);%handles.trial.forceProbeStuff.Origin'*x_hat;
CoM = CoM - origin;

plot(barmax, frame_times(frame_win),CoM(frame_win),'color',[1 1 1])
ylabel(barmax,'\mum')
%ylim(barmax,[-1 400])

panl.fontname = 'Arial';
panl.fontsize = 18;