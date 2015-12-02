cd(savedir)
cd vSines\

vs_figs = dir('*_VoltageSine_*.fig');
lg = false(size(vs_figs));
for r_idx = 1:length(vs_figs)
    if ~isempty(strfind(vs_figs(r_idx).name,'_2_5'))
        lg(r_idx) = true;
    end
end
vs_figs = vs_figs(~lg);

fig = figure;
set(fig,'color',[1 1 1],'position',[17 31 1872 963],'name','VoltageSine_7_5V_Collection');

pnl = panel(fig);
pnl.margin = [20 20 10 10];
pnl.pack('v',7);
pnl.de.margin = [10 10 10 10];

tags = {'TTX','4AP','TEA','4AP_TEA','ZD','AChI'};
freqs = {'25','100','141','200'};
pnl_hs = nan(length(tags),length(freqs));

for r_idx = 1:length(tags)
    pnl(r_idx).pack('h',4);
    for c_idx = 1:length(freqs)
        set(pnl(r_idx,c_idx).select(),'tag',[tags{r_idx} '_' freqs{c_idx}]); 
        pnl_hs(r_idx,c_idx) = pnl(r_idx,c_idx).select();
    end
    pnl(r_idx,1).ylabel(tags{r_idx});
end
pnl(r_idx+1).pack('h',4);
for c_idx = 1:length(freqs)
    set(pnl(r_idx+1,c_idx).select(),'tag',['Total_' freqs{c_idx}]);
    pnl_hs(r_idx+1,c_idx) = pnl(r_idx+1,c_idx).select();    
end

VS_amplitude = ones(size(analysis_cells));
for vs_idx = 1:length(vs_figs)
    cell_id = vs_figs(vs_idx).name(1:12);
    idx = regexp(vs_figs(vs_idx).name,'V\.');
    vsa = vs_figs(vs_idx).name(idx-2:idx);
    switch vsa
        case '_5V'
            VS_amplitude(vs_idx) = 7.5;
        case '10V'
            VS_amplitude(vs_idx) = 10;
    end
    cell_idx = find(strcmp(analysis_cells,cell_id));
    genotype = analysis_grid{cell_idx,2};
    
    uiopen(vs_figs(vs_idx).name,1);
    fromfig = gcf;
    
    for c_idx = 1:length(freqs)
        freq_ls = findobj(fromfig,'-regexp','tag',['_' freqs{c_idx}]);
        for l_idx = 1:length(freq_ls);
            tag = regexprep(get(freq_ls(l_idx),'tag'),['_' freqs{c_idx}],'');
            to_ax = findobj(fig,'tag',[tag '_' freqs{c_idx}],'type','axes');
            if isempty(to_ax) 
                switch tag
                    case 'Cs'
                        to_ax = findobj(fig,'tag',['ZD_' freqs{c_idx}],'type','axes');
                    case {'curare','MLA','Cd','aBTX'}
                        to_ax = findobj(fig,'tag',['AChI_' freqs{c_idx}],'type','axes');
                    case {'rem', 'current'}
                    otherwise
                        beep
                        fprintf('Add case for %s\n',tag);
                end
            end
            l = copyobj(freq_ls(l_idx),to_ax);
            set(l,'displayname',cell_id,'tag',genotype,'color',[0 0 0]);
                       
            f = findobj(get(freq_ls(l_idx),'parent'),'tag','fiducials');
            curfid = findobj(to_ax,'tag','fiducials');
            if isempty(curfid) 
                copyobj(f,to_ax);
            end
        end
        freq_current = findobj(fromfig,'tag',['current_' freqs{c_idx}]);
        freq_rem = findobj(fromfig,'tag',['rem_' freqs{c_idx}]);
        to_ax = pnl(length(tags)+1,c_idx).select();
        l = copyobj(freq_rem,to_ax);
        set(l,'ydata',get(freq_current,'ydata')-get(freq_rem,'ydata'),'color',[0 0 0],'displayname',cell_id,'tag',genotype);
    end

    close(fromfig)
end

% Add 4AP_TEA traces if not already there
for c_idx = 1:length(freqs)
    TEA_ax = findobj(fig,'type','axes','tag',['TEA_' freqs{c_idx}]);
    AP_ax = findobj(fig,'type','axes','tag',['4AP_' freqs{c_idx}]);
    TEA_freq_ls = findobj(TEA_ax,'type','line','-not','tag','fiducials');

    for l_idx = 1:length(TEA_freq_ls);
        l1 = findobj(AP_ax,'displayname',get(TEA_freq_ls(l_idx),'displayname'),'type','line');
        if ~isempty(l1)
            to_ax_ = findobj(fig,'tag',['4AP_TEA_' freqs{c_idx}],'type','axes');
            l2 = copyobj(TEA_freq_ls(l_idx),to_ax_);
            set(l2,'ydata',get(l1,'ydata')+get(l2,'ydata'));
        end
        set(l2,'color',[0 0 1]);
    end
