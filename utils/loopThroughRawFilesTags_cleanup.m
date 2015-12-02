function varargout = loopThroughRawFilesTags_cleanup(D,varargin)
% tags used to be cells of cells, now they should be cells
fprintf('Looping over raw files %s\n',D);
rawfiles = dir([D '\*_Raw_*.mat']);

protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

dfns = protocols;
for p = 1:length(protocols)
    rawfiles = dir([D '\' protocols{p} '*_Raw_*']);
    tagsrep = 0;
    for f = 1:length(rawfiles)
        trial = load([D '\' rawfiles(f).name]);

        if isfield(trial,'tags')
            tags = trial.tags;
            for tag_ind = 1:length(tags)
                if iscell(tags{tag_ind})
                    tags{tag_ind} = tags{tag_ind}{1};
                    tagsrep = tagsrep+1;
                end
            end
            trial.tags = tags;
        end
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end
    fprintf('\t%s - %g tags\n',protocols{p},tagsrep);
end

varargout = {dfns};