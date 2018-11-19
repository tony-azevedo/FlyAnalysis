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

ax_hist = findobj('type','axes','tag','hist');
if ~isempty(ax_hist)
    spotCheckFig = ax_hist.Parent;
    ax_main = findobj(spotCheckFig,'type','axes','tag','main');
    ax_filtered = findobj(spotCheckFig,'type','axes','tag','filtered');
    ax_detect = findobj(spotCheckFig,'type','axes','tag','detect');
    ax_squigs = findobj(spotCheckFig,'type','axes','tag','squiggles');
    cla(ax_main)
    cla(ax_filtered)
    cla(ax_detect)
    cla(ax_squigs)
    cla(ax_hist);

    ax_hist.ButtonDownFcn = @spotCheck_XY;
    ax_hist.Parent.KeyPressFcn = @spotCheck_XY;

    figure(spotCheckFig);
    
else
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
    panl(3).pack('h',{1/4 3/8 3/8})
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
    
    % Plot cumulative histogram of targetSpikeDist
    ax_hist = panl(3,1).select(); ax_hist.Tag = 'hist';
    title(ax_hist,'Histogram'); xlabel(ax_hist,'DTW Distance');

    % Examine each spike
    ax_detect = panl(3,2).select(); ax_detect.Tag = 'detect';
    title(ax_detect,'Is this a spike? In the right place?');

    % Look at the filtered data too
    ax_squigs = panl(3,3).select(); ax_squigs.Tag = 'squiggles';
    title(ax_squigs,'Is this a spike? In the right place?');

    % trial = load(sprintf(trialStem,trialnumlist(1)));
end

vars = cleanUpSpikeVarsStruct(trial.spikeDetectionParams);

window = -floor(vars.spikeTemplateWidth/2): floor(vars.spikeTemplateWidth/2);
smthwnd = (vars.fs/2000+1:length(window)-vars.fs/2000);
idx_i = round(vars.spikeTemplateWidth/6);

spikewindow = window-floor(vars.spikeTemplateWidth/2);

detectedUFSpikeCandidates = [];
targetSpikeDist = [];
spikeAmplitude = [];

% Rerun the detection with the current parameters to see what it would have
% found
spikeDetectSingleTrial(trial,inputToAnalyze)
% vars.locs here is relative to beginning of the trial

% Correct each detected spike to find its inflection point
vars = estimateSpikeTimeFromInflectionPoint(vars,detectedUFSpikeCandidates,targetSpikeDist);

if length(unique(vars.locs))~=length(unique(vars.locs_uncorrected))
    error('SpikeInflection point detection is off');
end
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

plot(ax_squigs,...
    window,vars.spikeTemplate,...
    'color',[0.8500    0.3250    0.0980],'linewidth',1,'tag','templatesquig'); hold(ax_squigs,'on')

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
    
% assumption: spikes in the trial have a match in the input structure,
% even if they actually have been moved. Create a map
spikes_map = nan(size(vars.locs(:)));
for s = trial.spikes(:)'
    % find the closest spike in the according to peak
    idxdiff = abs(vars.locs-s); 
    spikes_map(idxdiff==min(idxdiff)) = s;
end
spikes_map = cat(2,spikes_map(:),vars.locs(:),vars.locs_uncorrected(:));

sDs_in = targetSpikeDist(~isnan(spikes_map(:,1)));
sDs_out = targetSpikeDist(isnan(spikes_map(:,1)));
amp_in = spikeAmplitude(~isnan(spikes_map(:,1)));
amp_out = spikeAmplitude(isnan(spikes_map(:,1)));

scat_out = plot(ax_hist,sDs_out,amp_out,'.','color',[0.9290 0.6940 0.1250],'markersize',10,'tag','distance_hist_out'); hold(ax_hist,'on');
scat_in = plot(ax_hist,sDs_in,amp_in,'.','color',[.0 .45 .74],'markersize',10,'tag','distance_hist_in'); hold(ax_hist,'on');
distthresh = plot(ax_hist,vars.Distance_threshold*[1 1],[min(spikeAmplitude) max(spikeAmplitude)],'color',[1 0 0],'tag','dist_threshold');
ampthresh = plot(ax_hist,[min(targetSpikeDist) max(targetSpikeDist)],vars.Amplitude_threshold*[1 1],'color',[1 0 0],'tag','amp_threshold');

