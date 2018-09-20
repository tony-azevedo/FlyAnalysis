function varargout = spikeDetectionBatch(trialStem,trialnumlist,inputToAnalyze,vars_initial)
%% For now this function only gets the spikes from a single electrode.
% I'll need to come up with a different version (spikeDetectionPairs) when
% I start looking at pairs of neurons. Alternatively the wrapper function
% could just cal this function on the two sets of spikes.

global vars;

vars_initial = cleanUpSpikeVarsStruct(vars_initial);

% Create a figure that you can then click on to analyze spikes
disttreshfig = figure; clf; set(disttreshfig, 'Position', [140          80        1600         900],'color', 'w');
panl = panel(disttreshfig);

vertdivisions = [4 4]; vertdivisions = num2cell(vertdivisions/sum(vertdivisions));
panl.pack('v',vertdivisions)  % response panel, stimulus panel
panl.margin = [20 20 10 10];
panl.fontname = 'Arial';
panl(1).pack('h',{1/3 1/3 1/3})
panl(2).pack('h',{1/4 1/4 1/4 1/4});

% Plot cumulative histogram of targetSpikeDist
ax_hist = panl(1,1).select(); ax_hist.Tag = 'hist'; hold(ax_hist,'on');
title(ax_hist,'Click to change threshold'); xlabel(ax_hist,'DTW Distance');

plot(ax_hist,vars_initial.Distance_threshold*[1 1],[0 1],'color',[1 0 0],'tag','threshold');

% Plot all detected waveforms
ax_detect = panl(1,2).select(); ax_detect.Tag = 'detect';
title(ax_detect,'Templates');

% Plot all detected spikes
ax_detect_patch = panl(1,3).select(); ax_detect_patch.Tag = 'detect_patch';

ax_fltrd_suspect = panl(2,1).select(); ax_fltrd_suspect.Tag = 'fltrd_suspect';     hold(ax_fltrd_suspect,'on');
ax_unfltrd_suspect = panl(2,2).select(); ax_unfltrd_suspect.Tag = 'unfltrd_suspect';  hold(ax_unfltrd_suspect,'on');
ax_fltrd_notsuspect = panl(2,3).select(); ax_fltrd_notsuspect.Tag = 'fltrd_notsuspect';  hold(ax_fltrd_notsuspect,'on');
ax_unfltrd_notsuspect = panl(2,4).select(); ax_unfltrd_notsuspect.Tag = 'unfltrd_notsuspect';  hold(ax_unfltrd_notsuspect,'on');

window = -floor(vars_initial.spikeTemplateWidth/2): floor(vars_initial.spikeTemplateWidth/2);
spikewindow = window-floor(vars_initial.spikeTemplateWidth/2);
start_point = round(.01*vars_initial.fs);
smthwnd = (vars.fs/2000+1:length(spikewindow)-vars.fs/2000);

detectedUFSpikeCandidates = [];
detectedUFSpikeCandidates_acrossCells = [];
detectedSpikeCandidates = [];
detectedSpikeCandidates_acrossCells = [];
norm_detectedSpikeCandidates = [];
norm_detectedSpikeCandidates_acrossCells = [];
targetSpikeDist = [];
targetSpikeDist_acrossCells = [];
trialnumids = [];
spikes_acrossCells = [];

norm_spikeTemplate = (vars_initial.spikeTemplate-min(vars_initial.spikeTemplate))/(max(vars_initial.spikeTemplate)-min(vars_initial.spikeTemplate));
total_spikes = 10;

norm_spikeTemplate_ = plot(ax_detect,window,norm_spikeTemplate,'color',[1 .3 0.74], 'linewidth', 2,'tag','initial_template');
hold(ax_detect,'on');

