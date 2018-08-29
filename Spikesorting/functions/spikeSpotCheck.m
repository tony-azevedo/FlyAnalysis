function h = spikeSpotCheck(trial,inputToAnalyze,varargin)

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

% trial = load(sprintf(trialStem,trialnumlist(1)));
vars = trial.spikeDetectionParams;

window = -floor(vars.spikeTemplateWidth/2): floor(vars.spikeTemplateWidth/2);
smthwnd = (vars.fs/2000+1:length(window)-vars.fs/2000);

spkwaveforms = zeros(length(trial.spikes),length(window));
% collect spikes that are good
for t = trial.spikes
    
end
% average the spikes that are really good
spikeaverage = mean(spkwaveforms,1);
spikeaverage = spikeaverage-spikeaverage(1);

spikeWaveform = spikeaverage;
spikeWaveform = smooth(spikeWaveform-spikeWaveform(1),vars.fs/2000);
spikeWaveform_ = smooth(diff(spikeWaveform),vars.fs/2000);
spikeWaveform_ = smooth(diff(spikeWaveform_),vars.fs/2000);
spikeWaveform_ = [0; 0;spikeWaveform_-spikeWaveform_(1)];
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

function spotCheck(~,evntdata)

persistent context current_spike current_tick current_dot suspect_spike 
persistent wind smthwind cntxtwnd t spike_idx spike trace trial superthreshold tickYData

ax_hist = findobj('type','axes','tag','hist');
hObject = ax_hist;
trial = hObject.Parent.UserData;

hist_dots = findobj(hObject,'tag','distance_hist');
if ~isempty(hist_dots)
    spikesinorder = hist_dots.UserData;
    thresh_line = findobj(hObject,'tag','threshold');
    threshold = max(thresh_line.XData);
end

ax_main = findobj(hObject.Parent,'Tag','main');

ax_detect = findobj(hObject.Parent,'Tag','detect');
spike_ave = findobj(ax_detect,'Tag', 'spike_ave');
ticks = findobj(ax_main,'Tag','raster_ticks');
spike_ddT = findobj(ax_detect,'Tag', 'spike_ddT');

hist_dots = findobj(hObject,'tag','distance_hist');
if isempty(hist_dots)
    suspect_spike = findobj(ax_detect,'Tag', 'spike_time');
    suspect_spike.XData = 0 *[1 1];
    suspect_spike.YData = suspect_spike.YData - min(suspect_spike.YData)  + max(spike_ddT.YData);
    set(suspect_spike,'Userdata',spike);
    
    ax_detect.YLim = [...
        min([min(spike_ave.YData) min(spike_ddT.YData) min(suspect_spike.YData)]) ...
        max([max(spike_ave.YData) max(spike_ddT.YData) max(suspect_spike.YData)])];
    ax_detect.XLim = [spike_ave.XData(1) spike_ave.XData(end)];

end

