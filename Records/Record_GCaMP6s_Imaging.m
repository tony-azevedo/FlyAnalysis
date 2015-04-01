% Analysis Record for In Vivo Calcium imaging with antennal stimulation
savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

%% GCaMP6s cells all
list = {...
'150107_F1_C1'
'150106_F1_C1'
'141211_F3_C1'
'141211_F1_C1'
'141211_F2_C1'
'141210_F3_C1'
'141210_F2_C1'
'141210_F1_C1'
'141201_F1_C1'
'141125_F1_C1'
'141124_F1_C1'
'141123_F1_C1'
'141123_F2_C1'
'141120_F1_C1'  GH86
'141119_F1_C1'
'141118_F1_C1'
'141029_F2_C1'
'141029_F1_C1'
'141028_F2_C1'  GH86
'141028_F1_C1'
'141027_F1_C1'  GH86
'141027_F2_C1'  GH86
'141025_F1_C1'  GH86
};


%% Ipsilateral stimulation
clear analysis_cell
SidePart = 'IpsiTerminals';
Record_GCaMP6s_Imaging_Ipsilateral
Script_GCaMP6s_Imaging

%% Ipsilateral stimulation
clear analysis_cell
SidePart = 'IpsiAMMC';
Record_GCaMP6s_Imaging_IpsilateralAMMC
Script_GCaMP6s_Imaging

%% Contralateral stimulation
clear analysis_cell
SidePart = 'ContraTerminals';
Record_GCaMP6s_Imaging_Contralateral
Script_GCaMP6s_Imaging

% AMMC
% clear analysis_cell
% SidePart = 'ContraAMMC';
% Record_GCaMP6s_Imaging_ContralateralAMMC
% Script_GCaMP6s_Imaging

%% Compare Contra and Ipsi and AMMC stimuluation
close all

ComparisonFig = figure();

set(ComparisonFig,'color',[1 1 1]);
%set(ComparisonFig,'units','pixels','position',[300 200 1024  768])
set(ComparisonFig,'units','inches','position',[1 1 10.3 6.3])

panl = panel(ComparisonFig);
panl.pack('v',{1/3,2/3});
panl(1).pack('h',{1/3,1/3,1/3});
panl(2).pack('h',{3/5, 2/5});
panl(2,1).pack('v',{2/3,1/6,1/6});

panl.fontsize = 18;
panl.fontname = 'Arial';
%panl(1,2,1,2).fontsize = 10;


% image
uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiAMMC_Mask_150211_F2_C1_8_.fig',1)
AxonROI = gcf;

ax_ROI = panl(1,2).select();
cla(ax_ROI);
axs = findobj(get(AxonROI,'children'),'type','axes');
imgax = axs(2);
axonroi = findobj(imgax,'type','line');
axonimgobj = findobj(imgax,'type','image');
axonimg = get(axonimgobj,'Cdata');
imshow(axonimg,[],'initialmagnification','fit','parent',ax_ROI)
hold(ax_ROI,'on')
plot(ax_ROI,get(axonroi,'xdata'),get(axonroi,'ydata'),'color',[0 1 0]);
close(AxonROI)

uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiTerminals_Mask_150211_F4_C1_9_.fig',1)
AxonROI = gcf;

ax_ROI = panl(1,1).select();
cla(ax_ROI);
axs = findobj(get(AxonROI,'children'),'type','axes');
imgax = axs(2);
axonroi = findobj(imgax,'type','line');
axonimgobj = findobj(imgax,'type','image');
axonimg = get(axonimgobj,'Cdata');
imshow(axonimg,[],'initialmagnification','fit','parent',ax_ROI)
hold(ax_ROI,'on')
plot(ax_ROI,get(axonroi,'xdata'),get(axonroi,'ydata'),'color',[0 1 0]);
close(AxonROI)

uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\ContraTerminals_Mask_150203_F2_C1_5_.fig',1)
AxonROI = gcf;

