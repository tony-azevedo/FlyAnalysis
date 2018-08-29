%% Script_FindTheTrialsWithRedLEDTransients


fid = fopen(fullfile(D,'RedLEDArifact.txt'),'w');

for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    close all
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
                
        if isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            t = makeInTime(trial.params);
            ft = makeFrameTime(trial,t);
            
            if mean(trial.forceProbeStuff.CoM(ft>0&ft<trial.params.stimDurInSec))-mean(trial.forceProbeStuff.CoM(ft<0))<-10
                fprintf(fid,[regexprep(trial.name,'\\','\\\'),'\n']);
            end
            
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end    
end
fclose(fid);
fclose('all');
clear fid
winopen(D)