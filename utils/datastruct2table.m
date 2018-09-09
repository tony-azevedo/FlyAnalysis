function T = datastruct2table(data)

sz = [length(data) length(fieldnames(data(1)))];
tempcell = cell(sz);
T = cell2table(tempcell);

fldnames = fieldnames(data(1));
T.Properties.VariableNames = fldnames;

datatypes = cell(1,length(fldnames));
for c_idx = 1:length(fldnames)
    datatypes{c_idx} = class(data(1).(fldnames{c_idx}));
end
T.

for r_idx = 1:length(data)
    for c_idx = 1:length(fldnames)
        T{r_idx,c_idx} = data(r_idx).(fldnames{c_idx});
    end
end

