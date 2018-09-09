% Slow Workflows

% 81A06
Workflow_81A06_171025_F1_C1_ForceProbePatching % 171025_F1_C1

% Workflow_81A06_171107_F1_C2_ForceProbePatching % not much leg movement
Workflow_81A06_171116_F1_C1_ForceProbePatching % Good cell, current injection nice, still need to 

% 35C09
% Great recording, current steps that change the position of the bar,
% change 
Workflow_35C09_180111_F1_C1_ForceProbePatching

% decent recording, hard to see spikes, no seal and leak but not sure it
% I was clearly in the cell
Workflow_35C09_180307_F2_C1_ForceProbePatching

Workflow_35C09_180313_F1_C1_ForceProbePatching

%% Intermediate workflows

% 81A06
% Interesting cell, used the spike current hack thing, even had a signal in
% the EMG. 
Workflow_81A06_171026_F2_C1_ForceProbePatching 

% no spiking, not clear what this was, but large sensory responses that
% don't really look like 
Workflow_81A06_171107_F1_C1_ForceProbePatching 

% first really clear evidence of intermediate neuron, with a nice fill
Workflow_81A06_171122_F1_C1_ForceProbePatching

% Nice spikes, good strong responses to sensory information. piezo ramp
% videos
Workflow_81A06_180112_F1_C1_ForceProbePatching


% 82E04
% EMG on some of the trials, spikes are not clear. Something was going on
% with the last Sweeps, but I have no idea what!
Workflow_82E04_180118_F1_C1_ForceProbePatching


% 22A08
% clear movement of the bar with single spikes, very nice!
Workflow_22A08_180222_F1_C1_ForceProbePatching


Workflow_22A08_180320_F1_C1_ForceProbePatching 

% Workflow_22A08_180322_F1_C1_ForceProbePatching 

Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching

% Slow
Workflow_35C09_180111_F1_C1_ForceProbePatching
Workflow_35C09_180307_F2_C1_ForceProbePatching
Workflow_35C09_180313_F1_C1_ForceProbePatching
Workflow_35C09_180621_F1_C1_ForceProbePatching
Workflow_35C09_180628_F2_C1_ForceProbePatching


%% Intermediate workflows
Workflow_22A08_180222_F1_C1_ForceProbePatching
Workflow_22A08_180223_F1_C1_ForceProbePatching
Workflow_22A08_180320_F1_C1_ForceProbePatching
Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching
Workflow_22A08_180807_F1_C1_ChRStimulation_ForceProbePatching


%% Fast work flows

% 81A07 - with ChR
Workflow_81A07_171101_F1_C1_ForceProbePatching
Workflow_81A07_171102_F1_C1_ForceProbePatching
Workflow_81A07_171102_F2_C1_ForceProbePatching
Workflow_81A07_171103_F1_C1_ForceProbePatching
Workflow_81A07_180308_F3_C1_ForceProbePatching


%% Fast work flows

% 81A07
Workflow_81A07_171101_F1_C1_ForceProbePatching
Workflow_81A07_171102_F1_C1_ForceProbePatching
Workflow_81A07_171102_F2_C1_ForceProbePatching
Workflow_81A07_171103_F1_C1_ForceProbePatching
Workflow_81A07_180308_F3_C1_ForceProbePatching



%% Miscelaneous

% VT26027 - Extensor! Hard to see som bar movement in all but decent, kind
% of a reductor type recording. This is a (the?) slow extensor

%% Now the interesting stuff


%% Plot the area of the twtich, from 0 to .05 across distance

% time around the twitch to show
t_i_f = [-0.02 .13];
   
% ----------- 171103_F1_C1 ------------
trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_75.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
disp(trial.name), cd(D)
clear trials
% EpiFlash Sets - cause spikes and video movement
% Position 0 EpiFlash2T: 
trials{1} = 72:115;
% Position 100 EpiFlash2T:
trials{2} = 116:139;
% Position 200 EpiFlash2T: 
trials{3} = 140:163;
% Position -100 EpiFlash2T: 
trials{4} = 164:187;
% Position -200 EpiFlash2T:
trials{5} =  188:211;
% Position 0 EpiFlash2T more spikes: 
trials{6} = 212:223;
dists = [200 100 0 -100 -200 0];
setordridx = [1 2 3 4, 5];
script_singleSpikeTwitchAtEachDistance


% ----------- 180308_F3_C1 ------------
trial = load('B:\Raw_Data\180308\180308_F3_C1\EpiFlash2T_Raw_180308_F3_C1_5.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
disp(trial.name), cd(D)

clear trials 
trials{1} = 4:66; % 0
trials{2} = 70:99; % 0 
trials{3} = 100:129; % 75
trials{4} = 130:159; % 150
trials{5} = 161:190; % -75
trials{6} = 191:220; % -150
trials{7} = 221:242; % 0
trials{8} = 243:262; % 0 more spikes

dists = [0 0 75 150 -75 -150 0 0];
setordridx = [1 2 3 4 5 6 7];
script_singleSpikeTwitchAtEachDistance



