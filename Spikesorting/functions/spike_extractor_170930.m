%% updated by JCT 05_17_2017

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

%% choose the filter parameters for pulling out spikes
filter_sliderGUI(unfiltered_data(start_point(1):stop_point), piezo(start_point:stop_point),spike_params.spikeTemplateWidth);

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
        spikeTemplate(hh,:) = vars.filtered_data(round(template_center-(0.5*spike_params.spikeTemplateWidth)):round(template_center+(0.5*spike_params.spikeTemplateWidth)));
        end
    catch err
        display('no spikes selected'); detected_spike_locs = []; spikesBelowThresh = []; spikeTemplate = spike_params.spiketemplate;
    end
   
end
    selected_spikes = 0;
        if size(spikeTemplate,1)>1; spikeTemplate = mean(spikeTemplate,1);end
end

if isempty(spikeTemplate); detected_spike_locs = []; spikesBelowThresh = []; 
return; end;

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
loccs = locks((locks> spike_params.spikeTemplateWidth)); %%to prevent strange happenings, make sure that spikes do not occur right at the edges
spike_locs = loccs(loccs < (length(all_filtered_data)-spike_params.spikeTemplateWidth));
spike_locs(all_filtered_data(spike_locs)> mean(all_filtered_data(spike_locs))+ 5*std(all_filtered_data(spike_locs))) = [];%% eliminate spikes that are way bigger than they're supposed to be

%% pool the detected spike candidates and do spike_params.spiketemplate matching
targetSpikeDist = zeros(size(spike_locs));
counter = 1;
for i=1:length(spike_locs)

    if min(spike_locs(i)+spike_params.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(i)-spike_params.spikeTemplateWidth/2,0)< spike_params.spikeTemplateWidth
        continue
    else
%         curSpikeTarget = all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1:min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)),1);  %% old method
%         detectedSpikeCandidates(:,counter) = all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0): min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)),1);
        curSpikeTarget = all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
        detectedSpikeCandidates(:,counter) = all_filtered_data(max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0): min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)));
        norm_curSpikeTarget = (curSpikeTarget-min(curSpikeTarget))/(max(curSpikeTarget)-min(curSpikeTarget));
        norm_spikeTemplate = (spikeTemplate-min(spikeTemplate))/(max(spikeTemplate)-min(spikeTemplate));
        norm_detectedSpikeCandidates(:, counter) = norm_curSpikeTarget;
        [targetSpikeDist(i), ~,~] = dtw_WarpingDistance(norm_curSpikeTarget, norm_spikeTemplate);
    end
    counter = counter+1;
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

%%
figure(11); clf; set(11, 'Position', [0 0 1600 900],'color', 'w');
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
    subplot(3,2,5);title('Enter the new spike distance threshold:');hold all;        plot(unfiltered_data-mean(unfiltered_data)), hold on; 
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
save(last_filt_params, 'vars');display('spike filter parameters saved');
% end
