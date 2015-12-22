cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation\include\vSteps\'
step_figs = dir('*VoltageSteps.fig');

close all
fig = figure;
set(fig,'color',[1 1 1],'position',[17 403 1872 579],'name','VoltageStep_Collection');

pnl = panel(fig);
pnl.margin = [20 20 10 10];
pnl.pack(2,8);
pnl.de.margin = [10 10 10 10];

tags = {'Total','AChI','TTX','4AP','TEA','4AP_TEA','ZD','All'};
pnl_hs = nan(2,length(tags));
for c_idx = 1:size(pnl_hs,2)
    for r_idx = 1:size(pnl_hs,1);
        pnl_hs(r_idx,c_idx) = pnl(r_idx,c_idx).select();
        pnl(r_idx,c_idx).xlabel('s');
        pnl(r_idx,c_idx).ylabel('pA');
    end
    set(pnl(1,c_idx).select(),'tag',[tags{c_idx} '+']);
    set(pnl(2,c_idx).select(),'tag',[tags{c_idx} '-']);
    pnl(1,c_idx).title(tags{c_idx});
end


%%
for sp_idx = 1:length(step_figs)
    cell_id = step_figs(sp_idx).name(1:12);
    cell_idx = find(strcmp(analysis_cells,cell_id));
    genotype = analysis_grid{cell_idx,2};
    
    uiopen(step_figs(sp_idx).name,1);
    fromfig = gcf;
    
    fromax = findobj(fromfig,'type','axes','-regexp','tag','Currents_');
        
    disp(cell_id)
    for a_idx = 1:length(fromax)
        disp(get(fromax(a_idx),'tag'));
    end
    disp('')
    
    %the first axis is always the final condition
    
    to_ax = findobj(fig,'type','axes','tag','All+');
    l = copyobj(findobj(fromax(1),'type','line','tag','10'),to_ax);
    set(l,'displayname',cell_id,'tag',genotype)

    to_ax = findobj(fig,'type','axes','tag','All-');
    l = copyobj(findobj(fromax(1),'type','line','tag','-60'),to_ax);
    set(l,'displayname',cell_id,'tag',genotype)
    
    for a_idx = 1:length(fromax);
        tag = get(fromax(a_idx),'tag');
        tag = tag(10:end);
        to_ax = findobj(fig,'type','axes','tag',[tag '+']);
        if isempty(to_ax)
            switch tag
                case 'Cs'
                    to_ax = findobj(fig,'tag','ZD+','type','axes');
                case {'curare','MLA','Cd','aBTX'}
                    to_ax = findobj(fig,'tag','AChI+','type','axes');
                case {'theoretical','total','ctrl'}
                    to_ax = findobj(fig,'tag','Total+','type','axes');
                otherwise
                    beep
                    keyboard
                    fprintf('Add case for %s\n',tag);
            end
        end
        
        l = copyobj(findobj(fromax(a_idx),'type','line','tag','10'),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)            

        to_ax = findobj(fig,'type','axes','tag',[tag '-']);
        if isempty(to_ax)
            switch tag
                case 'Cs'
                    to_ax = findobj(fig,'tag','ZD-','type','axes');
                case {'curare','MLA','Cd','aBTX'}
                    to_ax = findobj(fig,'tag','AChI-','type','axes');
                case {'theoretical','total','ctrl'}
                    to_ax = findobj(fig,'tag','Total-','type','axes');
                otherwise
                    beep
                    keyboard
                    fprintf('Add case for %s\n',tag);
            end
        end
        
        l = copyobj(findobj(fromax(a_idx),'type','line','tag','-60'),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)
        
    end
        
    % Is there a control fig? if not use the curare fig?
    fromax = findobj(fromfig,'type','axes','-regexp','tag','Currents_ctrl');
    if isempty(fromax)
        fromax = findobj(fromfig,'type','axes','-regexp','tag','Currents_curare');
        
        to_ax = findobj(fig,'tag','Total+','type','axes');        
        l = copyobj(findobj(fromax,'type','line','tag','10'),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)

        to_ax = findobj(fig,'tag','Total-','type','axes');
        l = copyobj(findobj(fromax,'type','line','tag','-60'),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)

    end
        
    close(fromfig)
end

