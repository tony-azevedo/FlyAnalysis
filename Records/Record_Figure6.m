%% Figure 6
close all
Record_VoltageClampInputCurrents

figure5 = figure;

figure5.Units = 'inches';
set(figure5,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneAndHalfColumn'),10])
pnl = panel(figure5);

figurerows = [1 5 5 5  10 7 7];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);

pnl.margin = [20 4 4 4];

%% Aa: stimulus

Record_VoltageClampInputCurrents
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';

trial = load(a2example.PiezoSineTrial);
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
pnl(1).pack('h', fnum)  % response panel, stimulus panel
pnl(r).de.margin = [4 4 4 4];
pnl(r).marginbottom = 4;

trialnummatrix = nan(1,length(freqs));
pnl_hs = trialnummatrix;

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
    
    stim = PiezoSineStim(h.trial.params);
    x = makeInTime(h.trial.params);
    x_win = x>= -.2 & x<trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec);
    
    pnl_hs(1,c) = pnl(1,c).select();
    line(x(x_win),stim(x_win),'parent',pnl_hs(1,c),'color',[0 0 1],'tag',[num2str(h.trial.params.freq), 'Hz']);
    
    set(pnl_hs(1,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[]);
    axis(pnl_hs(1,c),'tight')
    
    slims_from = get(pnl_hs(1,c),'ylim');
    slims = [min(slims(1),slims_from(1)),...
        max(slims(2),slims_from(2))];
    
end
c = c+1;
trial = load(a2example.PiezoStepTrial);
h = getShowFuncInputsFromTrial(trial);

stim = PiezoStepStim(h.trial.params);
x = makeInTime(h.trial.params);
x_win = x>= -.2 & x<trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec);

pnl_hs(1,c) = pnl(1,c).select();
line(x(x_win),stim(x_win),'parent',pnl_hs(1,c),'color',[0 0 1],'tag',[num2str(h.trial.params.displacement), 'Hz']);

set(pnl_hs(1,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[]);
axis(pnl_hs(1,c),'tight')

% slims_from = get(pnl_hs(1,c),'ylim');
% slims = [min(slims(1),slims_from(1)),...
%     max(slims(2),slims_from(2))];

set(pnl_hs(:),'ylim',slims)
axis(pnl_hs(1,c),'tight')
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure5Xlims'))
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
pnl(1,1).ylabel(['V']);
pnl(1,1).de.fontsize = 18;

%% A: A2

Record_VoltageClampInputCurrents
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
r = 2;
trial = load(a2example.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
fnum = length(freqs)+1;
pnl(r).pack('h', fnum)  % response panel, stimulus panel
pnl(r).de.margin = [4 4 4 4];
pnl(r).marginbottom = 4;

trialnummatrix = nan(1,length(freqs));
pnl_hs = trialnummatrix;

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

    pnl_hs(r,c) = pnl(r,c).select();
    copyobj(get(ax_from,'children'),pnl_hs(r,c));

    set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
    
end
% Step
c = c+1;
trial = load(a2example.PiezoStepTrial);
h = getShowFuncInputsFromTrial(trial);

averagefig = PF_PiezoStepAverage_SEM([],h,'');
ax_from = findobj(averagefig,'tag','response_ax');
ylabe = get(get(ax_from,'ylabel'),'string');
delete(get(ax_from,'xlabel'));
delete(get(ax_from,'ylabel'));
delete(get(ax_from,'zlabel'));
delete(get(ax_from,'title'));
pnl_hs(r,c) = pnl(r,c).select();
copyobj(get(ax_from,'children'),pnl_hs(r,c));
set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);

close(averagefig)
ylims
set(pnl_hs(r,:),'ylim',getpref('FigureMaking','Figure5Ylims'))
set(pnl_hs(r,:),'xlim',getpref('FigureMaking','Figure5Xlims'))
set(pnl_hs(r,1),'ytickmode','auto','ycolor',[0 0 0])
pnl(r,1).ylabel(['V']);
pnl(r,1).de.fontsize = 18;


%% B: Fru example

Record_VoltageClampInputCurrents
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';

trial = load(fruexample.PiezoSineTrial);
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
pnl(r).pack('h', fnum)  % response panel, stimulus panel
pnl(r).de.margin = [4 4 4 4];
pnl(r).marginbottom = 4;

trialnummatrix = nan(1,length(freqs));
pnl_hs = trialnummatrix;

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

    pnl_hs(r,c) = pnl(r,c).select();
    copyobj(get(ax_from,'children'),pnl(r,c).select());

    set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
    
end
% Step
c = c+1;
trial = load(fruexample.PiezoStepTrial);
h = getShowFuncInputsFromTrial(trial);

averagefig = PF_PiezoStepAverage([],h,'');
ax_from = findobj(averagefig,'tag','response_ax');
ylabe = get(get(ax_from,'ylabel'),'string');
delete(get(ax_from,'xlabel'));
delete(get(ax_from,'ylabel'));
delete(get(ax_from,'zlabel'));
delete(get(ax_from,'title'));
pnl_hs(r,c) = pnl(r,c).select();
copyobj(get(ax_from,'children'),pnl_hs(r,c));
set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);

