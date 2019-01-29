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
smthwnd = (vars_initial.fs/2000+1:length(spikewindow)-vars_initial.fs/2000);

detectedUFSpikeCandidates = [];
detectedUFSpikeCandidates_acrossCells = [];
detectedSpikeCandidates = [];
detectedSpikeCandidates_acrossCells = [];
norm_detectedSpikeCandidates = [];
norm_detectedSpikeCandidates_acrossCells = [];
targetSpikeDist = [];
targetSpikeDist_acrossCells = [];
spikeAmplitude = [];
spikeAmplitude_acrossCells = [];
trialnumids = [];
spikes_acrossCells = [];

norm_spikeTemplate = (vars_initial.spikeTemplate-min(vars_initial.spikeTemplate))/(max(vars_initial.spikeTemplate)-min(vars_initial.spikeTemplate));
total_spikes = 10;

norm_spikeTemplate_ = plot(ax_detect,window,norm_spikeTemplate,'color',[1 .3 0.74], 'linewidth', 2,'tag','initial_template');
spikeTemplate_ = plot(ax_detect,window,vars_initial.spikeTemplate,'color',[1 .3 0.74], 'linewidth', 2,'tag','initial_template');
hold(ax_detect,'on');

for tr_idx = trialnumlist
    
    trial = load(sprintf(trialStem,tr_idx));
    fprintf('%s\n',trial.name)
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
    targetSpikeDist_acrossCells = cat(1,targetSpikeDist_acrossCells,targetSpikeDist);
    spikeAmplitude_acrossCells = cat(1,spikeAmplitude_acrossCells,spikeAmplitude);
    trialnumids = cat(1,trialnumids,tr_idx*ones(size(targetSpikeDist)));
    spikes_acrossCells = cat(1,spikes_acrossCells,vars.locs(:));
    
    if isempty(vars.locs)
        continue
    end
    
    % find the spikes < dist thresh, get the best fit
    goodspikeAmp = mean(spikeAmplitude(targetSpikeDist<quantile(targetSpikeDist,.25)));
    suspect = targetSpikeDist<vars.Distance_threshold & spikeAmplitude > goodspikeAmp*vars.Amplitude_threshold;

    suspect_idx = find(suspect);
    suspectdist = targetSpikeDist(suspect_idx);
    suspectamp = spikeAmplitude(suspect_idx);
 
    goodi = suspectdist >= quantile(suspectdist,.2) & suspectdist <= quantile(suspectdist,.25);
    weirdi = suspectdist>quantile(suspectdist,.92) & suspectdist>.83*vars.Distance_threshold;
    goodspikes = suspect_idx(goodi);
    weirdspikes = suspect_idx(weirdi);

    % create a new template as you go
    if any(goodspikes)
        % The more spikes, the more the norm_spikeTemplate is updated
        template = mean(detectedSpikeCandidates_acrossCells(:,goodspikes),2);
        newtemplate = (template-min(template))/(max(template)-min(template));
        norm_spikeTemplate = norm_spikeTemplate(:)*total_spikes + newtemplate(:)*length(goodspikes);
        total_spikes = total_spikes+length(goodspikes);
    end

    norm_spikeTemplate = (norm_spikeTemplate-min(norm_spikeTemplate))/(max(norm_spikeTemplate)-min(norm_spikeTemplate));

        % plot the spike distances as you go
    hist_dots_out = plot(ax_hist,targetSpikeDist(~suspect),spikeAmplitude(~suspect),'.','color',[0.9290 0.6940 0.1250],'tag',['suspect_hist_out_' num2str(tr_idx)]); hold(ax_hist,'on');
    hist_dots_in = plot(ax_hist,suspectdist,suspectamp,'.','markeredgecolor',[0 0.45 0.74],'markerfacecolor','none','tag',['suspect_hist_' num2str(tr_idx)],'userdata',[targetSpikeDist(:) spikeAmplitude(:)]);
    plot(ax_hist,suspectdist(goodi),suspectamp(goodi),'.','markeredgecolor',[0 0 0],'markerfacecolor',[0 0 0],'tag',['good_hist' num2str(tr_idx)]); hold(ax_hist,'on');
    plot(ax_hist,suspectdist(weirdi),suspectamp(weirdi),'.','markeredgecolor',[0 1 .7], 'markerfacecolor',[0 1 .7],'tag',['weird_hist' num2str(tr_idx)]); hold(ax_hist,'on');
    
    uistack([hist_dots_out hist_dots_in],'bottom')
    
    if find(trialnumlist==tr_idx) > 50
        continue
    end
    
    if ~isempty(goodspikes)
        % suspect_ls = plot(ax_detect,window,norm_detectedSpikeCandidates(:,goodspikes),'tag','squiggles');
        suspect_ls = plot(ax_detect,window,detectedSpikeCandidates(:,goodspikes),'tag','squiggles');
        set(suspect_ls,'color',[0 0 0])
        hold(ax_detect,'on');
    end
    if ~isempty(weirdspikes)
        % suspect_ls = plot(ax_detect,window,norm_detectedSpikeCandidates(:,weirdspikes),'tag','squiggles');
        suspect_ls = plot(ax_detect,window,detectedSpikeCandidates(:,weirdspikes),'tag','squiggles');
        set(suspect_ls,'color',[0 1 .7])
    end
    % plot(ax_detect,window,mean(norm_detectedSpikeCandidates(:,suspect_idx),2),'color',[0 .7 1], 'linewidth', 2,'tag','potential_template')

    spikeWaveforms = detectedUFSpikeCandidates(:,suspect);
    spikeWaveforms = spikeWaveforms-repmat(spikeWaveforms(1,:),size(spikeWaveforms,1),1);
    spikeWaveform = smooth(mean(spikeWaveforms,2),vars.fs/2000);
    spikeWaveform_ = smoothAndDifferentiate(spikeWaveform,vars.fs/2000);

        
    if ~isempty(goodspikes)
        suspectUF_ls = plot(ax_detect_patch,spikewindow,spikeWaveforms(:,goodi),'tag','spikes');
        set(suspectUF_ls,'color',[0 0 0])
        hold(ax_detect_patch,'on');
    end
    
    if ~isempty(weirdspikes)
        suspectUF_ls = plot(ax_detect_patch,spikewindow,spikeWaveforms(:,weirdi),'tag','spikes');
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
        %plot(ax_fltrd_suspect,window,norm_detectedSpikeCandidates(:,goodspikes),'tag','squiggles_suspect','color',[0 0 0]);
        plot(ax_fltrd_suspect,window,detectedSpikeCandidates(:,goodspikes),'tag','squiggles_suspect','color',[0 0 0]);
        spikeTemplate_.YData = template;
    end
    
    if any(goodspikes)
        plot(ax_unfltrd_suspect,spikewindow,spikeWaveforms(:,goodi),'tag','spikes_suspect','color',[0 0 0]);
    end
    
    if any(weirdspikes)
        %plot(ax_fltrd_notsuspect,window,norm_detectedSpikeCandidates(:,weirdspikes),'tag','squiggles_notsuspect','color',[0 0 0]);
        plot(ax_fltrd_notsuspect,window,detectedSpikeCandidates(:,weirdspikes),'tag','squiggles_notsuspect','color',[0 0 0]);
    end
    
    if any(weirdspikes)
        plot(ax_unfltrd_notsuspect,spikewindow,spikeWaveforms(:,weirdi),'tag','spikes_notsuspect','color',[0 0 0]);
    end
    
    % norm_spikeTemplate_.YData = norm_spikeTemplate;
    drawnow
