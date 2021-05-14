function ntable = getDoubleColumns(table)
% return table with only columns with doubles
dbls = true(1,width(table));
for cidx = 1:width(table)
    if ~isnumeric(table{1,cidx}) || length(table{1,cidx})>1 
        dbls(cidx) = false;
    end
end
ntable = table(:,dbls);
