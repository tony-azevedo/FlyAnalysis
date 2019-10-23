% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

close all

DEBUG =0;

T = T_slow;
n = zeros(height(T),1); n_cell = cell(height(T),1);

% Strategy 1
% Position = n;
NumSpikes = n_cell;
Peak = n_cell; Probe0 = n_cell; ProbeMin = n_cell;
TimeToPeak = n_cell; SpontFiringRate = n; SpontFiringRateErr = n; mla = n;
T1 = addvars(T,NumSpikes,Peak,Probe0,ProbeMin,TimeToPeak,SpontFiringRate,SpontFiringRateErr, mla);
varTypes = varfun(@class,T1,'OutputFormat','cell');
T_FperNSpikes = table('Size',[2000,size(T1,2)],'VariableTypes',varTypes,'VariableNames',T1.Properties.VariableNames);
T_FperNSpikes_0 = T_FperNSpikes;
T_FperNSpikes_mla = T_FperNSpikes;

% Strategy 2
Steps = n_cell; Step = n; V_m = n; DV_m = n; Rest = n; FiringRate = n; SpikeNumEst = n; Peak = n;
T2 = addvars(T,Steps,Step,V_m,DV_m,Rest,FiringRate,SpikeNumEst,Peak,mla);
varTypes = varfun(@class,T2,'OutputFormat','cell');
T_FvsFiringRate = table('Size',[2000,size(T2,2)],'VariableTypes',varTypes,'VariableNames',T2.Properties.VariableNames);
T_FvsFiringRate_0 = T_FvsFiringRate;
T_FvsFiringRate_mla = T_FvsFiringRate;


