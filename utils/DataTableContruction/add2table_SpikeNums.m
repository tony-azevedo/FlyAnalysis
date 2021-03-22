function T = addSpikeNumsToDataTable(T,trialStem)

if any(strcmp(T.Properties.VariableNames,'spikenums'))
    fprintf('spikenums already added\n')
    return
end

% add the spike counts to the trials in the table
spikenums = nan(size(T.trial));
for tr = 1:length(T.trial)
    excluded = load(sprintf(trialStem,T.trial(tr)),'-mat','excluded');
    if isfield(excluded,'excluded') && excluded.excluded
        continue
    end
    
    try spikes = load(sprintf(trialStem,T.trial(tr)),'-mat','spikes'); spikes = spikes.spikes;
    catch e
        if strcmp(e.identifier,'MATLAB:undefinedVarOrClass')
            disp('ugg')
            continue
        end
    end
    if isempty(spikes)
        spikenums(tr) = 0;
        continue
    else 
        spikenums(tr) = length(spikes);
    end
end

T = addvars(T,spikenums);
if ~isempty(T.Properties.Description)
    save(T.Properties.Description,'T')
end