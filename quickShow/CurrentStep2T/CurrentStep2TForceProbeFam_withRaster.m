function newfig = CurrentStep2TForceProbeFam_withRaster(fig,handles,savetag)
% see also CurrentStepAverage

if isempty(fig) || ~ishghandle(fig)
    fig = figure(100+trials(1)); clf
else
end
trial = handles.trial;

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findBlockTrials(handles.trial,handles.prtclData);

switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   

ax1_1 = subplot(7,1,[4 5],'parent',fig); cla(ax1_1), hold(ax1_1,'on'), ylabel(ax1_1,'Trials');
ax2 = subplot(7,1,[2 3],'parent',fig); cla(ax2), hold(ax2,'on'), ylabel(ax2,'mV');

x = makeInTime(handles.trial.params);
ft = makeFrameTime(handles.trial);

voltage = zeros(length(x),length(blocktrials));
current = zeros(length(x),length(blocktrials));
EMG = zeros(length(x),length(blocktrials));
fprobe = zeros(length(ft),length(blocktrials));

cnt = 0;
gap = 0;
for bt_ind = 1:length(blocktrials)
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(bt_ind))));
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
    gap = gap+1;
    for t_ind = 1:length(trials)
        cnt = cnt+1;
        
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))));

        raster(ax1_1,x(trial.spikes),cnt+[-.4 .4]+gap*2);
        
        voltage(:,bt_ind) = voltage(:,bt_ind)+trial.voltage_1;
        current(:,bt_ind) = current(:,bt_ind)+trial.current_1;
        EMG(:,bt_ind) = EMG(:,bt_ind)+trial.(invec2);
        fprobe(:,bt_ind) = fprobe(:,bt_ind)+trial.forceProbeStuff.CoM(:);
    end 
    voltage(:,bt_ind) = voltage(:,bt_ind)/length(trials);
    current(:,bt_ind) = current(:,bt_ind)/length(trials);
    EMG(:,bt_ind) = EMG(:,bt_ind)/length(trials);
    fprobe(:,bt_ind) = fprobe(:,bt_ind)/length(trials);
    ex_trace(:,bt_ind) = trial.voltage_1;
end
ax1_1.YLim = [0 cnt+1+gap*2];

ax1_2 = subplot(7,1,1,'parent',fig); cla(ax1_2), hold(ax1_2,'on'), ylabel(ax1_2,'pA');
ax3 = subplot(7,1,[6 7],'parent',fig); cla(ax3), hold(ax3,'on'), ylabel(ax3,'CoM (pixels)');
for bt_ind = 1:length(blocktrials)
%     plot(ax2,x,voltage(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax2,x,ex_trace(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax1_2,x,current(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
%     plot(ax3,ft,fprobe(:,bt_ind) - handles.trial.forceProbeStuff.ZeroForce,'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax3,ft,fprobe(:,bt_ind) - mean(fprobe(ft<0,bt_ind)),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    %plot(ax1_1,x,EMG(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
end

xlim([ax1_1 ax1_2 ax2 ax3],[-trial.params.preDurInSec trial.params.stimDurInSec+ trial.params.postDurInSec])

