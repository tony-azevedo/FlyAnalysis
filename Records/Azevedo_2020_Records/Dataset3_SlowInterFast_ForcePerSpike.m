%% Table of force production experiments, Fast and Inter

varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Trialnums'};

sz = [1 length(varNames)];
data = cell(sz);
T_fastinter = cell2table(data);
T_fastinter.Properties.VariableNames = varNames;

T_fastinter{1,:} = {    '170921_F1_C1', '81A07',    'fast', 'EpiFlash2T','empty',[0                 ],  [22:151]};% just 0 position
T_fastinter{end+1,:} = {'171101_F1_C1', '81A07',    'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [16:330]};
T_fastinter{end+1,:} = {'171102_F1_C1', '81A07',    'fast', 'EpiFlash2T','empty',[ 0 100 200],          [7:121]};
T_fastinter{end+1,:} = {'171102_F2_C1', '81A07',    'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [47:173]}; 
T_fastinter{end+1,:} = {'171103_F1_C1', '81A07',    'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [72:223]}; 
T_fastinter{end+1,:} = {'180308_F3_C1', '81A07',    'fast', 'EpiFlash2T','empty',[-150 -75 0 75 150],   [ 4:262]};
% Just an incredible cell. Perfect twitches
T_fastinter{end+1,:} = {'190123_F3_C1', '81A07',    'fast', 'EpiFlash2T','empty',[-150 -75 0 75 150],   [ 1:287]};

% T(8)
% relatively few trials 
T_fastinter{end+1,:} = {'180222_F1_C1', '22A08',    'intermediate', 'CurrentStep2T','empty',[0], [98:126]};
T_fastinter{end+1,:} = {'180405_F3_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [42:125]};
T_fastinter{end+1,:} = {'180807_F1_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [25:258]};
% K-Boing cell, fits nicely for 2 spikes, not for 3
T_fastinter{end+1,:} = {'181219_F1_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [17:66,100:159]};
T_fastinter{end+1,:} = {'190110_F2_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [13:166]};
T_fastinter{end+1,:} = {'190710_F1_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [23:203]};
T_fastinter{end+1,:} = {'190712_F1_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [8:247]};
%T(12)

rewrite_yn = 'yes';

% Script_tableOfForcePerSpike
% head(T_FperSpike_0)
% head(T_FperSpike_mla)

% save('E:\Results\Dataset3_SIF_T_FperSpike_0','T_FperSpike_0')
% save('E:\Results\Dataset3_SIF_T_FperSpike_mla','T_FperSpike_mla')
T_FperSpike_0 = load('E:\Results\Dataset3_SIF_T_FperSpike_0'); T_FperSpike_0 = T_FperSpike_0.T_FperSpike_0;
T_FperSpike_mla = load('E:\Results\Dataset3_SIF_T_FperSpike_mla'); T_FperSpike_mla = T_FperSpike_mla.T_FperSpike_mla;
head(T_FperSpike_0)
head(T_FperSpike_mla)


%% Table of force production in slow neurons

varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Trialnums'};

sz = [1 length(varNames)];
data = cell(sz);
T_slow = cell2table(data);
T_slow.Properties.VariableNames = varNames;

T_slow{1,:} = {    '180111_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[5:42]}; % [5:54] some are too long
% T{2,:} = {'180307_F2_C1', '35C09',     'slow', 'CurrentStep2T','empty',[-150 -75  0 75 120], [],[24:73]}; % spikes are small
% T{2,:} = {'180313_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[12:61],[],[],[],0,0}; % questionable
T_slow{end+1,:} = {'180621_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[1:50]};
T_slow{end+1,:} = {'180628_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[17:58]}; % MLA [59:64]
T_slow{end+1,:} = {'181014_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[12:66]}; % MLA [67:171]
T_slow{end+1,:} = {'181021_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[6:60 ]}; % 
T_slow{end+1,:} = {'181024_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[6:60 ]}; % MLA [61:110]
% some twitching in this one in probe trace, not great, eg Trial 14
% T{end+1,:} = {'181127_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:35 ],[]}; % 
T_slow{end+1,:} = {'181127_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[1:35 ]}; % MLA [36:70 ]
T_slow{end+1,:} = {'181128_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[1:55 ]}; % MLA [56:105]
T_slow{end+1,:} = {'181128_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0],[1:50 ]}; % MLA [101:155]
% T{end+1,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow',  'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:50],[],[],[],[],[]};
% T{end+1,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow',  'CurrentStep2T','empty',[0                 ], [],[34:75],[],[],[],[],[]};
% T{end+1,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', 'CurrentStep2T','empty',[0                  ], [],[14:55],[],[],[],[],[]};

Script_tableOfForcePerNSpikes
head(T_FperNSpikes_0)
head(T_FperNSpikes_mla)
head(T_FvsFiringRate_0)
head(T_FvsFiringRate_mla)

% save('E:\Results\Dataset3_SIF_T_FperNSpikes_0','T_FperNSpikes_0')
% save('E:\Results\Dataset3_SIF_T_FperNSpikes_mla','T_FperNSpikes_mla')
% save('E:\Results\Dataset3_SIF_T_FvsFiringRate_0','T_FvsFiringRate_0')
% save('E:\Results\Dataset3_SIF_T_FvsFiringRate_mla','T_FvsFiringRate_mla')
% T_FperSpike_0 = load('E:\Results\Dataset3_SIF_T_FperNSpikes_0'); T_FperNSpikes_0 = T_FperNSpikes_0.T_FperNSpikes_0;
% T_FperSpike_mla = load('E:\Results\Dataset3_SIF_T_FperNSpikes_mla'); T_FperNSpikes_mla = T_FperNSpikes_mla.T_FperNSpikes_mla;
% T_FperSpike_0 = load('E:\Results\Dataset3_SIF_T_FvsFiringRate_0'); T_FvsFiringRate_0 = T_FvsFiringRate_0.T_FvsFiringRate_0;
% T_FperSpike_mla = load('E:\Results\Dataset3_SIF_T_FvsFiringRate_mla'); T_FvsFiringRate_mla = T_FvsFiringRate_mla.T_FvsFiringRate_mla;
% head(T_FperNSpikes_0)
% head(T_FperNSpikes_mla)
% head(T_FvsFiringRate_0)
% head(T_FvsFiringRate_mla)
% 

%% Figure 4D,F - Create force per spike plot
Script_forcePerSpike

%% Plot firing rate analysis for slow neurons
Script_forceVsFiringRate

%% Compare control and MLA
Script_forceVsFiringRate_controlVsMLA

%% Figure 4D - Slope of slow firing rate
Script_forcePerSpikeAndFiringRate

%% Figure 4A - Average twitches and emgs, calculate cv and estimate force production onset
Script_alignSingleSpikes
Script_alignDoubleSpikes
Script_align0Spikes

%% Example trials of motor neuron activity, emg, and bar

% ----- Fast -----
clear trials;
trial = load('E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_37.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Inter
clear trials;
trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_68.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Slow random -----
clear trials;
trial = load('E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_174.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Slow -----
clear trials;
trial = load('E:\Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_89.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('E:\Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_91.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamplesOfSlowMN_Spikes_EMG_Probe

%% For the example cells, show aligned spikes and forces

% ---- Fast -----
trial = load('E:\Data\190123\190123_F3_C1\EpiFlash2T_Raw_190123_F3_C1_78.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 1:175; 
Script_alignSingleAndDoubleSpikesExamples

% ---- Inter -----
trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 25:204; % Low
Script_alignSingleAndDoubleSpikesExamples

%% For the example cell 181014_F1_C1, spike with and without MLA

% ---- Fast -----
trial = load('E:\Data\190123\190123_F3_C1\EpiFlash2T_Raw_190123_F3_C1_78.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 1:175; 
Script_alignSingleAndDoubleSpikes

% ---- Inter -----
trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 25:204; % Low
Script_alignSingleAndDoubleSpikes





