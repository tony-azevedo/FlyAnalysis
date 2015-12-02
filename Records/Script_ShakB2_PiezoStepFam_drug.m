%% PiezoStep Fam Comparisons
fig = figure;
set(fig,'color',[1 1 1],'position',[14 468 1896 420])
pnl = panel(fig);

pnl.pack('h',length(analysis_cell))  % response panel, stimulus panel
pnl.margin = [18 10 2 10];
pnl.fontname = 'Arial';
%panl(1).marginbottom = 2;

ylims = [Inf -Inf];

for cnt = 1:length(analysis_cell)
    trial = load(analysis_cell(cnt).PiezoStepTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);
    
    pnl(cnt).pack('v',{2/3 1/3});
    pnl1 = pnl(cnt,1).select();
    pnl2 = pnl(cnt,2).select();
    
    PF_PiezoStepFamPnl(pnl1,pnl2,h,analysis_cell(cnt).name);
    
    fampnl(cnt) = pnl1;
    ylims = [...
        min([ylims(1) min(get(pnl1,'ylim'))]),...
        max([ylims(2) max(get(pnl1,'ylim'))])];

end
linkaxes(fampnl(:),'y')
set(fampnl(:),'ylim',ylims);
savePDFandFIG(fig,savedir,'PiezoStepFam',['PiezoStepFam_' auxid])