experiment = fileread(ps_name);

[prot,d,fly,cell,trial,D] = extractRawIdentifiers(name);

cd(D)


blockInds = regexp(protocol