close(averagefig)
% ylims
set(pnl_hs(r,:),'ylim',getpref('FigureMaking','Figure5Ylims'))
set(pnl_hs(r,:),'xlim',getpref('FigureMaking','Figure5Xlims'))
set(pnl_hs(r,1),'ytickmode','auto','ycolor',[0 0 0])
pnl(r,1).ylabel(['V']);
pnl(r,1).de.fontsize = 18;

%% C: VT example

Record_VoltageClampInputCurrents
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';

trial = load(vtexample.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end
r = 4;

freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
fnum = length(freqs)+1;
pnl(r).pack('h', fnum)  % response panel, stimulus panel
pnl(r).de.margin = [4 4 4 4];
pnl(r).marginbottom = 4;

trialnummatrix = nan(1,length(freqs));
pnl_hs = trialnummatrix;

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

    pnl_hs(r,c) = pnl(r,c).select();
    copyobj(get(ax_from,'children'),pnl(r,c).select());

    set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
    
end
% Step
c = c+1;
trial = load(vtexample.PiezoStepTrial);
h = getShowFuncInputsFromTrial(trial);

averagefig = PF_PiezoStepAverage([],h,'');
ax_from = findobj(averagefig,'tag','response_ax');
ylabe = get(get(ax_from,'ylabel'),'string');
delete(get(ax_from,'xlabel'));
delete(get(ax_from,'ylabel'));
delete(get(ax_from,'zlabel'));
delete(get(ax_from,'title'));
pnl_hs(r,c) = pnl(r,c).select();
copyobj(get(ax_from,'children'),pnl_hs(r,c));
set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);

close(averagefig)
% ylims
% set(pnl_hs(r,:),'ylim',ylims)
set(pnl_hs(r,:),'ylim',getpref('FigureMaking','Figure5Ylims'))
set(pnl_hs(r,:),'xlim',getpref('FigureMaking','Figure5Xlims'))
set(pnl_hs(r,1),'ytickmode','auto','ycolor',[0 0 0])
pnl(r,1).ylabel(['V']);
pnl(r,1).de.fontsize = 18;

%% D: R45D07 example
% 
% Record_VoltageClampInputCurrents
% savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
% 
% trial = load(r45D07example.PiezoSineTrial);
% h = getShowFuncInputsFromTrial(trial);
% 
% blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
% t = 1;
% while t <= length(blocktrials)
%     trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
%     blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
%     t = t+1;
% end
% r = 5;
% 
% freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
% fnum = length(freqs)+1;
% pnl(r).pack('h', fnum)  % response panel, stimulus panel
% pnl(r).de.margin = [4 4 4 4];
% pnl(r).marginbottom = 4;
% 
% trialnummatrix = nan(1,length(freqs));
% pnl_hs = trialnummatrix;
% 
% for bt = blocktrials;
%     params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
%     
%     if sum(freqs == params.params.freq);
%         c = find(freqs == params.params.freq);
%         trialnummatrix(1,c) = bt;
%     end    
% end
% 
% ylims = [Inf, -Inf];
% slims = [Inf, -Inf];
% 
% ylims = [Inf, -Inf];
% slims = [Inf, -Inf];
% for c = 1:size(trialnummatrix,2)
%     trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
%     h = getShowFuncInputsFromTrial(trial);
% 
%     averagefig = PF_PiezoSineAverage([],h,'');
%         
%     ax_from = findobj(averagefig,'tag','response_ax');
%     
%     ylabe = get(get(ax_from,'ylabel'),'string');
%     delete(get(ax_from,'xlabel'));
%     delete(get(ax_from,'ylabel'));
%     delete(get(ax_from,'zlabel'));
%     delete(get(ax_from,'title'));
%     
%     ylims_from = get(ax_from,'ylim');
%     xlims_from = get(ax_from,'xlim');
%     ylims = [min(ylims(1),ylims_from(1)),...
%         max(ylims(2),ylims_from(2))];
% 
%     pnl_hs(r,c) = pnl(r,c).select();
%     copyobj(get(ax_from,'children'),pnl(r,c).select());
% 
%     set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
%         
%         
%     % drawnow;
%     close(averagefig)
%     
% end
% % Step
% c = c+1;
% trial = load(r45D07example.PiezoStepTrial);
% h = getShowFuncInputsFromTrial(trial);
% 
% averagefig = PF_PiezoStepAverage([],h,'');
% ax_from = findobj(averagefig,'tag','response_ax');
% ylabe = get(get(ax_from,'ylabel'),'string');
% delete(get(ax_from,'xlabel'));
% delete(get(ax_from,'ylabel'));
% delete(get(ax_from,'zlabel'));
% delete(get(ax_from,'title'));
% pnl_hs(r,c) = pnl(r,c).select();
% copyobj(get(ax_from,'children'),pnl_hs(r,c));
% set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
% 
% close(averagefig)
% % ylims
% % set(pnl_hs(r,:),'ylim',ylims)
% set(pnl_hs(r,:),'ylim',getpref('FigureMaking','Figure5Ylims'))
% set(pnl_hs(r,:),'xlim',getpref('FigureMaking','Figure5Xlims'))
% set(pnl_hs(r,1),'ytickmode','auto','ycolor',[0 0 0])
% pnl(r,1).ylabel(['V']);
% pnl(r,1).de.fontsize = 18;
% 

