function [T,Excluded] = addExcludeFlagToDataTable(T,trialStem)

if any(strcmp(T.Properties.VariableNames,'Excluded'))
    Excluded = T.Excluded;
    fprintf('Excluded flag already added\n')
    sflag = 1;
    %     return
else
    sflag = 0;
end

% From the table, find excluded trials
Excluded = false(height(T),1);
for tr = 1:length(T.trial)
    %fprintf('%d ',tr);
    ex = load(sprintf(trialStem,T.trial(tr)),'excluded');
    if ~isfield(ex,'excluded')
        Excluded(tr) = false;
    else
        Excluded(tr) = logical(ex.excluded);
    end
end

if sflag
    sflag = any(T.Excluded ~= Excluded);
    T.Excluded = Excluded;
elseif ~sflag
    T = addvars(T,Excluded);
end

if ~isempty(T.Properties.Description) || sflag
    save(T.Properties.Description,'T')
end
