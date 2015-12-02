cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation\include\ramps\'
%cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation\control\ramps\'
ramp_figs = dir('*Currents.fig');

fig = figure;
set(fig,'color',[1 1 1],'position',[17 611 1872 371],'name','VoltageRamp_Collection');

tags = {'TTX','4AP','TEA','4AP_TEA','ZD','AChI','Total'};
tags = {'TTX','4AP','4AP_TEA','ZD','AChI','Total'};

pnl = panel(fig);
pnl.margin = [20 20 10 10];
pnl.pack('h',length(tags));
pnl.de.margin = [10 10 10 10];

pnl_hs = nan(1,length(tags));
for r_idx = 1:length(tags)
    pnl_hs(r_idx) = pnl(r_idx).select();
    set(pnl(r_idx).select(),'tag',tags{r_idx});
    pnl(r_idx).title(tags{r_idx});
end

for rp_idx = 1:length(ramp_figs)
    cell_id = ramp_figs(rp_idx).name(1:12);
    cell_idx = find(strcmp(analysis_cells,cell_id));
    genotype = analysis_grid{cell_idx,2};
    
    uiopen(ramp_figs(rp_idx).name,1);
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
                case {'curare','MLA','Cd','aBTX'}
                    to_ax = findobj(fig,'tag','AChI','type','axes');
                case {'theoretical','total'}
                    to_ax = findobj(fig,'tag','Total','type','axes');
                otherwise
                    beep
                    %keyboard
                    fprintf('Add case for %s\n',tag);
            end
        end
        
        l = copyobj(lines(l_idx),to_ax);
        set(l,'displayname',cell_id,'tag',genotype)
        if strcmp(get(lines(l_idx),'tag'),'theoretical')
            %keyboard
            set(l,'displayname',cell_id,'tag',[genotype '_theoretical'])
        end
            
    end
        
    close(fromfig)
end

linkaxes(pnl_hs)
set(pnl(1).select(),'xlim',[-90,-25],'ylim',[-200,200]);  



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
cellname = '151128_F2_C1';
clr = [0 0 1];

set(findobj(fig,'color',clr,'type','line'),'color',base_clr);
ls = findobj(fig,'type','line','displayname',cellname);
set(ls,'color',clr);

for i = 1:length(pnl_hs(:))
    uistack(findobj(pnl_hs(i),'type','line','color',clr),'top');
end

%%
for g = 1:length(genotypes)
    genotype = genotypes{g};
    for r = 1:size(pnl_hs,1)
        for c = 1:size(pnl_hs,2)
            ls = findobj(pnl_hs(r,c),'color',base_clr,'type','line','tag',genotype);
            if ~isempty(ls)
                                                
                set(ls,'color',lghtclrs(g,:))
                
            end
            set(findobj(pnl_hs(r,c),'color',lghtclrs(3,:),'type','line','tag',genotype),'linewidth',2);
        end
    end
end


%%
if ~isempty(strfind(savedir,'include'))
genotypes = {'10XUAS-mCD8:GFP/+;FruGal4/+';'20XUAS-mCD8:GFP;VT27938-Gal4'};
end
for g = 1:length(genotypes)
    genotype = genotypes{g};
    for r = 1:size(pnl_hs,1)
        for c = 1:size(pnl_hs,2)
            ls = findobj(pnl_hs(r,c),'color',lghtclrs(g,:),'type','line','tag',genotype);
            if ~isempty(ls)
                
                % need to match up the voltage vectors
                v = get(ls,'xdata');
                i = get(ls,'ydata');
                
                minintrv = [-Inf Inf];
                for l = 1:length(v)
                    minintrv(1) = max([minintrv(1),v{l}(1)]);
                    minintrv(2) = min([minintrv(2),v{l}(end)]);
                end
                minsamples = Inf;
                for l = 1:length(v)
                    v_ = unique(v{l});
                    minsamples = min(sum(v_>=minintrv(1) & v_<=minintrv(2)));
                end
                
                v_standard = linspace(minintrv(1), minintrv(2), minsamples);
                i_traces = nan(length(ls),length(v_standard));
                
                for l = 1:length(v)
                    [v_,uidx] = unique(v{l},'last');
                    if diff(uidx(end-1:end))>1
                        uidx(end) = uidx(end-1)+1;
                    end
                    i_ = i{l}(uidx);
                    
                    for v_idx = 1:length(v_standard)
                        if v_idx == 1
                            itrvl = [v_standard(1),v_standard(2)];
                        elseif v_idx == length(v_standard)
                            itrvl = [v_standard(end-1),v_standard(end)];
                        else
                            itrvl = [v_standard(v_idx-1),v_standard(v_idx+1)];
                        end
                        v_0 = v_- v_standard(v_idx);
                        idxs = find(v_0>=-1/2 & v_0<1/2);
                        
                        i_traces(l,v_idx) = mean(i_(v_0>=-1/2 & v_0<1/2));
                    end
                end
                                
                set(ls,'color',lghtclrs(g,:))
                if sum(isnan(i_traces(:)))
                    keyboard
                end
                y = nanmean(i_traces,1);
                
                ave = line(v_standard,y,'color',clrs(g,:),'tag',[genotype '_ave'],'parent',pnl_hs(r,c));
                x = get(ave,'xdata');                
                
                SEM = nanstd(i_traces,1)/sqrt(size(i_traces,1));
                % ts = tinv([0.025  0.975],size(i_traces,1)-1);
                ts = [-1 1];
                CI_patch_up = y + ts(1)*SEM; 
                CI_patch_down = y + ts(2)*SEM; 
                
                p = patch(...
                    [x(:);flipud(x(:))],...
                    [CI_patch_up(:);flipud(CI_patch_down(:))],...
                    lghtrclrs(g,:),'edgecolor',lghtrclrs(g,:),'edgealpha',0,'parent',pnl_hs(r,c));
                uistack(p,'bottom');
                
                drawnow
            end
        end
    end
end

t_ls = findobj(pnl_hs(1,end),'type','line','-regexp','tag','_theoretical');
set(t_ls,'color',[1 1 1])
uistack(t_ls,'bottom');

pnl(1).ylabel('pA')
pnl(1).xlabel('mV')

figure(fig)
eval(['export_fig ' 'Ramp_Collection.pdf' ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,'Ramp_Collection','fig');
