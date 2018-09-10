function TP = addProbePositionToDataTable(TP,positions)

if any(strcmp(TP.Properties.VariableNames,'ProbePosition'))
    fprintf('ProbePosition already added\n')
end
% From the table, find trials matching the distances and fill in the
% position column
position = zeros(size(TP.tags));
for tr = 1:length(TP.tags)
    if isempty(TP.tags{tr})
        % if the trial is not tagged, assume it's at 0 and move on
        continue
    end
    tags = TP.tags{tr};
    if isempty(tags{1})
        % if the trial was tagged, and it was removed
        continue
    end
    for t = 1:length(tags)
        if sum(positions == str2double(tags{t}))==1
            if position(tr)~=0 && str2double(tags{t})~=0
                fprintf(1,'Two or more tags for trial %d, cell %s, match a position\n',tr,TP.Description);
            end
            position(tr) = positions(positions == str2double(tags{t}));
            
        else
            % If a step trial has another tag, like MLA, skip it, has no
            % position
            position(tr) = nan;
            break
        end
    end
end

TP.ProbePosition = position;