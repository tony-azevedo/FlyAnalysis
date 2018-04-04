%% ForceProbe patcing workflow 171116_F1_C1 
trial = load('B:\Raw_Data\171116\171116_F1_C1\CurrentStep2T_Raw_171116_F1_C1_96.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

% Probe position analyzed on the current step trials below, see cells at
% bottom

% Spikes not yet analyzed

% feedback vs location not yet analyzed

cd (D)
clear trials
trials{1} = 96:133; % subesquent trials are with caffeine and not so good
Nsets = length(trials);


%% Set probe line 
trial = load('B:\Raw_Data\171116\171116_F1_C1\CurrentStep2T_Raw_171116_F1_C1_96.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

close all
% Go through all the sets of trials
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
        trial = probeLineROI(trial);
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
trial = load(sprintf(trialStem,217));
showProbeLocation(trial)

% trial = probeLineROI(trial);

%% Find an area to smooth out the pixels
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


%% Detect the bar for all the trials
for set = 1%:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,'Batch');
    br.Position =  [1050    251    270    56];
    
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            probeTrackROI_IR_dimglue;
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

% %% I changed the forceProbePosition vector inadvertently. This changes it back for these trials
% 
% for set = 1%:Nsets
%     fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
%     trialnumlist = trials{set};
%     
%     for tr_idx = trialnumlist
%         trial = load(sprintf(trialStem,tr_idx));
% 
%         % load the trial
%         
%         % create a CoM vector from the forceProbePosition vector
%         trial.forceProbeStuff.CoM = trial.forceProbeStuff.forceProbePosition(1,:);
%         % create a forceProbePosition vector from the CoM vector
%         
%         %     bar_loc = evalpnts(:,com);
%         %     forceProbePosition(:,kk) = bar_loc;
% 
%         origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
%         x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
%         forceProbePosition = x_hat.*(trial.forceProbeStuff.CoM-origin);
%         trial.forceProbeStuff.forceProbePosition = forceProbePosition;
%         
%         % save the trial
%         save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
% 
%     end
% end

%% Now do the EpiFlash2T Trials
trial = load('B:\Raw_Data\171116\171116_F1_C1\EpiFlash2T_Raw_171116_F1_C1_11.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials
trials{1} = 11:25;
Nsets = length(trials);


%% Set probe line 
% Go through all the sets of trials
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
        trial = probeLineROI(trial);
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
trial = load(sprintf(trialStem,20));
showProbeLocation(trial)

% trial = probeLineROI(trial);

%% Find an area to smooth out the pixels
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


%% Detect the bar for all the trials
for set = 1%:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,'Batch');
    br.Position =  [1050    251    270    56];
    
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            probeTrackROI_IR_dimglue;
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

% %% I changed the forceProbePosition vector inadvertently. This changes it back for these trials

% for set = 1%:Nsets
%     fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
%     trialnumlist = trials{set};
%     
%     for tr_idx = trialnumlist
%         trial = load(sprintf(trialStem,tr_idx));
% 
%         % load the trial
%         
%         % create a CoM vector from the forceProbePosition vector
%         trial.forceProbeStuff.CoM = trial.forceProbeStuff.forceProbePosition(1,:);
%         % create a forceProbePosition vector from the CoM vector
%         
%         %     bar_loc = evalpnts(:,com);
%         %     forceProbePosition(:,kk) = bar_loc;
% 
%         origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
%         x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
%         forceProbePosition = x_hat.*(trial.forceProbeStuff.CoM-origin);
%         trial.forceProbeStuff.forceProbePosition = forceProbePosition;
%         
%         % save the trial
%         save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
% 
%     end
% end
% 

%% Extract spikes

%% Extract spikes for different protocols
trial = load('B:\Raw_Data\171116\171116_F1_C1\PiezoStep2T_Raw_171116_F1_C1_30.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

polarity = 1;
trialnumlist = 1:30; 
for tr = trialnumlist
    trial = load(sprintf(trialStem,tr));
    if isfield(trial,'excluded') && trial.excluded
        continue;
    end

    simpleExtractSpikes
end

%% For piezo step stuff