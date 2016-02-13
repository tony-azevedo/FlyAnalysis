%% Record_Figure2 - take from the different types and agreggate here
close all

Scripts = {
    'Record_FS_HighFreqDepolB1s'
    'Record_FS_BandPassHiB1s'
    'Record_FS_BandPassLowB1s'
    'Record_FS_LowPassB1s'
    };

% Script_FrequencySelectivity

% Plotting transfer from all cells at all displacements
fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 .4 2*getpref('FigureSizes','NeuronOneColumn')/3, 11])

pnl = panel(fig);
pnl.margin = [16 16 4 4];
pnl.pack('h',1)  
pnl_hs = nan(4,1);
for panl = 1
    pnl(panl).pack('v',4);
    for cell_type = 1:length(Scripts)
        pnl_hs(cell_type,panl) = pnl(panl,cell_type).select();
    end
end
pnl.de.marginbottom = 12;
pnl.de.margintop = 2;

%% Figure 2AB: normalized response frequency curves for each type

clear g_coll
g_coll = {};
% g_coll = cell(1,length(Scripts));
for cell_type = 1:length(Scripts)

    eval(Scripts{cell_type});
    Script_Figure2NormSelectivity;
    
    copyobj(get(frompnl(1).select(),'children'),pnl(1,cell_type).select())
    close(f);
    delete(findobj(pnl(1,cell_type).select(),'marker','o'))
    clear g_s 
    g_s = cell(1,length(analysis_cell));
    for c = 1:length(analysis_cell)
        g_s{c} = analysis_cell(c).genotype;
    end
    g_coll = union(g_coll,unique(g_s));
    
end

%%
clrs = distinguishable_colors(length(g_coll));
for g_idx = 1:length(g_coll)
    set(findobj(pnl_hs(:),'tag',g_coll{g_idx}),'color',clrs(g_idx,:),'marker','none');
end

colorhash = @(x) round(x(1)*1E6)+round(x(2)*1E3)+x(3); 
clrhash = zeros(size(clrs,1),1);
for c = 1:length(clrhash)
    clrhash(c) = colorhash(clrs(c,:));
end

% for r = 1:4
%     l = findobj(pnl(1,r).select(),'type','line');
%     clrs_ = cell2mat(get(l,'color'));
%     clrhash_ = zeros(size(clrs_,1),1);
%     for c = 1:length(clrhash_)
%         clrhash_(c) = colorhash(clrs_(c,:));
%     end
%     
%     [~,idx] = unique(clrhash_); 
%     [~,ia] = intersect(clrhash_,clrhash);
%     idx = intersect(idx,ia);
%     clrhash = setdiff(clrhash,clrhash_);
%     
%     l_ = l(idx);
%     if length(l_)>0
%         legend(pnl(1,r).select(),l_,get(l_,'tag'));
%         legend(pnl(1,r).select(),'boxoff')
%     end
% end

for r = 1:4
    l = findobj(pnl(1,r).select(),'type','line');
    clrs_ = cell2mat(get(l,'color'));
    clrhash_ = zeros(size(clrs_,1),1);
    for c = 1:length(clrhash_)
        clrhash_(c) = colorhash(clrs_(c,:));
    end
    
    [~,idx] = unique(clrhash_); 
    [~,ia] = intersect(clrhash_,clrhash);
%     idx = intersect(idx,ia);
%     clrhash = setdiff(clrhash,clrhash_);
    
    l_ = l(idx);
    if length(l_)>0
        legend(pnl(1,r).select(),l_,get(l_,'tag'));
        legend(pnl(1,r).select(),'boxoff')
    end
end

% %% Figure 2C: amplitude dependence of the responses
% 
% for cell_type = 1:length(Scripts)
% 
%     eval(Scripts{cell_type});
%     Script_Figure2AmplitudeDependence;
%     
%     copyobj(get(frompnl(1).select(),'children'),pnl(3,cell_type).select())
%     close(f)
%         
% end

%% Clean up
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure2/';

pnl(1).ylabel('|F(f)| (mV)')
pnl(1).xlabel('f (Hz)')

set(pnl_hs(:),'tickdir','out');
set(pnl_hs(:),'xscale','log')
set(pnl_hs(:),'xlim',[15 600])

savePDF(fig,savedir,[],'Figure2S_bygenotype')
