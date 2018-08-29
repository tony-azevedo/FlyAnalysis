%% Script_Dataset5_V_Prb_1FlashStrength

f =figure;
panl = panel(f);
vertdivisions = [1]; vertdivisions = num2cell(vertdivisions/sum(vertdivisions));
panl.pack('v',vertdivisions)  % response panel, stimulus panel
panl.margin = [16 16 2 2];
panl.fontname = 'Arial';

x = makeInTime(trial.params);
h = postHocExposure(trial,length(trial.forceProbeStuff.CoM));
ft = x(h.exposure);
dft = diff(ft(1:2));
Nsmooth = sum(x>=ft(1)&x<ft(3));

y = zeros(length(x),length(nums));
prb = zeros(length(ft),length(nums));
y_ft = prb;

for tr_idx = 1:length(nums)
    trial = load(sprintf(trialStem,nums(tr_idx)));
%     raster(ax, x(trial.spikes),tr_idx+[-.4 .4]);
    y(:,tr_idx) = trial.voltage_1;
    prb(:,tr_idx) = trial.forceProbeStuff.CoM;
end
prb = prb - trial.forceProbeStuff.ZeroForce;

correctwind = ft>-.01&ft<.03;

% quick correction script for prb
for tr_idx = 1:length(nums)
    sigma = std(prb(ft<0&ft>-.03,tr_idx));
    mu = mean(prb(ft<0&ft>-.03,tr_idx));
    insrt = normrnd(mu,sigma,sum(correctwind),1);
    prb(correctwind,tr_idx) = insrt;
    base = mean(y(5,tr_idx));
    y(:,tr_idx) = smooth(y(:,tr_idx)-base,Nsmooth)+base;
    
    %smooth voltage into ft
    for ft_idx = 1:length(ft)
        idx = x>ft(ft_idx)-dft/2 & x<ft(ft_idx)+dft/2;
        y_ft(ft_idx,tr_idx) = mean(y(idx,tr_idx));
    end
end

ax = panl(1).select();

clrs = parula(length(nums)+1);
clrs = clrs(1:length(nums),:);

t_i = -.1;
t_f = .4;

for tr_idx = 1:length(nums)
    plot(ax,prb(ft>t_i&ft<t_f,tr_idx),y_ft(ft>t_i&ft<t_f,tr_idx),'color',clrs(tr_idx,:)); hold(ax,'on')
end
plot(ax,mean(prb(ft>t_i&ft<t_f,:),2),mean(y_ft(ft>t_i&ft<t_f,:),2),'color',[0 0 0],'marker','.','markeredgecolor',[0 0 0],'Linewidth',2);

ylabel(ax,'V_m (mV)')
xlabel(ax,'Force (um)')