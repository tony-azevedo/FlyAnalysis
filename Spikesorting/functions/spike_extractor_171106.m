%% updated by TA 2017_11_06

% function [detected_spike_locs, spikesBelowThresh, spikeTemplate, spikeDistThreshold, filter_params] = spike_extractor_170930(...
%     unfiltered_data, piezo, spike_params, init)

%% Code to match a given spike waveform across a recording (1-D); basic idea is to estimate warping distance via DTW and convert the  estimated warp distance into a probability via a kernel

% last_filt_params = [init.spikepath 'last_' spike_params.type '_filt_params.mat'];
% if exist(last_filt_params, 'file');load(last_filt_params); end

global vars;
vars.fs = spike_params.fs;
vars.spikeTemplateWidth = spike_params.spikeTemplateWidth;

max_len = 200000;
if length(unfiltered_data) < max_len
    vars.len = length(unfiltered_data)-1000;
else
    vars.len = max_len -1000;
end

% start_points = find(abs(unfiltered_data-mean(unfiltered_data)) >  3*std(abs(unfiltered_data)));
start_points = 100;

if isempty(start_points)
    start_points = 1000;end
% start_points = find(abs(unfiltered_data-mean(unfiltered_data)) >
% 4*std(abs(unfiltered_data)) & piezo >  0.5*max(piezo),10000)-max_len/4;
% %% older method that used the piezo signal to restrict windows for spike
% searching

start_point = max(start_points);
stop_point = min([start_point+vars.len length(unfiltered_data)]);

%% 
vars.fs = 10000;
vars.spikeTemplateWidth = 50;
vars.len = 49000;
vars.thresh_pos = 840;
vars.lp_pos = 420;
vars.hp_pos = 20;
vars.hp_cutoff = 283.9082;
vars.lp_cutoff = 403.0657;
vars.diff = 1;
vars.peak_threshold = 10.5860;
vars.Distance_threshold = 0.5000;

%                  vars.piezo: [49001×1 double]
%        vars.unfiltered_data: [49001×1 double]
%          vars.filtered_data: [1×49001 double]
%                   vars.locs: [1×21 double]
%          vars.spikeTemplate: [1×51 double]

filter_sliderGUI(unfiltered_data(start_point(1):stop_point), piezo(start_point:stop_point),spike_params.spikeTemplateWidth);

%% choose the filter parameters for pulling out spikes

if ~isempty(spike_params.spiketemplate)
    spikeTemplate = spike_params.spiketemplate;
    spike_params.spikeTemplateWidth = length(spikeTemplate);
else
    
    selected_spikes = [];
    while isempty(selected_spikes)          % Wait while the user does this.
        
        title('To use last spike filter parameters and HWD, hit any key, otherwise click the mouse...');
        reuse = waitforbuttonpress; % waitforbuttonpress returns 0 with click, 1 with key press, does not trigger on ctrl, shift, alt, caps lock, num lock, or scroll lock
        
        if reuse == 1
            spikeTemplate = vars.spikeTemplate;
            spike_params.Distance_threshold = vars.Distance_threshold;
            spike_params.approval_time = 2;
        else
            
            gcf; title('select filter params, threshold, and ROI, then hit enter');  zoom on;
            while ~waitforbuttonpress;end
            fig = gcf;cursorobj = datacursormode(fig);
            cursorobj.SnapToDataVertex = 'on'; % Snap to our plotted data, on by default
            title('select template spikes (hold alt to select multiple), then hit enter');
            cursorobj.Enable = 'on';     % Turn on the data cursor, hold alt to select multiple points
            while ~waitforbuttonpress;end % waitforbuttonpress returns 0 with click, 1 with key press, does not trigger on ctrl, shift, alt, caps lock, num lock, or scroll lock
            cursorobj.Enable = 'off';
            mypoints = getCursorInfo(cursorobj);
            
            try
                for hh = 1:length(mypoints)
                    template_center = [];template_center = mypoints(hh).Position(1);
                    spikeTemplateSeed(hh,:) = vars.filtered_data(template_center+(-spike_params.spikeTemplateWidth:spike_params.spikeTemplateWidth));
                end
            catch err
                display('no spikes selected'); detected_spike_locs = []; spikesBelowThresh = []; spikeTemplate = spike_params.spiketemplate;
            end
            
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
            middle = find(spikeTemplate==max(spikeTemplate));
            spikeTemplate = spikeTemplate(middle+1+(-floor(spike_params.spikeTemplateWidth/2):floor(spike_params.spikeTemplateWidth/2)));
        end
    end
    
    if isempty(spikeTemplate)
        detected_spike_locs = []; 
        spikesBelowThresh = [];
        return; 
    end;
    
    close;
    figure(12), plot(spikeTemplate), title('Template Waveform: wait one second');pause(1);close;
    vars.spikeTemplate = spikeTemplate;
