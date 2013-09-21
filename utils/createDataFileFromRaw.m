function varargout = createDataFileFromRaw(dfn,varargin)
% override = 0;
% if nargin
%     override = varargin{1};
% end
% 
% if  ~isempty(dir(dfn)) && ~override
%     return
% end

[filename,remain] = strtok(dfn,'\');
while ~isempty(remain);
[filename,remain] = strtok(remain,'\');
end

D = regexprep(dfn,filename,'');
curprotocol = strtok(filename,'_');

fprintf('Creating data files for %s\n',D);
rawfiles = dir([D '\*_Raw_*.mat']);

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

for p = 1:length(protocols)
    rawfiles = dir([D protocols{p} '*_Raw_*']);
    
    trial = load([D rawfiles(1).name]);
    data = trial.params;
    data = repmat(data,size(rawfiles));
    trialnums = nan(size(rawfiles));
    for f = 1:length(rawfiles)
        trial = load([D rawfiles(f).name]);
        data(f) = trial.params;
        trialnums(f) = trial.params.trial;
    end
    [~,order] = sort(trialnums);
    data = data(order);
    save(regexprep(dfn,curprotocol,protocols{p}),'data');
    fprintf('\t%s\n',protocols{p});
end

varargout = {};