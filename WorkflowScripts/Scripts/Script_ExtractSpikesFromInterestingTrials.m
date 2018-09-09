%% Extract spikes

% for now, use trials in the sets
close all
% Go through all the sets of trials
for set = 1%:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
        
    % Do a little investigation of filter properties on a couple of trials
    % first
    spikevars_cell = cell(3,1); cnt = 0;
    for tr_idx = trialnumlist(1:7) 
        trial = load(sprintf(trialStem,tr_idx)); 
                
        fprintf('%s\n',trial.name);
        if isfield(trial,'excluded') && trial.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        cnt = cnt+1;
        fstag = ['fs' num2str(trial.params.sampratein)];
        if ~isfield(trial,'spikeDetectionParams')
            spikevars = getacqpref('FlyAnalysis',['Spike_params_' fstag]);
            
            switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
            [h.trial,spikevars_cell{cnt}] = spikeDetection(trial,invec1,spikevars);
        else
            fprintf('Got some spike vars already\n');
            spikevars_cell{cnt} = trial.spikeDetectionParams;
            spikevars = trial.spikeDetectionParams;
            switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
        end
        
        if cnt>=3
            break
        end
    end
    
    thresh = 0;
    peak = Inf;
    spikeTemplate = zeros(size(spikevars.spikeTemplate));
    for cnt = 1:length(spikevars_cell)
        thresh = max([thresh,spikevars_cell{cnt}.Distance_threshold]);
        peak = min([peak,spikevars_cell{cnt}.peak_threshold]);
        spikeTemplate = spikeTemplate + spikevars_cell{cnt}.spikeTemplate;
    end
    spikevars.spikeTemplate = spikeTemplate/cnt;
    spikevars.Distance_threshold = thresh;
    spikevars.peak_threshold = peak;
    
    [distancestructure] = spikeDetectionBatch(trialStem,trialnumlist,invec1,spikevars);
    close all; spikeSpotCheckBatch(trialStem,trialnumlist,invec1,'spikes',distancestructure);
    
end
