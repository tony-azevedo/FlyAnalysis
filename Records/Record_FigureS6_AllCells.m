%% Figure 5 All cells stuff

%% All sensitivity curves for B1 neurons
close all
types = {
%     'a2_cell'
    'fru_cell'
    'vt_cell'
    'offtarget_cell'
%    'r45D07_cell'
    };

figure5 = figure;
Record_VoltageClampInputCurrents

figure5.Units = 'inches';
set(figure5,'color',[1 1 1],'position',[1 .2 getpref('FigureSizes','NeuronOneAndHalfColumn'),7])
pnl = panel(figure5);

figurerows = [3 4];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);
pnl.margin = [16 16 4 4];

r = 1;
pnl(r).pack('h',3) 
pnl(r).marginbottom = 8;  
pnl(r+1).pack('h',3) 
pnl(r+1).marginbottom = 8;  

for t_ind = 1:length(types)
    clear transfer freqs dsplcmnts f
    eval(['analysis_cell = ' types{t_ind} ';']);
    eval(['analysis_cells = ' types{t_ind} 's;']);
    
    trial = load(analysis_cell(1).PiezoSineTrial);
    h = getShowFuncInputsFromTrial(trial);
    
    fn = fullfile('C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\TransferFunctions',[types{t_ind}(1:regexp(types{t_ind},'_')) 'Xfunctions.mat']);
    if exist(fn,'file')==2
        s = load(fn);
    else
%         if t_ind==1
%         funchandle = @PF_PiezoSineDepolRespVsFreq_Current;
%         else
        funchandle = @PF_PiezoSineOsciRespVsFreq;
%         end
        for c_ind = 1:length(analysis_cell)
            trial = load(analysis_cell(c_ind).PiezoSineTrial);
            h = getShowFuncInputsFromTrial(trial);
            fprintf(1,'PF_PiezoSineOsciRVF: %s\n',analysis_cell(c_ind).name);
            
            [f,transfer{c_ind},freqs{c_ind},dsplcmnts{c_ind}] = feval(funchandle,[],h,analysis_cell(c_ind).genotype);
            savePDF(f,'C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\TransferFunctions',[],[types{t_ind}(1:regexp(types{t_ind},'_')) 'Xfunctions_' analysis_cell(c_ind).name]);
        end
        s.name = analysis_cells;
        s.transfer = transfer;
        s.freqs = freqs;
        s.dsplcmnts = dsplcmnts;
        save(fn,'-struct','s')
    end
    
    name = s.name;
    transfer = s.transfer;
    freqs = s.freqs;
    dsplcmnts = s.dsplcmnts;
    
    indv_ax = pnl(r,t_ind).select();
    hold(indv_ax,'on');
    dspl_ax = pnl(r+1,t_ind).select();
    hold(dspl_ax,'on');
    
    ylims = [Inf -Inf];
    
    displacements = dsplcmnts{1};
    
    show_freq = h.trial.params.freqs(7);
    show_dsplc = h.trial.params.displacements(3);
    
    cell_max_foralldisp = nan(length(transfer),1);
    for d_ind = 1:length(displacements)
        for c_ind = 1:length(transfer)
            dspl_o = dsplcmnts{c_ind};
            dspl = round(dspl_o*1000)/1000;
            
            d_i = find(dspl == displacements(d_ind));
            
            if isempty(d_i)
                continue
            end
            
            cell_max_foralldisp(c_ind) = max([cell_max_foralldisp(c_ind) max(real(abs(transfer{c_ind}(:,d_i))))]); %real(abs(transfer{c_ind}(af_f,d_i)))';
        end
    end

    for d_ind = 1:length(displacements)
        dspltranf = nan(length(transfer),length(h.trial.params.freqs));
        for c_ind = 1:length(transfer)
            dspl = dsplcmnts{c_ind};
            
            d_i = find(dspl == displacements(d_ind));
            dspltranf(c_ind,:) = real(abs(transfer{c_ind}(:,d_i)))';
            if displacements(d_ind)==show_dsplc
                l = plot(freqs{c_ind},dspltranf(c_ind,:),...
                    'parent',indv_ax,'linestyle','-','color',0*[.85 .85 .85],...
                    'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
                    'displayname',name{c_ind},'tag',types{t_ind},'userdata',dspl(d_i));
                if strcmp(analysis_cell(c_ind).genotype,'UAS-Dcr;20XUAS-mCD8:GFP/+;R45D07-Gal4/UAS-paraRNAi')
                    set(l,'color',[1 0 0])
                end
            end
            
        end
        if displacements(d_ind)==show_dsplc
            text(400,10,['N=' num2str(length(indv_ax.Children))],'parent',indv_ax,'verticalalignment','bottom');
        end
        for c_ind = 1:length(transfer)
            dspltranf(c_ind,:) = dspltranf(c_ind,:)/cell_max_foralldisp(c_ind);
        end

        SEM = nanstd(dspltranf,[],1)/sqrt(sum(~isnan(dspltranf(:,1))));
        %ts = tinv([0.025  0.975],sum(~isnan(dspltranf(:,1)))-1);
        ts = [-1 1];
        CI_up = ts(1)*SEM;
        CI_down = ts(2)*SEM;
        errorbar(dspl_ax,freqs{c_ind},nanmean(dspltranf,1),CI_down,CI_up,'linestyle','-','marker','none','color',[0 1/4 0]*d_ind);
        
        ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
    end
    set(indv_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    set(dspl_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    set(indv_ax,'ylim',[0 44]);
end


savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(figure5,savedir,[],'Figure5_AllCells')



