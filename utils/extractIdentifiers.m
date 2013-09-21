function varargout = extractRawIdentifiers(name)

[tok,remain] = strtok(fliplr(name),'\');

D = fliplr(remain);
tok = fliplr(remain);

varargout = {prot,date,fly,cell,trial,D}