ax_hist.YLim = distthresh.YData;
ax_hist.XLim = ampthresh.XData;

scat_in.UserData = spikes_map;

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

cmd = spotCheck_XY(ax_hist,[]);
h = [];

if ~isempty(cmd)
    h = cmd;
end

if ~isvalid(spotCheckFig)
    h = [];
    return
end
    
    function spikeDetectSingleTrial(trial,inputToAnalyze)
        %         if trial.params.gain_1==100 && strcmp(inputToAnalyze,'voltage_1')
        %             unfiltered_data = trial.(inputToAnalyze);
        %         else
        unfiltered_data = filterMembraneVoltage(trial.(inputToAnalyze),trial.params.sampratein);
        %         end
        
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
        

        if any(spike_locs~=unique(spike_locs))
            error('Why are there multiple peak at the same time?')
        end
        
        % norm_spikeTemplate = (spikeTemplate-min(spikeTemplate))/(max(spikeTemplate)-min(spikeTemplate));
        
        [detectedUFSpikeCandidates,...
            detectedSpikeCandidates,...
            norm_detectedSpikeCandidates,...
            targetSpikeDist,...
            spikeAmplitude,...
            window,...
            spikewindow] = ...
            getSquiggleDistanceFromTemplate(spike_locs,vars.spikeTemplate,all_filtered_data,vars.unfiltered_data,vars.spikeTemplateWidth,vars.fs);
        
        vars.locs = spike_locs+start_point;

    end

end


function varargout = spotCheck_XY(~,evntdata)

varargout = {''};

global context context_squigs current_spike current_tick current_dot suspect_spike 
global wind squigwind smthwind cntxtwnd t spike_idx spike trace trace_filtered trial direction tickYData ucspike
global cmd

% out color: [0.9290 0.6940 0.1250];
ax_hist = findobj('type','axes','tag','hist');
hObject = ax_hist;
trial = hObject.Parent.UserData;

hObject.Parent.CloseRequestFcn = {@(hObject,eventdata,handles) disp('Hit enter')};

hist_dots_in = findobj(hObject,'tag','distance_hist_in');
hist_dots_out = findobj(hObject,'tag','distance_hist_out');
if ~isempty(hist_dots_in)
    spikes_map = hist_dots_in.UserData;
    distthresh_line = findobj(hObject,'tag','dist_threshold');
    ampthresh_line = findobj(hObject,'tag','amp_threshold');
    dist_threshold = max(distthresh_line.XData);
    amp_threshold = max(ampthresh_line.YData);
end

ax_main = findobj(hObject.Parent,'Tag','main');
ax_filtered = findobj(hObject.Parent,'type','axes','tag','filtered');
ax_detect = findobj(hObject.Parent,'Tag','detect');
ax_squigs = findobj(hObject.Parent,'Tag','squiggles');

ticks = findobj(ax_main,'Tag','raster_ticks');

spike_ave = findobj(ax_detect,'Tag', 'spike_ave');
spike_ddT = findobj(ax_detect,'Tag', 'spike_ddT');
squigTplt = findobj(ax_squigs,'Tag', 'templatesquig');

if isempty(hist_dots_in)
    suspect_spike = findobj(ax_detect,'Tag', 'spike_time');
    suspect_spike.XData = 0 *[1 1];
    suspect_spike.YData = suspect_spike.YData - min(suspect_spike.YData)  + max(spike_ddT.YData);
    set(suspect_spike,'Userdata',spike);
    
    ax_detect.YLim = [...
        min([min(spike_ave.YData) min(spike_ddT.YData) min(suspect_spike.YData)]) ...
        max([max(spike_ave.YData) max(spike_ddT.YData) max(suspect_spike.YData)])];
    ax_detect.XLim = [spike_ave.XData(1) spike_ave.XData(end)];

