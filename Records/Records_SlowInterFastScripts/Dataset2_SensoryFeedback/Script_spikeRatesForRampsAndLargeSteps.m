% Do stuff with the spike rate of slow neurons

DEBUG =0;

T_RmpStpSlowFR = T_RampAndStep(strcmp(T_RampAndStep.Cell_label,'slow'),:);
cids = unique(T_RmpStpSlowFR.CellID);

T_RmpStpSlowFR.Peak(:) = NaN;
T_RmpStpSlowFR.Peak_step(:) = NaN;
T_RmpStpSlowFR.Peak_return(:) = NaN;
T_RmpStpSlowFR.Properties.VariableNames{11} = 'Rest'; % was V_m
T_RmpStpSlowFR.Rest(:) = NaN;
T_RmpStpSlowFR.Properties.VariableNames{17} = 'frXv_corr';
T_RmpStpSlowFR.frXv_corr(:) = NaN;
T_RmpStpSlowFR.TimeToPeak(:) = NaN;
T_RmpStpSlowFR.Area(:) = NaN;

if (DEBUG)
    fig = figure;
    fig.Position = [680    96   560   880];
    ax1 = subplot(2,1,1,'parent',fig);
    ax2 = subplot(2,1,2,'parent',fig);
end

% just go through each row and add the spike data
ridx = T_RmpStpSlowFR.Speed(:)==Inf;
for r = 1:height(T_RmpStpSlowFR)
    ridx(:) = false;
    ridx(r) = 1;
    
    Row = T_RmpStpSlowFR(ridx,:);
    if DEBUG && ~strcmp(fig.Tag,Row.CellID)
        cla(ax1); ax1.NextPlot = 'add';
        cla(ax2); ax2.NextPlot = 'add';
    end

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
        if ~isfield(trial,'spikes')
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
    switch sign(Row.Displacement)
        case -1 % extension
            [~,ttpk] = max(fr(t>0 & t<t(DT_return)));
        case 1 % flexion
            [~,ttpk] = min(fr(t>0 & t<t(DT_return)));
    end
    ttpk = ttpk+trial.params.preDurInSec*trial.params.sampratein+1;
    
    T_RmpStpSlowFR.Rest(ridx) = mean(fr(twind & t<0));
    T_RmpStpSlowFR.Peak(ridx) = mean(fr(ttpk+[-10 10]));
    T_RmpStpSlowFR.Peak_step(ridx) = mean(fr(DT_step+[-10 10]));
    T_RmpStpSlowFR.Peak_return(ridx) = mean(fr(DT_return+[-10 10]));
    T_RmpStpSlowFR.TimeToPeak(ridx) = t(ttpk);
    T_RmpStpSlowFR.Area(ridx) = area(DT_return);
    
    v = nanmean(v_,2);
    base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
    v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
    
    R = corrcoef(fr(twind)-mean(fr(twind)),v(twind)-mean(v(twind)));
    if R(1,2)>1
        stop;
    end
    T_RmpStpSlowFR.frXv_corr(ridx) = R(1,2);
    
    if DEBUG
        title(ax1,Row.CellID); hold(ax1,'on')
        fig.Tag = Row.CellID{1};
        plot(ax1,t,v);
        plot(ax1,[t(1) t(find(t<0,1,'last'))],T_RmpStpSlowFR.Rest(ridx)*[1 1],'Color',[.8 .8 .8]);
        plot(ax1,t,fr);
        plot(ax1,t(ttpk),T_RmpStpSlowFR.Peak(ridx),'o');
        
        ax1.XLim = [t(1) t(end)];
        
        plot(ax2,v(twind),fr(twind));
        drawnow
        %pause();
        pause(.02)
    end
end