end

ylims = [min([min(ax_unfltrd_notsuspect.YLim) min(ax_unfltrd_suspect.YLim)]) max([max(ax_unfltrd_notsuspect.YLim) max(ax_unfltrd_suspect.YLim)])];
set([ax_unfltrd_notsuspect,ax_unfltrd_suspect],'YLim',ylims)
vars = rmfield(vars,'unfiltered_data');
vars = rmfield(vars,'locs');

if ~isempty(targetSpikeDist_acrossCells)
    distthresh_l = plot(ax_hist,vars.Distance_threshold*[1 1],[min(spikeAmplitude_acrossCells) max(spikeAmplitude_acrossCells)],'color',[1 0 0],'tag','dist_threshold');
    ampthresh_l = plot(ax_hist,[min(targetSpikeDist_acrossCells) max(targetSpikeDist_acrossCells)],vars.Amplitude_threshold*[1 1],'color',[1 0 0],'tag','amp_threshold');
    
    xlims = ampthresh_l.XData+[-1 1]*.1*diff(ampthresh_l.XData);
    xlims = [xlims(1) max([xlims(2) distthresh_l.XData(2)*1.1])];
    ylims = distthresh_l.YData+[-1 1]*.1*diff(distthresh_l.YData);
    ylims = [min([ylims(1), ampthresh_l.YData(1)-0.1*diff([ampthresh_l.YData(1) max(distthresh_l.YData)])]) ylims(2)];
    set(ax_hist,'XLim',xlims,'YLim',ylims);
    
    spikeThresholdUpdateGUI_local(disttreshfig,norm_detectedSpikeCandidates_acrossCells,detectedUFSpikeCandidates_acrossCells,targetSpikeDist_acrossCells,spikeAmplitude_acrossCells,trialnumids);
    
    fprintf('Calculating spike times');

    % pull out spikes, but keep a record of indices 
    suspect = targetSpikeDist_acrossCells<vars.Distance_threshold & spikeAmplitude_acrossCells > vars.Amplitude_threshold;
 
    vars.locs = spikes_acrossCells;
    vars = estimateSpikeTimeFromInflectionPoint(vars,detectedUFSpikeCandidates_acrossCells,targetSpikeDist_acrossCells);

    spikes = vars.locs;
    spikes = spikes+start_point;
    spikes_acrossCells = spikes;
    spikes_uncorrected = vars.locs_uncorrected+start_point;
    
    vars = rmfield(vars,'locs');
    vars = rmfield(vars,'locs_uncorrected');
    
    for tr_idx = trialnumlist
        vars.lastfilename = trial.name;
       
        trial = load(sprintf(trialStem,tr_idx));
        if isfield(trial,'excluded') && trial.excluded
            fprintf(' * Trial excluded: %s\n',trial.name)
            continue
        end
        if isfield(trial,'spikeSpotChecked') && trial.spikeSpotChecked
            fprintf(' * Trial spot checked for spikes already, not saving: %s\n',trial.name)
            continue
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
    
