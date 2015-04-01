function varargout = PiezoLongSongScimStackTraceAmplitudes(handles)
% see also AverageLikeSines

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

trialfields = fieldnames(handles.trial);
for f_ind = 1:length(trialfields);
    if ~isempty(regexpi(trialfields{f_ind},'scim'));
        st_name = trialfields{f_ind};
    end
end

bt = blocktrials(1);

handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
trials = findLikeTrials('trial',bt,'datastruct',handles.prtclData);
trials = excludeTrials('trials',trials,'name',handles.trial.name);

scimtraces = nan(length(trials),length(handles.trial.exposureTimes));
for t_ind = 1:length(trials)
    scimTrace = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))),st_name);
    switch length(size(scimTrace))
        case 2
            scimtraces(t_ind,:) = scimTrace.(st_name)(:,2);
        case 3
            scimtraces(t_ind,:) = scimTrace.(st_name)(:,2,1);
    end
end

scimtraces_sem = std(scimtraces,1)/sqrt(size(scimtraces,1));
scimtraces = mean(scimtraces,1);

scimtraces_sem = scimtraces_sem / mean(scimtraces(handles.trial.exposureTimes<=0)) * 100;
scimtraces = (scimtraces / mean(scimtraces(handles.trial.exposureTimes<=0)) - 1)*100;

x = handles.trial.exposureTimes;

baseline = mean(scimtraces(x<=0&x>0-.5));
[peak,indx] = max(scimtraces(x>0));
peak_sem = scimtraces_sem(indx + sum(x<=0));

[trough,indx] = min(scimtraces(x>0));
trough_sem = scimtraces_sem(indx + sum(x<=0));

    
varargout = {baseline,peak,trough,peak_sem,trough_sem,x,scimtraces};