%% Voltage Steps
close all
%Create a figure with 2X2 panels
fig = figure();
set(fig,'color',[1 1 1],'position',[197 204  1240 742],'name',['VoltageSteps_paracomp']);
pnl = panel(fig);
pnl.margin = [18 18 10 10];
pnl.pack(2,2);
pnl.de.margin = [16 16 16 16];

pnl_hs = [...
    pnl(1,1).select() pnl(1,2).select()
    pnl(2,1).select() pnl(2,2).select()
    ];
pnl(1,1).title(genotypes{1,1}); set(pnl_hs(1,1),'tag',genotypes{1,1})
pnl(1,2).title(genotypes{1,2}); set(pnl_hs(1,2),'tag',genotypes{1,2})
pnl(2,1).title(genotypes{2,1}); set(pnl_hs(2,1),'tag',genotypes{2,1})
pnl(2,2).title(genotypes{2,2}); set(pnl_hs(2,2),'tag',genotypes{2,2})

%Create a figure for IvsV dots
fig_IvsV = figure();
set(fig_IvsV,'color',[1 1 1],'position',[1123 300 791 695],'name',['IvsV_paracomp']);
pnl_IvsV = panel(fig_IvsV);
pnl_IvsV.margin = [18 18 10 18];
pnl_IvsV.pack(2,2);
pnl_IvsV.de.margin = [16 16 16 16];

pnlIvsV_hs = [...
    pnl_IvsV(1,1).select() pnl_IvsV(1,2).select()
    pnl_IvsV(2,1).select() pnl_IvsV(2,2).select()
    ];
pnl_IvsV(1,1).title(genotypes{1,1}); set(pnlIvsV_hs(1,1),'tag',genotypes{1,1})
pnl_IvsV(1,2).title(genotypes{1,2}); set(pnlIvsV_hs(1,2),'tag',genotypes{1,2})
pnl_IvsV(2,1).title(genotypes{2,1}); set(pnlIvsV_hs(2,1),'tag',genotypes{2,1})
pnl_IvsV(2,2).title(genotypes{2,2}); set(pnlIvsV_hs(2,2),'tag',genotypes{2,2})

if ~isdir(fullfile(savedir,'vSteps'))
    mkdir(fullfile(savedir,'vSteps'))
end

%%
para_cell = analysis_cell;
genotype_cells = {para_cell,control_cell};

for c_ind = 1:length(genotype_cells)
    a_cell = genotype_cells{c_ind};
    
for ac_ind = 1:length(a_cell)
ac = a_cell(ac_ind);
yyddmm = ac.name(1:6);
disp(ac.name);
trial = load([fullfile('C:\Users\Anthony Azevedo\Raw_Data\',yyddmm,ac.name) '\VoltageStep_Raw_' ac.name '_10.mat']);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock','steps','step'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock','step'});
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end
disp(blocktrials)


ylims_voltage = [Inf -Inf];
ylims_current = [Inf -Inf];

steplims = [Inf -Inf];
currlims = [Inf -Inf];

stepfig = figure();
set(stepfig,'color',[1 1 1],'position',[215   178   546   817],'name',[ac.name '_VoltageSteps']);
pnl_vs = panel(stepfig);
pnl_vs.margin = [18 18 10 10];
pnl_vs.pack('v',{1/2 1/6 2/6});
pnl_vs.de.margin = [10 10 10 10];

[x,voltage,current] = PF_VoltageStepFam([pnl_vs(1).select() pnl_vs(2).select()],getShowFuncInputsFromTrial(trial),'');
set([pnl_vs(1).select() pnl_vs(2).select()],'xlim',[-0.02 0.12])
set(pnl_vs(1).select(),'ylim',[-200 310])

from_l = findobj(pnl_vs(1).select(),'type','line','tag',num2str(-60));
to_ax = pnl_hs(ismember(genotypes,ac.genotype));
l = copyobj(from_l,to_ax);
set(l,'tag',ac.name)

PF_VoltageStepIVRelationship(pnl_vs(3).select(),getShowFuncInputsFromTrial(trial),'');


from_ax = pnl_vs(3).select();
to_ax = pnlIvsV_hs(ismember(genotypes,ac.genotype));
ls = copyobj(findobj(from_ax,'type','line'),to_ax);
set(ls,'tag',ac.name)

fn = fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps.pdf']);
figure(stepfig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(stepfig,'paperpositionMode','auto');
saveas(stepfig,fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps']),'fig');

close(stepfig)
end

end

%%
linkaxes(pnl_hs(:))
set(pnl_hs(:),'xlim',[0.095 0.115],'ylim',[-800 100])
set(findobj(pnl_hs(:,1),'type','line'),'color',[0 0 1]);
set(findobj(pnl_hs(:,2),'type','line'),'color',[1 0 0]);

pnl(2,1).ylabel('pA')
pnl(1,1).ylabel('pA')
pnl(2,1).xlabel('s')
pnl(2,2).xlabel('s')



linkaxes(pnlIvsV_hs(:))
%set(pnlIvsV_hs(:),'xlim',[-60 20])
fig_IvsV = figure();
delete(findobj(pnlIvsV_hs(:),'color', [.75 .75 .75]))
set(findobj(pnlIvsV_hs(:,1),'type','line'),'color',[0 0 1]);
set(findobj(pnlIvsV_hs(:,2),'type','line'),'color',[1 0 0]);
%pnl_IvsV.title('Current (pA) vs Holding Command (mV)')
pnl_IvsV(2,1).ylabel('pA')
pnl_IvsV(1,1).ylabel('pA')
pnl_IvsV(2,1).xlabel('mV')
pnl_IvsV(2,2).xlabel('mV')



%%
fn = fullfile(savedir,'VoltageSteps_paracomp.pdf');
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'VoltageSteps_paracomp'),'fig');

fn = fullfile(savedir,'IvsV_paracomp.pdf');
figure(fig_IvsV)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig_IvsV,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'IvsV_paracomp'),'fig');