%% Sensitivity curves

LTSfigure = figure; 
LTSax = subplot(1,1,1,'parent',LTSfigure);
Scripts_ = {
    'A2'
    'B1-BPH'
    'B1-BPM/L'
};
clear l leg_str
types = {
    'a2_cell'
    'fru_cell'
    'vt_cell'
    'offtarget_cell'
    };

r = 5;
pnl(r).pack('h',3)  % response panel, stimulus panel
pnl(r+1).pack('h',3)  % response panel, stimulus panel
pnl(r).marginbottom = 4;  % response panel, stimulus panel
pnl(r+1).margintop = 4;  % response panel, stimulus panel

for t_ind = 1:3
    clear transfer freqs dsplcmnts f
    eval(['analysis_cell = ' types{t_ind} ';']);
    eval(['analysis_cells = ' types{t_ind} 's;']);
    
    trial = load(analysis_cell(1).PiezoSineTrial);
    h = getShowFuncInputsFromTrial(trial);
    
    fn = fullfile('C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\TransferFunctions',[types{t_ind}(1:regexp(types{t_ind},'_')) 'Xfunctions.mat']);
    if exist(fn,'file')==2
        s = load(fn);
    else
        if t_ind==1
        funchandle = @PF_PiezoSineDepolRespVsFreq_Current;
        else
        funchandle = @PF_PiezoSineOsciRespVsFreq;
        end
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
    dspl_ax = pnl(r+1,t_ind).select();
    hold(indv_ax,'on');
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
    
    lifetime_spareness = nan(length(transfer),length(all_dsplcmnts));
    for d_ind = 1:length(displacements)
        dspltranf = nan(length(transfer),length(h.trial.params.freqs));
        for c_ind = 1:length(transfer)
            dspl = dsplcmnts{c_ind};
            
            d_i = find(dspl == displacements(d_ind));
            if t_ind ==1
                dspltranf(c_ind,:) = transfer{c_ind}(:,d_i)';%/cell_max_foralldisp(c_ind);
            else
                dspltranf(c_ind,:) = real(abs(transfer{c_ind}(:,d_i)))';%/cell_max_foralldisp(c_ind);
            end
            
            r_ = dspltranf(c_ind,:);
            lifetime_spareness(c_ind,d_ind) = ...
                1/length(h.trial.params.freqs) * ...
                sum(((r_-mean(r_))/std(r_)).^4) - 3;

            if displacements(d_ind)==show_dsplc
                plot(freqs{c_ind},dspltranf(c_ind,:),...
                    'parent',indv_ax,'linestyle','-','color',0*[.85 .85 .85],...
                    'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
                    'displayname',name{c_ind},'tag',types{t_ind},'userdata',dspl(d_i))
            end
            
        end
        if displacements(d_ind)==show_dsplc
            if t_ind ==1
                text(17,-10,['N=' num2str(length(indv_ax.Children))],'parent',indv_ax,'verticalalignment','bottom');
            else
                text(400,10,['N=' num2str(length(indv_ax.Children))],'parent',indv_ax,'verticalalignment','bottom');
            end
            
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
        
