function varargout = extractRawIdentifiers(name)
% [protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(name)
%   [mfilename '_' protocol '_' dateID '_' flynum '_' cellnum '_' trialnum]

[remain,D] = strtok(fliplr(name),'\');

D = fliplr(D);
D = regexprep(D,'Acquisition','Raw_Data');
remain = fliplr(remain);

[prot,remain] = strtok(remain,'_');
[d,remain] = strtok(remain,'_Raw_');
[fly,remain] = strtok(remain,'_');
[cell,remain] = strtok(remain,'_');
trial = strtok(strtok(remain,'_'),'.mat');

trialStem = [prot '_Raw_' d '_' fly '_' cell '_%d.mat'];
%trialStem = regexprep(trialStem,'\\','\\\');
%trialStem = regexprep(trialStem,'Anthony Azevedo','Anthony'' Azevedo''');

varargout = {prot,d,fly,cell,trial,D,trialStem};