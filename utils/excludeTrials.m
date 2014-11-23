function trials = excludeTrials(varargin)

p = inputParser;
p.addParameter('trials',[],@isnumeric);
p.addParameter('name','',@ischar);
parse(p,varargin{:});

trials = p.Results.trials;
if isempty(trials)
    error('No trials to exclude')
end
name = p.Results.name;
if isempty(name);
    error('Input requires name of a trial')
end

[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(name);
exclude = false(size(trials));
for t_ind = 1:length(trials)
    trial = load(fullfile(D,sprintf(trialStem,trials(t_ind))));
    if isfield(trial,'excluded') && trial.excluded
        fprintf('Trial %g excluded\n',trial.params.trial);
        exclude(trials == trial.params.trial) = true;
    end
end
trials = trials(~exclude);