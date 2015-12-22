cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation\include\vSteps\'
step_figs = dir('*VoltageSteps.fig');

close all
fig = figure;
set(fig,'color',[1 1 1],'position',[17 403 1872 579],'name','VoltageStep_Collection');

pnl = panel(fig);
pnl.margin = [20 20 10 10];
pnl.pack(1,8);
pnl.de.margin = [10 10 10 10];

tags = {'Total','AChI','TTX','4AP','TEA','4AP_TEA','ZD','All'};
pnl_hs = nan(1,length(tags));
for r_idx = 1:length(tags)
    for c_idx = 1:size(pnl_hs,1);
        pnl_hs(c_idx,r_idx) = pnl(c_idx,r_idx).select();
        pnl(c_idx,r_idx).xlabel('mV');
        pnl(c_idx,r_idx).ylabel('pA');
    end
    set(pnl(1,r_idx).select(),'tag',tags{r_idx});
    pnl(1,r_idx).title(tags{r_idx});
end


%%
for sp_idx = 1:length(step_figs)
    cell_id = step_figs(sp_idx).name(1:12);
    cell_idx = find(strcmp(analysis_cells,cell_id));
    genotype = analysis_grid{cell_idx,2};
    
    uiopen(step_figs(sp_idx).name,1);
    fromfig = gcf;
    
        
    fromax = findobj(fromfig,'type','axes','-regexp','tag','IV');

    to_ax = findobj(fig,'type','axes','tag','All');
    l = copyobj(findobj(fromax(1),'type','line','DisplayName','Ipeak vs. V'),to_ax);
    set(l,'displayname',cell_id,'tag',genotype)
    
    for a_idx = 1:length(fromax);
        tag = get(fromax(a_idx),'tag');
        tag = tag(3:end);
        to_ax = findobj(fig,'tag',tag,'type','axes');
        if isempty(to_ax)
            switch tag
                case 'Cs'
                    to_ax = findobj(fig,'tag','ZD','type','axes');
                case {'curare','MLA','Cd','aBTX'}
                    to_ax = findobj(fig,'tag','AChI','type','axes');
                case {'theoretical','total','ctrl'}
                    to_ax = findobj(fig,'tag','Total','type','axes');
                otherwise
                    beep
                    keyboard
                    fprintf('Add case for %s\n',tag);
            end
        end
        
        l = copyobj(findobj(fromax(a_idx),'type','line','DisplayName','Imean vs. V'),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)            

        l = copyobj(findobj(fromax(a_idx),'type','line','DisplayName','Ipeak vs. V'),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)            

    end
        
    % Is there a control fig? if not use the curare fig?
    fromax = findobj(fromfig,'type','axes','-regexp','tag','IVctrl');
    if isempty(fromax)
        fromax = findobj(fromfig,'type','axes','-regexp','tag','IVcurare');
        to_ax = findobj(fig,'tag','Total','type','axes');
        
        l = copyobj(findobj(fromax,'type','line','DisplayName','Imean vs. V'),to_ax);
        set(l,'displayname',cell_id,'tag',genotype,'color',[0 1 0],'markerfacecolor',[0 1 0],'markeredgecolor',[0 1 0])             

        l = copyobj(findobj(fromax,'type','line','DisplayName','Ipeak vs. V'),to_ax);
        set(l,'displayname',cell_id,'tag',genotype,'color',[0 1 0],'markerfacecolor',[0 1 0],'markeredgecolor',[0 1 0])            
    end
        
    close(fromfig)
end

linkaxes(pnl_hs)
axis(pnl_hs(1,end),'tight')
set(pnl_hs(1,end),'xlim',[-110 -23],'ylim',[-200 250])
%set(pnl(1).select(),'xlim',[-90,-25],'ylim',[-100,200]);  

%% Remove the Ipeak vs. V curves 
delete(findobj(fig,'type','line','linestyle',':'));
%set(findobj(fig,'type','line','linestyle',':'),'linestyle','-');

