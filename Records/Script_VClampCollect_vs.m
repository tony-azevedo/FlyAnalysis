cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation\include\vSines\'
vs_figs = dir('*_VoltageSine_*.fig');
lg = false(size(vs_figs));
for idx = 1:length(vs_figs)
    if ~isempty(strfind(vs_figs(idx).name,'_2_5'))
        lg(idx) = true;
    end
end
vs_figs = vs_figs(lg);

fig = figure;
set(fig,'color',[1 1 1],'position',[17 611 1872 371],'name','VoltageRamp_Collection');

pnl = panel(fig);
pnl.margin = [20 20 10 10];
pnl.pack('h',7);
pnl.de.margin = [10 10 10 10];

for idx = 1:6
    pnl(idx).pack('h',7);
    set(pnl(1).select(),'tag','TTX'); title(pnl(1).select(),'TTX');
    set(pnl(2).select(),'tag','4AP'); title(pnl(2).select(),'4AP');
    set(pnl(3).select(),'tag','TEA'); title(pnl(3).select(),'TEA');
    set(pnl(4).select(),'tag','4AP_TEA'); title(pnl(4).select(),'4AP_TEA');
    set(pnl(5).select(),'tag','ZD'); title(pnl(5).select(),'ZD');
    set(pnl(6).select(),'tag','AChI'); title(pnl(6).select(),'AChI');

axs = [...
    pnl(1).select(),...
    pnl(2).select(),...
    pnl(3).select(),...
    pnl(4).select(),...
    pnl(5).select()...
    pnl(6).select()...
    ];


for rp_idx = 1:length(vs_figs)
    cell_id = vs_figs(rp_idx).name(1:12);
    cell_idx = find(strcmp(analysis_cells,cell_id));
    genotype = analysis_grid{cell_idx,2};
    
    uiopen(vs_figs(rp_idx).name,1);
    fromfig = gcf;
    
    fromax = findobj(fromfig,'tag','Xsensitive');
    lines = get(fromax,'children');
    for l_idx = 1:length(lines);
        tag = get(lines(l_idx),'tag');
        to_ax = findobj(fig,'tag',tag,'type','axes');
        if isempty(to_ax)
            switch tag
                case 'Cs'
                    to_ax = findobj(fig,'tag','ZD','type','axes');
                case {'curare','MLA','Cd'}
                    to_ax = findobj(fig,'tag','AChI','type','axes');
                otherwise
                    beep
                    fprintf('Add case for %s\n',tag);
            end
        end
        
        l = copyobj(lines(l_idx),to_ax);
        set(l,'displayname',cell_id)
        
    end
    close(fromfig)
end
linkaxes(axs)
set(pnl(1).select(),'xlim',[-90,-25],'ylim',[-100,200]);  