if isempty(evntdata) && ~isempty(hist_dots)
    trace = findobj(ax_main,'Tag', 'unfiltered_data');
    t = trace.XData;
    
    wind = spike_ave.XData;
    smthwind = spike_ddT.XData;
    suspect_spike = findobj(ax_detect,'Tag', 'spike_time');
    
    cntxtwnd = min(wind)*4:max(wind)*4;
    
    % find first spike less than threshold that is not already removed!
    spike_idx = find(hist_dots.XData<threshold,1,'last');
    spike = spikesinorder(1,spike_idx);
    if isempty(spike_idx) % there are no events larger than threshold
        spike_idx = 1;
        spike = spikesinorder(1,spike_idx);
    end
    while isnan(spike)
        % cross off spikes (these don't have a match in the current spike
        % vector in the trial)
        plot(hObject,...
            hist_dots.XData(spike_idx),...
            hist_dots.YData(spike_idx),...
            'marker','X','markeredgecolor',[1 0 0]);

        spike_idx = spike_idx-1;
        try spike = spikesinorder(1,spike_idx);
        catch e
            if strcmp(e.identifier,'MATLAB:badsubscript')
                
                % At this point, none of the potential spikes are
                % considered spikes
                
                spike_idx = 0;
                spike = spikesinorder(2,1);
                % spike is already nan
                break
            else
                error(e)
            end
        end
    end
    
    % fill in the current dot on the hist plot
    current_dot = plot(hObject,...
        hist_dots.XData(max([spike_idx 1])),...
        hist_dots.YData(max([spike_idx 1])),...
        'marker','o','markeredgecolor','none','markerfacecolor',[0 0 1],'tag','current_dot');
    
    for cnt = spike_idx:-1:1
        % Cross off any other spikes that have been rejected BELOW
        % threshold
        if isnan(spikesinorder(1,cnt))      
            plot(hObject,hist_dots.XData(cnt),hist_dots.YData(cnt),'marker','X','markeredgecolor',[1 0 0]);
        end
    end
    
    for cnt = find(hist_dots.XData>threshold,1,'first'):size(spikesinorder,2)        
        % Cross off any other spikes that have been rejected ABOVE
        % threshold
        if ~isnan(spikesinorder(1,cnt))
            plot(hObject,hist_dots.XData(cnt),hist_dots.YData(cnt),'marker','X','markeredgecolor',[0 1 0]);
        end
    end
    
    % Find the current tick
    current_tick = findobj(ax_main,'type','line','XData',[t(spike) t(spike)],'tag','raster_ticks');
    if numel(current_tick)>1
        error('Found too many current raster ticks')
    elseif numel(current_tick)<1 % No ticks at all!
        if spike_idx == 0 % All spikes have been rejected so far
            spike_idx = 1;
            current_tick = raster(ax_main,t(spikesinorder(2,1)),max(trace.YData)+.02*diff([min(trace.YData) max(trace.YData)]));
        else
            error('huh?')
        end
    end
    set(current_tick,'tag','current_tick','color',[1 0 0],'Linewidth',2);
    tickYData = current_tick.YData;
        
    % spikes can't be within template width of the end of the trial,
    % but the context could stretch over the ends
    if spike+cntxtwnd(1)>=1 && spike+cntxtwnd(end)<=length(t)
        context = plot(ax_detect,t(spike+cntxtwnd),trace.YData(spike+cntxtwnd),'tag','context'); % plot context
    elseif spike+cntxtwnd(1)<1
        context = plot(ax_detect,t(1:spike+cntxtwnd(end)),trace.YData(1:spike+cntxtwnd(end)),'tag','context'); % plot context
    elseif spike+cntxtwnd(end)>length(t)
        context = plot(ax_detect,t(spike+cntxtwnd(1):length(t)),trace.YData(spike+cntxtwnd(1):length(t)),'tag','context'); % plot context
    end
    current_spike = plot(ax_detect,t(spike+wind),trace.YData(spike+wind),'tag','context'); % highlight spike
    
    spike_ave.XData = t(spike+wind); % xvalues for average spike
    spike_ddT.XData = t(spike+smthwind); % xvalues for 2nd D
    
    spike_ave.YData = spike_ave.YData + trace.YData(spike+wind(1)); % xvalues for average spike
    spike_ddT.YData = spike_ddT.YData + trace.YData(spike+smthwind(1)); % xvalues for 2nd D
    % yvalues for average spike
    % yvalues for 2nd D
    
    % plot spike
    suspect_spike.XData = t(spike) *[1 1];
    suspect_spike.YData = suspect_spike.YData - min(suspect_spike.YData)  + max(spike_ddT.YData);
    set(suspect_spike,'Userdata',spike);
    
    ax_detect.YLim = [...
        min([min(context.YData) min(spike_ave.YData) min(spike_ddT.YData) min(suspect_spike.YData)]) ...
        max([max(context.YData) max(spike_ave.YData) max(spike_ddT.YData) max(suspect_spike.YData)])];
    % spikes can't be within template width of the end of the trial,
    % but the context could stretch over the ends
    ax_detect.XLim = [t(max([1, spike+cntxtwnd(1)])) t(min([length(t), spike+cntxtwnd(end)]))];
    
    superthreshold = 0;

