function h = spikeSpotCheck(trial,inputToAnalyze,varargin)

if isfield(trial,'excluded') && trial.excluded
    fprintf(' * Trial excluded: %s\n',trial.name)
    h = [];
    return
end

if isempty(trial.spikes)
    fprintf(' * No spikes to double check. Run the detection algorithm again\n')
end

% if length(unique(trial.spikes))~=length(trial.spikes)
%     fprintf(' * Duplicate spikes found. Removing.\n')
%     trial.spikes = unique(trial.spikes);
%     save(trial.name, '-struct', 'trial');
% end

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

% trial = load(sprintf(trialStem,trialnumlist(1)));
vars = cleanUpSpikeVarsStruct(trial.spikeDetectionParams);

window = -floor(vars.spikeTemplateWidth/2): floor(vars.spikeTemplateWidth/2);
smthwnd = (vars.fs/2000+1:length(window)-vars.fs/2000);
idx_i = round(vars.spikeTemplateWidth/6);

spikewindow = window-floor(vars.spikeTemplateWidth/2);

detectedUFSpikeCandidates = [];
targetSpikeDist = [];

% Rerun the detection with the current parameters to see what it would have
% found
spikeDetectSingleTrial(trial,inputToAnalyze)
% vars.locs has is relative to beginning of the trial

% Correct each detected spike to find its inflection point
vars = estimateSpikeTimeFromInflectionPoint(vars,detectedUFSpikeCandidates,targetSpikeDist);

spikeWaveform = vars.spikeWaveform;
spikeWaveform_ = vars.spikeWaveform_;
[pk,ttpk] = max(spikeWaveform_(smthwnd));
spikeWaveform_ = spikeWaveform_/pk * max(spikeWaveform);

ttpk = ttpk+smthwnd(1)-1;
% center the spike window over the spike
spikewindow = window+floor(vars.spikeTemplateWidth/2)-ttpk+1;

% plot the 2nd D and the average spike in the back ground
plot(ax_detect,...
    spikewindow(smthwnd),spikeWaveform_(smthwnd),...
    'color',[0 .8 .4],'linewidth',2,'tag','spike_ddT'); hold(ax_detect,'on')
plot(ax_detect,...
    spikewindow,spikeWaveform,...
    'color',[.4 .3 1],'linewidth',2,'tag','spike_ave');
suspect_spike = raster(ax_detect,0,max(spikeWaveform));
suspect_spike.Tag = 'spike_time';
suspect_spike.UserData = min(suspect_spike.YData)-max(spikeWaveform);

title(ax_main,sprintf('Trial %d ',trial.params.trial));
spotCheckFig.UserData = trial;
    
t = makeInTime(trial.params);
vars.unfiltered_data = filterMembraneVoltage(trial.(inputToAnalyze),trial.params.sampratein);
if isempty(findobj(ax_main,'tag','unfiltered_data'))
    plot(ax_main,t,vars.unfiltered_data,'color',[.85 .33 .1],'tag','unfiltered_data'), hold(ax_main,'on');
    axis(ax_main,'off');
else
    gobj = findobj(ax_main,'tag','unfiltered_data');
    gobj.YData = vars.unfiltered_data;
end

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
[dist, order] = sort(targetSpikeDist);
cumy = (1:length(dist))/length(dist);
distcumhist = plot(ax_hist,dist,cumy,'o','markeredgecolor',[0 0.45 0.74],'tag','distance_hist'); hold(ax_hist,'on');
plot(ax_hist,vars.Distance_threshold*[1 1],[0 1],'color',[1 0 0],'tag','threshold');
    
% assumption: spikes in the trial have a match in the input structure,
% even if they actually have been moved. Create a map
spikes_map = nan(size(vars.locs));
for s = trial.spikes(:)'
    % find the closest spike in the according to peak
    idxdiff = abs(vars.locs-s);
    spikes_map(idxdiff==min(idxdiff)) = s;
end
spikes_map = cat(1,spikes_map,vars.locs);

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
    

ax_hist.ButtonDownFcn = [];
spotCheckFig.KeyPressFcn = [];

title(ax_main,'Done with spot check');
title(ax_hist,'Done with spot check');
title(ax_detect,'Done with spot check');

    function spikeDetectSingleTrial(trial,inputToAnalyze)
        unfiltered_data = filterMembraneVoltage(trial.(inputToAnalyze),trial.params.sampratein);
        
        max_len = 400000;
        if length(unfiltered_data) < max_len
            vars.len = length(unfiltered_data)-round(.01*trial.params.sampratein);
        else
            vars.len = max_len -round(.01*trial.params.sampratein);
        end
        
        start_point = round(.01*vars.fs);
        stop_point = min([start_point+vars.len length(unfiltered_data)]);
        vars.unfiltered_data = unfiltered_data(start_point+1:stop_point);

        
        all_filtered_data = filterDataWithSpikes(vars);
        spike_locs = findSpikeLocations(vars,all_filtered_data);
        if any(spike_locs~=unique(spike_locs))
            error('Why are there multiple peak at the same time?')
        end
        

        % pool the detected spike candidates and do spike_params.spiketemplate matching
        targetSpikeDist = zeros(size(spike_locs));
        % norm_spikeTemplate was created in the wrapper function
        
        %window = (max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)))
        % Should have gotten rid of spikes near the beginning or end of the data
        window = -floor(vars.spikeTemplateWidth/2): floor(vars.spikeTemplateWidth/2);
        spikewindow = window-floor(vars.spikeTemplateWidth/2);
        
        detectedUFSpikeCandidates = nan(size(window(:),1),size(spike_locs(:),1));
        norm_spikeTemplate = (vars.spikeTemplate-min(vars.spikeTemplate))/(max(vars.spikeTemplate)-min(vars.spikeTemplate));

        % Get the waveforms associated with the detected spikes
        for sp=1:length(spike_locs)
            % in the case of a single location, the template doesn't match
            % the one coming out of seed template matching
            if min(spike_locs(sp)+vars.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(sp)-vars.spikeTemplateWidth/2,0)< vars.spikeTemplateWidth
                continue
            else
                curSpikeTarget = all_filtered_data(spike_locs(sp)+window);
                detectedUFSpikeCandidates(:,sp) = vars.unfiltered_data(spike_locs(sp)+spikewindow); 
                
                norm_curSpikeTarget = (curSpikeTarget-min(curSpikeTarget))/(max(curSpikeTarget)-min(curSpikeTarget));
                [targetSpikeDist(sp), ~,~] = dtw_WarpingDistance(norm_curSpikeTarget, norm_spikeTemplate);
            end
        end
                
        vars.locs = spike_locs+start_point;
    end

end