end

if isempty(evntdata) && ~isempty(hist_dots_in)
    trace = findobj(ax_main,'Tag', 'unfiltered_data');
    trace_filtered = findobj(ax_filtered,'Tag', 'filtered_data');
    t = trace.XData;
    
    wind = spike_ave.XData;
    squigwind = squigTplt.XData;
    smthwind = spike_ddT.XData;
    suspect_spike = findobj(ax_detect,'Tag', 'spike_time');
    
    cntxtwnd = min(wind)*4:max(wind)*4;
    
    % start with the current spike, move either forward or back, allow all
    % the spikes to be cliked upon.
    % spike_idx = find(hist_dots.XData<threshold,1,'last');
    spike_idx = 1;
    spike = spikes_map(spike_idx,1);
    ucspike = spikes_map(spike_idx,3);
    
    if isempty(spike_idx) % there are no events larger than threshold
        spike_idx = 1;
        spike = spikes_map(spike_idx,1);
    end
    if isnan(spike)
        spike = spikes_map(spike_idx,2);
    end
    
    % fill in the current dot on the hist plot
    current_dot = plot(hObject,...
        hist_dots_in.XData(max([spike_idx 1])),...
        hist_dots_in.YData(max([spike_idx 1])),...
        'marker','o','markeredgecolor','none','markerfacecolor',[1 0 0],'tag','current_dot');
        
    % Find the current tick
    current_tick = findobj(ax_main,'type','line','XData',[t(spike) t(spike)],'tag','raster_ticks');
    if numel(current_tick)>1
        error('Found too many current raster ticks')
    elseif numel(current_tick)<1 % No ticks at all!
        if spike_idx == 0 % All spikes have been rejected so far
            spike_idx = 1;
            current_tick = raster(ax_main,t(spikes_map(2,1)),max(trace.YData)+.02*diff([min(trace.YData) max(trace.YData)]));
        else
            error('huh?')
        end
    end
    set(current_tick,'tag','current_tick','color',[1 0 0],'Linewidth',2);
    tickYData = current_tick.YData;
        
    % spikes can't be within template width of the end of the trial,
    % but the context could stretch over the ends
    if spike+cntxtwnd(1)>=1 && spike+cntxtwnd(end)<=length(t)
        context = plot(ax_detect,t(spike+cntxtwnd),trace.YData(spike+cntxtwnd),'color',[0.49 0.18 0.56],'tag','context'); % plot context
        context_squigs = plot(ax_squigs,t(ucspike+cntxtwnd),trace_filtered.YData(ucspike+cntxtwnd),'color',[0.49 0.18 0.56],'tag','context'); % plot context
    elseif spike+cntxtwnd(1)<1
        context = plot(ax_detect,t(1:spike+cntxtwnd(end)),trace.YData(1:spike+cntxtwnd(end)),'tag','context'); % plot context
        context_squigs = plot(ax_squigs,t(1:ucspike+cntxtwnd(end)),trace_filtered.YData(1:ucspike+cntxtwnd(end)),'color',[0.49 0.18 0.56],'tag','context'); % plot context
    elseif spike+cntxtwnd(end)>length(t)
        context = plot(ax_detect,t(spike+cntxtwnd(1):length(t)),trace.YData(spike+cntxtwnd(1):length(t)),'tag','context'); % plot context
        context_squigs = plot(ax_squigs,t(ucspike+cntxtwnd(1):length(t)),trace_filtered.YData(ucspike+cntxtwnd(1):length(t)),'color',[0.49 0.18 0.56],'tag','context'); % plot context
    end
    current_spike = plot(ax_detect,t(spike+wind),trace.YData(spike+wind),'tag','context'); % highlight spike
    
    spike_ave.XData = t(spike+wind); % xvalues for average spike
    spike_ddT.XData = t(spike+smthwind); % xvalues for 2nd D
    squigTplt.XData = t(ucspike+squigwind); % xvalues for squiggle
    
    spike_ave.YData = spike_ave.YData + trace.YData(spike); % xvalues for average spike
    spike_ddT.YData = spike_ddT.YData + trace.YData(spike); % xvalues for 2nd D
    % squigTplt.YData = squigTplt.YData; % xvalues for squiggle
    if spike==spikes_map(spike_idx,2)
        spike_ddT.Color = [0 .8 .4];
        title(ax_detect,'Checked spike matches current spike');
    else
        spike_ddT.Color = [.8 .4 0];
        if spike>spikes_map(spike_idx,2)
            title(ax_detect,'Previous spike is to the right');
        else
            title(ax_detect,'Previous spike is to the left');
        end
    end
    
    % plot spike
    suspect_spike.XData = t(spike) *[1 1];
    suspect_spike.YData = suspect_spike.YData - min(suspect_spike.YData)  + max(spike_ddT.YData);
    set(suspect_spike,'Userdata',spike);
    
    % spikes can't be within template width of the end of the trial,
    % but the context could stretch over the ends
    ax_detect.XLim = [t(max([1, spike+cntxtwnd(1)])) t(min([length(t), spike+cntxtwnd(end)]))];
    ax_detect.YLim = min(spike_ave.YData) + mean(hist_dots_in.YData)*[-2 3.5];
    ax_squigs.XLim = [t(max([1, ucspike+cntxtwnd(1)])) t(min([length(t), ucspike+cntxtwnd(end)]))];
    % ax_squigs.YLim = min(squigTplt.YData) + diff([min(squigTplt.YData) max(squigTplt.YData)])*[-1 2.5];
    ax_squigs.YLim = [min(trace_filtered.YData) max(trace_filtered.YData)];


    
    ax_hist.ButtonDownFcn = @spotCheck_XY;
    ax_hist.Parent.KeyPressFcn = @spotCheck_XY;

    hist_dots_in.ButtonDownFcn = @dotSelect;
    hist_dots_out.ButtonDownFcn = @dotSelect;
    for tick = ticks'
        tick.ButtonDownFcn = @rasterSelect;
    end
    
    direction = 1;
        
