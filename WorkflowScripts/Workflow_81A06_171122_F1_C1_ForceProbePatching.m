%% ForceProbe patcing workflow 171122_F1_C1

% 

%% Which trials?
trial = load('B:\Raw_Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_12.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

trials{1} = 5:14;
trials{2} = 15:29;
trials{3} = 30:39; % caffeine


Nsets = length(trials);

close all

%% Where is the bar?
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

%% Any Bright spots to smooth out?
for set = 1:Nsets
    trialnumlist = trials{set};
    
    for tr_idx = trialnumlist(1:3)
        trial = load(sprintf(trialStem,tr_idx));
        
        if (~isfield(trial,'excluded') || ~trial.excluded) 
            tic
            fprintf('%s\n',trial.name);
            trial = smoothOutBrightPixels(trial);
            
            toc
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end
    
    % just set the line for the rest of the trials
    temp.ROI = getpref('quickshowPrefs','brightSpots2Smooth');

    for tr_idx = trialnumlist(4:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.brightSpots2Smooth = temp.ROI;
        fprintf('Saving bright spots to smooth in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
end

%% double check some trials
trial = load(sprintf(trialStem,13));
showProbeLocation(trial)

% trial = probeLineROI(trial);

%% Track the bar
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    close all
    
    br = waitbar(0,'Batch');
    br.Position =  [1050    251    270    56];
    
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            probeTrackROI_IR;
        elseif isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            fprintf('\t*Has profile: passing over trial for now\n')
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end
    
    delete(br);
    
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

%% Where is the bar?
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

%% Track the bar
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    close all
    
    br = waitbar(0,'Batch');
    br.Position =  [1050    251    270    56];
    
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            probeTrackROI_IR;
        elseif isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            fprintf('\t*Has profile: passing over trial for now\n')
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end
    
    delete(br);
    
end

%% Need to find the resting spot of the bar


%% Extract spikes for different protocols
trial = load('B:\Raw_Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_12.mat');
trial = load('B:\Raw_Data\171122\171122_F1_C1\EpiFlash2T_Raw_171122_F1_C1_9.mat');

% Check if this trial has spikes
if isfield(h.trial,'spikes') && isfield(h.trial,'spikeDetectionParams')
    % if so, then show raster above the data in the quick show menu and
    
    % enable for other trials
% If not, find out if the spike detection has been run for the cell
else 
    % Go through other trials, first check nearby ones in this protocol
    nums = h.trial.params.trial+[-1 1 -2 2 -3 3 -4 4];
    nums = nums(nums>0&nums<h.prtclData(end).trial);
    gotone = 0;
    for t = nums
        mtfl = matfile(sprintf(h.trialStem,t));
        if ~isempty(whos(mtfl,'Spikes'))
            gotone = 1;
            break
        end
    end
    % The go through all protocol files
    for t = 1:length(h.prtclData)
        mtfl = matfile(sprintf(h.trialStem,h.prtclData(t).trial));
        if ~isempty(whos(mtfl,'Spikes'))
            gotone = 1;
            break
        end
    end
    if ~gotone
        % warn if no other protocol trials have been run
        warning('No other protocol trials have spikes')
    else
        spikevars = mtfl.Spikes;
    end
    % then check other trials
        
    
    % If no spike detection has been run, get vars from
    % prefs('FlyAnalysis')
        % vars_skeleton = rmfield(vars,'unfiltered_data'); vars_skeleton =
        % rmfield(vars_skeleton,'filtered_data'); vars_skeleton =
        % rmfield(vars_skeleton,'piezo');
        % setpref('FlyAnalysis','Spike_params',vars_skeleton);
    if ~exist('spikevars','var')
        spikevars = getpref('FlyAnalysis','Spike_params');
    end 
    % run the spike filter GUI with these prefs., select example spikes.
    % may need to allow for different versions of spike analysis
    [h.trial.Spikes,spikevars] = spikeDetection(h.trial,spikevars);
    setpref('FlyAnalysis','Spike_params',spikevars);
end
