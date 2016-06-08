%% Record_FigureS2 - take from the different types and agreggate here
% close all

Scripts = {
    'Record_FS_HighFreqDepolB1s'
    'Record_FS_BandPassHiB1s'
    'Record_FS_BandPassLowB1s'
    'Record_FS_LowPassB1s'
    };

% Script_FrequencySelectivity

% Plotting transfer from all cells at all displacements
% fig = figure;
% fig.Units = 'inches';
% set(fig,'color',[1 1 1],'position',[1 2 getpref('FigureSizes','NeuronOneColumn'), getpref('FigureSizes','NeuronOneColumn')])
% 
% pnl = panel(fig);
% pnl.margin = [16 16 4 4];
% pnl.pack('h',3)  
% pnl_hs = nan(4,3);
% for panl = 1:3
%     pnl(panl).pack('v',4);
%     for cell_type = 1:length(Scripts)
%         pnl_hs(cell_type,panl) = pnl(panl,cell_type).select();
%     end
% end
% pnl.de.marginbottom = 12;
% pnl.de.margintop = 2;

%% Figure 2AB: normalized response frequency curves for each type

% Record_FS_BandPassHiB1s_CurrentStep
% Script_FS_CurrentChirpAndSteps
% savedir = 'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure_Summary_of_frequency_tuning\draft_material';
% savePDFandFIG(f,savedir,[],'FigureS3_Steps_BPH')
% B1H = f;
% 
% Record_FS_BandPassLowB1s
% Script_FS_CurrentChirpAndSteps
% savedir = 'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure_Summary_of_frequency_tuning\draft_material';
% savePDFandFIG(f,savedir,[],'FigureS3_Steps_BPM')
% B1M = f;
% 
% Record_FS_LowPassB1s_CurrentStep
% Script_FS_CurrentChirpAndSteps
% savedir = 'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure_Summary_of_frequency_tuning\draft_material';
% savePDFandFIG(f,savedir,[],'FigureS3_Steps_BPL')
% B1L = f;

%%

fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 2 8.5 4])
pnl = panel(fig);
pnl.margin = [16 16 4 4];
pnl.pack('h',3)  
% pnl_hs = nan(4,3);
% for panl = 1:3
%     pnl(panl).pack('v',4);
%     for cell_type = 1:length(Scripts)
%         pnl_hs(cell_type,panl) = pnl(panl,cell_type).select();
%     end
% end
% pnl.de.marginbottom = 12;
% pnl.de.margintop = 2;

axs = findobj(B1H,'type','axes','-regexp','tag','IV_');
for a = 1:length(axs)
    h = copyobj(findobj(axs(a),'type','line','color',[0 0 0]),pnl(1).select());
    set(h,'tag',get(axs(a),'tag'));
    
    x = h.XData;
    y = h.YData;
    [x,o] = sort(x);
    y = y(o);
    set(h,'xdata',x(x>-125),'ydata',y(x>-125));
end
xlim(pnl(1).select(),[-130 40]);
ylim(pnl(1).select(),[-80 20]);

axs = findobj(B1M,'type','axes','-regexp','tag','IV_');
for a = 1:length(axs)
    h = copyobj(findobj(axs(a),'type','line','color',[0 0 0]),pnl(2).select());
    set(h,'tag',get(axs(a),'tag'));
    
    x = h.XData;
    y = h.YData;
    [x,o] = sort(x);
    y = y(o);
    set(h,'xdata',x(x>-125),'ydata',y(x>-125));
end
xlim(pnl(2).select(),[-130 40]);
ylim(pnl(2).select(),[-80 20]);

axs = findobj(B1L,'type','axes','-regexp','tag','IV_');
for a = 1:length(axs)
    h = copyobj(findobj(axs(a),'type','line','color',[0 0 0]),pnl(3).select());
    set(h,'tag',get(axs(a),'tag'));
    
    x = h.XData;
    y = h.YData;
    [x,o] = sort(x);
    y = y(o);
    set(h,'xdata',x(x>-125),'ydata',y(x>-125));
end
xlim(pnl(3).select(),[-130 40]);
ylim(pnl(3).select(),[-80 20]);

genomap = {'Fru','VT27938','GH86','63A03','VT45599','45D07','VT30609'};
colrmap = {[0 0 1],[1 0 0],[0 1 0],[0 1 0],[1 .7 .7],[1 0 1],[.8 .8 .8]};
lgndmap = {[],     [],     [],     [],     [],       [],     []};
for p = 1:3
    ls = findobj(pnl(p).select(),'type','line');
    switch p
        case 1, Record_FS_BandPassHiB1s_CurrentStep
        case 2, Record_FS_BandPassLowB1s
        case 3, Record_FS_LowPassB1s_CurrentStep
    end
    
    lgndmap = [];
    lgndmap_ = {};
    for l = 1:length(ls)
        name = regexprep(ls(l).Tag,'IV_','');
        ac = analysis_cell(strcmp(analysis_cells,name));
        for g = 1:length(genomap)
            if ~isempty(strfind(ac.genotype,genomap{g}))
                set(ls(l),'color',colrmap{g});
                if isempty(lgndmap)
                    lgndmap = ls(l);
                    lgndmap_ = genomap(g);
                elseif ~sum(strcmp(lgndmap_,genomap{g}))
                    lgndmap(end+1) = ls(l);
                    lgndmap_{end+1} = genomap{g};
                end
            end
        end
    end
    legend(pnl(p).select(),lgndmap,lgndmap_,'Location','NorthWest');
end

savedir = 'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure_Summary_of_frequency_tuning\draft_material';
savePDFandFIG(fig,savedir,[],'FigureS3_Steps_All')

fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 2 8.5 4])
pnl_ = panel(fig);
pnl_.margin = [16 16 4 4];
pnl_.pack('h',1)  


for p = 1:3
    ls = findobj(pnl(p).select(),'type','line');
    clear x y
    x = [];
    for l = 1:length(ls)
        x = [x,ls(l).XData];
    end
    x = unique(x);
    y = nan(length(x),l);
    for l = 1:length(ls)
        x_ = ls(l).XData;
        y_ = ls(l).YData;
        
        [~,IA,~] = intersect(x,x_);
        y(IA,l) = ls(l).YData;
    end
    plot(pnl_(1).select(),x,nanmean(y,2)), hold on
end
savedir = 'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure_Summary_of_frequency_tuning\draft_material';
savePDFandFIG(fig,savedir,[],'FigureS3_Steps_All_Mean')

