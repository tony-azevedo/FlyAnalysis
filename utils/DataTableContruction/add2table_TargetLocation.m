function [T,target] = add2table_TargetLocation(T)

if any(strcmp(T.Properties.VariableNames,'Target'))
    fprintf('Target flag already added\n')
    sflag = 1;
else
    sflag = 0;
end

Dir = fileparts(T.Properties.Description);
[~,cid] = fileparts(Dir);

trial = load(fullfile(Dir,[T.protocol{1} '_Raw_' cid '_' num2str(T.trial(1)) '.mat']));
target = zeros(height(T),2);
for tr = 1:length(T.trial)
    %fprintf('%d ',tr);
    tl = load(fullfile(Dir,[T.protocol{tr} '_Raw_' cid '_' num2str(T.trial(tr)) '.mat']),'target_location');
    if ~isfield(tl,'target_location')
        target(tr,:) = 0;
    else
        target(tr,:) = tl.target_location;
    end
end

if sflag
    sflag_ = ~any(T.target1 ~= target(:,1)) || ~any(T.target2 ~= target(:,2));
    T.target1 = target(:,1);
    T.target2 = target(:,2);
    fprintf('Target location has changed\n')
elseif ~sflag
    target1 = target(:,1);
    target2 = target1+target(:,2);
    T = addvars(T,target1);
    T = addvars(T,target2);
end

if ~isempty(T.Properties.Description) || ~sflag || ~sflag_
    fprintf('Writing table with target locations\n')
    save(T.Properties.Description,'T')
end
