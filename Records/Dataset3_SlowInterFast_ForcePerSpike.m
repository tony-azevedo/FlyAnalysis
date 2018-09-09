%% Slow Workflows
Workflow_35C09_180111_F2_C1_ForceProbePatching
Workflow_35C09_180307_F2_C1_ForceProbePatching
Workflow_35C09_180313_F1_C1_ForceProbePatching
Workflow_35C09_180621_F1_C1_ForceProbePatching
Workflow_35C09_180628_F2_C1_ForceProbePatching

% Example spike injection in MLA
Workflow_iavChR_35C09_180329_F1_C1_ForceProbePatching

%% Intermediate workflows
Workflow_22A08_180222_F1_C1_ForceProbePatching
% Workflow_22A08_180223_F1_C1_ForceProbePatching % no twitches but this cell spiked upon entry!
Workflow_22A08_180320_F1_C1_ForceProbePatching
Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching
Workflow_22A08_180807_F1_C1_ChRStimulation_ForceProbePatching % Red LED artifact


%% Fast work flows

% 81A07
Workflow_81A07_170921_F1_C1_ForceProbePatching
Workflow_81A07_171101_F1_C1_ForceProbePatching
Workflow_81A07_171102_F1_C1_ForceProbePatching
Workflow_81A07_171102_F2_C1_ForceProbePatching
Workflow_81A07_171103_F1_C1_ForceProbePatching
Workflow_81A07_180308_F3_C1_ForceProbePatching


%% Other work flows

Workflow_35C09_180621_F3_C1_ForceProbePatching % non green, reductor non spiking



%% Miscelaneous

% VT26027 - Extensor! Hard to see som bar movement in all but decent, kind
% of a reductor type recording. This is a (the?) slow extensor



%% Example trials of motor neuron activity, emg, and bar

% ----- Fast -----
clear trials;
trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_37.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Inter
clear trials;
trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_68.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Slow random -----
clear trials;
trial = load('B:\Raw_Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_174.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Slow -----
clear trials;
trial = load('B:\Raw_Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_89.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_91.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamplesOfSlowMN_Spikes_EMG_Probe

%% For the example cells, show aligned spikes and forces

% ---- Fast -----
trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 22:151; 
Script_alignSingleAndDoubleSpikes

% ---- Inter -----
trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 25:204; % Low
Script_alignSingleAndDoubleSpikes


%%

CSHL_select_spikes_FR

%%
CSHL_trajects_by_SpN

%% 

CSHL_1cell_1spike


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