end

linkaxes(pnl_hs(:),'off')
axis(pnl_hs(:),'tight')
ylims = [Inf -Inf];
maxdiff = -Inf;
for r_idx = 1:size(pnl_hs,1)
    for c_idx = 1:size(pnl_hs,2)
        yl = get(pnl_hs(r_idx,c_idx),'ylim');
        maxdiff = max([maxdiff, diff(yl)]);
        ylims(1) = min([ylims(1) yl(1)]);
        ylims(2) = max([ylims(2) yl(2)]);
    end
end

for r_idx = 1:size(pnl_hs,1)
    linkaxes(pnl_hs(r_idx,:),'y');
    yl = get(pnl_hs(r_idx,1),'ylim');
    set(pnl_hs(r_idx,:),'ylim',mean(yl)+maxdiff/2*[-1 1]);
    
    yl = get(pnl_hs(r_idx,1),'ylim');
    xl = get(pnl_hs(r_idx,1),'xlim');
    l = findobj(get(pnl_hs(r_idx,1),'children'),'type','line','-not','tag','fiducials');
    text(xl(1),yl(2),['N=',num2str(length(l))],'verticalalignment','top','parent',pnl_hs(r_idx,1),'fontsize',8)
    
    fiducials = findobj(pnl_hs(r_idx,:),'tag','fiducials');
    set(fiducials,'ydata',mean(yl)+maxdiff/2*[-1 1]);
end
yl = get(pnl_hs(end,1),'ylim');
for c_idx = 1:size(pnl_hs,2)
    l = copyobj(findobj(pnl_hs(end-1,c_idx),'tag','fiducials'),pnl_hs(end,c_idx));
    set(l,'ydata',mean(yl)+maxdiff/2*[-1 1]);
end
set(pnl_hs(:),'yColor',[1 1 1],'ytick',[],'xcolor',[1 1 1],'xtick',[]);
set(pnl_hs(:,1),'yColor',[0 0 0],'ytickMode','auto');
    

% figure(fig)
% eval(['export_fig ' 'VoltageSine_7_5V_Collection.pdf' ' -pdf -transparent']);
% 
% set(fig,'paperpositionMode','auto');
% saveas(fig,'VoltageSine_7_5V_Collection','fig');

%% Turn all lines a particular color
base_clr = [1 1 1]*0.92;
currents = findobj(fig,'type','line','-not','tag','fiducials');
set(currents,'color',base_clr);

%% Highlight Voltage conditions
lgcl = VS_amplitude==10;
tenVcells = analysis_cells(lgcl);

clr = [0 0 1];
set(findobj(fig,'color',clr,'type','line'),'color',base_clr);

for t_idx = 1:length(tenVcells)
    ls = findobj(fig,'displayname',tenVcells{t_idx},'type','line');
    set(ls,'color',clr);
end
for i = 1:length(pnl_hs(:))
    uistack(findobj(pnl_hs(i),'color',clr,'type','line'),'top');
end

%% undo
% set(findobj(fig,'color',clr,'type','line'),'color',base_clr);

%% put away
for i = 1:length(pnl_hs(:))
    uistack(findobj(pnl_hs(i),'color',clr,'type','line'),'bottom');
    set(findobj(pnl_hs(i),'color',clr,'type','line'),'color',[1 1 1]);
end

%% Highlight individual cells
%     '150718_F1_C1'
%     '150720_F1_C2'
%     '150721_F2_C1'
%     '150722_F1_C2'
%     '150913_F2_C1'
%     '150922_F2_C1'
%     '151001_F1_C1'
%     '151001_F2_C1'
%     '151002_F2_C1'
%     '151007_F1_C1'
%     '151007_F3_C1'
%     '151007_F4_C1'
%     '151009_F1_C1'

% '150923_F1_C1'    [1x27 char]    [1x36 char]
%     '151005_F1_C1'    [1x27 char]    [1x47 char]
%     '151005_F2_C1'    [1x27 char]    [1x47 char]
%     '151006_F3_C1'    [1x27 char]    [1x24 char]
%     '151006_F3_C2'
%     
% cellname = '151007_F1_C1';
% clr = [0 0 1];
% 
% set(findobj(fig,'color',clr,'type','line'),'color',base_clr);
% ls = findobj(fig,'type','line','displayname',cellname);
% set(ls,'color',clr);
% 
% for i = 1:length(pnl_hs(:))
%     uistack(findobj(pnl_hs(i),'type','line','color',clr),'top');
% end