linkaxes(pnl_hs)
axis(pnl_hs(1,end),'tight')
set(pnl_hs(1,end),'xlim',[-.02 .12],'ylim',[-800 350])
%set(pnl(1).select(),'xlim',[-90,-25],'ylim',[-100,200]);  


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
'151117_F1_C1'
'151118_F1_C1'
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

VstepTTX_fig = figure;
set(VstepTTX_fig,'color',[1 1 1],'position',[1025  53 851 849],'name','VoltageStep_IV_TTX_Comparison');

VstepTTX_pnl = panel(VstepTTX_fig);
VstepTTX_pnl.margin = [20 20 10 10];
VstepTTX_pnl.pack(2,2);
VstepTTX_pnl.de.margin = [10 10 10 10];

VstepTTX_pnl_hs = nan(2,2);
for r_idx = 1:size(VstepTTX_pnl_hs,1);
    for c_idx = 1:size(VstepTTX_pnl_hs,2);
        VstepTTX_pnl_hs(r_idx,c_idx) = VstepTTX_pnl(r_idx,c_idx).select();
    end
end

to_ax_total = VstepTTX_pnl_hs(1,1);
VstepTTX_pnl(1,1).title('Control');
VstepTTX_pnl(1,1).ylabel('pA');

total_ax = findobj(fig,'tag','Total+');
total_ls = findobj(total_ax,'type','line');
for lidx = 1:length(total_ls)
    if sum(strcmp(TTX_first,get(total_ls(lidx),'Displayname')))
        l = copyobj(total_ls(lidx),to_ax_total);
    end
end

to_ax_total = VstepTTX_pnl_hs(2,1);
VstepTTX_pnl(2,1).ylabel('pA');
VstepTTX_pnl(2,1).xlabel('s');

total_ax = findobj(fig,'tag','Total-');
total_ls = findobj(total_ax,'type','line');
for lidx = 1:length(total_ls)
    if sum(strcmp(TTX_first,get(total_ls(lidx),'Displayname')))
        l = copyobj(total_ls(lidx),to_ax_total);
    end
end


to_ax_ttx = VstepTTX_pnl_hs(1,2);
VstepTTX_pnl(1,2).title('TTX (before 4AP TEA)');

ttx_ax = findobj(fig,'tag','TTX+');
ttx_ls = findobj(ttx_ax,'type','line');
for lidx = 1:length(ttx_ls)
    if sum(strcmp(TTX_first,get(ttx_ls(lidx),'Displayname')))
        l = copyobj(ttx_ls(lidx),to_ax_ttx);
    end
end

to_ax_ttx = VstepTTX_pnl_hs(2,2);
VstepTTX_pnl(2,2).xlabel('s');

ttx_ax = findobj(fig,'tag','TTX-');
ttx_ls = findobj(ttx_ax,'type','line');
for lidx = 1:length(ttx_ls)
    if sum(strcmp(TTX_first,get(ttx_ls(lidx),'Displayname')))
        l = copyobj(ttx_ls(lidx),to_ax_ttx);
    end
end


linkaxes(VstepTTX_pnl_hs(:))
set(to_ax_total,'xlim',[-.01 .11],'ylim',[-600 150])

for g = 1:2
    kon_ = [0 0 0];
    y_top = -Inf;
    ls = findobj(VstepTTX_pnl_hs(1,2),'type','line','tag',genotypes{g});
    for l = 1:length(ls)
        x = get(ls(l),'xdata');
        y = get(ls(l),'ydata');
        y = y(x>0.0005&x<0.04);
        y_top = max([y_top,max(y)]);
        x = x(x>0.0005&x<0.04);
        
        kon = nlinfit(x-x(1),y,@exponential,[100,-100,.001]);
        kon_ = kon_ + kon;
        line(x,exponential(kon,x-x(1)),'color',get(ls(l),'color')+[0 .7 0],'parent',VstepTTX_pnl_hs(1,2));
    end
    kon_ = kon_/l;
    line(x,exponential(kon_,x-x(1)),'color',[0 0 0],'parent',VstepTTX_pnl_hs(1,2),'linewidth',2);
    text(0.04,y_top,sprintf('k_a = %.2f ms',kon_(3)*1000),'verticalalignment','bottom','horizontalalignment','right','parent',VstepTTX_pnl_hs(1,2));
end


savePDFandFIG(VstepTTX_fig,savedir,[],'Vstep_TTX_first')


%% Total currents

