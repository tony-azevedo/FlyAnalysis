function interTrial_LEDFlashWithPiezoCueControl(plotcanvas,obj,savetag)

if strcmp(plotcanvas.UserData,mfilename) && ~isempty(plotcanvas.Children)  % the plotcanvas is already set up for this protocol
    axLED = findobj(plotcanvas,'type','axes','tag','quickshow_inax2');
    axPhys = findobj(plotcanvas,'type','axes','tag','quickshow_inax');
    axProbe = findobj(plotcanvas,'type','axes','tag','quickshow_inax3');
    delete(axLED.Children)
    delete(axProbe.Children)
else
    % setupStimulus
    delete(get(plotcanvas,'children'));
    panl = panel(plotcanvas);
    panl.fontname = 'Arial';
        
    panl.pack('v',{1/4 1/4 1/2})  % LED/piezo, response panel, stimulus panel
    panl(1).marginbottom = 16;
            
    axProbe = panl(3).select(); %axProbe.XTick = {}; axProbe.XColor = [1 1 1];            
    ylabel(axProbe,'Probe (um)'); %xlim([0 max(t)]);
    box(axProbe,'off'); set(axProbe,'TickDir','out','tag','quickshow_inax3');
    xlabel(axProbe,'Time (s)'); %xlim([0 max(t)]);

    axPhys = panl(2).select(); axPhys.XTick = {}; axPhys.XColor = [1 1 1];
    box(axPhys,'off'); set(axPhys,'TickDir','out','tag','quickshow_inax');

    axLED = panl(1).select(); axLED.XTick = {}; axLED.XColor = [1 1 1];
    box(axLED,'off'); set(axLED,'TickDir','out','tag','quickshow_inax2');
    
    panl.marginleft = 18;
    panl.margintop = 10;
    
    obj.plotcanvas.UserData = mfilename;

end
[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
title(axLED,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));
%%

% x = makeInTime(obj.trial.params);
x = cat(1,makeInTime(obj.trial.params),makeInterTime(obj.trial));

if ~isfield(obj.trial,'arduino_output')
    fprintf('Need to run continuous data extraction routine\n')
    return
end

% Overview ax
y = cat(2,obj.trial.sgsmonitor,obj.trial.intertrial.sgsmonitor);
line(x,y,'parent',axLED,'color',[.8 0 0],'tag',savetag);

y = cat(2,obj.trial.arduino_output,obj.trial.intertrial.arduino_output);
line(x,y,'parent',axLED,'color',[.8 0 .8],'tag',savetag,'displayname','arduino_output');
ylabel(axLED,'LED on'); %xlim([0 max(t)]);
axis(axLED,'tight');

% Voltage ax
y = cat(2,obj.trial.voltage_1,obj.trial.intertrial.voltage_1);
line(x,y,'parent',axPhys,'color',[.8 0 0],'tag',savetag,'displayname','voltage_1');
ylabel(axPhys,'LED on'); %xlim([0 max(t)]);
axis(axPhys,'tight');

% Probe ax
fcclr = [.8 .8 .8];
if obj.trial.params.blueToggle
    fcclr = [.8 .8 1];
end
y = cat(2,obj.trial.probe_position,obj.trial.intertrial.probe_position);
patch('XData',[x(1) x(end) x(end) x(1)], 'YData',obj.trial.target_location(1)*[1 1 1 1] + obj.trial.target_location(2)*[0 0 1 1],'FaceColor',fcclr,'EdgeColor',fcclr,'parent',axProbe)
line(x,y,'parent',axProbe,'color',[1 .2 .2],'tag',savetag,'displayname','probe_position');
axis(axProbe,'tight');
axProbe.YLim = [0 700];