for tr_idx = trialnumlist
    
    trial = load(sprintf(trialStem,tr_idx));
    if isfield(trial,'excluded') && trial.excluded
        fprintf(' * Trial excluded: %s\n',trial.name)
        continue
    end
    if isfield(trial,'spikeSpotChecked') && trial.spikeSpotChecked
        fprintf(' * Trial spot checked for spikes already: %s\n',trial.name)
        %continue
    end
    
    % Get out all the potential spikes
    spikeDetectSingleTrial(trial,inputToAnalyze,vars_initial);
    
    % concatonate the matrices from different cells
    detectedUFSpikeCandidates_acrossCells = cat(2,detectedUFSpikeCandidates_acrossCells,detectedUFSpikeCandidates);
    detectedSpikeCandidates_acrossCells = cat(2,detectedSpikeCandidates_acrossCells,detectedSpikeCandidates);
    norm_detectedSpikeCandidates_acrossCells = cat(2,norm_detectedSpikeCandidates_acrossCells,norm_detectedSpikeCandidates);
    targetSpikeDist_acrossCells = cat(2,targetSpikeDist_acrossCells,targetSpikeDist);
    trialnumids = cat(2,trialnumids,tr_idx*ones(size(targetSpikeDist)));
    spikes_acrossCells = cat(2,spikes_acrossCells,vars.locs);
    
    % plot the spike distances as you go
    dist = sort(targetSpikeDist);
    cumy = (1:length(dist))/length(dist); % full distribution
    plot(ax_hist,dist,cumy,'o','markeredgecolor',[1 .3 0.74],'tag',['distance_hist_' num2str(tr_idx)],'userdata',targetSpikeDist);

    % find the spikes < dist thresh, get the best fit
    suspect = targetSpikeDist<vars.Distance_threshold;
    suspect_idx = find(suspect);
    [dist, order] = sort(targetSpikeDist(suspect_idx));
    cumy_ = (1:length(dist))/length(dist); % compare to other suspect spikes
 
    goodi = cumy_>=.25 & cumy_<=.5;
    weirdi = cumy_>.92 & cumy_<=1 & dist>.83*vars.Distance_threshold;
    goodspikes = order(goodi);
    weirdspikes = order(weirdi);

    % create a new template as you go
    if any(goodspikes)
        % The more spikes, the more the norm_spikeTemplate is updated
        newtemplate = mean(detectedSpikeCandidates_acrossCells(:,suspect_idx(goodspikes)),2);
        newtemplate = (newtemplate-min(newtemplate))/(max(newtemplate)-min(newtemplate));
        norm_spikeTemplate = norm_spikeTemplate(:)*total_spikes + newtemplate(:)*length(goodspikes);
        total_spikes = total_spikes+length(goodspikes);
    end

    norm_spikeTemplate = (norm_spikeTemplate-min(norm_spikeTemplate))/(max(norm_spikeTemplate)-min(norm_spikeTemplate));

    cumy_suspect = (1:length(dist))/length(targetSpikeDist); % select suspect spikes from full distribution
    plot(ax_hist,dist,cumy_suspect,'o','markeredgecolor',[0 0.45 0.74],'tag',['suspect_hist_' num2str(tr_idx)]);

    plot(ax_hist,dist(goodi),cumy_suspect(goodi),'o','markeredgecolor',[0 0 0], 'markerfacecolor',[0 0 0],'tag',['good_hist' num2str(tr_idx)]); hold(ax_hist,'on');
    plot(ax_hist,dist(weirdi),cumy_suspect(weirdi),'o','markeredgecolor',[0 1 .7], 'markerfacecolor',[0 1 .7],'tag',['weird_hist' num2str(tr_idx)]); hold(ax_hist,'on');
    
    if ~isempty(goodspikes)
        suspect_ls = plot(ax_detect,window,norm_detectedSpikeCandidates(:,suspect_idx(goodspikes)),'tag','squiggles');
        set(suspect_ls,'color',[0 0 0])
        hold(ax_detect,'on');
    end
    if ~isempty(weirdspikes)
        suspect_ls = plot(ax_detect,window,norm_detectedSpikeCandidates(:,suspect_idx(weirdspikes)),'tag','squiggles');
        set(suspect_ls,'color',[0 1 .7])
    end
    % plot(ax_detect,window,mean(norm_detectedSpikeCandidates(:,suspect_idx),2),'color',[0 .7 1], 'linewidth', 2,'tag','potential_template')

    spikeWaveforms = detectedUFSpikeCandidates(:,suspect);
    spikeWaveforms = spikeWaveforms-repmat(spikeWaveforms(1,:),size(spikeWaveforms,1),1);
    spikeWaveform = smooth(mean(spikeWaveforms,2),vars.fs/2000);
    spikeWaveform_ = smoothAndDifferentiate(spikeWaveform,vars.fs/2000);

        
    if ~isempty(goodspikes)
        suspectUF_ls = plot(ax_detect_patch,spikewindow,spikeWaveforms(:,goodspikes),'tag','spikes');
        set(suspectUF_ls,'color',[0 0 0])
        hold(ax_detect_patch,'on');
    end
    
    if ~isempty(weirdspikes)
        suspectUF_ls = plot(ax_detect_patch,spikewindow,spikeWaveforms(:,weirdspikes),'tag','spikes');
        set(suspectUF_ls,'color',[0 1 .7])
    end
    if any(suspect)
        suspectUF_avel = plot(ax_detect_patch,spikewindow,spikeWaveform,'color',[0 .7 1],'linewidth',2);
        suspectUF_ddT2l = plot(ax_detect_patch,spikewindow(smthwnd(2:end-1)),spikeWaveform_(smthwnd(2:end-1))/max(spikeWaveform_(smthwnd(2:end-1)))*max(spikeWaveform),'color',[0 .8 .4],'linewidth',2);
        
        spikeTime = spikewindow(spikeWaveform_==max(spikeWaveform_));
        spikePT = spikewindow(spikeWaveform==max(spikeWaveform));
        spikePT = spikePT(1);
    else
        spikeTime = 0;
        spikePT = 0;
    end
    
    % Divide detected events into spike suspects and non spike suspects
    if any(goodspikes)
        plot(ax_fltrd_suspect,window,norm_detectedSpikeCandidates(:,suspect_idx(goodspikes)),'tag','squiggles_suspect','color',[0 0 0]);
    end
    
    if any(goodspikes)
        plot(ax_unfltrd_suspect,spikewindow,spikeWaveforms(:,goodspikes),'tag','spikes_suspect','color',[0 0 0]);
    end
    
    if any(weirdspikes)
        plot(ax_fltrd_notsuspect,window,norm_detectedSpikeCandidates(:,suspect_idx(weirdspikes)),'tag','squiggles_notsuspect','color',[0 0 0]);
    end
    
    if any(weirdspikes)
        plot(ax_unfltrd_notsuspect,spikewindow,spikeWaveforms(:,weirdspikes),'tag','spikes_notsuspect','color',[0 0 0]);
    end
    
    norm_spikeTemplate_.YData = norm_spikeTemplate;
    drawnow
