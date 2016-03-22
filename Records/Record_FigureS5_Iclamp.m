%% Figure 5 supplemental stuff

%% All sensitivity curves for B1 neurons
close all
types = {
%     'a2_cell'
    'fru_cell'
    'vt_cell'
    %'offtarget_cell'
    };

figure5 = figure;
Record_VoltageClampInputCurrents

figure5.Units = 'inches';
set(figure5,'color',[1 1 1],'position',[1 .2 getpref('FigureSizes','NeuronOneColumn'),11])
pnl = panel(figure5);

figurerows = [3 4 3 3 3];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);
pnl.margin = [16 16 4 4];

r = 1;
% pnl(r).pack('h',3) 
pnl(r).pack('h',2) 
pnl(r).marginbottom = 8;  
% pnl(r+1).pack('h',3) 
% pnl(r+1).marginbottom = 8;  

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
        error('Xfunctions don''t exist. Get it together!!');
    end
    
    name = s.name;
    transfer = s.transfer;
    freqs = s.freqs;
    dsplcmnts = s.dsplcmnts;
    
%     indv_ax = pnl(r,t_ind).select();
%     hold(indv_ax,'on');
%     dspl_ax = pnl(r+1,t_ind).select();
%     hold(dspl_ax,'on');
    dspl_ax = pnl(r,t_ind).select();
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
%             if displacements(d_ind)==show_dsplc
%                 l = plot(freqs{c_ind},dspltranf(c_ind,:),...
%                     'parent',indv_ax,'linestyle','-','color',0*[.85 .85 .85],...
%                     'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
%                     'displayname',name{c_ind},'tag',types{t_ind},'userdata',dspl(d_i));
%                 if strcmp(analysis_cell(c_ind).genotype,'UAS-Dcr;20XUAS-mCD8:GFP/+;R45D07-Gal4/UAS-paraRNAi')
%                     set(l,'color',[1 0 0])
%                 end
%             end
            
        end
        if displacements(d_ind)==show_dsplc
%             text(400,10,['N=' num2str(length(indv_ax.Children))],'parent',indv_ax,'verticalalignment','bottom');
            
%             plot(indv_ax,freqs{c_ind},nanmean(dspltranf,1),...
%                 'marker','o','markerfacecolor',[0 1/4 0]*3,'markeredgecolor',[0 1/4 0]*3,...
%                 'color',[0 1/4 0]*3);
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
%     set(indv_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    set(dspl_ax,'xscale','log','TickDir','out','xlim',[15 600]);
%     set(indv_ax,'ylim',[0 44]);
end
% savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
% savePDF(figure5,savedir,[],'Figure5')
% 

%% Current clamp data for all fru vt, offtarget cells

% % % %% ----- First get the current clamp data -----
% % % Record_VoltageClampInputCurrents
% % % types = {
% % % %     'a2_cell'
% % %     'fru_cell'
% % %     'vt_cell'
% % %     'offtarget_cell'
% % %     };
% % % 
% % % for t_ind = 1:3
% % %     clear transfer freqs dsplcmnts f hasPiezoSineName
% % %     eval(['analysis_cell = ' types{t_ind} ';']);
% % %     eval(['analysis_cells = ' types{t_ind} 's;']);
% % % 
% % %     fn = fullfile('C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\TransferFunctions',[types{t_ind}(1:regexp(types{t_ind},'_')) 'Xfunctions__IClamp.mat']);
% % %     if exist(fn,'file')==2
% % %         s = load(fn);
% % %     else
% % %         cnt = 0;
% % %         funchandle = @PF_PiezoSineOsciRespVsFreq;
% % %         for c_ind = 1:length(analysis_cell)
% % %             if ~isempty(analysis_cell(c_ind).PiezoSineTrial_IClamp)
% % %                 trial = load(analysis_cell(c_ind).PiezoSineTrial_IClamp);
% % %                 h = getShowFuncInputsFromTrial(trial);
% % %                 fprintf(1,'PF_PiezoSineOsciRVF: %s\n',analysis_cell(c_ind).name);
% % %                 cnt = cnt+1;
% % % 
% % %                 hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
% % %                 [f,transfer{cnt},freqs{cnt},dsplcmnts{cnt}] = feval(funchandle,[],h,analysis_cell(c_ind).genotype);
% % %                 savePDF(f,'C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\TransferFunctions',[],['IClamp_' types{t_ind}(1:regexp(types{t_ind},'_')) 'Xfunctions_' analysis_cell(c_ind).name]);
% % %             end
% % %         end
% % %         s.name = hasPiezoSineName;
% % %         s.transfer = transfer;
% % %         s.freqs = freqs;
% % %         s.dsplcmnts = dsplcmnts;
% % %         save(fn,'-struct','s')
% % %     end
% % % end
% % % %%


r = 3;
% pnl(r).pack('h',3) 
pnl(r).pack('h',2) 
pnl(r).marginbottom = 8;  
pnl(r+1).pack('h',2) 
pnl(r+1).marginbottom = 8;  

for t_ind = 1:length(types)
    clear transfer freqs dsplcmnts f
    eval(['analysis_cell = ' types{t_ind} ';']);
    eval(['analysis_cells = ' types{t_ind} 's;']);
    
    fn = fullfile('C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\TransferFunctions',[types{t_ind}(1:regexp(types{t_ind},'_')) 'Xfunctions__IClamp.mat']);
    s = load(fn);
    
    name = s.name;
    transfer = s.transfer;
    freqs = s.freqs;
    dsplcmnts = s.dsplcmnts;
    
    indv_ax = pnl(r,t_ind).select();
    dspl_ax = pnl(r+1,t_ind).select();
    hold(indv_ax,'on');
    hold(dspl_ax,'on');
    
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

    
    all_dsplcmnts = [0.015 0.05 0.15 .5];
    all_freqs = 25 * sqrt(2) .^ (-1:1:9);
    for d_ind = 1:length(all_dsplcmnts)
        dspltranf = nan(length(transfer),length(all_freqs));
        for c_ind = 1:length(transfer)
            dspl_o = dsplcmnts{c_ind};
            dspl = round(dspl_o*1000)/1000;

            d_i = find(dspl == all_dsplcmnts(d_ind));

            if isempty(d_i)
                continue
            end

            [~,af_i,af_f] = intersect(all_freqs,freqs{c_ind});
            dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(af_f,d_i)))';
            
            if d_ind==length(all_dsplcmnts)
                plot(freqs{c_ind}(af_f),real(abs(transfer{c_ind}(af_f,d_i))),...
                    'parent',indv_ax,'linestyle','-','color',0*[.85 .85 .85],...
                    'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
                    'displayname',name{c_ind},'tag',types{t_ind},'userdata',dspl_o(d_i))
            end
        end
