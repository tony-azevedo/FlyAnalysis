%% ForceProbe CaImaging workflow 

%% EpiFlash2T Bar detection
trial = load('B:\Raw_Data\171107\171107_F1_C1\EpiFlash2T_Raw_171107_F1_C1_6.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials

% if the position of the prep changes, make a new set
trials{3} = 1:5;
trials{1} = 6:65;
trials{2} = 66:70;
Nsets = length(trials);

%% Go through all the sets of trials
close all
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
    br.Position =  [1050    251    270    56];
    
    % set probeline for a few test movies
    for tr_idx = trialnumlist(1:4) 
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        fprintf('%s\n',trial.name);
        if isfield(trial,'excluded') && trial.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        trial = probeLineROI_startAt0(trial);
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
trial = load(sprintf(trialStem,6));
showProbeLocation(trial)

% trial = probeLineROI(trial);

%% Detect the bar for all the trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};

    close all
    br_base = waitbar(0,'Batch');
    br_base.Position =  [1050    251    270    56];
    
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br_base,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
%             trial = probeTrackROI_startAt0(trial);
            probeTrackROI_startAt0;
        elseif isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);

%             fprintf('\t*Has profile: passing over trial for now\n')
            fprintf('\t*Has profile: redo\n')

            probeTrackROI_startAt0;

        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end
    
    delete(br_base);
end

%% skootch the exposures

for set = 1:Nsets
    knownSkootch = 3;
    trialnumlist = trials{set};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end

%% 
for set = 1:Nsets
    trialnumlist = trials{set};
    fprintf('\t Decimate\n');    
    batch_avikmeansDecimate
    fprintf('\t- Extract\n');
    batch_avikmeansExtract
    fprintf('\t- Threshold\n');
    batch_avikmeansThreshold
    fprintf('\t- Cluster\n');
    batch_avikmeansCalculation_v2
    fprintf('\t- Intensity\n');
    batch_avikmeansClusterIntensity_v2
end
