% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

DEBUG =0;

T = T_fastinter;
n = zeros(height(T),1); n_cell = cell(height(T),1);
Position = n; NumSpikes = n; Peak = n; PeakErr = n; Speed = n; SpeedErr = n; TimeToPeak = n; TimeToPeakErr = n; EMG_delay = n; EMG_jitter = n; mla = n;
T = addvars(T,Position,NumSpikes,Peak,PeakErr,Speed,SpeedErr,TimeToPeak,TimeToPeakErr,EMG_delay,EMG_jitter, mla);
varTypes = varfun(@class,T,'OutputFormat','cell');
T_FperSpike = table('Size',[2000,size(T,2)],'VariableTypes',varTypes,'VariableNames',T.Properties.VariableNames);
T_FperSpike_0 = T_FperSpike;
T_FperSpike_mla = T_FperSpike;

CellID = T.CellID;
for drugconditions = {'0','mla'}
    
    fprintf('Drug condition: %s\n',drugconditions{1});
    switch drugconditions{1}
        case '0'
            T_FperSpike = T_FperSpike_0;
        case 'mla'
            % all trials tagged as mla and included are here
            T_FperSpike = T_FperSpike_mla;
    end
    
    Row_cnt = 0;
        
    for cidx = 1:length(CellID)
        if (DEBUG)
            figure
            ax = subplot(1,1,1);
        end
        
        T_row = T(cidx,:);
        
        cellid = CellID{cidx};
        
        fprintf('Starting %s\n',cellid);
        
        Dir = fullfile('E:\Data',cellid(1:6),cellid);
        if ~exist(Dir,'dir')
            Dir = fullfile('F:\Acquisition',cellid(1:6),cellid);
        end
        cd(Dir);
        
        datafilename = fullfile(Dir,[T.Protocol{cidx} '_' cellid '.mat']);
        
        try data = load(datafilename); data = data.data;
        catch e
            if strcmp(e.identifier,'MATLAB:load:couldNotReadFile')
                fprintf(' --- Could not find %s Info for %s. Moving on\n',T.Protocol{cidx},cellid);
                continue
            else
                e.rethrow
            end
        end
        
        trialnums = T_row.Trialnums{1};
        trialname = fullfile(Dir,[T.Protocol{cidx} '_Raw_' cellid '_' num2str(trialnums(1)) '.mat']);
        trialStem = extractTrialStem(trialname);

        TP = datastruct2table(data,'DataStructFileName',datafilename,'rewrite',rewrite_yn);
        TP = addProbePositionToDataTable(TP,T.Positions{cidx});
        [TP, drugs] = addDrugsToDataTable(TP);
        TP.ProbePosition(TP.caffeine | TP.mla | TP.atropine | TP.ttx | TP.serotonin) = Inf;

        switch drugconditions{1}
            case '0'
                [~,~,TP_idx] = intersect(trialnums,TP.trial);
                TP_0 = TP(TP_idx,:);
            case 'mla'
                if ~any(TP.mla)
                    continue
                end
                % all trials tagged as mla and included are here
                TP_0 = TP(TP.mla,:);
        end
        TP_0 = addSpikeNumsToDataTable(TP_0,trialStem);
        TP_0 = addExcludeFlagToDataTable(TP_0,trialStem);
        %TP_0 = TP_0(~TP_0.Excluded & TP_0.spikenums>0,:);
        TP_0 = TP_0(~TP_0.Excluded,:);
        
        positions = unique(TP_0.ProbePosition);
        for position = positions(:)'
            TP_position = TP_0(TP_0.ProbePosition==position,:);
            fprintf(1,'\tPosition: %d\n',position);
            
            peak = nan(size(TP_position.trial));
            speed = nan(size(TP_position.trial));
            ttpk = nan(size(TP_position.trial));
            cv = nan(size(TP_position.trial));
            if DEBUG
                cla(ax)
                title(ax,cellid); hold(ax,'on')
                ax.XLim = [0 .3];
                drawnow
            end
            for tr = 1:length(TP_position.trial)
                trial = load(fullfile(Dir,sprintf(trialStem,TP_position.trial(tr))));
                if isfield(trial,'excluded') && trial.excluded
                    continue
                end
                
                if isempty(trial.spikes)
                    t = makeInTime(trial.params);
                    ft = makeFrameTime(trial);
                    % start the search for a peak after the light stim is
                    % off
                    ft_spike = ft-trial.params.stimDurInSec;
                    
                    twitch = trial.forceProbeStuff.CoM;
                    twitch = twitch - twitch(find(ft_spike<0,1,'last'));

                    peak(tr) = mean(twitch(ft_spike>0 & ft_spike<.07));
                    % continue
                else
                    
                    t = makeInTime(trial.params);
                    if TP_position.spikenums(tr)==1 && isfield(trial,'EMGspikes')
                        
                        if strcmp(cellid,'180807_F1_C1') % a lot of spurious spiking in this cell
                            %emgspk = find(trial.EMGspikes>trial.spikes,1);
                            cv(tr) = diff(t([trial.spikes trial.EMGspikes]));
                        elseif strcmp(cellid,'190110_F2_C1') % a lot of spurious spiking in this cell
                            emgspk = find(trial.EMGspikes>trial.spikes,1);
                            cv(tr) = diff(t([trial.spikes trial.EMGspikes(emgspk)]));
                        elseif strcmp(cellid,'190712_F1_C1') % a lot of spurious spiking in this cell
                            emgspk = find(trial.EMGspikes>trial.spikes,1);
                            if length(emgspk) ~= 1
                                cv(tr) = nan;
                            else
                                cv(tr) = diff(t([trial.spikes trial.EMGspikes(emgspk)]));
                            end
                        elseif length(trial.EMGspikes) ~= 1
                            error('Too many EMGspikes: %s',trial.name);
                        else
                            cv(tr) = diff(t([trial.spikes trial.EMGspikes]));
                        end
                    end
                    
                    ft = makeFrameTime(trial);
                    ft_spike = ft-t(trial.spikes(1));
                    
                    twitch = trial.forceProbeStuff.CoM;
                    twitch = twitch - twitch(find(ft_spike<0,1,'last'));
                    if strcmp(cellid,'180405_F3_C1') % 22a08, too much spiking and movement after the flash
                        ft_last = t(trial.spikes(end))-t(trial.spikes(1));
                        [peak(tr),ttpk_i] = max(twitch(ft_spike>0 & ft_spike<ft_last+.08));
                    else
                        % normal case
                        [peak(tr),ttpk_i] = max(twitch(ft_spike>0 & ft_spike<.3));
                    end
                    ttpk_i = ttpk_i+sum(ft_spike<=0);
                    ttpk(tr) = ft_spike(ttpk_i);
                    try speed(tr) = max(diff(twitch(ft_spike>0 & ft_spike<=ttpk(tr)))/diff(ft(1:2)));
                    catch e
                        if strcmp(e.identifier,'MATLAB:matrix:singleSubscriptNumelMismatch')
                            speed(tr) = max(diff(twitch(ttpk_i-1:ttpk_i))/diff(ft(1:2)));
                        else 
                            e.rethrow
                        end
                    end
                    if peak(tr)<10 && strcmp(T.Cell_label{cidx},'fast')
                        fprintf(1,'\tSmall peak: %d\n',trial.params.trial)
                        ttpk(tr) = nan;
                        peak(tr) = nan;
                        speed(tr) = nan;
                    end
                    
                    
                    
                    if peak(tr)>10 && strcmp(cellid,'180807_F1_C1') && length(trial.spikes)==1
                        % This is a 22A08 cell with
                        error('\tExtra tall peak: %d\n',trial.params.trial)
                        
                        ttpk(tr) = nan;
                        peak(tr) = nan;
                        speed(tr) = nan;

                    end
                    if DEBUG
                        plot(ax,ft_spike(ft_spike>0),twitch(ft_spike>0),'tag',[cellid,' ',num2str(trial.params.trial)]);
                        plot(ax,ttpk(tr),twitch(ttpk_i),'ok');
                        drawnow
                    end
                end
            end
            
            spks = unique(TP_position.spikenums);
            % spks = spks(spks~=0);
            for spike = spks(:)'
                peak_ave = nanmean(peak(TP_position.spikenums==spike));
                num = std(peak(TP_position.spikenums==spike));
                den = sqrt(size(peak(TP_position.spikenums==spike),1));
                peak_sem = num./den;
                
                speed_ave = nanmean(speed(TP_position.spikenums==spike));
                num = std(speed(TP_position.spikenums==spike));
                den = sqrt(size(speed(TP_position.spikenums==spike),1));
                speed_sem = num./den;

                ttpk_ave = nanmean(ttpk(TP_position.spikenums==spike));
                num = std(ttpk(TP_position.spikenums==spike));
                den = sqrt(size(ttpk(TP_position.spikenums==spike),1));
                ttpk_sem = num./den;
                
                cv_ave = nanmedian(cv(TP_position.spikenums==spike));
                jitter = nanstd(cv(TP_position.spikenums==spike));
                
                T_row.Position = position;
                T_row.NumSpikes = spike;
                T_row.Trialnums = {TP_position.trial(TP_position.spikenums==spike)};
                T_row.Peak = peak_ave;
                T_row.PeakErr = peak_sem;
                T_row.Speed = speed_ave;
                T_row.SpeedErr = speed_sem;
                T_row.TimeToPeak = ttpk_ave;
                T_row.TimeToPeakErr = ttpk_sem;
                T_row.EMG_delay = cv_ave;
                T_row.EMG_jitter = jitter;
                
                Row_cnt = Row_cnt+1;
                T_FperSpike(Row_cnt,:) = T_row(1,:);
                % if position == 0 && spike == 1
                    % head(T_row)
                    % head(T_FperSpike(Row_cnt,:))
                % end
                
            end
        end
    end
    
    % Truncate preallocated table
    switch drugconditions{1}
        case '0'
            T_FperSpike_0 = T_FperSpike;
            T_FperSpike_0 = T_FperSpike_0(1:Row_cnt,:);
        case 'mla'
            % all trials tagged as mla and included are here
            T_FperSpike_mla = T_FperSpike;
            T_FperSpike_mla = T_FperSpike_mla(1:Row_cnt,:);
    end
end
% clear T_FperSpike varTypes varNames twitch ttpk_ave ttpk_sem ttpk trialStem ttpk_i trialnums trialname trial tr TP_position TP_idx TP_0 TP  TimeToPeakErr TimeToPeak T_row t sz spks spike Row_cnt positions position Position data PeakErr peak_ave peak_sem Peak peak NumSpikes num n_cell n mla jitter ft_spike ft_last ft emgspk EMG_jitter EMG_delay drugs drugconditions Dir den DEBUG datafilename  cv_ave cv cidx CellID cellid

