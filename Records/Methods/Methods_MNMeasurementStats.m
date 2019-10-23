%% Using fiji to measure cell fills from
% https://docs.google.com/spreadsheets/d/1E4s36rAY5LSV37ARaMYRURcozd52TBbjdVA54rUrMwY/edit#gid=1812206085

%% Slow MNs
soma_si = [
    nan     nan
    6.735	5.929
    6.087	3.969
    4.781	5.12
    6.824	7.697
    % with more fills
    6.828	5.631
    ];
pneurite_si = [
    0.693	0.59
    0.53	0.53
    0.61	0.565
    0.546	0.629
    0.848	0.611
    % with more fills
    0.59	0.436
    0.658	0.665
    ];
axon_si = [
    0.604	0.818
    0.656	0.611
    0.71	0.612
    0.628	0.814
    0.741	0.717
    % with more fills
    0.771	0.834
    0.688	0.627
    ];


soma_sc = [
    9.596	7.507
    nan	nan
    12.5	8.528
    9.053	4.012
    7.918	6.668
    5.953	9.031
    ];
pneurite_sc = [
    0.673	0.78
    0.611	0.663
    0.678	0.478
    0.724	0.753
    0.703	0.72
    0.674	0.84
    ];
axon_sc = [
    nan	nan
    0.676	0.692
    nan	nan
    0.578	0.545
    1.056	1.063
    0.638	0.557
    ];


%%
soma_ii = [
    16.819	8.168
    nan	nan
    nan	nan
    nan	nan
    nan	nan
    nan	nan
    8.988	6.87
    11.617	6.806
    ];
pneurite_ii = [
    1.105	1.072
    0.711	0.756
    0.848	1.001
    0.872	0.987
    0.741	0.741
    0.983	1.014
    1.011	0.791
    0.839	0.931
    ];
axon_ii = [
    1.449	1.524
    1.259	1.352
    1.189	1.622
    0.781	1.11
    1.124	1.266
    1.171	1.345
    1.871	1.666
    1.15	1.106
    ];

soma_ic = [
    12.731	8.588
    13.043	8.86
    nan	nan
    13.411	6.265
    11.365	8.47
    12.457	8.061
    ];
pneurite_ic = [
    0.999	0.982
    0.939	0.93
    0.927	0.798
    0.988	0.81
    1.016	1.26
    0.678	0.788
    ];
axon_ic = [
    nan	nan
    nan	nan
    1.53	1.391
    1.43	1.305
    1.87	1.524
    1.161	1.198
    ];

%%
soma_fi = [
    nan	nan
    nan	nan
    15.936	17.358
    23.128	14.419
    14.291	9.592
    14.98	11.555
    ];
pneurite_fi = [
    nan	nan
    1.28	1
    1.64	1.579
    1.175	1.058
    2.276	1.589
    0.962	1.038
    1.398	1.391
    ];
axon_fi = [
    nan	nan
    2.685	2.413
    2.879	2.775
    1.908	2.06
    2.729	2.464
    2.427	2.577
    2.484	2.024
    ];

soma_fc = [
    20.532	21.054
    nan	nan
    18.032	14.567
    nan	nan
    nan	nan
    18.85	7.445
    ];
pneurite_fc = [
    1.903	1.978
    nan	nan
    nan	nan
    nan	nan
    nan	nan
    nan	nan
    ];
axon_fc = [
    nan	nan
    nan	nan
    ];

%%
soma_s = cat(1,mean(soma_si,2),mean(soma_sc,2));
soma_s = soma_s(~isnan(soma_s));
pneurite_s = cat(1,mean(pneurite_si,2),mean(pneurite_sc,2));
pneurite_s = pneurite_s(~isnan(pneurite_s));
axon_s = cat(1,mean(axon_si,2),mean(axon_sc,2));
axon_s = axon_s(~isnan(axon_s));

%%
soma_i = cat(1,mean(soma_ii,2),mean(soma_ic,2));
soma_i = soma_i(~isnan(soma_i));
pneurite_i = cat(1,mean(pneurite_ii,2),mean(pneurite_ic,2));
pneurite_i = pneurite_i(~isnan(pneurite_i));
axon_i = cat(1,mean(axon_ii,2),mean(axon_ic,2));
axon_i = axon_i(~isnan(axon_i));

%%
soma_f = cat(1,mean(soma_fi,2),mean(soma_fc,2));
soma_f = soma_f(~isnan(soma_f));
pneurite_f = cat(1,mean(pneurite_fi,2),mean(pneurite_fc,2));
pneurite_f = pneurite_f(~isnan(pneurite_f));
axon_f = cat(1,mean(axon_fi,2),mean(axon_fc,2));
axon_f = axon_f(~isnan(axon_f));

%% Stats

[h,p] = ttest2(soma_s,soma_f)
[h,p] = ttest2(pneurite_s,pneurite_f)
[h,p] = ttest2(axon_s,axon_f)

%%
[h,p] = ttest2(soma_s,soma_i)
[h,p] = ttest2(pneurite_s,pneurite_i)
[h,p] = ttest2(axon_s,axon_i)

%%
[h,p] = ttest2(soma_i,soma_f)
[h,p] = ttest2(pneurite_i,pneurite_f)
[h,p] = ttest2(axon_i,axon_f)

%%
% Soma
[P,T,stats] = anovan([soma_f; soma_i; soma_s],[soma_f*0+1; soma_i*0+2; soma_s*0+3]);
results = multcompare(stats);

% Primary neurite
[P,T,stats] = anovan([pneurite_f; pneurite_i; pneurite_s],[pneurite_f*0+1; pneurite_i*0+2; pneurite_s*0+3]);
results = multcompare(stats);

% axon neurite
[P,T,stats] = anovan([axon_f; axon_i; axon_s],[axon_f*0+1; axon_i*0+2; axon_s*0+3]);
results = multcompare(stats);


%% Figure
morphf = figure;

axs = subplot(1,3,1); axs.NextPlot = 'add';
plot(1+0*soma_f,soma_f,'.','Markersize',12)
plot(2+0*soma_i,soma_i,'.','Markersize',12)
plot(3+0*soma_s,soma_s,'.','Markersize',12)
xlim([0 4])
ylim([0 22])

axp = subplot(1,3,2); axp.NextPlot = 'add';
plot(1+0*pneurite_f,pneurite_f,'.','Markersize',12)
plot(2+0*pneurite_i,pneurite_i,'.','Markersize',12)
plot(3+0*pneurite_s,pneurite_s,'.','Markersize',12)
xlim([0 4])
ylim([0 2])

axa = subplot(1,3,3); axa.NextPlot = 'add';
plot(1+0*axon_f,axon_f,'.','Markersize',12)
plot(2+0*axon_i,axon_i,'.','Markersize',12)
plot(3+0*axon_s,axon_s,'.','Markersize',12)
xlim([0 4])
ylim([0 3])

