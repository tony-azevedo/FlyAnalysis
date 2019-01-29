function varargout = extractTrialStem(name)
% [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile,notesfile] = extractRawIdentifiers(name)
%   [mfilename '_' protocol '_' dateID '_' flynum '_' cellnum '_' trialnum]

if ~contains(name,'.mat')
    name = [name '.mat'];
end
[remain,D] = strtok(fliplr(name),filesep);

D = fliplr(D);
% D = regexprep(D,'Acquisition','Raw_Data');
remain = fliplr(remain);

[prot,remain] = strtok(remain,'_');
[d,remain] = strtok(remain,'_Raw_');
[fly,remain] = strtok(remain,'_');
[cell,remain] = strtok(remain,'_');

trialStem = [prot '_Raw_' d '_' fly '_' cell '_%d.mat'];

varargout = {trialStem};

