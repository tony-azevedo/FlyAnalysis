function vars = estimateSpikeTimeFromInflectionPoint(vars,spikeWaveforms,targetSpikeDist)

% normalize and find a peak of the second derivative
idx_i = round(vars.spikeTemplateWidth/6);
idx_f = round(vars.spikeTemplateWidth/24);
idx_m = round(vars.spikeTemplateWidth*2/3);

window = -floor(vars.spikeTemplateWidth/2): floor(vars.spikeTemplateWidth/2);
spikewindow = window-floor(vars.spikeTemplateWidth/2);

smthwnd = (vars.fs/2000+1:length(spikewindow)-vars.fs/2000);

% Find the best estimate of the spike shape and it's 2nd derivative
for sp = 1:size(spikeWaveforms,2)
    spikeWaveforms(:,sp) = spikeWaveforms(:,sp)-min(spikeWaveforms(:,sp));
    spikeWaveforms(:,sp) = spikeWaveforms(:,sp)/max(spikeWaveforms(:,sp));
end

goodspikes = targetSpikeDist<quantile(targetSpikeDist,.25);
if sum(goodspikes<4)
    goodspikes(:) = 1;
end
spikeWaveform = mean(spikeWaveforms(:,goodspikes),2);
spikeWaveform = smooth(spikeWaveform-spikeWaveform(1),vars.fs/2000);
spikeWaveform_ = smoothAndDifferentiate(spikeWaveform,vars.fs/2000);
spikeWaveform_ = spikeWaveform_-spikeWaveform_(smthwnd(1));
spikeWaveform_ = (spikeWaveform_-min(spikeWaveform_(idx_i:end-idx_f)))/diff([min(spikeWaveform_(idx_i:end-idx_f)) max(spikeWaveform_(idx_i:end-idx_f))]);

[~,inflPntPeak_ave] = findpeaks(spikeWaveform_(idx_i+1:end-idx_f),'MinPeakProminence',0.014);
inflPntPeak_ave = inflPntPeak_ave+idx_i;
inflPntPeak_ave = inflPntPeak_ave(abs(inflPntPeak_ave-idx_m)==min(abs(inflPntPeak_ave-idx_m)));

vars.likelyiflpntpeak = inflPntPeak_ave;

vars.locs_uncorrected = vars.locs;
spikes =  vars.locs;

ipps = nan(size(spikes));


%% Debug figure
debug = 0;
if debug
tempf = figure;
select = randperm(size(spikeWaveforms,2),min([200 size(spikeWaveforms,2)]));
plot(spikeWaveforms(:,select),'color',[1 1 1]*.8); 
hold on
aveD = plot(idx_i:length(spikeWaveform_)-idx_i,spikeWaveform_(idx_i:end-idx_i),'color',[1 .7 .7],'linewidth',2);
ippave = plot(inflPntPeak_ave,spikeWaveform_(inflPntPeak_ave),'ko');
set(gca,'YLim',[-.1 1.1]);
end
%%

for i = 1:length(spikes)
    if targetSpikeDist(i)>vars.Distance_threshold
        % Don't correct the spike if it is above the distance
        % threshold and there is another spike nearby
        spikelocation_comparison = spikes;
        spikelocation_comparison = abs(spikelocation_comparison-vars.locs(i));
        if sum(spikelocation_comparison<vars.spikeTemplateWidth) > 1
            continue
        end
    end
    
    detectedSpikeWaveform = spikeWaveforms(:,i);
    detectedSpikeWaveform = smooth(detectedSpikeWaveform-detectedSpikeWaveform(1),vars.fs/2000);
    detectedSpikeWaveform_ = smoothAndDifferentiate(detectedSpikeWaveform,vars.fs/2000);
    
    % normalize
    detectedSpikeWaveform_ = (detectedSpikeWaveform_-min(detectedSpikeWaveform_))/diff([min(detectedSpikeWaveform_) max(detectedSpikeWaveform_)]);
    
    % see how this works:
    % really narrow the interest range
    start_idx = vars.fs/10000*10; % 50 for fs - 50k, 10 for fs - 10k
    end_idx = vars.fs/10000*10;
    
    idx_i = round(vars.spikeTemplateWidth/4);
    
    [pks,inflPntPeak] = findpeaks(detectedSpikeWaveform_(start_idx+1:end-end_idx),'MinPeakProminence',0.02);
    inflPntPeak = inflPntPeak+start_idx;
    
    if numel(inflPntPeak)>1
        inflPntPeak = inflPntPeak(abs(inflPntPeak-vars.likelyiflpntpeak)==min(abs(inflPntPeak-vars.likelyiflpntpeak)));
    end
        
    if length(inflPntPeak)==1
        ipps(i) = inflPntPeak;
        spikes(i) = spikes(i)+spikewindow(inflPntPeak);
    else
        % Peak of 2nd derivative is still undefined
        spikes(i) = spikes(i)+spikewindow(inflPntPeak_ave);
        
        % if ~isempty(spikeWaveform_) && ~isempty(inflPntPeak_ave)
            % use spike time closest to middle of template
        if isempty(inflPntPeak)
            % use spike time closest to middle of template
            % much shallower peak
            [~,inflPntPeak] = findpeaks(detectedSpikeWaveform_(idx_i+1:end-10),'MinPeakProminence',0.001);
            inflPntPeak = inflPntPeak+idx_i;
            if isempty(inflPntPeak)
                continue
            else
                if numel(inflPntPeak)>=1
                    inflPntPeak = inflPntPeak(abs(inflPntPeak-vars.likelyiflpntpeak)==min(abs(inflPntPeak-vars.likelyiflpntpeak)));
                end
            end
            try spikes(i) = spikes(i)+spikewindow(inflPntPeak);
            catch e
                % somehow, two peaks are exactly the same distance from
                % vars.likelyiflpntpeak, just pick one. This is not likely
                % a spike
                if strcmp(e.identifier,'MATLAB:subsassignnumelmismatch')
                    spikes(i) = spikes(i)+spikewindow(inflPntPeak(randi(length(inflPntPeak),1)));
                end
            end
        end
        
    end
    
    %% debug fig
    if debug
    ave = plot(spikeWaveforms(:,i),'color',[.7 0 0]);
    dave = plot(detectedSpikeWaveform_,'color',[ 0 0 .7]);
    peaks = plot(inflPntPeak,detectedSpikeWaveform_(inflPntPeak),'bo');
    drawnow
    pause(.01)

    delete(ave)
    delete(dave)
    delete(peaks)
    end
    %%
    
end

%% debug fig
if debug
    close(tempf)
end
%%


vars.locs = spikes;
vars.spikeWaveform = spikeWaveform;
vars.spikeWaveform_ = spikeWaveform_;

end