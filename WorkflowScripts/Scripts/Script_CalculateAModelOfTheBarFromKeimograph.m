%% Script_TrackTheBarAcrossTrialsInSet

N = 400;
bar_model = zeros(N,1);
trialnumlist = [];
for setidx = 1:length(trials)
    fprintf('\n\t***** Batch %d of %d\n',setidx,length(trials));
    trialnumlist = [trialnumlist trials{setidx}];
end

close all

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

% have to assume an appropriate trial has been opened
barmat = nan(N+1,length(trial.forceProbeStuff.CoM));
cnt = 0;
for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));
    
    waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
    barmat(:) = nan;
    if isfield(trial,'forceProbeStuff')
        cnt = cnt+1;
        fprintf('%s\n',trial.name);
        fprintf('\t*Has profile: calculating a model of the bar\n')
        
        temp = load(regexprep(trial.name,'_Raw_','_keimograph_'),'keimograph');
        keimograph = temp.keimograph;
        
        for fr = 1:length(trial.forceProbeStuff.CoM)
            if round(trial.forceProbeStuff.CoM(fr)+2*N/3)>size(keimograph,1) || isnan(trial.forceProbeStuff.CoM(fr))
                %disp('skip frame');
                continue;
            end
            ind = max([1 round(trial.forceProbeStuff.CoM(fr)-N/2)]) : ...
                min([size(keimograph,1) round(trial.forceProbeStuff.CoM(fr)+N/2)]);
            ind_aligned = ind - round(trial.forceProbeStuff.CoM(fr)-N/2) + 1;
            barmat(ind_aligned,fr) = keimograph(ind,fr);
        end
        
        trial.forceProbeStuff.barmodel = nanmean(barmat,2);
        save(trial.name, '-struct', 'trial')
    end
end

delete(br);
