function pnl = CurrentStepFam_PF(pnl,handles,savetag)
% see also CurrentStepAverage

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findBlockTrials(handles.trial,handles.prtclData);

x = makeInTime(handles.trial.params);
voltage = zeros(length(x),length(blocktrials));
current = zeros(length(x),length(blocktrials));
for bt_ind = 1:length(blocktrials);
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(bt_ind))));
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
    for t_ind = 1:length(trials);
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))));
        voltage(:,bt_ind) = voltage(:,bt_ind)+trial.voltage;
        current(:,bt_ind) = current(:,bt_ind)+trial.current;
    end 
    voltage(:,bt_ind) = voltage(:,bt_ind)/length(trials);
    current(:,bt_ind) = current(:,bt_ind)/length(trials);
end

hold(pnl,'on')
for bt_ind = 1:length(blocktrials);
    plot(pnl,x,voltage(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/(length(blocktrials)-1),'tag',savetag);
    %plot(ax2,x,current(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/(length(blocktrials)-1),'tag',savetag);
end
axis(pnl,'tight')
xlim(pnl,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
xlims = get(pnl,'xlim'); ylims = get(pnl,'ylim');
text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),...
    ['N=' num2str(length(trials))],...
    'parent',pnl,'fontsize',7,'tag','delete');

hold(pnl,'off')
