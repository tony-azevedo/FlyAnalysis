%% Plot probe position, spikes, membrane potential for target trigered stimuli

for cnt = 1:length(dirstimset)
    dirstims = dirstimset{cnt};
    sllim = sllims{cnt};

    f = figure;
    cueax = subplot(4,2,1,'parent',f);              cueax.NextPlot = 'add';
    stimax = subplot(4,2,2,'parent',f);             stimax.NextPlot = 'add';
    cuesppax = subplot(4,2,5,'parent',f);       cuesppax.NextPlot = 'add';
    stimsppax = subplot(4,2,6,'parent',f);      stimsppax.NextPlot = 'add';
    cuevax = subplot(4,2,3,'parent',f);            cuevax.NextPlot = 'add';
    stimvax = subplot(4,2,4,'parent',f);           stimvax.NextPlot = 'add';
    cuefrax = subplot(4,2,7,'parent',f);              cuefrax.NextPlot = 'add';
    stimfrax = subplot(4,2,8,'parent',f);             stimfrax.NextPlot = 'add';

    trial = load(sprintf(trialStem,dirstims.trial(1)));
    t = makeInTime(trial.params);
    x_cue = - trial.params.cueDelayDurInSec - trial.params.cueStimDurInSec;
    cuewin = ...
        t >= x_cue-.2 & ...
        t < x_cue + trial.params.cueStimDurInSec+trial.params.cueDelayDurInSec;
    cuelims = t(cuewin);
    cuelims = cuelims([1,end]);

    cuespike_mat = zeros(height(dirstims),sum(cuewin));
    stimspike_mat = zeros(height(dirstims),sum(cuewin));

    vcue = nan(height(dirstims),sum(cuewin));
    vstim = nan(height(dirstims),sum(cuewin));

    pp_stim = zeros(height(dirstims),1);

    for r = 1:height(dirstims)
        trial = load(sprintf(trialStem,dirstims.trial(r)));

        % plot cues
        % plot(cueax,t(cuewin),trial.sgsmonitor(cuewin));
        plot(cueax,t(cuewin)-x_cue,-trial.probe_position(cuewin),'tag',num2str(trial.params.trial));

        % plot cue spikes
        spikes = t(trial.spikes(trial.spikes<length(t)));
        spike_idx = trial.spikes(spikes>=cuelims(1) & spikes<=cuelims(2)) - sum(t<cuelims(1));
        % fill in spike mat
        cuespike_mat(r,spike_idx) = 1;

        vcue(r,1:sum(cuewin)) = trial.voltage_1(cuewin);

        % find the next cue
        stimwin = t>0;
        stimgt0 = trial.sgsmonitor(stimwin);
        ppgt0 = trial.probe_position(stimwin);
        tgt0 = t(stimwin);
        st0 = mean(stimgt0(1:1000));
        if sllim(1) < st0
            ramp10 = find(stimgt0<sllim(1),1,'first'); % these are flexion stimuli
            ramp90 = find(stimgt0<sllim(2),1,'first');
        else
            ramp10 = find(stimgt0>sllim(1),1,'first'); % these are flexion stimuli
            ramp90 = find(stimgt0>sllim(2),1,'first');
        end
        sl = polyfit(tgt0(ramp10:ramp90),stimgt0(ramp10:ramp90),1);
        x = (st0-sl(2))/sl(1);
        [~,min_idx] = min(abs(tgt0-x));
        x = tgt0(min_idx);
        tt_stim(r) = x;

        stimwin = ...
            t >= x-.2 & ...
            t < x+ trial.params.cueStimDurInSec+trial.params.cueDelayDurInSec;
        if sum(stimwin)>sum(cuewin)
            stimwin(find(stimwin,sum(stimwin)-sum(cuewin),'last')) = 0;
        end
        stimlims = t(stimwin);
        stimlims = stimlims([1,end]);

        % plot tt stims
        %     plot(stimax,tgt0(stimwin)-x,stimgt0(stimwin));
        plot(stimax,t(stimwin)-x,-trial.probe_position(stimwin),'tag',num2str(trial.params.trial));

        % Find the probe position at the time of the stimulus
        [~,min_idx] = min(abs(t-x));
        pp_stim(r) =  -trial.probe_position(min_idx);

        spikes = t(trial.spikes(trial.spikes<length(t)));
        spike_idx = trial.spikes(spikes>=stimlims(1) & spikes<=stimlims(2)) - sum(t<stimlims(1));
        stimspike_mat(r,spike_idx) = 1;

        vstim(r,1:sum(stimwin)) = trial.voltage_1(stimwin);
        % fill in spike mat

    end

    t_ = t(cuewin)-x_cue;

    % plot voltage for sanity sake
    %plot(cuevax,t_,nanmean(vcue,1));
    %plot(stimvax,t_,nanmean(vstim,1));
    plot(cuevax,t_,trial.sgsmonitor(cuewin));
    plot(stimvax,t_,trial.sgsmonitor(cuewin));

    % divide up according to position, i.e probe position at time of stim
    medpp = median(pp_stim);
    lo_rows = find(pp_stim<=medpp);
    lo_pp = pp_stim(pp_stim<=medpp);
    [~,order] = sort(lo_pp);
    lo_rows = lo_rows(order);

    hi_rows = find(pp_stim>medpp);
    hi_pp = pp_stim(pp_stim>medpp);
    [~,order] = sort(hi_pp);
    hi_rows = hi_rows(order);

    cuefr = firingRate(t(cuewin),cuespike_mat,.08);
    plot(cuefrax,t_,cuefr,'displayname','all')

    % lo probe position cues
    lo_rast = cuespike_mat(lo_rows,:);
    cuefr_lo = firingRate(t_,lo_rast,.08);
    plot(cuefrax,t_,cuefr_lo,'displayname','slow')
    for r = 1:size(lo_rast,1)
        raster(cuesppax,t_(logical(lo_rast(r,:))),r,'YLim',[0 10],'color',[1,0,0]);
    end
    % hi probe position cues
    hi_rast = cuespike_mat(hi_rows,:);
    cuefr_hi = firingRate(t_,hi_rast,.08);
    plot(cuefrax,t_,cuefr_hi,'displayname','slow')
    for r = 1:size(hi_rast,1)
        raster(cuesppax,t_(logical(hi_rast(r,:))),r+size(lo_rast,1)+2,'YLim',[0 10]);
    end

    stimfr = firingRate(t_,stimspike_mat,.08);
    plot(stimfrax,t_,stimfr,'displayname','fast')
    
    % lo probe position trials
    t_ = t(cuewin)-x_cue;
    lo_rast = stimspike_mat(lo_rows,:);
    %     stimfr_lo = firingRate(t_,lo_rast(1:round(size(lo_rast,1))/2,:),.08);
    %     stimfr_lo = firingRate(t_,lo_rast(round(size(lo_rast,1)/2):end,:),.08);
    stimfr_lo = firingRate(t_,lo_rast,.08);
    
    plot(stimfrax,t_,stimfr_lo,'displayname','slow')
    for r = 1:size(lo_rast,1)
        raster(stimsppax,t_(logical(lo_rast(r,:))),r,'YLim',[0 10],'color',[1,0,0]);
    end

    % hi probe position trials
    hi_rast = stimspike_mat(hi_rows,:);
    stimfr_hi = firingRate(t_,hi_rast,.08);
    plot(stimfrax,t_,stimfr_hi,'displayname','slow')
    for r = 1:size(hi_rast,1)
        raster(stimsppax,t_(logical(hi_rast(r,:))),r+size(lo_rast,1)+2,'YLim',[0 10]);
    end

end