%         plot(indv_ax,freqs{c_ind},nanmean(dspltranf,1),...
%             'marker','o','markerfacecolor',[0 1/4 0]*d_ind,'markeredgecolor',[0 1/4 0]*d_ind,...
%             'color',[0 1/4 0]*d_ind);
        errorbar(dspl_ax,freqs{c_ind},nanmean(dspltranf,1),CI_down,CI_up,'linestyle','-','marker','none','color',[0 1/4 0]*d_ind);
        
        ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
    end
    
    clr = [1 1 0]/length(Scripts_)*(t_ind-1) + [0 0 1/length(Scripts_)]*t_ind;
    plot(LTSax,(1:4)+(t_ind-1)*.15,lifetime_spareness,'.','color',clr,'displayname',Scripts_{t_ind}), hold on;
    l(t_ind) = plot(LTSax,(1:4)+(t_ind-1)*.15,nanmean(lifetime_spareness,1),...
        'marker','o','markersize',6,'markeredgecolor',clr,'markerfacecolor',clr,...
        'color',clr,'displayname',Scripts_{t_ind});
    leg_str{t_ind} = Scripts_{t_ind};
    
    set(indv_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    line(all_freqs([1 end]), [0 0],'parent',indv_ax);
    if t_ind ==1
        set(indv_ax,'ylim',[-12 .4]);
    else
        set(indv_ax,'ylim',[-1 44]);
    end
    set(dspl_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    line(all_freqs([1 end]), [0 0],'parent',dspl_ax);
    if t_ind ==1
        set(dspl_ax,'ylim',[-1 .1]);
    else
        set(dspl_ax,'ylim',[-.1 1]);
    end

end

legend(LTSax,l,leg_str)
set(LTSax,'xtick',[1 2 3 4],'XTickLabel',{'0.045' '0.15' '0.45' '1.5'})
xlabel('amplitude (\mum)');
ylabel('Lifetime Kurtosis');

ylim(LTSax,[-2.3 4.1])
xlim(LTSax,[.5 4.9])

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(LTSfigure,savedir,[],'Figure5_CurrentKurtosis')

%% Plot the Voltage tuning curves

r = 7;
pnl(r).pack('h',3)  % response panel, stimulus panel
pnl(r).marginbottom = 4;  % response panel, stimulus panel

Scripts = {
    'Record_FS_HighFreqDepolB1s'
    'Record_FS_BandPassHiB1s'
    'Record_FS_BandPassLowB1s'
    'Record_FS_LowPassB1s'
    };
selected_geno = {
    '20XUAS-mCD8:GFP;VT30609-Gal4'
    '10XUAS-mCD8:GFP;Fru-Gal4'
    '20XUAS-mCD8:GFP;VT27938-Gal4'
    '20XUAS-mCD8:GFP;VT27938-Gal4'
    };

for cell_type = 1:length(Scripts)-1
    
    dspl_ax = pnl(r,cell_type).select();
    hold(dspl_ax,'on');

    all_dsplcmnts = [0.015 0.05 0.15 .5];
    all_dsplcmnts = [ 0.15 ];
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
    if cell_type==3
        eval(Scripts{cell_type+1});
        s = load(fullfile(savedir,'transfer_functions_data'));

        indices = strcmp(s.genotype,selected_geno{cell_type+1});
        xfer_ct = [xfer_ct 2*ones(1,sum(indices))];
        genotype = [genotype s.genotype(indices)];
        
        hasPiezoSineName = [hasPiezoSineName s.name(indices)];
        transfer = [transfer s.transfer(indices)];
        freqs = [freqs s.freqs(indices)];
        dsplcmnts = [dsplcmnts s.dsplcmnts(indices)];
    end
    
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
            dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(af_f,d_i)))'/cell_max_foralldisp(c_ind);

            plot(freqs{c_ind}(af_f), dspltranf(c_ind,af_i),...
                'parent',dspl_ax,'linestyle','-','color',(xfer_ct(c_ind)-1)*[1 0 0],...
                'marker','.','markerfacecolor',(xfer_ct(c_ind)-1)*[1 0 0],'markeredgecolor',(xfer_ct(c_ind)-1)*[1 0 0],...
                'displayname',hasPiezoSineName{c_ind},'tag',genotype{c_ind},'userdata',dspl_o(d_i))

        end
        
        %         dspltranf = dspltranf(~isnan(dspltranf(:,1)),:);
        %         SEM = nanstd(dspltranf,[],1)/sqrt(sum(~isnan(dspltranf(:,1))));
        %         %     ts = tinv([0.025  0.975],sum(~isnan(dspltranf(:,1)))-1);
        %         ts = [-1 1];
        %         CI_up = ts(1)*SEM;
        %         CI_down = ts(2)*SEM;
        %         errorbar(dspl_ax,all_freqs,nanmean(dspltranf,1),CI_down,CI_up,'linestyle','-','marker','none','color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    end
    
    set(dspl_ax,'xscale','log','TickDir','out','xlim',[15 600]);
    line(all_freqs([1 end]), [0 0],'parent',dspl_ax);

end


%%
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(figure5,savedir,[],'Figure5_normalized')
