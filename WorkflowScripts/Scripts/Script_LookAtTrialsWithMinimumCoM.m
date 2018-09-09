%% Script_SetTheMinimumCoM_byHand
% NOTE: This selects the most likely ZeroForce location for the bar for
% each batch of trials.
% Issue: if the bar was lopsided, it may be wider and therefore extend
% further to the left. If CoM goes a lot below the Zero Force point, it may
% suffer from this property

% This needs to be done on batches of trial on their own. Because the bar
% may have moved in between. Just take a look at all of them.

for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    CoM_origin = nan(size(trialnumlist));
    cnt = 0;
    trialblocknum = 0;
    
    figure
    ax = subplot(1,3,[1 2]);
    hold(ax,'on')
    for tr_idx = trialnumlist
        cnt = cnt+1;
        trial = load(sprintf(trialStem,tr_idx));
                
        if isfield(trial,'forceProbeStuff')
            t = makeInTime(trial.params);
            ft = makeFrameTime(trial,t);
            ft_idx = ft<0|ft>ft(find(ft>trial.params.stimDurInSec,1));
            plot(ax,ft(ft_idx),trial.forceProbeStuff.CoM(ft_idx),'tag',num2str(trial.params.trial));
            CoM_origin(cnt) = mean(trial.forceProbeStuff.CoM(ft_idx' & trial.forceProbeStuff.CoM<quantile(trial.forceProbeStuff.CoM(:),0.05)));
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
        
    end

    ax2 = subplot(1,3,3);
    plot(ax2,ones(size(CoM_origin)),CoM_origin,'k+');
    ax2.YLim = ax.YLim; 
    
end