
%% Figure 4: ShakB Experiments

savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_ShakB2';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1
id = 'ShakB_';

close all
figure4 = figure;

figure4.Units = 'inches';
set(figure4,'color',[1 1 1],'position',[1 1 getpref('FigureSizes','NeuronOneAndHalfColumn'),5])
pnl = panel(figure4);
pnl.margin = [16 2 4 4];

figurerows = [5 5 1 5 5 1];
figurerows = num2cell(figurerows/sum(figurerows));

pnl.pack('v',figurerows);

figurecolumns = [2 2 2 2 2 2];
figurecolumns = num2cell(figurecolumns/sum(figurecolumns));

clear pnl_hs
for r = 1:length(figurerows)
    pnl(r).pack('h',figurecolumns);
    pnl(r).marginleft = 4;
    for c = 1:length(figurecolumns)
        pnl_hs(r,c) = pnl(r,c).select();
    end
end

% 151103_F3_C1 [curare] 25 Hz, 151106_F1_C1[curare] 50 Hz, 150701_F1_C1 [MLA] 100 Hz, 
Script_Shak2_Controls_MLA_Ex
example_cells = {
    '151103_F3_C1'
    '151106_F1_C1'
    '150701_F1_C1'
    }

r = 0;
for c=1:length(example_cells)
    ylims = [Inf -Inf];
    ac = analysis_cell(strcmp(analysis_cells,example_cells{c}));

