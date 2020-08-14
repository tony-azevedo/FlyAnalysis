%% Cells with steps and ramps 
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions'};

sz = [2 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

%T{1,:} = {'170921_F1_C1', '81A07/ChR',            'fast', 'PiezoStep2T','empty',0}; % no steps
T{1,:} = {'171101_F1_C1', '81A07/ChR',            'fast', 'PiezoRamp2T','empty',0}; 
%T{3,:} = {'171102_F1_C1', '81A07/ChR',            'fast', 'PiezoStep2T','empty',[]};
T{2,:} = {'171102_F2_C1', '81A07/ChR',            'fast', 'PiezoRamp2T','empty',0}; 
T{end+1,:} = {'171103_F1_C1', '81A07/ChR',            'fast', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'180308_F3_C1', '81A07/ChR',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180404_F1_C1', '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180410_F1_C1', '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180703_F3_C1', '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'190116_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'190116_F3_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]}; %'190123_F3_C1' is only in MLA to confirm that it was working. that's why it's not here
T{end+1,:} = {'190227_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]}; 
T{end+1,:} = {'190228_F1_C1', '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'190527_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'190605_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',0}; 
T{end+1,:} = {'190619_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',0}; 
T{end+1,:} = {'190619_F3_C1', '81A07',            'fast', 'PiezoRamp2T','empty',0}; 

T{end+1,:} = {'180222_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180223_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'180320_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180328_F4_C1', '22A08/iav-LexA',   'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180405_F3_C1', '22A08/ChR',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180807_F1_C1', '22A08/ChR',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180821_F1_C1', '22A08/iav-LexA',   'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180822_F1_C1', '22A08/iav-LexA',   'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181118_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181205_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181220_F1_C1', '22A08/iav-LexA',   'intermediate', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'190827_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'190903_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'190905_F2_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'190908_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',0};

T{end+1,:} = {'180111_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
% T{end+1,:} = {'180307_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]}; % 1 kHz. crap spike detection
% T{end+1,:} = {'180313_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]}; % 1 kHz. crap spike detection
T{end+1,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180621_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
% T{end+1,:} = {'180621_F3_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180628_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'180806_F2_C1', '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',0};
T{end+1,:} = {'181014_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181021_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181024_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181127_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181127_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181128_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'181128_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};

T_RampCells = T;
T_StepCells = T;
T_StepCells.Protocol(:) = {'PiezoStep2T'};

% Ramps
%Script_tableOfRampResponseData
%save('E:\Results\Dataset2_SIF_T_Ramp','T_Ramp')
T_Ramp = load('E:\Results\Dataset2_SIF_T_Ramp'); T_Ramp = T_Ramp.T_Ramp;
head(T_Ramp)

% Steps 
%Script_tableOfStepResponseData
%save('E:\Results\Dataset2_SIF_T_Step','T_Step')
T_Step = load('E:\Results\Dataset2_SIF_T_Step'); T_Step = T_Step.T_Step;
head(T_Step)

% Sweeps
% Script_tableOfStepResponseData
% head(T_Sweep)

% Combine steps and ramps of same size into one table
rampdisplacements = unique(T_Ramp.Displacement);
rampdispidx = abs(T_Step.Displacement)==10;
T_LargeSteps = T_Step(rampdispidx,:);
T_RampAndStep = [T_Ramp; T_LargeSteps];
T_RampAndStep = sortrows(T_RampAndStep,[3,1]);

% Get firing rate data on slow neurons, for ramps and steps of size 10
% Script_spikeRatesForRampsAndLargeSteps
%save('E:\Results\Dataset2_SIF_T_RmpStpSlowFR','T_RmpStpSlowFR')
T_RmpStpSlowFR = load('E:\Results\Dataset2_SIF_T_RmpStpSlowFR'); T_RmpStpSlowFR = T_RmpStpSlowFR.T_RmpStpSlowFR;
head(T_RmpStpSlowFR)

% Get the firing rate data on slow neurons for steps
% Script_spikeRatesForSteps
% save('E:\Results\Dataset2_SIF_T_StpSlowFR','T_StpSlowFR')
T_StpSlowFR = load('E:\Results\Dataset2_SIF_T_StpSlowFR'); T_StpSlowFR = T_StpSlowFR.T_StpSlowFR;
head(T_StpSlowFR)


%% Figure 6A-B
Plot_ExampleRampsForFigures

%% Figure 6C,D, Figure 6 - figsup 1A
Script_showSensoryFeedbackPeaksVsSpeedAndPosition

%% Plot the peaks vs amplitude for steps
Script_showSensoryFeedbackPeaksVsAmplitudeAndPosition

%% Figure 6E - Plot the average dynamics of 82 deg per second across cells
Script_showAverageVmAcrossCellsForOnePositionAndSpeed

%% Figure 6F - 
Script_showAverageFRAcrossCellsForSmallDisplacements

%% Figure 3C - Vm for each cell
Script_showVmForEachType

%% Figure 3D - spontaneous spike rates from sensory feedback trials
Script_showSpontaneousFRForEachType

%% 6 - figsup 2C - Compare iav to non-iav 
% come back and look at the firing rate after analyzing Dataset5
% Plot the peaks vs speed for each category at each displacement, including steps
Script_EffectOfChRActivationOfIavNeurons

%% 6 - figsup 1C - Reflex reversal in 35C09 in 181127_F2_C1 
figure
% trial = load('E:\Data\181021\181021_F1_C1\PiezoStep2T_Raw_181021_F1_C1_168.mat');
trial = load('E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_30.mat');
t = makeInTime(trial.params);
ax = subplot(3,2,1); ax.NextPlot = 'add'; ax.YLim = [-40 -22];
title('Extension depolarizes neuron')
plot(t,trial.voltage_1,'k'), hold on, raster(ax,t(trial.spikes),[-25 -22.5]);

ax = subplot(3,2,3); ax.NextPlot = 'add'; ax.YLim = [-60 40];
plot(t,trial.current_2,'k')

ax = subplot(3,2,5); ax.NextPlot = 'add';
plot(t,PiezoRampStim(trial.params),'b')

trial = load('E:\Data\181127\181127_F2_C1\PiezoRamp2T_Raw_181127_F2_C1_50.mat');
t = makeInTime(trial.params);
ax = subplot(3,2,2); ax.NextPlot = 'add'; ax.YLim = [-40 -22];
title('Extension hyperpolarizes neuron')
plot(t,trial.voltage_1,'k'), hold on, raster(ax,t(trial.spikes),[-25 -22.5]);
spike_counts = zeros(size(t)); spike_counts(trial.spikes) = 1;
%plot(t,firingRate(t,spike_counts,.03));

ax = subplot(3,2,4); ax.NextPlot = 'add'; ax.YLim = [-60 40];
plot(t,trial.current_2,'k')

ax = subplot(3,2,6); ax.NextPlot = 'add';
plot(t,PiezoRampStim(trial.params),'b')

%% Plot the delay for any good (ie non iav) fast or intermediate cells 


clrs = [0 0 0
    1 0 1
    0 .5 0];
cids = unique(T_Step.CellID);
clbls = unique(T.Cell_label);

figure
ax = subplot(1,1,1); hold(ax,'on');
% plot(ax,[-10 10],[0 0],'color',[1 1 1]*.8)
for cidx = 1:length(cids)
    idx = strcmp(T_Step.CellID,cids{cidx});
    if ~isempty(regexp(T_Step.Genotype{find(idx,1)},'iav','once'))
        continue
    end
    step_idx = T_Step.Displacement;
    x = T_Step.Displacement(idx);
    y = T_Step.Delay(idx);
    
    delay = y(x==-10);
    typ = find(strcmp(clbls,T_Step.Cell_label{find(idx,1)}));
    clr = clrs(strcmp(clbls,T_Step.Cell_label{find(idx,1)}),:);
    plot(ax,typ,delay,'marker','o','markeredgecolor',clr,'markerfacecolor',clr,'tag',cids{cidx});
end
ax.XLim = [.5 3.5];
