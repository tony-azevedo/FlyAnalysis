function fig = PiezoStep2TFam(fig,handles,savetag)
% see also CurrentStepAverage

if isempty(fig) || ~ishghandle(fig)
    fig = figure(100+handles.trial.params.trial); clf
else
end

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findBlockTrials(handles.trial,handles.prtclData);
handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(1))));
if sum(strcmp({'IClamp','IClamp_fast'},handles.trial.params.mode_1))
    y_name_1 = 'voltage_1';
    y_unit_1 = 'mV';
elseif sum(strcmp('VClamp',handles.trial.params.mode_1))
    y_name_1 = 'current_1';
    y_units_1 = 'pA';
end
if sum(strcmp({'IClamp','IClamp_fast'},handles.trial.params.mode_2))
    y_name_2 = 'voltage_2';
    y_unit_2 = 'mV';
elseif sum(strcmp('VClamp',handles.trial.params.mode_2))
    y_name_2 = 'current_2';
    y_units_2 = 'pA';
end

x = makeInTime(handles.trial.params);
y_1 = zeros(length(x),length(blocktrials)); y_2 = y_1;
sgs = zeros(length(x),length(blocktrials));
freqs = blocktrials;
for bt_ind = 1:length(blocktrials);
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(bt_ind))));
    freqs(bt_ind) = handles.trial.params.freq;
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
    for t_ind = 1:length(trials);
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))));
        y_1(:,bt_ind) = y_1(:,bt_ind)+trial.(y_name_1);
        y_2(:,bt_ind) = y_2(:,bt_ind)+trial.(y_name_2);
        sgs(:,bt_ind) = sgs(:,bt_ind)+trial.sgsmonitor;
    end 
    y_1(:,bt_ind) = y_1(:,bt_ind)/length(trials);
    y_2(:,bt_ind) = y_2(:,bt_ind)/length(trials);
    sgs(:,bt_ind) = sgs(:,bt_ind)/length(trials);
end
[freqs,o] = sort(freqs);
y_1 = y_1(:,o); y_2 = y_2(:,o);
sgs = sgs(:,o);

ax1 = subplot(3,1,1,'parent',fig); cla(ax1), hold(ax1,'on')
ax2 = subplot(3,1,2,'parent',fig); cla(ax2), hold(ax2,'on')
ax3 = subplot(3,1,3,'parent',fig); cla(ax3), hold(ax3,'on')
clrs = parula(length(blocktrials)+1);
clrs = clrs(1:end-1,:);
for bt_ind = 1:length(blocktrials);
    plot(ax1,x,y_1(:,bt_ind),'color',clrs(bt_ind,:),'tag',savetag);
    plot(ax2,x,y_2(:,bt_ind),'color',clrs(bt_ind,:),'tag',savetag);
    plot(ax3,x,sgs(:,bt_ind),'color',clrs(bt_ind,:),'tag',savetag);
end

axis(ax1,'tight')
xlim(ax1,[-.2 trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec)])
xlims = get(ax1,'xlim'); ylims = get(ax1,'ylim');
text(xlims(1)+.05*diff(xlims),ylims(1)+.1*diff(ylims),...
    ['N=' num2str(length(trials))],...
    'parent',ax1,'fontsize',7,'tag','delete');
tags = getTrialTags(blocktrials,handles.prtclData);
title(ax1,regexprep([dateID '_' flynum '_' cellnum '_' protocol '_Block' num2str(trial.params.trialBlock) '_' mfilename sprintf('_%s',tags{:})],'_','\\_'));
set(ax1,'tag','quickshow_inax');
hold(ax1,'off')

axis(ax2,'tight')
xlim(ax2,[-.2 trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec)])
xlims = get(ax2,'xlim'); ylims = get(ax2,'ylim');
set(ax2,'tag','quickshow_inax_2');
hold(ax2,'off')

axis(ax3,'tight')
xlim(ax3,[-.2 trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec)])
set(ax3,'tag','quickshow_outax');
hold(ax3,'off')
