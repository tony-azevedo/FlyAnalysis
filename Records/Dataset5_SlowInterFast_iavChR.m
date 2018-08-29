%% Workflows for iav Chr experiments

% 81A06
% No patching in this one, just a record of the movement and result of ChR
% stimulation
Workflow_iavChR_81A06_180305_F1_C1_ForceProbePatching

% test of whether this will work or not.
% nice patching example. What is the evidence it's an intermediate neuron?
Workflow_iavChR_81A06_180306_F2_C1_ForceProbePatching

% 81A07
% decent recording, not great, no sensory responses
Workflow_iavChR_81A07_180404_F1_C1_ForceProbePatching
Workflow_iavChR_81A07_180410_F1_C1_ForceProbePatching
Workflow_iavChR_81A07_180703_F3_C1_ForceProbePatching

% 22A08
Workflow_iavChR_22A08_180328_F4_C1_ForceProbePatching
Workflow_iavChR_22A08_180821_F1_C1_ForceProbePatching
Workflow_iavChR_22A08_180822_F1_C1_ForceProbePatching


% 35C09
Workflow_iavChR_35C09_180328_F1_C1_ForceProbePatching % Still need to analyse a low intensity stim epiFlash set that was focused on the probe, will need to create a new probe tracking routine
Workflow_iavChR_35C09_180329_F1_C1_ForceProbePatching % This is an amazing cell!
Workflow_iavChR_35C09_180702_F1_C1_ForceProbePatching
Workflow_iavChR_35C09_180806_F1_C1_ForceProbePatching


% Controls 
Workflow_iavChRcontrol_180821_F4_C1_ForceProbePatching


% Early club results
Workflow_clubChR_JR185_180819_F1_C1_ForceProbePatching

% Early club results
Workflow_clawChR_JR204_180821_F2_C1_ForceProbePatching
Workflow_clawChR_JR204_180821_F2_C1_ForceProbePatching

%% Light intensity relationship 
RedLEDPowerVsExternalVoltage

%% Example trials from each type (Not complete) 

% 81A07 - one option
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


% 22A08 - option only 1

% low range, just pulls, lets go in one case
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_26.mat');

% middle range, fly lets go of the bar.
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_27.mat');

% maxes out
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_24.mat');

% 35C09 - couple of options

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

%% Where the analysis belongs
savedir = 'G:\My Drive\Projects\FlySensorimotor\Analysis\Dataset5_iavChr';
winopen(savedir);

%% Initial comparisons

close all
% plot a couple examples of iav stimulation: slow, fast, inter for
% different light intensities and trajectories

% Inter 180822_F1_C1 Low
trial = load('B:\Raw_Data\180822\180822_F1_C1\EpiFlash2T_Raw_180822_F1_C1_27.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

num = 79; Script_Dataset5_V_Prb_1FlashStrength_1trial
Script_Dataset5_F_Vs_V_1FlashStrength_1Trial
Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength
ax = panl(1).select(); ax.YLim = [-50 -20]; ax.XLim = [-50 325];

% Inter 180822_F1_C1 Higher
trial = load('B:\Raw_Data\180822\180822_F1_C1\EpiFlash2T_Raw_180822_F1_C1_19.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'}); nums

num = 13; Script_Dataset5_V_Prb_1FlashStrength_1trial
Script_Dataset5_F_Vs_V_1FlashStrength_1Trial
Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength
ax = panl(1).select(); ax.YLim = [-50 -20]; ax.XLim = [-50 325];

% Inter 180822_F1_C1 Highest
trial = load('B:\Raw_Data\180822\180822_F1_C1\EpiFlash2T_Raw_180822_F1_C1_25.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

Script_Dataset5_V_Prb_1FlashStrength_1trial
Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength

% Inter 180822_F1_C1 all flash strengths
trial = load('B:\Raw_Data\180822\180822_F1_C1\EpiFlash2T_Raw_180822_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name); %#ok<*ASGLU>
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'ndf'}); nums %#ok<*NOPTS>

