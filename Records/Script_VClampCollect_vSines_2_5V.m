cd 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation\include\vSines\'
vs_figs = dir('*_VoltageSine_*.fig');
lg = false(size(vs_figs));
for r_idx = 1:length(vs_figs)
    if ~isempty(strfind(vs_figs(r_idx).name,'_2_5'))
        lg(r_idx) = true;
    end
end
vs_figs = vs_figs(lg);

fig = figure;
set(fig,'color',[1 1 1],'position',[17 31 1872 963],'name','VoltageSine_2_5V_Collection');

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
for c_idx = 1:length(freqs), pnl_hs(r_idx+1,c_idx) = pnl(r_idx+1,c_idx).select();    end

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
                    case {'curare','MLA','Cd'}
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
    

figure(fig)
eval(['export_fig ' 'VoltageSine_2_5V_Collection.pdf' ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,'VoltageSine_2_5V_Collection','fig');

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
set(findobj(fig,'color',clr,'type','line'),'color',base_clr);

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
cellname = '151001_F2_C1';
clr = [0 0 1];

set(findobj(fig,'color',clr,'type','line'),'color',base_clr);
ls = findobj(fig,'type','line','displayname',cellname);
set(ls,'color',clr);

for i = 1:length(pnl_hs(:))
    uistack(findobj(pnl_hs(i),'type','line','color',clr),'top');
end

%% Highlight reject cells
% '150913_F2_C1'	High access                     150913_F2_C1_access
% '151001_F1_C1'	access drift for ZD ONLY        151001_F1_C1_access
% '151001_F2_C1'	curare ONLY, changed Vh			151001_F2_C1_VoltageSine_Currents_7_5V
% '151002_F2_C1'	High access, but stable			151002_F2_C1_access
% '151007_F1_C1'	High access	for curare ONLY     151007_F1_C1_access
% '151007_F4_C1' 	high access variance';          150903_F1_C1_InputR.pdf 151007_F4_C1_access

rejects = {'150718_F1_C1','150720_F1_C2','150721_F2_C1','150913_F2_C1', '151002_F2_C1', '151007_F4_C1'};
clr = [0 0 1];

set(findobj(fig,'color',clr,'type','line'),'color',base_clr);
for r = 1:length(rejects)
    ls = findobj(fig,'type','line','displayname',rejects{r});
    set(ls,'color',clr);
end

for i = 1:length(pnl_hs(:))
    uistack(findobj(pnl_hs(i),'type','line','color',clr),'top');
end

spec_clr = [1 0 0];
set(findobj(fig,'color',spec_clr,'type','line'),'color',base_clr);
rejects = {
    '151001_F1_C1', 'ZD'; 
    '151001_F2_C1', 'AChI'; 
    '151007_F1_C1', 'AChI'};

for r = 1:size(rejects,1)
    to_axes = findobj(fig,'type','axes','-regexp','tag',rejects{r,2});
    ls = findobj(to_axes,'type','line','displayname',rejects{r,1});
    set(ls,'color',spec_clr);
end

%% Undo
set(findobj(fig,'color',clr,'type','line'),'color',base_clr);

%% put away
for i = 1:length(pnl_hs(:))
    uistack(findobj(pnl_hs(i),'color',clr,'type','line'),'bottom');
    set(findobj(pnl_hs(i),'color',clr,'type','line'),'color',[1 1 1]);
end

%% Highlight Fru vs VT cells

genotype = '10XUAS-mCD8:GFP/+;FruGal4/+';
% genotype = '20XUAS-mCD8:GFP;VT27938-Gal4';

clr = [0 0 1];

set(findobj(fig,'color',clr,'type','line'),'color',base_clr);
ls = findobj(fig,'color',base_clr,'type','line','tag',genotype);
set(ls,'color',clr);

for i = 1:length(pnl_hs(:))
    uistack(findobj(pnl_hs(i),'type','line','color',clr),'top');
end










