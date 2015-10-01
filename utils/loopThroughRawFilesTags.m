function varargout = loopThroughRawFilesTags(dfn,oldtag,newtag,varargin)
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

fprintf('Looping over raw files %s\n',D);
rawfiles = dir([D '*_Raw_*.mat']);

protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

dfns = protocols;
for p = 1:length(protocols)
    rawfiles = dir([D protocols{p} '*_Raw_*']);
    tagsrep = 0;
    for f = 1:length(rawfiles)
        trial = load([D rawfiles(f).name]);

        if isfield(trial,'tags')
            tags = trial.tags;
            for tag_ind = 1:length(tags)
                if strcmp(tags{tag_ind},oldtag)
                    tags{tag_ind} = newtag;
                    tagsrep = tagsrep+1;
                end
            end
            trial.tags = tags;
        end
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end
    fprintf('\t%s - %g tags\n',protocols{p},tagsrep);
end

varargout = {dfn,dfns};