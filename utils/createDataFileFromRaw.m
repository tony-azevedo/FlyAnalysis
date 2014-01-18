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
    if isfield(trial.params,'recmode');
        trial.params.mode = trial.params.recmode;
        save(trial.name, '-struct', 'trial');
    end

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
    for f = 1:length(rawfiles)
        trial = load([D rawfiles(f).name]);
        if isfield(trial.params,'recmode');
            trial.params.mode = trial.params.recmode;
            save(trial.name, '-struct', 'trial');
        end

        try data(f) = trial.params;
        catch e
            if ~strcmp(e.identifier,'MATLAB:heterogeneousStrucAssignment');
                error(e)
            end
            tempfn = fieldnames(data(f));
            for name = 1:length(tempfn)
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
        
        if isfield(trial,'exposure')
            % add an exposure time vector to the trial, and adjust images
            % and exposure vector to include only times associated 
            % with images
            t = makeInTime(trial.params);
            trial.exposure_time = t(trial.exposure);
            
            imdir = regexprep(regexprep(regexprep(trial.name,'Raw','Images'),'.mat',''),'Acquisition','Raw_Data');
            fprintf('%s\n',imdir);
            d = ls(fullfile(imdir,'*_Image_*'));
            numImages = size(d,1);
            trial.exposure(cumsum(trial.exposure)>numImages) = 0;
            trial.exposure_time = trial.exposure_time(1:min(numImages,length(trial.exposure_time)));
            if numImages > length(trial.exposure_time)
                mkdir(fullfile(imdir,'extras'))
                for im_ind = numImages - diff([length(trial.exposure_time),numImages])+1:numImages
                    imfilename = constructFilnameFromExposureNum(trial,im_ind);
                    if ~isempty(imfilename)
                        movefile(imfilename,fullfile(imdir,'extras'))
                    end
                end
            end
            d = ls(fullfile(imdir,'*_Image_*'));
            numImages = size(d,1);
            if numImages > length(trial.exposure_time)
                error('Problem moving files into %s',fullfile(imdir,'extras'));
            end
            save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
        end
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