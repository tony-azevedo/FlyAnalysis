function quickShow_VoltagePlateau(plotcanvas,obj,savetag,varargin)
p = inputParser;
p.PartialMatching = 0;
p.addParameter('BGCorrectImages',false,@islogical);
parse(p,varargin{:});

% setupStimulus
x = ((1:obj.trial.params.sampratein*obj.params.durSweep) - obj.trial.params.preDurInSec*obj.trial.params.sampratein)/obj.trial.params.sampratein;
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));

% displayTrial

if isfield(obj.trial,'dFoverF')
    ax1 = subplot(3,1,2,'parent',plotcanvas);
    set(ax1,'tag','quickshow_dFoverF_ax');
    
    if p.Results.BGCorrectImages
        dFF_t = dFoverF_bgcorr_trace(obj.trial);
    else
        dFF_t = dFoverF_withbg_trace(obj.trial);
    end
    line(obj.trial.exposure_time,dFF_t,'color',[0 .7 0],'linewidth',1,'parent',ax1,'tag',savetag);
    
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

ax2 = subplot(3,1,3,'parent',plotcanvas); 
set(ax2,'tag','quickshow_outax');
switch mode
    case 'IClamp'
        line(x,current,'parent',ax2,'color',[0 0 1],'tag',savetag);
        ylabel(ax2,'I (pA)'); %xlim([0 max(t)]);
    case 'VClamp'
        line(x,voltage,'parent',ax2,'color',[0 0 1],'tag',savetag);
        ylabel(ax2,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);

