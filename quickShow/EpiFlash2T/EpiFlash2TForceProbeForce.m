function h = EpiFlash2TForceProbeForce(h,handles,savetag)

if ~isfield(handles.trial,'forceProbeStuff');
    fprintf('No profiles\n');
    beep
    return
else
    I_profile = handles.trial.forceProbeStuff.keimograph;
end

set(h,'tag',mfilename);
trial = handles.trial;
x = makeTime(trial.params);

switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   

y = trial.(invec1);
ax = subplot(4,1,1,'parent',h);  cla(ax,'reset')
plot(ax,x,y,'color',[.7 0 0],'tag',savetag);
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
text(-.09,mean(mean(y(x<0),2),1),...
    [num2str(trial.params.ndf)],... 
    'fontsize',7,'parent',ax,'tag',savetag)
box(ax,'off');
set(ax,'TickDir','out');
%ylabel(ax,y_units);
[prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);
title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]));
set(ax,'tag','response_ax');

y = trial.(invec2);
ax = subplot(4,1,2,'parent',h);  cla(ax,'reset')
plot(ax,x,y,'color',[.7 0 0],'tag',savetag);
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
text(-.09,mean(mean(y(x<0),2),1),...
    [num2str(trial.params.ndf)],... 
    'fontsize',7,'parent',ax,'tag',savetag)
box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','response_ax2');

% ax = subplot(3,1,3,'parent',h); cla(ax,'reset')
% plot(ax,x,EpiFlashStim(trial.params),'color',[0 0 1],'tag',savetag); hold on;
% box(ax,'off');
% set(ax,'TickDir','out');
xlim(ax,[-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
% % xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
% set(ax,'tag','stimulus_ax');

h2 = postHocExposure(trial,size(I_profile,2));
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

ax = subplot(2,1,2,'parent',h);
plot(ax,frame_times,k*y)
hold on
plot(ax,frame_times,c*y_d)
plot(ax,frame_times,m*y_dd)
axis(ax,'tight')
xlim(ax,[-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
% ylim(ax,[-1E-6 12E-6])
legend({'ky','cy''','my'''''})
xlabel(ax,'s')
ylabel(ax,'F (N)')

% ax = subplot(2,1,1,'parent',h);
% plot(ax,frame_times,F,'linewidth',1)
% axis(ax,'tight')
% xlim(ax,[-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
% ylim(ax,[-1E-6 12E-6])
% xlabel(ax,'s')
% ylabel(ax,'F (N)')

