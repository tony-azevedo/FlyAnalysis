function varargout = createDataFileFromContRaw(dfn,varargin)
% override = 0;
% if nargin
%     override = varargin{1};
% end
% 
% if  ~isempty(dir(dfn)) && ~override
%     return
% end

%% performance test
% 160706 - 160630_F1_C1: 16.36 seconds - 160630_F2_C1: 3.27 seconds 
%
tic 
dfn = regexprep(dfn,'Acquisition','Raw_Data');

[filename,remain] = strtok(dfn,filesep);
while ~isempty(remain);
[filename,remain] = strtok(remain,filesep);
end

D = regexprep(dfn,filename,'');
dfn = regexprep(dfn,'_Raw','');
dfn = regexprep(dfn,'_\d*.mat','.mat');
curprotocol = strtok(filename,'_');

fprintf('Creating data files for %s\n',D);

rawfiles = dir([D curprotocol '_ContRaw_*']);

fid = fopen([D rawfiles(1).name]);
[data,~,header] = processHeader(fid);
fclose(fid);

% Check the filesnames
strcmp(header,[D rawfiles(1).name])

% change info into a structure
data = repmat(data,size(rawfiles));

trialnums = nan(size(rawfiles));
for f = 1:length(rawfiles)
    fid = fopen([D rawfiles(f).name]);
    [datainst,trial] = processHeader(fid);
    
    % change info into a structure

    data(f) = datainst;
    %[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile,notesfile] = extractRawIdentifiers(name);
    trialnums(f) = trialnumfromheader;
end        
[~,order] = sort(trialnums);
data = data(order);
save(dfn,'data');
fprintf('\t%s\n',protocol);
fprintf('Done creating and renaming raw files: %s',D)
toc
varargout = {dfn};


function varargout = processHeader(fid)
header = fscanf(fid,'%s',[1 1]);

% data fields
%protocol
field = fscanf(fid,'%s',[1 1]);
data.(field) = fscanf(fid,'%s',[1 1]);
%mode
field = fscanf(fid,'%s',[1 1]);
data.(field) = fscanf(fid,'%s',[1 1]);
%gain
field = fscanf(fid,'%s',[1 1]);
data.(field) = fscanf(fid,'%s',[1 1]);
%samprate
field = fscanf(fid,'%s',[1 1]);
data.(field) = fscanf(fid,'%s',[1 1]);

% trial fields
%ai0
% field = fscanf(fid,'%s',[1 1]);
% trial.(field) = fscanf(fid,'%s',[1 1]);
% %ai1
% field = fscanf(fid,'%s',[1 1]);
% trial.(field) = fscanf(fid,'%s',[1 1]);
% %di1
% field = fscanf(fid,'%s',[1 1]);
% trial.(field) = fscanf(fid,'%s',[1 1]);

varargout = {data,trial,header};