elseif isempty(evntdata) && isempty(hist_dots_in)
    
    fprintf('No spikes?\n');
else % Evntdata is from a key press or clicking on another spike
    
    if strcmp(evntdata.EventName,'KeyPress') && (strcmp(evntdata.Key,'return') || strcmp(evntdata.Character,'N'))
        trial.spikeSpotChecked = 1;
        save(trial.name, '-struct', 'trial');

        if isempty(hist_dots_in)
            uiresume();
            return
        end
        % delete(current_tick); % just turn current_tick back into a normal
        % tick
        set(current_tick,'tag','raster_ticks','color',[0 0 0],'linewidth',1);

        delete(context);
        delete(current_spike);  
        spike_ave.XData = wind;
        spike_ddT.XData = smthwind;
        
        spike_ave.YData = spike_ave.YData - trace.YData(spike+wind(1)); % xvalues for average spike
        spike_ddT.YData = spike_ddT.YData - trace.YData(spike+smthwind(1)); % xvalues for 2nd D

        clear GLOBAL context context_squigs current_spike current_tick current_dot suspect_spike
        clear GLOBAL wind squigwind smthwind cntxtwnd t spike_idx spike trace trace_filtered trial direction tickYData ucspike

        delete(findobj(ax_main,'type','line','marker','X','markeredgecolor',[1 0 0]));
        uiresume()
        hObject.Parent.CloseRequestFcn = {@(hObject,eventdata,handles) delete(hObject)};

        varargout = {''};
        if evntdata.Character=='N'
            cmd = 'next';
        end
        return    
    
    elseif strcmp(evntdata.EventName,'KeyPress') && strcmp(evntdata.Key,'rightarrow')
        % move spike to the right, but keep the original userdata
        if any(strcmp(evntdata.Modifier,'shift'))
            spike = spike + 1;
        else
            spike = spike + 10;
        end
        suspect_spike.XData = t(spike) *[1 1];
        current_tick.XData =  t(spike) *[1 1];
    
    elseif strcmp(evntdata.EventName,'KeyPress') && strcmp(evntdata.Key,'leftarrow')
        % move spike to the left
        if any(strcmp(evntdata.Modifier,'shift'))
            spike = spike - 1;
        else
            spike = spike - 10;
        end
        suspect_spike.XData = t(spike) *[1 1];
        current_tick.XData =  t(spike) *[1 1];
    
    % decision on spike
    elseif strcmp(evntdata.EventName,'Hit') || (strcmp(evntdata.EventName,'KeyPress') && ...
            (strcmp(evntdata.Character,'y') || strcmp(evntdata.Character,'n') || (strcmp(evntdata.Character,'d')) || (strcmp(evntdata.Key,'tab'))))
        
        if strcmp(evntdata.EventName,'Hit')
            % no decision made, so don't do anything regarding including
            % spike or not
            if any(hist_dots_in.XData == current_dot.XData(1))
                set(current_tick,'tag','raster_ticks','color',[0 0 0],'Linewidth',1/2);
            else
                delete(current_tick);
            end
            
        elseif strcmp(evntdata.EventName,'KeyPress') && all(evntdata.Key =='tab')
            % no decision made, just move to next spike
            if any(hist_dots_in.XData == current_dot.XData(1))
                set(current_tick,'tag','raster_ticks','color',[0 0 0],'Linewidth',1/2);
            else
                delete(current_tick);
            end
            if any(strcmp(evntdata.Modifier,'shift'))
                direction = -1;
            else
                direction = 1;
            end

        elseif strcmp(evntdata.EventName,'KeyPress') && evntdata.Character =='n'
            % it's not a spike, delete it from trial
            ns_i = numel(trial.spikes);
            if suspect_spike.XData(1)~=t(spike) % double check
                error('missalignment of spike and time');
            end
            
            % Remove spikes from trial

            trial.spikes = trial.spikes(trial.spikes~=suspect_spike.UserData); 
            hObject.Parent.UserData = trial;

            % reform the sDs and amps vectors
            sDs = spikes_map;
            amps = spikes_map;
            out_idx = isnan(spikes_map(:,1));
            in_idx = ~isnan(spikes_map(:,1));
            sDs(out_idx) = hist_dots_out.XData;
            amps(out_idx) = hist_dots_out.YData;
            sDs(in_idx) = hist_dots_in.XData;
            amps(in_idx) = hist_dots_in.YData;
                        
            % Remove spikes from spikemap
            spikes_map(spikes_map(:,1)==suspect_spike.UserData,1) = NaN;
            out_idx = find(isnan(spikes_map(:,1)));
            in_idx = find(~isnan(spikes_map(:,1)));
            
            delete(hist_dots_out);
            delete(hist_dots_in);
            
            hist_dots_out = plot(ax_hist,sDs(out_idx),amps(out_idx),'.','color',[0.9290 0.6940 0.1250],'markersize',10,'tag','distance_hist_out'); hold(ax_hist,'on');
            hist_dots_in = plot(ax_hist,sDs(in_idx),amps(in_idx),'.','color',[.0 .45 .74],'markersize',10,'tag','distance_hist_in'); hold(ax_hist,'on');
            hist_dots_in.UserData = spikes_map;
            hist_dots_in.ButtonDownFcn = @dotSelect;
            hist_dots_out.ButtonDownFcn = @dotSelect;

            ns_f = numel(trial.spikes);
            
            if ns_i~=ns_f 
                save(trial.name, '-struct', 'trial');
                fprintf('Spike at %.4f s removed - from (%d) to (%d) spikes\n',t(spike),ns_i,ns_f);
                
            end

            % cross off spikes
            switchedspike_idx = find(spikes_map(out_idx,2) == spikes_map(spike_idx,2));
            delete(findobj(ax_hist,'type','line','marker','o','XData',hist_dots_out.XData(switchedspike_idx),'-not','tag','current_dot','color',[1 0 0]));
            plot(hObject,...
                hist_dots_out.XData(switchedspike_idx),...
                hist_dots_out.YData(switchedspike_idx),...
                'marker','o','markeredgecolor',[1 0 1],'markersize',3);
            
            uistack([hist_dots_out hist_dots_in],'bottom')
            % Remove tick from ax_main (which is current_tick)
            delete(findobj(ax_main,'type','line','XData',[t(suspect_spike.UserData) t(suspect_spike.UserData)],'tag','raster_ticks'));
            delete(current_tick);
            
        elseif strcmp(evntdata.EventName,'KeyPress') && evntdata.Character =='y'
            % it's a spike! Move to next spike

            sDs = spikes_map;
            amps = spikes_map;
            out_idx = isnan(spikes_map(:,1));
            in_idx = ~isnan(spikes_map(:,1));
            sDs(out_idx) = hist_dots_out.XData;
            amps(out_idx) = hist_dots_out.YData;
            sDs(in_idx) = hist_dots_in.XData;
            amps(in_idx) = hist_dots_in.YData;
            
            if any(trial.spikes==suspect_spike.UserData) % not looking at undetected spikes
                fprintf('Spike at %.4f s saved (sample %d)\n',t(spike),spike);
                spikes_map(spikes_map(:,1)==suspect_spike.UserData,1) = spike;
                set(hist_dots_in,'UserData',spikes_map);
                trial.spikes(trial.spikes==suspect_spike.UserData) = spike;
                suspect_spike.UserData = spike;
            else % was not a spike before
                fprintf('Adding a spike at %.4f s (sample %d)\n',t(spike),spike);
                try trial.spikes = cat(1,trial.spikes,spike);
                catch e
                    if strcmp(e.message,'Dimensions of arrays being concatenated are not consistent.')
                        trial.spikes = cat(2,trial.spikes,spike);
                    end
                end
                trial.spikes = sort(trial.spikes);
                spikes_map(spikes_map(:,2)==suspect_spike.UserData,1) = spike;
                set(hist_dots_in,'UserData',spikes_map);
                suspect_spike.UserData = spike;
            end
            hObject.Parent.UserData = trial;
            save(trial.name, '-struct', 'trial');
            
            % the in and out spikes are different now
            out_idx = find(isnan(spikes_map(:,1)));
            in_idx = find(~isnan(spikes_map(:,1)));
            
            delete(hist_dots_out);
            delete(hist_dots_in);
            
            hist_dots_out = plot(ax_hist,sDs(out_idx),amps(out_idx),'.','color',[0.9290 0.6940 0.1250],'markersize',10,'tag','distance_hist_out'); hold(ax_hist,'on');
            hist_dots_in = plot(ax_hist,sDs(in_idx),amps(in_idx),'.','color',[.0 .45 .74],'markersize',10,'tag','distance_hist_in'); hold(ax_hist,'on');
            hist_dots_in.UserData = spikes_map;
            hist_dots_in.ButtonDownFcn = @dotSelect;
            hist_dots_out.ButtonDownFcn = @dotSelect;
            uistack([hist_dots_out hist_dots_in],'bottom')

            % Change the marker from red to green
            switchedspike_idx = find(spikes_map(in_idx,1) == spikes_map(spike_idx,1));
            delete(findobj(ax_hist,'type','line','marker','o','XData',hist_dots_in.XData(switchedspike_idx),'-not','tag','current_dot','color',[1 0 0]));
            % cross off spikes
            %             plot(hObject,...
            %                 hist_dots_in.XData(switchedspike_idx),...
            %                 hist_dots_in.YData(switchedspike_idx),...
            %                 'marker','o','markeredgecolor',[0 1 1],'markersize',3);

            % Remove X over tick
            delete(findobj(ax_main,'type','line','marker','X','XData',t(suspect_spike.UserData)));
           
            % turn current tick back into a normal tick
            set(current_tick,'tag','raster_ticks','color',[0 0 0],'Linewidth',1/2);
            
                % And if some of the other spikes should be looked at
        elseif strcmp(evntdata.EventName,'KeyPress') && (strcmp(evntdata.Character,'d'))
            
            switch direction
                case -1
                    direction = 1;
                case 1
                    direction = -1;
            end
            fprintf('function is obsolete \n')
            return
            
        end

        % -------------- go to next spike ---------------
        if strcmp(evntdata.EventName,'KeyPress')
            spike_idx = spike_idx+direction;
        elseif strcmp(evntdata.EventName,'Hit')
        end
        if spike_idx<1 % Hit the first spike
            spike_idx = 1;
            fprintf('First spike, can''t go any further\n');
        elseif spike_idx>size(spikes_map,1)
            spike_idx = size(spikes_map,1);
            fprintf('Last spike, can''t go any further\n');
        end

        spike = spikes_map(spike_idx,1);
        ucspike = spikes_map(spike_idx,3);
        if isnan(spike)
            spike = spikes_map(spike_idx,2);
            % cross off spikes (these don't have a match in the current spike
            % vector in the trial)
            if spike_idx<=1
                spike = spikes_map(spike_idx,2);
                fprintf('No spikes, going back to first spike, can''t go any further\n');
            end
            line([t(spike) t(spike)],tickYData,'parent',ax_main,'color',[0 0 0],'Linewidth',1/2,'tag','raster_ticks');
            
            out_idx = find(spikes_map(isnan(spikes_map(:,1)),2)==spike);
            current_dot.XData = hist_dots_out.XData(out_idx);
            current_dot.YData = hist_dots_out.YData(out_idx);
        else
            in_idx = find(spikes_map(~isnan(spikes_map(:,1)),1)==spike);
            current_dot.XData = hist_dots_in.XData(in_idx);
            current_dot.YData = hist_dots_in.YData(in_idx);
        end
            
        % turn the raster tick in main plot into the current_tick
        current_tick = findobj(ax_main,'type','line','XData',[t(spike) t(spike)],'tag','raster_ticks');
        if numel(current_tick)>1
            warning('Found too many current raster ticks')
            delete(current_tick(2:end));
            current_tick = current_tick(1);
        elseif numel(current_tick)<1
            error('No raster tick found to make into current tick')
        end
        set(current_tick,'tag','current_tick','color',[1 0 0],'Linewidth',2);

        
        % spikes can't be within template width of the end of the trial,
        % but the context could stretch over the ends
        if spike+cntxtwnd(1)>=1 && spike+cntxtwnd(end)<=length(t)
            context.XData = t(spike+cntxtwnd); % change context
            context.YData = trace.YData(spike+cntxtwnd);
            context_squigs.XData = t(ucspike+cntxtwnd); % change context
            context_squigs.YData = trace_filtered.YData(ucspike+cntxtwnd);
        elseif spike+cntxtwnd(1)<1
            context.XData = t(1:spike+cntxtwnd(end)); % change context
            context.YData = trace.YData(1:spike+cntxtwnd(end));
            context_squigs.XData = t(1:ucspike+cntxtwnd(end)); % change context
            context_squigs.YData = trace_filtered.YData(1:ucspike+cntxtwnd(end));
        elseif spike+cntxtwnd(end)>length(t)
            context.XData = t(spike+cntxtwnd(1):length(t)); % change context
            context.YData = trace.YData(spike+cntxtwnd(1):length(t));
            context_squigs.XData = t(ucspike+cntxtwnd(1):length(t)); % change context
            context_squigs.YData = trace_filtered.YData(ucspike+cntxtwnd(1):length(t));
        end
        
        current_spike.XData = t(spike+wind); % highlight spike
        current_spike.YData = trace.YData(spike+wind);
        
        spike_ave.XData = t(spike+wind); % xvalues for average spike
        spike_ddT.XData = t(spike+smthwind); % xvalues for 2nd D
        squigTplt.XData = t(ucspike+squigwind); % xvalues for 2nd D

        spike_ave.YData = spike_ave.YData - spike_ave.YData(1) + trace.YData(spike); % xvalues for average spike
        spike_ddT.YData = spike_ddT.YData - spike_ddT.YData(1) + trace.YData(spike); % xvalues for 2nd D
        % yvalues for average spike
        % yvalues for 2nd D
        if spike==spikes_map(spike_idx,2)
            spike_ddT.Color = [0 .8 .4];
            title(ax_detect,'Checked spike matches current spike');
        else
            spike_ddT.Color = [.8 .4 0];
            if spike>spikes_map(spike_idx,2)
                title(ax_detect,'Previous spike is to the right');
            elseif spike<spikes_map(spike_idx,2)
                title(ax_detect,'Previous spike is to the left');
            end
        end
        
        if isnan(spikes_map(spike_idx,1))
            spike_ave.Color = [1 .3 .4];
            squigTplt.Color = [1 .3 .4];
        else
            spike_ave.Color = [.4 .3 1];
            squigTplt.Color = [.4 .3 1];
        end

        % plot spike
        suspect_spike.XData = t(spike) *[1 1];
        suspect_spike.YData = suspect_spike.YData - suspect_spike.YData(1) + max(spike_ddT.YData)*[1 1];
        set(suspect_spike,'Userdata',spike);
        
        ax_detect.XLim = [t(max([1, spike+cntxtwnd(1)])) t(min([length(t), spike+cntxtwnd(end)]))];
        ax_detect.YLim = min(spike_ave.YData) + mean(hist_dots_in.YData)*[-3 3.5];

        ax_squigs.XLim = [t(max([1, ucspike+cntxtwnd(1)])) t(min([length(t), ucspike+cntxtwnd(end)]))];
        %ax_squigs.YLim = [min(trace_filtered.YData) max(trace_filtered.YData)];


    elseif strcmp(evntdata.EventName,'KeyPress') && ...
            (strcmp(evntdata.Character,'z'))

        % rerun the detection of spikes with the current spike vars
        fprintf('Need''s work\n')
        beep
    
    end

