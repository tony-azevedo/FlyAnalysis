%% Script_ClearProbeStuffIfWrong

close all
% Go through all the sets of trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};

    for tr_idx = trialnumlist(1:end)
        trial = load(sprintf(trialStem,tr_idx));
        try trial = rmfield(trial,'forceProbe_line'); catch, end
        try trial = rmfield(trial,'forceProbe_tangent'); catch, end
%         adjustProbeLineROI(trial);
        fprintf('Clearing bar and tangent in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
    
    delete(br);
end
