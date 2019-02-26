function [TP,drugs] = addDrugsToDataTable(TP)

if any(strcmp(TP.Properties.VariableNames,'Drugs'))
    fprintf('Drugs already added\n')
end
% From the table, find trials matching the distances and fill in the
% drug columns
drugs = {'caffeine';'mla';'atropine';'ttx';'5ht'};
strprfunc = @(c)regexprep(c,{';','\s','^_','_$','\.'},{'','_','','','_'});
Drugs = cell(height(TP),1);
drugChecks = false(height(TP),length(Drugs));
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

TP = addvars(TP,Drugs,caffeine,mla,atropine,ttx,serotonin);
drugs = drugs(any(drugChecks,1));
