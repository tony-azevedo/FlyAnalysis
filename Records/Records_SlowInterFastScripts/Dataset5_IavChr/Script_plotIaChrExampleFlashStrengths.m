%% choosing exemplars for the iav figure
% 
% T_input = T_iavChrFlash;
% 
% %% or
% T_input = T_iavChrFlash(contains(T_iavChrFlash.CellID,'180702_F1_C1'),:);
% 
% %% or
% T_input = T_iavChrFlash(...
%                 contains(T_iavChrFlash.CellID,'180702_F1_C1') ...
%               & 0.0316 == round(T_iavChrFlash.FlashStrength*1E4)/1E4...
%               ,:);

%%
for row = 1:height(T_input)
    
    T_row = T_input(row,:);
        
    group = T_row.Trialnums{1};   
    D = fileparts(T_row.TableFile{1}); cd (D)
    trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];

    trial = load(sprintf(trialStem,group(1)));
    t = makeInTime(trial.params); t = t(:)';
    ft = makeFrameTime(trial);
    
    % where to look for V_m peak
    vp_win = t>0&t<.04;
    % where to look for V_m trough
    vt_win = t>0&t<.15;
    
    % where to look for probe peak
    pp_win = ft>0&ft<.04;
    % where to look for probe trough
    %pt_win = ft>0&ft<.04;
    
    v_ = nan(length(t),length(group));
    probe_ = nan(length(ft),length(group));
    
    if isfield(trial,'spikes')
        spikes = v_;
    end
    for cnt = 1:length(group)
        trial = load(sprintf(trialStem,group(cnt)));
        if isfield(trial,'excluded') && trial.excluded
            continue
        end
        
        % Maybe there are differences in how long the trial is
        try v_(:,cnt) = trial.voltage_1(1:size(v_,1));
        catch e
            if strcmp(e.identifier,'MATLAB:subsassigndimmismatch') || strcmp(e.identifier,'MATLAB:badsubscript')
                if length(trial.voltage_1) < max(size(v_))
                    v_(1:length(trial.voltage_1),cnt) = trial.voltage_1;
                else
                    rethrow(e)
                end
            else
                rethrow(e)
            end
        end
        % collect the probe minimum
        
        % Maybe there are small errors in the alignment
        CoM = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
        try probe_(:,cnt) = CoM;
        catch e
            if strcmp(e.identifier,'MATLAB:subsassigndimmismatch')
                if length(trial.forceProbeStuff.CoM) < max(size(probe_))
                    probe_(1:length(CoM),cnt) = CoM;
                else
                    probe_(:,cnt) = CoM(1:max(size(probe_)));
                end
            else
                rethrow(e)
            end
        end
        
        if isfield(trial,'spikes')
            spikes(:,cnt) = 0;
            spikes(trial.spikes,cnt) = 1;
        end
        
    end
    if all(isnan(v_(:)))
        %continue
    end
    
    v = nanmean(v_,2);
    base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
    [peak_v,vttpk] = max(v(vp_win)-base); vttpk = vttpk+sum(t<=0);
    [trough_v,vtttr] = min(v(vt_win & t>t(vttpk))-base); vtttr = vtttr+sum(t<=t(vttpk));
    
    probe = nanmean(probe_,2);
    
    if isfield(trial,'spikes')
        DT = 10/300;
        fr = firingRate(t,spikes,10/300);
        Rest = mean(fr(t>-.1 &t<0));
        [peak_fr,frttpk] = max(fr(vp_win)-Rest); frttpk = frttpk+sum(t<=0);
        [trough_fr,frtttr] = min(fr(vt_win & t>t(frttpk))-Rest); frtttr = frtttr+sum(t<=t(frttpk));
    else
        Rest = NaN;
        peak_fr = NaN;
        trough_fr = NaN;
    end
    
    Start_probe = mean(probe(ft<0));
    area = cumtrapz(ft,probe - Start_probe); area = area-area(find(ft<=0,1,'last'));
    exttime = ft(find(area(ft>0)<-.05,1,'first')+sum(ft<0));
    extflag = ~isempty(exttime) && exttime < .1; % indicates the probe has gone negative
    
    % Decide if the fly lets go
    zthresh = 5;
    if min(probe) <= zthresh && sum(probe < zthresh) >= 2
        % the fly lets go of the probe
        
        [Trough_probe,ptttr] = min(probe(ft>0)); ptttr = ptttr + sum(ft<=0);
        releasePeriod = probe < min(probe)+zthresh;
        releaseSegment = ft(releasePeriod);
        ReleaseDuration = releaseSegment(end)-releaseSegment(1);
        
        [Peak_probe,pttpk] = max(probe(ft<ft(ptttr)&ft>=0)); pttpk = pttpk + sum(ft<=0);
        if isempty(Peak_probe) || Peak_probe <= probe(find(ft>0,1,'first'))
            Peak_probe = nan; pttpk = nan;
        end
    elseif min(probe) > zthresh || sum(probe < zthresh) < 2
        % the fly does not let go of the probe
        ReleaseDuration = nan;
        if extflag
            % the fly extends but does not let go of the probe
            [Trough_probe,ptttr] = min(probe(ft>0)); ptttr = ptttr + sum(ft<=0);
            % Get whatever peak is before the extension
            [Peak_probe,pttpk] = max(probe(ft<ft(ptttr)&ft>0)); pttpk = pttpk + sum(ft<=0);
            if Peak_probe <= probe(find(ft>0,1,'first'))
                Peak_probe = nan; pttpk = nan;
            end
        elseif ~extflag
            % if the fly first flexes, I care about the peak
            [Peak_probe,pttpk] = max(probe(ft>0)); pttpk = pttpk + sum(ft<=0);
            Trough_probe = nan; ptttr = nan;
        end
    end
    
    
    if strcmp(T_row.Cell_label,'slow')
        dbfig = figure;
        dbfig.Position = [680 32 689 964];
        ax1 = subplot(3,1,1,'parent',dbfig); ax1.NextPlot = 'add';
        ax1_5 = subplot(3,1,2,'parent',dbfig); ax1_5.NextPlot = 'add';
        ax2 = subplot(3,1,3,'parent',dbfig); ax2.NextPlot = 'add';
        cla(ax1_5)
        plot(ax1_5,t,fr,'color',[0 0 0]);
        [peak_fr,frttpk] = max(fr(vp_win)-base); frttpk = frttpk+sum(t<=0);
        [trough_fr,frtttr] = min(fr(vt_win & t>t(frttpk))-base); frtttr = frtttr+sum(t<=t(frttpk));
        plot(ax1_5,t(frttpk),peak_fr+base,'marker','o','color',[1 0 0]);
        plot(ax1_5,t(frtttr),trough_fr+base,'marker','o','color',[0 .6 0]);
    else
        ax1 = subplot(2,1,1,'parent',dbfig); ax1.NextPlot = 'add';
        ax2 = subplot(2,1,2,'parent',dbfig); ax2.NextPlot = 'add';
    end
    cla(ax1)
    cla(ax2)
    groupid = [cellid ' (' num2str(T_row.FlashStrength) ',', T_row.Drug{1} '): [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
    title(ax1,regexprep(groupid,'\_','\\_'));
    plot(ax1,t,v_,'color',[1 .7 .7]);
    plot(ax1,t,v,'color',[.7 0 0]);
    plot(ax1,t(vttpk),peak_v+base,'marker','o','color',[1 0 0]);
    plot(ax1,t(vtttr),trough_v+base,'marker','o','color',[0 .6 0]);
    
    for cnt = 1:length(group)
        plot(ax2,ft,probe_(:,cnt),'color',[.7 .7 1],'tag',num2str(group(cnt)));
    end
    plot(ax2,ft,probe,'color',[0 0 .7]);
    %plot(ax2,ft([1 length(ft)]),[0 0],'color',[.7 .7 .7]);
    
    if ~isnan(Peak_probe)
        plot(ax2,ft(pttpk),Peak_probe,'marker','o','color',[0 1 0]);
    end
    if ~isnan(Trough_probe)
        plot(ax2,ft(ptttr),Trough_probe,'marker','o','color',[.6 .68 .1]);
    end
    if ~isnan(ReleaseDuration)
        plot(ax2,ft(releasePeriod),probe(releasePeriod),'color',[1 0 0],'linewidth',2);
    end
    
    drawnow
    %pause
    
end
