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
    rawfiles = dir([D protocols{p} '_Raw_*']);
    
    trial = load([D rawfiles(1).name]);
    n = trial.name;
    trial = setRawFilePath(trial);

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
        trial = setRawFilePath(trial);

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
                if strcmp(tempfn{name},'combinedTrialBlock')
                    
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
        
        if isfield(trial,'exposure')
            % add an exposure time vector to the trial, and adjust images
            % and exposure vector to include only times associated 
            % with images
            imdir = regexprep(trial.name,{'_Raw_','.mat'},{'_Images_',''});
            fprintf('%s\n',imdir);

            d = dir(fullfile(imdir,'*_Image_*'));
            numImages = length(d);
            
            t = makeInTime(trial.params);
            
            if numImages>0 && ~sum(trial.exposure)
                % fucked up, no exposure input, but images were saved
                [trial.exposure_time,trial.exposure] = exposureTimeFromImages(trial,imdir);
            else
                trial.exposure_time = t(trial.exposure);
            end

            % trial.exposure(cumsum(trial.exposure)>numImages) = 0;
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
            d = dir(fullfile(imdir,'*_Image_*'));
            numImages = length(d);
            if numImages > length(trial.exposure_time)
                error('Problem moving files into %s',fullfile(imdir,'extras'));
            end
            % save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
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
fprintf('Done creating and renaming raw files: %s',D)
toc
varargout = {dfn,dfns};