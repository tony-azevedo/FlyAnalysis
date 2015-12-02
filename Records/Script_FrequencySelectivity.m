

if sum(strcmp(analysis_cells,'151030_F1_C1'))
    funchandle = @PiezoSineDepolRespVsFreq;
else
    funchandle = @PiezoSineOsciRespVsFreq;
end

%% Exporting PiezoSineMatrix info on cells 
if save_log
    for c_ind = 14;%1:length(analysis_cell)
        if ~isempty(analysis_cell(c_ind).PiezoSineTrial)
            close all
            trial = load(analysis_cell(c_ind).PiezoSineTrial);
            h = getShowFuncInputsFromTrial(trial);

            f = PF_PiezoSineMatrix([],h,'');
            
            % genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            % if ~isdir(genotypedir), mkdir(genotypedir); end
            if isfield(h.trial.params,'trialBlock'); b = num2str(h.trial.params.trialBlock); else b = 'NaN';end
            fn = [analysis_cell(c_ind).name ...
                b '_',...
                'PiezoSineMatrix'];
            savePDFandFIG(f,savedir,'Matrices',fn)
        end
    end
end


%% Exporting PiezoSineOsciRespVsFreq info on cells with X-functions
close all
if save_log
    close all
    clear transfer freqs dsplcmnts f
    cnt = 0;
    for c_ind = 1:length(analysis_cell)
        if ~isempty(analysis_cell(c_ind).PiezoSineTrial)
            trial = load(analysis_cell(c_ind).PiezoSineTrial);
            h = getShowFuncInputsFromTrial(trial);
            
            cnt = cnt+1;
            
            if exist('f','var') && ishandle(f), close(f),end
            
            hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
            genotype{cnt} = analysis_cell(c_ind).genotype;
            
            [transfer{cnt},freqs{cnt},dsplcmnts{cnt}] = feval(funchandle,[],h,analysis_cell(c_ind).genotype);
            
            f = findobj(0,'tag',func2str(funchandle));

            if isfield(h.trial.params,'trialBlock'), tb = num2str(h.trial.params.trialBlock);
            else tb = 'NaN';
            end
            
            fn = [id,analysis_cell(c_ind).name '_'...
                tb '_',...
                func2str(funchandle)];
            savePDFandFIG(f,savedir,[],fn)
        end
    end
    
    for c_ind = 1:length(hasPiezoSineName)
        hasPiezoSineName{c_ind} = hasPiezoSineName{c_ind};
    end
    
    s.name = hasPiezoSineName;
    s.transfer = transfer;
    s.freqs = freqs;
    s.dsplcmnts = dsplcmnts;
    s.genotype = genotype;
    
    save(fullfile(savedir,'transfer_functions_data'),'-struct','s')
end


%% Show all amplitudes 
close all
s = load(fullfile(savedir,'transfer_functions_data'));
hasPiezoSineName = s.name;
transfer = s.transfer;
freqs = s.freqs;
dsplcmnts = s.dsplcmnts;
genotype = s.genotype;

% Count the number of displacements, etc
all_dsplcmnts = [];
for d_ind = 1:length(dsplcmnts) 
    all_dsplcmnts = [all_dsplcmnts,round(dsplcmnts{d_ind}*1000)/1000];
end
all_dsplcmnts = sort(unique(all_dsplcmnts));
% all_dsplcmnts = [0.05 0.15 .5 1.5];

all_freqs = [];
for d_ind = 1:length(freqs) 
    all_freqs = [all_freqs,round(freqs{d_ind}*1000)/1000];
end
all_freqs = sort(unique(all_freqs));

% Plotting transfer from all cells at all displacements
f = figure;
set(f,'position',[7         226        1903         752],'color',[1 1 1])
pnl = panel(f);
pnl.pack('v',{2/6  2/6 2/6})  % response panel, stimulus panel
pnl.margin = [20 20 10 10];
pnl(1).marginbottom = 2;
pnl(2).marginbottom = 2;

pnl(1).pack('h',length(all_dsplcmnts));
pnl(2).pack('h',length(all_dsplcmnts));

ylims = [0 -Inf];

