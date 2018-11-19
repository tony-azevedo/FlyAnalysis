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
