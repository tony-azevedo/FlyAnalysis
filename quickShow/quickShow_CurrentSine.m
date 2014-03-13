function quickShow_CurrentSine(plotcanvas,obj,savetag)

% setupStimulus
if isfield(obj.trial,'voltage')
    x = ((1:obj.trial.params.sampratein*obj.params.durSweep) - obj.trial.params.preDurInSec*obj.trial.params.sampratein)/obj.trial.params.sampratein;
    voltage = obj.trial.voltage(1:length(x));
    current = obj.trial.current(1:length(x));
    
    % displayTrial
    ax1 = subplot(3,1,[1 2],'parent',plotcanvas,'tag','quickshow_inax');
    if length(obj.trial.params.mode)>=6, mode = obj.trial.params.mode(1:6);
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
    [prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
    title(ax1,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));
    
    ax2 = subplot(3,1,3,'parent',plotcanvas,'tag','quickshow_outax');
    line(x,current,'parent',ax2,'color',[0 0 1],'tag',savetag);
    ylabel(ax2,'I (pA)'); %xlim([0 max(t)]);
    box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
    xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);
    
elseif isfield(obj.trial,'voltage_1')
    
    [prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
    
    x = makeInTime(obj.trial.params);
    
    % displayTrial
    ax1 = subplot(3,1,1,'parent',plotcanvas,'tag','quickshow_inax');
    switch obj.trial.params.mode_1
        case 'VClamp'
            error('CurrentSine Trial was in VClamp');
        case 'IClamp'
            line(x,obj.trial.voltage_1,'parent',ax1,'color',[.6 0 0],'tag',savetag);
            ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
    end
    box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');
    title(ax1,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));
    
    ax1 = subplot(3,1,2,'parent',plotcanvas,'tag','quickshow_inax');
    switch obj.trial.params.mode_2
        case 'VClamp'
            warning('CurrentSine Trial was in VClamp');
            line(x,obj.trial.current_2,'parent',ax1,'color',[1 .5 .5],'tag',savetag);
            ylabel(ax1,'pA'); %xlim([0 max(t)]);
        case 'IClamp'
            line(x,obj.trial.voltage_2,'parent',ax1,'color',[1 .5 .5],'tag',savetag);
            ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
    end
    box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');

    ax2 = subplot(3,1,3,'parent',plotcanvas,'tag','quickshow_outax');
    line(x,obj.trial.current_2,'parent',ax2,'color',[1 .5 .5],'tag',savetag);
    line(x,obj.trial.current_1,'parent',ax2,'color',[.6 0 0],'tag',savetag);
    ylabel(ax2,'I (pA)'); %xlim([0 max(t)]);
    box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
    xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);

end
