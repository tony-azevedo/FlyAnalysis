function newfig = CurrentSineScimFamily(h,handles,savetag)
% see also AverageLikeSines

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
    set(h,'color',[1 1 1])
else
    delete(get(h,'children'));
end

pnl = panel(h);
pnl.pack(1)  % response panel, stimulus panel
pnl.margin = [18 16 16 16];

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'amp','freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

trialfields = fieldnames(handles.trial);
for f_ind = 1:length(trialfields);
    if ~isempty(strfind(trialfields{f_ind},'scim'));
        st_name = trialfields{f_ind};
    end
end

cnt = 0;
for bt = blocktrials;

    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    trials = findLikeTrials('trial',bt,'datastruct',handles.prtclData);

    scimtraces = nan(length(trials),length(handles.trial.exposureTimes));
    for t_ind = 1:length(trials)
        scimTrace = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))),st_name);
        scimtraces(t_ind,:) = scimTrace.(st_name)(:,2)./scimTrace.(st_name)(:,1);
    end
    
    scimtraces = mean(scimtraces,1);
    scimtraces = (scimtraces / mean(scimtraces(handles.trial.exposureTimes<=0)) - 1)*100;
    line(handles.trial.exposureTimes,scimtraces,...
        'parent',pnl(1).select(),...
        'color',[0 1 0]*(1 - cnt/length(blocktrials)) + [1 0  1]*cnt/length(blocktrials),...
        'displayname',[num2str(handles.trial.params.amp) ' pA; ', num2str(handles.trial.params.freq) ' Hz']);
    cnt = cnt+1;

end
axis('tight');

tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end

legend(pnl(1).select(),'show','location','best');
legend('boxoff');

pnl(1).ylabel('% \DeltaG/R');
pnl(1).xlabel('Time(s)');
pnl(1).title(sprintf('%s Block %d: {%s}', [handles.currentPrtcl '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:})));


