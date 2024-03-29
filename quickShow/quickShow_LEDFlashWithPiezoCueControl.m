function quickShow_LEDFlashWithPiezoCueControl(plotcanvas,obj,savetag)

if strcmp(plotcanvas.UserData,mfilename) && ~isempty(plotcanvas.Children)   % the plotcanvas is already set up for this protocol
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

% setupStimulus
x = makeInTime(obj.trial.params);

if ~isfield(obj.trial,'arduino_output')
    fprintf('Need to run continuous data extraction routine\nMay need to exclude trial: excludeEmptyControlTrials\n')
    return
end
% displayTrial
line(x,obj.trial.sgsmonitor,'parent',axLED,'color',[.8 0 0],'tag',savetag);
line(x,obj.trial.arduino_output,'parent',axLED,'color',[.8 0 .8],'tag',savetag,'displayname','arduino_output');
ylabel(axLED,'LED on'); %xlim([0 max(t)]);
axis(axLED,'tight');

line(x,obj.trial.voltage_1,'parent',axPhys,'color',[.8 0 0],'tag',savetag,'displayname','voltage_1');
ylabel(axPhys,'LED on'); %xlim([0 max(t)]);
axis(axPhys,'tight');

fcclr = [.8 .8 .8];
if obj.trial.params.blueToggle
    fcclr = [.8 .8 1];
end
patch('XData',[x(1) x(end) x(end) x(1)], 'YData',obj.trial.target_location(1)*[1 1 1 1] + obj.trial.target_location(2)*[0 0 1 1],'FaceColor',fcclr,'EdgeColor',fcclr,'parent',axProbe)
% downsample probe position
ddpp = logical(size(obj.trial.probe_position));
ddpp(1:end-1) = find(ddpp);
ddpp(end) = 0; 

line(x(ddpp),obj.trial.probe_position(ddpp),'parent',axProbe,'color',[1 .2 .2],'tag',savetag,'displayname','probe_position');
axis(axProbe,'tight');
axProbe.YLim = [0 700];


