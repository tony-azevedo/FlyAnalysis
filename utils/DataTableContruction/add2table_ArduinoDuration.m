function T = add2table_ArduinoDuration(T)

if any(strcmp(T.Properties.VariableNames,'arduino_duration'))
    fprintf('arduino_duration already added\n')
    return
end
% From the table, find trials matching the distances and fill in the
% position column
arduino_duration = nan(size(T.tags));

fprintf(1,'Finding ArduinoDuration:\n');    

Dir = fileparts(T.Properties.Description);
[~,cid] = fileparts(Dir);

trial = load(fullfile(Dir,[T.protocol{1} '_Raw_' cid '_' num2str(T.trial(1)) '.mat']));
time = makeInTime(trial.params);
for tr = 1:length(T.trial)
    %     fprintf('%d ',tr);
    ao = load(fullfile(Dir,[T.protocol{tr} '_Raw_' cid '_' num2str(T.trial(tr)) '.mat']),'arduino_output');
    if isfield(ao,'arduino_output') && any(ao.arduino_output)
        arduino_duration(tr) = time(find(ao.arduino_output,1,'last'));
    elseif isfield(ao,'arduino_output') && ~any(ao.arduino_output)
        %fprintf('\tArduino off - trial %d\n',tr);
        arduino_duration(tr) = 0;
    else
        arduino_duration(tr) = nan;
    end
end

T = addvars(T,arduino_duration);
if ~isempty(T.Properties.Description)
    fprintf('Writing table with arduino_duration flag\n')
    save(T.Properties.Description,'T')
end