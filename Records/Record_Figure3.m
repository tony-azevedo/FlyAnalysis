%% Record_Figure3 - take from the different types and agreggate here
close all

Scripts = {
    'Record_FS_HighFreqDepolB1s'
    'Record_FS_BandPassHiB1s'
    'Record_FS_BandPassLowB1s'
    'Record_FS_LowPassB1s'
    };

% Script_FrequencySelectivity

% Plotting transfer from all cells at all displacements
fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 2 getpref('FigureSizes','NeuronOneColumn'), getpref('FigureSizes','NeuronOneColumn')])

pnl = panel(fig);
pnl.margin = [16 16 4 4];
pnl.pack('h',3)  
pnl_hs = nan(4,3);
for panl = 1:3
    pnl(panl).pack('v',4);
    for cell_type = 1:length(Scripts)
        pnl_hs(cell_type,panl) = pnl(panl,cell_type).select();
    end
end
pnl.de.marginbottom = 12;
pnl.de.margintop = 2;

%% Figure 2AB: normalized response frequency curves for each type

for cell_type = 1:length(Scripts)

    eval(Scripts{cell_type});
    Script_Figure2NormSelectivity;
    
    copyobj(get(frompnl(1).select(),'children'),pnl(1,cell_type).select())
    copyobj(get(frompnl(2).select(),'children'),pnl(2,cell_type).select())
    close(f)
        
end

%% Figure 2C: amplitude dependence of the responses

LTSfigure = figure; 
ax = subplot(1,1,1,'parent',LTSfigure);
Scripts_ = {
    'A2'
    'B1-BPH'
    'B1-BPM'
    'B1-BPL'
    };

for cell_type = 1:length(Scripts)

    eval(Scripts{cell_type});
    Script_Figure2AmplitudeDependence;
    
    copyobj(get(frompnl(1).select(),'children'),pnl(3,cell_type).select())
    close(f)
    
    fprintf('%s\n',Scripts_{cell_type});
    nanmean(lifetime_spareness,1)
    
    clr = [1 1 0]/length(Scripts)*(cell_type-1) + [0 0 1/length(Scripts)]*cell_type;
    plot(ax,(1:4)+(cell_type-1)*.15,lifetime_spareness,'.','color',clr,'displayname',Scripts_{cell_type}), hold on;
    l(cell_type) = plot(ax,(1:4)+(cell_type-1)*.15,nanmean(lifetime_spareness,1),...
        'marker','o','markersize',6,'markeredgecolor',clr,'markerfacecolor',clr,...
        'color',clr,'displayname',Scripts{cell_type});
    leg_str{cell_type} = Scripts_{cell_type};
end
legend(ax,l,leg_str)
set(ax,'xtick',[1 2 3 4],'XTickLabel',{'0.045' '0.15' '0.45' '1.5'})
xlabel('amplitude (\mum)');
ylabel('Lifetime Kurtosis');

ylim(ax,[-2.3 4.1])
xlim(ax,[.5 4.9])

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure2/';
savePDF(LTSfigure,savedir,[],'Figure2_Kurtosis')

%% Clean up
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure2/';

pnl(1).ylabel('normalized'), pnl(2).ylabel('|F(f)| (mV)'),pnl(3).ylabel('|F(f)| (mV)')
pnl(1).xlabel('f (Hz)'), pnl(2).xlabel('f (Hz)'),pnl(3).xlabel('f (Hz)')

set(pnl_hs(:),'tickdir','out');
set(pnl_hs(:,3),'xscale','log','xlim',[15 600],'xtick',[25 50 100 200 400])

text(300,10,[num2str(all_dsplcmnts(3),2) ' V'],'parent',pnl_hs(4,2));

h = findobj(pnl(3,4).select(),'type','line','-not','linestyle','none');
legend(pnl(3,4).select(),h,get(h,'DisplayName'))
legend(pnl(3,4).select(),'boxoff');

savePDF(fig,savedir,[],'Figure2')
