function newfig = CurrentStep2TFam(fig,handles,savetag)
% see also CurrentStepAverage

if isempty(fig) || ~ishghandle(fig)
    fig = figure(100+trials(1)); clf
else
end
trial = handles.trial;

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findBlockTrials(handles.trial,handles.prtclData);

switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   

x = makeInTime(handles.trial.params);
voltage = zeros(length(x),length(blocktrials));
current = zeros(length(x),length(blocktrials));
EMG = zeros(length(x),length(blocktrials));
for bt_ind = 1:length(blocktrials)
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(bt_ind))));
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
    for t_ind = 1:length(trials)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))));
        voltage(:,bt_ind) = voltage(:,bt_ind)+trial.voltage_1;
        EMG(:,bt_ind) = EMG(:,bt_ind)+trial.(invec2);
    end 
    voltage(:,bt_ind) = voltage(:,bt_ind)/length(trials);
    current(:,bt_ind) = current(:,bt_ind)/length(trials);
    EMG(:,bt_ind) = EMG(:,bt_ind)/length(trials);
end

ax1 = subplot(3,1,[1 2],'parent',fig); cla(ax1), hold(ax1,'on')
ax2 = subplot(3,1,3,'parent',fig); cla(ax2), hold(ax2,'on')
for bt_ind = 1:length(blocktrials)
    plot(ax1,x,voltage(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax2,x,current(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
end
axis(ax1,'tight')
xlim(ax1,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
xlims = get(ax1,'xlim'); ylims = get(ax1,'ylim');
text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),...
    ['N=' num2str(length(trials))],...
    'parent',ax1,'fontsize',7,'tag','delete');
tags = getTrialTags(blocktrials,handles.prtclData);
title(ax1,[dateID '_' flynum '_' cellnum '_' protocol '_Block' num2str(trial.params.trialBlock) '_' mfilename sprintf('_%s',tags{:})],'interpreter','none');
set(ax1,'tag','quickshow_inax');
hold(ax1,'off')

axis(ax2,'tight')
xlim(ax2,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
set(ax2,'tag','quickshow_outax');
hold(ax2,'off')
