%% Plot only relevant displacements 0.015 0.05 0.15 0.5 V
close all
% Plotting transfer from all cells at all displacements
fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 2 getpref('FigureSizes','NeuronOneColumn'), getpref('FigureSizes','NeuronOneColumn')])

pnl = panel(fig);
pnl.margin = [16 16 4 4];
pnl.pack('h',3)  
pnl_hs = nan(2,3);
for panl = 1:3
    pnl(panl).pack('v',{1/10 3/10 3/10 3/10});
    for cell_type = 1:4
        pnl_hs(cell_type,panl) = pnl(panl,cell_type).select();
    end
end
pnl.de.marginbottom = 12;
pnl.de.margintop = 2;

%% Example traces from Figure 1 
Record_FS_HighFreqDepolB1s
trial = load(example_cell.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end
for t = 1:length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials(t) = trials(end);
end

freqs = h.trial.params.freqs(4:2:8);
fnum = length(freqs);

trialnummatrix = nan(1,fnum);

for bt = blocktrials;
    params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
    
    if sum(freqs == params.params.freq);
        c = find(freqs == params.params.freq);
        trialnummatrix(1,c) = bt;
    end    
end

ylims = [Inf, -Inf];
slims = [Inf, -Inf];
for c = 1:size(trialnummatrix,2)
    trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
    h = getShowFuncInputsFromTrial(trial);
    
    stim = PiezoSineStim(h.trial.params);
    x = makeInTime(h.trial.params);
    x_win = x>= -.2 & x<trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec);
    
    pnl_hs(1,c) = pnl(c,1).select();
    line(x(x_win),stim(x_win),'parent',pnl_hs(1,c),'color',[0 0 1],'tag',[num2str(h.trial.params.freq), 'Hz']);
    
    set(pnl_hs(1,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[]);
    axis(pnl_hs(1,c),'tight')
    
    slims_from = get(pnl_hs(1,c),'ylim');
    slims = [min(slims(1),slims_from(1)),...
        max(slims(2),slims_from(2))];

    h.trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
    averagefig = extractSpikes([],h,'');
        
    ax_from = findobj(averagefig,'tag','response_ax');
    
    ylabe = get(get(ax_from,'ylabel'),'string');
    delete(get(ax_from,'xlabel'));
    delete(get(ax_from,'ylabel'));
    delete(get(ax_from,'zlabel'));
    delete(get(ax_from,'title'));
    
    ylims_from = get(ax_from,'ylim');
    xlims_from = get(ax_from,'xlim');
    ylims = [min(ylims(1),ylims_from(1)),...
        max(ylims(2),ylims_from(2))];

    copyobj(get(ax_from,'children'),pnl(c,2).select());    
    set(pnl(c,2).select(),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
    
end
pnl_hs = [pnl(1,1).select(),pnl(2,1).select(),pnl(3,1).select()];
set(pnl_hs(:),'ylim',slims)
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1Xlims'))
set(pnl(1,1).select(),'ytickmode','auto','ycolor',[0 0 0])

pnl_hs = [pnl(1,2).select(),pnl(2,2).select(),pnl(3,2).select()];
set(pnl_hs(:),'ylim',ylims)
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1Xlims'))
set(pnl(1,2).select(),'ytickmode','auto','ycolor',[0 0 0])

pnl(1,1).ylabel(['Stimulus (V)']);
%pnl(1,2).de.fontsize = 18;

pnl(1,2).ylabel(['mV']);
%pnl(1,2).de.fontsize = 18;

%% Example tuning for spikes at .15 V for Voltage of A2s

funchandle = @PF_PiezoSineSpikesVsFreq;

s = load(fullfile(savedir,'spike_transfer_functions_data'));
hasPiezoSineName = s.name;
transfer = s.transfer;
freqs = s.freqs;
dsplcmnts = s.dsplcmnts;
genotype = s.genotype;

if length(hasPiezoSineName)~=length(analysis_cells) || length(hasPiezoSineName)~=length(transfer)
    warning('Transfer_functions_data for %s is out of date',id)
    Script_TransferFunctionsFigure2A2Spikes
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

copyobj(get(frompnl(1).select(),'children'),pnl(1,3).select())
copyobj(get(frompnl(2).select(),'children'),pnl(2,3).select())
close(f)

%% Norm sensitivity for A2 spikes

all_dsplcmnts = [0.015 0.05 0.15 .5];
all_freqs = round(25 * sqrt(2) .^ (-1:1:9) * 1000)/1000; 

% Plotting transfer from all cells at all displacements
f = figure;
set(f,'position',[7         226        1903         752],'color',[1 1 1])
frompnl = panel(f);
frompnl.pack(1)  % response panel, stimulus panel
ax1 = frompnl(1).select(); hold(ax1,'on')

ylims = [0 -Inf];

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

lifetime_spareness = nan(length(transfer),length(all_dsplcmnts));
for d_ind = 1:length(all_dsplcmnts)
    dspltranf = nan(length(transfer),length(all_freqs));
    for c_ind = 1:length(transfer)
        dspl_o = dsplcmnts{c_ind};
        dspl = round(dspl_o*1000)/1000;

        d_i = find(dspl == all_dsplcmnts(d_ind));

        if isempty(d_i)
            continue
        end

        [~,af_i,af_f] = intersect(all_freqs,round(freqs{c_ind}*1000)/1000);
        dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(af_f,d_i)))'/cell_max_foralldisp(c_ind);
        r_ = dspltranf(c_ind,af_i);
        lifetime_spareness(c_ind,d_ind) = ...
            1/length(af_i) * ...
            sum(((r_-mean(r_))/std(r_)).^4) - 3;
    end
    %     plot(all_freqs(~isnan(dspltranf(3,:))),nanmean(dspltranf(:,~isnan(dspltranf(3,:))),1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
        
    plot(ax1,all_freqs,nanmean(dspltranf,1),...
        'displayname',[num2str(all_dsplcmnts(d_ind),2),' V' ],...
        'marker','o','markerfacecolor','none','markeredgecolor','none',...[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'color',[0 1/length(all_dsplcmnts) 0]*d_ind);

    dspltranf = dspltranf(~isnan(dspltranf(:,1)),:);
    SEM = nanstd(dspltranf,[],1)/sqrt(sum(~isnan(dspltranf(:,1))));
    %     ts = tinv([0.025  0.975],sum(~isnan(dspltranf(:,1)))-1);
    ts = [-1 1];
    CI_up = ts(1)*SEM;
    CI_down = ts(2)*SEM;
    
    %     p = patch(...
    %         [x(:);flipud(x(:))],...
    %         [CI_patch_up(:);flipud(CI_patch_down(:))],...
    %         lghtrclrs(g,:),'edgecolor',lghtrclrs(g,:),'edgealpha',0,'parent',frompnl_hs(r,c));
    %     uistack(p,'bottom');
    errorbar(ax1,all_freqs,nanmean(dspltranf,1),CI_down,CI_up,'linestyle','none','marker','none','color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    
end

copyobj(get(frompnl(1).select(),'children'),pnl(3,3).select())
close(f)

%% Example traces at .15 V for Voltage of A2s
Record_FS_HighFreqDepolB1s

Script_Figure2NormSelectivity;

copyobj(get(frompnl(1).select(),'children'),pnl(1,4).select())
copyobj(get(frompnl(2).select(),'children'),pnl(2,4).select())
close(f)

%% Norm Selectivity for Voltage of A2s

Record_FS_HighFreqDepolB1s
Script_Figure2AmplitudeDependence;

copyobj(get(frompnl(1).select(),'children'),pnl(3,4).select())
close(f)
    


%% clean up
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure2_Summary_of_frequency_tuning/';

pnl(1,3).ylabel('Spikes (N)'), pnl(1,4).ylabel('mV'),
pnl(1,4).xlabel('f (Hz)'), pnl(2,4).xlabel('f (Hz)'),pnl(3,4).xlabel('f (Hz)')

pnl_hs = [pnl(1,3).select(),pnl(2,3).select(),pnl(3,3).select();
    pnl(1,4).select(),pnl(2,4).select(),pnl(3,4).select()];
set(pnl_hs(:),'tickdir','out');
set(pnl_hs(:,3),'xscale','log','xlim',[15 600],'xtick',[25 50 100 200 400])

savePDF(fig,savedir,[],'Figure2_A2Spiking')

