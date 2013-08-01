function quickShow_Sweep(plotcanvas,obj,savetag)
% setupStimulus
obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax1 = subplot(5,1,4,'parent',plotcanvas);
if length(obj.params.recmode)>6, mode = obj.params.recmode(1:6);
else mode = 'IClamp';
end
switch mode
    case 'VClamp'
        ylabel(ax1,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax1,'tag',savetag);
    case 'IClamp'
        ylabel(ax1,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax1,'tag',savetag);
end
box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');

ax2 = subplot(5,1,[1 2 3],'parent',plotcanvas);
switch mode
    case 'VClamp'
        ylabel(ax2,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax2,'tag',savetag);
    case 'IClamp'
        ylabel(ax2,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax2,'tag',savetag);
end
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');

ax3 = subplot(5,1,[5],'parent',plotcanvas); 
voltagefft = fft(voltage);
f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(ax3,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
hold(ax3,'on');
box(ax3,'off'); set(ax3,'TickDir','out'); axis(ax3,'tight');
ylabel(ax3,'V^2'); %xlim([0 max(t)]);
xlabel(ax3,'Time (s)'); 

