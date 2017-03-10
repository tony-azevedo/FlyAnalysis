function plotcanvas = EpiFlashLegPosition(plotcanvas,obj,savetag,varargin)

% setupStimulus
delete(get(plotcanvas,'children'));
panl = panel(plotcanvas);
panl.pack('v',{1/2 1/2})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

% setupStimulus
x = makeInTime(obj.trial.params);

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
            line(x,obj.trial.current,'parent',ax1,'color',[1 0 0],'tag',savetag);
            ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
        case 'IClamp'
            line(x,obj.trial.voltage,'parent',ax1,'color',[1 0 0],'tag',savetag);
            ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
    end
    box(ax1,'off'); set(ax1,'TickDir','out','tag','quickshow_inax'); axis(ax1,'tight');
end

if isfield(obj.trial,'legposition')
    panl(2).pack('v',2);
    lp = obj.trial.legposition;
    [fe,ti,ta] = legAngles(lp,'deg');
%     [fe,ti,ta] = legPositions(lp,'delta');
           
    exp_times = find(obj.trial.exposure);
    frametimes = exp_times(obj.trial.frame_roi);

    plot(panl(2,1).select(),x(frametimes),ta,'tag',savetag)
    axis(panl(2,2).select(),'tight');
    xlim(panl(2,1).select(),[x(1) x(end)]);
    ylabel(panl(2,1).select(),'tarsus'); %xlim([0 max(t)]);
    set(panl(2,1).select(),'TickDir','out'); 

    plot(panl(2,2).select(),x(frametimes),ti,'tag',savetag)
    axis(panl(2,2).select(),'tight');
    xlim(panl(2,2).select(),[x(1) x(end)]);
    ylabel(panl(2,2).select(),'tibia'); %xlim([0 max(t)]);
    set(panl(2,2).select(),'TickDir','out','tag','quickshow_outax'); 

    xlabel(panl(2,2).select(),'Time (s)'); %xlim([0 max(t)]);

%     plot(panl(2,3).select(),x(frametimes),fe,'tag',savetag)
%     ylim(panl(2,3).select(),[70 180]);
%     xlim(panl(2,3).select(),[x(1) x(end)]);
%     ylabel(panl(2,3).select(),'femur');
%     set(panl(2,3).select(),'TickDir','out','tag','quickshow_outax');
    
elseif isfield(obj.trial.params,'coordinate')
    [~,m] = ManipulatorMoveStim(obj.trial.params);
    panl(2).pack('v',size(m,1));

    for i = 1:size(m,1)
        ax2 = panl(2,i).select();
        line(x,m(i,:),'parent',ax2,'color',[0 0 1],'tag',savetag);
        ylabel(ax2,['coord ' num2str(i)]); %xlim([0 max(t)]);
        box(ax2,'off'); 
        set(ax2,'TickDir','out');axis(ax2,'tight');
    end
    xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);
    set(ax2,'TickDir','out','tag','quickshow_outax'); 
end



% % setupStimulus
% x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;
% voltage = obj.trial.voltage(1:length(x));
% current = obj.trial.current(1:length(x));
% sgsmonitor = obj.trial.sgsmonitor(1:length(x));
% %sgsmonitor = zeros(size(x));
% 
% % displayTrial
% if isfield(obj.trial,'dFoverF')
%     ax1 = subplot(3,1,2,'parent',plotcanvas);
%     set(ax1,'tag','quickshow_dFoverF_ax');
%     line(obj.trial.exposure_time,obj.trial.dFoverF,'color',[0 .7 0],'linewidth',1,'parent',ax1,'tag',savetag);
%     
%     ylabel(ax1,'%\DeltaF / F');
%     axis(ax1,'tight')
%     xlims = get(ax1,'xlim');
%     box(ax1,'off');
%     set(ax1,'TickDir','out');
%     
%     set(ax1,'xlim',xlims)
% 
%     ax1 = subplot(3,1,1,'parent',plotcanvas);
% 
% else
%     ax1 = subplot(3,1,[1 2],'parent',plotcanvas);
% end
% 
% set(ax1,'tag','quickshow_inax');
% if length(obj.params.mode)>6, mode = obj.params.mode(1:6);
% else mode = 'IClamp';
% end
% switch mode
%     case 'VClamp'
%         line(x,current,'parent',ax1,'color',[1 0 0],'tag',savetag);
%         ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
%     case 'IClamp'
%         line(x,voltage,'parent',ax1,'color',[1 0 0],'tag',savetag);
%         ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
% end
% box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');
% 
% ax2 = subplot(3,1,3,'parent',plotcanvas); 
% set(ax2,'tag','quickshow_outax');
% line(x,sgsmonitor,'parent',ax2,'color',[0 0 1],'tag',savetag);
% ylabel(ax2,'SGS monitor (V)'); %xlim([0 max(t)]);
% box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
% xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);
% 
