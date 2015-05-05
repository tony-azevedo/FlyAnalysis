% Script_VoltageClamp_VStep

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,Dir,trialStem,dfile] = ...
    extractRawIdentifiers(VClamptrial.name);
data = load(dfile); data = data.data;

blocktrials = findLikeTrials('name',VClamptrial.name,'datastruct',data,'exclude',{'step'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',data);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

x = makeInTime(VClamptrial.params);
current = zeros(length(x),length(blocktrials));

for bt_ind = 1:length(blocktrials);
    VClamptrial = load([Dir sprintf(trialStem,blocktrials(bt_ind))]);
    Vtrials = findLikeTrials('name',VClamptrial.name,'datastruct',data);
    for it_ind = 1:length(Vtrials)
        VClamptrial = load([Dir sprintf(trialStem,Vtrials(it_ind))]);
        current(:,bt_ind) = current(:,bt_ind)+VClamptrial.current;
    end
    current(:,bt_ind) = current(:,bt_ind)/length(Vtrials);
    plot(ax_trace,x,current(:,bt_ind),'color',[0 1 0] + [0 -1  1]* (bt_ind-1)/(length(blocktrials)-1));
end
xlim(ax_trace,[-.05 .25])
ylim(ax_trace,[-200 200])
xlabel(ax_trace,'s');
ylabel(ax_trace,'pA');

plot(ax_zooml,x,current(:,1),'color',[0 1 0] + [0 -1  1]*0);
plot(ax_zooml,x,current(:,4),'color',[0 1 0] + [0 -1  1]*3/(length(blocktrials)-1));
plot(ax_zooml,x,current(:,6),'color',[0 1 0] + [0 -1  1]*6/(length(blocktrials)-1));
plot(ax_zooml,x,current(:,end),'color',[0 1 0] + [0 -1  1]);
xlabel(ax_zooml,'s');
ylabel(ax_zooml,'pA');
xlim(ax_zooml,[-.001 .005])
ylim(ax_zooml,[-200 200])


plot(ax_zoomr,x,current(:,1),'color',[0 1 0] + [0 -1  1]*0);
plot(ax_zoomr,x,current(:,4),'color',[0 1 0] + [0 -1  1]*3/(length(blocktrials)-1));
plot(ax_zoomr,x,current(:,6),'color',[0 1 0] + [0 -1  1]*6/(length(blocktrials)-1));
plot(ax_zoomr,x,current(:,end),'color',[0 1 0] + [0 -1  1]);
xlabel(ax_zoomr,'s');
ylabel(ax_zoomr,'pA');
xlim(ax_zoomr,[VClamptrial.params.stimDurInSec-.001 VClamptrial.params.stimDurInSec+.005])
ylim(ax_zoomr,[-200 200])

% lags = lags/VClamptrial.params.sampratein;
% [pks,locs] = findpeaks(x_cor_mean_curr(lags>=0&lags<.04),'MINPEAKDISTANCE',0.0005*VClamptrial.params.sampratein);%,lags(lags>-.001&lags<.04));
% lag_loc = lags(lags>0&lags<.04);
% plot(ax_peak,lag_loc(locs(1:min(20,length(locs)))),1:min(20,length(locs)),'.','color',dark_colr,'linestyle','none')
% xlim(ax_peak,[0 .04])
