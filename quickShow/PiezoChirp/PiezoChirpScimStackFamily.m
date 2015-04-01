function h = PiezoChirpScimStackFamily(h,handles,savetag)
% see also AverageLikeSines

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);
if isempty(h) || ~ishghandle(h)
    h = figure(100+str2double(trialnum)); clf
    set(h,'color',[1 1 1])
else
    delete(get(h,'children'));
end

pnl = panel(h);
pnl.pack('v',{5/7 1/7 1/7})  % response panel, stimulus panel
pnl.margin = [18 16 16 16];

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

cnt = 0;
for bt = blocktrials;

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
    
    
    scimtraces_sem = smooth(std(scimtraces,1)/sqrt(size(scimtraces,1)));
    scimtraces = smooth(mean(scimtraces,1));
    
    scimtraces_sem = scimtraces_sem / mean(scimtraces...
        (handles.trial.exposureTimes<=0&handles.trial.exposureTimes>=-2))...
        * 100;
    scimtraces = (scimtraces / mean(scimtraces...
        (handles.trial.exposureTimes<=0&handles.trial.exposureTimes>=-2))...
        - 1)*100;
    
    scimtraces_sem = scimtraces_sem(:)';
    scimtraces = scimtraces(:)';
    
    ptch = patch(...
        [handles.trial.exposureTimes,fliplr(handles.trial.exposureTimes)],...
        [scimtraces-scimtraces_sem,fliplr(scimtraces+scimtraces_sem)],...
        [.9 .9 .9],...
        'EdgeColor','none','parent',pnl(1).select(),'displayname','SEM');
%     line(handles.trial.exposureTimes,scimtraces,...
%         'parent',pnl(1).select(),...
%         'color',[0 1 0]*(1 - cnt/length(blocktrials)) + [1 0  1]*cnt/length(blocktrials),...
%         'displayname',[num2str(handles.trial.params.displacement) ' V']);
   
    line(handles.trial.exposureTimes,scimtraces,...
        'parent',pnl(1).select(),...
        'color',[0 1 0]*(1 - cnt/length(blocktrials)) + [1 0  1]*cnt/length(blocktrials),...
        'displayname',[num2str(handles.trial.params.displacement) ' V']);
    cnt = cnt+1;

end
chi = get(pnl(1).select(),'children');
for indx = 2:2:length(chi)
    temp(indx/2) = chi(indx);
    chi(indx/2) = chi(indx-1);
end
chi(end/2+1:end) = temp;
set(pnl(1).select(),'children',chi)
drawnow

axis('tight');

tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end

legend(pnl(1).select(),'show','location','best');
legend('boxoff');

pnl(1).ylabel('% \DeltaF/F_0');
%pnl(1).xlabel('Time(s)');
pnl(1).title(sprintf('%s %s Block %d: {%s}', [handles.currentPrtcl '.' dateID '.' flynum '.' cellnum],st_name,b,sprintf('%s; ',tags{:})));

x = makeInTime(handles.trial.params);
freq_value = zeros(size(x));
freq_value(x>=0 & x< handles.trial.params.stimDurInSec) = ...
    (handles.trial.params.freqEnd-handles.trial.params.freqStart)/handles.trial.params.stimDurInSec * ....
    x(x>=0 & x< handles.trial.params.stimDurInSec) + ...
    handles.trial.params.freqStart;
plot(pnl(2).select(),x,freq_value,'color',[0 0 .5],'tag',savetag); hold on
axis(pnl(2).select(),'tight')
ylabel(pnl(2).select(),'Hz');

line(makeInTime(handles.trial.params),handles.trial.sgsmonitor,...
    'parent',pnl(3).select(),...
    'color',[0 0 1]);

axis(pnl(3).select(),'tight');

pnl(3).ylabel('SGS (V)');
pnl(3).xlabel('Time(s)');