elseif isempty(evntdata) && isempty(hist_dots)
    
    fprintf('No spikes?\n');
else % Evntdata is from a key press
    
    if strcmp(evntdata.EventName,'KeyPress') && strcmp(evntdata.Key,'return')
        if isempty(hist_dots)
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

        clear context current_spike current_tick current_dot suspect_spike
        clear wind smthwind cntxtwnd t spike_idx spike trace trial superthreshold
        delete(findobj(ax_main,'type','line','marker','X','markeredgecolor',[1 0 0]));
        uiresume()
    
    
    elseif strcmp(evntdata.EventName,'KeyPress') && strcmp(evntdata.Key,'rightarrow')
        % move spike to the right, but keep the original userdata
        if any(strcmp(evntdata.Modifier,'shift'))
            spike = spike + 10;
        end
        spike = spike + 1;
        suspect_spike.XData = t(spike) *[1 1];
        current_tick.XData =  t(spike) *[1 1];
    
    elseif strcmp(evntdata.EventName,'KeyPress') && strcmp(evntdata.Key,'leftarrow')
        % move spike to the left
        if any(strcmp(evntdata.Modifier,'shift'))
            spike = spike - 10;
        end
        spike = spike - 1;
        suspect_spike.XData = t(spike) *[1 1];
        current_tick.XData =  t(spike) *[1 1];
    
    % decision on spike
    elseif strcmp(evntdata.EventName,'KeyPress') && ...
            (strcmp(evntdata.Character,'y') || strcmp(evntdata.Character,'n') || (strcmp(evntdata.Character,'d')))
        
        if strcmp(evntdata.EventName,'KeyPress') && evntdata.Character =='n'
            % it's not a spike, delete it from trial
            ns_i = numel(trial.spikes);
            if suspect_spike.XData(1)~=t(spike) % double check
                error('missalignment of spike and time');
            end
            
            % Remove spikes from trial
            trial.spikes = trial.spikes(trial.spikes~=suspect_spike.UserData); 
            hObject.Parent.UserData = trial;

            % Remove spikes from spikemap
            spikesinorder(1,spikesinorder(1,:)==suspect_spike.UserData) = NaN;
            set(hist_dots,'UserData',spikesinorder);

            ns_f = numel(trial.spikes);
            
            if ns_i~=ns_f 
                save(trial.name, '-struct', 'trial');
                fprintf('Spike at %.4f s removed - from (%d) to (%d) spikes\n',t(spike),ns_i,ns_f);
                plot(ax_main,...
                    t(spike),...
                    current_tick.YData(1),...
                    'marker','X','markeredgecolor',[1 0 0]);
            end
            
            % Change the histogram marker from green to red
            delete(findobj(ax_hist,'type','line','marker','X','XData',hist_dots.XData(spike_idx)));
            % cross off spikes
            plot(hObject,...
                hist_dots.XData(spike_idx),...
                hist_dots.YData(spike_idx),...
                'marker','X','markeredgecolor',[1 0 0]);
            
            % Remove tick from ax_main (which is current_tick)
            % delete(findobj(ax_main,'type','line','XData',[t(suspect_spike.UserData) t(suspect_spike.UserData)],'tag','raster_ticks'));
            delete(current_tick);
            
        elseif strcmp(evntdata.EventName,'KeyPress') && evntdata.Character =='y'
            % it's a spike! Move to next spike
            if any(trial.spikes==suspect_spike.UserData) % not looking at undetected spikes
                fprintf('Spike at %.4f s saved (sample %d)\n',t(spike),spike);
                spikesinorder(1,spikesinorder(1,:)==suspect_spike.UserData) = spike;
                set(hist_dots,'UserData',spikesinorder);
                trial.spikes(trial.spikes==suspect_spike.UserData) = spike;
                suspect_spike.UserData = spike;
            else % superthreshold
                fprintf('Adding a spike at %.4f s (sample %d)\n',t(spike),spike);
                trial.spikes = cat(2,trial.spikes,spike);
                trial.spikes = sort(trial.spikes);
                spikesinorder(1,spikesinorder(2,:)==suspect_spike.UserData) = spike;
                set(hist_dots,'UserData',spikesinorder);
                suspect_spike.UserData = spike;
            end
            hObject.Parent.UserData = trial;
            save(trial.name, '-struct', 'trial');
            
            % Change the marker from red to green
            delete(findobj(ax_hist,'type','line','marker','X','XData',hist_dots.XData(spike_idx)));
            % cross off spikes
            plot(hObject,...
                hist_dots.XData(spike_idx),...
                hist_dots.YData(spike_idx),...
                'marker','X','markeredgecolor',[0 1 0]);

            % Remove X over tick
            delete(findobj(ax_main,'type','line','marker','X','XData',t(suspect_spike.UserData)));
           
            % turn current tick back into a normal tick
            set(current_tick,'tag','raster_ticks','color',[0 0 0],'Linewidth',1/2);
            
            
        % And if some of the other spikes should be looked at
        elseif strcmp(evntdata.EventName,'KeyPress') && (strcmp(evntdata.Character,'d'))
            
            % turn current tick back into a normal tick
            set(current_tick,'tag','raster_ticks','color',[0 0 0],'Linewidth',1/2);
            
            % is the current tick part of the spikes?
            if ~any(t(spikesinorder(1,~isnan(spikesinorder(1,:)))) == current_tick.XData(1))
                delete(current_tick)
            else
                set(current_tick,'tag','raster_ticks','color',[0 0 0],'Linewidth',1/2);
            end
                
            if ~superthreshold
                superthreshold = 1;
                spike_idx = find(isnan(spikesinorder(1,:)),1,'first');
                spike = spikesinorder(2,spike_idx);
                spike_idx = spike_idx-1; % just goose the idx for below
            elseif superthreshold
                superthreshold = 0;
                spike_idx = find(~isnan(spikesinorder(1,:)),1,'last');
                if isempty(spike_idx) 
                    % This is the case where no events that pass peak
                    % threshold are spikes
                    spike_idx = size(spikesinorder,2);
                    fprintf('Starting at least likely event\n');
                    spike = spikesinorder(2,spike_idx); % give it another go with the original spike time
                else
                    spike = spikesinorder(1,spike_idx); % give it another go with the original spike time
                end
                spike_idx = spike_idx+1; % just goose the idx for below
            end
            
        end
        
        % go to next spike
        if ~superthreshold
            spike_idx = spike_idx-1;        
            if spike_idx>=1
                spike = spikesinorder(1,spike_idx);
                
                while isnan(spike)
                    % cross off spikes (these don't have a match in the current spike
                    % vector in the trial)
                    if spike_idx<=1
                        spike = spikesinorder(2,1);
                        fprintf('No spikes, going back to first spike, can''t go any further\n');
                        new_tick = line([t(spike) t(spike)],tickYData,'parent',ax_main,'color',[1 0 0],'Linewidth',2);
                        set(new_tick,'tag','current_tick');
                        break
                    end
                    plot(hObject,...
                        hist_dots.XData(spike_idx),...
                        hist_dots.YData(spike_idx),...
                        'marker','X','markeredgecolor',[1 0 0]);
                    
                    spike_idx = spike_idx-1;
                    spike = spikesinorder(1,spike_idx);
                end
            else  % Hit the first spike
                spike_idx = spike_idx+1;
                fprintf('First spike, can''t go any further\n');
                if isnan(spikesinorder(1,spike_idx)) % this is not a spike
                    
                    spike = spikesinorder(2,spike_idx);
                    % new tick (looks like the raster ticks)
                    line([t(spike) t(spike)],tickYData,'parent',ax_main,'color',[0 0 0],'Linewidth',1/2,'tag','raster_ticks');
                elseif ~isnan(spikesinorder(1,spike_idx)) % yes it's a spike, and it's already a spike and has a tick
                    spike = spikesinorder(1,spike_idx);
                end
            end
            
        elseif superthreshold
            spike_idx = spike_idx+1;
            if spike_idx<=size(spikesinorder,2)
                while ~isnan(spikesinorder(1,spike_idx)) % only look at spikes that are above threshold or not identified as spikes
                    spike_idx = spike_idx+1;
                end
            else
                spike_idx = spike_idx-1;
                fprintf('Last spike, can''t go any further\n');
            end
            spike = spikesinorder(2,spike_idx);
            new_tick = findobj(ax_main,'type','line','XData',[t(spike) t(spike)]);
            delete(new_tick);

            % new tick (looks like the raster ticks)
            line([t(spike) t(spike)],tickYData,'parent',ax_main,'color',[0 0 0],'tag','raster_ticks');
        end

        % turn the raster tick in main plot into the current_tick
        current_tick = findobj(ax_main,'type','line','XData',[t(spike) t(spike)],'tag','raster_ticks');
        if numel(current_tick)>1
            error('Found too many current raster ticks')
        elseif numel(current_tick)<1
            error('No raster tick found to make into current tick')
        end
        set(current_tick,'tag','current_tick','color',[1 0 0],'Linewidth',2);

        current_dot.XData = hist_dots.XData(spike_idx);
        current_dot.YData = hist_dots.YData(spike_idx);
        
        % spikes can't be within template width of the end of the trial,
        % but the context could stretch over the ends
        if spike+cntxtwnd(1)>=1 && spike+cntxtwnd(end)<=length(t)
            context.XData = t(spike+cntxtwnd); % change context
            context.YData = trace.YData(spike+cntxtwnd);
        elseif spike+cntxtwnd(1)<1
            context.XData = t(1:spike+cntxtwnd(end)); % change context
            context.YData = trace.YData(1:spike+cntxtwnd(end));
        elseif spike+cntxtwnd(end)>length(t)
            context.XData = t(spike+cntxtwnd(1):length(t)); % change context
            context.YData = trace.YData(spike+cntxtwnd(1):length(t));
        end
        
        current_spike.XData = t(spike+wind); % highlight spike
        current_spike.YData = trace.YData(spike+wind);
        
        spike_ave.XData = t(spike+wind); % xvalues for average spike
        spike_ddT.XData = t(spike+smthwind); % xvalues for 2nd D
        
        spike_ave.YData = spike_ave.YData - spike_ave.YData(1) + trace.YData(spike+wind(1)); % xvalues for average spike
        spike_ddT.YData = spike_ddT.YData - spike_ddT.YData(1) + trace.YData(spike+smthwind(1)); % xvalues for 2nd D
        % yvalues for average spike
        % yvalues for 2nd D
        
        % plot spike
        suspect_spike.XData = t(spike) *[1 1];
        suspect_spike.YData = suspect_spike.YData - suspect_spike.YData(1) + max(spike_ddT.YData)*[1 1];
        set(suspect_spike,'Userdata',spike);
        
        ax_detect.YLim = [...
            min([min(context.YData) min(spike_ave.YData) min(spike_ddT.YData) min(suspect_spike.YData)]) ...
            max([max(context.YData) max(spike_ave.YData) max(spike_ddT.YData) max(suspect_spike.YData)])];

        % spikes can't be within template width of the end of the trial,
        % but the context could stretch over the ends
        ax_detect.XLim = [t(max([1, spike+cntxtwnd(1)])) t(min([length(t), spike+cntxtwnd(end)]))];
    

    elseif strcmp(evntdata.EventName,'KeyPress') && ...
            (strcmp(evntdata.Character,'z'))

        % rerun the detection of spikes with the current spike vars
        fprintf('Need''s work\n')
        beep
    
    end

end

end

