%% closeLook_210405_F1_C1

disp(T.Properties.UserData.trialStem)
disp(T.Properties.UserData.Dir)
head(T)
disp(fplims) % likely the extent of movement
outcomes'

T0 = load('LEDFlashWithPiezoCueControl_210405_F1_C1_MeasureTable.mat');
T0 = T0.T;

%% summary slide
url = 'https://docs.google.com/presentation/d/1CY7S35FTiHLboO3TpRfFfARa37c4H5OMYelhEipoCHE/edit#slide=id.gd4c03a7d51_0_8';
web(url,'-browser')

%% probe position and Rm over time
figure
plot(T.trial,T.Vm_Delta/-5)
ylabel('R_m (G\Omega)')
xlabel('Trial #')

figure
subplot(2,1,1)
plot(T.trial,-T.probe_position_init)
hold on
plot(T.trial(T.outcome==1),-T.probe_position_init(T.outcome==1),'.')
ylabel('Initial Probe (flipped)')

subplot(2,1,2)
plot(T.trial,T.Vm_pretrial)
hold on
plot(T.trial(T.outcome==1),T.Vm_pretrial(T.outcome==1),'.')
ylabel('Initial Vm (mV)')
xlabel('Trial #')


%% reset T
% T = T0;

%% Separate cases 1 and 2 based on movement
figure
idx = (T.outcome == 1 | T.outcome == 2);
H = histogram(T.rms_mvmt(idx));
disp([H.BinEdges(1:end-1)',H.Values'])
H.Parent.YLim = [0 sum(H.Values(H.BinEdges(1:end-1)>H.BinEdges(2)))];
text(H.Parent,H.BinEdges(3),H.Parent.YLim(2)-.1*diff(H.Parent.YLim),sprintf('Bin 1 total: %d',H.Values(1)))
title(H.Parent,'Histogram of RMS Movement in no stim trials');

% Any trial with > 5 rms movement is classified as outcome 2;
idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt > 5;
T.outcome(idx) = 2;


%% outcomes

% progression of outcomes
fig = plotTrialOutcomes(T,outcomes,'Trial outcome over course of experiment');

% histograms of outcomes
figure
H = histogram(T.outcome(T.block>=1 & T.block<=4));
H.Parent.XTick = (1:6);
H.Parent.XTickLabel = outcomes;
H.Parent.XTickLabelRotation = 45;
xlabel(H.Parent,'outcome');
title(H.Parent,'Outcome in first 4 blocks');

figure
H = histogram(T.outcome(T.block>=5 & T.block<=8));
H.Parent.XTick = (1:6);
H.Parent.XTickLabel = outcomes;
H.Parent.XTickLabelRotation = 45;
xlabel(H.Parent,'outcome');
title(H.Parent,'Outcome in blocks 5,6,7,8');

figure
H = histogram(T.outcome(T.block>=9 & T.block<=12));
H.Parent.XTick = (1:6);
H.Parent.XTickLabel = outcomes;
H.Parent.XTickLabelRotation = 45;
xlabel(H.Parent,'outcome');
title(H.Parent,'Outcome in blocks 9,10,11,12');


%% ********** No stim - in target trials **********

%%
% plot no_stim trials with large movements
idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt >40;
ttl = 'no stim with rms movement > 40 um';
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

% plot no_stim trials with semi large movements
idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt > 5 & T.rms_mvmt < 40;
ttl = 'no stim with rms movement > 5 & < 40 um';
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

% quick check outcome1 is trials on which the fly didn't move
any(T.rms_mvmt(T.outcome==1) > 5)

% how many blocks?
unique(T.block)                    % 14, exclude 13, 0 - rest
unique(T.block(~T.hiforce,:)) % 14, exclude 13, 0 - rest
unique(T.block(T.hiforce,:)) % 13, exclude 13

% no stim; hi force trials early on (block 2,4) vs  late (10,12)
idx = T.outcome == 1 & ~T.hiforce & (T.block == 1 | T.block == 3);
ttl = 'Early lo force successful trials (blocks 1 and 3)';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(T.block == 1 | T.block == 3));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

idx = T.outcome == 1 & ~T.hiforce & (T.block == 9 | T.block == 11);
ttl = 'Late lo force successful trials (blocks 9 and 11)';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(T.block == 9 | T.block == 11));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);


% no stim; hi force trials early on (block 2,4) vs  late (10,12)
idx = T.outcome == 1 & T.hiforce & (T.block == 2 | T.block == 4);
ttl = 'Early hi force successful trials (blocks 2 and 4)';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(T.block == 1 | T.block == 3));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

idx = T.outcome == 1 & T.hiforce & (T.block == 10 | T.block == 12);
ttl = 'Late hi force successful trials (blocks 10 and 12)';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(T.block == 10 | T.block == 12));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);


%% ********** Failure trials **********

