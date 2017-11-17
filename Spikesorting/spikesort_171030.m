%% extractSpikes Script

trial = load('B:\Raw_Data\171026\171026_F2_C1\EpiFlash2T_Raw_171026_F2_C1_7.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

trialnumlist = 7; 
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if trial.excluded
        continue;
    end

    simpleExtractSpikes_HACK_current
    pause(.5)
end
