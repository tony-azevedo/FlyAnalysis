function varargout = createDataFileFromRaw(dfn,varargin)
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

dfnparts = split(dfn,filesep);

D = fullfile(dfnparts{1:end-1});
dfn = regexprep(dfn,'_Raw','');
dfn = regexprep(dfn,'_\d*.mat','.mat');
curprotocol = strtok(dfnparts{end},'_');

cellID = dfnparts{end-1}; % regexp(filename,'(\d+)_F(\d+)_C(\d+)','match'); cellID = cellID{1};

fprintf('Creating data files for %s\n',D);
rawfiles = dir(fullfile(D, '*_Raw_*.mat'));

% if ~isempty(dir(regexprep(dfn,'.mat','.h5')))
%     raw = load(rawfiles(1).name);
%     if ~isfield(raw,'params')
%         addH5DataToTrials(regexprep(dfn,'.mat','.h5'))
%     end
% end

select_protocols = 'all';
if nargin>1
    select_protocols = varargin{1};
end
switch select_protocols
    case 'all'
        protocols = cell(length(rawfiles),1);
        for f = 1:length(rawfiles)
            protocols{f} = strtok(rawfiles(f).name,'_');
        end
        protocols = unique(protocols);

    case 'one'
        protocols = {curprotocol};
end

dfns = protocols;
for p = 1:length(protocols)
    rawfiles = dir(fullfile(D, [protocols{p} '_Raw_*.mat']));
    
    trial = load(fullfile(D, rawfiles(1).name));
%     n = trial.name;
%     trial = setRawFilePath(trial);

%     if isfield(trial.params,'recmode')
%         trial.params.mode = trial.params.recmode;
%         save(trial.name, '-struct', 'trial');
%     end

    data = trial.params;
    data = repmat(data,size(rawfiles));
    clear tags
    if isfield(trial,'tags')
        tags.tags = trial.tags;
    else
        tags.tags = {};
    end
    tags = repmat(tags,size(rawfiles));
    
    trialnums = nan(size(rawfiles));
    
    imaged = zeros(size(rawfiles));
    for f = 1:length(rawfiles)
        trial = load(fullfile(D,rawfiles(f).name));
        %         trial = setRawFilePath(trial);
        
        if ~isfield(trial,'excluded')
            trial.excluded = 0;
            save(trial.name, '-struct', 'trial');
        end

        if isfield(trial.params,'recmode')
            trial.params.mode = trial.params.recmode;
            save(trial.name, '-struct', 'trial');
        end
        imaged(f) = isfield(trial,'imageFile')&&~isempty(trial.imageFile);
        
        try data(f) = trial.params;
        catch e
            if ~strcmp(e.identifier,'MATLAB:heterogeneousStrucAssignment')
                error(e)
            end
            tempfn = fieldnames(data(f));
            for name = 1:length(tempfn)
                if strcmp(tempfn{name},'combinedTrialBlock')
                    
                    trial.params.(tempfn{name}) = trial.params.trialBlock;
                end
                if strcmp(tempfn{name},'mode_1')
                    
                    trial.params.(tempfn{name}) = trial.params.trialBlock;
                end
                
                data(f).(tempfn{name}) = trial.params.(tempfn{name});
            end
        end
        if isfield(trial,'tags')
            tags(f).tags = trial.tags;
        end
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
fprintf('Done creating and renaming raw files: %s',D)
toc
varargout = {dfn,dfns};