function [TP,ProbeMin] = addProbeMinToDataTable(TP,trialStem)

if any(strcmp(TP.Properties.VariableNames,'ProbeMin'))
    fprintf('ProbeMin already added\n')
    ProbeMin = TP.ProbeMin;
    return
end
% From the table, find trials matching the distances and fill in the
% drug columns
ProbeMin = nan(height(TP),1);
for tr = 1:length(TP.trial)
    ex = load(sprintf(trialStem,TP.trial(tr)),'forceProbeStuff');
    if ~isfield(ex,'forceProbeStuff')
        % nan
    else
        ProbeMin(tr) = min(ex.forceProbeStuff.CoM);
    end
end

TP = addvars(TP,ProbeMin);

