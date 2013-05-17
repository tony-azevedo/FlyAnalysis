% quickShow_PureTones

% 1) load data from folder

% 2) load the trace you want to show
trial = 3;
obj.y = voltage;

obj.x = ((1:data(trial).sampratein*(data(trial).preDurInSec+data(trial).stimDurInSec+data(trial).postDurInSec))-data(trial).preDurInSec*data(trial).sampratein)/data(trial).sampratein;
pre = round(9/10000*data(trial).sampratein);

ramp = 0.02;
durSweep = data(trial).stimDurInSec+data(trial).preDurInSec+data(trial).postDurInSec;
obj.stimx = ((1:data(trial).samprateout*(data(trial).preDurInSec+data(trial).stimDurInSec+data(trial).postDurInSec))-data(trial).preDurInSec*data(trial).samprateout)/data(trial).samprateout;
obj.stim = zeros(size(obj.stimx));
obj.stim(data(trial).samprateout*(data(trial).preDurInSec)+1: data(trial).samprateout*(data(trial).preDurInSec+data(trial).stimDurInSec)) = 1;
obj.stim(data(trial).samprateout*(data(trial).preDurInSec):round(data(trial).samprateout*(data(trial).preDurInSec + ramp))) = (0:data(trial).samprateout*ramp)/(data(trial).samprateout*ramp);
obj.stim(round(data(trial).samprateout*(data(trial).preDurInSec+data(trial).stimDurInSec - ramp)):data(trial).samprateout*(data(trial).preDurInSec+data(trial).stimDurInSec)) = fliplr(0:data(trial).samprateout*ramp)/(data(trial).samprateout*ramp);

trialstim = data(trial).amplitude * obj.stim .* sin(data(trial).tone*2*pi*obj.stimx);


%% 
figure(1);
ax1 = subplot(3,1,[1 2]);
cla(ax1)
%line(obj.stimx,trialstim,'parent',ax1,'color',[0 0 1],'linewidth',1);
line(obj.x,obj.y(:,1),'parent',ax1,'color',[1 0 0],'linewidth',1);
box off; set(gca,'TickDir','out');

switch data(trial).recmode
    case 'VClamp'
        ylabel('I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        ylabel('V_m (mV)'); %xlim([0 max(t)]);
end

title(sprintf('Trial %g.  Pure tone - %g Hz',data(trial).trial,data(trial).tone))
ax2 = subplot(3,1,3);
cla(ax2)
line(obj.stimx,trialstim,'parent',ax2,'color',[.7 .7 .7],'linewidth',1);
%line(obj.x,obj.sensorMonitor,'parent',ax2,'color',[0 0 1],'linewidth',1);
box off; set(gca,'TickDir','out');
xlabel('Time (s)'); %xlim([0 max(t)]);

%%
figure(2);
currtone = find(data(trial).tones==data(trial).tone);
ax1 = subplot(2,length(data(trial).tones),currtone);

redlines = findobj(2,'Color',[1, 0, 0]);
set(redlines,'color',[1 .8 .8]);
bluelines = findobj(2,'Color',[0, 0, 1]);
set(bluelines,'color',[.8 .8 1]);

%line(obj.stimx,trialstim,'parent',ax1,'color',[0 0 1],'linewidth',1);
line(obj.x,obj.y(:,1),'parent',ax1,'color',[1 0 0],'linewidth',1);
box off; set(gca,'TickDir','out');axis tight

switch data(trial).recmode
    case 'VClamp'
        ylabel('I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        ylabel('V_m (mV)'); %xlim([0 max(t)]);
end
title(sprintf('Pure tone - %g Hz',data(trial).tone))

ax2 = subplot(2,length(data(trial).tones),length(data(trial).tones)+currtone);
line(obj.stimx,trialstim,'parent',ax2,'color',[.7 .7 .7],'linewidth',1);
%line(obj.x,obj.sensorMonitor,'parent',ax2,'color',[0 0 1],'linewidth',1);
box off; set(gca,'TickDir','out');axis tight

xlabel('Time (s)'); %xlim([0 max(t)]);
