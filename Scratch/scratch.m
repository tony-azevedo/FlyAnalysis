a = dir('CurrentStepControl*')

for f = 1:length(a)
    trial = load(a(f).name);
    trial.params.protocol = 'CurrentStepControl';
    trial.name = regexprep(trial.name,'CurrentStep_Control','CurrentStepControl');
    save(a(f).name,'-struct','trial');
end

%%