%% change the colors and average
if ~isempty(strfind(savedir,'include'))
    genotypes = {'10XUAS-mCD8:GFP;FruGal4';'20XUAS-mCD8:GFP;VT27938-Gal4';'20XUAS-mCD8:GFP;VT30609-Gal4'};
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


%% Cells in which TTX was applied before 4AP TEA
TTX_first = {
'150722_F1_C2'
'151022_F1_C1'
'151022_F2_C1'
'151029_F3_C1'
'151030_F1_C1'
};

TTX_second = {
'150922_F2_C1'
'151001_F1_C1'
'151001_F2_C1'
'151007_F3_C1'
'151009_F1_C1'
};

TTX_never = {
'151007_F1_C1'
'151007_F3_C1'
'151021_F3_C1'
};

IVTTX_fig = figure;
set(IVTTX_fig,'color',[1 1 1],'position',[1005 536 884 446],'name','VoltageStep_IV_TTX_Comparison');

IVTTX_pnl = panel(IVTTX_fig);
IVTTX_pnl.margin = [20 20 10 10];
IVTTX_pnl.pack(1,2);
IVTTX_pnl.de.margin = [10 10 10 10];

IVTTX_pnl_hs = nan(1,2);
for c_idx = 1:size(IVTTX_pnl_hs,2);
    IVTTX_pnl_hs(1,c_idx) = IVTTX_pnl(1,c_idx).select();
end

to_ax_total = IVTTX_pnl_hs(1,1);
IVTTX_pnl(1,1).title('Control');
IVTTX_pnl(1,1).xlabel('mV');
IVTTX_pnl(1,1).ylabel('pA');

total_ax = findobj(fig,'tag','Total');

total_ls = findobj(total_ax,'type','line');
for lidx = 1:length(total_ls)
    if sum(strcmp(TTX_first,get(total_ls(lidx),'Displayname')))
        l = copyobj(total_ls(lidx),to_ax_total);
    end
end

to_ax_ttx = IVTTX_pnl_hs(1,2);
IVTTX_pnl(1,2).title('TTX (before 4AP TEA)');

ttx_ax = findobj(fig,'tag','TTX');

ttx_ls = findobj(ttx_ax,'type','line');
for lidx = 1:length(ttx_ls)
    if sum(strcmp(TTX_first,get(ttx_ls(lidx),'Displayname')))
        l = copyobj(ttx_ls(lidx),to_ax_ttx);
    end
end
linkaxes([to_ax_total to_ax_ttx])
set(to_ax_total,'xlim',[-110 -23],'ylim',[-200 250])

savePDFandFIG(IVTTX_fig,savedir,[],'IV_TTX_first')


%% Total currents

IV_fig = figure;
set(IV_fig,'color',[1 1 1],'position',[1376 536 513 446],'name','VoltageStep_IV');

IV_pnl = panel(IV_fig);
IV_pnl.margin = [20 20 10 10];
IV_pnl.pack(1);
IV_pnl.de.margin = [10 10 10 10];

IV_pnl_hs = IV_pnl(1).select();

to_ax_total = IV_pnl_hs;
IV_pnl(1).xlabel('mV');
IV_pnl(1).ylabel('pA');

total_ax = findobj(fig,'tag','Total');

total_ls = findobj(total_ax,'type','line');
l = copyobj(total_ls,to_ax_total);

set(to_ax_total,'xlim',[-110 -23],'ylim',[-200 250])

savePDFandFIG(IV_fig,savedir,[],'IV')

%%

ls = findobj(to_ax_total,'type','line');
for l = 1:length(ls)
    x = get(ls(l),'xdata');
    set(ls(l),'xdata',x-get(ls(l),'userdata'));
end

set(to_ax_total,'xlim',[-62 20],'ylim',[-200 300])
savePDFandFIG(IV_fig,savedir,[],'IV_0shifted')

%%
legend(legend_lines,genotypes);
legend(pnl_hs(1,end),'boxoff');
savePDFandFIG(fig,savedir,[],'IV_DrugConditions')