end

ylims = [min([min(ax_unfltrd_notsuspect.YLim) min(ax_unfltrd_suspect.YLim)]) max([max(ax_unfltrd_notsuspect.YLim) max(ax_unfltrd_suspect.YLim)])];
set([ax_unfltrd_notsuspect,ax_unfltrd_suspect],'YLim',ylims)

spikeThresholdUpdateGUI_local(disttreshfig,norm_detectedSpikeCandidates_acrossCells,detectedUFSpikeCandidates_acrossCells,targetSpikeDist_acrossCells,trialnumids);

fprintf('Go ahead, change the threshold now');
uiwait();

% The threshold is finally set, get rid of spikes that are over
% the threshold
if ~isempty(targetSpikeDist_acrossCells)
        
    % pull out spikes, but keep a record of indices 
    suspect = targetSpikeDist_acrossCells<vars.Distance_threshold;

    vars.locs = spikes_acrossCells;
    vars = estimateSpikeTimeFromInflectionPoint(vars,detectedUFSpikeCandidates_acrossCells,targetSpikeDist_acrossCells);

    spikes = vars.locs;
    spikes = spikes+start_point;
    spikes_acrossCells = spikes;
    spikes_uncorrected = vars.locs_uncorrected+start_point;

    for tr_idx = trialnumlist
        vars.lastfilename = trial.name;
       
        trial = load(sprintf(trialStem,tr_idx));
        if isfield(trial,'excluded') && trial.excluded
            fprintf(' * Trial excluded: %s\n',trial.name)
            continue
        end
        if isfield(trial,'spikeSpotChecked') && trial.spikeSpotChecked
            fprintf(' * Trial spot checked for spikes already, not saving: %s\n',trial.name)
            %continue
        end

        tr_spikes = spikes(trialnumids==tr_idx & suspect);
        tr_uncorrectedspikes = spikes_uncorrected(trialnumids==tr_idx & suspect);
                
        if isempty(tr_spikes)
            trial.spikes = tr_spikes;
            trial.spikes_uncorrected = tr_uncorrectedspikes;
            trial.spikeDetectionParams = vars;
            save(trial.name, '-struct', 'trial');
            fprintf('Saved Spikes (0) and filter parameters saved: %s\n',numel(trial.spikes),trial.name);
            continue
        end
        trial.spikes = tr_spikes;
        trial.spikes_uncorrected = tr_uncorrectedspikes;
        trial.spikeDetectionParams = vars;
        trial.spikeSpotChecked = 0;
        save(trial.name, '-struct', 'trial');
        fprintf('Saved Spikes (%d) and filter parameters saved: %s\n',numel(trial.spikes),trial.name);
        
    end
    