% ---- PiezoSineTrial ------
    trial = load(ac.PiezoSineTrial_IClamp);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoSineAverage([],h,ac.name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl(r+1,2*c-1).select());
    txt = findobj(pnl(r+1,2*c-1).select(),'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    axis(pnl(r+1,2*c-1).select(),'tight')
    ylims = [...
        min([ylims(1) min(get(pnl(r+1,2*c-1).select(),'ylim'))]),...
        max([ylims(2) max(get(pnl(r+1,2*c-1).select(),'ylim'))])];

    close(fig)

% ---- PiezoSine Drug Trial ------
    trial = load(ac.PiezoSineTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoSineAverage([],h,ac.name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl(r+2,2*c-1).select());
    txt = findobj(pnl(r+2,2*c-1).select(),'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    axis(pnl(r+2,2*c-1).select(),'tight')
    ylims = [...
        min([ylims(1) min(get(pnl(r+2,2*c-1).select(),'ylim'))]),...
        max([ylims(2) max(get(pnl(r+2,2*c-1).select(),'ylim'))])];

    close(fig)

% ---- PiezoSine Stimulus ------
    trial = load(ac.PiezoSineTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);
    x = makeInTime(trial.params);
    y = PiezoSineStim(trial.params);
    
    line(x,y,'parent',pnl(r+3,2*c-1).select());
    

% ---- PiezoStepTrial ------
    trial = load(ac.PiezoStepTrial_IClamp);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoStepAverage([],h,ac.name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl(r+1,2*c).select());
    txt = findobj(pnl(r+1,2*c).select(),'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    
    axis(pnl(r+1,2*c).select(),'tight')
    ylims = [...
        min([ylims(1) min(get(pnl(r+1,2*c).select(),'ylim'))]),...
        max([ylims(2) max(get(pnl(r+1,2*c).select(),'ylim'))])];

    close(fig)

% ---- PiezoStep Drug Trial ------
    trial = load(ac.PiezoStepTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoStepAverage([],h,ac.name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl(r+2,2*c).select());
    txt = findobj(pnl(r+2,2*c).select(),'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    axis(pnl(r+2,2*c).select(),'tight')
    ylims = [...
        min([ylims(1) min(get(pnl(r+2,2*c).select(),'ylim'))]),...
        max([ylims(2) max(get(pnl(r+2,2*c).select(),'ylim'))])];

    close(fig)

% ---- PiezoStep Stimulus ------
    trial = load(ac.PiezoStepTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);
    x = makeInTime(trial.params);
    y = PiezoStepStim(trial.params);
    
    line(x,y,'parent',pnl(r+3,2*c).select());   
    
    ylims
    set(pnl_hs(r+(1:2),2*(c-1)+[1 2]),'ylim',ylims)
    set(pnl_hs(r+3,2*(c-1)+[1 2]),'ylim',[-1 1])
    set(pnl_hs(r+(1:3),2*(1:3)),'ycolor',[1 1 1],'ytick',[]);
end

% 151015_F1_C1 [curare] 50 Hz, Examples 151010_F1_C1[curare] 50 Hz, 150723_F1_C2 [MLA] 100 Hz, 
Script_Shak2_ShakB_MLA_Ex
example_cells = {
    '151015_F1_C1'
    '151010_F1_C1'
    '150723_F1_C2'
    }

ylims = [-Inf Inf];
r = 3;
for c=1:length(example_cells)
    ylims = [Inf -Inf];
    ac = analysis_cell(strcmp(analysis_cells,example_cells{c}));

% ---- PiezoSineTrial ------
    trial = load(ac.PiezoSineTrial_IClamp);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoSineAverage([],h,ac.name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl(r+1,2*c-1).select());
    txt = findobj(pnl(r+1,2*c-1).select(),'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    axis(pnl(r+1,2*c-1).select(),'tight')
    ylims = [...
        min([ylims(1) min(get(pnl(r+1,2*c-1).select(),'ylim'))]),...
        max([ylims(2) max(get(pnl(r+1,2*c-1).select(),'ylim'))])];

    close(fig)

% ---- PiezoSine Drug Trial ------
    trial = load(ac.PiezoSineTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoSineAverage([],h,ac.name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl(r+2,2*c-1).select());
    txt = findobj(pnl(r+2,2*c-1).select(),'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    axis(pnl(r+2,2*c-1).select(),'tight')
    ylims = [...
        min([ylims(1) min(get(pnl(r+2,2*c-1).select(),'ylim'))]),...
        max([ylims(2) max(get(pnl(r+2,2*c-1).select(),'ylim'))])];

    close(fig)

% ---- PiezoSine Stimulus ------
    trial = load(ac.PiezoSineTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);
    x = makeInTime(trial.params);
    y = PiezoSineStim(trial.params);
    
    line(x,y,'parent',pnl(r+3,2*c-1).select());
    

% ---- PiezoStepTrial ------
    trial = load(ac.PiezoStepTrial_IClamp);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoStepAverage([],h,ac.name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl(r+1,2*c).select());
    txt = findobj(pnl(r+1,2*c).select(),'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    
    axis(pnl(r+1,2*c).select(),'tight')
    ylims = [...
        min([ylims(1) min(get(pnl(r+1,2*c).select(),'ylim'))]),...
        max([ylims(2) max(get(pnl(r+1,2*c).select(),'ylim'))])];

    close(fig)

% ---- PiezoStep Drug Trial ------
    trial = load(ac.PiezoStepTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);

    fig = PF_PiezoStepAverage([],h,ac.name);
    
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'children'),pnl(r+2,2*c).select());
    txt = findobj(pnl(r+2,2*c).select(),'type','text');
    pstn = get(txt,'position');pstn(1) = 0;
    set(txt,'position',pstn);
    axis(pnl(r+2,2*c).select(),'tight')
    ylims = [...
        min([ylims(1) min(get(pnl(r+2,2*c).select(),'ylim'))]),...
        max([ylims(2) max(get(pnl(r+2,2*c).select(),'ylim'))])];

    close(fig)

% ---- PiezoStep Stimulus ------
    trial = load(ac.PiezoStepTrial_IClamp_Drug);
    h = getShowFuncInputsFromTrial(trial);
    x = makeInTime(trial.params);
    y = PiezoStepStim(trial.params);
    
    line(x,y,'parent',pnl(r+3,2*c).select());   
    
    ylims
    set(pnl_hs(r+(1:2),2*(c-1)+[1 2]),'ylim',ylims)
    set(pnl_hs(r+3,2*(c-1)+[1 2]),'ylim',[-1 1])
    set(pnl_hs(r+(1:3),2*(1:3)),'ycolor',[1 1 1],'ytick',[]);
end

% ---- Clean up ----
set(pnl_hs(:),'xlim',[-.05 .1])
set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[]);
%delete(findobj(pnl_hs(:),'type','line','color',[1 .7 .7]));

figure4dir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure4/';
savePDF(figure4,figure4dir,[],'Figure4af');

%%
Script_Shak2_ShakB_Ex

auxid = 'ShakB_nodrugs';
% Script_ShakB2_PiezoSine
% Script_ShakB2_PiezoSineRvF
% Script_ShakB2_PiezoStepFam

Script_ShakB2_PiezoStep

ShakB_cell = analysis_cell;

% savePDF(fig,savedir,[],'ShakB2Males')
shakbmalesdots = findobj(fig,'tag','dots');

% ShakB flies with drug trials 
% Examples 151010F1C1[curare] 50 Hz, 150723F1C2 [MLA] 100 Hz, 151015F1C1
% [curare] 50 Hz

Script_Shak2_ShakB_MLA_Ex

auxid = 'ShakB';
% Script_ShakB2_PiezoStepFam
% Script_ShakB2_PiezoSineRvF
% Script_ShakB2_PiezoSine

Script_ShakB2_PiezoStep_Drug

ShakB_drug_cell = analysis_cell;

% savePDF(fig,savedir,[],'ShakB2Males_Drug.pdf')

shakbmalesdrugsdots = findobj(fig,'tag','dots');
examplepnl = panel.recover(fig);
shakB_ctrl_ax = examplepnl(5,1).select();
shakB_drug_ax = examplepnl(5,2).select();
shakB_step_ax = examplepnl(5,3).select();


% Controls with no drugs
Script_Shak2_Controls_Ex

auxid = 'ShakBCtrl_nodrugs';
% Script_ShakB2_PiezoStepFam
% Script_ShakB2_PiezoSine
% Script_ShakB2_PiezoSineRvF

Script_ShakB2_PiezoStep

ShakB_ctrl_cell = analysis_cell;

shakbcontrolsdots = findobj(fig,'tag','dots');

% savePDF(fig,savedir,[],'ShakB2Controls')


% Controls that have drug trials
% Examples: 151106F1C1[curare] 50 Hz, 150701F1C1 [MLA] 100 Hz, 151103F3C1 [curare]
% 25 Hz

Script_Shak2_Controls_MLA_Ex

auxid = 'ShakBCtrl';
% Script_ShakB2_PiezoStepFam
% Script_ShakB2_PiezoSine
% Script_ShakB2_PiezoSineRvF

Script_ShakB2_PiezoStep_Drug

ShakB_ctrl_drug_cell = analysis_cell;

shakbcontrolsdrugsdots = findobj(fig,'tag','dots');
% savePDF(fig,savedir,[],'ShakB2Controls_Drug')

examplepnl = panel.recover(fig);
ctrl_ctrl_ax = examplepnl(5,1).select();
ctrl_drug_ax = examplepnl(5,2).select();
ctrl_step_ax = examplepnl(5,3).select();


%
dots_fig = figure;
dots_fig.Units = 'inches';
set(dots_fig,'color',[1 1 1],'position',[1 1 (getpref('FigureSizes','NeuronTwoColumn')-getpref('FigureSizes','NeuronOneAndHalfColumn')),5])
pnl = panel(dots_fig);

pnl.pack('h',2)  % response panel, stimulus panel
pnl.margin = [16 16 4 4];
pnl.fontname = 'Arial';
copyobj(get(shakbcontrolsdrugsdots,'children'),pnl(1).select());
copyobj(get(shakbcontrolsdots,'children'),pnl(1).select());

copyobj(get(shakbmalesdrugsdots,'children'),pnl(2).select());
copyobj(get(shakbmalesdots,'children'),pnl(2).select());

linkaxes([pnl(1).select() pnl(2).select()])
xlim(pnl(2).select(),[-.5 1.5])
ylim(pnl(2).select(),[0 15])

set(pnl(1).select(),'xticklabel',{'ctrl','drug'},'xtick',[0 1],'tag','dots','tag','wt')
set(pnl(2).select(),'xticklabel',{'ctrl','drug'},'xtick',[0 1],'tag','dots','tag','shakB2')

ylabel(pnl(1).select(),'Peak (mV)')


savePDFandFIG(dots_fig,figure4dir,[],'ShakB2StepFig')

%% Stats
close all

pnl = panel.recover(dots_fig);
uiopen(fullfile(figure4dir,'ShakB2StepFig.fig'),1)

wt_dots = get(findobj(gcf,'tag','wt'),'children');
wt_ctrl = [];
wt_drug = [];
wt_ctrl_p = [];
wt_drug_p = [];
for d_ind = 1:length(wt_dots)
    yd = get(wt_dots(d_ind),'ydata');
    switch length(yd)
        case 1
            wt_ctrl(end+1) = yd;
        case 2
            wt_ctrl(end+1) = yd(1);
            wt_drug(end+1) = yd(2);
            wt_ctrl_p(end+1) = yd(1);
            wt_drug_p(end+1) = yd(2);
    end
end

shkB_dots = get(findobj(gcf,'tag','shakB2'),'children');
shkB_ctrl = [];
shkB_drug = [];
shkB_ctrl_p = [];
shkB_drug_p = [];
for d_ind = 1:length(shkB_dots)
    yd = get(shkB_dots(d_ind),'ydata');
    switch length(yd)
        case 1
            shkB_ctrl(end+1) = yd;
        case 2
            shkB_ctrl(end+1) = yd(1);
            shkB_drug(end+1) = yd(2);
            shkB_ctrl_p(end+1) = yd(1);
            shkB_drug_p(end+1) = yd(2);
    end
end

percentreduced_wt = (wt_ctrl_p-wt_drug_p)./wt_ctrl_p
percentreduced_shakB = (shkB_ctrl_p-shkB_drug_p)./shkB_ctrl_p

% % ttest
% [H,P,CI] = ttest(wt_ctrl_p,wt_drug_p)       % p = 0.17
% [H,P,CI] = ttest(shkB_ctrl_p,shkB_drug_p)   % p = 0.0015

% % ttest2
% [H,P,CI] = ttest2(wt_ctrl,wt_drug)          % p = 0.1355
% [H,P,CI] = ttest2(shkB_ctrl,shkB_drug)      % p = 0.0428
% [H,P,CI] = ttest2(wt_ctrl,shkB_ctrl)        % p < 1E-4
% [H,P,CI] = ttest2(percentreduced_wt,percentreduced_shakB)   % p <1E-6

% % ranksum
% [P,H,CI] = ranksum(wt_ctrl,wt_drug)          % p = 0.1355
% [P,H,CI] = ranksum(shkB_ctrl,shkB_drug)      % p < 1E-4
% [P,H,CI] = ranksum(wt_ctrl,shkB_ctrl)        % p < 1E-4

%% 
y = [wt_ctrl,wt_drug,shkB_ctrl,shkB_drug];
g1 = cat(2,...
    repmat({'wt'},size(wt_ctrl)),...
    repmat({'wt'},size(wt_drug)),...
    repmat({'shakB2'},size(shkB_ctrl)),...
    repmat({'shakB2'},size(shkB_drug)))%,...
g2 = cat(2,...
    repmat({'ctrl'},size(wt_ctrl)),...
    repmat({'drug'},size(wt_drug)),...
    repmat({'ctrl'},size(shkB_ctrl)),...
    repmat({'drug'},size(shkB_drug)))%,...

% y = [wt_ctrl_p,wt_drug_p,shkB_ctrl_p,shkB_drug_p];
% g1 = cat(2,...
%     repmat({'wt'},size(wt_ctrl_p)),...
%     repmat({'wt'},size(wt_drug_p)),...
%     repmat({'shakB2'},size(shkB_ctrl_p)),...
%     repmat({'shakB2'},size(shkB_drug_p)))%,...
% g2 = cat(2,...
%     repmat({'ctrl'},size(wt_ctrl_p)),...
%     repmat({'drug'},size(wt_drug_p)),...
%     repmat({'ctrl'},size(shkB_ctrl_p)),...
%     repmat({'drug'},size(shkB_drug_p)))%,...

%% anova

figure
[p,tbl,stats,terms] = anovan(y,{g1,g2},'model','linear','varnames',{'geno';'cond'});
multcompare(stats,'ctyp','lsd','dimension',[1 2]);

%% kruskalwallis
for i = 1:length(g1)
    g3{i} = [g1{i} '_' g2{i}];
end
    
[P,ANOVATAB,STATS] = kruskalwallis(y,g3);
results = multcompare(STATS,'ctype','hsd');



