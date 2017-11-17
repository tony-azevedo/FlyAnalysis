% Do the skootching of the data

[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);

for tr_idx = trialnumlist
    
    trial = load(sprintf(trialStem,tr_idx));
    fprintf('%s\n',trial.name);
    
    if isfield(trial,'excluded') && trial.excluded
        fprintf('\t ** Bad movie, moving on\n');
        continue
    end
    if isfield(trial,'exposure_raw')
        fprintf('\t -- Already skootched, moving on\n');
        continue
    end

    if isfield(trial,'forceProbeStuff')
        N = size(trial.forceProbeStuff.forceProbePosition,2);
    else
        N = size(trial.roitraces,1);
    end
    
    exp=postHocExposure(trial,N,'shift',knownSkootch,'use','skootched');
    trial.exposure_raw = trial.exposure;
    trial.exposure = exp.exposure;
    
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
end
