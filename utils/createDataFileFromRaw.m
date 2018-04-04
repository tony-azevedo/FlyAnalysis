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

cellID = regexp(filename,'(\d+)_F(\d+)_C(\d+)','match'); cellID = cellID{1};

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
    savedirmat = ls(D)';
    savedirconts = savedirmat(:)';
    
    imaged = zeros(size(rawfiles));
    for f = 1:length(rawfiles)
        trial = load([D rawfiles(f).name]);
        trial = setRawFilePath(trial);

        if isfield(trial.params,'recmode');
            trial.params.mode = trial.params.recmode;
            save(trial.name, '-struct', 'trial');
        end
        imaged(f) = isfield(trial,'imageFile')&&~isempty(trial.imageFile);
        
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
    end
    
    for f = 1:length(rawfiles)
        data(f).tags = tags(f).tags;
    end
    [~,order] = sort(trialnums);
    data = data(order);
    dfns{p} = regexprep(dfn,curprotocol,protocols{p});
    
    % Find all the matched avis, their trial nums, and their size
    pattern_old = [trial.params.protocol,'_Image_(\d+)_' datestr(trial.timestamp,29) '-(\d+)-\d+.avi'];
    matchedavifiles = regexp(savedirconts,pattern_old,'match');
    
    pattern_new = [trial.params.protocol,'_Image_' cellID '_(\d+)_' datestr(trial.timestamp,'yyyymmdd') 'T(\d+).avi'];
    baslermatchedavifiles = regexp(savedirconts,pattern_new,'match');

    unpattern_old = [trial.params.protocol,'_Image_' datestr(trial.timestamp,29) '-(\d+)-\d+.avi'];
    unmatchedavifiles = regexp(savedirconts,unpattern_old,'match');

    if ~isempty(baslermatchedavifiles)
        if length(baslermatchedavifiles)~= sum(imaged)
            % Basler camera created X files, but X-sum raw files have imageFiles
            % Most likely, the trial timed out before the video was saved
            % then a second video was taken just making sure the trials
            % with more videos are referencing the newest
            fprintf('Basler camera created %d files, but %d raw files have imageFiles\nMost likely, the trial timed out before the video was saved\nthen a second video was taken. Just making sure the trials \nwith more videos are referencing the newest\n',length(baslermatchedavifiles),sum(imaged));
            raw_imaged = rawfiles(logical(imaged));
            for f = 1:length(raw_imaged)
                imgf = load([D raw_imaged(f).name],'imageFile'); imgf = imgf.imageFile;
                trnm = load([D raw_imaged(f).name],'params'); trnm = trnm.params.trial;
                pattern_new = [trial.params.protocol,'_Image_' cellID '_' num2str(trnm) '_' datestr(trial.timestamp,'yyyymmdd') 'T'];
                times = regexp(savedirconts,pattern_new,'end');
                if length(times)>1
                    for tms = 1:length(times)
                        times(tms) = str2double(savedirconts(times(tms)+(1:6)));
                    end
                    imgftm = regexp(imgf,pattern_new,'end');
                    imgftm = str2double(imgf(imgftm+(1:6)));
                    if imgftm == max(times)
                        fprintf('\nSeveral images for %s, \nnewest (T%g) is correct referenced in file name\n',...
                            [trial.params.protocol,'_Raw_' cellID '_' num2str(trnm)],...
                            imgftm);
                    else
                        keyboard
                    end
                end
            end

            
        end
    elseif ~isempty(matchedavifiles) || ~isempty(unmatchedavifiles)
        aviFileAssignmentAssessment(trial.name);
    end

    for f = 1:length(rawfiles)

        if isfield(trial,'exposure') && (~isfield(trial,'imageFile') || exist(regexprep(trial.imageFile,'Acquisition','Raw_Data'),'file')~=2)
            % add an exposure time vector to the trial, and adjust images
            % and exposure vector to include only times associated 
            % with images
            
            % This is the case where avi files are being stored, rather
            % than image folders.
            d = dir(fullfile(D,[trial.params.protocol,'_Image_' datestr(trial.timestamp,29) '*.avi']));
            d2 = dir(fullfile(D,[trial.params.protocol,'_Images_' '*.avi']));
            if length(d)
                
                
                
            elseif length(d2)
                
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
    end
    
    save(dfns{p},'data');
    fprintf('\t%s\n',protocols{p});
end
fprintf('Done creating and renaming raw files: %s',D)
toc
varargout = {dfn,dfns};