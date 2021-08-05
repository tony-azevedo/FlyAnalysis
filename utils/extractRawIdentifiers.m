function varargout = extractRawIdentifiers(name)
% [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,tfile,notesfile] = extractRawIdentifiers(name)
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
trial = strtok(strtok(remain,'_'),'.mat');

trialStem = [prot '_Raw_' d '_' fly '_' cell '_%d.mat'];
%trialStem = regexprep(trialStem,'\\','\\\');
%trialStem = regexprep(trialStem,'Anthony Azevedo','Anthony'' Azevedo''');

ind_ = regexp(name,'_');
indDot = regexp(name,'\.');
tfile = name(~(1:length(name) >= ind_(end) & 1:length(name) < indDot(1)));
tfile = regexprep(tfile,{'_Raw','.mat'},{'','_Table.mat'});
if ~exist(tfile,'file')
    error('No data table: %s\n',tfile)
end

notesfile = fullfile(D,['notes_' d '_' fly '_' cell '.txt']);
% notesfile = regexprep(notesfile,'Acquisition','Raw_Data');

varargout = {prot,d,fly,cell,trial,D,trialStem,tfile,notesfile};

