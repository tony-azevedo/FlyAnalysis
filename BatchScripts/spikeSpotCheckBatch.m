function h = spikeSpotCheckBatch(trialStem,trialnumlist,inputToAnalyze,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('spikes','');
parse(p,varargin{:});

spikes = p.Results.spikes;

spotCheckFig = figure; clf;
spotCheckFig.Position = [140          308        1600         670];
spotCheckFig.Color = [1 1 1];
spotCheckFig.Interruptible = 'off';
spotCheckFig.BusyAction = 'cancel';

panl = panel(spotCheckFig);

vertdivisions = [2,1,4]; vertdivisions = num2cell(vertdivisions/sum(vertdivisions));
panl.pack('v',vertdivisions)  % response panel, stimulus panel
panl.margin = [20 20 10 10];
panl.fontname = 'Arial';
panl(3).pack('h',{1/3 2/3})
panl(1).marginbottom = 2;
panl(2).margintop = 2;

% Top figure is the trial voltage,
% next is the filtered trial
% Third row
% on the left is histogram and spike dot
% Then snippet, spike highlighted, with template on top of it and 2nd
% derivative

% Plot unfiltered data
ax_main = panl(1).select(); ax_main.Tag = 'main';

% Plot filtered data
ax_filtered = panl(2).select(); ax_filtered.Tag = 'filtered';

% linkaxes([ax_main ax_filtered],'x');

% Plot cumulative histogram of targetSpikeDist
ax_hist = panl(3,1).select(); ax_hist.Tag = 'hist';
title(ax_hist,'Histogram'); xlabel(ax_hist,'DTW Distance');

% Examine each spike
ax_detect = panl(3,2).select(); ax_detect.Tag = 'detect';
title(ax_detect,'Is this a spike? In the right place?');

ax_hist.ButtonDownFcn = @spotCheck;
spotCheckFig.KeyPressFcn = @spotCheck;

trial = load(sprintf(trialStem,trialnumlist(1)));
vars = trial.spikeDetectionParams;

window = -floor(vars.spikeTemplateWidth/2): floor(vars.spikeTemplateWidth/2);
smthwnd = (vars.fs/2000+1:length(window)-vars.fs/2000);

% average the spikes that are really good
spikeaverage = mean(spikes.detectedUFSpikeCandidates_acrossCells(:,...
    spikes.targetSpikeDist_acrossCells > prctile(spikes.targetSpikeDist_acrossCells,25) & ...
    spikes.targetSpikeDist_acrossCells < prctile(spikes.targetSpikeDist_acrossCells,65))...
    ,2);
spikeaverage = spikeaverage-spikeaverage(1);

spikeWaveform = spikeaverage;
spikeWaveform = smooth(spikeWaveform-spikeWaveform(1),vars.fs/2000);
spikeWaveform_ = smoothAndDifferentiate(spikeWaveform,vars.fs/2000);
% normalize
spikeWaveform_ = spikeWaveform_-spikeWaveform_(smthwnd(1));

[pk,ttpk] = max(spikeWaveform_(smthwnd));
spikeWaveform_ = spikeWaveform_/pk * max(spikeWaveform);

ttpk = ttpk+smthwnd(1)-1;
% center the spike window over the spike
spikewindow = window+floor(vars.spikeTemplateWidth/2)-ttpk+1;

% plot the 2nd D and the average spike in the back ground
suspectUF_ddT2l = plot(ax_detect,...
    spikewindow(smthwnd),spikeWaveform_(smthwnd),...
    'color',[0 .8 .4],'linewidth',2,'tag','spike_ddT'); hold(ax_detect,'on')
suspectUF_ave = plot(ax_detect,...
    spikewindow,spikeWaveform,...
    'color',[.4 .3 1],'linewidth',2,'tag','spike_ave');
suspect_spike = raster(ax_detect,0,max(spikeWaveform));
suspect_spike.Tag = 'spike_time';
suspect_spike.UserData = min(suspect_spike.YData)-max(spikeWaveform);

% ax_fltrd_suspect = panl(2,1).select(); ax_fltrd_suspect.Tag = 'fltrd_suspect';     hold(ax_fltrd_suspect,'on');
% ax_unfltrd_suspect = panl(2,2).select(); ax_unfltrd_suspect.Tag = 'unfltrd_suspect';  hold(ax_unfltrd_suspect,'on');
% ax_fltrd_notsuspect = panl(2,3).select(); ax_fltrd_notsuspect.Tag = 'fltrd_notsuspect';  hold(ax_fltrd_notsuspect,'on');
% ax_unfltrd_notsuspect = panl(2,4).select(); ax_unfltrd_notsuspect.Tag = 'unfltrd_notsuspect';  hold(ax_unfltrd_notsuspect,'on');
%

t = makeInTime(trial.params);
for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));
    fprintf('Trial %d (%d of %d)\n',tr_idx,find(tr_idx==trialnumlist),length(trialnumlist));
    title(ax_main,sprintf('Trial %d (%d of %d)',tr_idx,find(tr_idx==trialnumlist),length(trialnumlist)));
    if isfield(trial,'excluded') && trial.excluded
        fprintf(' * Trial excluded: %s\n',trial.name)
        continue
    end
    if isfield(trial,'spikeSpotChecked') && trial.spikeSpotChecked
        fprintf(' * Trial spot checked already: %s\n',trial.name)
        continue
    end
    spotCheckFig.UserData = trial;
    
    unfiltered_data = filterMembraneVoltage(trial.(inputToAnalyze),trial.params.sampratein);
    if isempty(findobj(ax_main,'tag','unfiltered_data'))
        plot(ax_main,t,unfiltered_data,'color',[.85 .33 .1],'tag','unfiltered_data'), hold(ax_main,'on');
        axis(ax_main,'off');
    else
        gobj = findobj(ax_main,'tag','unfiltered_data');
        gobj.YData = unfiltered_data;
    end
    
    vars = trial.spikeDetectionParams;
    vars.unfiltered_data = unfiltered_data;
    all_filtered_data = filterDataWithSpikes(vars);
    
    if isempty(findobj(ax_filtered,'tag','filtered_data'))
        plot(ax_filtered,t,all_filtered_data-mean(all_filtered_data),'color',[.0 .45 .74],'tag','filtered_data'), hold(ax_filtered,'on');
        axis(ax_filtered,'off');
    else
        gobj = findobj(ax_filtered,'tag','filtered_data');
        gobj.YData = all_filtered_data-mean(all_filtered_data);
    end

    % Get out all the potential spikes from the input structure
    cla(ax_hist)
    sDs = spikes.targetSpikeDist_acrossCells(spikes.trialnumids == tr_idx);
    spikes_byPeak = spikes.spikes_acrossCells(spikes.trialnumids == tr_idx);
    [dist, order] = sort(sDs);
    cumy = (1:length(dist))/length(dist);
    distcumhist = plot(ax_hist,dist,cumy,'o','markeredgecolor',[0 0.45 0.74],'tag','distance_hist'); hold(ax_hist,'on');
    plot(ax_hist,vars.Distance_threshold*[1 1],[0 1],'color',[1 0 0],'tag','threshold');
    
    % assumption: spikes in the trial have a match in the input structure,
    % even if they actually have been moved. Create a map
    spikes_map = nan(size(spikes_byPeak));
    for s = trial.spikes
        % find the closest spike in the according to peak
        idxdiff = abs(spikes_byPeak-s);
        spikes_map(idxdiff==min(idxdiff)) = s;
    end
    spikes_map = cat(1,spikes_map,spikes_byPeak);
    
    set(distcumhist,'Userdata',spikes_map(:,order));
    
    % plot the spikes as they've been selected thus far
    if isempty(findobj(ax_main,'tag','raster_ticks'))
        suspect_ticks = raster(ax_main,t(trial.spikes),max(trial.(inputToAnalyze))+.02*diff([min(trial.(inputToAnalyze)) max(trial.(inputToAnalyze))]));
        set(suspect_ticks,'tag','raster_ticks');
    else
        gobj = findobj(ax_main,'tag','raster_ticks');
        delete(gobj);
        suspect_ticks = raster(ax_main,t(trial.spikes),max(trial.(inputToAnalyze))+.02*diff([min(trial.(inputToAnalyze)) max(trial.(inputToAnalyze))]));
        set(suspect_ticks,'tag','raster_ticks');
    end

    spotCheck(ax_hist,[]);
    
    uiwait();
        
    if ~isvalid(spotCheckFig)
        h = [];
        return
    end
    
end
ax_hist.ButtonDownFcn = [];
spotCheckFig.KeyPressFcn = [];

title(ax_main,'Done with spot check');
title(ax_hist,'Done with spot check');
title(ax_detect,'Done with spot check');
end


