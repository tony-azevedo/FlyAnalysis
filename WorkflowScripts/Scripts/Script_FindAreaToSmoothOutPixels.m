%% Script_SetProbeLine

for set = 1:Nsets
    trialnumlist = trials{set};
    
    for tr_idx = trialnumlist(1:3)
        trial = load(sprintf(trialStem,tr_idx));
        
        if (~isfield(trial,'excluded') || ~trial.excluded) 
            tic
            fprintf('%s\n',trial.name);
            trial = smoothOutBrightPixels(trial);
            
            toc
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end
    
    % just set the line for the rest of the trials
    temp.ROI = getacqpref('quickshowPrefs','brightSpots2Smooth');

    for tr_idx = trialnumlist(4:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.brightSpots2Smooth = temp.ROI;
        fprintf('Saving bright spots to smooth in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
end