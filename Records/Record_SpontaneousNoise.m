%%
savedir = 'C:\Users\tony\RAnalysis_Data\Record_SpontaneousNoise';
if ~isdir(savedir)
    mkdir(savedir)
end
id = 'SN_';

%% Probe on, perfusion on, different holding potentials

% FruGal4 Non Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150509\150509_F2_C2\Sweep_Raw_150509_F2_C2_3.mat';
pAylims = [-125 150]; pA2ylims = [-10 50];
Script_SNHoldingPotentials

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150512\150512_F1_C1\Sweep_Raw_150512_F1_C1_25.mat';
pAylims = [-300 200]; pA2ylims = [-900 1400];
Script_SNHoldingPotentials

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150513\150513_F2_C1\Sweep_Raw_150513_F2_C1_2.mat';
pAylims = [-125 240]; pA2ylims = [-10 50];
Script_SNHoldingPotentials

%% Probe on, perfusion on, different holding Currents

% FruGal4 Non Spiking - No currents
% analysis_cell(1).SweepTrial = ...
%'C:\Users\tony\Raw_Data\150509\150509_F2_C2\Sweep_Raw_150509_F2_C2_4.mat';

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150512\150512_F1_C1\Sweep_Raw_150512_F1_C1_5.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150513\150513_F2_C1\Sweep_Raw_150513_F2_C1_4.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

%% Perfusion off, probe on, different holding potentials
Condition = 'Perfusion off, probe on';
tag_to_match = {'probe on'};

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150526\150526_F1_C2\Sweep_Raw_150526_F1_C2_125.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials

% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C2\Sweep_Raw_150527_F1_C2_53.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials


% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_33.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials

analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_100.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials


close all;

%% Perfusion off, probe on, different holding current
Condition = 'Perfusion off, probe on';
tag_to_match = {'probe on'};

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150526\150526_F1_C2\Sweep_Raw_150526_F1_C2_103.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents


% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C2\Sweep_Raw_150527_F1_C2_56.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents


% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_132.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_103.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents


close all;


%% Perfusion off, probe off, different holding potentials
Condition = 'Perfusion off, probe off';
tag_to_match = {'perfusion off'};

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150526\150526_F1_C2\Sweep_Raw_150526_F1_C2_3.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials

% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C2\Sweep_Raw_150527_F1_C2_9.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials


% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_60.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials

analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_54.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials


close all;


%% Perfusion off, probe off, different holding currents
Condition = 'Perfusion off, probe off';
tag_to_match = {'perfusion off'};

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150526\150526_F1_C2\Sweep_Raw_150526_F1_C2_9.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C2\Sweep_Raw_150527_F1_C2_3.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_132.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

% pJFRC7/+;R63A03-Gal4/+
% analysis_cell(1).SweepTrial = ...
% 'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_77.mat';
% mVylims = [-110 -20]; mV2ylims = [-.55 1.5]; mV2ylims = [-.55 1.5];
% Script_SNHoldingCurrents

analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_56.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

close all;


%% Perfusion on, probe off, different holding potentials
Condition = 'Perfusion on, probe off';
tag_to_match = {'perfusion on'};

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150526\150526_F1_C2\Sweep_Raw_150526_F1_C2_76.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials

% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C1\Sweep_Raw_150527_F1_C1_4.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials


% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_108.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials

% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_3.mat';
pAylims = [-230 240]; pA2ylims = [-323 600];  pA2ylims = [-20 65];
Script_SNHoldingPotentials


close all;

%% Perfusion on, probe off, different holding currents
Condition = 'Perfusion on, probe off';
tag_to_match = {'perfusion on'};

% FruGal4 Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150526\150526_F1_C2\Sweep_Raw_150526_F1_C2_97.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C1\Sweep_Raw_150527_F1_C1_6.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents


% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_125.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

% pJFRC7/+;R63A03-Gal4/+
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_4.mat';
mVylims = [-120 -20]; mV2ylims = [-3 5.5];
Script_SNHoldingCurrents

close all;


%% Antennal nerve clipped, different holding potentials

%% Antenna nerve clipped, different holding currents

%% Antenna Glued, different holding potentials
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150519\150519_F1_C1\Sweep_Raw_150519_F1_C1_3.mat';
pAylims = [-125 240]; pA2ylims = [-10 50];
Script_SNHoldingPotentials

%cnt = find(strcmp(analysis_cells,'150519_F1_C2'));
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150519\150519_F1_C2\Sweep_Raw_150519_F1_C2_13.mat';
pAylims = [-125 240]; pA2ylims = [-10 50];
Script_SNHoldingPotentials

%% Antenna Glued, different holding currents
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150519\150519_F1_C1\Sweep_Raw_150519_F1_C1_5.mat';
mVylims = [-101 -35]; mV2ylims = [-.25 .62];
Script_SNHoldingCurrents

analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150519\150519_F1_C2\Sweep_Raw_150519_F1_C2_5.mat';
mVylims = [-90 -30]; mV2ylims = [-.2 .5];
Script_SNHoldingCurrents

%% Antennal TRP channels blocked, holding potentials

%% Antennal TRP channels blocked, different holding currents

%% Antenna intact, Cs/QX314
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150507\150507_F1_C1\Sweep_Raw_150507_F1_C1_3.mat';
pAylims = [-125 150]; pA2ylims = [-10 50];
Script_SNHoldingPotentials

%% Antenna intact, Cs/QX314
% FruGal4 Non Spiking
analysis_cell(1).SweepTrial = ...
'C:\Users\tony\Raw_Data\150507\150507_F1_C1\Sweep_Raw_150507_F1_C1_20.mat';
mVylims = [-40 -33]; mV2ylims = [-0.3376    0.6318];
Script_SNHoldingCurrents
