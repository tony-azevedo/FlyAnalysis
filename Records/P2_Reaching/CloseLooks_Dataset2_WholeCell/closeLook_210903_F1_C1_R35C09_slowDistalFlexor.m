%% closeLook_210903_F3_C1

disp(T.Properties.UserData.trialStem)
disp(T.Properties.UserData.Dir)
head(T)
disp(fplims) % likely the extent of movement
outcomes = {'no AS - static';
    'no AS - moved';
    'AS off';
    'AS off - late';
    'timeout - static';
    'timeout - fail'};

T0 = loadtable(measuretblname);

%% summary slide
url = 'https://docs.google.com/presentation/d/1IQceL1AIBrzbHBlUOIfNEV1B7NCXs1luQPk8pkDBdbg/edit#slide=id.gd994210d75_0_197';
web(url,'-browser')

%% probe position and Rm over time
plotScript_probeposition_Rm_overtime


%% reset T
% T = T0;

%% Improve T
% Maybe some trials were excluded
T = cleanUpMeasureTable(T); % get rid of any trials that are excluded


%% Separate cases 1 and 2 based on movement
figure
idx = (T.outcome == 1 | T.outcome == 2);
H = histogram(T.rms_mvmt(idx));
disp([H.BinEdges(1:end-1)',H.Values'])
H.Parent.YLim = [0 sum(H.Values(H.BinEdges(1:end-1)>H.BinEdges(2)))];
text(H.Parent,H.BinEdges(3),H.Parent.YLim(2)-.1*diff(H.Parent.YLim),sprintf('Bin 1 total: %d',H.Values(1)))
title(H.Parent,'Histogram of RMS Movement in no punishment trials');

movement_threshold = 5;

% Any trial with > 5 rms movement is classified as outcome 2;
% idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt > movement_threshold;
% T.outcome(idx) = 2;


%% outcomes

% progression of outcomes
fig = plotTrialOutcomes(T,outcomes,'Title',[regexprep(cid,'_','\\_'), ': Trial outcome over course of experiment']);

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
idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt > 40;
ttl = 'no punishment with rms movement > 40 um';
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

% plot no_punishment trials with semi large movements
idx = (T.outcome == 1 | T.outcome == 2) & T.rms_mvmt > movement_threshold & T.rms_mvmt < 32;
ttl = sprintf('no punishment with rms movement > %d & < 40 um',movement_threshold);
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

% quick check outcome1 is trials on which the fly didn't move
sum(T.rms_mvmt(T.outcome==1) > movement_threshold)

% how many blocks?
unique(T.block)                    % 12, 0 - rest
unique(T.block(~T.hiforce,:)) 
unique(T.block(T.hiforce,:)) 

% --- Starts with high force: block 1 is high, block 2 is low

% no punishment; hi force trials early on (block 2,4) vs  late (10,12)
idx = T.outcome == 1 & T.hiforce & (T.block == 1 | T.block == 3);
ttl = 'Early hi force successful trials (blocks 1 and 3)';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(T.block == 1 | T.block == 3));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

idx = T.outcome == 1 & T.hiforce & (T.block == 9 | T.block == 11);
ttl = 'Late hi force successful trials (blocks 9 and 11)';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(T.block == 9 | T.block == 11));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);


% no punishment; lo force trials early on (block 2,4) vs  late (10,12)
idx = T.outcome == 1 & ~T.hiforce & (T.block == 2 | T.block == 4);
ttl = 'Early lo force successful trials (blocks 2 and 4)';
ttl = sprintf('%s: %d trials (of %d)',ttl,sum(idx),sum(T.block == 1 | T.block == 3));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);

idx = T.outcome == 1 & ~T.hiforce & (T.block == 10 | T.block == 12);
ttl = 'Late lo force successful trials (blocks 10 and 12)';
ttl = sprintf('%s: %d trials (of %d late trials)',ttl,sum(idx),sum(T.block == 10 | T.block == 12));
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



%% ********** Punishment trials **********

figure  
idx = (T.outcome == 3 | T.outcome == 4);
H = histogram(T.rms_mvmt(idx));
disp([H.BinEdges(1:end-1)',H.Values'])
H.Parent.YLim = [0 sum(H.Values(H.BinEdges(1:end-1)>H.BinEdges(2)))];
text(H.Parent,H.BinEdges(3),H.Parent.YLim(2)-.1*diff(H.Parent.YLim),sprintf('Bin 1 total: %d',H.Values(1)))
title(H.Parent,'Histogram of RMS Movement in punishment - off trials');

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


