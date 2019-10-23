%% Script_FindTheMinimumCoM
% NOTE: This lets the user select the most likely ZeroForce location for the bar for
% each batch of trials.
% Issue: if the bar was lopsided, it may be wider and therefore extend
% further to the left. If CoM goes a lot below the Zero Force point, it may
% suffer from this property

% This needs to be done on batches of trials on their own. Because the bar
% may have moved in between. Just take a look at all of them.

blockfig = figure;
blockfig.Position = [13 558 1835 420];

%trials = bartrials;
% clfield = 'clustertraces_NBCls';

Nblax = max([3 length(trials)]);
for n = 1:Nblax
    ax = subplot(1,Nblax,n,'parent',blockfig);
    ax.NextPlot = 'add';
end

clrs = ax.ColorOrder;

blcnt = 0;
ylims = [Inf -Inf];
for blcnt = 1:length(trials)
    trialnums = trials{blcnt};
    block_F0 = Inf*ones(1,6);
    ax = subplot(1,Nblax,blcnt,'parent',blockfig);
    for tr = trialnums
        trial = load(sprintf(trialStem,tr));
        if isfield(trial,'excluded') && trial.excluded
            continue
        end
        ftca = makeFrameTime2CB2T(trial);
        onwind = ftca>3*diff(ftca(1:2))&ftca<trial.params.stimDurInSec-3*diff(ftca(1:2));
        trial_F0 = min(trial.(clfield)(onwind,:));
        if length(block_F0)>trial_F0
            block_F0 = block_F0(1:length(trial_F0));
            clrs = clrs(1:length(trial_F0),:);
        end
        for cl = 1:length(trial_F0)
            plot(ax,ftca(onwind),trial.(clfield)(onwind,cl),'color',clrs(cl,:),'tag',num2str(trial.params.trial));
            if trial_F0(cl) < block_F0(cl)
                block_F0(cl) = trial_F0(cl);
            end
        end
        ylims = [min([ylims(1) min(trial_F0)]) max([ylims(2) max(trial.(clfield)(:))])];
    end
    title(ax,['Block ' num2str(blcnt)])
    if isfield(trial,['F0_' clfield])
        for cl = 1:length(trial_F0)            
            plot(ax,[ftca(1) ftca(end)], trial.(['F0_' clfield])(cl)*[1 1],'color',clrs(cl,:),'tag','zfl','userdata',block_F0);
        end
    else
        for cl = 1:length(trial_F0)
            plot(ax,[ftca(1) ftca(end)], block_F0(cl)*[1 1],'color',clrs(cl,:),'tag','zfl','userdata',block_F0);
        end
    end
end
ylims = mean(ylims)+1.1*diff(ylims/2)*[-1 1];
set(findobj(blockfig,'type','axes'),'ylim',ylims);

%% Now let user choose where F0 is (previous block - j, next block - k, none - n, correct - space,r - redo)
for blcnt = 1:length(trials)
    ax = subplot(1,Nblax,blcnt,'parent',blockfig);

    zfl = findobj(ax,'tag','zfl');
    for cl = 1:length(zfl)
        fol = zfl(cl);
        clr = fol.Color;
        fol.Color = lighten(clr);
        fol.LineWidth = 2;
        set(ax,'ylim',[0 4*mean(fol.YData)]);
        
        prblines = findobj(ax,'type','line','color',clr);
        blockF0(cl) = getF0Estimate(prblines,fol);
    end
    saveF0(blockF0,trialStem,trials{blcnt},clfield)        
end


function saveF0(blockF0,trialStem,trials,clfield)
fprintf('Saving ZeroForce = \t');
fprintf('%.3f\t',blockF0);
fprintf(' to trial: ');
for tr = trials
    fprintf(' %d ',tr)
    trial = load(sprintf(trialStem,tr));
    trial.(['F0_' clfield]) = blockF0;
    save(trial.name, '-struct', 'trial');
end
fprintf('\n')
end

function ZF = getF0Estimate(ls,fol)
threshold = 1.5;
ZF = mean(fol.YData);
zfvals = [];
for l = ls'
    y = l.YData(:);
    zfvals = cat(1,zfvals,y(y<ZF+threshold));
end
ZF = mean(zfvals(zfvals<quantile(zfvals,.75)));
fol.YData = ZF*[1 1];
end