else
    fprintf('*******No spikes detected in that set**********\n')
    for tr_idx = trialnumlist
        vars.lastfilename = trial.name;
        
        trial = load(sprintf(trialStem,tr_idx));
        if isfield(trial,'excluded') && trial.excluded
            fprintf(' * Trial excluded: %s\n',trial.name)
            continue
        end
        if isfield(trial,'spikeSpotChecked') && trial.spikeSpotChecked
            fprintf(' * Trial spot checked for spikes already, not saving: %s\n',trial.name)
            continue
        end
        
        trial.spikes = [];
        trial.spikes_uncorrected = [];
        trial.spikeDetectionParams = vars;
        save(trial.name, '-struct', 'trial');
        fprintf('Saved Spikes (0) and filter parameters saved: %s\n',numel(trial.spikes),trial.name);
        
    end

end
acrossCellSpikeData.detectedUFSpikeCandidates_acrossCells = detectedUFSpikeCandidates_acrossCells;
acrossCellSpikeData.detectedSpikeCandidates_acrossCells = detectedSpikeCandidates_acrossCells;
acrossCellSpikeData.norm_detectedSpikeCandidates_acrossCells = norm_detectedSpikeCandidates_acrossCells;
acrossCellSpikeData.targetSpikeDist_acrossCells = targetSpikeDist_acrossCells;
acrossCellSpikeData.spikeAmplitude_acrossCells = spikeAmplitude_acrossCells;
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
        if isempty(spike_locs)
            vars.locs = spike_locs;
            detectedUFSpikeCandidates = [];
            detectedSpikeCandidates = [];
            norm_detectedSpikeCandidates = [];
            targetSpikeDist = [];
            spikeAmplitude = [];
            %window = ; % same as before;
            %spikewindow = ; % same as before
            return
        end
        
        [detectedUFSpikeCandidates,...
            detectedSpikeCandidates,...
            norm_detectedSpikeCandidates,...
            targetSpikeDist,...
            spikeAmplitude,...
            window,...
            spikewindow] = ...
            getSquiggleDistanceFromTemplate(spike_locs,vars.spikeTemplate,all_filtered_data,vars.unfiltered_data,vars.spikeTemplateWidth,vars.fs);

        spikeamp_cell = mean(spikeAmplitude(targetSpikeDist<quantile(targetSpikeDist,.25)));
        spikeamp_cell = mean(spikeAmplitude(targetSpikeDist<quantile(targetSpikeDist,.25) &...
            spikeAmplitude > vars.Amplitude_threshold * spikeamp_cell));
        if isnan(spikeamp_cell)
            spikeamp_cell = mean(spikeAmplitude);
        end
        
        % Normalize the spike Amplitudes for comparison across cells
        spikeAmplitude = spikeAmplitude/spikeamp_cell;
        detectedUFSpikeCandidates = detectedUFSpikeCandidates/spikeamp_cell;
        if any(isnan(detectedUFSpikeCandidates(1,:)))
            disp(spikeamp_cell);
        end
        
        vars.locs = spike_locs;
    end

