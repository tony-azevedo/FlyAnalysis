% Record: iav slide for UI grant

%% 81A07 - one option
% maxes out
trial = load('B:\Raw_Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_63.mat');

% small activation, just pulls
trial = load('B:\Raw_Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_44.mat');

% small movements, inhibition
trial = load('B:\Raw_Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_36.mat');


% 81A07 - option two
% maxes out
trial = load('B:\Raw_Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_6.mat');

% inhibited initially but pulls, no letting go
trial = load('B:\Raw_Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_77.mat');


%% 22A08 - option only 1

% low range, just pulls, lets go in one case
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_26.mat');

% middle range, fly lets go of the bar.
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_27.mat');

% maxes out
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_24.mat');

%% 35C09 - couple of options

% lets go of bar, Vm tracks bar movement perfectly, spikes are a little
% hard to detect,
trial = load('B:\Raw_Data\180328\180328_F1_C1\EpiFlash2T_Raw_180328_F1_C1_102.mat');

% 35C09 - option 2
% excited, then inhibited, pulls on bar
trial = load('B:\Raw_Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_43.mat');

% excited, inhibited, slowly releases the bar
trial = load('B:\Raw_Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_44.mat');

% 35C09 - option 3
% hyperpolarization, some spiking during hyperpolarization, lets go in many
% cases
trial = load('B:\Raw_Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_16.mat');


%% slow, spikes, hyperpolarization and probe movement
% 35C09 - option 4 
% nice cell, showing two different light levels and probe traces, have to
% fix the probe spot
trial = load('B:\Raw_Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_6.mat');
trial = load('B:\Raw_Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_1.mat');

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

%%
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
ax.XLim = [-.3 1];
ax.YLim = [-50 -20];

ax = panl(3).select();
plot(ax,ft,prb,'color',[.7 .7 1]); hold(ax,'on')
plot(ax,ft,mean(prb,2),'color',[0 0 .7]); hold(ax,'on')
ax.XLim = [-.3 1];
ax.YLim = [780 840];



%% intermediate, spikes, hyperpolarization and probe movement
% 35C09 - option 4 
% nice cell, showing two different light levels and probe traces, have to
% fix the probe spot
% low range, just pulls, lets go in one case
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_26.mat');

% middle range, fly lets go of the bar.
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_27.mat');

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

%%
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
%     raster(ax, x(trial.spikes),tr_idx+[-.4 .4]);
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
ax.XLim = [-.3 1];
ax.YLim = [-55 -40];

ax = panl(3).select();
plot(ax,ft,prb,'color',[.7 .7 1]); hold(ax,'on')
plot(ax,ft,mean(prb,2),'color',[0 0 .7]); hold(ax,'on')
ax.XLim = [-.3 1];
ax.YLim = [600 800];

%% fast, spikes, hyperpolarization and probe movement
% 35C09 - option 4 
% nice cell, showing two different light levels and probe traces, have to
% fix the probe spot

trial = load('B:\Raw_Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_44.mat');

% middle range, fly lets go of the bar.
trial = load('B:\Raw_Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_50.mat');

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

%%
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
%     raster(ax, x(trial.spikes),tr_idx+[-.4 .4]);
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
ax.XLim = [-.3 1];
ax.YLim = [-55 -40];

ax = panl(3).select();
plot(ax,ft,prb,'color',[.7 .7 1]); hold(ax,'on')
plot(ax,ft,mean(prb,2),'color',[0 0 .7]); hold(ax,'on')
ax.XLim = [-.3 1];
ax.YLim = [540 740];





