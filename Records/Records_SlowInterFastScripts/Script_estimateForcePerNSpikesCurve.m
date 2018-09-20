% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

DEBUG =1;

CellID = T.CellID;
T_new = T(1,:);
T_new.CellID = 'placeholder';
Row_cnt = 0;

if (DEBUG)
    figure
    ax = subplot(1,1,1);
end

for cidx = 1:length(CellID)
    T_row = T(cidx,:);
    
    cid = CellID{cidx};
    
    fprintf('Starting %s\n',cid);
    
    Dir = fullfile('B:\Raw_Data',cid(1:6),cid);
    cd(Dir);
    
    datafilename = fullfile('B:\Raw_Data',cid(1:regexp(cid,'_')-1),cid);
    datafilename = fullfile(datafilename,[T.Protocol{cidx} '_' cid '.mat']);
    try data = load(datafilename); data = data.data;
    catch e
        if strcmp(e.identifier,'MATLAB:load:couldNotReadFile')
            fprintf(' --- Could not find %s Info for %s. Moving on\n',T.Protocol{cidx},cid);
            continue
        else
            e.rethrow
        end
    end
    
    fprintf(1,'\tTablizing datastructure %s\n',datafilename);
    TP = datastruct2table(data,'DataStructFileName',datafilename);
    fprintf(1,'\tFinding tagged positions: [');
    fprintf(1,'%d\t',T.Positions{cidx});
    fprintf(1,']\n');
    
    TP = addProbePositionToDataTable(TP,T.Positions{cidx});
    % TP = addSpikeNumsToDataTable(TP);
    
    trialnums = T.Trialnums{cidx};
    trialname = fullfile(Dir,[T.Protocol{cidx} '_Raw_' cid '_' num2str(trialnums(1)) '.mat']);
    [~,~,~,~,~,~,trialStem] = extractRawIdentifiers(trialname);

    [tr_idx,~,TP_idx] = intersect(trialnums,TP.trial);
    TP_spikes = TP(TP_idx,:);
    % for pos = T.Positions
    TP_spikes_position = TP_spikes(TP_spikes.ProbePosition==0,:);
    
    spikenums = zeros(size(TP_spikes_position.trial));
    fr = nan(size(TP_spikes_position.trial));
    peak = nan(size(TP_spikes_position.trial));
    ttpk = nan(size(TP_spikes_position.trial));
    if DEBUG
        cla(ax)
        title(ax,cid); hold(ax,'on')
        ax.XLim = [0 1];
        drawnow
    end

    for tr = 1:length(TP_spikes_position.trial)
        trial = load(fullfile(Dir,sprintf(trialStem,TP_spikes_position.trial(tr))));
        if isfield(trial,'excluded') && trial.excluded
            continue
        end
        
        t = makeInTime(trial.params);
        spikenums(tr) = length(t(t(trial.spikes)>0 & t(trial.spikes)<trial.params.stimDurInSec));

        % get baseline firing rate while you're at it
        fr(tr) = length(t(t(trial.spikes)<0))/(trial.params.preDurInSec-.06);

        if spikenums(tr)==0
            continue
        end

        ft = makeFrameTime(trial);
        
        twitch = smooth(trial.forceProbeStuff.CoM,10);
        twitch = twitch - twitch(find(ft<0,1,'last'));
        % if strcmp(cid,'180807_F1_C1') 
        
        [peak(tr),ttpk_i] = max(twitch(ft>trial.params.stimDurInSec/2 & ft<trial.params.stimDurInSec+.1));
        ttpk_i = ttpk_i+sum(ft<=trial.params.stimDurInSec/2);
        ttpk(tr) = ft(ttpk_i);

        if DEBUG
            plot(ax,ft(ft>0 & ft<trial.params.stimDurInSec+.1),twitch(ft>0 & ft<trial.params.stimDurInSec+.1));
            plot(ax,ttpk(tr),twitch(ttpk_i),'ok');
            drawnow
        end

        
    end

    if DEBUG
        cla(ax)
        plot(ax,spikenums(spikenums>=20),peak(spikenums>=20),'k.')
        ax.YLim = [0 20];
        ax.XLim = [0 100];
        drawnow
    end

    T_row.NumSpikes = {spikenums};
    T_row.Peak = {peak};
    T_row.TimeToPeak = {ttpk};
    T_row.SpontFiringRate = nanmean(fr);
    num = nanstd(fr);
    den = sqrt(sum(~isnan(fr)));
    T_row.SpontFiringRateErr = num./den;

    T_new = [T_new;T_row];

end
T_new = T_new(~strcmp(T_new.CellID,'placeholder'),:);


