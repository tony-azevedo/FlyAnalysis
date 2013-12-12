function newfig = BlockPlotStepMatrix(fig,handles,savetag)
% see also AverageLikeSines

[prot,datestr,fly,cellnum,trial,D] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement'});
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
    f(cnt) = AverageLikeSteps([],handles,savetag);
    cnt = cnt+1;
end
f = unique(f);
f = sort(f);
f = reshape(f,length(handles.prtclData(bt).displacements),[]);
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end
newfig = layout(f,...
    sprintf('%s Block %d: {%s}', [handles.currentPrtcl '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
    'close');

