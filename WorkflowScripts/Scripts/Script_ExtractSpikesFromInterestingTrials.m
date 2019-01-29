%% Extract spikes

% for now, use trials in the sets
close all

fprintf('\n\t***** Detecting spikes for each set **** \n');

% Go through all the sets of trials
REDODETECTION = 1;
for setidx = 2:length(trials) 
    fprintf('\n\t***** Batch %d of %d\n',setidx,length(trials));
    [~,fn] = fileparts(exampletrials{setidx});
    fprintf('Example %d: %s\n',setidx,fn)
    
    spikevars = load(exampletrials{setidx},'spikeDetectionParams'); spikevars = spikevars.spikeDetectionParams;   
    params = load(exampletrials{setidx},'params'); params = params.params;
    disp(spikevars);
    
    trialnumlist = trials{setidx};
    switch params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end

    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        if (~isfield(trial,'spikes') || REDODETECTION) && (~isfield(trial,'spikeSpotChecked') || ~trial.spikeSpotChecked)  
            [trial,vars_skeleton] = spikeDetectionNonInteractive(trial,invec1,spikevars);
        else
            fprintf('Skipping %d\n',tr_idx)
        end
    end
end