end
        

function spikeThresholdUpdateGUI_local(disttreshfig,norm_detectedSpikeCandidates_acrossCells,detectedUFSpikeCandidates_acrossCells,targetSpikeDist_acrossCells,spikeAmplitude_acrossCells,trialnumids)
global squiggles
global spikes
global spikeDists
global spikeAmps
global trialnums

squiggles = norm_detectedSpikeCandidates_acrossCells;
spikes = detectedUFSpikeCandidates_acrossCells;
spikeDists = targetSpikeDist_acrossCells;
spikeAmps = spikeAmplitude_acrossCells;
trialnums = trialnumids;

% set(suspect_ls(suspect),'color',[0 0 0])
ax_hist = findobj(disttreshfig,'Tag','hist');

distthresh_l = findobj(ax_hist,'tag','dist_threshold');
ampthresh_l = findobj(ax_hist,'tag','amp_threshold');
distthresh_l.Color = [0 1 1];

ax_hist.ButtonDownFcn = @updateSpikeThreshold;

title(ax_hist,'Click to change distance threshold (X-axis)');
updateSpikeThreshold(ax_hist,[])

while ~waitforbuttonpress;end

distthresh_l.Color = [1 0 0];
ampthresh_l.Color = [0 1 1];

ax_hist.ButtonDownFcn = @updateAmpThreshold;

title(ax_hist,'Click to change amplitude threshold (Y-axis)');

updateAmpThreshold(ax_hist,[])
while ~waitforbuttonpress;end

end


function updateSpikeThreshold(hObject,eventdata)
global vars 

if ~isempty(eventdata) && hObject==eventdata.Source
    vars.Distance_threshold = hObject.CurrentPoint(1);
end

updatePanels(hObject,[])
end

function updateAmpThreshold(hObject,eventdata)
global vars 

