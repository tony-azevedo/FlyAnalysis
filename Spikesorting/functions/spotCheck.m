function spotCheck(~,evntdata)

persistent context current_spike current_tick current_dot suspect_spike 
persistent wind smthwind cntxtwnd t spike_idx spike trace trial superthreshold tickYData

ax_hist = findobj('type','axes','tag','hist');
hObject = ax_hist;
trial = hObject.Parent.UserData;

hist_dots = findobj(hObject,'tag','distance_hist');
if ~isempty(hist_dots)
    spikes_map = hist_dots.UserData;
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
    spike = spikes_map(1,spike_idx);
    if isempty(spike_idx) % there are no events larger than threshold
        spike_idx = 1;
        spike = spikes_map(1,spike_idx);
    end
    while isnan(spike)
        % cross off spikes (these don't have a match in the current spike
        % vector in the trial)
        plot(hObject,...
            hist_dots.XData(spike_idx),...
            hist_dots.YData(spike_idx),...
            'marker','X','markeredgecolor',[1 0 0]);

        spike_idx = spike_idx-1;
        try spike = spikes_map(1,spike_idx);
        catch e
            if strcmp(e.identifier,'MATLAB:badsubscript')
                
                % At this point, none of the potential spikes are
                % considered spikes
                
                spike_idx = 0;
                spike = spikes_map(2,1);
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
        if isnan(spikes_map(1,cnt))      
            plot(hObject,hist_dots.XData(cnt),hist_dots.YData(cnt),'marker','X','markeredgecolor',[1 0 0]);
        end
    end
    
    for cnt = find(hist_dots.XData>threshold,1,'first'):size(spikes_map,2)        
        % Cross off any other spikes that have been rejected ABOVE
        % threshold
        if ~isnan(spikes_map(1,cnt))
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
    if spike==spikes_map(2,spike_idx)
        spike_ddT.Color = [0 .8 .4];
        title(ax_detect,'Checked spike matches current spike');
    else
        spike_ddT.Color = [.8 .4 0];
        if spike>spikes_map(2,spike_idx)
            title(ax_detect,'Previous spike is to the right');
        else
            title(ax_detect,'Previous spike is to the left');
        end
    end
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
        trial.spikeSpotChecked = 1;
        save(trial.name, '-struct', 'trial');

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
            spikes_map(1,spikes_map(1,:)==suspect_spike.UserData) = NaN;
            set(hist_dots,'UserData',spikes_map);

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
                spikes_map(1,spikes_map(1,:)==suspect_spike.UserData) = spike;
                set(hist_dots,'UserData',spikes_map);
                trial.spikes(trial.spikes==suspect_spike.UserData) = spike;
                suspect_spike.UserData = spike;
            else % superthreshold
                fprintf('Adding a spike at %.4f s (sample %d)\n',t(spike),spike);
                try trial.spikes = cat(2,trial.spikes,spike);
                catch e
                    if strcmp(e.message,'Dimensions of matrices being concatenated are not consistent.')
                        keyboard
                    end
                end
                trial.spikes = sort(trial.spikes);
                spikes_map(1,spikes_map(2,:)==suspect_spike.UserData) = spike;
                set(hist_dots,'UserData',spikes_map);
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
            if ~any(t(spikes_map(1,~isnan(spikes_map(1,:)))) == current_tick.XData(1))
                delete(current_tick)
            else
                set(current_tick,'tag','raster_ticks','color',[0 0 0],'Linewidth',1/2);
            end
                
            if ~superthreshold
                superthreshold = 1;
                spike_idx = find(isnan(spikes_map(1,:)),1,'first');
                spike = spikes_map(2,spike_idx);
                spike_idx = spike_idx-1; % just goose the idx for below
            elseif superthreshold
                superthreshold = 0;
                spike_idx = find(~isnan(spikes_map(1,:)),1,'last');
                if isempty(spike_idx) 
                    % This is the case where no events that pass peak
                    % threshold are spikes
                    spike_idx = size(spikes_map,2);
                    fprintf('Starting at least likely event\n');
                    spike = spikes_map(2,spike_idx); % give it another go with the original spike time
                else
                    spike = spikes_map(1,spike_idx); % give it another go with the original spike time
                end
                spike_idx = spike_idx+1; % just goose the idx for below
            end
            
        end
        
        % go to next spike
        if ~superthreshold
            spike_idx = spike_idx-1;        
            if spike_idx>=1
                spike = spikes_map(1,spike_idx);
                
                while isnan(spike)
                    % cross off spikes (these don't have a match in the current spike
                    % vector in the trial)
                    if spike_idx<=1
                        spike = spikes_map(2,1);
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
                    spike = spikes_map(1,spike_idx);
                end
            else  % Hit the first spike
                spike_idx = spike_idx+1;
                fprintf('First spike, can''t go any further\n');
                if isnan(spikes_map(1,spike_idx)) % this is not a spike
                    
                    spike = spikes_map(2,spike_idx);
                    % new tick (looks like the raster ticks)
                    line([t(spike) t(spike)],tickYData,'parent',ax_main,'color',[0 0 0],'Linewidth',1/2,'tag','raster_ticks');
                elseif ~isnan(spikes_map(1,spike_idx)) % yes it's a spike, and it's already a spike and has a tick
                    spike = spikes_map(1,spike_idx);
                end
            end
            
        elseif superthreshold
            spike_idx = spike_idx+1;
            if spike_idx<=size(spikes_map,2)
                while ~isnan(spikes_map(1,spike_idx)) % only look at spikes that are above threshold or not identified as spikes
                    spike_idx = spike_idx+1;
                end
            else
                spike_idx = spike_idx-1;
                fprintf('Last spike, can''t go any further\n');
            end
            spike = spikes_map(2,spike_idx);
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
        if spike==spikes_map(2,spike_idx)
            spike_ddT.Color = [0 .8 .4];
            title(ax_detect,'Checked spike matches current spike');
        else
            spike_ddT.Color = [.8 .4 0];
            if spike>spikes_map(2,spike_idx)
                title(ax_detect,'Previous spike is to the right');
            else
                title(ax_detect,'Previous spike is to the left');
            end
        end
        
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