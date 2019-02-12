%% Extract spikes

% for now, use trials in the sets
close all

fprintf('\n\t***** Detecting EMG spikes for trials with 1 spike set **** \n');

% Go through all the sets of trials
REDODETECTION = 1;
for setidx = 1:length(trials) 
    fprintf('\n\t***** Batch %d of %d\n',setidx,length(trials));
    [~,fn] = fileparts(exampletrials{setidx});
    fprintf('Example %d: %s\n',setidx,fn)
    
    spikevars = load(exampletrials{setidx},'EMGspikeDetectionParams'); spikevars = spikevars.EMGspikeDetectionParams;   
    params = load(exampletrials{setidx},'params'); params = params.params;
    disp(spikevars);
    
    trialnumlist = trials{setidx};

    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        if length(trial.spikes)~=1
            continue
        end
        trial.current_2_flipped = -1*trial.current_2;

        % first correct an old mistake:
        if isfield(trial,'spikes_spikes_uncorrected')
            trial = rmfield(trial,'spikes_spikes_uncorrected'); 
        end
        if isfield(trial,'spike_uncorrected')
            trial = rmfield(trial,'spike_uncorrected'); 
        end
        save(trial.name, '-struct', 'trial');

        if (~isfield(trial,'EMGspikes') || REDODETECTION) %&& (~isfield(trial,'EMGspikeSpotChecked') || ~trial.EMGspikeSpotChecked)  
            [trial,vars_skeleton] = spikeDetection(trial,'current_2_flipped',spikevars,'interact','no','alt_spike_field','EMGspikes');
        else
            fprintf('Skipping %d\n',tr_idx)
        end
    end
end
