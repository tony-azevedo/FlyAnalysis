function quickShow_PiezoChirp(plotcanvas,obj,savetag)

x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;
x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

obj.stimx = ((1:obj.params.samprateout*(obj.params.preDurInSec+obj.params.stimDurInSec+obj.params.postDurInSec))-obj.params.preDurInSec*obj.params.samprateout)/obj.params.samprateout;
obj.stimx = obj.stimx(:);

stim = (1:obj.params.samprateout*(obj.params.preDurInSec+obj.params.stimDurInSec+obj.params.postDurInSec));
stim = stim(:);
stim(:) = 0;

stimpnts = obj.params.samprateout*obj.params.preDurInSec+1:...
    obj.params.samprateout*(obj.params.preDurInSec+obj.params.stimDurInSec);

w = window(@triang,2*obj.params.ramptime*obj.params.samprateout);
w = [w(1:obj.params.ramptime*obj.params.samprateout);...
    ones(length(stimpnts)-length(w),1);...
    w(obj.params.ramptime*obj.params.samprateout+1:end)];

stimtime = (stimpnts - stimpnts(1)+1)/obj.params.samprateout;

stim(stimpnts) = ...
    w.*...
    chirp(stimtime,obj.params.freqstart,stimtime(end),obj.params.freqstop)';
obj.stim = stim;
obj.stim = obj.stim * obj.params.displacement + obj.params.displacementOffset;

stimind = obj.params.sampratein*obj.params.preDurInSec+1:obj.params.sampratein*(obj.params.preDurInSec+obj.params.stimDurInSec);
freqramp = x; freqramp(:) = 0; 
df = (obj.params.freqstop-obj.params.freqstart)/length(stimind);
freqramp(stimind) = (obj.params.freqstart+df:df:obj.params.freqstop);

%
ax1 = subplot(4,1,[1 2],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax1,'color',[1 0 0],'tag',savetag);
        ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax1,'color',[1 0 0],'tag',savetag);
        ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax1,'off'); set(ax1,'TickDir','out'); 
ylabel(ax1,'V_m (mV)'); 

ax2 = subplot(4,1,3,'parent',plotcanvas);
line(obj.stimx,obj.stim,'parent',ax2,'color',[.75 .75 .75],'linewidth',1,'tag',savetag);
line(x,sgsmonitor,'parent',ax2,'color',[0 0 1],'linewidth',1,'tag',savetag);
box(ax2,'off'); set(ax2,'TickDir','out'); 
ylabel(ax2,'I (pA)'); 
xlabel(ax2,'Time (s)'); 

ax3 = subplot(4,1,4,'parent',plotcanvas);
line(x,freqramp,'parent',ax3,'color',[.75 .75 .75],'linewidth',1,'tag',savetag);
box(ax2,'off'); set(ax3,'TickDir','out'); 
ylabel(ax3,'(Hz)'); 
xlabel(ax3,'Time (s)'); 

