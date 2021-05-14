function xtable = excludeColumns(table,excludedFields)
% return table after excluding columns
vns = table.Properties.VariableNames;
exns = true(size(vns));
for vidx = 1:length(vns)
    v = vns{vidx};
    if any(strcmp(excludedFields,v))
        exns(vidx) = false;
    end
end
xtable = table(:,exns);


