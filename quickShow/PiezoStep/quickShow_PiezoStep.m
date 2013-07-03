function quickShow_PiezoStep(plotcanvas,obj,savetag)

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
ax1 = subplot(3,1,[1 2],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax1,'color',[1 0 0],'tag',savetag);
        ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax1,'color',[1 0 0],'tag',savetag);
        ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax1,'off'); set(ax1,'TickDir','out'); 

ax2 = subplot(3,1,3,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax2,'color',[0 0 1],'tag',savetag);
ylabel(ax2,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax2,'off'); set(ax2,'TickDir','out'); 
xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);

