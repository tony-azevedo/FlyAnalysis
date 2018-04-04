%% Batch script for tracking the probe 

close all

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

for tr_idx = trialnumlist 
    trial = load(sprintf(trialStem,tr_idx));

    waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));

    if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
        fprintf('%s\n',trial.name);
        probeTrackROI;        
    elseif isfield(trial,'forceProbeStuff')
        fprintf('%s\n',trial.name);
        fprintf('\t*Has profile: passing over trial for now\n')
    else
        fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
        continue
    end        
end

delete(br);