end

end

function dotSelect(hObject,evntdata)

global spike_idx spike

ax_hist = hObject.Parent;
hist_dots_in = findobj(ax_hist,'tag','distance_hist_in');
hist_dots_out = findobj(ax_hist,'tag','distance_hist_out');

currentspot = evntdata.IntersectionPoint;
[dist_in,spike_in] = min(sqrt((hist_dots_in.XData-currentspot(1,1)).^2 + (hist_dots_in.YData-currentspot(1,2)).^2));
[dist_out,spike_out] = min(sqrt((hist_dots_out.XData-currentspot(1,1)).^2 + (hist_dots_out.YData-currentspot(1,2)).^2));
if dist_in >.5 && dist_out >.5
    return
end

% which index?
spikemap = hist_dots_in.UserData;

if dist_in < dist_out
    spikes = spikemap(~isnan(spikemap(:,1)),1);
    spike = spikes(spike_in);
    spike_idx = find(spikemap(:,1)==spike);
else
    spikes = spikemap(isnan(spikemap(:,1)),2);
    spike = spikes(spike_out);
    spike_idx = find(spikemap(:,2)==spike);
end

spotCheck_XY(ax_hist,evntdata);
end

function rasterSelect(hObject,evntdata)

global spike_idx spike 

ax_main = hObject.Parent;
ax_hist = findobj(ax_main.Parent,'type','axes','tag','hist');
hist_dots_in = findobj(ax_hist,'tag','distance_hist_in');
currenttime = evntdata.IntersectionPoint;
x = makeInTime(ax_main.Parent.UserData.params);
[~,indx] = min(abs(x-currenttime(1)));

% which index?
spikemap = hist_dots_in.UserData;

spikes = spikemap(:,1);
[~,spike_idx] = min(abs(spikes-indx));
spike = spikes(spike_idx);

spotCheck_XY(ax_hist,evntdata);
end
