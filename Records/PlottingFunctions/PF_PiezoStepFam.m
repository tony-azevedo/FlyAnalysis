function fig = PF_PiezoStepFam(fig,handles,savetag)
% see also CurrentStepAverage

if isempty(fig) || ~ishghandle(fig)
    fig = figure(100+handles.trial.params.trial); clf
else
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

x_win = x>= -.1 & x<trial.params.stimDurInSec+ min(.25,trial.params.postDurInSec);

ax1 = subplot(3,1,[1 2],'parent',fig); cla(ax1), hold(ax1,'on')
ax2 = subplot(3,1,3,'parent',fig); cla(ax2), hold(ax2,'on')
for bt_ind = 1:length(blocktrials);
    plot(ax1,x(x_win),y(x_win,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/(length(blocktrials)-1),'tag',num2str(displacements(bt_ind)));
    plot(ax2,x(x_win),sgs(x_win,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/(length(blocktrials)-1),'tag',num2str(displacements(bt_ind)));
end
axis(ax1,'tight')
xlim(ax1,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
xlims = get(ax1,'xlim'); ylims = get(ax1,'ylim');
text(xlims(1)+.05*diff(xlims),ylims(1)+.1*diff(ylims),...
    ['N=' num2str(length(trials))],...
    'parent',ax1,'fontsize',7,'tag','delete');
tags = getTrialTags(blocktrials,handles.prtclData);
title(ax1,regexprep([dateID '_' flynum '_' cellnum '_' protocol '_Block' num2str(trial.params.trialBlock) '_' mfilename sprintf('_%s',tags{:})],'_','\\_'));
set(ax1,'tag','quickshow_inax');
hold(ax1,'off')

axis(ax2,'tight')
xlim(ax2,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
set(ax2,'tag','quickshow_outax');
hold(ax2,'off')