Vstep_fig = figure;
set(Vstep_fig,'color',[1 1 1],'position',[1338 336 551 646],'name','VoltageStep');

Vstep_pnl = panel(Vstep_fig);
Vstep_pnl.margin = [20 20 10 10];
Vstep_pnl.pack(2,1);
Vstep_pnl.de.margin = [10 10 10 10];

Vstep_pnl_hs(1,1) = Vstep_pnl(1,1).select();
Vstep_pnl_hs(2,1) = Vstep_pnl(2,1).select();

to_ax_total = Vstep_pnl_hs(1,1);
Vstep_pnl(1,1).xlabel('s');
Vstep_pnl(1,1).ylabel('pA');

total_ax = findobj(fig,'tag','Total+');

total_ls = findobj(total_ax,'type','line');
l = copyobj(total_ls,to_ax_total);

to_ax_total = Vstep_pnl_hs(2,1);
Vstep_pnl(2,1).xlabel('s');
Vstep_pnl(2,1).ylabel('pA');

total_ax = findobj(fig,'tag','Total-');

total_ls = findobj(total_ax,'type','line');
l = copyobj(total_ls,to_ax_total);


set(Vstep_pnl_hs(1,1),'xlim',[-.01 .05],'ylim',[-20 150])
set(Vstep_pnl_hs(2,1),'xlim',[-.01 .05],'ylim',[-800 50])

for g = 1:2
    kon_ = [0 0 0];
    y_top = -Inf;
    ls = findobj(Vstep_pnl_hs(1,1),'type','line','tag',genotypes{g});
    for l = 1:length(ls)
        x = get(ls(l),'xdata');
        y = get(ls(l),'ydata');
        y = y(x>0.0005&x<0.04);
        y_top = max([y_top,max(y)]);
        x = x(x>0.0005&x<0.04);
        
        kon = nlinfit(x-x(1),y,@exponential,[100,-100,.001]);
        kon_ = kon_ + kon;
        line(x,exponential(kon,x-x(1)),'color',get(ls(l),'color')+[0 .7 0],'parent',Vstep_pnl_hs(1,1));
    end
    kon_ = kon_/l;
    line(x,exponential(kon_,x-x(1)),'color',[0 0 0],'parent',Vstep_pnl_hs(1,1),'linewidth',2);
    text(0.04,y_top,sprintf('k_a = %.2f ms',kon_(3)*1000),'verticalalignment','bottom','horizontalalignment','right','parent',Vstep_pnl_hs(1,1));
end

savePDFandFIG(Vstep_fig,savedir,[],'Vstep_on')

%%
set(Vstep_pnl_hs(1,1),'xlim',[.1-.01 .1+.05],'ylim',[-20 150])
set(Vstep_pnl_hs(2,1),'xlim',[.1-.01 .1+.05],'ylim',[-800 50])

for g = 1:2
    koff_ = [0 0 0];
    y_top = -Inf;
    ls = findobj(Vstep_pnl_hs(1,1),'type','line','tag',genotypes{g});
    ls_ex = findobj(Vstep_pnl_hs(1,1),'type','line','displayname','150722_F1_C2');
    ls = ls(ls~=ls_ex);
    for l = 1:length(ls)
        x = get(ls(l),'xdata');
        y = get(ls(l),'ydata');
        y = y(x>0.101 &x<0.15);
        y_top = max([y_top,max(y)]);
        x = x(x>0.101 &x<0.15);
        
        koff = nlinfit(x-x(1),y,@exponential,[100,100,.01]);
        koff_ = koff_ + koff;
        line(x,exponential(koff,x-x(1)),'color',get(ls(l),'color')+[0 .7 0],'parent',Vstep_pnl_hs(1,1));
    end
    koff_ = koff_/l;
    line(x,exponential(koff_,x-x(1)),'color',[0 0 0],'parent',Vstep_pnl_hs(1,1),'linewidth',2);
    text(0.14,y_top,sprintf('k_a = %.2f ms',koff_(3)*1000),'verticalalignment','bottom','horizontalalignment','right','parent',Vstep_pnl_hs(1,1));
end

savePDFandFIG(Vstep_fig,savedir,[],'Vstep_off')


%%
legend(legend_lines,genotypes);
legend(pnl_hs(2,end),'boxoff');
savePDFandFIG(fig,savedir,[],'Vstep_DrugConditions')

