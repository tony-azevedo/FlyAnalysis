function [T,excluded] = add2table_ExcludeFlag(T)

if any(strcmp(T.Properties.VariableNames,'excluded'))
    excluded = T.excluded;
    fprintf('excluded flag already added\n')
    sflag = 1;
else
    sflag = 0;
end

Dir = fileparts(T.Properties.Description);
[~,cid] = fileparts(Dir);

trial = load(fullfile(Dir,[T.protocol{1} '_Raw_' cid '_' num2str(T.trial(1)) '.mat']));
excluded = false(height(T),1);
for tr = 1:length(T.trial)
    %fprintf('%d ',tr);
    ex = load(fullfile(Dir,[T.protocol{tr} '_Raw_' cid '_' num2str(T.trial(tr)) '.mat']),'excluded');
    if ~isfield(ex,'excluded')
        excluded(tr) = false;
    else
        excluded(tr) = logical(ex.excluded);
    end
end

if sflag
    sflag_ = ~any(T.excluded ~= excluded);
    T.excluded = excluded;
    fprintf('excluded flags have changed\n')
elseif ~sflag
    T = addvars(T,excluded);
end

if ~isempty(T.Properties.Description) || ~sflag || ~sflag_
    fprintf('Writing table with exclude flag\n')
    save(T.Properties.Description,'T')
end
