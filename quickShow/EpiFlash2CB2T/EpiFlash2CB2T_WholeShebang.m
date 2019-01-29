function h = EpiFlash2CB2T_WholeShebang(h,handles,savetag)

if ~isfield(handles.trial,'clustertraces')
    return
end
    
delete(get(h,'children'));
panl = panel(h);
panl.pack('v',{1/4 1/4 1/4 1/4})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

trial = handles.trial;
x = makeTime(trial.params);

% displayTrial
ax1 = panl(1).select();
switch trial.params.mode_2
    case 'VClamp'
        line(x,trial.current_2,'parent',ax1,'color',[1 .2 .2],'tag',savetag);
        ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,trial.voltage_2,'parent',ax1,'color',[1 .2 .2],'tag',savetag);
        ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
    otherwise
        error('Why are you in I=0 mode?')
end
box(ax1,'off'); set(ax1,'TickDir','out','tag','quickshow_inax'); axis(ax1,'tight');
xlim(ax1,[min(x) max(x)]);


ax2 = panl(2).select(); 
t2 = postHocExposure2(trial,max(size(trial.clustertraces)));
line(x,EpiFlashStim(trial.params)*max(trial.clustertraces(:)),'parent',ax2,'color',[.9 .9 1],'tag',savetag);
clrs = parula(size(trial.clustertraces,2)+1);
clrs = clrs(1:end-1,:);
for cl = 1:size(trial.clustertraces,2)
    ls = line(x(t2.exposure2),trial.clustertraces(:,cl),'parent',ax2,'tag',savetag);
    ls.Color = clrs(cl,:);
end    

ylabel(ax2,'F'); %xlim([0 max(t)]);
box(ax2,'off'); set(ax2,'TickDir','out','tag','quickshow_outax'); axis(ax2,'tight');
xlim(ax2,[min(x) max(x)]);
xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);

if isfield(trial,'legPositions')
    ax3 = panl(3).select();
    t2 = postHocExposure(trial,max(size(trial.legPositions.Tibia_Angle)));
    % ax3 = axes('parent',clusterfig,'units','pixels','position',[0 0 wh]);
    ax3.Box = 'off';
    box(ax3,'off'); set(ax3,'TickDir','out','tag','quickshow_ax'); axis(ax3,'tight');
    plot(ax3,x(t2.exposure),trial.legPositions.Tibia_Angle)
    
    xlim(ax3,[min(x) max(x)]);
    
    ylabel(ax3,'Tibia Angle'); %xlim([0 max(t)]);
    
    %     ax4 = panl(4).select();
    %     t2 = postHocExposure(trial,max(size(trial.legPositions.Tibia_Angle))-1);
    %     ax4.Box = 'off';
    %     plot(ax4,x(t2.exposure),diff(smooth(trial.legPositions.Tibia_Angle,4)))
    %     box(ax4,'off'); set(ax4,'TickDir','out','tag','quickshow_ax'); axis(ax4,'tight');
    %     xlim(ax4,[min(x) max(x)]);
    %     ylabel(ax4,'Tibia Angle'); %xlim([0 max(t)]);
    
    ax4 = panl(4).select();
    % ax3 = axes('parent',clusterfig,'units','pixels','position',[0 0 wh]);
    ax4.Box = 'off';
    ax4.XTick = [];
    ax4.YTick = [];
    ax4.Tag = 'unlink';
    colormap(ax4,'gray')
    
    if length(size(trial.clmask))>2
        N_Cl_idx = nan(size(trial.clmask,3),1);
        for idx = 1:length(N_Cl_idx)
            N_Cl_idx(idx) = length(unique(trial.clmask(:,:,idx)))-1;
        end
        clmask = squeeze(trial.clmask(:,:,N_Cl_idx==min(size(trial.clustertraces))));
    else
        clmask = trial.clmask;
    end
    imshow(clmask*0,[0 255],'parent',ax4);
    for cl = 1:size(trial.clustertraces,2)
        alphamask(clmask==cl,clrs(cl,:),1,ax4);
    end
    ax4.Tag = 'unlink';
    ax4.Position = [.02 .02 .4 .3];

elseif isfield(trial,'forceProbeStuff')
    ax3 = panl(3).select();
    t2 = postHocExposure(trial,length(trial.forceProbeStuff.CoM));
    % ax3 = axes('parent',clusterfig,'units','pixels','position',[0 0 wh]);
    ax3.Box = 'off';
    box(ax3,'off'); set(ax3,'TickDir','out','tag','quickshow_ax'); axis(ax3,'tight');
    plot(ax3,x(t2.exposure),trial.forceProbeStuff.CoM)
    
    xlim(ax3,[min(x) max(x)]);
    
    ylabel(ax3,'ProbePosition'); %xlim([0 max(t)]);
    
    
    ax4 = panl(4).select();
    % ax3 = axes('parent',clusterfig,'units','pixels','position',[0 0 wh]);
    ax4.Box = 'off';
    ax4.XTick = [];
    ax4.YTick = [];
    ax4.Tag = 'unlink';
    colormap(ax4,'gray')
    
    if length(size(trial.clmask))>2
        N_Cl_idx = nan(size(trial.clmask,3),1);
        for idx = 1:length(N_Cl_idx)
            N_Cl_idx(idx) = length(unique(trial.clmask(:,:,idx)))-1;
        end
        clmask = squeeze(trial.clmask(:,:,N_Cl_idx==min(size(trial.clustertraces))));
    else
        clmask = trial.clmask;
    end
    imshow(clmask*0,[0 255],'parent',ax4);
    for cl = 1:size(trial.clustertraces,2)
        alphamask(clmask==cl,clrs(cl,:),1,ax4);
    end
    ax4.Tag = 'unlink';
    ax4.Position = [.02 .02 .4 .3];
    

    
end



  