Script_Dataset5_F_Vs_V_AllFlashStrengths


% Inter 180821_F1_C1 Low
trial = load('B:\Raw_Data\180821\180821_F1_C1\EpiFlash2T_Raw_180821_F1_C1_19.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength

% Inter 180821_F1_C1 Weird one:
trial = load('B:\Raw_Data\180821\180821_F1_C1\EpiFlash2T_Raw_180821_F1_C1_29.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength

% Inter 180821_F1_C1 Higher:
trial = load('B:\Raw_Data\180821\180821_F1_C1\EpiFlash2T_Raw_180821_F1_C1_82.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength

% Inter 180328_F4_C1 (0.13 UV)
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_33.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength

% Inter 180328_F4_C1 higher (.25)
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_34.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength

% Inter 180328_F4_C1 highest (.5)
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_36.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});

Script_Dataset5_V_Prb_1FlashStrength
Script_Dataset5_F_Vs_V_1FlashStrength

%% Look at all flash strengths for all 22A08 Cells

% Inter 180822_F1_C1 all flash strengths
trial = load('B:\Raw_Data\180822\180822_F1_C1\EpiFlash2T_Raw_180822_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name); %#ok<*ASGLU>
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'ndf'}); nums %#ok<*NOPTS>

Script_Dataset5_F_Vs_V_AllFlashStrengths
ax = panl(1).select(); ax.YLim = [-50 -20]; ax.XLim = [-50 325];

% Inter 180328_F4_C1 all flash strengths
trial = load('B:\Raw_Data\180821\180821_F1_C1\EpiFlash2T_Raw_180821_F1_C1_1.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name); %#ok<*ASGLU>
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'ndf'}); nums %#ok<*NOPTS>

Script_Dataset5_F_Vs_V_AllFlashStrengths
ax = panl(1).select(); ax.YLim = [-50 -20]; ax.XLim = [-50 325];

% Inter 180328_F4_C1 all flash strengths
trial = load('B:\Raw_Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_33.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name); %#ok<*ASGLU>
cd(D)
% [nums,inds] = findLikeTrials('name',trial.name,'exclude',{'ndf','ndfs','trialBlock'}); nums %#ok<*NOPTS>
nums = [1:4,33:36]; inds = nums;
Script_Dataset5_F_Vs_V_AllFlashStrengths
ax = panl(1).select(); ax.YLim = [-50 -20]; ax.XLim = [-50 325];


%% 35C09

% 180328_F1_C1 % Still need to analyse a low intensity stim epiFlash set that was focused on the probe, will need to create a new probe tracking routine
% 180329_F1_C1 % This is an amazing cell!
% 180702_F1_C1
% 180806_F1_C1
% Workflow_iavChR_35C09_180328_F1_C1_ForceProbePatching % Still need to analyse a low intensity stim epiFlash set that was focused on the probe, will need to create a new probe tracking routine
% Workflow_iavChR_35C09_180329_F1_C1_ForceProbePatching % This is an amazing cell!
% Workflow_iavChR_35C09_180702_F1_C1_ForceProbePatching
% Workflow_iavChR_35C09_180806_F1_C1_ForceProbePatching


close all
% plot a couple examples of iav stimulation: slow, fast, inter for
% different light intensities and trajectories

trial = load('B:\Raw_Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_7.mat');
trial = load('B:\Raw_Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_5.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'}); nums

num = 5; Script_Dataset5_V_Prb_1FlashStrength_1trial
Script_Dataset5_F_Vs_V_1FlashStrength_1Trial
Script_Dataset5_V_Prb_1FlashStrength; ax = panl(1).select(); ax.YLim = [-50 -25]; 
Script_Dataset5_F_Vs_V_1FlashStrength
ax = panl(1).select(); ax.YLim = [-55 -30]; ax.XLim = [-25 75];

