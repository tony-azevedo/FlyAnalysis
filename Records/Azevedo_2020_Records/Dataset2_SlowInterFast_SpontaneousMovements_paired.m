%% Table of flies with spontaneous movement trials 
% with bar and no bar in which spikes occur in EMG

sz = [1 5];
varNames = {'CellID','Genotype','Cell_label','Protocol','spikes_trialnums'};% ,'bar_good','no_bar_trialnums','no_bar_good'};
varTypes = {'string','string','string','string','cell'};% ,'logical','cell','logical'};

% rownames = {'170921_F1_C1', '171101_F1_C1','171102_F1_C1','171102_F2_C1','171103_F1_C1', '180308_F3_C1', '180404_F1_C1','180410_F1_C1', '180703_F3_C1'}

data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;
% T = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

% for now, ignoring fast neurons, since we don't know when proximal spikes
% occur
% fast                                                                    'bar_trialnums'   'no_bar_trialnums'
% T{1,:} =     {'190116_F1_C1', '81A07',     'fast',   'EpiFlash2TTrain', [1:17 18:47 78:92],false, [10:19 48:77], true}; % real crap! caffeine for later trials
% T{end+1,:} = {'190116_F3_C1', '81A07',     'fast',   'EpiFlash2TTrain', [16:45],false ,[1:15 46:75],true};  % control
% T{end+1,:} = {'190116_F3_C1', '81A07',     'fast',   'EpiFlash2T',      [16:30],true,[1:15] ,true};  % bar gets stuck,  caffeine 
% T{end+1,:} = {'190227_F1_C1', '81A07',     'fast',   'EpiFlash2T',      [14:28],true ,[29:38],false};      % tibia at 90 deg. Impossible to track in DLC
% T{end+1,:} = {'190227_F1_C1', '81A07',     'fast',   'EpiFlash2TTrain', []     ,false,[1:15] ,false};      % tibia at 90 deg. Impossible to track
% T{end+1,:} = {'170616_F1_C1', '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};      % tibia at 90 deg. Impossible to track
% T{end+1,:} = {'190527_F1_C1', '81A07',     'fast',   'EpiFlash2TTrain', [14:90],true ,[]     ,false};
% T{end+1,:} = {'190605_F1_C1', '81A07',     'fast',   'EpiFlash2T',      [12:91],true ,[]     ,false};
% T{end+1,:} = {'190619_F1_C1', '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};
% T{end+1,:} = {'190619_F3_C1', '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};


% intermediate
% T{end+1,:} = {'180223_F1_C1',  '22A08',     'intermediate',     'EpiFlash2T',   [1:14], true,[], false};
% Not great. The freak out/escape response is there,
% T{1,:} = {'180320_F1_C1',  '22A08',     'intermediate',     'EpiFlash2T',   [1:8]};
T{1,:} = {'180320_F1_C1',  '22A08',     'intermediate',     'EpiFlash2TTrain',   [1:58]};
T{end+1,:} = {'181118_F1_C1',  '22A08',     'intermediate',     'EpiFlash2TTrain',   [1:35]}; % tracked!
T{end+1,:} = {'181205_F1_C1',  '22A08',     'intermediate',     'EpiFlash2TTrain',   [1:45]}; % MLA flowing in during 31:45

% Slow
% T{end+1,:} =     {'180111_F2_C1', '35C09',     'slow',   'EpiFlash2T', [1:9]  ,true ,[10:19],true}; % Not tracking yet
% 1 kHz. crap spike detection % T{end+1,:} = {'180307_F2_C1', '35C09',     'slow', 'EpiFlash2T','empty',[-150 -75  0 75 150]}; 
T{end+1,:} = {'180621_F1_C1', '35C09',     'slow',   'EpiFlash2T',      [1:46]};
%T{end+1,:} = {'180621_F3_C1', '35C09',     'slow',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true}; % interesting non green cell! Start with this one to get protocol working
T{end+1,:} = {'180628_F2_C1', '35C09',     'slow',   'EpiFlash2T',      [1:14]}; % trials 15-29 are MLA trials. Interesting, or not.
% T{end+1,:} = {'181014_F1_C1', '35C09',     'slow',   'EpiFlash2TTrain', [1:10] ,true ,[11:18],true}; % tracked!
T{end+1,:} = {'181021_F1_C1', '35C09',     'slow',   'EpiFlash2TTrain', [5:12]}; 
% T{end+1,:} = {'181024_F2_C1', '35C09',     'slow',   'EpiFlash2TTrain', [1:4]}; 
T{end+1,:} = {'181127_F1_C1', '35C09',     'slow',   'EpiFlash2TTrain', [1:44]}; 
T{end+1,:} = {'181127_F2_C1', '35C09',     'slow',   'EpiFlash2TTrain', [1:26]}; % Clear, look at leg pose
% T{end+1,:} = {'181128_F1_C1', '35C09',     'slow',   'EpiFlash2T', [1:4],        []}; % Not much movement at all
% T{end+1,:} = {'181128_F2_C1', '35C09',     'slow',   'EpiFlash2TTrain', [16:20],true ,[1:10 21:25],true}; % Not much movement at all


sz = [height(T) 5];
varNames = {'CellID','Genotype','Cell_label','Protocol','spikes_trialnums'};%,'bar_good','no_bar_trialnums','no_bar_good'};
varTypes = {'string','string','string','string','cell'};%,'logical','cell','logical'};

T_SM = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
T_SM.CellID = T.CellID;
T_SM.Genotype = T.Genotype;
T_SM.Cell_label = T.Cell_label;
T_SM.Protocol = T.Protocol;
T_SM.spikes_trialnums = T.spikes_trialnums;

%% Figure 5G, Figure 5 - figsup 1C,D
Script_spikeTriggeredPairedLikelihood