%% Highlight reject cells
% '150913_F2_C1'	High access                     150913_F2_C1_access
% '151002_F2_C1'	High access, but stable			151002_F2_C1_access
% '151007_F4_C1' 	high access variance';          150903_F1_C1_InputR.pdf 151007_F4_C1_access

% rejects = {'151007_F1_C1'};
% clr = [0 0 1];
% 
% set(findobj(fig,'color',clr,'type','line'),'color',base_clr);
% for r = 1:length(rejects)
%     ls = findobj(fig,'type','line','displayname',rejects{r});
%     set(ls,'color',clr);
% end
% 
% for i = 1:length(pnl_hs(:))
%     uistack(findobj(pnl_hs(i),'type','line','color',clr),'top');
% end
% 
% %% put away or delete
% for i = 1:length(pnl_hs(:))
% %     uistack(findobj(pnl_hs(i),'color',clr,'type','line'),'bottom');
% %     set(findobj(pnl_hs(i),'color',clr,'type','line'),'color',[1 1 1]);
%     delete(findobj(pnl_hs(i),'color',clr,'type','line'));
% end


%% Highlight weird conditions
% '151001_F1_C1'	access drift for ZD ONLY        151001_F1_C1_access
% '151001_F2_C1'	curare ONLY, changed Vh			151001_F2_C1_VoltageSine_Currents_7_5V
% '151007_F1_C1'	Low access	for curare ONLY     151007_F1_C1_access

clr = [1 0 0];
set(findobj(fig,'color',clr,'type','line'),'color',base_clr);
rejects = {
    '151001_F1_C1', 'ZD'};  %'151001_F2_C1', 'AChI'};

for r = 1:size(rejects,1)
    wrd_axes = findobj(fig,'type','axes','-regexp','tag',rejects{r,2});
    set(findobj(wrd_axes,'type','line','displayname',rejects{r,1}),'color',clr,'tag','reject_altered');
    for w_idx = 1:length(wrd_axes)
        axtag = get(wrd_axes(w_idx),'tag');
        totalaxis = findobj(fig,'type','axes','-regexp','tag',['Total_' axtag(length(rejects{r,2})+2:end)]);

        tot_l = findobj(totalaxis,'type','line','displayname',rejects{r,1});
        ls = findobj(wrd_axes(w_idx),'type','line','displayname',rejects{r,1});
        
        tot_l_copy = copyobj(tot_l,totalaxis);
        set(tot_l_copy,'color',[0 1 0],'tag','reject_altered');
        set(tot_l,'ydata',get(tot_l,'ydata')+get(ls,'ydata'),'color',[0 0 1]);
    end
end

%% put away or delete
% for i = 1:length(pnl_hs(:))
%     uistack(findobj(pnl_hs(i),'tag','reject_altered','type','line'),'bottom');
%     set(findobj(pnl_hs(i),'tag','reject_altered','type','line'),'color',[1 1 1]);
% end
% set(findobj(fig,'color',[0 0 1],'type','line'),'color',base_clr);

for i = 1:length(pnl_hs(:))
    delete(findobj(pnl_hs(i),'tag','reject_altered','type','line'));
end
set(findobj(fig,'color',[0 0 1],'type','line'),'color',base_clr);

%% Undo
% set(findobj(fig,'color',clr,'type','line'),'color',base_clr);

%% Highlight Fru vs VT cells

genotype = '10XUAS-mCD8:GFP/+;FruGal4/+';
genotype = '20XUAS-mCD8:GFP;VT27938-Gal4';

clr = [0 0 1];

set(findobj(fig,'color',clr,'type','line'),'color',base_clr);
ls = findobj(fig,'color',base_clr,'type','line','tag',genotype);
set(ls,'color',clr);

for i = 1:length(pnl_hs(:))
    uistack(findobj(pnl_hs(i),'type','line','color',clr),'top');
end


%% Average Fru vs VT cells
if ~isempty(strfind(savedir,'sham'))
    genotypes = {'10XUAS-mCD8:GFP/+;FruGal4/+'};
end
if ~isempty(strfind(savedir,'include'))
    genotypes = {'10XUAS-mCD8:GFP/+;FruGal4/+';'20XUAS-mCD8:GFP;VT27938-Gal4';'pJFRC7;VT30609-Gal4'};
end
if ~isempty(strfind(savedir,'cesiumPara'))
    genotypes = {'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi';'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'};
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

set(findobj(fig,'color',clr,'type','line'),'color',base_clr);

