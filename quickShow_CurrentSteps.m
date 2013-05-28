% quickShow_CurrentSteps

% 1) load data from folder

% 2) load the trial you want to show
trials = (12:14);
% FlySoundProtocol

D = ['C:\Users\Anthony Azevedo\Acquisition\',data(1).date,'\',...
    data(1).date,'_F',data(1).flynumber,'_C',data(1).cellnumber];
namebase = [D,'\CurrentSteps_Raw_', ...
    data(1).date,'_F',data(1).flynumber,'_C',data(1).cellnumber,'_'];

for trial = trials
load([namebase,num2str(trial),'.mat']);
obj.y = voltage;

data(trial).durSweep = data(trial).stimDurInSec+data(trial).preDurInSec+data(trial).postDurInSec;
obj.stimx = ((1:data(trial).samprateout*(data(trial).preDurInSec+data(trial).stimDurInSec+data(trial).postDurInSec))-data(trial).preDurInSec*data(trial).samprateout)/data(trial).samprateout;
obj.stim = zeros(size(obj.stimx));
obj.stim(data(trial).sampratein*(data(trial).preDurInSec)+1: data(trial).sampratein*(data(trial).preDurInSec+data(trial).stimDurInSec)) = 1;
obj.x = ((1:data(trial).sampratein*(data(trial).preDurInSec+data(trial).stimDurInSec+data(trial).postDurInSec))-data(trial).preDurInSec*data(trial).samprateout)/data(trial).sampratein;

nA = data(trial).step/1000;

trialstim = obj.stim * nA;

trialstim = (trialstim-data(trial).daqout_to_current_offset)/data(trial).daqout_to_current;

% subtract some voltage to remove the static current
DAQ_V_to_subtract_static_current = data(trial).daqCurrentOffset/data(trial).daqout_to_current;
trialstim = trialstim - DAQ_V_to_subtract_static_current;

%
figure(1);
ax1 = subplot(4,1,[2 3 4]);

redlines = findobj(1,'Color',[1, 0, 0]);
set(redlines,'color',[1 .8 .8]);
bluelines = findobj(1,'Color',[0, 0, 1]);
set(bluelines,'color',[.8 .8 1]);
greylines = findobj(1,'Color',[.6 .6 .6]);
set(greylines,'color',[.8 .8 .8]);
pinklines = findobj(1,'Color',[.5 1 1]);
set(pinklines,'color',[.8 .8 .8]);

%line(obj.stimx,obj.generateStimulus,'parent',ax1,'color',[0 0 1],'linewidth',1);
line(obj.x,obj.y(1:length(obj.x),1),'parent',ax1,'color',[1 0 0],'linewidth',1);
box off; set(gca,'TickDir','out');
ylabel('V_m (mV)'); %xlim([0 max(t)]);
xlabel('Time (s)'); 
% xlim([-.01 .05]);
% xlim([0.5-.03 0.5+.03]);

ax2 = subplot(4,1,1);
line(obj.stimx,current(1:length(obj.stimx)),'parent',ax2,'color',[.6 .6 .6],'linewidth',1);
line(obj.stimx,data(trial).step*obj.stim,'parent',ax2,'color',[.5 1 1],'linewidth',1);
box off; set(gca,'TickDir','out');
ylabel('I (pA)'); %xlim([0 max(t)]);
title(['trials ' num2str(trials)])
% xlim([-.01 .05]);
% xlim([0.5-.03 0.5+.03]);
% 
end