ax_ROI = panl(1,3).select();
cla(ax_ROI);
axs = findobj(get(AxonROI,'children'),'type','axes');
imgax = axs(2);
axonroi = findobj(imgax,'type','line');
axonimgobj = findobj(imgax,'type','image');
axonimg = get(axonimgobj,'Cdata');
imshow(axonimg,[],'initialmagnification','fit','parent',ax_ROI)
hold(ax_ROI,'on')
plot(ax_ROI,get(axonroi,'xdata'),get(axonroi,'ydata'),'color',[0 1 0]);
close(AxonROI)

panl(1).margin = 2;


% uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\ContraTerminals_ROI_150203_F1_C1_4_BoutonExample.fig',1)
% BoutonROI = gcf;
% axs = get(BoutonROI,'children');
% imgax = axs(2);
% boutonroi = findobj(imgax,'type','line');
% plot(ax_ROI,get(boutonroi,'xdata'),get(boutonroi,'ydata'),'color',[.5 1 .5]);
% close(BoutonROI)

figure(ComparisonFig)

%uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\ContraTerminals_ChirpScimUp_150203_F2_C1_5_.fig',1)
uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\ContraTerminals_ChirpScimUp_150203_F1_C1_4_.fig',1)
AxonFluo = gcf;

axs = findobj(get(AxonFluo,'children'),'type','axes');
fluoax = axs(4);
freqax = axs(2);
stimax = axs(1);

ax_fluo = panl(2,1,1).select();
panl(2,1,1).marginbottom = 2;
cla(ax_fluo);
% ax_fluo_inset = panl(1,2,1,2).select();
% cla(ax_fluo_inset);

ax_freq = panl(2,1,3).select();
panl(2,1,3).margintop = 2;
cla(ax_freq);

ax_stim = panl(2,1,2).select();
panl(2,1,2).marginbottom = 2;
panl(2,1,2).margintop = 2;
cla(ax_stim);

