cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\PiezoSine\'
rvf_figs = dir('*VClamp_RvF.fig');

close all
fig = figure;
set(fig,'color',[1 1 1],'position',[782 152 1107 830],'name','RespVsFreq_Collection');

pnl = panel(fig);
pnl.margin = [20 20 10 10];
pnl.pack('v',{2/3 1/3});
pnl(1).pack('h',2)
pnl(2).pack('h',2)
pnl.de.margin = [10 10 10 10];

genotypes = {   '10XUAS-mCD8:GFP/+;FruGal4/+'                           '20XUAS-mCD8:GFP;VT27938-Gal4';
                'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'        'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'
}
genotypes = genotypes(2,:);
amplitudes = {'0.05 V', '0.15 V'};
pnl_hs = nan(2,2);
for r_idx = 1:size(pnl_hs,1)
    for c_idx = 1:size(pnl_hs,2);
        pnl_hs(c_idx,r_idx) = pnl(c_idx,r_idx).select();
    end
    pnl(1,r_idx).title(amplitudes{r_idx});
    set(pnl_hs(1,r_idx),'tag',[amplitudes{r_idx} 'magnitude_ax']);
    set(pnl_hs(2,r_idx),'tag',[amplitudes{r_idx} 'phase_ax']);
end

pnl(1,1).ylabel('pA');
pnl(2,1).ylabel('degrees');
pnl(2,1).xlabel('Hz');


%%
for rvf_idx = 1:length(rvf_figs)
    cell_id = rvf_figs(rvf_idx).name(1:12);
    cell_idx = find(strcmp(analysis_cells,cell_id));
    genotype = analysis_grid{cell_idx,2};
    
    uiopen(rvf_figs(rvf_idx).name,1);
    fromfig = gcf;
    
           
    for aidx = 1:length(amplitudes);
        fromax = findobj(fromfig,'type','axes','-regexp','tag','magnitude_ax');
        to_ax = findobj(fig,'type','axes','-regexp','tag',[amplitudes{aidx} 'magnitude_ax']);
    
        l = copyobj(findobj(fromax,'type','line','DisplayName',amplitudes{aidx}),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)
    
        fromax = findobj(fromfig,'type','axes','-regexp','tag','phase_ax');
        to_ax = findobj(fig,'type','axes','-regexp','tag',[amplitudes{aidx} 'phase_ax']);
        
        l = copyobj(findobj(fromax,'type','line','DisplayName',amplitudes{aidx}),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)
    end
    close(fromfig)
end
%%
set(pnl_hs(:),'xscale','log')
linkaxes(pnl_hs(1,:))
linkaxes(pnl_hs(2,:))
axis(pnl_hs(1,end),'tight')

%set(pnl(1).select(),'xlim',[-90,-25],'ylim',[-100,200]);  

%% change the colors and average
if ~isempty(strfind(savedir,'include'))
    genotypes = {'10XUAS-mCD8:GFP/+;FruGal4/+';'20XUAS-mCD8:GFP;VT27938-Gal4';'pJFRC7;VT30609-Gal4'};
end

clrs = [
    0 0 1
    1 0 0
    0 1 0
    ];
% lghtclrs = [
%     .7 .7 1
%     1 .7 .7
%     .7 1 .7
%     ];
% lghtrclrs = [
%     .9 .9 1
%     1 .9 .9
%     .9 1 .9
%     ];

base_clr = [1 1 1]*0.92;
set(findobj(fig,'type','line'),'color',base_clr,'markerfacecolor',base_clr,'markeredgecolor',base_clr);

%% Turn the genotypes different colors
for g = 1:length(genotypes)
    genotype = genotypes{g};
    for r = 1:size(pnl_hs,1)
        for c = 1:size(pnl_hs,2)
            ls = findobj(pnl_hs(r,c),'color',base_clr,'type','line','tag',genotype);
            if ~isempty(ls)
                                                
                set(ls,'color',clrs(g,:),'markerfacecolor',clrs(g,:),'markeredgecolor',clrs(g,:))
                legend_lines(g) = ls(1);
            end
        end
    end
end


