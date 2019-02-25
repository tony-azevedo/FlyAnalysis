% Do stuff with the spike rate of slow neurons
DEBUG =0;

T_StpSlowFR = T_Step(strcmp(T_Step.Cell_label,'slow'),:);
cids = unique(T_StpSlowFR.CellID);

T_StpSlowFR.Peak(:) = NaN;
T_StpSlowFR.Peak_step(:) = NaN;
T_StpSlowFR.Peak_return(:) = NaN;
T_StpSlowFR.Properties.VariableNames{11} = 'Rest'; % was V_m
T_StpSlowFR.Rest(:) = NaN;
T_StpSlowFR.Properties.VariableNames{17} = 'frXv_corr';
T_StpSlowFR.frXv_corr(:) = NaN;
T_StpSlowFR.TimeToPeak(:) = NaN;
T_StpSlowFR.Area(:) = NaN;

cids = unique(T_StpSlowFR.CellID);


if (DEBUG)
    fig = figure;
    fig.Position = [680    96   560   880];
    ax1 = subplot(2,1,1,'parent',fig);
    ax2 = subplot(2,1,2,'parent',fig);
end

for c = 1:length(cids)
    cid = cids{c};
    fprintf(1,'Cell %s\n',cid);
    cidx = strcmp(T_StpSlowFR.CellID,cid);
    positions = unique(T_StpSlowFR.Position(cidx));
    
    for position = positions(:)'
        % get the trials for each speed and displacement, average and calculate amplitude, area, time
        % to peak
        fprintf(1,'Position %d\n',position);
        posidx = T_StpSlowFR.Position == position;
        
        displacements = unique(T_StpSlowFR.Displacement(cidx&posidx));
        
        if DEBUG %%&& -10==displacement(D) && (strcmp(cid,'180404_F1_C1') || strcmp(cid,'180703_F3_C1'))
            cla(ax1); ax1.NextPlot = 'add';
            cla(ax2); ax2.NextPlot = 'add';
        end
        for displacement = displacements(:)'
            
            fprintf(1,'\tDisplacement %d\n',displacement);
            dspidx = T_StpSlowFR.Displacement(:)==displacement;
            
            ridx = cidx & posidx & dspidx;
            if ~sum(ridx)
                continue
            end
            
            % sum(ridx)
            Row = T_StpSlowFR(ridx,:);
            group = Row.Trialnums{:};
            if isempty(group)
                continue
            end
            trialStem = fullfile(fileparts(Row.TableFile{:}),[Row.Protocol{:} '_Raw_' Row.CellID{:} '_%d.mat']); trialStem = regexprep(trialStem,'\\','\\\');
            trial = load(sprintf(trialStem,group(1)));
            t = makeInTime(trial.params); t = t(:)';
            DT_step = abs(Row.Displacement)/Row.Speed;
            DT_return = trial.params.stimDurInSec-DT_step;
            DT_step = round((DT_step+trial.params.preDurInSec)*trial.params.sampratein)+1;
            DT_return = round((DT_return+trial.params.preDurInSec)*trial.params.sampratein)+1;
            
            v_ = nan(length(t),length(group));
            spikes_ = v_;
            
            for cnt = 1:length(group)
                trial = load(sprintf(trialStem,group(cnt)));
                if isfield(trial,'excluded') && trial.excluded
                    continue
                end
                if ~isfield(trial,'spikes') || isempty(trial.spikes)
                    continue
                end
                v_(:,cnt) = trial.voltage_1;
                
                spikes_(:,cnt) = 0;
                spikes_(trial.spikes,cnt) = 1;
                
            end
            if all(isnan(v_(:)))
                continue
            end
            % ignore the prepulse
            twind = t>-trial.params.preDurInSec+.06;
            
            DT = 10/300;
            fr = firingRate(t,spikes_,10/300);
            area = cumtrapz(t,fr); area = area-area(find(t<=0,1,'last'));
            
            % look for the peak response, either hyperpolarization or
            % depolarization, following the stimulus, before the off
            % step
            switch sign(displacement)
                case -1 % extension
                    [~,ttpk] = max(fr(t>0 & t<t(DT_return)));
                case 1 % flexion
                    [~,ttpk] = min(fr(t>0 & t<t(DT_return)));
            end
            ttpk = ttpk+trial.params.preDurInSec*trial.params.sampratein+1;
            
            T_StpSlowFR.Rest(ridx) = mean(fr(twind & t<0));
            T_StpSlowFR.Peak(ridx) = mean(fr(ttpk+[-10 10]));
            T_StpSlowFR.Peak_step(ridx) = mean(fr(DT_step+[-10 10]));
            T_StpSlowFR.Peak_return(ridx) = mean(fr(DT_return+[-10 10]));
            T_StpSlowFR.TimeToPeak(ridx) = t(ttpk);
            T_StpSlowFR.Area(ridx) = area(DT_return);
            
            v = nanmean(v_,2);
            base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            
            R = corrcoef(fr(twind)-mean(fr(twind)),v(twind)-mean(v(twind)));
            if R(1,2)>1
                stop;
            end
            T_StpSlowFR.frXv_corr(ridx) = R(1,2);
            
            if DEBUG %%&& -10==displacement(D) && (strcmp(cid,'180404_F1_C1') || strcmp(cid,'180703_F3_C1'))
                groupid = [cid]; % ': [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
                title(ax1,groupid); hold(ax1,'on')
                plot(ax1,t,v);
                plot(ax1,[t(1) t(find(t<0,1,'last'))],T_StpSlowFR.Rest(ridx)*[1 1],'Color',[.8 .8 .8]);
                plot(ax1,t,fr);
                plot(ax1,t(ttpk),T_StpSlowFR.Peak(ridx),'o');
                
                ax1.XLim = [t(1) t(end)];
                
                plot(ax2,v(twind),fr(twind));
                drawnow
                %pause();
                pause(.02)
                
            end
        end
    end
end

% if DEBUG
%     close(ax.Parent)
% end

