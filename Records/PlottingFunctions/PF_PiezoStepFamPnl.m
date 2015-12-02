function pnl = PF_PiezoStepFamPnl(pnl1,pnl2,handles,savetag)
% see also CurrentStepAverage

if isempty(pnl1) 
    fig = figure(100+handles.trial.params.trial); clf
    pnl = panel(fig);
    pnl.pack('v',{2/3 1/3});
    pnl1 = pnl(1).select();
    pnl2 = pnl(2).select();
end

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findBlockTrials(handles.trial,handles.prtclData);
handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(1))));
if sum(strcmp({'IClamp','IClamp_fast'},handles.trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
elseif sum(strcmp('VClamp',handles.trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
end

x = makeInTime(handles.trial.params);
y = zeros(length(x),length(blocktrials));
sgs = zeros(length(x),length(blocktrials));
displacements = blocktrials;
for bt_ind = 1:length(blocktrials);
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(bt_ind))));
    displacements(bt_ind) = handles.trial.params.displacement;
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
    for t_ind = 1:length(trials);
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))));
        y(:,bt_ind) = y(:,bt_ind)+trial.(y_name);
        sgs(:,bt_ind) = sgs(:,bt_ind)+trial.sgsmonitor;
    end 
    y(:,bt_ind) = y(:,bt_ind)/length(trials);
    sgs(:,bt_ind) = sgs(:,bt_ind)/length(trials);
end
[displacements,o] = sort(displacements);
y = y(:,o);
sgs = sgs(:,o);


hold(pnl1,'on')
hold(pnl2,'on')
clrs = parula(length(blocktrials)+1);
clrs = clrs(1:end-1,:);
for bt_ind = 1:length(blocktrials);
    plot(pnl1,x,y(:,bt_ind),'color',clrs(bt_ind,:),'tag',savetag);
    plot(pnl2,x,sgs(:,bt_ind),'color',clrs(bt_ind,:),'tag',savetag);
end

axis(pnl1,'tight')
xlim(pnl1,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
xlims = get(pnl1,'xlim'); ylims = get(pnl1,'ylim');
text(xlims(1)+.05*diff(xlims),ylims(1)+.1*diff(ylims),...
    ['N=' num2str(length(trials))],...
    'parent',pnl1,'fontsize',7,'tag','delete');
tags = getTrialTags(blocktrials,handles.prtclData);
title(pnl1,savetag);
set(pnl1,'tag','quickshow_inax');
hold(pnl1,'off')

axis(pnl2,'tight')
xlim(pnl2,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
set(pnl2,'tag','quickshow_outax');
hold(pnl2,'off')
