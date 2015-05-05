% Script_VoltageClamp_VStep

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,Dir,trialStem,dfile] = ...
    extractRawIdentifiers(IClamptrial.name);
data = load(dfile); data = data.data;

blocktrials = findLikeTrials('name',IClamptrial.name,'datastruct',data,'exclude',{'step'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',data);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

x = makeInTime(IClamptrial.params);
voltage = zeros(length(x),length(blocktrials));

for bt_ind = 1:length(blocktrials);
    IClamptrial = load([Dir sprintf(trialStem,blocktrials(bt_ind))]);
    Itrials = findLikeTrials('name',IClamptrial.name,'datastruct',data);
    for it_ind = 1:length(Itrials)
        IClamptrial = load([Dir sprintf(trialStem,Itrials(it_ind))]);
        voltage(:,bt_ind) = voltage(:,bt_ind)+IClamptrial.voltage;
    end
    voltage(:,bt_ind) = voltage(:,bt_ind)/length(Itrials);
    plot(ax_trace,x,voltage(:,bt_ind),'color',[0 1 0] + [0 -1  1]* (bt_ind-1)/(length(blocktrials)-1));
end
xlim(ax_trace,[-.2 IClamptrial.params.stimDurInSec+0.2])
xlabel(ax_trace,'s');
ylabel(ax_trace,'mV');

plot(ax_zooml,x,voltage(:,1),'color',[0 1 0] + [0 -1  1]*0);
plot(ax_zooml,x,voltage(:,2),'color',[0 1 0] + [0 -1  1]*2/(length(blocktrials)-1));
plot(ax_zooml,x,voltage(:,end-2),'color',[0 1 0] + [0 -1  1]*(length(blocktrials)-3)/(length(blocktrials)-1));
plot(ax_zooml,x,voltage(:,end),'color',[0 1 0] + [0 -1  1]);
xlabel(ax_zooml,'s');
ylabel(ax_zooml,'mV');
xlim(ax_zooml,[-.05 .1])


plot(ax_zoomr,x,voltage(:,1),'color',[0 1 0] + [0 -1  1]*0);
plot(ax_zoomr,x,voltage(:,2),'color',[0 1 0] + [0 -1  1]*2/(length(blocktrials)-1));
plot(ax_zoomr,x,voltage(:,end-2),'color',[0 1 0] + [0 -1  1]*(length(blocktrials)-3)/(length(blocktrials)-1));
plot(ax_zoomr,x,voltage(:,end),'color',[0 1 0] + [0 -1  1]);
xlabel(ax_zoomr,'s');
ylabel(ax_zoomr,'mV');
xlim(ax_zoomr,IClamptrial.params.stimDurInSec+[-.05 .1])

