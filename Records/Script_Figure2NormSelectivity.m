%% Plot only relevant displacements 0.015 0.05 0.15 0.5 V
if sum(strcmp(analysis_cells,'151030_F1_C1'))
    funchandle = @PF_PiezoSineDepolRespVsFreq;
else
    funchandle = @PF_PiezoSineOsciRespVsFreq;
end
s = load(fullfile(savedir,'transfer_functions_data'));
hasPiezoSineName = s.name;
transfer = s.transfer;
freqs = s.freqs;
dsplcmnts = s.dsplcmnts;
genotype = s.genotype;

if length(hasPiezoSineName)~=length(analysis_cells) || length(hasPiezoSineName)~=length(transfer)
    warning('Transfer_functions_data for %s is out of date',id)
%     Script_TransferFunctionsFigure2
end

% Count the number of displacements, etc
all_dsplcmnts = [];
for d_ind = 1:length(dsplcmnts) 
    all_dsplcmnts = [all_dsplcmnts,round(dsplcmnts{d_ind}*1000)/1000];
end
all_dsplcmnts = sort(unique(all_dsplcmnts));
all_dsplcmnts = [0.15];

all_freqs = [];
for d_ind = 1:length(freqs) 
    all_freqs = [all_freqs,round(freqs{d_ind}*1000)/1000];
end
all_freqs = sort(unique(all_freqs));
all_freqs = round(25 * sqrt(2) .^ (-1:1:9) * 1000)/1000; 

% Plotting transfer from all cells at all displacements
f = figure;
set(f,'position',[7         226        1903         752],'color',[1 1 1])
frompnl = panel(f);
frompnl.pack('h',{1/2  1/2})  % response panel, stimulus panel
frompnl.margin = [20 20 10 10];
frompnl(1).marginbottom = 2;
frompnl(2).marginbottom = 2;

ylims = [0 -Inf];

all_dsplcmnts = [0.015 0.05 0.15 .5];

cell_max_foralldisp = nan(length(transfer),1);
for d_ind = 1:length(all_dsplcmnts)
    for c_ind = 1:length(transfer)
        dspl_o = dsplcmnts{c_ind};
        dspl = round(dspl_o*1000)/1000;

        d_i = find(dspl == all_dsplcmnts(d_ind));

        if isempty(d_i)
            continue
        end

        [~,af_i,af_f] = intersect(all_freqs,round(freqs{c_ind}*1000)/1000);
        cell_max_foralldisp(c_ind) = max([cell_max_foralldisp(c_ind) max(real(abs(transfer{c_ind}(af_f,d_i))))]); %real(abs(transfer{c_ind}(af_f,d_i)))';
                
    end
end

all_dsplcmnts = [0.15];
for d_ind = 1:length(all_dsplcmnts)
    dspltranf = nan(length(transfer),length(all_freqs));
    ax1 = frompnl(1).select(); hold(ax1,'on')
    ax2 = frompnl(2).select(); hold(ax2,'on')
    frompnl(1).title([num2str(all_dsplcmnts(d_ind)) ' V'])
    for c_ind = 1:length(transfer)
        cnt = find(strcmp(analysis_cells,hasPiezoSineName{c_ind}));
        
        dspl_o = dsplcmnts{c_ind};
        dspl = round(dspl_o*1000)/1000;

        d_i = find(dspl == all_dsplcmnts(d_ind));

        if isempty(d_i)
            continue
        end

        [~,af_i,af_f] = intersect(all_freqs,round(freqs{c_ind}*1000)/1000);
        dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(af_f,d_i)))'/cell_max_foralldisp(c_ind);
        
        plot(freqs{c_ind}(af_f),real(abs(transfer{c_ind}(af_f,d_i))),...
            'parent',ax1,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
            'displayname',hasPiezoSineName{c_ind},'tag',analysis_cell(cnt).genotype,'userdata',dspl_o(d_i))
        plot(freqs{c_ind}(af_f),real(abs(transfer{c_ind}(af_f,d_i)))/cell_max_foralldisp(c_ind),...max(real(abs(transfer{c_ind}(af_f,d_i)))),...
            'parent',ax2,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
            'displayname',hasPiezoSineName{c_ind},'tag',analysis_cell(cnt).genotype,'userdata',dspl_o(d_i))
        
    end
    plot(all_freqs(~isnan(dspltranf(3,:))),nanmean(dspltranf(:,~isnan(dspltranf(3,:))),1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    text(400,2,['N=' num2str(length(ax1.Children))],'parent',ax1,'verticalalignment','bottom');
        
    plot(ax2,all_freqs,nanmean(dspltranf,1),...
        'marker','o','markerfacecolor',[0 1/4 0]*3,'markeredgecolor',[0 1/4 0]*3,...
        'color',[0 1/4 0]*3);

    set(ax1,'xscale','log');
    set(ax2,'xscale','log');
    
    ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
end
