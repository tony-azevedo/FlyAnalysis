%% PiezoSine Comparisons
fig = figure;
set(fig,'color',[1 1 1],'position',[14 468 1896 420])
pnl = panel(fig);

pnl.pack('h',length(analysis_cell))  % response panel, stimulus panel
pnl.margin = [16 16 2 10];
pnl.fontname = 'Arial';
%panl(1).marginbottom = 2;

ylims = [Inf -Inf];


for cnt = 1:length(analysis_cell)
    trial = load(analysis_cell(cnt).PiezoSineTrial_IClamp);
    h = getShowFuncInputsFromTrial(trial);
        
    fig = PF_PiezoSineMatrix([],h,analysis_cell(cnt).name);
    pnl = panel.recover(fig);
    pnl.title([auxid ': ' get(fig,'name')])
    
    savePDFandFIG(fig,savedir,'PiezoSineMatrices',[auxid '_PSneMatrix_' analysis_cell(cnt).name])
    
    close(fig)
end
