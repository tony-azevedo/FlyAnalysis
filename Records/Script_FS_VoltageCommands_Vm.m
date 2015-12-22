% Vm resistance

trial = load(ac.trials.Sweep);
h = getShowFuncInputsFromTrial(trial);
cd(h.dir);

trials = findLikeTrials('name',trial.name,'datastruct',h.prtclData);
trials = excludeTrials('trials',trials,'name',trial.name);

x = makeInTime(trial.params);

voltage = trials;
for t_ind = 1:length(trials);
    trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
    switch h.prot
    voltage(t_ind) = mean(trial.voltage(x>0.1));
    
end

Vm = mean(voltage);

Vs_names = dir([h.dir '\VoltageSine_Raw_*']);
VStrial = load(fullfile(h.dir,Vs_names(1).name));
x = makeInTime(VStrial.params);

v_hold = mean(VStrial.voltage(x>VStrial.params.stimDurInSec));

fig = figure;
subplot(1,1,1), hold on
plot(0,Vm,'ob','displayname',ac.name,'tag',ac.genotype)
plot(1,v_hold,'ob','displayname',ac.name,'tag',ac.genotype)
plot([0 1],[Vm,v_hold],'color',[.7 .7 1],'displayname',ac.name,'tag',ac.genotype)

if ~isdir(fullfile(savedir,'Vm'))
    mkdir(fullfile(savedir,'Vm'))
end

fn = fullfile(savedir,'Vm',[ac.name,'_Vm.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'Vm',[ac.name,'_Vm']),'fig');
