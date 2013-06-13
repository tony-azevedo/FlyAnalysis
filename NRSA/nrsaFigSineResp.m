% Figure 2 of NRSA Grant, Sine Response
load('C:\Users\Anthony Azevedo\Acquisition\07-Jun-2013\07-Jun-2013_F1_C1\PiezoSine_07-Jun-2013_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Acquisition\07-Jun-2013\07-Jun-2013_F1_C1\PiezoSine_Raw_07-Jun-2013_F1_C1_1.mat')

trial = regexp(name,'_'); trial = str2num(name(trial(end)+1:end));
label = regexp(name,'\'); label = name(label(end)+1:end);
label = regexprep(label,'_','.');
label = [label ' - ' num2str(data(trial).displacement) ' V'];

% setupStimulus
stimx = ((1:data(trial).samprateout*(data(trial).preDurInSec+data(trial).stimDurInSec+data(trial).postDurInSec))-data(trial).preDurInSec*data(trial).samprateout)/data(trial).samprateout;
x = ((1:data(trial).sampratein*(data(trial).preDurInSec+data(trial).stimDurInSec+data(trial).postDurInSec))-data(trial).preDurInSec*data(trial).sampratein)/data(trial).sampratein;
voltage = voltage(1:length(x));
sgsmonitor = sgsmonitor(1:length(stimx))-sgsmonitor(end);

% displayTrial
figure(1),
ax1 = subplot(3,1,[1 2]);

redlines = findobj(1,'Color',[1, 0, 0]);
set(redlines,'color',[1 .8 .8]);
bluelines = findobj(1,'Color',[0, 0, 1]);
set(bluelines,'color',[.8 .8 1]);

%line(obj.stimx,obj.generateStimulus,'parent',ax1,'color',[0 0 1],'linewidth',1);
line(x,voltage,'parent',ax1,'color',[0 0 0],'linewidth',1);
set(ax1,'Ycolor',[0 0 0],'ylim',[-100,20],'ytick',(-100:20:20),'xlim',[-.2 .2])

box off; set(gca,'TickDir','out');
ylabel(ax1,'mV'); %xlim([0 max(t)]);
xlabel('Time (s)'); %xlim([0 max(t)]);

title(label);

ax3 = subplot(3,1,3); cla
line(stimx,sgsmonitor,'parent',ax3,'color',[0 0 0],'linewidth',1);
box off; set(gca,'TickDir','out'); axis tight
set(ax3,'ycolor',[1 1 1]*0,'ylim',[-2 2],'ytick',(-2:1:2),'xlim',[-.2 .2])
ylabel('\mum'); %xlim([0 max(t)]);
xlabel('time (s)');

title(ax1,label)
