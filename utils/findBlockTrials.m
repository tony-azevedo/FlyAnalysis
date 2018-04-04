function blocktrials = findBlockTrials(trial,datastruct)
% blocktrials = findBlockTrials(trial,datastruct)

paramn = fieldnames(trial.params);
cnt = 1;
for p_ind = 1:length(paramn)
    pname = paramn{p_ind};
    if strcmp(pname(end),'s')
        excludes{cnt} = pname(1:end-1);
        cnt = cnt+1;
    end
end

blocktrials = findLikeTrials('name',trial.name,'datastruct',datastruct,'exclude',excludes);
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',datastruct);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

