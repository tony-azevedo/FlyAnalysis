%% closeLook_210405_F1_C1

disp(T.Properties.UserData.trialStem)
disp(T.Properties.UserData.Dir)
head(T)
disp(fplims) % likely the extent of movement
outcomes'

T0 = load(measuretblname);
T0 = T0.T;

%% summary slide
url = 'https://docs.google.com/presentation/d/1XFOJ7ffpmEBnc7BZ9K0AiyoKhrRVo8zNEifmm_4GMlU/edit#slide=id.gd4f30bd8be_1_0';
web(url,'-browser')

%% probe position and Rm over time
plotScript_probeposition_Rm_overtime


%% reset T
% T = T0;

%% Separate cases 1 and 2 based on movement
figure
idx = (T.outcome == 1 | T.outcome == 2);
H = histogram(T.rms_mvmt(idx));
disp([H.BinEdges(1:end-1)',H.Values'])
H.Parent.YLim = [0 sum(H.Values(H.BinEdges(1:end-1)>H.BinEdges(2)))];
text(H.Parent,H.BinEdges(3),H.Parent.YLim(2)-.1*diff(H.Parent.YLim),sprintf('Bin 1 total: %d',H.Values(1)))
title(H.Parent,'Histogram of RMS Movement in no punishment trials');

% Any trial with > 5 rms movement is classified as outcome 2;
% idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt > 5;
% T.outcome(idx) = 2;


%% outcomes

% progression of outcomes
fig = plotTrialOutcomes(T,outcomes,[regexprep(cid,'_','\\_'), ': Trial outcome over course of experiment']);

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


%% ********** No punishment - in target trials **********

%%
% plot no_punishment trials with large movements
idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt >25;
ttl = 'no punishment with rms movement > 25 um';
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

% plot no_punishment trials with semi large movements
idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt > 5 & T.rms_mvmt < 25;
ttl = 'no punishment with rms movement > 5 & < 25 um';
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

% quick check outcome1 is trials on which the fly didn't move
any(T.rms_mvmt(T.outcome==1) > 5)

% how many blocks?
unique(T.block)                    % 14, exclude 13, 0 - rest
unique(T.block(~T.hiforce,:)) % 14, exclude 13, 0 - rest
unique(T.block(T.hiforce,:)) % 13, exclude 13

% no punishment; hi force trials early on (block 2,4) vs  late (10,12)
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


% no punishment; hi force trials early on (block 2,4) vs  late (10,12)
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

%% ********** Compare sensory feedback **********

%% Look at depolarizations
steps = sort(T.displacements{1});

ttl_stem = 'Lo, Early %gV';
for stp = steps
    idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp & (T.block == 1 | T.block == 2 | T.block == 3 | T.block == 4);
    ttl = sprintf(ttl_stem,stp);
    %[fig] = plotPiezoStepResponse(T(idx,:),ttl);
    [fig] = plotPiezoStepResponseByNum(T(idx,:),ttl);
end

ttl_stem = 'Hi, Early %gV';
for stp = steps
    idx = T.outcome == 1 & T.hiforce & T.displacement == stp & (T.block == 1 | T.block == 2 | T.block == 3 | T.block == 4);
    ttl = sprintf(ttl_stem,stp);
    [fig] = plotPiezoStepResponseByNum(T(idx,:),ttl);
end

ttl_stem = 'Lo, Late %gV';
for stp = steps
    idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp & (T.block == 15 | T.block == 16 | T.block == 11 | T.block == 12 | T.block == 13 | T.block == 14);
    ttl = sprintf(ttl_stem,stp);
    %[fig] = plotPiezoStepResponse(T(idx,:),ttl);
    [fig] = plotPiezoStepResponseByNum(T(idx,:),ttl);
end

ttl_stem = 'Hi, Late %gV';
for stp = steps
    idx = T.outcome == 1 & T.hiforce & T.displacement == stp & (T.block == 15 | T.block == 16 | T.block == 11 | T.block == 12 | T.block == 13 | T.block == 14);
    ttl = sprintf(ttl_stem,stp);
    [fig] = plotPiezoStepResponseByNum(T(idx,:),ttl);
end

%% Look at cue driven spikes
steps = sort(T.displacements{1});

ttl_stem = 'Lo, Early %gV';
for stp = [-5 5]
    idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp & (T.block == 1 | T.block == 2 | T.block == 3 | T.block == 4);
    ttl = sprintf(ttl_stem,stp);
    %[fig] = plotPiezoStepResponse(T(idx,:),ttl);
    [fig] = plotPiezoStepSpikes(T(idx,:),ttl);
end

ttl_stem = 'Hi, Early %gV';
for stp = [-5 5]
    idx = T.outcome == 1 & T.hiforce & T.displacement == stp & (T.block == 1 | T.block == 2 | T.block == 3 | T.block == 4);
    ttl = sprintf(ttl_stem,stp);
    [fig] = plotPiezoStepSpikes(T(idx,:),ttl);
end

ttl_stem = 'Lo, Late %gV';
for stp = [-5 5]
    idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp & (T.block == 15 | T.block == 16 | T.block == 11 | T.block == 12 | T.block == 13 | T.block == 14);
    ttl = sprintf(ttl_stem,stp);
    %[fig] = plotPiezoStepResponse(T(idx,:),ttl);
    [fig] = plotPiezoStepSpikes(T(idx,:),ttl);
end

