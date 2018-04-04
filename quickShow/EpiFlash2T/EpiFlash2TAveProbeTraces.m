function h = EpiFlash2TAveProbeTraces(h,handles,savetag)

% setupStimulus
delete(get(h,'children'));
panl = panel(h);
panl.pack('v',{1/3 1/3 1/3})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode_1))
    y_name = 'voltage_1';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode_1))
    y_name = 'current_1';
    y_units = 'pA';
end

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode_2))
    y_name_2 = 'voltage_2';
    y_units_2 = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode_2))
    y_name_2 = 'current_2';
    y_units_2 = 'pA';
end

y = zeros(length(x),length(trials));
y_2 = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name);
    y_2(:,t) = trial.(y_name_2);
end

ax = panl(1).select();
plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);
% xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
set(ax,'tag','response_ax');

ax = panl(2).select();
plot(ax,x,y_2,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y_2,2),'color',[.7 0 0],'tag',savetag);
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
set(ax,'tag','response_ax_2');

ax = panl(3).select();
plot(ax,x,EpiFlashStim(trial.params),'color',[0 0 1],'tag',savetag); hold on;
box(ax,'off');
set(ax,'TickDir','out');
xlim([-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
set(ax,'tag','stimulus_ax');


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
ax1_1 = subplot(6,1,4,'parent',fig); cla(ax1_1), hold(ax1_1,'on'), ylabel(ax1_1,'pA');
ax1_2 = subplot(6,1,1,'parent',fig); cla(ax1_2), hold(ax1_2,'on'), ylabel(ax1_2,'pA');
ax2 = subplot(6,1,[2 3],'parent',fig); cla(ax2), hold(ax2,'on'), ylabel(ax2,'mV');
ax3 = subplot(6,1,[5 6],'parent',fig); cla(ax3), hold(ax3,'on'), ylabel(ax3,'CoM (pixels)');

for bt_ind = 1:length(blocktrials)
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,blocktrials(bt_ind))));
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
    for t_ind = 1:length(trials)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t_ind))));
        voltage(:,bt_ind) = voltage(:,bt_ind)+trial.voltage_1;
        current(:,bt_ind) = current(:,bt_ind)+trial.current_1;
        EMG(:,bt_ind) = EMG(:,bt_ind)+trial.(invec2);
        fprobe(:,bt_ind) = fprobe(:,bt_ind)+trial.forceProbeStuff.CoM(:);
        plot(ax3,ft,trial.forceProbeStuff.CoM(:)-nanmean(trial.forceProbeStuff.CoM(1:40)),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    end 
    voltage(:,bt_ind) = voltage(:,bt_ind)/length(trials);
    current(:,bt_ind) = current(:,bt_ind)/length(trials);
    EMG(:,bt_ind) = EMG(:,bt_ind)/length(trials);
    fprobe(:,bt_ind) = fprobe(:,bt_ind)/length(trials);
end

for bt_ind = 1:length(blocktrials)
    plot(ax2,x,voltage(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax1_2,x,current(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
%     plot(ax3,ft,fprobe(:,bt_ind) - nanmean(fprobe(1:40,bt_ind)),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
    plot(ax1_1,x,EMG(:,bt_ind),'color',[0 1 0] + [ 0 -1 1]*(bt_ind-1)/max([(length(blocktrials)-1) 1]),'tag',savetag);
end
axis(ax1_1,'tight')
xlim([ax1_1 ax1_2 ax2 ax3],[-trial.params.preDurInSec trial.params.stimDurInSec+ trial.params.postDurInSec])


