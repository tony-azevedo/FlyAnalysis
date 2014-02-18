function quickShow_PiezoStep(plotcanvas,obj,savetag)

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
if isfield(obj.trial,'dFoverF')
    ax1 = subplot(3,1,2,'parent',plotcanvas);
    set(ax1,'tag','quickshow_dFoverF_ax');
    line(obj.trial.exposure_time,obj.trial.dFoverF,'color',[0 .7 0],'linewidth',1,'parent',ax1,'tag',savetag);
    
    ylabel(ax1,'%\DeltaF / F');
    axis(ax1,'tight')
    xlims = get(ax1,'xlim');
    box(ax1,'off');
    set(ax1,'TickDir','out');
    
    set(ax1,'xlim',xlims)

    ax1 = subplot(3,1,1,'parent',plotcanvas);

else
    ax1 = subplot(3,1,[1 2],'parent',plotcanvas);
end

set(ax1,'tag','quickshow_inax');
if length(obj.params.mode)>6, mode = obj.params.mode(1:6);
else mode = 'IClamp';
end
switch mode
    case 'VClamp'
        line(x,current,'parent',ax1,'color',[1 0 0],'tag',savetag);
        ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax1,'color',[1 0 0],'tag',savetag);
        ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');

ax2 = subplot(3,1,3,'parent',plotcanvas); 
set(ax2,'tag','quickshow_outax');
line(x,sgsmonitor,'parent',ax2,'color',[0 0 1],'tag',savetag);
ylabel(ax2,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);

