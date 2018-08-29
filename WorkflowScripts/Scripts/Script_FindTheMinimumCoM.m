%% Script_FindTheMinimumCoM
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
    
%     close all
    
    br = waitbar(0,'Batch');
    br.Position =  [1050    251    270    56];
    
    CoM_origin = nan(size(trialnumlist));
    cnt = 0;
    trialblocknum = 0;
    
    figure
    ax = subplot(1,3,[1 2]);
    hold(ax,'on')
    for tr_idx = trialnumlist
        cnt = cnt+1;
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        if isfield(trial,'forceProbeStuff')
            t = makeInTime(trial.params);
            ft = makeFrameTime(trial,t);
            ft_idx = ft<0|ft>ft(find(ft>trial.params.stimDurInSec,1));
            plot(ax,ft(ft_idx)
            CoM_origin(cnt) = mean(trial.forceProbeStuff.CoM(ft_idx' & trial.forceProbeStuff.CoM<quantile(trial.forceProbeStuff.CoM(:),0.05)));
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
        
    end
    
    hist(CoM_origin,length(CoM_origin/5)), hold on
    hist(CoM_origin(CoM_origin<quantile(CoM_origin,.5)),20), hold on
    CoM_origin = CoM_origin(CoM_origin<quantile(CoM_origin,.25));
    ZeroForce = mean(CoM_origin(round(CoM_origin/10)==mode(round(CoM_origin/10))));
    
    plot([ZeroForce ZeroForce],[0 10],'r')
    drawnow
    
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));        
        if isfield(trial,'forceProbeStuff')
            trial.forceProbeStuff.ZeroForce = ZeroForce;
            save(trial.name,'-struct','trial')
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
        
    end

    delete(br);
    
end
