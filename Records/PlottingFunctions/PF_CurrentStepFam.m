function pnl = PF_CurrentStepFam(pnl,handles,savetag)
% see also CurrentStepAverage
pnl_aux = [];
if length(pnl)>1
    pnl_aux = pnl(2);
    pnl = pnl(1);
end
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
        voltage(:,bt_ind) = voltage(:,bt_ind)+trial.voltage(1:length(x));
        current(:,bt_ind) = current(:,bt_ind)+trial.current(1:length(x));
    end 
    voltage(:,bt_ind) = voltage(:,bt_ind)/length(trials);
    current(:,bt_ind) = current(:,bt_ind)/length(trials);
end

hold(pnl,'on')
for bt_ind = 1:length(blocktrials);
    plot(pnl,x,voltage(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([length(blocktrials)-1,1]),'tag',savetag);
    if ~isempty(pnl_aux)
        hold(pnl_aux,'on')
        plot(pnl_aux,x,current(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/(length(blocktrials)-1),'tag',savetag);
    end
end
if ~isempty(pnl_aux)
    linkaxes([pnl pnl_aux],'x');
end

axis(pnl,'tight')
xlim(pnl,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
xlims = get(pnl,'xlim'); ylims = get(pnl,'ylim');
text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),...
    ['N=' num2str(length(trials))],...
    'parent',pnl,'fontsize',7,'tag','delete');

hold(pnl,'off')
if ~isempty(pnl_aux)
    hold(pnl_aux,'off')
end
