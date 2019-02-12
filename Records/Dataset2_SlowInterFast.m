% Slow Workflows

% Slow
% Workflow_35C09_180111_F1_C1_ForceProbePatching
% Workflow_35C09_180307_F2_C1_ForceProbePatching
% Workflow_35C09_180313_F1_C1_ForceProbePatching
% 
% Workflow_35C09_180621_F1_C1_ForceProbePatching % 
% Workflow_35C09_180628_F2_C1_ForceProbePatching % spike detection complete
% Workflow_35C09_181014_F1_C1_ForceProbePatching % complete!
% 
% Workflow_35C09_181021_F1_C1_ForceProbePatching
% Workflow_35C09_181024_F2_C1_ForceProbePatching
% Workflow_35C09_181127_F1_C1_ForceProbePatching
% Workflow_35C09_181127_F2_C1_ForceProbePatching
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
% Workflow_22A08_181205_F1_C1_ForceProbePatching


%% Fast work flows

% 81A07 - with ChR
% Workflow_81A07_171101_F1_C1_ForceProbePatching
% Workflow_81A07_171102_F1_C1_ForceProbePatching
% Workflow_81A07_171102_F2_C1_ForceProbePatching
% Workflow_81A07_171103_F1_C1_ForceProbePatching
% Workflow_81A07_180308_F3_C1_ForceProbePatching
% Workflow_81A07_190116_F1_C1_ForceProbePatching % Is this a flexor?
% Workflow_81A07_190116_F3_C1_ForceProbePatching


%% Others

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

%% 
Dataset2_SlowInterFast_SpontaneousActivity.m
Dataset2_SlowInterFast_Sensory_Ramps
Dataset2_SlowInterFast_Sensory_Steps

%% Figure 3: Intro to motor neurons example traces

fig = figure;
set(fig,'color',[1 1 1])
fig.Position = [680   287   560   691];
panl = panel(fig);

panl.pack('h',{1/3 1/3 1/3})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
% panl(1).marginbottom = 2;
% panl(2).margintop = 8;

vsplit = [3 1 1 1]; vsplit = num2cell(vsplit/sum(vsplit));
panl(1).pack('v',vsplit)
panl(2).pack('v',vsplit)
panl(3).pack('v',vsplit)

ylims1 = [-60 5];

% fast
ax = panl(1,1).select();
trial = load('E:\Data\180308\180308_F3_C1\CurrentStep2T_Raw_180308_F3_C1_9.mat');
t = makeInTime(trial.params);
plot(t,trial.voltage_1), hold on
trial = load('E:\Data\180308\180308_F3_C1\CurrentStep2T_Raw_180308_F3_C1_4.mat');
plot(t,trial.voltage_1)
ax.XLim = [-.5 1];
ax.YLim = ylims1;

ax = panl(1,2).select();
trial = load('E:\Data\180308\180308_F3_C1\CurrentStep2T_Raw_180308_F3_C1_9.mat');
plot(t,trial.current_2); hold on
trial = load('E:\Data\180308\180308_F3_C1\CurrentStep2T_Raw_180308_F3_C1_4.mat');
plot(t,trial.current_2); hold on
ax.XLim = [-.5 1];


ax = panl(1,3).select();
trial = load('E:\Data\180308\180308_F3_C1\EpiFlash2T_Raw_180308_F3_C1_1.mat');
t = makeInTime(trial.params);
plot(t,trial.voltage_1)
ax.XLim = [-.5 1];
% ax.YLim = [-80 0];

ax = panl(1,4).select();
plot(t,trial.current_2)
ax.XLim = [-.5 1];
% ax.YLim = [-80 0];

% intermediate
ax = panl(2,1).select();
trial = load('E:\Data\181205\181205_F1_C1\CurrentStep2T_Raw_181205_F1_C1_7.mat');
t = makeInTime(trial.params);
plot(t,trial.voltage_1),hold on
trial = load('E:\Data\181205\181205_F1_C1\CurrentStep2T_Raw_181205_F1_C1_9.mat'); 
plot(t,trial.voltage_1)
ax.XLim = [-.5 1];
ax.YLim = ylims1;

ax = panl(2,2).select();
plot(t,trial.current_2)
ax.XLim = [-.5 1];
% ax.YLim = [-80 0];

% slow
ax = panl(3,1).select();
trial = load('E:\Data\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_17.mat');
t = makeInTime(trial.params);
plot(t,trial.voltage_1), hold on
raster(ax,t(trial.spikes),[-4.5 -.5]);
trial = load('E:\Data\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_19.mat');
plot(t,trial.voltage_1)
raster(ax,t(trial.spikes),[.5 4.5]);
ax.XLim = [-.5 1];
ax.YLim = ylims1;