if ~isempty(eventdata) && hObject==eventdata.Source
    vars.Amplitude_threshold = hObject.CurrentPoint(1,2);
end

updatePanels(hObject,[])
end


function updatePanels(hObject,~)

global vars 
global squiggles
global spikes
global spikeDists
global spikeAmps
global trialnums
    
trialnumlist = unique(trialnums);

disttreshfig = get(hObject,'parent');

ax_hist = findobj(disttreshfig,'Tag','hist');
ax_detect = findobj(disttreshfig,'Tag','detect');
ax_detect_patch = findobj(disttreshfig,'Tag','detect_patch');

ax_fltrd_suspect = findobj(disttreshfig,'Tag','fltrd_suspect');
ax_unfltrd_suspect = findobj(disttreshfig,'Tag' ,'unfltrd_suspect');
ax_fltrd_notsuspect = findobj(disttreshfig,'Tag','fltrd_notsuspect');
ax_unfltrd_notsuspect = findobj(disttreshfig,'Tag','unfltrd_notsuspect');

distthresh_l = findobj(ax_hist,'tag','dist_threshold');
distthresh_l.XData = vars.Distance_threshold*[1 1];
ampthresh_l = findobj(ax_hist,'tag','amp_threshold');
ampthresh_l.YData = vars.Amplitude_threshold*[1 1];

cla(ax_fltrd_notsuspect)
cla(ax_unfltrd_notsuspect)

meanspike = findobj(ax_detect_patch,'color',[0 .7 1]); meanspike = meanspike(1);
meansquiggle = findobj(ax_detect,'color',[1 .3 0.74]);

for tr_idx = trialnumlist(:)'
    if find(trialnumlist==tr_idx) > 50
        break
    end
    spkDs = spikeDists(trialnums==tr_idx);
    spkAs = spikeAmps(trialnums==tr_idx);
    
    delete(findobj(ax_hist,'tag',['suspect_hist_' num2str(tr_idx)]));
    delete(findobj(ax_hist,'tag',['weird_hist' num2str(tr_idx)]));
    gooddots = findobj(ax_hist,'tag',['good_hist' num2str(tr_idx)]);

    % find the spikes < dist thresh, get the best fit
    suspect = spkDs<vars.Distance_threshold & spkAs>vars.Amplitude_threshold;
    suspect_idx = find(suspect);
    suspectdist = spkDs(suspect);
    suspectamp = spkAs(suspect);

    weirdi = suspectdist>quantile(suspectdist,.92) & suspectdist>.83*vars.Distance_threshold;
    weirdspikes = suspect_idx(weirdi);

    plot(ax_hist,spkDs(suspect),spkAs(suspect),'.','color',[0 0.45 0.74],'tag',['suspect_hist_' num2str(tr_idx)]);
    uistack(gooddots,'top')
    plot(ax_hist,suspectdist(weirdi),suspectamp(weirdi),'.','color',[0 1 .7],'tag',['weird_hist' num2str(tr_idx)]); 
    hold(ax_hist,'on');
    
    if any(weirdspikes)
        trinds = find(trialnums==tr_idx);
        trinds = trinds(weirdspikes);
        
        plot(ax_fltrd_notsuspect,meansquiggle.XData,squiggles(:,trinds),'tag','squiggles_notsuspect','color',[0 1 .7]);
        
        trspikes = spikes(:,trinds);
        trspikes = trspikes-repmat(trspikes(1,:),size(trspikes,1),1);
        plot(ax_unfltrd_notsuspect,meanspike.XData,trspikes,'tag','spikes_notsuspect','color',[0 0 0]);
    end
end

ylims = [min([min(ax_unfltrd_notsuspect.YLim) min(ax_unfltrd_suspect.YLim)]) max([max(ax_unfltrd_notsuspect.YLim) max(ax_unfltrd_suspect.YLim)])];
set([ax_unfltrd_notsuspect,ax_unfltrd_suspect],'YLim',ylims)
end
