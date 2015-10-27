%% Voltage Steps

cs_names = dir([h.dir '\VoltageStep_Raw_*']);
trial = load(fullfile(h.dir,cs_names(1).name));

h = getShowFuncInputsFromTrial(trial);
    
blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock','steps','step'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock','step'});
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

x = makeInTime(trial.params);
i = -600;
f = 400;

%Create a figure with the number of columns drugs
fig = figure();
set(fig,'color',[1 1 1],'position',[197 204  1240 742],'name',[ac.name '_VoltageSteps']);
pnl = panel(fig);
pnl.margin = [18 18 10 10];
pnl.pack('h',length(blocktrials));
pnl.de.margin = [10 10 10 10];

ylims_voltage = [Inf -Inf];
ylims_current = [Inf -Inf];

steplims = [Inf -Inf];
currlims = [Inf -Inf];
    
for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
    pnl(bt_ind).pack('v',{2/4,1/4,1/4});
    [x,voltage,current] = PF_VoltageStepFam([pnl(bt_ind,1).select() pnl(bt_ind,2).select()],getShowFuncInputsFromTrial(trial),'');

    ylims_voltage(1) = min([ylims_voltage(1),min(min(voltage))]);
    ylims_voltage(2) = max([ylims_voltage(2),max(max(voltage))]);

    win = x>.005&x<.05; % where the max might occur;
    current_win = current(win,:);
    ylims_current(2) = max([ylims_current(2),max(current_win(:))]);
    
    win = (x>.005&x<.05)|(x>trial.params.stimDurInSec+.0003&x<trial.params.stimDurInSec+.01); % where the max might occur;
    current_win = current(win,:);
    ylims_current(1) = min([ylims_current(1),min(current_win(:))]);
    
    tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
    if ~isempty(tg),
        tg = drugmap.(tg);
    else tg = 'ctrl';
    end

    pnl(bt_ind).title(tg);

    PF_VoltageStepIVRelationship([pnl(bt_ind,3).select()],getShowFuncInputsFromTrial(trial),'');
    axis(pnl(bt_ind,3).select(),'tight'); %'ylim',[-100 300],'xlim',[-60 40]);
    xlims = get(pnl(bt_ind,3).select(),'xlim');
    steplims(1) = min([steplims(1) xlims(1)]);
    steplims(2) = max([steplims(2) xlims(2)]);
    ylims = get(pnl(bt_ind,3).select(),'ylim');
    currlims(1) = min([currlims(1) ylims(1)]);
    currlims(2) = max([currlims(2) ylims(2)]);

end
col_pnls = pnl(1).de;
pnls_hs = zeros(length(col_pnls),length(blocktrials));

for r_ind = 1:size(pnls_hs,1);
    for c_ind = 1:size(pnls_hs,2);
        pnls_hs(r_ind,c_ind) = pnl(c_ind,r_ind).select();
    end
end

set(pnls_hs([1,3],:),'ylim',ylims_current,...
    'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
set(pnls_hs([2],:),'ylim',ylims_voltage,...
    'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

ylabel(pnl(1,1).select(),'pA');
ylabel(pnl(1,2).select(),'mV');
xlabel(pnl(1,2).select(),'s');
xlabel(pnl(length(blocktrials),2).select(),regexprep(ac.name,'_','.'));

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,3).select(),'xlim',steplims,'ylim',currlims);
end

% set(pnl(1,1).select(),'tag','currents');
% set(pnl(1,2).select(),'tag','ramp');
% set(pnl(2).select(),'tag','Xsensitive');

if ~isdir(fullfile(savedir,'vSteps'))
    mkdir(fullfile(savedir,'vSteps'))
end

fn = fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps']),'fig');

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,1).select(),'xlim',[-.005 .02]);
end

fn = fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps_onset.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,1).select(),'xlim',trial.params.stimDurInSec+[-.005 .01]);
end

fn = fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps_offset.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

