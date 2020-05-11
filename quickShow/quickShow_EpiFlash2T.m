function quickShow_EpiFlash2T(plotcanvas,obj,savetag)

if strcmp(plotcanvas.UserData,mfilename) % the plotcanvas is already set up for this protocol
    axP = findobj(plotcanvas,'type','axes','tag','quickshow_inax');
    axE = findobj(plotcanvas,'type','axes','tag','quickshow_inax2');
    axE2 = findobj(plotcanvas,'type','axes','tag','quickshow_inax3');
    axO = findobj(plotcanvas,'type','axes','tag','quickshow_outax');
    
    panum = 4;
    if isempty(axE2)
        panum = 3;
    end
    if isempty(axE)
        panum = 2;
    end
else
    % setupStimulus
    delete(get(plotcanvas,'children'));
    panl = panel(plotcanvas);
    panl.fontname = 'Arial';
    
    %% Change the number of panels to see the different EMGs
    if isfield(obj.trial,'current_extEMG')
        panum = 4;
    else, panum = 3;
    end
    
    switch panum
        case 2
            panl.pack('v',{1/3 1/2})  % response panel, stimulus panel
            panl(1).marginbottom = 16;
            
            axO = panl(2).select();
        case 3
            panl.pack('v',{1/3 1/3 1/3})  % response panel, EMG panel, stimulus panel
            panl(1).marginbottom = 4;
            panl(2).marginbottom = 4;
            
            axE = panl(2).select(); axE.XTick = {}; axE.XColor = [1 1 1];
            axO = panl(3).select();
            
            ylabel(axE,'EMG (pA)'); %xlim([0 max(t)]);
            box(axE,'off'); set(axE,'TickDir','out','tag','quickshow_inax2');
            
        case 4
            panl.pack('v',{2/7 3/7 2/7})  % response panel, stimulus panel
            panl(1).marginbottom = 4;
            panl(2).marginbottom = 4;
            
            panl(2).pack('v',{1/2 1/2})
            panl(2,1).marginbottom = 4;
            panl(2,2).marginbottom = 4;
            axE = panl(2,1).select(); axE.XTick = {}; axE.XColor = [1 1 1];
            set(axE,'TickDir','out','tag','quickshow_inax2');
            
            axE2 = panl(2,2).select(); axE2.XTick = {}; axE2.XColor = [1 1 1];
            set(axE2,'TickDir','out','tag','quickshow_inax3');
            
            panl(2).ylabel('EMG (pA)')
            
            axO = panl(3).select();
            panl(3).margintop = 4;
            
    end
    
    axP = panl(1).select(); axP.XTick = {}; axP.XColor = [1 1 1];
    box(axP,'off'); set(axP,'TickDir','out','tag','quickshow_inax');
    
    ylabel(axO,'EpiFlash (V)'); %xlim([0 max(t)]);
    box(axO,'off'); set(axO,'TickDir','out','tag','quickshow_outax');
    % ylim(ax3,[670 870]);
    xlabel(axO,'Time (s)'); %xlim([0 max(t)]);
    
    panl.marginleft = 18;
    panl.margintop = 10;
    
    obj.plotcanvas.UserData = mfilename;
    %guidata(plotcanvas,obj.plotcanvas);

    
%     panl.title(sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));

end
[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
title(axP,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));
%%

% setupStimulus
x = makeInTime(obj.trial.params);


% displayTrial
switch obj.trial.params.mode_1
    case 'VClamp'
        line(x,obj.trial.current_1,'parent',axP,'color',[.8 0 0],'tag',savetag);
        ylabel(axP,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,obj.trial.voltage_1,'parent',axP,'color',[.8 0 0],'tag',savetag);
        ylabel(axP,'V_m (mV)'); %xlim([0 max(t)]);
    otherwise
        error('Why are you in I=0 mode?')
end
axis(axP,'tight');

if panum > 2
    switch obj.trial.params.mode_2
        case 'VClamp'
            line(x,obj.trial.current_2,'parent',axE,'color',[1 .2 .2],'tag',savetag);
        case 'IClamp'
            line(x,obj.trial.voltage_2,'parent',axE,'color',[1 .2 .2],'tag',savetag);
        otherwise
            error('Why are you in I=0 mode?')
    end
    axis(axE,'tight');
    
    if panum >3
        line(x,obj.trial.current_extEMG,'parent',axE2,'color',[1 .2 .2],'tag',savetag);
        axis(axE2,'tight');
    end
end

line(x,EpiFlashStim(obj.trial.params),'parent',axO,'color',[0 0 1],'tag',savetag);
ylabel(axO,'EpiFlash (V)'); %xlim([0 max(t)]);
box(axO,'off'); set(axO,'TickDir','out','tag','quickshow_outax'); axis(axO,'tight');
% ylim(ax3,[670 870]);
xlabel(axO,'Time (s)'); %xlim([0 max(t)]);


