function h = EpiFlash2TPhaseSpace(h,handles,savetag)

if ~isfield(handles.trial,'forceProbeStuff')
    fprintf('No forceProbe')
    return
end
    
trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
delete(get(h,'children'));
panl = panel(h);
panl.pack('v',{3/4 1/4})  % response panel, stimulus panel
panl(1).pack('h',{1/2})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
% panl(1).marginbottom = 2;

trial = handles.trial;
x = makeTime(trial.params);

% displayTrial

% ax1 = panl(1).select();
% switch trial.params.mode_2
%     case 'VClamp'
%         line(x,trial.current_2,'parent',ax1,'color',[1 .2 .2],'tag',savetag);
%         ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
%     case 'IClamp'
%         line(x,trial.voltage_2,'parent',ax1,'color',[1 .2 .2],'tag',savetag);
%         ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
%     otherwise
%         error('Why are you in I=0 mode?')
% end
% box(ax1,'off'); set(ax1,'TickDir','out','tag','quickshow_inax2'); axis(ax1,'tight');


% ax2 = panl(2).select();
% t2 = postHocExposure(trial,size(trial.clustertraces,1));
% clrs = parula(size(trial.clustertraces,2)+1);
% clrs = clrs(1:end-1,:);
% 
% for cl = 1:size(trial.clustertraces,2)
%     ls = line(x(t2.exposure),trial.clustertraces(1:sum(t2.exposure),cl),'parent',ax2,'tag',savetag);
%     ls.Color = clrs(cl,:);
% end    
% 
% ylabel(ax2,'F'); %xlim([0 max(t)]);
% %box(ax2,'off'); set(ax2,'TickDir','out','tag','quickshow_outax'); axis(ax2,'tight');
% xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);


origin = find(handles.trial.forceProbeStuff.EvalPnts(1,:)==0&handles.trial.forceProbeStuff.EvalPnts(2,:)==0);
x_hat = handles.trial.forceProbeStuff.EvalPnts(:,origin+1);
CoM = handles.trial.forceProbeStuff.forceProbePosition';
CoM = CoM*x_hat;
origin = min(CoM);%handles.trial.forceProbeStuff.Origin'*x_hat;
CoM = CoM - origin;

h2 = postHocExposure(trial,length(CoM));
frame_times = x(h2.exposure);

dCoMdt = diff(CoM)./diff(frame_times);

ax3 = panl(2).select();
plot(ax3,frame_times,CoM,'k')
axis(ax3,'tight')
set([ax3],'xlim',[x(1) x(end)],'tag','unlink')
xlabel(ax3,'s')
ylabel(ax3,'CoM (pixels)')

ax4 = panl(1,1).select();
set([ax4],'tag','unlink')
plot(ax4,CoM(2:end),dCoMdt,'k')
axis(ax4,'tight')
xlabel(ax4,'CoM (pixels)')
ylabel(ax4,'CoM'' (pixels/s)')

CoM = CoM(2:end);

frame_times = frame_times(2:end);

%% Color the trace and the phasespace
origin = find(abs(CoM)<5 & abs(dCoMdt)<250);

ax3 = panl(2).select(); hold(ax3,'on')
plot(ax3,frame_times(origin),CoM(origin),'.','color',[1 1 1]*.7)

ax4 = panl(1,1).select(); hold(ax4,'on')
plot(ax4,CoM(origin),dCoMdt(origin),'.','color',[1 1 1]*.7)

%%
upperleft = find(CoM>5 & CoM<150 & dCoMdt>250);

ax3 = panl(2).select(); hold(ax3,'on')
plot(ax3,frame_times(upperleft),CoM(upperleft),'.','color',[0 .7 0])

ax4 = panl(1,1).select(); hold(ax4,'on')
plot(ax4,CoM(upperleft),dCoMdt(upperleft),'.','color',[0 .7 0])

%%
upperleft = find(CoM>150 & dCoMdt>250);

ax3 = panl(2).select(); hold(ax3,'on')
plot(ax3,frame_times(upperleft),CoM(upperleft),'.','color',[1 .7 0])

ax4 = panl(1,1).select(); hold(ax4,'on')
plot(ax4,CoM(upperleft),dCoMdt(upperleft),'.','color',[1 .7 0])

%%
upperleft = find(CoM>150 & dCoMdt<-250);

ax3 = panl(2).select(); hold(ax3,'on')
plot(ax3,frame_times(upperleft),CoM(upperleft),'.','color',[1 0 0])

ax4 = panl(1,1).select(); hold(ax4,'on')
plot(ax4,CoM(upperleft),dCoMdt(upperleft),'.','color',[1 0 0])

%%
upperleft = find(CoM>5 & CoM<150 & dCoMdt<-250);

ax3 = panl(2).select(); hold(ax3,'on')
plot(ax3,frame_times(upperleft),CoM(upperleft),'.','color',[0 0 1])

ax4 = panl(1,1).select(); hold(ax4,'on')
plot(ax4,CoM(upperleft),dCoMdt(upperleft),'.','color',[0 0 1])

% Show the image for reference
% smooshedImagePath = regexprep(trial.name,{'_Raw_','.mat'},{'_smooshed_', '.mat'});
% iostr = load(smooshedImagePath);
% 
% clfig = findobj('type','figure','tag','AVI_Clutsters');
% if isempty(clfig)
%     clfig = figure;
%     set(clfig,'position',[1200 10 640 512],'tag','AVI_Clutsters');
%     dispax = axes('parent',clfig,'units','pixels','position',[0 0 640 512]);
%     set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
%     colormap(dispax,'gray')
%     dispax.Tag = 'dispax';
% end
% dispax = findobj(clfig,'type','axes');
% imshow(iostr.smooshedframe,[0 2*quantile(iostr.smooshedframe(:),0.975)],'parent',dispax);
% for cl = 1:size(trial.clustertraces,2)
%     hold(dispax,'on')
%     alphamask(trial.clmask==cl,clrs(cl,:),.4,dispax);
% end
% hold(dispax,'off')
% figure(clfig);
% 


