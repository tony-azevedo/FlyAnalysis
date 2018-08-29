function quickShow_ManipulatorMove2T(plotcanvas,obj,savetag)

% setupStimulus
delete(get(plotcanvas,'children'));
panl = panel(plotcanvas);
panl.pack('v',{1/3 1/3 1/3})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

% setupStimulus
x = makeInTime(obj.trial.params);

[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
panl.title(sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));

% displayTrial
ax1 = panl(1).select();
switch obj.trial.params.mode_1
    case 'VClamp'
        line(x,obj.trial.current_1,'parent',ax1,'color',[.8 0 0],'tag',savetag);
        ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,obj.trial.voltage_1,'parent',ax1,'color',[.8 0 0],'tag',savetag);
        ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
    otherwise
        error('Why are you in I=0 mode?')
end
box(ax1,'off'); set(ax1,'TickDir','out','tag','quickshow_inax'); axis(ax1,'tight');

ax2 = panl(2).select();
switch obj.trial.params.mode_2
    case 'VClamp'
        line(x,obj.trial.current_2,'parent',ax2,'color',[1 .2 .2],'tag',savetag);
        ylabel(ax2,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,obj.trial.voltage_2,'parent',ax2,'color',[1 .2 .2],'tag',savetag);
        ylabel(ax2,'V_m (mV)'); %xlim([0 max(t)]);
    otherwise
        error('Why are you in I=0 mode?')
end
box(ax2,'off'); set(ax2,'TickDir','out','tag','quickshow_inax2'); axis(ax2,'tight');

if isfield(obj.trial.params,'coordinate')
    [~,m] = ManipulatorMoveStim(obj.trial.params);
    panl(3).pack('v',size(m,1));

    for i = 1:size(m,1)
        ax3 = panl(3,i).select();
        line(x,m(i,:),'parent',ax3,'color',[0 0 1],'tag',savetag);
        ylabel(ax3,['coord ' num2str(i)]); %xlim([0 max(t)]);
        box(ax3,'off'); 
        set(ax3,'TickDir','out');axis(ax3,'tight');
    end
    xlabel(ax3,'Time (s)'); %xlim([0 max(t)]);
    set(ax3,'TickDir','out','tag','quickshow_outax'); 
end