end
acrossCellSpikeData.detectedUFSpikeCandidates_acrossCells = detectedUFSpikeCandidates_acrossCells;
acrossCellSpikeData.detectedSpikeCandidates_acrossCells = detectedSpikeCandidates_acrossCells;
acrossCellSpikeData.norm_detectedSpikeCandidates_acrossCells = norm_detectedSpikeCandidates_acrossCells;
acrossCellSpikeData.targetSpikeDist_acrossCells = targetSpikeDist_acrossCells;
acrossCellSpikeData.trialnumids = trialnumids;
acrossCellSpikeData.spikes_acrossCells = spikes_acrossCells;
varargout = {acrossCellSpikeData};



    function spikeDetectSingleTrial(trial,inputToAnalyze,vars_initial)
        unfiltered_data = filterMembraneVoltage(trial.(inputToAnalyze),trial.params.sampratein);
        % d1 = getacqpref('FlyAnalysis',['VoltageFilter_fs' num2str(trial.params.sampratein)]);
        % unfiltered_data = filter(d1,unfiltered_data);
        
        vars = vars_initial;
        
        max_len = 400000;
        if length(unfiltered_data) < max_len
            vars.len = length(unfiltered_data)-round(.01*trial.params.sampratein);
        else
            vars.len = max_len -round(.01*trial.params.sampratein);
        end
        
        stop_point = min([start_point+vars.len length(unfiltered_data)]);
        unfiltered_data = unfiltered_data(start_point+1:stop_point);
        
        vars.unfiltered_data = unfiltered_data;
        
        all_filtered_data = filterDataWithSpikes(vars);
        spike_locs = findSpikeLocations(vars,all_filtered_data);
        
        clear locks loccs
        
        % pool the detected spike candidates and do spike_params.spiketemplate matching
        targetSpikeDist = zeros(size(spike_locs));
        % norm_spikeTemplate was created in the wrapper function
        
        %window = (max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)))
        % Should have gotten rid of spikes near the beginning or end of the data
        window = -floor(vars.spikeTemplateWidth/2): floor(vars.spikeTemplateWidth/2);
        spikewindow = window-floor(vars.spikeTemplateWidth/2);
        
        detectedUFSpikeCandidates = nan(size(window(:),1),size(spike_locs(:),1));
        detectedSpikeCandidates = detectedUFSpikeCandidates;
        norm_detectedSpikeCandidates = detectedUFSpikeCandidates;
        
        for sp=1:length(spike_locs)
            % in the case of a single location, the template doesn't match
            % the one coming out of seed template matching
            if min(spike_locs(sp)+vars.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(sp)-vars.spikeTemplateWidth/2,0)< vars.spikeTemplateWidth
                continue
            else
                curSpikeTarget = all_filtered_data(spike_locs(sp)+window);
                detectedUFSpikeCandidates(:,sp) = vars.unfiltered_data(spike_locs(sp)+spikewindow); 
                detectedSpikeCandidates(:,sp) = curSpikeTarget; 
                norm_curSpikeTarget = (curSpikeTarget-min(curSpikeTarget))/(max(curSpikeTarget)-min(curSpikeTarget));
                norm_detectedSpikeCandidates(:,sp) = norm_curSpikeTarget;
                [targetSpikeDist(sp), ~,~] = dtw_WarpingDistance(norm_curSpikeTarget, norm_spikeTemplate);
            end
        end
        if any(isnan(detectedUFSpikeCandidates(:)))
            error('some of the spikes are at the edge of the data');
        end
        vars.locs = spike_locs;
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
        

function spikeThresholdUpdateGUI_local(disttreshfig,norm_detectedSpikeCandidates_acrossCells,detectedUFSpikeCandidates_acrossCells,targetSpikeDist_acrossCells,trialnumids)
global squiggles
global spikes
global spikeDists
global trialnums

