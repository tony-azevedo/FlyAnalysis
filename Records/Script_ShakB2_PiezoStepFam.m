%% PiezoStep Fam Comparisons
fig = figure;
set(fig,'color',[1 1 1],'position',[14 222 1896 640])
pnl = panel(fig);

pnl.pack('h',length(analysis_cell))  % response panel, stimulus panel
pnl.margin = [18 10 2 10];
pnl.fontname = 'Arial';
%panl(1).marginbottom = 2;

ylims = [Inf -Inf];
fampnl = nan(3,length(analysis_cell));
for cnt = 1:length(analysis_cell)
    trial = load(analysis_cell(cnt).PiezoStepTrial_IClamp);
    h = getShowFuncInputsFromTrial(trial);
    
    pnl(cnt).pack('v',{4/9 4/9 1/9});
    pnl1 = pnl(cnt,1).select();
    pnl2 = pnl(cnt,2).select();
    pnl3 = pnl(cnt,3).select();
    
    PF_PiezoStepFamPnl(pnl1,pnl3,h,analysis_cell(cnt).name);
    
    if isfield(analysis_cell(cnt),'PiezoStepTrial_IClamp_Drug') && ~isempty(analysis_cell(cnt).PiezoStepTrial_IClamp_Drug);
        trial = load(analysis_cell(cnt).PiezoStepTrial_IClamp_Drug);
        h = getShowFuncInputsFromTrial(trial);
        PF_PiezoStepFamPnl(pnl2,pnl3,h,'Drug');
                
        ylims = [...
            min([ylims(1) min(get(pnl2,'ylim'))]),...
            max([ylims(2) max(get(pnl2,'ylim'))])];
        
    end

    fampnl(1,cnt) = pnl1;
    fampnl(2,cnt) = pnl2;
    fampnl(3,cnt) = pnl3;
    ylims = [...
        min([ylims(1) min(get(pnl1,'ylim'))]),...
        max([ylims(2) max(get(pnl1,'ylim'))])];

end
set(fampnl(1:2,:),'ylim',ylims);
pnl(1,3).xlabel('s');
pnl(1,1).ylabel('mV');
pnl(1,2).ylabel('mV');

savePDFandFIG(fig,savedir,'PiezoStepFam',['PiezoStepFam_' auxid])

set(fampnl(:),'xlim',[-.02 .05]);
savePDFandFIG(fig,savedir,'PiezoStepFam',['PiezoStepFam_' auxid '_zoom'])
