function quickShow_CurrentSteps(plotcanvas,obj,savetag)

obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage(1:length(obj.x));
current = obj.trial.current(1:length(obj.x));

obj.stimx = ((1:obj.params.samprateout*(obj.params.preDurInSec+obj.params.stimDurInSec+obj.params.postDurInSec))-obj.params.preDurInSec*obj.params.samprateout)/obj.params.samprateout;
obj.stim = zeros(size(obj.stimx));
obj.stim(obj.params.sampratein*(obj.params.preDurInSec)+1: obj.params.sampratein*(obj.params.preDurInSec+obj.params.stimDurInSec)) = 1;
obj.x = ((1:obj.params.sampratein*(obj.params.preDurInSec+obj.params.stimDurInSec+obj.params.postDurInSec))-obj.params.preDurInSec*obj.params.samprateout)/obj.params.sampratein;

%
ax1 = subplot(3,1,[1 2],'parent',plotcanvas);
line(obj.x,voltage,'parent',ax1,'color',[1 0 0],'linewidth',1,'tag',savetag);
box(ax1,'off'); set(ax1,'TickDir','out'); 
ylabel(ax1,'V_m (mV)'); 
%xlabel(ax1,'Time (s)'); 

ax2 = subplot(3,1,3,'parent',plotcanvas);
line(obj.stimx,current(1:length(obj.stimx)),'parent',ax2,'color',[0 0 1],'linewidth',1,'tag',savetag);
line(obj.stimx,obj.params.step*obj.stim,'parent',ax2,'color',[.75 .75 .75],'linewidth',1,'tag',savetag);
box(ax2,'off'); set(ax2,'TickDir','out'); 
ylabel(ax2,'I (pA)'); 
xlabel(ax2,'Time (s)'); 
