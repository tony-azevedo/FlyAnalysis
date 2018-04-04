%% ForceProbe patcing workflow 180223_F1_C1 - 
% This cell has somewhat ok spikes during the EpiFlash trials, but no
% spikes during current injection.

trial = load('B:\Raw_Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step movements
% No spikes

%% EpiFlash stimuli

trial = load('B:\Raw_Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_1.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:7; % beautiful vidoes of the leg with no bar, but not analyable yet
trials{2} = 8:14; 
Nsets = length(trials);
    
trial = load(sprintf(trialStem,8));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR'
    };

%% Set probe line 

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
    temp.forceProbe_line = getacqpref('quickshowPrefs','forceProbeLine');
    temp.forceProbe_tangent = getacqpref('quickshowPrefs','forceProbeTangent');

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
trial = load(sprintf(trialStem,17));
showProbeLocation(trial)

% trial = probeLineROI(trial);


%% Find an area to smooth out the pixels
for set = 1:Nsets
    trialnumlist = trials{set};
    
    for tr_idx = trialnumlist(1:end)
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
    temp.ROI = getacqpref('quickshowPrefs','brightSpots2Smooth');

%     for tr_idx = trialnumlist(4:end)
%         trial = load(sprintf(trialStem,tr_idx));
%         trial.brightSpots2Smooth = temp.ROI;
%         fprintf('Saving bright spots to smooth in trial %s\n',num2str(tr_idx))
%         save(trial.name,'-struct','trial')
%     end
    
    % undo
%     for tr_idx = trialnumlist
%         trial = load(sprintf(trialStem,tr_idx));
%         trial = rmfield(trial,'brightSpots2Smooth');
%         save(trial.name,'-struct','trial')
%     end

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
            eval(routine{set}); %probeTrackROI_IR;
        elseif isfield(trial,'forceProbeStuff')
%             fprintf('%s\n',trial.name);
%             fprintf('\t*Has profile: passing over trial for now\n')
            
            %OR...
            fprintf('\t*Has profile: redoing\n')
            eval(routine{set}); %probeTrackROI_IR;
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

%% Epi flash trials

%% Extract spikes

% This was agonizing for this cell, very annoying

%% Align spikes and bar trajectories



