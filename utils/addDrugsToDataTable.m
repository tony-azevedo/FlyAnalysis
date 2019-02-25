function TP = addDrugsToDataTable(TP,positions)

if any(strcmp(TP.Properties.VariableNames,'ProbePosition'))
    fprintf('ProbePosition already added\n')
end
% From the table, find trials matching the distances and fill in the
% position column
drugs = {'caffeine','MLA','atropine','TTX','5HT'};
drugtags = tags;
for tr = 1:length(TP.tags)
    if isempty(TP.tags{tr})
        % if the trial is not tagged
        continue
    end
    tags = TP.tags{tr};
    if isempty(tags{1})
        % if the trial was tagged, and it was removed
        continue
    end
    for t = 1:length(tags)
        % assume tag might include concentration
        if contains(tags{t},drugs,'IgnoreCase',1)
            % some where there is a tag
            if any(contains(drugs,tags{t},'IgnoreCase',1))
                drug = drugs{contains(drugs,tags{t},'IgnoreCase',1)};
            else 
                fprintf()
            end
        else
            % If a step trial has another tag, like MLA, skip it, has no
            % position
            fprintf('\t\t\tNo positions. Tagged as: %s\n',tags{t})
            position(tr) = nan;
            break
        end
    end
end

TP.Drugs = drugtags;

%%
tags = {'weird','ttx'};
drugs = {'caffeine','MLA','atropine','TTX','5HT'};
for t = 1:length(tags)
    if contains(tags{t},drugs,'IgnoreCase',1)
        fprintf(1,tags{t})
    end
end