CellIDs = T.CellID;
%% Do the following twice, once for control, once for mla:
for drugconditions = {'0','mla'}
    
    fprintf('Drug condition: %s\n',drugconditions{1});
    switch drugconditions{1}
        case '0'
            T_FvsFiringRate = T_FvsFiringRate_0;
            T_FperNSpikes = T_FperNSpikes_0;
        case 'mla'
            % all trials tagged as mla and included are here
            T_FvsFiringRate = T_FvsFiringRate_mla;
            T_FperNSpikes = T_FperNSpikes_mla;
    end
    
    Row_cnt_1 = 0;
    Row_cnt_2 = 0;

    for cididx = 1:length(CellIDs) % 4 for 181014_F1_C1
        
        cellid = CellIDs{cididx};
        T_row = T1(cididx,:);
        
        fprintf('Starting %s\n',cellid);
        
        Dir = fullfile('E:\Data',cellid(1:6),cellid);
        if ~exist(Dir,'dir')
            Dir = fullfile('F:\Acquisition',cellid(1:6),cellid);
        end
        cd(Dir);
        
        datafilename = fullfile(Dir,[T_row.Protocol{1} '_' cellid '.mat']);
        try data = load(datafilename); data = data.data;
        catch e
            if strcmp(e.identifier,'MATLAB:load:couldNotReadFile')
                fprintf(' --- Could not find %s Info for %s. Moving on\n',T.Protocol{cididx},cellid);
                continue
            else
                e.rethrow
            end
        end
        
        trialnums = T_row.Trialnums{1};
        trialname = fullfile(Dir,[T_row.Protocol{1} '_Raw_' cellid '_' num2str(trialnums(1)) '.mat']);
        trialStem = extractTrialStem(trialname);
        
        fprintf(1,'\tTablizing datastructure %s\n',datafilename);
        TP = datastruct2table(data,'DataStructFileName',datafilename);
        TP = addExcludeFlagToDataTable(TP,trialStem);
        TP = addProbePositionToDataTable(TP,T_row.Positions{1});
        [TP, drugs] = addDrugsToDataTable(TP);
        
        TP.ProbePosition(TP.caffeine | TP.mla | TP.atropine | TP.ttx | TP.serotonin) = Inf;
        TP = TP(~TP.Excluded,:);
        
        switch drugconditions{1}
            case '0'
                %TP = TP(TP.ProbePosition==0,:);
                [~,~,TP_idx] = intersect(trialnums,TP.trial);
                TP_0 = TP(TP_idx,:);
            case 'mla'
                if ~any(TP.mla)
                    continue
                end
                % all trials tagged as mla and included are here
                TP_0 = TP(TP.mla,:);
        end
        
        
        spikenums = zeros(size(TP_0.trial));
        fr = nan(size(TP_0.trial));
        peak = nan(size(TP_0.trial));
        startingforce = nan(size(TP_0.trial));
        minforce = nan(size(TP_0.trial));
        ttpk = nan(size(TP_0.trial));
        
        %% Taking two approaches from here
        % 1) look across trials;
        
        % Make a figure for force vs spike numbers
        if (DEBUG)
            figure
            ax = subplot(1,1,1);
        end
        
        % Set up the individual trials axis
        if DEBUG
            figure
            ax_cell = subplot(1,1,1);
            cla(ax_cell)
            title(ax_cell,cellid); hold(ax_cell,'on')
            ax_cell.XLim = [0 1];
            drawnow
        end
        
        for tr = 1:length(TP_0.trial)
            trial = load(fullfile(Dir,sprintf(trialStem,TP_0.trial(tr))));
            if isfield(trial,'excluded') && trial.excluded
                continue
            end
            
            t = makeInTime(trial.params);
            spikenums(tr) = length(t(t(trial.spikes)>0 & t(trial.spikes)<trial.params.stimDurInSec));
            
            % get baseline firing rate while you're at it
            fr(tr) = sum(t(trial.spikes)<0 & t(trial.spikes)>-trial.params.preDurInSec-.06)/(trial.params.preDurInSec-.06);
            
            if spikenums(tr)==0
                continue
            end
            
            ft = makeFrameTime(trial);
            
            twitch = smooth(trial.forceProbeStuff.CoM,10);
            startingforce(tr) = twitch(find(ft<0,1,'last'));
            minforce(tr) = min(twitch);
            twitch = twitch - twitch(find(ft<0,1,'last'));
            
            [peak(tr),ttpk_i] = max(twitch(ft>trial.params.stimDurInSec/2 & ft<trial.params.stimDurInSec+.1));
            ttpk_i = ttpk_i+sum(ft<=trial.params.stimDurInSec/2);
            ttpk(tr) = ft(ttpk_i);
            
            % Plot the individual trials
            if DEBUG
                l = plot(ax_cell,ft(ft>0 & ft<trial.params.stimDurInSec+.1),twitch(ft>0 & ft<trial.params.stimDurInSec+.1));
                l.Tag = [cellid ' ' num2str(TP_0.trial(tr))];
                plot(ax_cell,ttpk(tr),twitch(ttpk_i),'ok');
                drawnow
            end
        end
        
        % Plot the Peak vs spike number
        if DEBUG
            plot(ax,spikenums(spikenums>=20),peak(spikenums>=20),'k.')
            ax.YLim = [0 20];
            ax.XLim = [0 100];
            drawnow
        end
        
        T_row.NumSpikes = {spikenums};
        T_row.Peak = {peak};
        T_row.Probe0 = {startingforce};
        T_row.ProbeMin = {minforce};
        T_row.TimeToPeak = {ttpk};
        T_row.SpontFiringRate = nanmean(fr);
        num = nanstd(fr);
        den = sqrt(sum(~isnan(fr)));
        T_row.SpontFiringRateErr = num./den;
        
        Row_cnt_1 = Row_cnt_1+1;
        T_FperNSpikes(Row_cnt_1,:) = T_row(1,:);
        %     head(T_row)
        %     head(T_FperNSpikes(Row_cnt_1,:))
        
        %% Strategy/Table 2
        % 2) average by step/current, then report force vs. spike rate
        Row = T2(cididx,:); % reset
        current_steps = unique(TP_0.steps{1});
        clrs = parula(length(current_steps)+1); clrs = clrs(1:end-1,:);
        if DEBUG
            fig = figure;
            fig.Position = [680   154   560   824];
            ax0 = subplot(3,1,1); ax0.NextPlot = 'add';
            ax1 = subplot(3,1,2); ax1.NextPlot = 'add';
            ax2 = subplot(3,1,3); ax2.NextPlot = 'add';
        end
        for step = current_steps
            
            stpidx = TP_0.step==step;
            group = TP_0.trial(stpidx);
            trial = load(fullfile(Dir,sprintf(trialStem,group(1))));
            %% Right here is the problem!
            t = (0:1:round(min(TP_0.durSweep)*trial.params.sampratein) -1)/trial.params.sampratein;
            if isfield(trial.params,'preDurInSec')
                t = t-min(TP_0.preDurInSec);
            end
            t = t(:);
            ft = makeFrameTime(trial);
            v_ = nan(length(t),length(group));
            spikes_ = v_;
            probe_ = nan(length(ft),length(group));
            
            for cnt = 1:length(group)
                trial = load(sprintf(trialStem,group(cnt)));
                if isfield(trial,'excluded') && trial.excluded
                    continue
                end
                if ~isfield(trial,'spikes')
                    continue
                end
                
                % The probe position vector maybe a different length
                try v_(:,cnt) = trial.voltage_1;
                catch e
                    if strcmp(e.identifier,'MATLAB:subsassigndimmismatch')
                        if -trial.params.preDurInSec == t(1)
                            v_(:,cnt) = trial.voltage_1(1:length(t));
                        else
                            error(e);
                        end
                    end
                end
                spikes_(:,cnt) = 0;
                spikes_(trial.spikes(trial.spikes<length(t)),cnt) = 1;
                
                % The probe position vector maybe a different length
                try probe_(:,cnt) = trial.forceProbeStuff.CoM;
                catch e
                    if strcmp(e.identifier,'MATLAB:subsassigndimmismatch')
                        if -trial.params.preDurInSec == t(1)
                            if length(trial.forceProbeStuff.CoM)<size(probe_,1)
                                com_ = [trial.forceProbeStuff.CoM nan(1,size(probe_,1)-length(trial.forceProbeStuff.CoM))];
                                probe_(:,cnt) = trial.forceProbeStuff.CoM;
                            elseif length(trial.forceProbeStuff.CoM)>size(probe_,1)
                                probe_(:,cnt) = trial.forceProbeStuff.CoM(1:size(probe_,1));
                            else
                                error(e);
                            end
                        else
                            error(e);
                        end
                    end
                end
            end
            if all(isnan(v_(:)))
                continue
            end
            v = nanmean(v_,2);
            spikes = logical(spikes_(:,~isnan(spikes_(1,:))));
            
            % ignore the prepulse
            twind = t>-trial.params.preDurInSec+.06;
            
            DT = 10/300;
            fr = firingRate(t,spikes_,10/300);
            probe = smooth(nanmean(probe_,2));
            probe = probe-mean(probe(ft<0 & ft >-.2));
            area = cumtrapz(ft,probe);
            area = area-area(find(ft<=0,1,'last'));
            
            switch sign(area(find(ft<=trial.params.stimDurInSec-.05,1,'last')))
                case 1 % depolarization
                    [~,ttpk] = max(probe(ft>0 & ft<trial.params.stimDurInSec));
                case -1 % hyperpolarization
                    [~,ttpk] = min(probe(ft>0 & ft<trial.params.stimDurInSec));
            end
            ttpk = ttpk+sum(ft<=0);
            
            Row.Trialnums = {group(:)'};
            Row.Steps = {current_steps};
            Row.Step = step;
            Row.V_m = mean(v(twind&t<0));
            Row.DV_m = mean(v(t>0 & t<trial.params.stimDurInSec))-Row.V_m;
            Row.Rest = mean(fr(twind & t<0));
            % a little bogus method of getting the highest spike rate for
            % large current steps
            if step<0
                Row.FiringRate = mean(fr(twind & t>0&t<trial.params.stimDurInSec)); % this is a little bogus
            elseif step>0
                stimwind = t>0&t<trial.params.stimDurInSec;
                highfr = stimwind;
                highfr(stimwind) = fr(stimwind)>=quantile(fr(stimwind),.5);
                Row.FiringRate = mean(fr(highfr)); % this is a little bogus
            end
            Row.SpikeNumEst = Row.FiringRate*trial.params.stimDurInSec;
            Row.Peak = probe(ttpk);
            
            Row_cnt_2 = Row_cnt_2+1;
            T_FvsFiringRate(Row_cnt_2,:) = Row(1,:);
            %         head(Row)
            %         head(T_FvsFiringRate(Row_cnt_2,:))
            
            if DEBUG
                clr_idx = find(step==current_steps);
                clr = clrs(clr_idx,:);
                %for c = 1:size(spikes,2)
                %raster(ax0,t(spikes(:,c)),c+[-.4 .4]+(clr_idx-1)*length(group)*1.5);
                %end
                plot(ax1,t,fr,'color',clr,'tag',[cellid ' ' num2str(step)])
                plot(ax1,t,fr,'color',clr,'tag',[cellid ' ' num2str(step)])
                plot(ax2,ft,probe,'color',clr,'tag',[cellid ' ' num2str(step)])
                
                title(ax0,regexprep(cellid,'\_','\\_'))
                groupstr = sprintf('%d,',group(:));
                groupstr = [num2str(step) ' - [' groupstr(1:end-1) ']'];
                text(ax1,.5,clr_idx*20,groupstr)
                
                ax1.YLim = [0 150];
                ax1.XLim = [t(1) t(end)];
                ax2.XLim = [t(1) t(end)];
                ax0.XLim = [t(1) t(end)];
                drawnow
            end
            
        end
        
    end
    switch drugconditions{1}
        case '0'
            T_FvsFiringRate_0 = T_FvsFiringRate;
            T_FperNSpikes_0 = T_FperNSpikes;
            T_FperNSpikes_0 = T_FperNSpikes_0(1:Row_cnt_1,:);
            T_FvsFiringRate_0 = T_FvsFiringRate_0(1:Row_cnt_2,:);
        case 'mla'
            % all trials tagged as mla and included are here
            T_FperNSpikes_mla = T_FperNSpikes;
            T_FperNSpikes_mla = T_FperNSpikes_mla(1:Row_cnt_1,:);
            T_FperNSpikes_mla.mla(:) = 1;
            T_FvsFiringRate_mla = T_FvsFiringRate;
            T_FvsFiringRate_mla = T_FvsFiringRate_mla(1:Row_cnt_2,:);
            T_FvsFiringRate_mla.mla(:) = 1;
    end

end
%%
clear T_FvsFiringRate T_FperNSpikes
clear varTypes varNames twitch ttpk_ave ttpk_sem ttpk trialStem ttpk_i trialnums trialname trial tr TP_position TP_idx TP_0 TP  TimeToPeakErr TimeToPeak T_row t sz spks spike Row_cnt positions position Position data PeakErr peak_ave peak_sem Peak peak NumSpikes num n_cell n mla jitter ft_spike ft_last ft emgspk EMG_jitter EMG_delay drugs drugconditions Dir den DEBUG datafilename  cv_ave cv cidx CellID cellid
clear T T1 T2 Row Rest Probe0 ProbeMin Row_cnt_1 Row_cnt_2 startingforce DT DV_m e group minforce current_steps cnt clrs cididx CellIDs area V_m v_ v twind stpidx stimwind Steps Step step SpontFiringRate FiringRate SpontFiringRateErr spikes_ spikes SpikeNumEst spikenums probe_ probe highfr fr 