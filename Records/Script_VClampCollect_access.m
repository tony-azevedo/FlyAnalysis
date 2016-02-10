cd(savedir)
cd access\

access_figs = dir('*access.fig');

fig = figure;
set(fig,'color',[1 1 1],'position',[262         147        1627         835],'name','Access_Collection');

pnl = panel(fig);
pnl.margin = [20 20 20 20];
pnl.pack('v',{1/2 1/2});
pnl(1).pack('h',{1/3 1/3 1/3});
pnl.de.margin = [16 16 16 16];

% set(pnl(1,1).select(),'tag','TTX'); title(pnl(1,1).select(),'TTX');
clrs = distinguishable_colors(length(access_figs),{'w','k',[1 1 0],[1 1 1]*.75});

%%
for af_idx = 1:length(access_figs)
    cell_id = access_figs(af_idx).name(1:12);
    cell_idx = find(strcmp(analysis_cells,cell_id));
    genotype = analysis_grid{cell_idx,2};
    
    uiopen(access_figs(af_idx).name,1);
    fromfig = gcf;
    
    fromax = findobj(fromfig,'type','axes');
    access_dots = findobj(fromax,'tag','access');    

    access = nan(size(access_dots));
    access_time = access;
    for a_idx = 1:length(access_dots);
        access(a_idx) = get(access_dots(a_idx),'ydata');
        access_time(a_idx) = get(access_dots(a_idx),'xdata');
    end        
    
    access_time = access_time(~isnan(access));
    access = access(~isnan(access));
    
    [X,deltax] = optimalBinWidth(access);
    [N,X] = hist(access,X);

    Z = (X-median(access))/mean(access);
    norm_distr = N/(sum(N)*diff(Z(1:2)));
    halfmax = max(norm_distr)/2;

    d = line(X,norm_distr,...
        'color',clrs(af_idx,:),...
        'displayname',cell_id,...
        'tag',cell_id,...
        'parent',pnl(1,1).select());
    if median(access) < 0.06, 
        set(d,'color',[.9 .9 .9]), 
    else
        set(d,'linewidth',2)
        line(access_time-access_time(1),access,...
            'color',clrs(af_idx,:),...
                'linestyle','none','marker','.','markerfacecolor',clrs(af_idx,:),'markeredgecolor',clrs(af_idx,:),...
            'displayname',cell_id,...
            'tag',cell_id,...
            'parent',pnl(2).select());
    end
    
    n = line(Z*100,norm_distr,...
        'color',clrs(af_idx,:),...
        'color',clrs(af_idx,:),...
        'displayname',cell_id,...
        'tag',cell_id,...
        'parent',pnl(1,2).select());
        
    if sum(norm_distr(Z<-0.15 | Z>0.15) > halfmax) 
        set(n,'linewidth',2)
        if isempty(findobj(pnl(2).select(),'tag',cell_id))
            line(access_time-access_time(end),access,...
                'color',clrs(af_idx,:),...
                'linestyle','none','marker','.','markerfacecolor',clrs(af_idx,:),'markeredgecolor',clrs(af_idx,:),...
                'displayname',cell_id,...
                'tag',cell_id,...
                'parent',pnl(2).select());
        end
    else
        set(n,'color',[.9 .9 .9]);
    end
    

    c = line(X(N==max(N)),std(access)/mean(access),...
        'marker','o','markersize',4,...
        'markerfacecolor',clrs(af_idx,:),...
        'markeredgecolor',clrs(af_idx,:),...
        'displayname',cell_id,...
        'tag',cell_id,...
        'parent',pnl(1,3).select());

    if std(access)/mean(access) > .3
        set(c,'markersize',8)
        if isempty(findobj(pnl(2).select(),'tag',cell_id))
            line(access_time-access_time(end),access,...
                'color',clrs(af_idx,:),...
                'linestyle','none','marker','.','markerfacecolor',clrs(af_idx,:),'markeredgecolor',clrs(af_idx,:),...
                'displayname',cell_id,...
                'tag',cell_id,...
                'parent',pnl(2).select());
        end
    end

    close(fromfig)

end
%%
set(pnl(1,1).select(),'xlim',[0,.32]); 
uistack(findobj(pnl(1,1).select(),'linewidth',2),'top');
pnl(1,1).xlabel('Access (G\Omega)');
pnl(1,1).ylabel('Access pdf');

set(pnl(1,2).select(),'xlim',[-40,40]);  
uistack(findobj(pnl(1,2).select(),'linewidth',2),'top');
pnl(1,2).xlabel('% Access changes (G\Omega)');
pnl(1,2).ylabel('% Access pdf');

pnl(1,3).xlabel('Access mode (G\Omega)')
pnl(1,3).ylabel('CV')

set(pnl(2).select(),'ylim',[0,.32]); 
legend(pnl(2).select(),'toggle')
l = findobj(fig,'Tag','legend');
set(l,'location','NorthWest','interpreter','none','box','off');
dots = findobj(l,'marker','.');
set(dots,'marker','o')
for d_idx = 1:length(dots)
    set(dots(d_idx),'markerfacecolor',get(dots(d_idx),'color'))
end
pnl(2).xlabel('time (AU)');
pnl(2).ylabel('Access (G\Omega)');

savePDF(fig,savedir,[],'Access_Collection')