ttl_stem = 'Hi, Late %gV';
for stp = [-5 5]
    idx = T.outcome == 1 & T.hiforce & T.displacement == stp & (T.block == 15 | T.block == 16 | T.block == 11 | T.block == 12 | T.block == 13 | T.block == 14);
    ttl = sprintf(ttl_stem,stp);
    [fig] = plotPiezoStepSpikes(T(idx,:),ttl);
end


%% lo vs. high probe stiffness
idx = T.outcome == 1;
plotCommandVsActualMovemnt(T(idx,:))

% Does is become stiffer over time?
plotProbeMovementVsTrial(T)


%% lo vs. high
plotCompareLoHiFeedbackResponses(T)

% early
idx = (T.block == 1 | T.block == 2 | T.block == 3 | T.block == 4);
plotCompareLoHiFeedbackResponses(T(idx,:))

% middle
idx = (T.block == 5 | T.block == 6 | T.block == 7 | T.block == 8);
plotCompareLoHiFeedbackResponses(T(idx,:))

% late
idx = (T.block == 9 | T.block == 10 | T.block == 11 | T.block == 12 | T.block == 14);
plotCompareLoHiFeedbackResponses(T(idx,:))

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

fprintf('Make sure to classify movement trials');
% Any trial with > 5 rms movement is classified as outcome 2;
% idx = (T.outcome == 5 | T.outcome == 6) & T.rms_mvmt > 5;
% T.outcome(idx) = 6;

% quick check outcome1 is trials on which the fly didn't move
any(T.rms_mvmt(T.outcome==5) > 5)


% plot failure trials with large movements
idx0 = (T.outcome == 5 | T.outcome == 6);
idx = idx0 & T.rms_mvmt >5;
ttl = 'timeouts with rms movement > 50 um';
ttl = sprintf('%s: %d trials (of %d timeouts)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);

% plot failure trials with small movements
idx0 = (T.outcome == 5 | T.outcome == 6);
idx = idx0 & T.rms_mvmt <=5;
ttl = 'timeouts with rms movement < 10 um';
ttl = sprintf('%s: %d trials (of %d timeouts)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl,fplims);

%% ********** Punishment trials **********

% Separate cases 5 and 6 based on movement
figure
idx = (T.outcome == 3 | T.outcome == 4);
H = histogram(T.rms_mvmt(idx));
disp([H.BinEdges(1:end-1)',H.Values'])
H.Parent.YLim = [0 sum(H.Values(H.BinEdges(1:end-1)>H.BinEdges(2)))];
text(H.Parent,H.BinEdges(3),H.Parent.YLim(2)-.1*diff(H.Parent.YLim),sprintf('Bin 1 total: %d',H.Values(1)))
title(H.Parent,'Histogram of RMS Movement in timeout trials');

T = cleanUpMeasureTable(T); % get rid of any trials that are excluded

% plot moving punishment - off trials 
idx = (T.outcome == 3);
ttl = 'punishment - off';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - off trials, hi force
idx = T.outcome == 3 & T.hiforce;
ttl = 'punishment - off, hi force trials';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - off trials, hi force, blue LED
idx0 = T.outcome == 3 & T.hiforce;
idx = idx0 & T.blueToggle;
ttl = 'punishment - off, hi force trials, blue LED trials';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - off trials, hi force, Red LED only
idx0 = T.outcome == 3 & T.hiforce;
idx = idx0 & ~T.blueToggle;
ttl = 'punishment - off, hi force trials, red LED';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);


% plot moving punishment - off trials, lo force
idx0 = T.outcome == 3 & ~T.hiforce;
idx = idx0;% & ~T.blueToggle;
ttl = 'punishment - off, lo force';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - off trials, lo force, Blue LED
idx0 = T.outcome == 3 & ~T.hiforce;
idx = idx0 & T.blueToggle;
ttl = 'punishment - off, lo force, blue LED';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);


% plot moving punishment - off trials, lo force, Blue LED
idx0 = T.outcome == 3 & ~T.hiforce;
idx = idx0 & ~T.blueToggle;
ttl = 'punishment - off, lo force, red LED only';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);

%% ********** LATE trials **********


% plot moving punishment - late 
idx = T.outcome == 4;
ttl = 'punishment - late';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - late, hi force
idx0 = T.outcome == 4 & T.hiforce;
idx = idx0; %;& ~T.blueToggle;
ttl = 'punishment - late, hi force';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - late, lo force
idx0 = T.outcome == 4 & ~T.hiforce;
idx = idx0; %;& ~T.blueToggle;
ttl = 'punishment - late, lo force';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - late, lo force
idx0 = T.outcome == 4 & ~T.hiforce;
idx = idx0 & T.blueToggle;
ttl = 'punishment - late, lo force, blue LED';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(idx0));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - late, lo force
idx0 = T.outcome == 4 & ~T.hiforce;
idx = idx0 & ~T.blueToggle;
ttl = 'punishment - late, lo force';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
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
plotCompareLoHiFeedbackResponses(T)

% early
idx = (T.block == 1 | T.block == 2 | T.block == 3 | T.block == 4);
plotCompareLoHiFeedbackResponses(T(idx,:))

% middle
idx = (T.block == 5 | T.block == 6 | T.block == 7 | T.block == 8);
plotCompareLoHiFeedbackResponses(T(idx,:))

% late
idx = (T.block == 9 | T.block == 10 | T.block == 11 | T.block == 12 | T.block == 14);
plotCompareLoHiFeedbackResponses(T(idx,:))