end

%% get all the spike locs using the correct filt and thresh cvalues
spike_params.spikeTemplateWidth = length(spikeTemplate);
filts = vars.hp_cutoff/(vars.fs/2);
[x,y] = butter(4,filts,'high');%%bandpass filter between 50 and 200 Hz
filtered_data_high = filter(x, y, unfiltered_data);

filts = vars.lp_cutoff/(vars.fs/2);
[x2,y2] = butter(4,filts,'low');%%bandpass filter between 50 and 200 Hz
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

[locks, ~] = peakfinder(double(all_filtered_data),mean(all_filtered_data)+vars.peak_threshold*std(all_filtered_data));%% slightly different algorithm;  [peakLoc] = peakfinder(x0,sel,thresh) returns the indicies of local maxima that are at least sel above surrounding all_filtered_data and larger (smaller) than thresh if you are finding maxima (minima).

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
    
    if min(spike_locs(i)+spike_params.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(i)-spike_params.spikeTemplateWidth/2,0)< spike_params.spikeTemplateWidth
        continue
    else
        curSpikeTarget = all_filtered_data(spike_locs(i)+window);
        detectedUFSpikeCandidates(:,i) = unfiltered_data(spike_locs(i)+spikewindow); % all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0): min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
        detectedSpikeCandidates(:,i) = curSpikeTarget; % all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0): min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
        norm_curSpikeTarget = (curSpikeTarget-min(curSpikeTarget))/(max(curSpikeTarget)-min(curSpikeTarget));
        norm_detectedSpikeCandidates(:,i) = norm_curSpikeTarget;
        [targetSpikeDist(i), ~,~] = dtw_WarpingDistance(norm_curSpikeTarget, norm_spikeTemplate);
    end
end
if any(isnan(detectedUFSpikeCandidates(:)))
    error('some of the spikes are at the edge of the data');
end

% estimate spike probabilities at candidate locations
spikeProbs = zeros(size(spike_locs));
for i=1:length(spike_locs)
    if min(spike_locs(i)+spike_params.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(i)-spike_params.spikeTemplateWidth/2,0)< spike_params.spikeTemplateWidth
        continue
    else
        spikeProbs(i) = exp( -(abs(targetSpikeDist(i)-mean(targetSpikeDist))) / (2*var(targetSpikeDist)) );
    end
end



%% Up to here: 
% Filter the trace, then pick a few things that look like spikes, then go
% through all the things that pass threshold and compare the dtw_Warping
% Distance. use the distance to calculate probability from a t-distribution

% In the end, the spike probability is less usefull, unless very weird
% waveforms are included.

% Looking forward, the spike dist threshold is important, and way too high!


%%
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
plot(ax_main,unfiltered_data-mean(unfiltered_data),'color',[.85 .33 .1],'tag','unfiltered_data'), hold(ax_main,'on');

axis(ax_main,'off');

% Plot filtered data
ax_filtered = panl(2).select(); ax_filtered.Tag = 'filtered';
plot(ax_filtered,all_filtered_data-mean(all_filtered_data),'color',[.0 .45 .74],'tag','filtered_data'), hold(ax_filtered,'on');
axis(ax_filtered,'off');

panl(3).pack('h',{1/3 1/3 1/3})  

% Plot cumulative histogram of targetSpikeDist
ax_hist = panl(3,1).select(); ax_hist.Tag = 'hist';
title(ax_hist,'Click to change threshold'); xlabel(ax_hist,'DTW Distance');
[dist, order] = sort(targetSpikeDist);
cumy = (1:length(dist))/length(dist);
plot(ax_hist,dist,cumy,'o','markeredgecolor',[0 0.45 0.74],'tag','distance_hist','userdata',targetSpikeDist); hold(ax_hist,'on');
plot(ax_hist,vars.Distance_threshold*[1 1],[0 1],'color',[1 0 0],'tag','threshold');

% Plot all detected waveforms
ax_detect = panl(3,2).select(); ax_detect.Tag = 'detect';
title(ax_detect,'Click anywhere to use blue line as template');
suspect_ls = plot(ax_detect,window,norm_detectedSpikeCandidates,'tag','squiggles');
hold(ax_detect,'on'); 
plot(ax_detect,window,norm_spikeTemplate,'color',[.85 .85 .85], 'linewidth', 2)
plot(ax_detect,window,mean(norm_detectedSpikeCandidates,2),'color',[0 .7 1], 'linewidth', 2,'tag','potential_template')

suspect = targetSpikeDist<vars.Distance_threshold;

set(suspect_ls(suspect),'color',[0 0 0])

