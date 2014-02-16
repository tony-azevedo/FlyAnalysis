function newfig = CurrentStepFamMatrix(fig,handles,savetag)
% see also AverageLikeSines

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'step'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

clear f
cnt = 1;
for bt = blocktrials;
    handles.trial = load(sprintf(handles.trialStem,bt));
    f(cnt) = AverageLikeCurrentSteps([],handles,savetag);
    cnt = cnt+1;
end
f = unique(f);
f = sort(f);
f = reshape(f,length(handles.prtclData(bt).steps),[]);
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end
newfig = layout(f,...
    sprintf('%s Block %d: {%s}', [handles.currentPrtcl '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:})),...
    'close');