% Separate cases 5 and 6 based on movement
figure
idx = (T.outcome == 5 | T.outcome == 6);
H = histogram(T.rms_mvmt(idx));
disp([H.BinEdges(1:end-1)',H.Values'])
H.Parent.YLim = [0 sum(H.Values(H.BinEdges(1:end-1)>H.BinEdges(2)))];
text(H.Parent,H.BinEdges(3),H.Parent.YLim(2)-.1*diff(H.Parent.YLim),sprintf('Bin 1 total: %d',H.Values(1)))
title(H.Parent,'Histogram of RMS Movement in timeout trials');

% Where exaclty is this edge?
idx0 = (T.outcome == 5 | T.outcome == 6);
idx = idx0 & T.rms_mvmt <= 50;
figure
H = histogram(T.rms_mvmt(idx));

% Any trial with > 5 rms movement is classified as outcome 2;
idx = (T.outcome == 5 | T.outcome == 6) & T.rms_mvmt > 10;
T.outcome(idx) = 6;


%% plot failure trials with large movements
idx0 = (T.outcome == 5 | T.outcome == 6);
idx = idx0 & T.rms_mvmt >10;
ttl = 'timeouts with rms movement > 50 um';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);

% plot failure trials with small movements
idx0 = (T.outcome == 5 | T.outcome == 6);
idx = idx0 & T.rms_mvmt <=10;
ttl = 'timeouts with rms movement < 10 um';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl,fplims);

%% ********** Moving trials **********

% Separate cases 5 and 6 based on movement
figure
idx = (T.outcome == 3 | T.outcome == 6);
H = histogram(T.rms_mvmt(idx));
disp([H.BinEdges(1:end-1)',H.Values'])
H.Parent.YLim = [0 sum(H.Values(H.BinEdges(1:end-1)>H.BinEdges(2)))];
text(H.Parent,H.BinEdges(3),H.Parent.YLim(2)-.1*diff(H.Parent.YLim),sprintf('Bin 1 total: %d',H.Values(1)))
title(H.Parent,'Histogram of RMS Movement in timeout trials');


%% plot moving stim - off trials 
idx = (T.outcome == 3);
ttl = 'stim - off';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

%% plot moving stim - off trials, hi force
idx = T.outcome == 3 & T.hiforce;
ttl = 'stim - off, hi force trials';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

%% plot moving stim - off trials, hi force, blue LED
idx0 = T.outcome == 3 & T.hiforce;
idx = idx0 & T.blueToggle;
ttl = 'stim - off, hi force trials, blue LED trials';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

%% plot moving stim - off trials, hi force, Red LED only
idx0 = T.outcome == 3 & T.hiforce;
idx = idx0 & ~T.blueToggle;
ttl = 'stim - off, hi force trials, red LED';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);


%% plot moving stim - off trials, lo force
idx0 = T.outcome == 3 & ~T.hiforce;
idx = idx0;% & ~T.blueToggle;
ttl = 'stim - off, lo force';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

%% plot moving stim - off trials, lo force, Blue LED
idx0 = T.outcome == 3 & ~T.hiforce;
idx = idx0 & T.blueToggle;
ttl = 'stim - off, lo force, blue LED';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);


%% plot moving stim - off trials, lo force, Blue LED
idx0 = T.outcome == 3 & ~T.hiforce;
idx = idx0 & ~T.blueToggle;
ttl = 'stim - off, lo force, red LED only';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

%% ********** LATE trials **********


% plot moving stim - late 
idx = T.outcome == 4;
ttl = 'stim - late';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);

% plot moving stim - late, hi force
idx0 = T.outcome == 4 & T.hiforce;
idx = idx0; %;& ~T.blueToggle;
ttl = 'stim - late, hi force';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);

% plot moving stim - late, lo force
idx0 = T.outcome == 4 & ~T.hiforce;
idx = idx0; %;& ~T.blueToggle;
ttl = 'stim - late, lo force';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);

% plot moving stim - late, lo force
idx0 = T.outcome == 4 & ~T.hiforce;
idx = idx0 & T.blueToggle;
ttl = 'stim - late, lo force, blue LED';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);


%% ********** Compare sensory feedback **********

%%
steps = sort(T.displacements{1});

ttl_stem = 'Lo, %gV';
for stp = steps
    idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp & (T.block == 1 | T.block == 2 | T.block == 3 | T.block == 4);
    ttl = sprintf(ttl_stem,stp);
    [fig] = plotPiezoStepResponse(T(idx,:),ttl);
end

%% lo vs. high
plotCompareLoHiFeedbackResponses(T(idx,:))

% early
idx = (T.block == 1 | T.block == 2 | T.block == 3 | T.block == 4);
plotCompareLoHiFeedbackResponses(T(idx,:))

% late
idx = (T.block == 9 | T.block == 10 | T.block == 11 | T.block == 12);
plotCompareLoHiFeedbackResponses(T(idx,:))




