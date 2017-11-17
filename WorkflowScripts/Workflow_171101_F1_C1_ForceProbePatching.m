%% ForceProbe patcing workflow 171101_F1_C1
trial = load('B:\Raw_Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_16.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)

% EpiFlash Sets - cause spikes and video movement
Nsets = 6;
% Position 0 EpiFlash2T: 16:195
trials{1} = 16:195;
% Position 0 EpiFlash2T more spikes: 196:210
trials{2} = 196:210;
% Position 100 EpiFlash2T: 211:240
trials{3} = 211:240;
% Position 200 EpiFlash2T: 241:270
trials{4} = 241:270;
% Position -100 EpiFlash2T: 271:300
trials{5} =  271:300;
% Position -200 EpiFlash2T: 301:330
trials{6} = 301:330;


%% Set probe line 
trial = load('B:\Raw_Data\171101\171101_F1_C1\EpiFlash2T_Raw_171101_F1_C1_16.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

close all
% Go through all the sets of trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
    br.Position =  [1050    251    270    56];
    
    % set probeline for a few test movies
    for tr_idx = trialnumlist(1:6) 
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

    for tr_idx = trialnumlist(6:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.forceProbe_line = temp.forceProbe_line;
        trial.forceProbe_tangent = temp.forceProbe_tangent;
        fprintf('Saving bar and tangent in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
    
    delete(br);
end

%% double check some trials
trial = load(sprintf(trialStem,310));
showProbeLocation(trial)

% trial = probeLineROI(trial);


%% Detect the bar for all the trials
for set = 5:Nsets
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

%% Extract spikes


%% Random extra play time: move the manipulator while recording sensory feedback
trial = load('B:\Raw_Data\171101\171101_F1_C1\Sweep2T_Raw_171101_F1_C1_7.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
% 
% close all
% % Go through all the sets of trials
% trialnumlist = 6:8;
% 
% br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
% br.Position =  [1050    251    270    56];
% 
% % set probeline for a few test movies
% for tr_idx = trialnumlist
%     h = load(sprintf(trialStem,tr_idx));
%     
%     waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(h.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
%     
%     fprintf('%s\n',h.name);
%     if isfield(h,'excluded') && h.excluded
%         fprintf(' * Bad movie: %s\n',trial.name)
%         continue
%     end
%     trial = probeLineROI(h);
% end
% delete(br)
% batch_probeTrackROI