squiggles = norm_detectedSpikeCandidates_acrossCells;
spikes = detectedUFSpikeCandidates_acrossCells;
spikeDists = targetSpikeDist_acrossCells;
trialnums = trialnumids;

% set(suspect_ls(suspect),'color',[0 0 0])
ax_hist = findobj(disttreshfig,'Tag','hist');

ax_hist.ButtonDownFcn = @updateSpikeThreshold;

updateSpikeThreshold(ax_hist,[])
end

function updateSpikeThreshold(hObject,eventdata)
global vars 
global squiggles
global spikes
global spikeDists
global trialnums

trialnumlist = unique(trialnums);

disttreshfig = get(hObject,'parent');
if ~isempty(eventdata) && hObject==eventdata.Source
    vars.Distance_threshold = hObject.CurrentPoint(1);
end
if isempty(eventdata)
    return
end
    
ax_hist = findobj(disttreshfig,'Tag','hist');
ax_detect = findobj(disttreshfig,'Tag','detect');
ax_detect_patch = findobj(disttreshfig,'Tag','detect_patch');

ax_fltrd_suspect = findobj(disttreshfig,'Tag','fltrd_suspect');
ax_unfltrd_suspect = findobj(disttreshfig,'Tag' ,'unfltrd_suspect');
ax_fltrd_notsuspect = findobj(disttreshfig,'Tag','fltrd_notsuspect');
ax_unfltrd_notsuspect = findobj(disttreshfig,'Tag','unfltrd_notsuspect');

thresh_l = findobj(ax_hist,'tag','threshold');
thresh_l.XData = vars.Distance_threshold*[1 1];

cla(ax_fltrd_notsuspect)
cla(ax_unfltrd_notsuspect)

meanspike = findobj(ax_detect_patch,'color',[0 .7 1]); meanspike = meanspike(1);
meansquiggle = findobj(ax_detect,'color',[1 .3 0.74]);

for tr_idx = trialnumlist
    spkDs = spikeDists(trialnums==tr_idx);
    
    delete(findobj(ax_hist,'tag',['suspect_hist_' num2str(tr_idx)]));
    delete(findobj(ax_hist,'tag',['weird_hist' num2str(tr_idx)]));
    gooddots = findobj(ax_hist,'tag',['good_hist' num2str(tr_idx)]);

    % find the spikes < dist thresh, get the best fit
    suspect = spkDs<vars.Distance_threshold;
    suspect_idx = find(suspect);
    [dist, order] = sort(spkDs(suspect_idx));
    cumy = (1:length(dist))/length(dist);
 
    weirdi = cumy>.92 & cumy<=1 & dist>.83*vars.Distance_threshold;
    weirdspikes = order(weirdi);

    cumy = (1:length(dist))/length(spkDs);
    
    plot(ax_hist,dist,cumy,'o','markeredgecolor',[0 0.45 0.74],'tag',['suspect_hist_' num2str(tr_idx)]);
    uistack(gooddots,'top')
    plot(ax_hist,dist(weirdi),cumy(weirdi),'o','markeredgecolor',[0 1 .7], 'markerfacecolor',[0 1 .7],'tag',['weird_hist' num2str(tr_idx)]); hold(ax_hist,'on');
    
    if any(weirdspikes)
        trinds = find(trialnums==tr_idx);
        trinds = trinds(suspect_idx(weirdspikes));
        
        plot(ax_fltrd_notsuspect,meansquiggle.XData,squiggles(:,trinds),'tag','squiggles_notsuspect','color',[0 1 .7]);
        
        trspikes = spikes(:,trinds);
        trspikes = trspikes-repmat(trspikes(1,:),size(trspikes,1),1);
        plot(ax_unfltrd_notsuspect,meanspike.XData,trspikes,'tag','spikes_notsuspect','color',[0 0 0]);
    end
end

ylims = [min([min(ax_unfltrd_notsuspect.YLim) min(ax_unfltrd_suspect.YLim)]) max([max(ax_unfltrd_notsuspect.YLim) max(ax_unfltrd_suspect.YLim)])];
set([ax_unfltrd_notsuspect,ax_unfltrd_suspect],'YLim',ylims)
end
