function quickShow_LEDFlashWithPiezoCueControl(plotcanvas,obj,savetag)

if strcmp(plotcanvas.UserData,mfilename) % the plotcanvas is already set up for this protocol
    axLED = findobj(plotcanvas,'type','axes','tag','quickshow_inax');
    axProbe = findobj(plotcanvas,'type','axes','tag','quickshow_inax2');
    delete(axLED.Children)
    delete(axProbe.Children)
else
    % setupStimulus
    delete(get(plotcanvas,'children'));
    panl = panel(plotcanvas);
    panl.fontname = 'Arial';
        
    panl.pack('v',{1/4 3/4})  % response panel, stimulus panel
    panl(1).marginbottom = 16;
            
    axProbe = panl(2).select(); %axProbe.XTick = {}; axProbe.XColor = [1 1 1];            
    ylabel(axProbe,'Probe (um)'); %xlim([0 max(t)]);
    box(axProbe,'off'); set(axProbe,'TickDir','out','tag','quickshow_inax2');
    xlabel(axProbe,'Time (s)'); %xlim([0 max(t)]);
            
    axLED = panl(1).select(); axLED.XTick = {}; axLED.XColor = [1 1 1];
    box(axLED,'off'); set(axLED,'TickDir','out','tag','quickshow_inax');
    
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
    fprintf('Need to run continuous data extraction routine\n')
    return
end
% displayTrial
line(x,obj.trial.sgsmonitor,'parent',axLED,'color',[.8 0 0],'tag',savetag);
ylabel(axLED,'LED on'); %xlim([0 max(t)]);
axis(axLED,'tight');

patch('XData',[x(1) x(end) x(end) x(1)], 'YData',obj.trial.target_location(1)*[1 1 1 1] + obj.trial.target_location(2)*[0 0 1 1],'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'parent',axProbe)
line(x,obj.trial.probe_position,'parent',axProbe,'color',[1 .2 .2],'tag',savetag);
axis(axProbe,'tight');
axProbe.YLim = [100 900];


