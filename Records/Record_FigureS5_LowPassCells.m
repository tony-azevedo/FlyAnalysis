%% Figure 5 Low pass cells stuff

close all
types = {
%     'a2_cell'
%     'fru_cell'
%     'vt_cell'
%     'offtarget_cell'
    'r45D07_cell'
    };


figure5 = figure;
Record_VoltageClampInputCurrents

figure5.Units = 'inches';
set(figure5,'color',[1 1 1],'position',[1 .2 getpref('FigureSizes','NeuronOneColumn'),10])
pnl = panel(figure5);

figurerows = [3 4 3 4 3];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);
pnl.margin = [16 16 4 4];


%% D: R45D07 example

Record_VoltageClampInputCurrents
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';

trial = load(r45D07example.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end
r = 1;

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
trial = load(r45D07example.PiezoStepTrial);
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
set(pnl_hs(:),'ylim',getpref('FigureMaking','Figure5Ylims'))
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure5Xlims'))
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
pnl(r,1,1).ylabel(['pA']);
pnl(r,2,1).ylabel(['pA']);


%% sensitivity curves for Low pass B1 neurons

r = 2;
pnl(r).pack('h',2) 
pnl(r).marginbottom = 8;  


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
    
    indv_ax = pnl(r,1).select();
    hold(indv_ax,'on');
    dspl_ax = pnl(r,2).select();
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
    set(indv_ax,'ylim',[0 10]);
end


savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(figure5,savedir,[],'Figure5_AllCells')


%% D: R45D07 example

Record_FS_TargetedLowPassB1s

trial = load(example_cell.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

r = 3;

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
trial = load(example_cell.PiezoStepTrial);
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
set(pnl_hs(:),'ylim',[-51 -20])
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure5Xlims'))
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
pnl(r,1,1).ylabel(['pA']);
pnl(r,2,1).ylabel(['pA']);


%% sensitivity curves for Low pass B1 neurons

r = 4;
pnl(r).pack('h',2) 
pnl(r).marginbottom = 8;  

Record_FS_TargetedLowPassB1s

clear transfer freqs dsplcmnts f

trial = load(analysis_cell(1).PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

s = load(fullfile(savedir,'transfer_functions_data'));
name = s.name;
transfer = s.transfer;
freqs = s.freqs;
dsplcmnts = s.dsplcmnts;

if length(name)~=length(analysis_cells) || length(name)~=length(transfer)
    warning('Transfer_functions_data for %s is out of date',id)
%     Script_TransferFunctionsFigure2
end

indv_ax = pnl(r,1).select();
hold(indv_ax,'on');
dspl_ax = pnl(r,2).select();
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
set(indv_ax,'ylim',[0 15]);


savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(figure5,savedir,[],'Figure5_LowPassCells')

%% Voltage Steps Low pass B1 neurons

r = 5;
pnl(r).pack('h',2) 
pnl(r).marginbottom = 8;  

Record_FS_TargetedLowPassB1s

step_ax = pnl(r,1).select();
hold(step_ax,'on');
iv_ax = pnl(r,2).select();
hold(iv_ax,'on');

for c_ind = 1:length(analysis_cell)
    disp(analysis_cell(c_ind).name)
    if ~isempty(analysis_cell(c_ind).VoltageStepTrial)
        trial = load(analysis_cell(c_ind).VoltageStepTrial);
        h = getShowFuncInputsFromTrial(trial);
        t = findLikeTrials('name',h.trial.name);
        
        x = makeInTime(h.trial.params);
%         xwin = x>.1-.01 & x<=.1+0.03;
%         
%         y = nan(length(t),sum(xwin));
%         for tr_ind = 1:length(t)
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,t(tr_ind))));
%             y(tr_ind,:) = trial.current(xwin);
%         end
%         plot(step_ax_d,x(xwin),mean(y,1),...
%             'displayname',[num2str(h.trial.params.step),' V' ],...
%             'color',clrs(c_ind,:));
        
        trial = load(fullfile(h.dir,sprintf(h.trialStem,t(1)+diff(t(1:2))-1)));
        h = getShowFuncInputsFromTrial(trial);
        t = findLikeTrials('name',h.trial.name);
        xwin = x>-.05 & x<=0.15;
        
        y = nan(length(t),sum(xwin));
        for tr_ind = 1:length(t)
            trial = load(fullfile(h.dir,sprintf(h.trialStem,t(tr_ind))));
            y(tr_ind,:) = trial.current(xwin);
        end
        plot(step_ax,x(xwin),mean(y,1),...
            'displayname',[num2str(h.trial.params.step),' V' ],...
            'color',[1 0 1]);
        
        [V,I,Base] = PF_VoltageStepIVRelationship_NoPlot(h,'');
        plot(iv_ax,V-Base,I,...
            'tag',analysis_cell(c_ind).name,...
            'displayname',analysis_cell(c_ind).name,...
            'color',[1 0 1]);
    end
end

set(step_ax(:),'ylim',[-40 120])
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure5Xlims'))

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(figure5,savedir,[],'Figure5_LowPassCells')

