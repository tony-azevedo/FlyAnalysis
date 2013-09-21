function varargout = extractRawIdentifiers(name)
% [prot,d,fly,cell,trial,D] = extractRawIdentifiers(name)
%   [mfilename '_' prot '_' d '_' fly '_' cell '_' trial]

[remain,D] = strtok(fliplr(name),'\');

D = fliplr(D);
D = regexprep(D,'Acquisition','Raw_Data');
remain = fliplr(remain);

[prot,remain] = strtok(remain,'_');
[d,remain] = strtok(remain,'_Raw_');
[fly,remain] = strtok(remain,'_');
[cell,remain] = strtok(remain,'_');
trial = strtok(strtok(remain,'_'),'.mat');

varargout = {prot,d,fly,cell,trial,D};