% Plot all detected spikes
ax_detect_patch = panl(3,3).select(); ax_detect_patch.Tag = 'detect_patch';
spikeWaveforms = detectedUFSpikeCandidates-repmat(detectedUFSpikeCandidates(1,:),size(detectedUFSpikeCandidates,1),1);
spikeWaveform = smooth(mean(spikeWaveforms(:,suspect),2));
spikeWaveform_ = smooth(diff(spikeWaveform));
spikeWaveform_ = smooth(diff(spikeWaveform_));
hold(ax_detect_patch,'on');
suspectUF_ls = plot(ax_detect_patch,spikewindow,spikeWaveforms,'tag','spikes');
suspectUF_avel = plot(ax_detect_patch,spikewindow,spikeWaveform,'color',[0 .7 1],'linewidth',2);
suspectUF_ddT2l = plot(ax_detect_patch,spikewindow(2:end-1),spikeWaveform_/max(spikeWaveform_)*max(spikeWaveform),'color',[0 .8 .4],'linewidth',2);

spikeTime = spikewindow(spikeWaveform_==max(spikeWaveform_));
spikePT = spikewindow(spikeWaveform==max(spikeWaveform));

set(suspectUF_ls(suspect),'color',[0 0 0])

% Plot spikes
suspect_dots = raster(ax_main,spike_locs+spikePT,max(unfiltered_data-mean(unfiltered_data))+.02*diff([min(unfiltered_data) max(unfiltered_data)]));
set(suspect_dots,'color',[0 0 0],'tag','dots','userdata',spikePT);
set(suspect_dots(~suspect),'color',[1 0 0],'linewidth',2)

% Divide detected events into spike suspects and non spike suspects
panl(4).pack('h',{1/4 1/4 1/4 1/4});

ax_fltrd_suspect = panl(4,1).select(); ax_fltrd_suspect.Tag = 'fltrd_suspect';
plot(ax_fltrd_suspect,window,norm_detectedSpikeCandidates(:,suspect),'tag','squiggles_suspect','color',[0 0 0]);

ax_unfltrd_suspect = panl(4,2).select(); ax_unfltrd_suspect.Tag = 'unfltrd_suspect';
plot(ax_unfltrd_suspect,spikewindow,spikeWaveforms(:,suspect),'tag','spikes_suspect','color',[0 0 0]);

ax_fltrd_notsuspect = panl(4,3).select(); ax_fltrd_notsuspect.Tag = 'fltrd_notsuspect';
if any(~suspect)
    plot(ax_fltrd_notsuspect,spikewindow,norm_detectedSpikeCandidates(:,~suspect),'tag','squiggles_notsuspect','color',[0 0 0]);
end

ax_unfltrd_notsuspect = panl(4,4).select(); ax_unfltrd_notsuspect.Tag = 'unfltrd_notsuspect';
if any(~suspect)
    plot(ax_unfltrd_notsuspect,spikewindow,spikeWaveforms(:,~suspect),'tag','spikes_notsuspect','color',[0 0 0]);
end

spikeThresholdUpdateGUI(disttreshfig,norm_detectedSpikeCandidates,spikeWaveforms);



