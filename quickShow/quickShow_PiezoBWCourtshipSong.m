function quickShow_PiezoBWCourtshipSong(plotcanvas,obj,savetag)

% setupStimulus
panl = panel(plotcanvas);
panl.pack('v',{1/2 1/2})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

% setupStimulus
x = ((1:obj.trial.params.sampratein*obj.params.durSweep) - obj.trial.params.preDurInSec*obj.trial.params.sampratein)/obj.trial.params.sampratein;
if isfield(obj.trial,'voltage')
    voltage = obj.trial.voltage(1:length(x));
    current = obj.trial.current(1:length(x));
end
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
panl.title(sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));

% displayTrial
if isfield(obj.trial,'voltage')
    ax1 = panl(1).select();
    if length(obj.trial.params.mode)>6, mode = obj.trial.params.mode(1:6);
    else mode = obj.trial.params.mode(1:6);
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
end
    
ax2 = panl(2).select();
line(x,sgsmonitor,'parent',ax2,'color',[0 0 1],'tag',savetag);
ylabel(ax2,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);

