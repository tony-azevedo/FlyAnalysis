function newfig = CurrentStep2TForceProbeFam(fig,handles,savetag)
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
h2 = postHocExposure(handles.trial,length(trial.forceProbeStuff.CoM));
ft = x(h2.exposure);

voltage = zeros(length(x),length(blocktrials));
current = zeros(length(x),length(blocktrials));
EMG = zeros(length(x),length(blocktrials));
fprobe = zeros(length(ft),length(blocktrials));
for bt_ind = 1:length(blocktrials)
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(bt_ind))));
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
    for t_ind = 1:length(trials)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))));
        voltage(:,bt_ind) = voltage(:,bt_ind)+trial.voltage_1;
        current(:,bt_ind) = current(:,bt_ind)+trial.current_1;
        EMG(:,bt_ind) = EMG(:,bt_ind)+trial.(invec2);
        fprobe(:,bt_ind) = fprobe(:,bt_ind)+trial.forceProbeStuff.CoM(:);
    end 
    voltage(:,bt_ind) = voltage(:,bt_ind)/length(trials);
    current(:,bt_ind) = current(:,bt_ind)/length(trials);
    EMG(:,bt_ind) = EMG(:,bt_ind)/length(trials);
    fprobe(:,bt_ind) = fprobe(:,bt_ind)/length(trials);
end

ax1_1 = subplot(6,1,4,'parent',fig); cla(ax1_1), hold(ax1_1,'on'), ylabel(ax1_1,'pA');
ax1_2 = subplot(6,1,1,'parent',fig); cla(ax1_2), hold(ax1_2,'on'), ylabel(ax1_2,'pA');
ax2 = subplot(6,1,[2 3],'parent',fig); cla(ax2), hold(ax2,'on'), ylabel(ax2,'mV');
ax3 = subplot(6,1,[5 6],'parent',fig); cla(ax3), hold(ax3,'on'), ylabel(ax3,'CoM (pixels)');
for bt_ind = 1:length(blocktrials)
    plot(ax2,x,voltage(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax1_2,x,current(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax3,ft,fprobe(:,bt_ind) - nanmean(fprobe(1:40,bt_ind)),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax1_1,x,EMG(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
end
axis(ax1_1,'tight')
xlim([ax1_1 ax1_2 ax2 ax3],[-trial.params.preDurInSec trial.params.stimDurInSec+ trial.params.postDurInSec])

