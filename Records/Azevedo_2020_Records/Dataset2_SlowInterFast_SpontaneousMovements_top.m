%% Table of flies with spontaneous movement trials with bar and no bar:
sz = [1 8];
varNames = {'CellID','Genotype','Cell_label','Protocol','bar_trialnums','bar_good','no_bar_trialnums','no_bar_good'};
varTypes = {'string','string','string','string','cell','logical','cell','logical'};

% rownames = {'170921_F1_C1', '171101_F1_C1','171102_F1_C1','171102_F2_C1','171103_F1_C1', '180308_F3_C1', '180404_F1_C1','180410_F1_C1', '180703_F3_C1'}

data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;
% T = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

% fast                                                                    'bar_trialnums'   'no_bar_trialnums'
T{1,:} =     {'190116_F1_C1', '81A07',     'fast',   'EpiFlash2TTrain', [1:17 18:47 78:92],false, [10:19 48:77], true}; % real crap! caffeine for later trials
T{end+1,:} = {'190116_F3_C1', '81A07',     'fast',   'EpiFlash2TTrain', [16:45],false ,[1:15 46:75],true};  % control
T{end+1,:} = {'190116_F3_C1', '81A07',     'fast',   'EpiFlash2T',      [16:30],true,[1:15] ,true};  % bar gets stuck,  caffeine 
T{end+1,:} = {'190227_F1_C1', '81A07',     'fast',   'EpiFlash2T',      [14:28],true ,[29:38],false};      % tibia at 90 deg. Impossible to track in DLC
T{end+1,:} = {'190227_F1_C1', '81A07',     'fast',   'EpiFlash2TTrain', []     ,false,[1:15] ,false};      % tibia at 90 deg. Impossible to track
T{end+1,:} = {'170616_F1_C1', '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};      % tibia at 90 deg. Impossible to track
T{end+1,:} = {'190527_F1_C1', '81A07',     'fast',   'EpiFlash2TTrain', [14:90],true ,[]     ,false};
T{end+1,:} = {'190605_F1_C1', '81A07',     'fast',   'EpiFlash2T',      [12:91],true ,[]     ,false};
T{end+1,:} = {'190619_F1_C1', '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};
T{end+1,:} = {'190619_F3_C1', '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};

% intermediate
T{end+1,:} = {'180223_F1_C1',  '22A08',     'intermediate',     'EpiFlash2T',   [1:14], true,[], false};
T{end+1,:} = {'180320_F1_C1',  '22A08',     'intermediate',     'EpiFlash2T',   [1:8], false,[], false};
T{end+1,:} = {'180320_F1_C1',  '22A08',     'intermediate',     'EpiFlash2TTrain',   [1:53], true,[], false};
T{end+1,:} = {'181118_F1_C1',  '22A08',     'intermediate',     'EpiFlash2TTrain',   [21:35], true,[1:20], true}; % tracked!
T{end+1,:} = {'181205_F1_C1',  '22A08',     'intermediate',     'EpiFlash2TTrain',   [16:30 31:45], true, [1:15],true}; % MLA flowing in during 31:45

% Slow
T{end+1,:} =     {'180111_F2_C1', '35C09',     'slow',   'EpiFlash2T', [1:9]  ,true ,[10:19],true}; % Not tracking yet % 1 kHz. crap spike detection % T{end+1,:} = {'180307_F2_C1', '35C09',     'slow', 'EpiFlash2T','empty',[-150 -75  0 75 150]}; 
T{end+1,:} = {'180621_F1_C1', '35C09',     'slow',   'EpiFlash2T',      [1:22,35:46],true ,[23:34],true};
T{end+1,:} = {'180628_F2_C1', '35C09',     'slow',   'EpiFlash2T',      [1:6]  ,true ,[7:14] ,true}; % trials 15-29 are MLA trials. Interesting, or not.
T{end+1,:} = {'181014_F1_C1', '35C09',     'slow',   'EpiFlash2TTrain', [1:10] ,true ,[11:18],true}; % tracked!
T{end+1,:} = {'181021_F1_C1', '35C09',     'slow',   'EpiFlash2TTrain', [5:12] ,true ,[]     ,true}; 
T{end+1,:} = {'181024_F2_C1', '35C09',     'slow',   'EpiFlash2TTrain', [1:4]  ,true ,[]     ,true}; 
T{end+1,:} = {'181127_F1_C1', '35C09',     'slow',   'EpiFlash2TTrain',      [15:24],true ,[25:44],true}; 
T{end+1,:} = {'181127_F2_C1', '35C09',     'slow',   'EpiFlash2TTrain',      [17:26],true ,[1:16] ,true}; % Clear, look at leg pose
% T{end+1,:} = {'181128_F1_C1', '35C09',     'slow',   'EpiFlash2T', [1:4],        []}; % Not much movement at all
T{end+1,:} = {'181128_F2_C1', '35C09',     'slow',   'EpiFlash2TTrain', [16:20],true ,[1:10 21:25],true}; % Not much movement at all
% How much is the probe actually moving?
% T{end+1,:} = {'190818_F1_C1', '35C09',     'slow',   'EpiFlash2T', [],false ,[],false}; % Not much movement at all
T{end+1,:} = {'190819_F2_C1', '35C09',     'slow',   'EpiFlash2T', [],false ,[],false}; % Not much movement at all

% Others!
T{end+1,:} = {'180621_F3_C1', '35C09',     'other',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true}; % interesting non green cell! Start with this one to get protocol working
T{end+1,:} = {'190811_F1_C1', '81A04',     'big bright - LTM',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true}; 
T{end+1,:} = {'190812_F1_C1', '81A04',     'small bright - reductor',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true};
T{end+1,:} = {'190813_F1_C1', '81A04',     'big dim - tarsus extensor',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true}; 
T{end+1,:} = {'190815_F1_C1', '81A04',     'small bright - reductor nice fill',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true}; 

ofinterest = {
    '190527_F1_C1'
    %'190605_F1_C1'
    
    '181118_F1_C1' % 
    % '181205_F1_C1' possible
    
    '180628_F2_C1' % 1,2,3, 4, 5!, and then 7 or 9 for free movement
    % '181014_F1_C1' % Not great
    % '181021_F1_C1' % meh
    % '181127_F1_C1' % great movements but spikes are not convincing,
    % didn't even include the final peizo ramp data
    };
paired = {
    '190116_F3_C1'; % pretty good! threshold the spikes?
    %   '190227_F1_C1'; % fast neuron only on the emg
    '190527_F1_C1'; % Fast, need to threshold spikes. Try detecting other EMG spikes
    '190605_F1_C1' % Strong EMG. This is not the logic I want though
    % I would avoid using the fast whole cell recordings. Better would be
    % to find spikes in the intermediate neuron recordings and then ask
    % what the intermediate neuron is doing when the fast goes off.
    
    % '180223_F1_C1'; % Not great. The freak out/escape response is there,
    % but no clear fast neuron spikes
    '180320_F1_C1'; % Yes!
    '181118_F1_C1'; 
    '181205_F1_C1'
    
    '180628_F2_C1' % 1,2,3, 4, 5!, and then 7 or 9 for free movement
    % '181014_F1_C1' % Not great
    % '181021_F1_C1' % meh
    % '181127_F1_C1' % great movements but spikes are not convincing,
    % didn't even include the final peizo ramp data
    };


sz = [height(T) 8];
varNames = {'CellID','Genotype','Cell_label','Protocol','bar_trialnums','bar_good','no_bar_trialnums','no_bar_good'};
varTypes = {'string','string','string','string','cell','logical','cell','logical'};

T_SM = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
T_SM.CellID = T.CellID;
T_SM.Genotype = T.Genotype;
T_SM.Cell_label = T.Cell_label;
T_SM.Protocol = T.Protocol;
T_SM.bar_trialnums = T.bar_trialnums;
T_SM.no_bar_trialnums = T.no_bar_trialnums;

for r = 1:height(T)
    T_SM.bar_good(r) = T.bar_good{r};
    T_SM.no_bar_good(r) = T.no_bar_good{r};
end    

%% Calculate Correlations of membrane potential with leg angle
Script_plotCorrelationsWithVm

%% Plot spike triggered phase plot
Script_spikeTriggeredPhasePlot

%% Plot some trials for the figure
Script_plotExampleTrials
Script_plotTrajectoriesInPhaseSpace

%% Example trials of spontaneous movement and spiking etc
% slow trials
slow_spontaneous_trials = {
    'B:\Raw_Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_8.mat' % ok, not a lot of fast movements
    'B:\Raw_Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_5.mat' % Hell yeah!
    };
% showProbeImage(load('B:\Raw_Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_5.mat'))

% intermediate
inter_spontaneous_trials = {
    'B:\Raw_Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_14.mat'         % slowly moves it up, lets go, a little bit of catching
    'B:\Raw_Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_8.mat'         % slowly moves it up, lets go, a little bit of catching
    'B:\Raw_Data\180320\180320_F1_C1\EpiFlash2T_Raw_180320_F1_C1_3.mat'         % hits low, fair number of spikes, decent sized  pulls
    };

% Fast trials
fast_spontaneous_trials = {
    'B:\Raw_Data\170616\170616_F1_C1\EpiFlash2T_Raw_170616_F1_C1_41.mat'
    };


%% Other interesting notes
% 35C09 spikes without bar are a bit lower and slower. Compare here:

% Before I put the bar in
trial = load('F:\Acquisition\181021\181021_F1_C1\Sweep_Raw_181021_F1_C1_1.mat');

% vs.

% After
trial = load('F:\Acquisition\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_1.mat');

%% Workflows for spontaneous activity and sensory feedback


Workflow_35C09_180111_F2_C1_ForceProbePatching 
Workflow_35C09_180307_F2_C1_ForceProbePatching % Decent, but the head is visible. come back to this
Workflow_35C09_180313_F1_C1_ForceProbePatching % Decent, but no EMG, no spontaneous movement
Workflow_35C09_180621_F1_C1_ForceProbePatching % Ah! No movement
Workflow_35C09_180628_F2_C1_ForceProbePatching % Brilliant! 22A08 in emg, probably

% Workflow_iavChR_35C09_180328_F1_C1_ForceProbePatching % Still need to analyse a low intensity stim epiFlash set that was focused on the probe, will need to create a new probe tracking routine
% Workflow_iavChR_35C09_180329_F1_C1_ForceProbePatching % This is an amazing cell! Alas, no EMG
% Workflow_iavChR_35C09_180702_F1_C1_ForceProbePatching % Need current steps
% Workflow_iavChR_35C09_180806_F1_C1_ForceProbePatching % need current steps
% 

%% Intermediate workflows
Workflow_22A08_180222_F1_C1_ForceProbePatching % 
Workflow_22A08_180223_F1_C1_ForceProbePatching
Workflow_22A08_180320_F1_C1_ForceProbePatching
Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching
Workflow_22A08_180807_F1_C1_ChRStimulation_ForceProbePatching

% Workflow_iavChR_22A08_180328_F4_C1_ForceProbePatching
% Workflow_iavChR_22A08_180821_F1_C1_ForceProbePatching
% Workflow_iavChR_22A08_180822_F1_C1_ForceProbePatching


%% Fast work flows

% 81A07 - with ChR
% 170616_F1_C1
% 170608_F1_C1 % old style of files, not good
% 170414_F1_C1
% 180216_F1_C2
Workflow_81A07_170921_F1_C1_ForceProbePatching % no spontaneous activity
Workflow_81A07_171101_F1_C1_ForceProbePatching %
Workflow_81A07_171102_F1_C1_ForceProbePatching
Workflow_81A07_171102_F2_C1_ForceProbePatching
Workflow_81A07_171103_F1_C1_ForceProbePatching
Workflow_81A07_180308_F3_C1_ForceProbePatching

% Workflow_iavChR_81A07_180404_F1_C1_ForceProbePatching
% Workflow_iavChR_81A07_180410_F1_C1_ForceProbePatching
% Workflow_iavChR_81A07_180703_F3_C1_ForceProbePatching