% %% aside to Make a stimulus figure
% 
% StimulusFig = figure();
% 
% set(StimulusFig,'color',[1 1 1]);
% set(StimulusFig,'units','inches','position',[3 2 8.83  7.5])
% %set(ComparisonFig,'units','pixels','position',[300 200 768 678])
% 
% panl = panel(StimulusFig);
% panl.pack({[0 0 .45 .2] [.55 0 .45 .2]});
% 
% panl.fontsize = 18;
% panl.fontname = 'Arial';
% 
% axstart_stim = panl(1).select();
% c = copyobj(get(stimax,'children'), axstart_stim);
% 
% axend_stim = panl(2).select();
% c = copyobj(get(stimax,'children'), axend_stim);
% 
% xlim(axstart_stim,[-.1 .2])
% xlim(axend_stim,[9.5 10.1])
% set(axstart_stim,'TickDir','out')
% set(axend_stim,'TickDir','out')
% 
% panl(1).ylabel('V')
% panl(1).xlabel('Time (s)')
% 
% 
% cd(savedir)
% fn = ['ChirpStimulus_Poster_', ...
%     '.pdf'];
% 
% eval(['export_fig ''' fn '''  -pdf -transparent'])
% saveas(StimulusFig, fn(1:end-4),'fig')
% close(StimulusFig)
% 
% %%

c = copyobj(findobj(get(fluoax,'children'),'-not','type', 'text'), ax_fluo);
c = copyobj(findobj(get(freqax,'children'),'-not','type', 'text'), ax_freq);
c = copyobj(findobj(get(stimax,'children'),'-not','type', 'text'), ax_stim);

linkaxes([ax_fluo ax_freq ax_stim],'x');
axis(ax_fluo,'tight')
xlim(ax_fluo,[-3 14])
line(get(ax_fluo,'xlim'),[0 0],'color',[.8 .8 .8],'parent',ax_fluo)

ylim(ax_fluo,lesstight(get(ax_fluo,'ylim')));
ylim(ax_freq,[-.001 800])
set(ax_fluo,'TickDir','out','xtick',[])
set(ax_freq,'TickDir','out')
set(ax_stim,'xtick',[])
panl(2,1,1).ylabel('\DeltaF/F (%)'); 
% panl(1,2,1,2).ylabel('\DeltaF/F (%)'); 
panl(2,1,3).ylabel('Hz'); 
panl(2,1,3).xlabel('Time (s)'); 


% axs = get(BoutonFluo,'children');
% fluoax = axs(4);
% freqax = axs(2);
% stimax = axs(1);
% 
% c = copyobj(get(fluoax,'children'), ax_fluo_inset);
% axis(ax_fluo_inset,'tight')
% xlim(ax_fluo_inset,[-3 14])
% ylim(ax_fluo_inset,[-10 max(get(ax_fluo_inset,'ylim'))])
% 
% set(ax_fluo_inset,'TickDir','out')


close(AxonFluo)
% close(BoutonFluo)
figure(ComparisonFig)

% uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\ContraTerminals_ChirpScimUp_150203_F1_C1_4_BoutonExampleFamily.fig',1)
%uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiTerminals_ROI_150212_F2_C1_5_.fig',1)

ax_comp = panl(2,2).select();
cla(ax_comp);

uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiAMMC_Peaks_Troughs_Up.fig',1);
IpsiAMMC_up_fig = gcf;
axs = findobj(get(IpsiAMMC_up_fig,'children'),'type','axes');
ax_fluo = axs(4); ax_freq = axs(3); %#ok<NASGU>
peak_point = 1; trough_point = 2; leftfreq = 0;%#ok<*NASGU>
Script_GCaMP6s_Imaging_DotBox
close(IpsiAMMC_up_fig)
figure(ComparisonFig)

%
uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiTerminals_Peaks_Troughs_Up.fig',1);
IpsiTerminals_up_fig = gcf;
axs = findobj(get(IpsiTerminals_up_fig,'children'),'type','axes');
ax_fluo = axs(4);ax_freq = axs(3);
peak_point = 3;trough_point = 4;leftfreq = 1000;
Script_GCaMP6s_Imaging_DotBox
close(IpsiTerminals_up_fig)
figure(ComparisonFig)

%
uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\ContraTerminals_Peaks_Troughs_Up.fig',1);
ContraTerminals_up_fig = gcf;
axs = findobj(get(ContraTerminals_up_fig,'children'),'type','axes');
ax_fluo = axs(4);ax_freq = axs(3);
peak_point = 5;trough_point = 6; leftfreq = 2000;
Script_GCaMP6s_Imaging_DotBox
close(ContraTerminals_up_fig)
figure(ComparisonFig)

hold(ax_comp,'on')
plot(ax_comp,[.5 6.5],[0 0],'color',[1 1 1]*.8,'linestyle','--'), axis(ax_comp,'tight')
set(ax_comp,'xColor',[1 1 1]*0,'box','off','TickDir','out','xTick',[0 800 1000 2000],'xticklabel',{'0' '800'},'xlim',[-20 3000])
panl(2,2).ylabel('\DeltaF/F (%)'); 
panl(2,2).xlabel('Hz'); 

cd(savedir)
fn = ['ContraTerminal_poster_2_', ...
    '.pdf'];

eval(['export_fig ''' fn '''  -pdf'])
saveas(ComparisonFig, fn(1:end-4),'fig')


%% Format fig for poster
set(ComparisonFig,'position',[0 0   10.3   7])

panl.fontname = 'Arial';
panl.fontsize = 18;
panl.margin = [24 24 10 10];

%% Comparison of sizes
cd('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4')

SizeFigure = figure;

set(SizeFigure,'color',[1 1 1]);
%set(ComparisonFig,'units','pixels','position',[300 200 1024  768])
set(SizeFigure,'units','inches','position',[1 1 13 6.3])

panl = panel(SizeFigure);
panl.pack('v',{1/3,1/3 1/3});
array = 1/10 * ones(1,10);
array = num2cell(array);
panl(1).pack('h',array);
panl(2).pack('h',array);
panl(3).pack('h',array);
panl.margin = [1 1 1 1];

fn = {'Record_GCaMP6s_Imaging_IpsilateralAMMC'; 'Record_GCaMP6s_Imaging_Ipsilateral';'Record_GCaMP6s_Imaging_Contralateral'};
pxls_per_um_1024x1024_5x = 664/50 % count pixels in imgj for the micrometer at 1024x1024(Mehmet)
pxls_per_um_1024x1024 = pxls_per_um_1024x1024_5x/5;  % 
pxls_per_um_64x64 = pxls_per_um_1024x1024/1024 * 64;  % 
for panel_row = 1:3
    clear analysis_cell zoomfactor roi_areas
    eval(fn{panel_row});
    for cnt = 1:length(analysis_cell)
        if isempty(analysis_cell(cnt).ChirpUpTrial)
            continue
        end
        trial = load(analysis_cell(cnt).ChirpUpTrial);
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        prtclData = load(dfile);
        obj.prtclData = prtclData.data;
        obj.prtclTrialNums = obj.currentTrialNum;
        
        [f,i_info] = scimStackChan2Mask_Fig(obj.trial,obj.trial.params);
        descript = i_info.ImageDescription;
        ind_i = regexp(descript,'state.acq.zoomFactor=','end');
        ind_f = regexp(descript,'state.acq.zoomFactor=\d+','end');
        zoomfactor{cnt} = descript(ind_i+1:ind_f);
        
        panl_0 = panel.recover(f);
        imgax = panl_0(2).select();
        ax_ROI = panl(panel_row,cnt).select();
        
        roi = findobj(imgax,'type','line');
        x = get(roi,'xdata');
        y = get(roi,'ydata');
        roi_area = polyarea(get(roi,'xdata'),get(roi,'ydata'));
        roi_areas(cnt) = roi_area / (pxls_per_um_64x64 * str2double(zoomfactor{cnt}))^2;
        imgobj = findobj(imgax,'type','image');
        img = get(imgobj,'Cdata');
        %imshow(img,[],'initialmagnification',100*str2double(zoomfactor{cnt})/17,'parent',ax_ROI)
        imshow(img,[],'initialmagnification','fit','parent',ax_ROI)
        
        col = [1 1 0]+(cnt-1)/length(analysis_cell)*[-1 -1 1];
        line(get(roi,'xdata'),get(roi,'ydata'),'parent',ax_ROI,'color',col);
        panl(panel_row,cnt).title(['19/' zoomfactor{cnt}]);
        
        close(f)
        
        col = [1 1 0]+(cnt-1)/length(analysis_cell)*[-1 -1 1];
        area_ax = panl(panel_row,10).select();
        line(roi_areas(cnt),0,'linestyle','none','marker','o','markeredgecolor',col,'markerfacecolor','none','parent',area_ax);
    end
    line([mean(roi_areas),mean(roi_areas)],[-1 1],'linestyle','-','parent',area_ax);
    set(area_ax,'xlim',[0 200])
end
cd ..
fn = ['SizeCompFigure_', ...
    '.pdf'];

eval(['export_fig ''' fn '''  -pdf'])
saveas(SizeFigure, fn(1:end-4),'fig')



%%

% uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\ContraTerminals_Peaks_Troughs_Down.fig',1);
% ContraTerminals_down_fig = gcf;
% uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\ContraTerminals_Peaks_Troughs_Song.fig',1);
% ContraTerminals_song_fig = gcf;

% uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiAMMC_Peaks_Troughs_Down.fig',1);
% IpsiAMMC_down_fig = gcf;
% uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiAMMC_Peaks_Troughs_Song.fig',1);
% IpsiAMMC_song_fig = gcf;

% uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiTerminals_Peaks_Troughs_Down.fig',1);
% IpsiTerminals_down_fig = gcf;
% uiopen('C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\IpsiTerminals_Peaks_Troughs_Song.fig',1);
% IpsiTerminals_song_fig = gcf;
