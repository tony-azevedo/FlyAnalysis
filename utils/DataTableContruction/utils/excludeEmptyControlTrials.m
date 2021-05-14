function T = excludeEmptyControlTrials(T)
% helps to set exclude flag on for trials with no data

empty_rows = T(isnan(T.arduino_duration),:);
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(T.Properties.Description);

for r = 1:height(empty_rows)
    trial = load(fullfile(D,sprintf(trialStem,empty_rows(r,:).trial)));
    trial.excluded = 1;
    save(trial.name,'-struct','trial');
    empty_rows(r,:).excluded = 1;
    
    fprintf('Trial excluded: %s\n',trial.name);
end

T(isnan(T.arduino_duration),:) = empty_rows;
save(T.Properties.Description,'T')
