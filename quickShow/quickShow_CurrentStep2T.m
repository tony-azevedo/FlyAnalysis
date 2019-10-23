function plotcanvas = quickShow_CurrentStep2T(plotcanvas,obj,savetag)
% see also quickShow_CurrentStep
guidata(plotcanvas);

% setupStimulus
x = ((1:obj.trial.params.sampratein*obj.params.durSweep) - obj.trial.params.preDurInSec*obj.trial.params.sampratein)/obj.trial.params.sampratein;

ax1 = subplot(3,1,1,'parent',plotcanvas);
set(ax1,'tag','quickshow_inax');
switch obj.trial.params.mode_1
    case 'VClamp'
        line(x,obj.trial.current_1(1:length(x)),'parent',ax1,'color',[.7 0 0],'tag',savetag);
        ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,obj.trial.voltage_1(1:length(x)),'parent',ax1,'color',[.7 0 0],'tag',savetag);
        ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');
[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
title(ax1,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));

ax2 = subplot(3,1,2,'parent',plotcanvas);
set(ax2,'tag','quickshow_inax2');

switch obj.trial.params.mode_2
    case 'VClamp'
        line(x,obj.trial.current_2(1:length(x)),'parent',ax2,'color',[1 .3 .3],'tag',savetag);
        ylabel(ax2,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,obj.trial.voltage_2(1:length(x)),'parent',ax2,'color',[1 .3 .3],'tag',savetag);
        ylabel(ax2,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');

ax3 = subplot(3,1,3,'parent',plotcanvas,'tag','quickshow_outax'); 
set(ax3,'tag','quickshow_outax');

line(x,obj.trial.current_1(1:length(x)),'parent',ax3,'color',[0 0 .7],'tag',savetag);
ylabel(ax3,'I (pA)'); %xlim([0 max(t)]);
box(ax3,'off'); set(ax3,'TickDir','out'); axis(ax3,'tight');
xlabel(ax3,'Time (s)'); %xlim([0 max(t)]);

plotcanvas = get(ax3,'parent');
