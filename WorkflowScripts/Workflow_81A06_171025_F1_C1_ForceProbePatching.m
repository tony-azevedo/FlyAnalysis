%% ForceProbe patcing workflow 171026_F2_C1

%% Extract spikes for different protocols
trial = load('B:\Raw_Data\171025\171025_F1_C1\EpiFlash2T_Raw_171025_F1_C1_5.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

polarity = 1;
trialnumlist = 5:18; 
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if isfield(trial,'excluded') && trial.excluded
        continue;
    end

    simpleExtractSpikes
end

% nothing in EMG channel aligned with spikes

%% EpiFlash2T
trial = load('B:\Raw_Data\171025\171025_F1_C1\EpiFlash2T_Raw_171025_F1_C1_5.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

trials{1} = 5:18;

Nsets = length(trials);

close all
%% Go through all the sets of trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
    br.Position =  [1050    251    270    56];
    
    % set probeline for a few test movies
    for tr_idx = trialnumlist(1:4) 
        h = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(h.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        fprintf('%s\n',h.name);
        if isfield(h,'excluded') && h.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        trial = probeLineROI(h);
    end
    
    % just set the line for the rest of the trials
    temp.forceProbe_line = getpref('quickshowPrefs','forceProbeLine');
    temp.forceProbe_tangent = getpref('quickshowPrefs','forceProbeTangent');

    for tr_idx = trialnumlist(5:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.forceProbe_line = temp.forceProbe_line;
        trial.forceProbe_tangent = temp.forceProbe_tangent;
        fprintf('Saving bar and tangent in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
    
    delete(br);
end

%% double check some trials
trial = load(sprintf(trialStem,13));
showProbeLocation(trial)

% trial = probeLineROI(trial);

%% Detect the bar for all the trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};

    batch_probeTrackROI
end

%% skootch the exposures
for set = 1:Nsets
    knownSkootch = 1;
    trialnumlist = trials{set};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end

%% CurrentStep2T
trial = load('B:\Raw_Data\171025\171025_F1_C1\CurrentStep2T_Raw_171025_F1_C1_9.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

trials{1} = 13:64;

Nsets = length(trials);

close all
% Go through all the sets of trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
    br.Position =  [1050    251    270    56];
    
    % set probeline for a few test movies
    for tr_idx = trialnumlist(1:4) 
        h = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(h.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        fprintf('%s\n',h.name);
        if isfield(h,'excluded') && h.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        trial = probeLineROI(h);
    end
    
    % just set the line for the rest of the trials
    temp.forceProbe_line = getpref('quickshowPrefs','forceProbeLine');
    temp.forceProbe_tangent = getpref('quickshowPrefs','forceProbeTangent');

    for tr_idx = trialnumlist(5:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.forceProbe_line = temp.forceProbe_line;
        trial.forceProbe_tangent = temp.forceProbe_tangent;
        fprintf('Saving bar and tangent in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
    
    delete(br);
end

%% Detect the bar for all the trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};

    batch_probeTrackROI
end
