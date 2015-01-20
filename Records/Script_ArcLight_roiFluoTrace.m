roiFluoTrace(trial,trial.params,'NewROI','No','dFoFfig',fig,'MotionCorrection',true);

[currentPrtcl,dateID,flynum,cellnum] = ...
    extractRawIdentifiers(trial.name);

eval(['export_fig ', ...
    [roiFluoTraceSavedir [dateID,'_',flynum,'_',cellnum,'_',currentPrtcl,'_',num2str(trial.params.trial)]],...
    ' -pdf -transparent'])
close(fig)

trial = load(analysis_cell(c_ind).plateau_trial{1});

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,celldir,trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

prtclData = load(dfile);
prtclData = prtclData.data;
trials = findLikeTrials('name',trial.name,'datastruct',prtclData);

for t_ind = 1:length(trials)
    fig = figure(proplist{:});
    trial = load(fullfile(celldir,sprintf(trialStem,trials(t_ind))));
    try roiFluoTrace(trial,trial.params,'NewROI','No','dFoFfig',fig,'MotionCorrection',true);
    catch
        close(fig)
        continue
    end
    eval(['export_fig ', ...
        [roiFluoTraceSavedir [dateID,'_',flynum,'_',cellnum,'_',currentPrtcl,'_',num2str(trial.params.trial)]],...
        ' -pdf -transparent'])
    
    close(fig)
end