%%
figure(11); clf; set(11, 'Position', [140          80        1600         900],'color', 'w');
accept_spikeDistThreshold_flag = 0;max_plot_length = 120*vars.fs;
while accept_spikeDistThreshold_flag == 0
    detected_spike_locs = [];clear spikesAboveThresh spikesBelowThresh spikesAboveThresh_aligned spikesBelowThresh_aligned;
    figure(11); clf;
    subplot(3,2,1); plot(norm_detectedSpikeCandidates), title('All detected spike candidates');hold on; plot(norm_spikeTemplate, 'k', 'linewidth', 4)
    subplot(3,2,3), hist(targetSpikeDist,20), title('Histogram of distances')
    
    if length(unfiltered_data) > max_plot_length
        subplot(3,2,5);title('Enter the new spike distance threshold:');hold all;
        plot(unfiltered_data(1:max_plot_length)-mean(unfiltered_data(1:max_plot_length))), hold on;
        plot(detected_spike_locs(detected_spike_locs<max_plot_length), zeros(1,sum(detected_spike_locs<max_plot_length)),'ro');
        xlim([start_point stop_point]);
    else
        subplot(3,2,5);title('Enter the new spike distance threshold:');hold all;        
        plot(unfiltered_data-mean(unfiltered_data)), hold on;
        plot(detected_spike_locs, zeros(1,length(detected_spike_locs)),'ro');
        xlim([start_point stop_point]);
    end
    
    spikesAboveThresh = []; spikesBelowThresh = [];spikeDistThreshold = [];detected_spike_locs = [];
    
    if isempty(spike_params.Distance_threshold)
        subplot(3,2,5);title('Enter the new spike distance threshold:');hold all;
        spikeDistThreshold = input('\n \n Enter the spike distance threshold:');
        vars.Distance_threshold = spikeDistThreshold;
    else
        spikeDistThreshold  = spike_params.Distance_threshold;
        vars.Distance_threshold = spike_params.Distance_threshold;
    end
    i =1;
    aboveThreshCounter =1;
    belowThreshCounter=1;
    
    while i<= length(spike_locs)
        if length(all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2))+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)))) >= spike_params.spikeTemplateWidth-1
            curSpikeTarget = all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2))+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
            %         if length(all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)),1)) >= spike_params.spikeTemplateWidth-1
            %             curSpikeTarget = all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)),1);
            if targetSpikeDist(i)> spikeDistThreshold
                spikesAboveThresh(:, aboveThreshCounter)= curSpikeTarget/max(abs(curSpikeTarget));
                aboveThreshCounter = aboveThreshCounter+1;
            else
                spikesBelowThresh(:, belowThreshCounter)= curSpikeTarget/max(abs(curSpikeTarget));
                belowThreshCounter = belowThreshCounter+1;
                detected_spike_locs = [detected_spike_locs;spike_locs(i)];
            end
        end
        i=i+1;
    end
    % update the counters
    belowThreshCounter = belowThreshCounter-1;
    aboveThreshCounter = aboveThreshCounter-1;
    
    %     ind = detected_spikes<spikeDistThreshold;
    %     finalSpikeLocs = detected_spike_locs;
    
    figure(11);
    subplot(3,2,2), plot(spikesAboveThresh), title(sprintf('Spikes above %f: number = %d', spikeDistThreshold, size(spikesAboveThresh,2)))
    subplot(3,2,4), plot(spikesBelowThresh), title(sprintf('Spikes below %f: number = %d', spikeDistThreshold, size(spikesBelowThresh,2)))
    if spike_params.approval== 0
        accept_spikeDistThreshold_flag = 1;
    elseif spike_params.approval == 1
        if length(unfiltered_data) > max_plot_length
            subplot(3,2,5), axis off; title({'Are you happy with the spike output?' 'Hit 0 if No'}); hold all;
            plot(unfiltered_data(1:max_plot_length)-mean(unfiltered_data(1:max_plot_length))), hold on;
            plot(detected_spike_locs(detected_spike_locs<max_plot_length), zeros(1,sum(detected_spike_locs<max_plot_length)),'ro');
            subplot(3,2,6), plot(all_filtered_data(1:max_plot_length)-mean(all_filtered_data((1:max_plot_length)))), hold on;
            plot(detected_spike_locs(detected_spike_locs<max_plot_length), zeros(1,sum(detected_spike_locs<max_plot_length)),'ro');
            title ('Estimated spikes');
        else
            subplot(3,2,5), axis off; title({'Are you happy with the spike output?' 'Hit 0 if No'}); hold all;
            plot(unfiltered_data-mean(unfiltered_data)), hold on;
            plot(detected_spike_locs, zeros(1,length(detected_spike_locs)),'ro');
            xlim([start_point stop_point]);
            subplot(3,2,6), plot(all_filtered_data-mean(all_filtered_data)), hold on;
            plot(detected_spike_locs, zeros(1,length(detected_spike_locs)),'ro');
            title ('Estimated spikes');xlim([start_point stop_point]);
        end
        if ~isfield(spike_params,'approval_time')
            spike_params.approval_time = 1;
        end
        accept_spikeDistThreshold_flag = timeinput(spike_params.approval_time); %%returns 1 if no input within 1 second
        spike_params.Distance_threshold = [];
    elseif spike_params.approval == 2
        subplot(3,2,5), axis off; title({'Are you happy with the spike output?' 'Hit Enter for yes or press 1 for No'}); hold all;
        if length(unfiltered_data) > 120*fs
            plot(unfiltered_data(1:max_plot_length)-mean(unfiltered_data(1:max_plot_length))), hold on;
            plot(detected_spike_locs(detected_spike_locs<max_plot_length), zeros(1,sum(detected_spike_locs<max_plot_length)),'ro');
            xlim([start_point stop_point]);
        else
            plot(unfiltered_data-mean(unfiltered_data)), hold on;
            plot(detected_spike_locs, zeros(1,length(detected_spike_locs)),'ro');
            xlim([start_point stop_point]);
        end
        accept_spikeDistThreshold_flag = input('\n Are you happy with the spike output? \n Hit Enter for yes or press 0 for No:');
        spike_params.Distance_threshold = [];
    end
end

filter_params = vars;
% save(last_filt_params, 'vars');display('spike filter parameters saved');

