
%% Record of ShakB Experiments

savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_ShakB2';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1
id = 'ShakB_';

%%
Script_Shak2_ShakB_Ex

auxid = 'ShakB_nodrugs';
Script_ShakB2_PiezoSine
Script_ShakB2_PiezoSineRvF

Script_ShakB2_PiezoStepFam
Script_ShakB2_PiezoStep

ShakB_cell = analysis_cell;

fn = fullfile(savedir,['ShakB2Males.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
shakbmalesdots = findobj(fig,'tag','dots');

%%
Script_Shak2_ShakB_MLA_Ex

auxid = 'ShakB';
Script_ShakB2_PiezoStepFam
Script_ShakB2_PiezoSineRvF
Script_ShakB2_PiezoSine

Script_ShakB2_PiezoStep_Drug

ShakB_drug_cell = analysis_cell;

fn = fullfile(savedir,['ShakB2Males_Drug.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
shakbmalesdrugsdots = findobj(fig,'tag','dots');
examplepnl = panel.recover(fig);
shakB_ctrl_ax = examplepnl(5,1).select();
shakB_drug_ax = examplepnl(5,2).select();
shakB_step_ax = examplepnl(5,3).select();


%%
Script_Shak2_Controls_Ex

auxid = 'ShakBCtrl_nodrugs';
Script_ShakB2_PiezoStepFam
Script_ShakB2_PiezoSine
Script_ShakB2_PiezoSineRvF

Script_ShakB2_PiezoStep

ShakB_ctrl_cell = analysis_cell;

fn = fullfile(savedir,['ShakB2Controls.pdf']);
figure(fig)
set(fig,'position',[610 558 992 420])
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
shakbcontrolsdots = findobj(fig,'tag','dots');


%%
Script_Shak2_Controls_MLA_Ex

auxid = 'ShakBCtrl';
Script_ShakB2_PiezoStepFam
Script_ShakB2_PiezoSine
Script_ShakB2_PiezoSineRvF

Script_ShakB2_PiezoStep_Drug

ShakB_ctrl_drug_cell = analysis_cell;

fn = fullfile(savedir,['ShakB2Controls_Drug.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
shakbcontrolsdrugsdots = findobj(fig,'tag','dots');
examplepnl = panel.recover(fig);
ctrl_ctrl_ax = examplepnl(5,1).select();
ctrl_drug_ax = examplepnl(5,2).select();
ctrl_step_ax = examplepnl(5,3).select();


%%
dots_fig = figure;
set(dots_fig,'color',[1 1 1],'position',[286   458   512   520])
pnl = panel(dots_fig);

pnl.pack('h',2)  % response panel, stimulus panel
pnl.margin = [18 10 10 10];
pnl.fontname = 'Arial';
pnl(1).pack('v',{3/10,3/10,1/10,3/10})  % response panel, stimulus panel
copyobj(get(ctrl_ctrl_ax,'children'),pnl(1,1).select());
copyobj(get(ctrl_drug_ax,'children'),pnl(1,2).select());
copyobj(get(ctrl_step_ax,'children'),pnl(1,3).select());
copyobj(get(shakbcontrolsdrugsdots,'children'),pnl(1,4).select());
copyobj(get(shakbcontrolsdots,'children'),pnl(1,4).select());

pnl(2).pack('v',{3/10,3/10,1/10,3/10})  % response panel, stimulus panel
copyobj(get(shakB_ctrl_ax ,'children'),pnl(2,1).select());
copyobj(get(shakB_drug_ax ,'children'),pnl(2,2).select());
copyobj(get(shakB_step_ax ,'children'),pnl(2,3).select());
copyobj(get(shakbmalesdrugsdots,'children'),pnl(2,4).select());
copyobj(get(shakbmalesdots,'children'),pnl(2,4).select());

linkaxes([...
    pnl(1,1).select(),...
    pnl(1,2).select(),...
    pnl(1,3).select(),...
    pnl(2,1).select(),...
    pnl(2,2).select(),...
    pnl(2,3).select(),...
],'x')
xlim(pnl(2,3).select(),[-.1 .1])

linkaxes([...
    pnl(1,1).select(),...
    pnl(1,2).select(),...
    pnl(2,1).select(),...
    pnl(2,2).select(),...
],'y')
ylim(pnl(2,2).select(),[-40 -30])

ylim(pnl(1,3).select(),[3.5 6.5])
ylim(pnl(2,3).select(),[3.5 6.5])

linkaxes([pnl(1,4).select() pnl(2,4).select()])
xlim(pnl(2,4).select(),[-.5 1.5])
ylim(pnl(2,4).select(),[0 15])

set(pnl(1,4).select(),'xticklabel',{'ctrl','drug'},'xtick',[0 1],'tag','dots')
set(pnl(2,4).select(),'xticklabel',{'ctrl','drug'},'xtick',[0 1],'tag','dots')

ylabel(pnl(1,1).select(),'mV')
ylabel(pnl(1,2).select(),'mV')
ylabel(pnl(1,3).select(),'V')
xlabel(pnl(1,3).select(),'s')
xlabel(pnl(2,3).select(),'s')
ylabel(pnl(1,4).select(),'Peak (mV)')


fn = fullfile(savedir,['ShakB2StepFig.pdf']);
figure(dots_fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

%% Stats

pnl = panel.recover(dots_fig);

wt_dots = get(pnl(1,4).select(),'children');
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

shkB_dots = get(pnl(2,4).select(),'children');
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

% % ttest
% [H,P,CI] = ttest(wt_ctrl_p,wt_drug_p)       % p = 0.17
% [H,P,CI] = ttest(shkB_ctrl_p,shkB_drug_p)   % p = 0.0015
% 
% 
% % ttest2
% [H,P,CI] = ttest2(wt_ctrl,wt_drug)          % p = 0.1355
% [H,P,CI] = ttest2(shkB_ctrl,shkB_drug)      % p = 0.0428
% [H,P,CI] = ttest2(wt_ctrl,shkB_ctrl)        % p < 1E-4


% anova
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

figure
[p,tbl,stats,terms] = anovan(y,{g1,g2},'model','interaction','varnames',{'geno';'drug'});
multcompare(stats,'ctyp','lsd','dimension',[1 2]);

%% Need to look at the sine responses in these neurons.  Average across cycles to see what the responses look like

