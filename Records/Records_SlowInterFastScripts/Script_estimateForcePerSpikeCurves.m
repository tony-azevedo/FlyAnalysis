% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

DEBUG =0;

CellID = T.CellID;
T_new = T(1,:);
T_new.CellID = 'placeholder';
Row_cnt = 0;

T_new.EMG_delay = zeros(1);

for cidx =  1:length(CellID)
    if (DEBUG)
        figure
        ax = subplot(1,1,1);
    end

    T_row = T(cidx,:);
    
    cid = CellID{cidx};
    
    fprintf('Starting %s\n',cid);
    
    Dir = fullfile('E:\Data',cid(1:6),cid);
    if ~exist(Dir,'dir')
        Dir = fullfile('F:\Acquisition',cid(1:6),cid);
    end
    cd(Dir);

    datafilename = fullfile(Dir,[T.Protocol{cidx} '_' cid '.mat']);

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
    for pos = T.Positions
        TP_spikes_position = TP_spikes(TP_spikes.ProbePosition==0,:);
        
        spikenums = zeros(size(TP_spikes_position.trial));
        peak = nan(size(TP_spikes_position.trial));
        ttpk = nan(size(TP_spikes_position.trial));
        if DEBUG
            cla(ax)
            title(ax,cid); hold(ax,'on')
            ax.XLim = [0 .3];
            drawnow
        end
        for tr = 1:length(TP_spikes_position.trial)
            trial = load(fullfile(Dir,sprintf(trialStem,TP_spikes_position.trial(tr))));
            if isfield(trial,'excluded') && trial.excluded
                continue
            end
            % fprintf(1,'%d\n',length(trial.spikes));
            spikenums(tr) = length(trial.spikes);
            
            if length(trial.spikes)==0
                continue
            end
            
            t = makeInTime(trial.params);
            ft = makeFrameTime(trial);
            ft_spike = ft-t(trial.spikes(1));
            
            twitch = trial.forceProbeStuff.CoM;
            twitch = twitch - twitch(find(ft_spike<0,1,'last'));
            if strcmp(cid,'180405_F3_C1')
                ft_last = t(trial.spikes(end))-t(trial.spikes(1));
                [peak(tr),ttpk_i] = max(twitch(ft_spike>0 & ft_spike<ft_last+.08));
            else
                [peak(tr),ttpk_i] = max(twitch(ft_spike>0 & ft_spike<.3));
            end
            ttpk_i = ttpk_i+sum(ft_spike<=0);
            ttpk(tr) = ft_spike(ttpk_i);
            if peak(tr)<10 && strcmp(T.Cell_label{cidx},'fast')
                fprintf(1,'%d\n',trial.params.trial)
                ttpk(tr) = nan;
                peak(tr) = nan;
            end
            if peak(tr)>10 && strcmp(cid,'180807_F1_C1') && length(trial.spikes)==1
                fprintf(1,'%d\n',trial.params.trial)
                ttpk(tr) = nan;
                peak(tr) = nan;
            end
            if DEBUG
                plot(ax,ft_spike(ft_spike>0),twitch(ft_spike>0),'tag',[cid,' ',num2str(trial.params.trial)]);
                plot(ax,ttpk(tr),twitch(ttpk_i),'ok');
                drawnow
            end
            
        end
        
        spks = unique(spikenums);
        spks = spks(spks~=0);
        for spike = spks(:)'
            peak_ave = nanmean(peak(spikenums==spike));
            num = std(peak(spikenums==spike));
            den = sqrt(size(peak(spikenums==spike),1));
            peak_sem = num./den;
            
            ttpk_ave = nanmean(ttpk(spikenums==spike));
            num = std(ttpk(spikenums==spike));
            den = sqrt(size(ttpk(spikenums==spike),1));
            ttpk_sem = num./den;
            
            T_row.NumSpikes = spike;
            T_row.Trialnums = trialnums(spikenums==spike);
            T_row.Peak = peak_ave;
            T_row.PeakErr = peak_sem;
            T_row.TimeToPeak = ttpk_ave;
            T_row.TimeToPeakErr = ttpk_sem;
            
            T_new = [T_new;T_row];
            
        end
        
    end
end
T_new = T_new(~strcmp(T_new.CellID,'placeholder'),:);


