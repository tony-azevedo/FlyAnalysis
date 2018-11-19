%% Extract spikes

% for now, use trials in the sets
close all

fprintf('\n\t***** Getting general spikevars **** \n');
trialnumlist = trials{1};

spikevars_cell = cell(3,1); cnt = 0;
for tr_idx = trialnumlist(1:min([6 length(trialnumlist)]))
    trial = load(sprintf(trialStem,tr_idx));
    
    fprintf('%s\n',trial.name);
    if isfield(trial,'excluded') && trial.excluded
        fprintf(' * Bad movie: %s\n',trial.name)
        continue
    end
    cnt = cnt+1;
    fstag = ['fs' num2str(trial.params.sampratein)];
    spikevars = getacqpref('FlyAnalysis',['Spike_params_' fstag]);
    
    switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
    [h.trial,spikevars_cell{cnt}] = spikeDetection(trial,invec1,spikevars);    
    if cnt>=3
        break
    end
end

thresh = 0;
ampthresh = Inf;
peak = 0;
spikeTemplate = zeros(size(spikevars.spikeTemplate));
for cnt = 1:length(spikevars_cell)
    thresh = max([thresh,spikevars_cell{cnt}.Distance_threshold]);
    ampthresh = min([ampthresh,spikevars_cell{cnt}.Amplitude_threshold]);
    peak = max([peak,spikevars_cell{cnt}.peak_threshold]);
    spikeTemplate = spikeTemplate + spikevars_cell{cnt}.spikeTemplate;
end
spikevars.spikeTemplate = spikeTemplate/cnt;
spikevars.Distance_threshold = thresh;
spikevars.peak_threshold = peak;
spikevars.Amplitude_threshold = ampthresh;

% Go through all the sets of trials
for setidx = 1:Nsets 
    fprintf('\n\t***** Batch %d of %d\n',setidx,Nsets);
    trialnumlist = trials{setidx};
    
    [distancestructure] = spikeDetectionBatch(trialStem,trialnumlist,invec1,spikevars);
end