%% ********** How does movement relate to spiking? **********

% We know there is movement in outcome 3 trials. Rank them by rms movement,

figure  
idx = T.outcome == 3 & T.rms_mvmt>10;
H = histogram(T.rms_mvmt(idx));
disp([H.BinEdges(1:end-1)',H.Values'])
title(H.Parent,'Histogram of large Movements in punishment - off trials');

%% Look at the variance and rms of the movement. 
% They are basically the same, but reaching trials should have less
% variance, but may have similar rms values

figure
idx = T.outcome == 3 & T.rms_mvmt>10;
plot([0 max(T.rms_mvmt(idx))],[0 max(T.rms_mvmt(idx))],'color',[.8 .8 .8])
hold on
plot(T.rms_mvmt(idx),sqrt(T.var_mvmt(idx)),'.')
xlabel('RMS')
xlabel('Variance')

% Maybe reaching trials lie off the unity line
m = 1/1.7;
b = 0;
plot([0 max(T.rms_mvmt(idx))],m*[0 max(T.rms_mvmt(idx))]+b,'color',[.8 .8 .8])

idx = T.outcome == 3 & T.rms_mvmt>40 & T.rms_mvmt<100;
reach_idx = idx & sqrt(T.var_mvmt) < m*T.rms_mvmt+b;
plot(T.rms_mvmt(reach_idx),sqrt(T.var_mvmt(reach_idx)),'.')

%% plot reach movements
ttl = 'reach trials';
ttl = sprintf('%s: %d trials',ttl,sum(reach_idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfTrials(T(idx,:),ttl);%,fplims);
[fig] = plotChunkOfSpikes(T(idx,:),ttl);%,fplims);

% I think we're looking for trial ~64
idx = T.outcome == 3 & T.rms_mvmt>20 & T.rms_mvmt<80;
ttl = 'Reach - trials';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
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
idx = T.outcome == 4 & T.hiforce;
ttl = 'punishment - late, hi force';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);

% plot moving punishment - late, lo force
idx = T.outcome == 4 & ~T.hiforce;
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

% --- curious what happens on the next trials ---
T.trial(idx)
idx_next = circshift(idx,1);
T.trial(idx_next)
ttl = 'trials after, punishment - late, lo force, blue LED';
ttl = sprintf('%s: %d trials',ttl,sum(idx_next));
T.rms_mvmt(idx_next)
[fig] = plotChunkOfLongTrials(T(idx_next,:),ttl);%,fplims);

idx_next = circshift(idx_next,1);
T.trial(idx_next)
ttl = 'trials after, punishment - late, lo force, blue LED';
ttl = sprintf('%s: %d trials',ttl,sum(idx_next));
T.rms_mvmt(idx_next)
[fig] = plotChunkOfLongTrials(T(idx_next,:),ttl);%,fplims);

idx_next = circshift(idx_next,1);
T.trial(idx_next)
ttl = 'trials after, punishment - late, lo force, blue LED';
ttl = sprintf('%s: %d trials',ttl,sum(idx_next));
T.rms_mvmt(idx_next)
[fig] = plotChunkOfLongTrials(T(idx_next,:),ttl);%,fplims);


% plot moving punishment - late, lo force
idx0 = T.outcome == 4 & ~T.hiforce;
idx = idx0 & ~T.blueToggle;
ttl = 'punishment - late, lo force, red LED';
ttl = sprintf('%s: %d trials',ttl,sum(idx));
T.rms_mvmt(idx)
[fig] = plotChunkOfLongTrials(T(idx,:),ttl);%,fplims);



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
% Any trial with > 20 rms movement is classified as outcome 6;
% idx = (T.outcome == 5 | T.outcome == 6) & T.rms_mvmt > 20;
% T.outcome(idx) = 6;

% quick check outcome1 is trials on which the fly didn't move
any(T.rms_mvmt(T.outcome==5) > 20)


% plot failure trials with large movements
idx0 = (T.outcome == 5 | T.outcome == 6);
idx = idx0 & T.rms_mvmt >20;
ttl = 'timeouts with rms movement > 5 um';
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


%% ************ Future analyses **************

% Find trials where the neuron is spiking during the cue
% Relate movements to spike rates


