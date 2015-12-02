%% PiezoSine Comparisons
f = figure;
set(f,'color',[1 1 1],'position',[14 220 1896 560])
pnl = panel(f);

pnl.pack('h',length(analysis_cell))  % response panel, stimulus panel
pnl.margin = [16 16 2 10];
pnl.fontname = 'Arial';
%panl(1).marginbottom = 2;

ylims = [Inf -Inf];

fampnl = nan(2,length(analysis_cell));

for cnt = 1:length(analysis_cell)
    pnl(cnt).pack('v',{1/2 1/2});
    pnl1 = pnl(cnt,1).select();
    pnl2 = pnl(cnt,2).select();

    trial = load(analysis_cell(cnt).PiezoSineTrial_IClamp);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoSineOsciRespVsFreq([],h,analysis_cell(cnt).name);
    pnl_ = panel.recover(fig);
    pnl_.title([auxid ': ' get(fig,'name')])
    
    %savePDFandFIG(fig,savedir,'PiezoSineOsciRespVsFreq',[auxid '_' get(fig,'name')])
    
    copyobj(get(pnl_(1).select(),'children'),pnl1);

    close(fig)

    l = findobj(pnl1,'color',[0 1 0]);
    freqs = get(l,'xdata');
    mgntd = get(l,'ydata');
    
    BF = freqs(mgntd==max(mgntd));
    BF_disp = str2num(regexprep(get(l,'DisplayName'),'V',''));
    BF_trialnum = [];
    for tidx = 1:length(h.prtclData)
        if h.prtclData(tidx).freq == BF && h.prtclData(tidx).displacement == BF_disp;
            BF_trialnum = h.prtclData(tidx).trial;
            break
        end
    end
            
    analysis_cell(cnt).BF_trial = fullfile(h.dir,sprintf(h.trialStem,BF_trialnum(1))); %#ok<SAGROW>
    
    if isfield(analysis_cell(cnt),'PiezoSineTrial_IClamp_Drug') && ~isempty(analysis_cell(cnt).PiezoSineTrial_IClamp_Drug);
        trial = load(analysis_cell(cnt).PiezoSineTrial_IClamp_Drug);
        h = getShowFuncInputsFromTrial(trial);
        fig = PF_PiezoSineOsciRespVsFreq([],h,analysis_cell(cnt).name);

        pnl_ = panel.recover(fig);
        pnl_.title([auxid ': ' get(fig,'name')])

        %savePDFandFIG(fig,savedir,'PiezoSineOsciRespVsFreq',[auxid '_Drugs_' get(fig,'name')])
        
        copyobj(get(pnl_(1).select(),'children'),pnl2);
        pnl(cnt,2).title('Drugs');
        ylims = [...
            min([ylims(1) min(get(pnl2,'ylim'))]),...
            max([ylims(2) max(get(pnl2,'ylim'))])];

        if ~sum(trial.params.freqs==BF)
            BF = trial.params.freqs(abs(trial.params.freqs-BF)==min(abs(trial.params.freqs-BF)));
        end
        BF_trialnum = [];
        for tidx = 1:length(h.prtclData)
            if h.prtclData(tidx).freq == BF ...
                    && h.prtclData(tidx).displacement == BF_disp ...
                    %%&& sum(strcmp(h.prtclData(tidx).tags,trial.tags{1}))
                if (isfield(trial.params,'combinedTrialBlock') ...
                        && h.prtclData(tidx).combinedTrialBlock==trial.params.combinedTrialBlock)...
                        || h.prtclData(tidx).trialBlock==trial.params.trialBlock
                    
                    BF_trialnum = h.prtclData(tidx).trial;
                    break
                end
            end
        end
        analysis_cell(cnt).BF_Drug_trial = fullfile(h.dir,sprintf(h.trialStem,BF_trialnum(1))); %#ok<SAGROW>
        close(fig)
    end
    
    set([pnl1 pnl2],'xscale','log','xlim',[16 600])
    pnl(cnt,1).title(analysis_cell(cnt).name);
    
    fampnl(1,cnt) = pnl1;
    fampnl(2,cnt) = pnl2;
    ylims = [...
        min([ylims(1) min(get(pnl1,'ylim'))]),...
        max([ylims(2) max(get(pnl1,'ylim'))])];

end

set(fampnl(:),'ylim',ylims);
pnl(1,2).xlabel('Frequency (Hz)');
pnl(1,1).ylabel('Magnitude (mV)');
pnl(1,2).ylabel('phase (deg)');

savePDFandFIG(f,savedir,'PiezoSineOsciRespVsFreq',['PiezoSineOsciRespVsFreq_' auxid])

%%
f = figure;
set(f,'color',[1 1 1],'position',[14 220 1896 560])
pnl = panel(f);

pnl.pack('h',length(analysis_cell))  % response panel, stimulus panel
pnl.margin = [16 16 2 10];
pnl.fontname = 'Arial';
%panl(1).marginbottom = 2;

ylims = [Inf -Inf];

fampnl = nan(3,length(analysis_cell));

for cnt = 1:length(analysis_cell)
    pnl(cnt).pack('v',{4/9 4/9 1/9});
    pnl1 = pnl(cnt,1).select();     fampnl(1,cnt) = pnl1;
    pnl2 = pnl(cnt,2).select();    fampnl(2,cnt) = pnl2;
    pnl3 = pnl(cnt,3).select();    fampnl(3,cnt) = pnl3;

    trial = load(analysis_cell(cnt).BF_trial);
    h = getShowFuncInputsFromTrial(trial);

    fig = PiezoSineAverage([],h,analysis_cell(cnt).name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl1);
    copyobj(get(findobj(fig,'type','axes','tag','stimulus_ax'),'children'),pnl3);
    txt = findobj(pnl1,'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    
    ylims = [...
        min([ylims(1) min(get(pnl1,'ylim'))]),...
        max([ylims(2) max(get(pnl1,'ylim'))])];

    close(fig)
    if isfield(analysis_cell(cnt),'BF_Drug_trial') && ~isempty(analysis_cell(cnt).BF_Drug_trial);
        pnl(cnt,2).title('Drugs');
        trial = load(analysis_cell(cnt).BF_Drug_trial);
        h = getShowFuncInputsFromTrial(trial);

        fig = PiezoSineAverage([],h,analysis_cell(cnt).name);
        
        copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl2);
        copyobj(get(findobj(fig,'type','axes','tag','stimulus_ax'),'children'),pnl3);
        txt = findobj(pnl2,'type','text');
        pstn = get(txt,'position');pstn(1) = 0;
        set(txt,'position',pstn);

        ylims = [...
            min([ylims(1) min(get(pnl2,'ylim'))]),...
            max([ylims(2) max(get(pnl2,'ylim'))])];
        close(fig)
    end
            
    pnl(cnt,1).title(analysis_cell(cnt).name);
    
end
set(fampnl(1:2,:),'ylim',ylims);
set(fampnl(3,:),'ylim',[4.2 5.8]);
set(fampnl(:),'xlim',[-.03 .1]);
pnl(1,3).xlabel('s');
pnl(1,3).ylabel('V');
pnl(1,1).ylabel('mV');
pnl(1,2).ylabel('mV');

savePDFandFIG(f,savedir,'PiezoSineOsciRespVsFreq',['PiezoSineResp_' auxid])
