%% Voltage Step Subtractions 

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
set(fig,'color',[1 1 1],'position',[197 9  1410 988],'name',[ac.name '_VoltageSteps']);
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
    pnl(bt_ind).pack('v',{2/5,1/5,2/5});
    
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
    
    if bt_ind == 1
        current_0 = current;
        for c_ind = 1:size(current_0,2);
            current_0(:,c_ind) = smooth(current_0(:,c_ind),5);
        end
    else
        current_1 = current;
        for c_ind = 1:size(current_1,2);
            current_1(:,c_ind) = smooth(current_1(:,c_ind),5);
        end

        current_diff = current_0-current_1;
        for v_ind = 1:size(current_diff,2)
            line(x,current_diff(:,v_ind),...
                'parent',pnl(bt_ind,3).select(),...
                'color',[0 1 0] + [ 0 -1 1]*(v_ind-1)/max([size(current_diff,2)-1,1]));
        end
        xlim(pnl(bt_ind,3).select(),[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
        current_0 = current_1;
    end
    
    pnl(bt_ind).title(tg);
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
ylabel(pnl(1,3).select(),'pA');
xlabel(pnl(1,2).select(),'s');
xlabel(pnl(length(blocktrials),2).select(),regexprep(ac.name,'_','.'));

if ~isdir(fullfile(savedir,'vSteps_sbtrct'))
    mkdir(fullfile(savedir,'vSteps_sbtrct'))
end

fn = fullfile(savedir,'vSteps_sbtrct',[ac.name, '_VoltageSubtraction.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'vSteps_sbtrct',[ac.name, '_VoltageSubtraction']),'fig');

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,1).select(),'xlim',[-.005 .02]);
    set(pnl(bt_ind,3).select(),'xlim',[-.005 .02]);
end

fn = fullfile(savedir,'vSteps_sbtrct',[ac.name, '_VoltageSubtraction_onset.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,1).select(),'xlim',trial.params.stimDurInSec+[-.005 .01]);
    set(pnl(bt_ind,3).select(),'xlim',trial.params.stimDurInSec+[-.005 .01]);
end

fn = fullfile(savedir,'vSteps_sbtrct',[ac.name, '_VoltageSubtraction_offset.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
