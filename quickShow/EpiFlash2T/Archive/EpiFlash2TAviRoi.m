function h = EpiFlash2TAviRoi(h,handles,savetag)

if ~isfield(handles.trial,'clustertraces')
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
panl.pack('v',{1/3 1/3 1/3})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

trial = handles.trial;
x = makeTime(trial.params);

% displayTrial
ax1 = panl(1).select();
switch trial.params.mode_1
    case 'VClamp'
        line(x,trial.current_1,'parent',ax1,'color',[.8 0 0],'tag',savetag);
        ylabel(ax1,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,trial.voltage_1,'parent',ax1,'color',[.8 0 0],'tag',savetag);
        ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
    otherwise
        error('Why are you in I=0 mode?')
end
box(ax1,'off'); set(ax1,'TickDir','out','tag','quickshow_inax'); axis(ax1,'tight');

ax2 = panl(2).select();
switch trial.params.mode_2
    case 'VClamp'
        line(x,trial.current_2,'parent',ax2,'color',[1 .2 .2],'tag',savetag);
        ylabel(ax2,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,trial.voltage_2,'parent',ax2,'color',[1 .2 .2],'tag',savetag);
        ylabel(ax2,'V_m (mV)'); %xlim([0 max(t)]);
    otherwise
        error('Why are you in I=0 mode?')
end
box(ax2,'off'); set(ax2,'TickDir','out','tag','quickshow_inax2'); axis(ax2,'tight');


ax3 = panl(3).select();
t2 = postHocExposure(trial,size(trial.clustertraces,1));
line(x,EpiFlashStim(trial.params)*max(trial.clustertraces(:)),'parent',ax3,'color',[.9 .9 1],'tag',savetag);
clrs = parula(size(trial.clustertraces,2)+1);
clrs = clrs(1:end-1,:);

for cl = 1:size(trial.clustertraces,2)
    ls = line(x(t2.exposure),trial.clustertraces(1:sum(t2.exposure),cl),'parent',ax3,'tag',savetag);
    ls.Color = clrs(cl,:);
end    

ylabel(ax3,'F'); %xlim([0 max(t)]);
box(ax3,'off'); set(ax3,'TickDir','out','tag','quickshow_outax'); axis(ax3,'tight');
xlabel(ax3,'Time (s)'); %xlim([0 max(t)]);

smooshedImagePath = regexprep(trial.name,{'_Raw_','.mat'},{'_smooshed_', '.mat'});
iostr = load(smooshedImagePath);

clfig = findobj('type','figure','tag','AVI_Clutsters');
if isempty(clfig)
    clfig = figure;
    set(clfig,'position',[1200 10 640 512],'tag','AVI_Clutsters');
    dispax = axes('parent',clfig,'units','pixels','position',[0 0 640 512]);
    set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
    colormap(dispax,'gray')
    dispax.Tag = 'dispax';
end
dispax = findobj(clfig,'type','axes');
imshow(iostr.smooshedframe,[0 2*quantile(iostr.smooshedframe(:),0.975)],'parent',dispax);
for cl = 1:size(trial.clustertraces,2)
    hold(dispax,'on')
    alphamask(trial.clmask==cl,clrs(cl,:),.4,dispax);
end
hold(dispax,'off')
figure(clfig);



