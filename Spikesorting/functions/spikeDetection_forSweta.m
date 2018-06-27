function [trial,vars_skeleton] = spikeDetection_forSweta(data)
%%
%                     fs: 10000
%     spikeTemplateWidth: 51
%                    len: 24900
%             thresh_pos: 840
%                 lp_pos: 420
%                 hp_pos: 20
%              hp_cutoff: 478.8107
%              lp_cutoff: 603.0437
%                   diff: 2
%         peak_threshold: 9.7943
%     Distance_threshold: 0.1555
%          spikeTemplate: [1×51 double]
%           lastfilename: 'B:\Raw_Data\180124\180124_F1_C1\CurrentStep2T_Raw_18012…'
%       likelyiflpntpeak: 33

vars_initial.fs= 10000;
vars_initial.spikeTemplateWidth= 51;
vars_initial.len= 24900;
vars_initial.thresh_pos= 840;
vars_initial.lp_pos= 420;
vars_initial.hp_pos= 20;
vars_initial.hp_cutoff= 478.8107;
vars_initial.lp_cutoff= 603.0437;
vars_initial.diff= 2;
vars_initial.peak_threshold= 9.7943;
vars_initial.Distance_threshold= 0.1555;
vars_initial.spikeTemplate= [];
vars_initial.lastfilename= 'B:\Raw_Data\180124\180124_F1_C1\CurrentStep2T_Raw_18012…';
vars_initial.likelyiflpntpeak= 33;

sampratein = 10000;
unfiltered_data = data;

%% initialize spike ID params
spike_params.approval = 1; %%approval (== 0) to run without asking for the spike distance threshold
spike_params.approval_time = 10;
spike_params.spikeTemplateWidth = round(0.005*sampratein); %%number of samples for the spike template
spike_params.type = ''; %% for naming spike files

%% run spike ID

global vars;
vars = vars_initial;

max_len = 400000;
if length(unfiltered_data) < max_len
    vars.len = length(unfiltered_data)-round(.01*sampratein);
else
    vars.len = max_len -round(.01*sampratein);
end

start_point = round(.01*sampratein);
stop_point = min([start_point+vars.len length(unfiltered_data)]);
unfiltered_data = unfiltered_data(start_point+1:stop_point);

vars.unfiltered_data = unfiltered_data;

%% run detection first, ask if you need to look again.
if isfield(vars,'spikeTemplate') && ~isempty(vars.spikeTemplate) 
    spikeTemplate = vars.spikeTemplate;
    [spikes_detected,uncorrectedSpikes] = detectSpikes();
end

%% if you're done, save the spikes... done
newbutton = questdlg('Save spikes?','Spike detection','Yes');

% rejigger the filter and then select some spikes
while strcmp(newbutton,'No')
    % if it needs work, change the filters
    
    filter_sliderGUI(vars.unfiltered_data,spike_params.spikeTemplateWidth);
    uiwait
    selected_spikes = [];
    spikeTemplate = [];
    % select suspect spikes to create a seedTemplate
    while isempty(selected_spikes)          % Wait while the user does this.
        getSeedTemplate
    end
    
    if isempty(spikeTemplate)
        detected_spike_locs = [];
        spikesBelowThresh = [];
        return;
    end;
    vars.spikeTemplate = spikeTemplate;
    
    [spikes_detected,uncorrectedSpikes] = detectSpikes;
    newbutton = questdlg('Save spikes?','Spike detection','Yes');
end
    
% Save spikes
if strcmp(newbutton,'Yes')
    
    error('Save the data now in your format')
    
    if isfield(vars,'locs'),vars = rmfield(vars,{'locs'}); end
    if isfield(vars,'spike_locs'),vars = rmfield(vars,{'spike_locs'}); end
    if isfield(vars,'filtered_data'),vars = rmfield(vars,{'filtered_data'}); end
    if isfield(vars,'unfiltered_data'), vars = rmfield(vars,{'unfiltered_data'}); end
    if isfield(vars,'lastfile'),vars = rmfield(vars,{'lastfile'}); end
    vars.lastfilename = trial.name;
    vars_skeleton = vars;
    if isempty(spikes_detected)
        trial.spikes = spikes_detected;
        trial.spikes_uncorrected = uncorrectedSpikes;
        trial.spikeDetectionParams = vars;
        save(trial.name, '-struct', 'trial');
        fprintf('Saved Spikes (0) and filter parameters saved: %s\n',numel(trial.spikes),trial.name);
        return
    end
    trial.spikes = spikes_detected + start_point;
    trial.spikes_uncorrected = uncorrectedSpikes + start_point;
    trial.spikeDetectionParams = vars;
    save(trial.name, '-struct', 'trial');
    fprintf('Saved Spikes (%d) and filter parameters saved: %s\n',numel(trial.spikes),trial.name);
    return
