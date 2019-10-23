function T = addProbePositionToDataTable(T,positions)

if any(strcmp(T.Properties.VariableNames,'ProbePosition'))
    fprintf('ProbePosition already added\n')
    return
end
% From the table, find trials matching the distances and fill in the
% position column
ProbePosition = zeros(size(T.tags));
if length(positions) == 1
    T.ProbePosition = ProbePosition;
    return
end

fprintf(1,'\tFinding tagged positions: [');
fprintf(1,'%d\t',positions);
fprintf(1,']\n');
    
for tr = 1:length(T.tags)
    if isempty(T.tags{tr})
        % if the trial is not tagged, assume it's at 0 and move on
        continue
    end
    tags = T.tags{tr};
    if isempty(tags{1})
        % if the trial was tagged, and it was removed
        continue
    end
    for t = 1:length(tags)
        if sum(positions == str2double(tags{t}))==1
            if ProbePosition(tr)~=0 && str2double(tags{t})~=0
                fprintf(1,'Two or more tags for trial %d, cell %s, match a position\n',tr,T.Description);
            end
            ProbePosition(tr) = positions(positions == str2double(tags{t}));
            
        else
            % If a step trial has another tag, like MLA, skip it, has no
            % position
            %fprintf('\t\t\tNo positions. Tagged as: %s\n',tags{t})
            ProbePosition(tr) = nan;
            break
        end
    end
end

T = addvars(T,ProbePosition);
if ~isempty(T.Properties.Description)
    save(T.Properties.Description,'T')
end