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

%% Plot responses from a particular cell, look for example cells
CellID = '190116_F3_C1'; 
% Fast: 
% 171101_F1_C1 - pretty; 
% 171102_F2_C1 - steps in only 1 direction;
% 171103_F1_C1 - nice, only 1 position; 
% 180308_F3_C1 - change in membrane potential during rest; 
% 190116_F1_C1 - only 2 positions; 
% ** 190116_F3_C1 - great;
% Intermediate: 
% 180222_F1_C1 - not great; 
% 180223_F1_C1 - unstable, high membrane potential; 
% 180320_F1_C1 - again, depolarization; 
% 180405_F3_C1 - meh, not all positions; 
% 180807_F1_C1 - no, not all positions there;
% ** 181118_F1_C1 - too much activity, could clean up; 
% 181205_F1_C1 - not hyperpolarized in other direction, in fact the timing
% of the off response follows the on response, as if missing the inhibition
Plot_ResponsesForRampsAndSteps

%% Plot responses for slow neurons with firing rate
close all
CellID = '181128_F2_C1';
% 180111_F2_C1 - no 75 position, nice, though
% 180621_F1_C1 - no 75 position, nice, though
% 180628_F2_C1 - weird cell, sharp responses, not publication quality
% 181014_F1_C1 - nice, sharp, has a few stray weird trials for -75
% 181021_F1_C1 - no 150 or -150
% 181024_F2_C1 - no -150
% 181127_F1_C1 - nice;
% 181127_F2_C1 - seeing a constent change in the resting rate of -10 and 10
% 181128_F1_C1 - not much, no positions; 
% 181128_F2_C1 - nice;

Plot_SpikeRatesForRampsAndSteps


%%
close all
CellID = '181127_F2_C1';
Plot_RastersForRampsAndSteps

%% Plot examples for the figure
Plot_ExampleRampsForFigures

%% Plot spike rate for slow neurons in MLA
unique(T_RampAndStep.CellID(logical(T_RampAndStep.mla)))
close all
CellID = '181205_F1_C1';
% Intermediate
% 181205_F1_C1
% Slow
% 180628_F2_C1 - no spikes at all
% 181024_F2_C1 - no -150
% 181127_F2_C1 - seeing a constent change in the resting rate of -10 and 10
% 181128_F2_C1 - nice;

Plot_ResponsesForRampsAndStepsAndMLA
Plot_RastersForRampsAndStepsMLA
Plot_SpikeRatesForRampsAndStepsMLA

%% Compare resting spike rates and responses to different size steps in MLA
Script_mlaEffectOnSensoryFeedback

%% Plot the peaks for -10 step, 150 speed 
% There is no significant correlation between position and depolarization,
% even if the peaks are normalized
Script_computeCorrelationOfResistanceReflexAndPosition

%% Plot the peaks vs speed for each category at each displacement, including steps
Script_showSensoryFeedbackPeaksVsSpeedAndPosition

%% Plot the peaks vs amplitude for steps
Script_showSensoryFeedbackPeaksVsAmplitudeAndPosition

%% Plot the peaks vs amplitude for steps
Script_showRelativeTimeToPeakForSlowNeurons

%% Compare membrane potential changes at different timescales
% x axis is in degrees, starting at minimum -150, going to 150
% steps are in the opposite direction, but a step of 10V is ~8 deg, where
% as the positions cover 42 deg
Script_compareSensoryFeedbackAcrossTimescales 
Script_compareSlowMNSpikeRatesAcrossTimescales


%% Plot the average dynamics of 82 deg per second across cells
Script_showAverageVmAcrossCellsForOnePositionAndSpeed

%%
Script_showAverageFRAcrossCellsForSmallDisplacements

%%
Script_showVmForEachType

%% Use spontaneous activity script for this
% Script_estimateInputResistanceFromCurrentPulses

%% Spontaneous spike rate
Script_showSpontaneousFRForEachType

%% Compare iav to non-iav 
% come back and look at the firing rate after analyzing Dataset5
% Plot the peaks vs speed for each category at each displacement, including steps
Script_EffectOfChRActivationOfIavNeurons

%% Reflex reversal in 35C09 in 181127_F2_C1 
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

%% Slow Workflows

% Slow
% Workflow_35C09_180111_F1_C1_ForceProbePatching
% Workflow_35C09_180307_F2_C1_ForceProbePatching
% Workflow_35C09_180313_F1_C1_ForceProbePatching
% 
% Workflow_35C09_180621_F1_C1_ForceProbePatching % 
% Workflow_35C09_180628_F2_C1_ForceProbePatching % spike detection complete
% Workflow_35C09_181014_F1_C1_ForceProbePatching % complete!
% 
% Workflow_35C09_181021_F1_C1_ForceProbePatching % spike detection and leg movement complete
% Workflow_35C09_181024_F2_C1_ForceProbePatching
% Workflow_35C09_181127_F1_C1_ForceProbePatching
% Workflow_35C09_181127_F2_C1_ForceProbePatching
% 
% Workflow_35C09_181128_F1_C1_ForceProbePatching
% Workflow_35C09_181128_F2_C1_ForceProbePatching


%% Intermediate workflows
% Workflow_22A08_180222_F1_C1_ForceProbePatching % clear movement of the bar with single spikes, very nice!
% Workflow_22A08_180223_F1_C1_ForceProbePatching
% Workflow_22A08_180320_F1_C1_ForceProbePatching
% 
% Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching
% Workflow_22A08_180807_F1_C1_ChRStimulation_ForceProbePatching
% 
% Workflow_22A08_181118_F1_C1_ForceProbePatching
% 
% Workflow_22A08_181205_F1_C1_ForceProbePatching


%% Fast work flows

% 81A07 - with ChR
% Workflow_81A07_171101_F1_C1_ForceProbePatching
% Workflow_81A07_171102_F1_C1_ForceProbePatching
% Workflow_81A07_171102_F2_C1_ForceProbePatching
% Workflow_81A07_171103_F1_C1_ForceProbePatching
% Workflow_81A07_180308_F3_C1_ForceProbePatching

% 
%% Others
% 
% % Slow
% % 81A06
% Workflow_81A06_171025_F1_C1_ForceProbePatching % 171025_F1_C1
% 
% % Workflow_81A06_171107_F1_C2_ForceProbePatching % not much leg movement
% Workflow_81A06_171116_F1_C1_ForceProbePatching % Good cell, current injection nice, still need to 
% 
% 
% % Intermediate workflows
% 
% % 81A06
% % Interesting cell, used the spike current hack thing, even had a signal in
% % the EMG. 
% Workflow_81A06_171026_F2_C1_ForceProbePatching 
% 
% % no spiking, not clear what this was, but large sensory responses that
% % don't really look like 
% Workflow_81A06_171107_F1_C1_ForceProbePatching 
% 
% % first really clear evidence of intermediate neuron, with a nice fill
% Workflow_81A06_171122_F1_C1_ForceProbePatching
% 
% % Nice spikes, good strong responses to sensory information. piezo ramp
% % videos
% Workflow_81A06_180112_F1_C1_ForceProbePatching