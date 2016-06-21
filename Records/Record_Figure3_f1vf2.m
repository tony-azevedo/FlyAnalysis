%% Record_Figure3 - take from the different types and agreggate here
close all

Scripts = {
%     'Record_FS_HighFreqDepolB1s'
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
pnl.pack('v',3)  
pnl_hs = nan(3,2);
for panl = 1:3
    pnl(panl).pack('h',2);
    pnl_hs(panl,1) = pnl(panl,1).select();
    pnl_hs(panl,2) = pnl(panl,2).select();
end
pnl.de.marginbottom = 12;
pnl.de.margintop = 2;

%% Figure 2AB: normalized response frequency curves for each type

for cell_type = 1:length(Scripts)

    eval(Scripts{cell_type});
    Script_FS_f1_f2;
    
    copyobj(get(frompnl(1).select(),'children'),pnl(cell_type,1).select())
    copyobj(get(frompnl(2).select(),'children'),pnl(cell_type,2).select())
    close(f)
        
end
pnl(2,1).ylabel('Fraction of Variance at F_s')
pnl(2,2).ylabel('Fraction of Variance at 2F_s')
pnl(3,1).xlabel('f (Hz)')
pnl(3,2).xlabel('f (Hz)')

set(pnl_hs(:),'tickdir','out');
set(pnl_hs(:),'xscale','log','xlim',[15 600],'xtick',[25 50 100 200 400],'ylim',[0 1])

%% Clean up
savedir = 'C:\Users\tony\Dropbox (Tuthill Lab)\AzevedoWilson_B1_MS\Figure2_Summary_of_frequency_tuning';
savePDF(fig,savedir,[],'Figure2_F1andF2ofVar')