for g = 1:length(genotypes)
    genotype = genotypes{g};
    for r = 1:size(pnl_hs,1)
        for c = 1:size(pnl_hs,2)
            ls = findobj(pnl_hs(r,c),'color',base_clr,'type','line','tag',genotype);
            if ~isempty(ls)
                maxlength = -Inf;
                for l = 1:length(ls)
                    if length(get(ls(l),'ydata')) > maxlength
                        
                        maxlength = length(get(ls(1),'ydata'));
                        midx = l;
                    end
                end
                set(ls,'color',lghtclrs(g,:))
                
                ave = copyobj(ls(midx),pnl_hs(r,c));
                set(ave,'tag',[genotype '_ave'],'color',clrs(g,:));
                
                traces = nan(length(ls),length(get(ave,'ydata')));
                for l = 1:length(ls)
                    traces(l,1:length(get(ls(l),'ydata'))) = get(ls(l),'ydata');
                end
                
                y = nanmean(traces,1);
                x = get(ave,'xdata');
                
                set(ave,'ydata',y);
                
                SEM = nanstd(traces,1)/sqrt(size(traces,1));
                %ts = tinv([0.025  0.975],size(traces,1)-1);
                ts = [-1 1];
                CI_patch_up = y + ts(1)*SEM; 
                CI_patch_down = y + ts(2)*SEM; 
                
                p = patch(...
                    [x(:);flipud(x(:))],...
                    [CI_patch_up(:);flipud(CI_patch_down(:))],...
                    lghtrclrs(g,:),'edgecolor',lghtrclrs(g,:),'edgealpha',0,'parent',pnl_hs(r,c));
                uistack(p,'bottom');
            end
        end
    end
end

if ~isempty(strfind(savedir,'include'))
    
    for r_idx = 1:size(pnl_hs,1)
        
        yl = get(pnl_hs(r_idx,1),'ylim');
        xl = get(pnl_hs(r_idx,1),'xlim');
        l = findobj(get(pnl_hs(r_idx,1),'children'),'type','line','-not','tag','fiducials');
    end
    
    linkaxes(pnl_hs(:),'off')
    axis(pnl_hs(:),'tight')
    ylims = [Inf -Inf];
    maxdiff = -Inf;
    for r_idx = 1:size(pnl_hs,1)
        for c_idx = 1:size(pnl_hs,2)
            yl = get(pnl_hs(r_idx,c_idx),'ylim');
            maxdiff = max([maxdiff, diff(yl)]);
            ylims(1) = min([ylims(1) yl(1)]);
            ylims(2) = max([ylims(2) yl(2)]);
        end
    end
    
    for r_idx = 1:size(pnl_hs,1)
        linkaxes(pnl_hs(r_idx,:),'y');
        yl = get(pnl_hs(r_idx,1),'ylim');
        set(pnl_hs(r_idx,:),'ylim',mean(yl)+maxdiff/2*[-1 1]);
        
        fiducials = findobj(pnl_hs(r_idx,:),'tag','fiducials');
        set(fiducials,'ydata',mean(yl)+maxdiff/2*[-1 1]);
    end
    fprintf('Y-Limits: %.2f \n',round(mean(yl)+maxdiff/2*[-1 1]))
else
    for r_idx = 1:size(pnl_hs,1)
        linkaxes(pnl_hs(r_idx,:),'y');
        set(pnl_hs(r_idx,:),'ylim',[-39 64]);
        
        fiducials = findobj(pnl_hs(r_idx,:),'tag','fiducials');
        set(fiducials,'ydata',[-39 64]);
    end
end

set(findobj(fig,'type','patch'),'facealpha',0)
% delete(findobj(fig,'type','patch'));

figure(fig)
eval(['export_fig ' 'VoltageSine_7_5V_ByGenotype_Traces.pdf' ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,'VoltageSine_7_5V_ByGenotype_Traces','fig');

set(findobj(fig,'type','patch'),'facealpha',1)
set(findobj(fig,'type','patch'),'edgealpha',0);

% set(findobj(fig,'type','line','color',lghtclrs(1,:),'-or','color',lghtclrs(2,:)),'color',[1 1 1]);
% for pidx = 1:length(pnl_hs(:))
%     uistack(findobj(pnl_hs(7,4),'type','line','color',[1 1 1]),'bottom');
% end
delete(findobj(fig,'type','line','color',lghtclrs(1,:),'-or','color',lghtclrs(2,:)))

figure(fig)
eval(['export_fig ' 'VoltageSine_7_5V_ByGenotype_95ci.pdf' ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,'VoltageSine_7_5V_ByGenotype__95ci','fig');

% for g = 1:length(genotypes)
%     set(findobj(pnl_hs(:),'color',[1 1 1],'type','line','tag',genotype),'color',lghtclrs(g,:));
% end

