%% Script_SetTheMinimumCoM_byHand
% NOTE: This selects the most likely ZeroForce location for the bar for
% each batch of trials.
% Issue: if the bar was lopsided, it may be wider and therefore extend
% further to the left. If CoM goes a lot below the Zero Force point, it may
% suffer from this property

% This needs to be done on batches of trial on their own. Because the bar
% may have moved in between. Just take a look at all of them.

for tr_idx = trialnumlist_specific
    trial = load(sprintf(trialStem,tr_idx));
    if isfield(trial,'forceProbeStuff')
        fprintf('Setting ZeroForce for trial %d to %.2f\n',tr_idx,ZeroForce);
        trial.forceProbeStuff.ZeroForce = ZeroForce;
        save(trial.name,'-struct','trial')
    else
        fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
        continue
    end
    
end