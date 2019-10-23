function [T,drugs] = addDrugsToDataTable(T)
drugs = {'caffeine';'mla';'atropine';'ttx';'5ht';'wash_out'};

if any(strcmp(T.Properties.VariableNames,'Drugs'))
    [~,drugidx] = intersect(T.Properties.VariableNames,drugs);
    drugChecks = T(:,drugidx);
    drugs = drugs(any(drugChecks{:,:},1));
    fprintf('Drugs already added\n')
    return
end
% From the table, find trials matching the distances and fill in the
% drug columns

strprfunc = @(c)regexprep(c,{';','\s','^_','_$','\.'},{'','_','','','_'});
Drugs = cell(height(T),1);
drugChecks = false(height(T),length(drugs));
for tr = 1:length(T.tags)
    if isempty(T.tags{tr})
        % if the trial is not tagged
        continue
    end
    tags = T.tags{tr};
    if isempty(tags{1})
        % if the trial was tagged, and it was removed
        continue
    end
    for t = 1:length(tags)
        % assume tag might include concentration
        if contains(strprfunc(tags{t}),drugs,'IgnoreCase',1)
            % some where there is a tag
            for drug = drugs'
                if contains(strprfunc(tags{t}),drug,'IgnoreCase',1)
                    drugChecks(tr,strcmp(drug,drugs)) = true;
                end
            end
        end
    end
    Drugs{tr} = drugs(drugChecks(tr,:));
end
caffeine = drugChecks(:,1);
mla = drugChecks(:,2);
atropine = drugChecks(:,3);
ttx = drugChecks(:,4);
serotonin  = drugChecks(:,5);
wash_out  = drugChecks(:,6);
caffeine = drugChecks(:,1);
control  = ~any(drugChecks,2);

T = addvars(T,Drugs,control,caffeine,mla,atropine,ttx,serotonin,wash_out);
drugs = drugs(any(drugChecks,1));
drugs = regexprep(drugs,'5ht','serotonin');

if ~isempty(T.Properties.Description)
    save(T.Properties.Description,'T')
end