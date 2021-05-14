function quickShow_CurrentStepControl(plotcanvas,obj,savetag)

% if isfield(obj.trial,'voltage_1')
%     plotcanvas = quickShow_CurrentStep2T(plotcanvas,obj,savetag);
%     return
% end

if ~isfield(obj.trial,'arduino_output')
    fprintf('Need to run continuous data extraction routine\n')
    return
end

h = guidata(plotcanvas);

% setupStimulus
x = ((1:obj.trial.params.sampratein*obj.params.durSweep) - obj.trial.params.preDurInSec*obj.trial.params.sampratein)/obj.trial.params.sampratein;
voltage = obj.trial.voltage_1(1:length(x));
current = obj.trial.current_1(1:length(x));

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

if length(obj.trial.params.mode)>=6, mode = obj.trial.params.mode(1:6);
else mode = 'IClamp';
end
if length(x) > 100000
    line(downsample(x,10),downsample(voltage,10),'parent',ax1,'color',[1 0 0],'tag',savetag);
else
    line(x,voltage,'parent',ax1,'color',[1 0 0],'tag',savetag);
end
ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');
[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
title(ax1,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));

ax2 = subplot(3,1,3,'parent',plotcanvas,'tag','quickshow_outax'); 
set(ax2,'tag','quickshow_outax');

if length(x) > 100000
    line(downsample(x,10),downsample(current,10),'parent',ax2,'color',[0 0 1],'tag',savetag);
else
    line(x,current,'parent',ax2,'color',[0 0 1],'tag',savetag);
end
line(x,current,'parent',ax2,'color',[0 0 1],'tag',savetag);
ylabel(ax2,'I (pA)'); %xlim([0 max(t)]);
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);