% All the cells
trial = load('B:\Raw_Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_67.mat'); 
nums = [36:44]; inds = nums;
trialnumlist = [11:75]; % more High

trial = load('B:\Raw_Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_14.mat'); 
nums = [11:20]; inds = nums;
trialnumlist = [14:98]; % more High

trial = load('B:\Raw_Data\180806\180806_F2_C1\EpiFlash2T_Raw_180806_F2_C1_5.mat'); 
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'ndf'}); nums %#ok<*NOPTS>
trialnumlist = [1:72]; % more High

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name); %#ok<*ASGLU>
cd(D)

Script_Dataset5_F_Vs_V_AllFlashStrengths
ax = panl(1).select(); ax.YLim = [-55 -28]; ax.XLim = [-25 75];

%% 81A07

Workflow_iavChR_81A07_180404_F1_C1_ForceProbePatching
Workflow_iavChR_81A07_180410_F1_C1_ForceProbePatching
Workflow_iavChR_81A07_180703_F3_C1_ForceProbePatching


close all
% plot a couple examples of iav stimulation: slow, fast, inter for
% different light intensities and trajectories

trial = load('B:\Raw_Data\180703\180703_F3_C1\EpiFlash2T_Raw_180703_F3_C1_7.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'}); nums

num = 5; Script_Dataset5_V_Prb_1FlashStrength_1trial
Script_Dataset5_F_Vs_V_1FlashStrength_1Trial
Script_Dataset5_V_Prb_1FlashStrength; ax = panl(1).select(); ax.YLim = [-50 -25]; 
Script_Dataset5_F_Vs_V_1FlashStrength
ax = panl(1).select(); ax.YLim = [-55 -30]; ax.XLim = [-25 75];

% Fast 180410_F1_C1 81A07 highest
trial = load('B:\Raw_Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_47.mat');
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'}); nums
num = 47;

% Fast 180410_F1_C1 81A07 high
trial = load('B:\Raw_Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_5.mat');
[nums,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'}); nums
num = 6;



Script_Dataset5_V_Prb_1FlashStrength_1trial
Script_Dataset5_F_Vs_V_1FlashStrength_1Trial
Script_Dataset5_V_Prb_1FlashStrength; ax = panl(1).select(); ax.YLim = [-55 -30]; 
Script_Dataset5_F_Vs_V_1FlashStrength
ax = panl(1).select(); ax.YLim = [-55 -30]; ax.XLim = [-25 75];



% All the cells
trial = load('B:\Raw_Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_13.mat');
nums = [13:16, 49:53]; inds = nums; 
trialnumlist = [13:44, 45:68]; % or 88, but the probe moves

trial = load('B:\Raw_Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_66.mat'); 
nums = [2:8]; inds = nums;
trialnumlist = [2:28, 66:137]; % more High

trial = load('B:\Raw_Data\180703\180703_F3_C1\EpiFlash2T_Raw_180703_F3_C1_21.mat');
nums = [3:11]; inds = nums;
trialnumlist = [3:72]; % more High

Script_Dataset5_F_Vs_V_AllFlashStrengths
ax = panl(1).select(); ax.YLim = [-55 -35]; ax.XLim = [-50 175];

%% Drug observations:

% Caffeine
trial = load('B:\Raw_Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_96.mat');
Script_Dataset5_V_Prb_1FlashStrength;
print(gcf,fullfile(savedir,'EpiFlash2T_Raw_180404_F1_C1_96_Caffeine'), '-dpng')

% compare to 
trial = load('B:\Raw_Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_66.mat');
Script_Dataset5_V_Prb_1FlashStrength;
print(gcf,fullfile(savedir,'EpiFlash2T_Raw_180404_F1_C1_66_NoCaffeine'), '-dpng')


% MLA
trial = load('B:\Raw_Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_96.mat');