%         if d_ind==length(all_dsplcmnts)
%             plot(indv_ax,all_freqs,nanmean(dspltranf,1),...
%                 'marker','o','markerfacecolor',[0 1/4 0]*length(all_dsplcmnts),'markeredgecolor',[0 1/4 0]*length(all_dsplcmnts),...
%                 'color',[0 1/4 0]*length(all_dsplcmnts));
%         end    
        for c_ind = 1:length(transfer)
            dspltranf(c_ind,:) = dspltranf(c_ind,:)/cell_max_foralldisp(c_ind);
        end

        plot(dspl_ax,all_freqs,nanmean(dspltranf,1),...
            'displayname',[num2str(all_dsplcmnts(d_ind),2),' V' ],...
            'marker','o','markerfacecolor','none','markeredgecolor','none',...[0 1/length(all_dsplcmnts) 0]*d_ind,...
            'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
        
        SEM = nanstd(dspltranf,[],1)/sqrt(sum(~isnan(dspltranf(:,1))));
        %     ts = tinv([0.025  0.975],sum(~isnan(dspltranf(:,1)))-1);
        ts = [-1 1];
        CI_up = ts(1)*SEM;
        CI_down = ts(2)*SEM;
        
        errorbar(dspl_ax,all_freqs,nanmean(dspltranf,1),CI_down,CI_up,...
            'linestyle','none','marker','none','color',[0 1/length(all_dsplcmnts) 0]*d_ind);        
        ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
    end
    set(indv_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    set(dspl_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    set(indv_ax,'ylim',[0 7.8]);
end
% savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
% savePDF(figure5,savedir,[],'Figure5')
% 

%% Plot the Voltage tuning curves

r = 5;
pnl(r).pack('h',2)  % response panel, stimulus panel
pnl(r).marginbottom = 4;  % response panel, stimulus panel

Scripts = {
%     'Record_FS_HighFreqDepolB1s'
    'Record_FS_BandPassHiB1s'
    'Record_FS_BandPassLowB1s'
    'Record_FS_LowPassB1s'
    };
selected_geno = {
%     '20XUAS-mCD8:GFP;VT30609-Gal4'
    '10XUAS-mCD8:GFP;Fru-Gal4'
    '20XUAS-mCD8:GFP;VT27938-Gal4'
    '20XUAS-mCD8:GFP;VT27938-Gal4'
    };

for cell_type = 1:length(Scripts)-1
    
    dspl_ax = pnl(r,cell_type).select();
    hold(dspl_ax,'on');

    all_dsplcmnts = [0.015 0.05 0.15 .5];
    %all_dsplcmnts = [ 0.15 ];
    all_freqs = round(25 * sqrt(2) .^ (-1:1:9) * 1000)/1000;
    
    eval(Scripts{cell_type});
    s = load(fullfile(savedir,'transfer_functions_data'));
    indices = strcmp(s.genotype,selected_geno{cell_type});

    genotype = s.genotype(indices);
    hasPiezoSineName = s.name(indices);
    transfer = s.transfer(indices);
    freqs = s.freqs(indices);
    dsplcmnts = s.dsplcmnts(indices);
    xfer_ct = ones(1,sum(indices));
%     if cell_type==2
%         eval(Scripts{cell_type+1});
%         s = load(fullfile(savedir,'transfer_functions_data'));
% 
%         indices = strcmp(s.genotype,selected_geno{cell_type+1});
%         xfer_ct = [xfer_ct 2*ones(1,sum(indices))];
%         genotype = [genotype s.genotype(indices)];
%         
%         hasPiezoSineName = [hasPiezoSineName s.name(indices)];
%         transfer = [transfer s.transfer(indices)];
%         freqs = [freqs s.freqs(indices)];
%         dsplcmnts = [dsplcmnts s.dsplcmnts(indices)];
%     end
    
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
            dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(af_f,d_i)))';

%             plot(freqs{c_ind}(af_f),dspltranf(c_ind,af_i),.../cell_max_foralldisp(c_ind),...
%                 'parent',dspl_ax,'linestyle','-','color',(xfer_ct(c_ind)-1)*[1 0 0],...
%                 'marker','.','markerfacecolor',(xfer_ct(c_ind)-1)*[1 0 0],'markeredgecolor',(xfer_ct(c_ind)-1)*[1 0 0],...
%                 'displayname',hasPiezoSineName{c_ind},'tag',genotype{c_ind},'userdata',dspl_o(d_i))

        end
        
        for c_ind = 1:length(transfer)
            dspltranf(c_ind,:) = dspltranf(c_ind,:)/cell_max_foralldisp(c_ind);
        end


        dspltranf = dspltranf(~isnan(dspltranf(:,1)),:);
        SEM = nanstd(dspltranf,[],1)/sqrt(sum(~isnan(dspltranf(:,1))));
        %     ts = tinv([0.025  0.975],sum(~isnan(dspltranf(:,1)))-1);
        ts = [-1 1];
        CI_up = ts(1)*SEM;
        CI_down = ts(2)*SEM;
        errorbar(dspl_ax,all_freqs,nanmean(dspltranf,1),CI_down,CI_up,'linestyle','-','marker','none','color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    end
    
    set(dspl_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    line(all_freqs([1 end]), [0 0],'parent',dspl_ax);

end

%%
Record_VoltageClampInputCurrents
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';

trial = load(fruexample.PiezoSineTrial_IClamp);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end
r = 2;

freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
fnum = length(freqs)+1;
pnl(r).pack('v', 2)  % response panel, stimulus panel
pnl(r,1).pack('h', 3)  % response panel, stimulus panel
pnl(r,2).pack('h', 3)  % response panel, stimulus panel
pnl(r).de.margin = [4 4 4 4];
pnl(r).marginbottom = 4;

trialnummatrix = nan(1,length(freqs));
pnl_hs = nan(2,3);

for bt = blocktrials;
    params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
    
    if sum(freqs == params.params.freq);
        c = find(freqs == params.params.freq);
        trialnummatrix(1,c) = bt;
    end    
end

ylims = [Inf, -Inf];
slims = [Inf, -Inf];

ylims = [Inf, -Inf];
slims = [Inf, -Inf];
for c = 1:size(trialnummatrix,2)
    trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
    h = getShowFuncInputsFromTrial(trial);

    averagefig = PF_PiezoSineAverage([],h,'');
        
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

    i = floor((c-1)/3)+1;
    j = c-floor((c-1)/3)*3;
    pnl_hs(i,j) = pnl(r,i,j).select();
    copyobj(get(ax_from,'children'),pnl(r,i,j).select());

    set(pnl(r,i,j).select(),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
    
end
% Step
c = c+1;
trial = load(fruexample.PiezoStepTrial_IClamp);
h = getShowFuncInputsFromTrial(trial);

averagefig = PF_PiezoStepAverage_SEM([],h,'');
ax_from = findobj(averagefig,'tag','response_ax');
ylabe = get(get(ax_from,'ylabel'),'string');
delete(get(ax_from,'xlabel'));
delete(get(ax_from,'ylabel'));
delete(get(ax_from,'zlabel'));
delete(get(ax_from,'title'));
i = floor((c-1)/3)+1;
j = c-floor((c-1)/3)*3;
pnl_hs(i,j) = pnl(r,i,j).select();
copyobj(get(ax_from,'children'),pnl(r,i,j).select());
set(pnl(r,i,j).select(),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);

close(averagefig)
% ylims
set(pnl_hs(:),'ylim',getpref('FigureMaking','Figure5IClampYlims'))
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure5Xlims'))
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
pnl(r,1,1).ylabel(['V']);
pnl(r,2,1).ylabel(['V']);
% pnl(r,1).de.fontsize = 18;

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(figure5,savedir,[],'Figure5_IClamp')



