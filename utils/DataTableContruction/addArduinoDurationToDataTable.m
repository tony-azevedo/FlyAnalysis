function T = addArduinoDurationToDataTable(T)

if any(strcmp(T.Properties.VariableNames,'ArduinoDuration'))
    fprintf('ArduinoDuration already added\n')
    return
end
% From the table, find trials matching the distances and fill in the
% position column
ArduinoDuration = nan(size(T.tags));

fprintf(1,'\tFinding ArduinoDuration:\n');    

Dir = fileparts(T.Properties.Description);
[~,cid] = fileparts(Dir);

trial = load(fullfile(Dir,[T.protocol{1} '_Raw_' cid '_' num2str(T.trial(1)) '.mat']));
time = makeInTime(trial.params);
for tr = 1:length(T.trial)
    ao = load(fullfile(Dir,[T.protocol{tr} '_Raw_' cid '_' num2str(T.trial(tr)) '.mat']),'arduino_output');
    if isfield(ao,'arduino_output')
        ArduinoDuration(tr) = time(find(ao.arduino_output,1,'last'));
    else
        ArduinoDuration(tr) = nan;
    end
end

T = addvars(T,ArduinoDuration);
if ~isempty(T.Properties.Description)
    save(T.Properties.Description,'T')
end