%%
legend(legend_lines,genotypes);
legend(get(legend_lines(1),'parent'),'boxoff');
savePDFandFIG(fig,savedir,[],'RespVFreq')


%% example cells
%close exfig cellfig

example1 = '151017_F2_C1';
%example1 = '151108_F2_C1';
%example1 = '151030_F1_C1';

cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\PiezoSine\'
uiopen([example1 '_VClamp.fig'],1);
exfig = gcf; 
axchi = get(exfig,'children');
pmpnl = nan(length(axchi),3);
for aidx = 1:length(axchi);
    t = findobj(axchi(aidx),'type','text');
    if isempty(t)
        continue
    end
    txt = get(t,'String');
    pmpnl(aidx,1) = axchi(aidx);
    pmpnl(aidx,2) = round(str2double(txt(1:regexp(txt,'Hz')-1)));
    pmpnl(aidx,3) = str2double(txt(regexp(txt,'Hz')+2:regexp(txt,'mum')-2))/3;
end

cnt = find(strcmp(analysis_cells,example1));
ac = analysis_cell(cnt);
Script_VoltageClamp_ExampleUtility
trial = load(VClampCtrlSineTrial);
stim = PiezoSine;
stim.setParams(trial.params);

cellfig = figure;
set(cellfig,'color',[1 1 1],'position',[1256 159 587 807],'name','Example');

pnl = panel(cellfig);
pnl.margin = [20 20 10 10];
pnl.pack('v',3);
pnl(1).pack('v',{4/5 1/5})
pnl(2).pack('v',{4/5 1/5})
pnl(3).pack('v',{4/5 1/5})
pnl.de.margin = [10 10 10 10];

ax35 = pmpnl(pmpnl(:,2)==35&pmpnl(:,3)==0.15,1);
ax71 = pmpnl(pmpnl(:,2)==71&pmpnl(:,3)==0.15,1);
ax141 = pmpnl(pmpnl(:,2)==141&pmpnl(:,3)==0.15,1);

pnlhs = nan(3,2);

copyobj(get(ax35,'children'),pnl(1,1).select());
x = get(findobj(pnl(1,1).select(),'type','line','color',[.7 0 0]),'xdata');
xlims = [min(x),max(x)];
stim.setParams('freqs',25*sqrt(2)^(1));
out = stim.getStimulus;
t = makeOutTime(stim.params); win = t>=xlims(1)&t<=xlims(2);
line(t(win),out.speakercommand(win),'parent',pnl(1,2).select(),'color',[0 0 1])
pnlhs(1,1) = pnl(1,1).select(); pnlhs(1,2) = pnl(1,2).select();
axis(pnlhs(1,1),'tight');

copyobj(get(ax71,'children'),pnl(2,1).select());
stim.setParams('freqs',25*sqrt(2)^(3));
out = stim.getStimulus;
line(t(win),out.speakercommand(win),'parent',pnl(2,2).select(),'color',[0 0 1])
pnlhs(2,1) = pnl(2,1).select(); pnlhs(2,2) = pnl(2,2).select();
axis(pnlhs(2,1),'tight');

copyobj(get(ax141,'children'),pnl(3,1).select());
stim.setParams('freqs',25*sqrt(2)^(5));
out = stim.getStimulus;
line(t(win),out.speakercommand(win),'parent',pnl(3,2).select(),'color',[0 0 1])
pnlhs(3,1) = pnl(3,1).select(); pnlhs(3,2) = pnl(3,2).select();
axis(pnlhs(3,1),'tight');

linkaxes(pnlhs(:,1),'y')
set(pnlhs(1:end-1),'xtick',[],'xcolor',[1 1 1])
axis(pnlhs(:),'tight');
axis(pnlhs(2,1),'tight');
pnl(3,2).xlabel('s');
pnl(1,1).ylabel('pA');
pnl(1,1).title(ac.name);

savePDFandFIG(cellfig,savedir,[],[ac.name '_select'])

set(pnlhs(:),'xlim',[-.02 .08])

savePDFandFIG(cellfig,savedir,[],[ac.name '_zoom'])








