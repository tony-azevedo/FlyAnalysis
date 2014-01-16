function genotype = IdentifyUnits(str)

unitsMap = load('learnedUnitsMap');

if unitsMap.forward.isKey(str)
    genotype = unitsMap.forward(str);
    return
else
    keys = unitsMap.backward.keys;
    prntstr = sprintf('Input Units for Data (or enter if absent)\n');
    for k = 1:length(keys)
        prntstr = sprintf('%s%d: %s \n',prntstr,k,keys{k});
    end
    k = input(prntstr);
    if ~isempty(k)
        key = keys{k};
        val = unitsMap.backward(key);
        val{end+1} = str;
    else
        key = input(sprintf('Enter proper Units for ''%s''\n(e.g.  Hz)\n',str),'s');
        val = {str};
    end
    
    unitsMap.backward(key) = val;
    unitsMap.forward(str) = key;
    genotype = key;
    save(unitsMap.name, '-struct', 'unitsMap');
end
