function varargout = createDataFileFromRaw(dfn,varargin)
% override = 0;
% if nargin
%     override = varargin{1};
% end
% 
% if  ~isempty(dir(dfn)) && ~override
%     return
% end
dfn = regexprep(dfn,'Acquisition','Raw_Data');

[filename,remain] = strtok(dfn,'\');
while ~isempty(remain);
[filename,remain] = strtok(remain,'\');
end

D = regexprep(dfn,filename,'');
dfn = regexprep(dfn,'_Raw','');
dfn = regexprep(dfn,'_\d*.mat','.mat');
curprotocol = strtok(filename,'_');

fprintf('Creating data files for %s\n',D);
rawfiles = dir([D '*_Raw_*.mat']);

if ~isempty(dir(regexprep(dfn,'.mat','.h5')))
    raw = load(rawfiles(1).name);
    if ~isfield(raw,'params');
        addH5DataToTrials(regexprep(dfn,'.mat','.h5'))
    end
end

protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

dfns = protocols;
for p = 1:length(protocols)
    rawfiles = dir([D protocols{p} '*_Raw_*']);
    
    trial = load([D rawfiles(1).name]);
    data = trial.params;
    data = repmat(data,size(rawfiles));
    clear tags
    tags.tags = trial.tags;
    tags = repmat(tags,size(rawfiles));
    trialnums = nan(size(rawfiles));
    for f = 1:length(rawfiles)
        trial = load([D rawfiles(f).name]);
        data(f) = trial.params;
        tags(f).tags = trial.tags;
        if isempty( tags(f).tags) && ~ iscell( tags(f).tags)
            tags(f).tags = {};
        end
        trialnums(f) = trial.params.trial;
    end
    for f = 1:length(rawfiles)
        data(f).tags = tags(f).tags;
    end
    [~,order] = sort(trialnums);
    data = data(order);
    dfns{p} = regexprep(dfn,curprotocol,protocols{p});
    save(dfns{p},'data');
    fprintf('\t%s\n',protocols{p});
end

varargout = {dfn,dfns};