end

if strcmp(newbutton,'Cancel')
    vars_skeleton = [];
end


    function varargout = detectSpikes
        %% get all the spike locs using the correct filt and thresh cvalues
        % Amazingly, the filtering operation in the filter_slider GUI hear
        % below were using different values for the filter poles (4 here
        % and 2 in the filterGUI). This meant that if you chose a single
        % template seed example, you would get different spikeTemplate
        % waveforms and the DTW distance was somewhat large. Oddly, you'd
        % think it would go the opposite way, such that the template was smoother 
        % than the target spikes. I'm now using 3 poles as a happy medium               
        
        vars.spikeTemplateWidth = length(vars.spikeTemplate);
        filts1 = vars.hp_cutoff/(vars.fs/2);
        [x,y] = butter(3,filts1,'high');%%bandpass filter between 50 and 200 Hz
        filtered_data_high = filter(x, y, vars.unfiltered_data-vars.unfiltered_data(1));
        
        filts2 = vars.lp_cutoff/(vars.fs/2);
        [x2,y2] = butter(3,filts2,'low');%%bandpass filter between 50 and 200 Hz
        filtered_data = filter(x2, y2, filtered_data_high);
        
        if vars.diff == 0
            diff_filt = filtered_data';
        elseif vars.diff == 1
            diff_filt = [0 diff(filtered_data)'];
            diff_filt(1:100) = 0;
        elseif vars.diff == 2
            diff_filt = [0 0 diff(diff(filtered_data))'];
            diff_filt(1:100) = 0;
        end
        
        all_filtered_data = diff_filt;
        
        [locks, ~] = peakfinder(all_filtered_data,mean(all_filtered_data)+vars.peak_threshold*std(all_filtered_data));%% slightly different algorithm;  [peakLoc] = peakfinder(x0,sel,thresh) returns the indicies of local maxima that are at least sel above surrounding all_filtered_data and larger (smaller) than thresh if you are finding maxima (minima).
        
        % to prevent strange happenings, make sure that spikes do not occur right at the edges
        loccs = locks(locks> spike_params.spikeTemplateWidth);
        spike_locs = loccs(loccs < (length(all_filtered_data)-spike_params.spikeTemplateWidth));
        
        % eliminate spikes that are way bigger than they're supposed to be
        spike_locs(all_filtered_data(spike_locs)> mean(all_filtered_data(spike_locs))+ 5*std(all_filtered_data(spike_locs))) = [];
        
        clear locks loccs
        
        %% pool the detected spike candidates and do spike_params.spiketemplate matching
        targetSpikeDist = zeros(size(spike_locs));
        norm_spikeTemplate = (spikeTemplate-min(spikeTemplate))/(max(spikeTemplate)-min(spikeTemplate));
        
        %window = (max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)))
        % Should have gotten rid of spikes near the beginning or end of the data
        window = -floor(spike_params.spikeTemplateWidth/2): floor(spike_params.spikeTemplateWidth/2);
        spikewindow = window-floor(spike_params.spikeTemplateWidth/2);
        
        detectedUFSpikeCandidates = nan(size(window(:),1),size(spike_locs(:),1));
        detectedSpikeCandidates = detectedUFSpikeCandidates;
        norm_detectedSpikeCandidates = detectedUFSpikeCandidates;
        
        for i=1:length(spike_locs)
            % in the case of a single location, the template doesn't match
            % the one coming out of seed template matching
            if min(spike_locs(i)+spike_params.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(i)-spike_params.spikeTemplateWidth/2,0)< spike_params.spikeTemplateWidth
                continue
            else
                curSpikeTarget = all_filtered_data(spike_locs(i)+window);
                detectedUFSpikeCandidates(:,i) = vars.unfiltered_data(spike_locs(i)+spikewindow); % all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0): min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
                detectedSpikeCandidates(:,i) = curSpikeTarget; % all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0): min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
                norm_curSpikeTarget = (curSpikeTarget-min(curSpikeTarget))/(max(curSpikeTarget)-min(curSpikeTarget));
                norm_detectedSpikeCandidates(:,i) = norm_curSpikeTarget;
                [targetSpikeDist(i), ~,~] = dtw_WarpingDistance(norm_curSpikeTarget, norm_spikeTemplate);
            end
        end
        if any(isnan(detectedUFSpikeCandidates(:)))
            error('some of the spikes are at the edge of the data');
        end
        vars.locs = spike_locs;
        
        %% Create a figure that you can then click on to analyze spikes
        disttreshfig = figure; clf; set(disttreshfig, 'Position', [140          80        1600         900],'color', 'w');
        panl = panel(disttreshfig);
        
        vertdivisions = [2 1 4 4]; vertdivisions = num2cell(vertdivisions/sum(vertdivisions));
        panl.pack('v',vertdivisions)  % response panel, stimulus panel
        panl.margin = [20 20 10 10];
        panl.fontname = 'Arial';
        panl(1).marginbottom = 2;
        panl(2).margintop = 2;
        panl(2).marginbottom = 10;
        
        % Plot unfiltered data
        ax_main = panl(1).select(); ax_main.Tag = 'main';
        plot(ax_main,vars.unfiltered_data-mean(vars.unfiltered_data),'color',[.85 .33 .1],'tag','vars.unfiltered_data'), hold(ax_main,'on');
        axis(ax_main,'off');
        
        % Plot filtered data
        ax_filtered = panl(2).select(); ax_filtered.Tag = 'filtered';
        plot(ax_filtered,all_filtered_data-mean(all_filtered_data),'color',[.0 .45 .74],'tag','filtered_data'), hold(ax_filtered,'on');
        axis(ax_filtered,'off');
        
        linkaxes([ax_main ax_filtered],'x');
        
        panl(3).pack('h',{1/3 1/3 1/3})
        
        % Plot cumulative histogram of targetSpikeDist
        ax_hist = panl(3,1).select(); ax_hist.Tag = 'hist';
        title(ax_hist,'Click to change threshold'); xlabel(ax_hist,'DTW Distance');
        [dist, order] = sort(targetSpikeDist);
        cumy = (1:length(dist))/length(dist);
        plot(ax_hist,dist,cumy,'o','markeredgecolor',[0 0.45 0.74],'tag','distance_hist','userdata',targetSpikeDist); hold(ax_hist,'on');
        plot(ax_hist,vars.Distance_threshold*[1 1],[0 1],'color',[1 0 0],'tag','threshold');
        
        % This is useful feedback to see what has been detected thus far,
        % but if there are no spikes, stop here.
        if ~isempty(targetSpikeDist)
            
            % Plot all detected waveforms
            ax_detect = panl(3,2).select(); ax_detect.Tag = 'detect';
            title(ax_detect,'Click anywhere to use blue line as template');
            suspect_ls = plot(ax_detect,window,norm_detectedSpikeCandidates,'tag','squiggles');
            hold(ax_detect,'on');
            plot(ax_detect,window,norm_spikeTemplate,'color',[.85 .85 .85], 'linewidth', 2,'tag','initial_template')
            plot(ax_detect,window,mean(norm_detectedSpikeCandidates,2),'color',[0 .7 1], 'linewidth', 2,'tag','potential_template')
            
            suspect = targetSpikeDist<vars.Distance_threshold;
            
            set(suspect_ls(suspect),'color',[0 0 0])
            
            % Plot all detected spikes
            ax_detect_patch = panl(3,3).select(); ax_detect_patch.Tag = 'detect_patch';
            spikeWaveforms = detectedUFSpikeCandidates-repmat(detectedUFSpikeCandidates(1,:),size(detectedUFSpikeCandidates,1),1);
            spikeWaveform = smooth(mean(spikeWaveforms(:,suspect),2),vars.fs/2000);
            spikeWaveform_ = smooth(diff(spikeWaveform),vars.fs/2000);
            spikeWaveform_ = smooth(diff(spikeWaveform_),vars.fs/2000);
            
            hold(ax_detect_patch,'on');
            
            smthwnd = (vars.fs/2000+1:length(spikewindow)-vars.fs/2000);
            suspectUF_ls = plot(ax_detect_patch,spikewindow,spikeWaveforms,'tag','spikes');
            suspectUF_avel = plot(ax_detect_patch,spikewindow,spikeWaveform,'color',[0 .7 1],'linewidth',2);
            suspectUF_ddT2l = plot(ax_detect_patch,spikewindow(smthwnd(2:end-1)),spikeWaveform_(smthwnd(2:end-1))/max(spikeWaveform_(smthwnd(2:end-1)))*max(spikeWaveform),'color',[0 .8 .4],'linewidth',2);
            
            if any(suspect)
                spikeTime = spikewindow(spikeWaveform_==max(spikeWaveform_));
                spikePT = spikewindow(spikeWaveform==max(spikeWaveform));
                spikePT = spikePT(1);
            else
                spikeTime = 0;
                spikePT = 0;
            end
            
            set(suspectUF_ls(suspect),'color',[0 0 0])
            
            % Plot spikes
            suspect_dots = raster(ax_main,spike_locs+spikePT,max(vars.unfiltered_data-mean(vars.unfiltered_data))+.02*diff([min(vars.unfiltered_data) max(vars.unfiltered_data)]));
            set(suspect_dots,'color',[0 0 0],'tag','dots','userdata',spikePT);
            set(suspect_dots(~suspect),'color',[1 0 0],'linewidth',2)
            
            % Divide detected events into spike suspects and non spike suspects
            panl(4).pack('h',{1/4 1/4 1/4 1/4});
            
            ax_fltrd_suspect = panl(4,1).select(); ax_fltrd_suspect.Tag = 'fltrd_suspect';
            if any(suspect)
                plot(ax_fltrd_suspect,window,norm_detectedSpikeCandidates(:,suspect),'tag','squiggles_suspect','color',[0 0 0]);
            end
            
            ax_unfltrd_suspect = panl(4,2).select(); ax_unfltrd_suspect.Tag = 'unfltrd_suspect';
            if any(suspect)
                plot(ax_unfltrd_suspect,spikewindow,spikeWaveforms(:,suspect),'tag','spikes_suspect','color',[0 0 0]);
            end
            
            ax_fltrd_notsuspect = panl(4,3).select(); ax_fltrd_notsuspect.Tag = 'fltrd_notsuspect';
            if any(~suspect)
                plot(ax_fltrd_notsuspect,window,norm_detectedSpikeCandidates(:,~suspect),'tag','squiggles_notsuspect','color',[0 0 0]);
            end
            
            ax_unfltrd_notsuspect = panl(4,4).select(); ax_unfltrd_notsuspect.Tag = 'unfltrd_notsuspect';
            if any(~suspect)
                plot(ax_unfltrd_notsuspect,spikewindow,spikeWaveforms(:,~suspect),'tag','spikes_notsuspect','color',[0 0 0]);
            end
            
            spikeThresholdUpdateGUI(disttreshfig,norm_detectedSpikeCandidates,spikeWaveforms);
            
            uiwait();
            
            % The threshold is finally set, get rid of spikes that are over
            % the threshold
            spikes = vars.locs;
            
            norm_spikeTemplate = (vars.spikeTemplate-min(vars.spikeTemplate))/(max(vars.spikeTemplate)-min(vars.spikeTemplate));
            % Calculate the distance one last time
            for i=1:length(spike_locs)
                
                if min(spike_locs(i)+vars.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(i)-vars.spikeTemplateWidth/2,0)< vars.spikeTemplateWidth
                    continue
                else
                    curSpikeTarget = all_filtered_data(spike_locs(i)+window);
                    norm_curSpikeTarget = (curSpikeTarget-min(curSpikeTarget))/(max(curSpikeTarget)-min(curSpikeTarget));
                    [targetSpikeDist(i), ~,~] = dtw_WarpingDistance(norm_curSpikeTarget, norm_spikeTemplate);
                end
            end
            
            suspect = targetSpikeDist<vars.Distance_threshold;
            spikes = spikes(suspect);
            
            % spikePI = find(spikewindow==spikePT); % spikePI is the peak
            % of the average spike. For 81A07 initial spikes, this is often
            % before the actual spike. With the peak finder function below,
            % this is obsolete
            % peak time of average spike, then look for inflection point in
            % front of that.
            %             IP_offset = 6; % empirically determined to give enough space for the inflection point in 81A07
            
            tmp_f = figure;
            spikes_uncorrected = spikes;
            
            % This loop gets a corrected spike time for each spike. 
            % If the peak of the second derivative isn't useful, use the
            % average of all spikes you found to get a peak
            spikeWaveforms = nan(size(window(:),1),size(spikes(:),1));

            for i = 1:length(spikes)
                spikeWaveforms(:,i) = vars.unfiltered_data(spike_locs(i)+spikewindow);
            end
            if length(spikes)>1
                spikesWaveform = mean(spikeWaveforms,2);
                spikesWaveform = smooth(spikesWaveform-spikesWaveform(1),vars.fs/2000);
                spikesWaveform_ = smooth(diff(spikesWaveform),vars.fs/2000); 
                spikesWaveform_ = smooth(diff(spikesWaveform_),vars.fs/2000); 
                spikesWaveform_ = [0; 0;spikesWaveform_-spikesWaveform_(1)];
                
                % normalize
                spikesWaveform_ = (spikesWaveform_-min(spikesWaveform_))/diff([min(spikesWaveform_) max(spikesWaveform_)]);
                [~,inflPntPeak_ave] = findpeaks(spikesWaveform_(16:end-10),'MinPeakProminence',0.014);
                inflPntPeak_ave = inflPntPeak_ave+15;
                inflPntPeak_ave = inflPntPeak_ave(abs(inflPntPeak_ave-25)==min(abs(inflPntPeak_ave-25)));
            else
                spikesWaveform = [];
                spikesWaveform_ = [];
                inflPntPeak_ave = [];
            end
            
            ipps = nan(size(spikes));
            if ~isfield(vars,'likelyiflpntpeak') || isnan(vars.likelyiflpntpeak)
                vars.likelyiflpntpeak = 33;
            end
            for i = 1:length(spikes)
            
                spikeWaveform = vars.unfiltered_data(spikes(i)+spikewindow);
                
                spikeWaveform = smooth(spikeWaveform-spikeWaveform(1),vars.fs/2000);
                spikeWaveform_ = smooth(diff(spikeWaveform),vars.fs/2000); 
                spikeWaveform_ = smooth(diff(spikeWaveform_),vars.fs/2000); 
                spikeWaveform_ = [0; 0;spikeWaveform_-spikeWaveform_(1)];
                
                % normalize
                spikeWaveform_ = (spikeWaveform_-min(spikeWaveform_))/diff([min(spikeWaveform_) max(spikeWaveform_)]);
                
                %% see how this works:
                %pks = peakfinder(spikeWaveform_);
                % really narrow the interest range
                start_idx = vars.fs/10000*15;
                end_idx = vars.fs/10000*10;
                
                [~,inflPntPeak] = findpeaks(spikeWaveform_(start_idx+1:end-end_idx),'MinPeakProminence',0.02);
                inflPntPeak = inflPntPeak+start_idx;
                if numel(inflPntPeak)>1
                    inflPntPeak = inflPntPeak(abs(inflPntPeak-vars.likelyiflpntpeak)==min(abs(inflPntPeak-vars.likelyiflpntpeak)));
                end
                if length(inflPntPeak)~=1
                    warning('Peak of 2nd derivative is still undefined');
                    plot(spikewindow,spikeWaveform_); hold on;
                    if ~isempty(spikesWaveform_) && ~isempty(inflPntPeak_ave)
                        % use spike time closest to ~25 ms
                        warning('Using artificial point closest to 25');
                        plot(spikewindow(inflPntPeak_ave),spikeWaveform_(inflPntPeak_ave),'ro');
                        spikes(i) = spikes(i)+spikewindow(inflPntPeak_ave);
                        %pause;
                    elseif isempty(inflPntPeak) && isempty(inflPntPeak_ave)
                        % use spike time closest to ~25 ms
                        warning('Using artificial point closest to 25');
                        [~,inflPntPeak] = findpeaks(spikeWaveform_(21:end-10),'MinPeakProminence',0.001);
                        inflPntPeak = inflPntPeak+20;
                        if isempty(inflPntPeak)
                            inflPntPeak = 28;
                            title('Using indx 28 as inflection point')
                        else
                            if numel(inflPntPeak)>1
                                inflPntPeak = inflPntPeak(abs(inflPntPeak-vars.likelyiflpntpeak)==min(abs(inflPntPeak-vars.likelyiflpntpeak)));
                            end
                            title('Found a small peak of d/dt^2')
                        end
                        plot(spikewindow(inflPntPeak),spikeWaveform_(inflPntPeak),'ro');
                        spikes(i) = spikes(i)+spikewindow(inflPntPeak);
                        %pause;
                        
                    else
                        warning('Only one spike, no average 2nd derivative to fall back on');
                        spikes(i) = NaN;
                    end
                    hold off;
                else
                    ipps(i) = inflPntPeak;
                    spikes(i) = spikes(i)+spikewindow(inflPntPeak); %#ok<FNDSB>
                    plot(spikewindow,spikeWaveform_); hold on; plot(spikewindow(inflPntPeak),spikeWaveform_(inflPntPeak),'ro');
                end
            end
            vars.likelyiflpntpeak = nanmean(ipps);
            varargout = {spikes,spikes_uncorrected};
            pause(.4); %hold off;
            close(tmp_f);
            return
        else % If there were no spikes at all
            uiwait();
            spikes = [];
            spikes_uncorrected = spikes;
            varargout = {spikes,spikes_uncorrected};

            return
        end
    end

    function getSeedTemplate()
        fig = figure('position',[100 100 1200 900], 'NumberTitle', 'off', 'color', 'w');
        
        patchax = axes(fig,'units','normalized','position',[0.1300 0.8500 0.7750 0.1]);
        plot(patchax,(1:vars.len),vars.unfiltered_data(1:vars.len),'color',[0.8500    0.3250    0.0980]);
        ticks = raster(patchax,vars.locs,max(vars.unfiltered_data(1:vars.len))+.02*diff([max(vars.unfiltered_data(1:vars.len)),min(vars.unfiltered_data(1:vars.len))]));
        set(ticks,'tag','ticks');
        
        filtax = axes(fig,'units','normalized','position',[0.1300 0.105 0.7750 0.39]);
        set(fig,'toolbar','figure');
        
        plot_filt = (vars.filtered_data(1:vars.len)-mean(vars.filtered_data))/max(vars.filtered_data);
        plot_spikes = vars.locs(vars.locs<vars.len);
        plot_thresh = (vars.peak_threshold *std(vars.filtered_data)-mean(vars.filtered_data))/max(vars.filtered_data);
        
        hold(filtax,'off');
        axes(filtax);
        plot(filtax,plot_spikes, plot_filt(plot_spikes),'ro');hold on;
        plot(filtax,plot_filt,'k');hold on;
        plot(filtax,[1 vars.len],max(plot_filt)-[plot_thresh plot_thresh],'--','color',[.8 .8 .8]);%% uncomment to plot piezo signal or another channel
        
        squigglesax = axes(fig,'units','normalized','position',[0.1300    0.56    0.3550    0.235]); hold(squigglesax,'on');
        spikesax = axes(fig,'units','normalized','position',[0.544    0.56    0.36    0.235]); hold(spikesax,'on');
        
        cursorobj = datacursormode(fig);
        cursorobj.SnapToDataVertex = 'on'; % Snap to our plotted data, on by default
        title(filtax,'select template spikes (hold alt to select multiple), then hit enter');
        cursorobj.Enable = 'on';     % Turn on the data cursor, hold alt to select multiple points
        set(cursorobj,'UpdateFcn',{@labeldtips})
        
        while ~waitforbuttonpress;end 
        
        cursorobj.Enable = 'off';
        mypoints = getCursorInfo(cursorobj);
        
        if ~isempty(mypoints)
            for hh = 1:length(mypoints)
                template_center = mypoints(hh).Position(1);
                spikeTemplateSeed(hh,:) = vars.filtered_data(template_center+(-spike_params.spikeTemplateWidth:spike_params.spikeTemplateWidth));
            end
            
            selected_spikes = 0;
            if size(spikeTemplateSeed,1)>1
                % align the templates, may not have picked the peaks
                skootchedTemplate = spikeTemplateSeed;
                for r = 2:size(spikeTemplateSeed,1)
                    [c,lags] = xcorr(spikeTemplateSeed(1,:),spikeTemplateSeed(r,:));
                    skootch = lags(c==max(c));
                    switch sign(skootch)
                        case 1
                            skootchedTemplate(r,skootch+1:end) = spikeTemplateSeed(r,1:end-skootch);
                        case -1
                            skootchedTemplate(r,1:end+skootch) = spikeTemplateSeed(r,-skootch+1:end);
                    end
                end
                spikeTemplate = mean(skootchedTemplate,1);
                middle = find(spikeTemplate(spike_params.spikeTemplateWidth+ (-floor(spike_params.spikeTemplateWidth/2):floor(spike_params.spikeTemplateWidth/2)))==max(spikeTemplate(spike_params.spikeTemplateWidth+ (-floor(spike_params.spikeTemplateWidth/2):floor(spike_params.spikeTemplateWidth/2)))));
                middle = middle+floor(spike_params.spikeTemplateWidth/2)-1;
                spikeTemplate = spikeTemplate(middle+1+(-floor(spike_params.spikeTemplateWidth/2):floor(spike_params.spikeTemplateWidth/2)));
            else
                spikeTemplate = spikeTemplateSeed;
                middle = find(spikeTemplate(spike_params.spikeTemplateWidth+ (-floor(spike_params.spikeTemplateWidth/2):floor(spike_params.spikeTemplateWidth/2)))==max(spikeTemplate(spike_params.spikeTemplateWidth+ (-floor(spike_params.spikeTemplateWidth/2):floor(spike_params.spikeTemplateWidth/2)))));
                middle = middle+floor(spike_params.spikeTemplateWidth/2)-1;
                spikeTemplate = spikeTemplate(middle+1+(-floor(spike_params.spikeTemplateWidth/2):floor(spike_params.spikeTemplateWidth/2)));
            end
        else
            disp('no spikes selected');
            selected_spikes = 0;
            detected_spike_locs = [];
            spikesBelowThresh = [];
            spikeTemplate = [];
            spikeTemplateSeed = [];
        end
        
        close(fig)
        
        function output_txt = labeldtips(obj,event_obj,...
                xydata,labels,xymean)
            % Display an observation's Y-data and label for a data tip
            % obj          Currently not used (empty)
            % event_obj    Handle to event object
            % xydata       Entire data matrix
            % labels       State names identifying matrix row
            % xymean       Ratio of y to x mean (avg. for all obs.)
            % output_txt   Datatip text (character vector or cell array
            %              of character vectors)
            
            pos = get(event_obj,'Position');
            x = pos(1); y = pos(2);
            output_txt = {['X: ',num2str(x,4)]};
            
            window = -floor(vars.spikeTemplateWidth/2):floor(vars.spikeTemplateWidth/2);
            squiggle = vars.filtered_data(x+window);
            spike = vars.unfiltered_data(x+window-floor(find(window==0)/2));
            plot(squigglesax,window,squiggle);
            plot(spikesax,window-floor(find(window==0)/2),spike);
            
            % The portion of the example called Explore the Graph with the Custom Data
            % Cursor sets up data cursor mode and declares this function as a callback
            % using the following code:
        end
    end
end

%% %%%%%%%%%%%%    Other code detritus    %%%%%%%%%%%%%%%%%%%%

%% estimate spike probabilities at candidate locations
% spikeProbs = zeros(size(spike_locs));
% for i=1:length(spike_locs)
%     if min(spike_locs(i)+spike_params.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(i)-spike_params.spikeTemplateWidth/2,0)< spike_params.spikeTemplateWidth
%         continue
%     else
%         spikeProbs(i) = exp( -(abs(targetSpikeDist(i)-mean(targetSpikeDist))) / (2*var(targetSpikeDist)) );
%     end
% end
        
