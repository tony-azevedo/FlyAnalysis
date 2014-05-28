function genotype = IdentifyGenotype(str)

genotypeMap = load('learnedGenotypeMap');

if genotypeMap.forward.isKey(str)
    genotype = genotypeMap.forward(str);
    return
else
    keys = genotypeMap.backward.keys;
    prntstr = sprintf('Genotype: %s\nInput Number for Genotype (or enter if absent)\n',str);
    for k = 1:length(keys)
        prntstr = sprintf('%s%d: %s \n',prntstr,k,keys{k});
    end
    k = input(prntstr);
    if ~isempty(k)
        key = keys{k};
        val = genotypeMap.backward(key);
        val{end+1} = str;
    else
        key = input(sprintf('Enter proper genotype for ''%s''\n(e.g.  GH86-Gal4/GH86-Gal4;pJFRC7/pJFRC7;;)\n',str),'s');
        val = {str};
    end
    
    genotypeMap.backward(key) = val;
    genotypeMap.forward(str) = key;
    genotype = key;
    save(genotypeMap.name, '-struct', 'genotypeMap');
end
