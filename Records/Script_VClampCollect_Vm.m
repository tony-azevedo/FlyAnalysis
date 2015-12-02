cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation\include\Vm\'
Vm_figs = dir('*Vm.fig');

fig = figure;
set(fig,'color',[1 1 1],'position',[158   465   512   488],'name','VoltageStep_Collection');

pnl = panel(fig);
pnl.margin = [20 20 10 10];
pnl.pack('h',1);
to_ax = pnl(1).select();

for f_idx = 1:length(Vm_figs)
    cell_id = Vm_figs(f_idx).name(1:12);
    cell_idx = find(strcmp(analysis_cells,cell_id));
    genotype = analysis_grid{cell_idx,2};
    
    uiopen(Vm_figs(f_idx).name,1);
    fromfig = gcf;
    
    fromax = findobj(fromfig,'type','axes');
    lines = get(fromax,'children');
    for l_idx = 1:length(lines);
        l = copyobj(lines(l_idx),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)
        %         if length(get(l),'xdata')==2
        %             set(l,'displayname',cell_id,'tag',genotype)
        %         end
            
    end
        
    close(fromfig)
end

set(pnl(1).select(),'xlim',[-.1,1.1]);  

hold(pnl(1).select(),'on')

%% change the colors and average
if ~isempty(strfind(savedir,'include'))
    genotypes = {'10XUAS-mCD8:GFP/+;FruGal4/+';'20XUAS-mCD8:GFP;VT27938-Gal4';'pJFRC7;VT30609-Gal4'};
end

clrs = [
    0 0 .7
    .7 0 0
    0 .7 0
    ];
lghtclrs = [
    .7 .7 1
    1 .7 .7
    .7 1 .7
    ];
lghtrclrs = [
    .9 .9 1
    1 .9 .9
    .9 1 .9
    ];

base_clr = [1 1 1]*0.92;
set(findobj(fig,'type','line'),'color',base_clr);

%%
geno_nicknames = {'Fru','VT27938','VT30609'};
for g = 1:length(genotypes)
    genotype = genotypes{g};
    set(findobj(pnl(1).select(),'marker','o','tag',genotype),'markeredgecolor',clrs(g,:));
    set(findobj(pnl(1).select(),'marker','none','tag',genotype),'color',lghtclrs(g,:));
    
    
    ls = findobj(pnl(1).select(),'marker','none','tag',genotype);
    v_ = zeros(length(ls),2);
    
    for l = 1:length(ls)
        v_(l,:) = get(ls(l),'ydata');
    end
    
    SEM = std(v_,[],1)/sqrt(size(v_,1));
    %ts = tinv([0.025  0.975],size(v_,1)-1);
    ts = [-1 1];
    
    erbr = errorbar(get(ls(l),'xdata'),mean(v_,1),ts(1)*SEM,'color',clrs(g,:),'linewidth',2);
    
    eval([geno_nicknames{g} '_v_ = v_;']);
end

% Stats:
[H,P,CI] = ttest2(Fru_v_(:,1),VT27938_v_(:,1));


%%
figure(fig)
eval(['export_fig ' 'VmCollection.pdf' ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,'VmCollection','fig');
