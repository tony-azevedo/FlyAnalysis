function varargout = CurrentSineMatrix(fig,handles,savetag)
% see also AverageLikeSines

[prot,datestr,fly,cellnum,~,~] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'amp','freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

clear f
cnt = 1;
if isfield(handles.trial.params,'mode_1')
    multi = 1;
end

for bt = blocktrials;
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    if ~multi
        f(cnt) = CurrentSineAverage([],handles,savetag);
    elseif multi
        f(cnt) = CurrentSineAverageSingleTrode([],handles,savetag,'trode','1');
    end
    cnt = cnt+1;
end
f = unique(f);
f = sort(f);
if ~isfield(handles.prtclData(bt),'amps');
    handles.prtclData(bt).amps = handles.prtclData(bt).amp;
end
f = reshape(f,length(handles.prtclData(bt).amps),length(handles.prtclData(bt).freqs));
f = f';
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end
varargout{1} = layout(f,...
    sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
    'close');

if multi
    clear f
    cnt = 1;
    for bt = blocktrials;
        handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
        f(cnt) = CurrentSineAverageSingleTrode([],handles,savetag,'trode','2');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    if ~isfield(handles.prtclData(bt),'amps');
        handles.prtclData(bt).amps = handles.prtclData(bt).amp;
    end
    f = reshape(f,length(handles.prtclData(bt).amps),length(handles.prtclData(bt).freqs));
    f = f';
    tags = getTrialTags(blocktrials,handles.prtclData);
    
    b = nan;
    if isfield(handles.trial.params, 'trialBlock')
        b = handles.trial.params.trialBlock;
    end
    varargout{2} = layout(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end
