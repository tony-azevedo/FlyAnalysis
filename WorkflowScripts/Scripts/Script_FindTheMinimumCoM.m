%% Script_FindTheMinimumCoM
% NOTE: This lets the user select the most likely ZeroForce location for the bar for
% each batch of trials.
% Issue: if the bar was lopsided, it may be wider and therefore extend
% further to the left. If CoM goes a lot below the Zero Force point, it may
% suffer from this property

% This needs to be done on batches of trials on their own. Because the bar
% may have moved in between. Just take a look at all of them.

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

data = load(datastructfile); data = data.data;
TP = datastruct2table(data,'DataStructFileName',datastructfile);
% TP = addProbePositionToDataTable(TP,T.Positions{cidx});
TP = addExcludeFlagToDataTable(TP,trialStem);
[TP, drugs] = addDrugsToDataTable(TP);
TP = addProbeMinToDataTable(TP,trialStem);
TP = TP(~TP.Excluded & ~isnan(TP.ProbeMin),:);

blocks = unique(TP.trialBlock);
blockfig = figure;
blockfig.Position = [13 558 1835 420];

Nblax = max([3 length(blocks)]);
for n = 1:Nblax
    ax = subplot(1,Nblax,n,'parent',blockfig);
    ax.NextPlot = 'add';
end

blcnt = 0;
ylims = [Inf -Inf];
for block = blocks'
    blcnt = blcnt+1;
    block_Zero_force = Inf;
    T_block = TP(TP.trialBlock==block,:);   
    ax = subplot(1,Nblax,blcnt,'parent',blockfig);
    for tr = T_block.trial'
        trial = load(sprintf(trialStem,tr));
        if isfield(trial,'excluded') && trial.excluded
            continue
        end
        ft = makeFrameTime(trial);
        plot(ax,ft,trial.forceProbeStuff.CoM,'color',[.7 .7 1],'tag',num2str(trial.params.trial));
        
        trial_Zero_force = min(trial.forceProbeStuff.CoM);
        if trial_Zero_force < block_Zero_force
            block_Zero_force = trial_Zero_force;
        end        
        ylims = [min([ylims(1) trial_Zero_force]) max([ylims(2) max(trial.forceProbeStuff.CoM)])];
    end
    title(ax,['Block ' num2str(block)])
    if isfield(trial.forceProbeStuff,'ZeroForce')
        plot(ax,[ft(1) ft(end)], trial.forceProbeStuff.ZeroForce*[1 1],'color',[.8 1 .3],'tag','zfl','userdata',block_Zero_force);
    else
        plot(ax,[ft(1) ft(end)], block_Zero_force*[1 1],'color',[.8 .8 .8],'tag','zfl','userdata',block_Zero_force);
    end
end
ylims = mean(ylims)+1.1*diff(ylims/2)*[-1 1];
set(findobj(blockfig,'type','axes'),'ylim',ylims);

%% Now let user choose where ZeroForce is (previous block - j, next block - k, none - n, correct - space,r - redo)
blcnt = 0;
for block = blocks'
    blcnt = blcnt+1;    
    ax = subplot(1,Nblax,blcnt,'parent',blockfig);
    T_block = TP(TP.trialBlock==block,:);

    zfl = findobj(ax,'tag','zfl');
    blockZeroForce0 = mean(zfl.YData);
    zfl.Color = [1 0 0];
    
    if blcnt == 1 % can't choose the left
        title(ax,['Block ' num2str(block) ' - space,k,n,r?'])
        keydown = waitforbuttonpress;
        while keydown==0 || ~any(strcmp({' ','k','n','r'},blockfig.CurrentCharacter))
            %disp(displayf.CurrentCharacter);
            keydown = waitforbuttonpress;
        end
    elseif blcnt == length(blocks) % can't choose the right
        title(ax,['Block ' num2str(block) ' - space,j,n,r?'])
        keydown = waitforbuttonpress;
        while keydown==0 || ~any(strcmp({' ','j','n','r'},blockfig.CurrentCharacter))
            %disp(displayf.CurrentCharacter);
            keydown = waitforbuttonpress;
        end
    else
        title(ax,['Block ' num2str(block) ' - space,j,k,n,r?'])
        keydown = waitforbuttonpress;
        while keydown==0 || ~any(strcmp({' ','j','k','n','r'},blockfig.CurrentCharacter))
            %disp(displayf.CurrentCharacter);
            keydown = waitforbuttonpress;
        end
    end
    cmd_key = blockfig.CurrentCharacter;
    
    title(ax,['Saving Block ' num2str(block)])
    zfl.Color = [1 1 1]*.8;

    switch cmd_key
        case ' ' 
            prblines = findobj(ax,'type','line');
            blockZeroForce = getLowForceEstimate(prblines);
            saveZF(blockZeroForce,trialStem,T_block.trial)
        case 'r'
            zfl = findobj(ax,'tag','zfl');
            zfl.YData = zfl.UserData*[1 1]; % reset as the minimum for the block
            prblines = findobj(ax,'type','line');
            blockZeroForce = getLowForceEstimate(prblines);
            saveZF(blockZeroForce,trialStem,T_block.trial)
        case 'j'
            ax_left = subplot(1,Nblax,blcnt-1,'parent',blockfig);
            prblines = findobj(ax_left,'type','line');
            blockZeroForce = getLowForceEstimate(prblines);
            zfl = findobj(ax,'tag','zfl');
            zfl.YData = blockZeroForce*[1 1];
            saveZF(blockZeroForce,trialStem,T_block.trial)
        case 'k'
            ax_right = subplot(1,Nblax,blcnt+1,'parent',blockfig);
            prblines = findobj(ax_right,'type','line');
            blockZeroForce = getLowForceEstimate(prblines);
            zfl = findobj(ax,'tag','zfl');
            zfl.YData = blockZeroForce*[1 1];
            saveZF(blockZeroForce,trialStem,T_block.trial)
        case 'n'
            saveZF(NaN,trialStem,T_block.trial)
        otherwise
    end
    
    title(ax,['Block ' num2str(block)])

end


function saveZF(ZeroForce,trialStem,trials)
fprintf('Saving ZeroForce = %.1f to trial: ',ZeroForce)
for tr = trials'
    fprintf(' %d ',tr)
    trial = load(sprintf(trialStem,tr));
    trial.forceProbeStuff.ZeroForce = ZeroForce;
    save(trial.name, '-struct', 'trial');
end
fprintf('\n')
end

function ZF = getLowForceEstimate(ls)
threshold = 5;
zfl = findobj(ls,'tag','zfl');
if zfl.UserData~=mean(zfl.YData) % this has already been done
    ZF = mean(zfl.YData);
else % Calculating block ZF for the first time
    ls = ls(ls~=zfl);
    ZF = mean(zfl.YData);
    zfvals = [];
    for l = ls'
        y = l.YData(:);
        zfvals = cat(1,zfvals,y(y<ZF+threshold));
    end
    ZF = mean(zfvals);
    zfl.YData = ZF*[1 1];
end

end