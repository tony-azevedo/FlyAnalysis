function [T,HasProbe,HasTrackedLeg] = addTrackingFlagsToDataTable(T,trialStem)

if any(strcmp(T.Properties.VariableNames,'HasProbe'))
    fprintf('HasProbe already added\n')
    HasProbe = T.HasProbe;
    HasTrackedLeg = T.HasTrackedLeg;
    return
end
% From the table, find trials matching the distances and fill in the
% drug columns
HasProbe = false(height(T),1);
HasTrackedLeg = false(height(T),1);
for tr = 1:length(T.trial)
    trial = load(sprintf(trialStem,T.trial(tr)));
    if ~isfield(trial,'forceProbeStuff')
        % nan
    else
        HasProbe(tr) = true;
    end
    if ~isfield(trial,'legPositions')
        % nan
    else
        HasTrackedLeg(tr) = true;
    end
end

T = addvars(T,HasProbe,HasTrackedLeg);

if ~isempty(T.Properties.Description)
    save(T.Properties.Description,'T')
end
