% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

DEBUG =1;

CellID = T_fastinter.CellID;
T_new = T_fastinter(1,:);
T_new.CellID = 'placeholder';
Row_cnt = 0;

if (DEBUG)
    figure
    ax = subplot(1,1,1);
     hold(ax,'on')
end

for cidx = 1:length(CellID)
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
        figure
        ax_cell = subplot(1,1,1);
        cla(ax_cell)
        title(ax_cell,cid); hold(ax_cell,'on')
        ax_cell.XLim = [0 1];
        drawnow
    end

    for tr = 1:length(TP_spikes_position.trial)
        trial = load(fullfile(Dir,sprintf(trialStem,TP_spikes_position.trial(tr))));
        if trial.excluded
            continue;
        end
        if length(trial.spikes) ~= N
            continue
        end
        if n==2
            fr_12(tr-trialnumlist(1)+1) = 1/diff(trial.spikes(1:2));
        end

        
        t = makeInTime(trial.params);
                
        frame_times = makeFrameTime(trial);
        ft = frame_times;
        
        sp_win = t>=t(trial.spikes(1))+t_i_f(1) & t<t(trial.spikes(1))+t_i_f(2);
        frame_win = frame_times>=t(trial.spikes(1))+t_i_f(1) & frame_times <= t(trial.spikes(1))+t_i_f(2);
        
        CoM = trial.forceProbeStuff.CoM;
        origin = min(CoM(ft>ft(3)&ft<0));
        CoM = CoM - origin;

        trjct_t = t_i_f+t(trial.spikes(1));
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
        
        spike_i_idx = trial.spikes(1)-4;
        sptrjct = plot(n_sp_ax, t(trjct_twin)-t(trial.spikes(1)),trial.voltage_1(trjct_twin)-trial.voltage_1(spike_i_idx),'color',clrs(n,:),'tag',num2str(tr));
        %emgtrjct = plot(n_emg_ax, t(trjct_twin)-t(trial.spikes(1)),trial.current_2(trjct_twin),'color',[.8 0 0],'tag',num2str(tr));
        
        % get rid of artifact, if necessary
        
%         trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
%         phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:));
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);        
    end

    if DEBUG
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




