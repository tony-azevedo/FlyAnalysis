%% Script_FixTheTrialsWithRedLEDTransients

fid = fopen(fullfile(D,'RedLEDArifactDuringSpikes.txt'),'w');
                
for setidx = 1:length(trials)
    fprintf('\n\t***** Batch %d of %d\n',setidx,length(trials));
    trialnumlist = trials{setidx};
    
    %close all
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        if ~isfield(trial,'forceProbeStuff')
            continue
        end
        if isfield(trial,'spikes') && ~isempty(trial.spikes) 
            t = makeInTime(trial.params);
            if t(trial.spikes(1)) <= trial.params.stimDurInSec && trial.params.stimDurInSec==.01
                fprintf(fid,[regexprep(trial.name,'\\','\\\'),'\n']);
                zeroOutStimArtifactsAssumefast %(trial)
            elseif trial.params.stimDurInSec>=.02
                zeroOutStimArtifactsAssumeTranslate
            else
                zeroOutStimArtifactsAssumefast
                % redLEDArtifactClickyCorrect(trial)
            end
        else
%             error('Get spikes first, or comment this out')
            if trial.params.stimDurInSec>=.02
                zeroOutStimArtifactsAssumeTranslate
            else
                zeroOutStimArtifactsAssumefast
                % redLEDArtifactClickyCorrect(trial)
            end
        end
    end
end
fclose(fid);
fclose('all');
clear fid
winopen(D)

