%% Script_TrackTheBarAcrossTrialsInSet

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
            fprintf('%s\n',trial.name);
            fprintf('\t*Has profile: passing over trial for now\n')
            
            %OR...
            %fprintf('\t*Has profile: redoing\n')
            %eval(routine{set}); %probeTrackROI_IR;

            %OR...
            if isfield(trial.forceProbeStuff,'keimograph')
                fprintf('\t*Moving keimograph to alt file: redoing\n')
                keimograph = trial.forceProbeStuff.keimograph;
                save(regexprep(trial.name,'_Raw_','_keimograph_'),'keimograph');
                trial.forceProbeStuff = rmfield(trial.forceProbeStuff,'keimograph');
                save(trial.name,'-struct','trial')
            end
            if exist(regexprep(trial.name,'.mat','_barkeimograph.mat'),'file')
                fprintf('\t*Moving keimograph to alt file: movefile\n')
                movefile(regexprep(trial.name,'.mat','_barkeimograph.mat'),regexprep(trial.name,'_Raw_','_keimograph_'));
            end
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end
    
    delete(br);
    
end