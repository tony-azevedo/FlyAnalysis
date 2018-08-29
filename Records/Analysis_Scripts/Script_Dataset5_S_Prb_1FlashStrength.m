%% Script_Dataset5_S_Prb_1FlashStrength

f =figure;
panl = panel(f);
vertdivisions = [4 4 4]; vertdivisions = num2cell(vertdivisions/sum(vertdivisions));
panl.pack('v',vertdivisions)  % response panel, stimulus panel
panl.margin = [10 10 2 2];
panl.fontname = 'Arial';

x = makeInTime(trial.params);
h = postHocExposure(trial,length(trial.forceProbeStuff.CoM));
ft = x(h.exposure);
y = zeros(length(x),length(nums));
prb = zeros(length(ft),length(nums));

ax = panl(1).select();
for tr_idx = 1:length(nums)
    trial = load(sprintf(trialStem,nums(tr_idx)));
    raster(ax, x(trial.spikes),tr_idx+[-.4 .4]);
    y(:,tr_idx) = trial.voltage_1;
    prb(:,tr_idx) = trial.forceProbeStuff.CoM;
end

correctwind = ft>-.01&ft<.03;

% quick correction script for prb
for tr_idx = 1:length(nums)
    sigma = std(prb(ft<0&ft>-.03,tr_idx));
    mu = mean(prb(ft<0&ft>-.03,tr_idx));
    insrt = normrnd(mu,sigma,sum(correctwind),1);
    prb(correctwind,tr_idx) = insrt;
end

ax.XLim = [-.3 1];

ax = panl(2).select();
plot(ax,x,y,'color',[1 .7 .7]);hold(ax,'on')
plot(ax,x,mean(y,2),'color',[.7 0 0]);

ax = panl(3).select();
plot(ax,ft,prb,'color',[.7 .7 1]); hold(ax,'on')
plot(ax,ft,mean(prb,2),'color',[0 0 .7]); hold(ax,'on')
