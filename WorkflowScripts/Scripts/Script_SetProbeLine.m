%% Script_SetProbeLine
trialStem = extractTrialStem(trial.name);

close all
% Go through all the sets of trials
for setidx = 1:length(trials)
    fprintf('\n\t***** Batch %d of %d\n',setidx,length(trials));
    trialnumlist = trials{setidx}; if size(trialnumlist,1)>1, trialnumlist = trialnumlist'; end
    
    br = waitbar(0,sprintf('Batch %d of %d',setidx,length(trials)));
    br.Position =  [1050    251    270    56];
    
    % set probeline for a few test movies
    for tr_idx = trialnumlist(1) 
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(sprintf(trialStem,tr_idx),'_','\\_'));
        
        fprintf('%s\n',trial.name);
        if isfield(trial,'excluded') && trial.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        trial = probeLineROI(trial);
        %trial = probeLineROI_startAtEpi(trial);
    end
    
    % just set the line for the rest of the trials
    temp.forceProbe_line = trial.forceProbe_line;
    temp.forceProbe_tangent = trial.forceProbe_tangent;
    
    % temp.forceProbe_line = getacqpref('quickshowPrefs','forceProbeLine');
    % temp.forceProbe_tangent = getacqpref('quickshowPrefs','forceProbeTangent');

    for tr_idx = trialnumlist(2:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.forceProbe_line = temp.forceProbe_line;
        trial.forceProbe_tangent = temp.forceProbe_tangent;
%         adjustProbeLineROI(trial);
        fprintf('Saving bar and tangent in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
    
    delete(br);
end
