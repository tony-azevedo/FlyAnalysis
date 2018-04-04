function h = EpiFlash2TForceVsDistance(h,handles,savetag)

if ~isfield(handles.trial,'forceProbeStuff');
    fprintf('No profiles\n');
    beep
    return
end

set(h,'tag',mfilename);
trial = handles.trial;
x = makeTime(trial.params);

h2 = postHocExposure(trial,size(trial.forceProbeStuff.forceProbePosition,2));
frame_times = x(h2.exposure);

origin = find(handles.trial.forceProbeStuff.EvalPnts(1,:)==0&handles.trial.forceProbeStuff.EvalPnts(2,:)==0);
x_hat = handles.trial.forceProbeStuff.EvalPnts(:,origin+1);
CoM = handles.trial.forceProbeStuff.forceProbePosition';
CoM = CoM*x_hat;

CoM = CoM-mean(CoM(CoM<=quantile(CoM,.15)));

dt = mean(diff(frame_times));
y = CoM*1E-6;
y_d = gradient(y,dt);
y_dd = gradient(y_d,dt);

k = 0.2234; % N/m
m = 0.1702*1E-6; %[mg/s/s]/[1/s/s] = [mg];
c = 0.1377*1E-3;

F = m*y_dd + m*y_d + k*y;

ax = subplot(1,1,1,'parent',h); cla(ax)
plot(ax,y,F)
hold on
plot(ax,y(frame_times>0&frame_times<.08),F(frame_times>0&frame_times<.08),'+')

% plot(ax,frame_times,c*y_d)
% plot(ax,frame_times,m*y_dd)
% axis(ax,'tight')
% xlim(ax,[-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
% % ylim(ax,[-1E-6 12E-6])
% legend({'ky','cy''','my'''''})
xlabel(ax,'s')
ylabel(ax,'F (N)')

A = polyarea(y,F);
text(0, 0, sprintf('Area = %g J',A),'tag',savetag);
% ax = subplot(2,1,1,'parent',h);
% plot(ax,frame_times,F,'linewidth',1)
% axis(ax,'tight')
% xlim(ax,[-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
% ylim(ax,[-1E-6 12E-6])
% xlabel(ax,'s')
% ylabel(ax,'F (N)')

