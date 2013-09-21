[prot,d,fly,cellnum,trial,D] = extractRawIdentifiers(name);
cd(D)

fclose('all');
experiment = fileread(ps_name);

a = dir('notes_*');
notes = fileread(fullfile(D,a.name));

[prot,d,fly,cellnum,trial,D] = extractRawIdentifiers(name);

blockInds = regexp(experiment,'.setProtocol(''','end');

rawfiles = dir('*_Raw*');
protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

for b = 1:length(blockInds)
    fin = regexp(experiment(blockInds(b)+1:blockInds(b)+50),''');');
    blockProtocol = experiment(blockInds(b)+1:blockInds(b)+fin(1)-1);
    
    firstBlockTrial