for d_ind = 1:length(all_dsplcmnts)
    dspltranf = nan(length(transfer),length(all_freqs));
    ax1 = pnl(1,d_ind).select(); hold(ax1,'on')
    ax2 = pnl(2,d_ind).select(); hold(ax2,'on')
    pnl(1,d_ind).title([num2str(all_dsplcmnts(d_ind)) ' V'])
    for c_ind = 1:length(transfer)
        dspl_o = dsplcmnts{c_ind};
        dspl = round(dspl_o*1000)/1000;

        d_i = find(dspl == all_dsplcmnts(d_ind));

        if isempty(d_i)
            continue
        end
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*1000)/1000);
        dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(:,d_i)))';
        
        plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i))),...
            'parent',ax1,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
            'displayname',hasPiezoSineName{c_ind},'tag',genotype{c_ind},'userdata',dspl_o(d_i))
        plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i)))/max(real(abs(transfer{c_ind}(:,d_i)))),...
            'parent',ax2,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
            'displayname',hasPiezoSineName{c_ind},'tag',genotype{c_ind},'userdata',dspl_o(d_i))
        
    end
    %plot(all_freqs(~isnan(dspltranf(3,:))),nanmean(dspltranf(:,~isnan(dspltranf(3,:))),1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    plot(ax1,all_freqs,nanmean(dspltranf,1),...
        'marker','o','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'color',[0 1/length(all_dsplcmnts) 0]*d_ind);

    set(ax1,'xscale','log');
    set(ax2,'xscale','log');
    
    ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
end

% phases (all the same?)
pnl(3).pack('h',length(all_dsplcmnts));
plims = [0 -Inf];
for d_ind = 1:length(all_dsplcmnts)
    dsplphase = nan(length(transfer),length(all_freqs));
    ax = pnl(3,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(transfer)
        dspl_o = dsplcmnts{c_ind};
        dspl = round(dspl_o*1000)/1000;

        d_i = find(dspl == all_dsplcmnts(d_ind));

        if isempty(d_i)
            continue
        end
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*1000)/1000);
        dsplphase(c_ind,af_i) = angle(transfer{c_ind}(:,d_i))';
        dsplphase(c_ind,:) = unwrap(dsplphase(c_ind,:));
        %dsplphase = dsplphase/(2*pi)*360;
        plot(all_freqs,dsplphase(c_ind,:),...
            'parent',ax,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
            'tag',hasPiezoSineName{c_ind})
    end
    
    plot(all_freqs,nanmean(dsplphase,1),...
        'parent',ax,'linestyle','none','color',[.85 .85 .85],...
        'marker','o','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind)

    set(ax,'xscale','log');
    plims = [min(plims(1),min(dsplphase(:))) max(plims(2),max(dsplphase(:)))];
end
rotUp = ceil(plims(2)/pi);
rotDn = floor(plims(1)/pi);
tx = rotDn:rotUp; for txi = 1:length(tx);txc{txi} = [num2str(tx(txi)) '\pi']; end

pnl(1,1).ylabel('|F(f)| (mV)'),pnl(3,1).xlabel('f (Hz)')
pnl(2,1).ylabel('normalized'),pnl(3,2).xlabel('f (Hz)')
pnl(3,1).ylabel('phase'),pnl(3,3).xlabel('f (Hz)')

for d_ind = 1:length(all_dsplcmnts)
    set(pnl(1,d_ind).axis,'ylim',ylims);
    set(pnl(2,d_ind).axis,'ylim',[0 1.1]);
    set(pnl(1,d_ind).axis,'xlim',[10 1000]);
    set(pnl(2,d_ind).axis,'xlim',[10 1000]);
    set(pnl(3,d_ind).select(),'YTick',[rotDn*pi:pi:rotUp*pi])    
    set(pnl(3,d_ind).select(),'yticklabel',txc);
    
    set(pnl(1,d_ind).axis,'tag',['mag_' num2str(all_dsplcmnts(d_ind))]);
    set(pnl(2,d_ind).axis,'tag',['norm_' num2str(all_dsplcmnts(d_ind))]);
end

savePDFandFIG(f,savedir,[],[id func2str(funchandle)])


%% Group amplitudes to the nearby (0.1 -> 0.05, .2->.15 .4->.5)
close all
s = load(fullfile(savedir,'transfer_functions_data'));
hasPiezoSineName = s.name;
transfer = s.transfer;
freqs = s.freqs;
dsplcmnts = s.dsplcmnts;
genotype = s.genotype;

% Count the number of displacements, etc
all_dsplcmnts = [];
for d_ind = 1:length(dsplcmnts) 
    all_dsplcmnts = [all_dsplcmnts,round(dsplcmnts{d_ind}*1000)/1000];
end
all_dsplcmnts = sort(unique(all_dsplcmnts));
all_dsplcmnts = [0.015 0.05 0.15 .5];

all_freqs = [];
for d_ind = 1:length(freqs) 
    all_freqs = [all_freqs,round(freqs{d_ind}*1000)/1000];
end
all_freqs = sort(unique(all_freqs));

% Plotting transfer from all cells at all displacements
f = figure;
set(f,'position',[7         226        1903         752],'color',[1 1 1])
pnl = panel(f);
pnl.pack('v',{2/6  2/6 2/6})  % response panel, stimulus panel
pnl.margin = [20 20 10 10];
pnl(1).marginbottom = 2;
pnl(2).marginbottom = 2;

pnl(1).pack('h',length(all_dsplcmnts));
pnl(2).pack('h',length(all_dsplcmnts));

ylims = [0 -Inf];

for d_ind = 1:length(all_dsplcmnts)
    dspltranf = nan(length(transfer),length(all_freqs));
    ax1 = pnl(1,d_ind).select(); hold(ax1,'on')
    ax2 = pnl(2,d_ind).select(); hold(ax2,'on')
    pnl(1,d_ind).title([num2str(all_dsplcmnts(d_ind)) ' V'])
    for c_ind = 1:length(transfer)
        dspl_o = dsplcmnts{c_ind};
        dspl = round(dspl_o*1000)/1000 - 1E-3;
        [dist,d_i] = min(abs(dspl - all_dsplcmnts(d_ind)));
        if isempty(d_i)
            continue
        end
        if dist> (dspl(d_i)-1E-3)/2
            continue
        end
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*1000)/1000);
        dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(:,d_i)))';
        
        plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i))),...
            'parent',ax1,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
            'displayname',hasPiezoSineName{c_ind},'tag',genotype{c_ind},'userdata',dspl_o(d_i))
        plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i)))/max(real(abs(transfer{c_ind}(:,d_i)))),...
            'parent',ax2,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
            'displayname',hasPiezoSineName{c_ind},'tag',genotype{c_ind},'userdata',dspl_o(d_i))
        
    end
    %plot(all_freqs(~isnan(dspltranf(3,:))),nanmean(dspltranf(:,~isnan(dspltranf(3,:))),1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    plot(ax1,all_freqs,nanmean(dspltranf,1),...
        'marker','o','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'color',[0 1/length(all_dsplcmnts) 0]*d_ind);

    set(ax1,'xscale','log');
    set(ax2,'xscale','log');
    
    ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
end

% phases (all the same?)
pnl(3).pack('h',length(all_dsplcmnts));
plims = [0 -Inf];
for d_ind = 1:length(all_dsplcmnts)
    dsplphase = nan(length(transfer),length(all_freqs));
    ax = pnl(3,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(transfer)
        dspl_o = dsplcmnts{c_ind};
        dspl = round(dspl_o*1000)/1000 - 1E-3;
        [dist,d_i] = min(abs(dspl - all_dsplcmnts(d_ind)));
        if isempty(d_i)
            continue
        end
        if dist> (dspl(d_i)-1E-3)/2
            continue
        end
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*1000)/1000);
        dsplphase(c_ind,af_i) = angle(transfer{c_ind}(:,d_i))';
        dsplphase(c_ind,:) = unwrap(dsplphase(c_ind,:));
        %dsplphase = dsplphase/(2*pi)*360;
        plot(all_freqs,dsplphase(c_ind,:),...
            'parent',ax,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
            'tag',hasPiezoSineName{c_ind})
    end
    
    plot(all_freqs,nanmean(dsplphase,1),...
        'parent',ax,'linestyle','none','color',[.85 .85 .85],...
        'marker','o','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind)

    set(ax,'xscale','log');
    plims = [min(plims(1),min(dsplphase(:))) max(plims(2),max(dsplphase(:)))];
end
rotUp = ceil(plims(2)/pi);
rotDn = floor(plims(1)/pi);
tx = rotDn:rotUp; for txi = 1:length(tx);txc{txi} = [num2str(tx(txi)) '\pi']; end

pnl(1,1).ylabel('|F(f)| (mV)'),pnl(3,1).xlabel('f (Hz)')
pnl(2,1).ylabel('normalized'),pnl(3,2).xlabel('f (Hz)')
pnl(3,1).ylabel('phase'),pnl(3,3).xlabel('f (Hz)')

for d_ind = 1:length(all_dsplcmnts)
    set(pnl(1,d_ind).axis,'ylim',ylims);
    set(pnl(2,d_ind).axis,'ylim',[0 1.1]);
    set(pnl(1,d_ind).axis,'xlim',[10 1000]);
    set(pnl(2,d_ind).axis,'xlim',[10 1000]);
    set(pnl(3,d_ind).select(),'YTick',[rotDn*pi:pi:rotUp*pi])    
    set(pnl(3,d_ind).select(),'yticklabel',txc);
    
    set(pnl(1,d_ind).axis,'tag',['mag_' num2str(all_dsplcmnts(d_ind))]);
    set(pnl(2,d_ind).axis,'tag',['norm_' num2str(all_dsplcmnts(d_ind))]);
end

savePDFandFIG(f,savedir,[],[id func2str(funchandle) '_Aggregate'])


