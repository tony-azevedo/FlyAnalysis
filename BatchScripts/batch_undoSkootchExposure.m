% Do the skootching of the data

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

% skootchedFrames = nan(size(1:length(data)));

for tr_idx = trialnumlist
    
    trial = load(sprintf(trialStem,tr_idx));
    fprintf('%s\n',trial.name);
    
    [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,dataFile] = extractRawIdentifiers(trial.name);
    if isfield(trial,'excluded') && trial.excluded
        fprintf('\t ** Bad movie, moving on\n');
        continue
    end
    if ~isfield(trial,'exposure_raw')
        fprintf('\t --Not yet skootched, moving on\n');
        continue
    end
    
    trial.exposure = trial.exposure_raw;
    trial = rmfield(trial,'exposure_raw');
    
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
end
