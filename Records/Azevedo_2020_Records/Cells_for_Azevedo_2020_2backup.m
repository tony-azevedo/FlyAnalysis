%% Steps for data back up

% 1) Copy folders pertaining to Paper to Shared_Data, but no videos
% 2) Copy that entire folder to Data in my folder
% 3) Make sure every file is copied to Data. This will take a long time, has to upload
% 4) Delete any data that is not in the data set from my hard drive

%% Dataset 1 - Calcium imaging - copy to shared data
% cells = {
%     % '181209_F2_C1'
%     '181210_F1_C1'
%     '190424_F1_C1'
%     '190424_F2_C1'
%     '190424_F3_C1'
%     '171107_F2_C1'
%     '171109_F1_C1'
%     };
% 
% for c_idx = 1:length(cells)
%     cll = cells{c_idx};
%     clldir = cll(1:6);
%     files = dir(fullfile('E:\Data',clldir,cll));
%     mkdir(fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_1',clldir,cll))
%     for f_idx = 1:length(files)
%         if ~files(f_idx).isdir
%             % copy non-movies
%             if ~contains(files(f_idx).name,'.avi')
%                 copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_1',clldir,cll));
%             end
%         elseif strcmp(files(f_idx).name,'clusters')
%             copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_1',clldir,cll));
%         end
%     end
% end

%% Dataset 1 - Calcium imaging - copy to online data
% cells = {
%     '181209_F2_C1'
%     '181210_F1_C1'
%     '190424_F1_C1'
%     '190424_F2_C1'
%     '190424_F3_C1'
%     '171107_F1_C2'
%     '171109_F1_C1'
%     };
% 
% for c_idx = 5:length(cells)
%     cll = cells{c_idx};
%     clldir = cll(1:6);
%     copyfile(fullfile('E:\Data',clldir,cll),fullfile('G:\My Drive\Data',clldir,cll));
% end

%% Dataset 2 - Whole cell recordings
% cells = {
%     '171101_F1_C1'%, '81A07/ChR',            'fast', 'PiezoRamp2T','empty',0}; 
%     '171102_F2_C1'%, '81A07/ChR',            'fast', 'PiezoRamp2T','empty',0}; 
%         '171103_F1_C1'%, '81A07/ChR',            'fast', 'PiezoRamp2T','empty',0};
%         '180308_F3_C1'%, '81A07/ChR',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180404_F1_C1'%, '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180410_F1_C1'%, '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180703_F3_C1'%, '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '190116_F1_C1'%, '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '190116_F3_C1'%, '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]}; %'190123_F3_C1' is only in MLA to confirm that it was working. that's why it's not here
%         '190227_F1_C1'%, '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150]}; 
%         '190228_F1_C1'%, '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',0};
%         '190527_F1_C1'%, '81A07',            'fast', 'PiezoRamp2T','empty',0};
%         '190605_F1_C1'%, '81A07',            'fast', 'PiezoRamp2T','empty',0}; 
%         '190619_F1_C1'%, '81A07',            'fast', 'PiezoRamp2T','empty',0}; 
%         '190619_F3_C1'%, '81A07',            'fast', 'PiezoRamp2T','empty',0}; 
% 
%         '180222_F1_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180223_F1_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
%         '180320_F1_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180328_F4_C1'%, '22A08/iav-LexA',   'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180405_F3_C1'%, '22A08/ChR',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180807_F1_C1'%, '22A08/ChR',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180821_F1_C1'%, '22A08/iav-LexA',   'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180822_F1_C1'%, '22A08/iav-LexA',   'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181118_F1_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181205_F1_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181220_F1_C1'%, '22A08/iav-LexA',   'intermediate', 'PiezoRamp2T','empty',0};
%         '190827_F1_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
%         '190903_F1_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
%         '190905_F2_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
%         '190908_F1_C1'%, '22A08',            'intermediate', 'PiezoRamp2T','empty',0};
% 
%         '180111_F2_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180328_F1_C1'%, '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180329_F1_C1'%, '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180621_F1_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180628_F2_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '180702_F1_C1'%, '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',0};
%         '180806_F2_C1'%, '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',0};
%         '181014_F1_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181021_F1_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181024_F2_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181127_F1_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181127_F2_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181128_F1_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
%         '181128_F2_C1'%, '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
% };

% for c_idx = 1:length(cells)
%     cll = cells{c_idx};
%     clldir = cll(1:6);
%     files = dir(fullfile('E:\Data',clldir,cll));
%     mkdir(fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2',clldir,cll))
%     for f_idx = 1:length(files)
%         if ~files(f_idx).isdir
%             % copy non-movies
%             if ~contains(files(f_idx).name,'.avi')
%                 copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2',clldir,cll));
%             end
%         elseif strcmp(files(f_idx).name,'clusters')
%             copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2',clldir,cll));
%         end
%     end
% end

%% Copy Dataset_2 to Data
% for c_idx = 15:length(cells)
%     cll = cells{c_idx};
%     clldir = cll(1:6);
%     files = dir(fullfile('E:\Data',clldir,cll));
%     mkdir(fullfile('G:\My Drive\Data',clldir,cll))
%     for f_idx = 1:length(files)
%         if ~files(f_idx).isdir
%             copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Data',clldir,cll));
%         end
%     end
% end
% 
%% Dataset_2 - Tables
% copyfile(fullfile('E:\Results\Dataset2_SIF_T_Ramp.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2'));
% copyfile(fullfile('E:\Results\Dataset2_SIF_T_Step.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2'));
% copyfile(fullfile('E:\Results\Dataset2_SIF_T_RmpStpSlowFR.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2'));
% copyfile(fullfile('E:\Results\Dataset2_SIF_T_StpSlowFR.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2'));
% 
% copyfile(fullfile('E:\Results\Dataset2_SIF_T_Ramp.mat'),fullfile('G:\My Drive\Data\Results'));
% copyfile(fullfile('E:\Results\Dataset2_SIF_T_Step.mat'),fullfile('G:\My Drive\Data\Results'));
% copyfile(fullfile('E:\Results\Dataset2_SIF_T_RmpStpSlowFR.mat'),fullfile('G:\My Drive\Data\Results'));
% copyfile(fullfile('E:\Results\Dataset2_SIF_T_StpSlowFR.mat'),fullfile('G:\My Drive\Data\Results'));

%% Dataset_3 - force per spike
cells = {
  '170921_F1_C1'%, '81A07',    'fast', 'EpiFlash2T','empty',[0                 ],  [22:151]};% just 0 position
  '171101_F1_C1'%, '81A07',    'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [16:330]};
  '171102_F1_C1'%, '81A07',    'fast', 'EpiFlash2T','empty',[ 0 100 200],          [7:121]};
  '171102_F2_C1'%, '81A07',    'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [47:173]};
  '171103_F1_C1'%, '81A07',    'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [72:223]};
  '180308_F3_C1'%, '81A07',    'fast', 'EpiFlash2T','empty',[-150 -75 0 75 150],   [ 4:262]};
  % Just an incredible c%ell. Perfect twitches
  '190123_F3_C1'%, '81A07',    'fast', 'EpiFlash2T','empty',[-150 -75 0 75 150],   [ 1:287]};
  
  % T(8)
  % relatively few trials
  '180222_F1_C1'%, '22A08',    'intermediate', 'CurrentStep2T','empty',[0], [98:126]};
  '180405_F3_C1'%, '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [42:125]};
  '180807_F1_C1'%, '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [25:258]};
  % K-Boing cell, fits nicely for 2 spikes, not for 3
  '181219_F1_C1'%, '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [17:66,100:159]};
  '190110_F2_C1'%, '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [13:166]};
  '190710_F1_C1'%, '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [23:203]};
  '190712_F1_C1'%, '22A08',    'intermediate', 'EpiFlash2T','empty',[0   ], [8:247]};
  
  '180111_F2_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[5:42]}; % [5:54] some are too long
  '180307_F2_C1'%, '35C09',     'slow', 'CurrentStep2T','empty',[-150 -75  0 75 120], [],[24:73]}; % spikes are small
  '180313_F1_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[12:61],[],[],[],0,0}; % questionable
  '180621_F1_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[1:50]};
  '180628_F2_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[17:58]}; % MLA [59:64]
  '181014_F1_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[12:66]}; % MLA [67:171]
  '181021_F1_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[6:60 ]}; %
  '181024_F2_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[6:60 ]}; % MLA [61:110]
  % some twitching in this one in probe trace, not great, eg Trial 14
  '181127_F1_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:35 ],[]}; %
  '181127_F2_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[1:35 ]}; % MLA [36:70 ]
  '181128_F1_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[1:55 ]}; % MLA [56:105]
  '181128_F2_C1'%, '35C09',  'slow',     'CurrentStep2T','empty',[0],[1:50 ]}; % MLA [101:155]
  '180328_F1_C1'%, '35C09/iav-LexA',     'slow',  'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:50],[],[],[],[],[]};
  '180329_F1_C1'%, '35C09/iav-LexA',     'slow',  'CurrentStep2T','empty',[0                 ], [],[34:75],[],[],[],[],[]};
  '180702_F1_C1'%, '35C09/iav-LexA',     'slow', 'CurrentStep2T','empty',[0                  ], [],[14:55],[],[],[],[],[]};
  };

for c_idx = 1:length(cells)
    cll = cells{c_idx};
    clldir = cll(1:6);
    files = dir(fullfile('E:\Data',clldir,cll));
    mkdir(fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3',clldir,cll))
    for f_idx = 1:length(files)
        if ~files(f_idx).isdir
            % copy non-movies
            if ~contains(files(f_idx).name,'.avi')
                copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3',clldir,cll));
            end
        elseif strcmp(files(f_idx).name,'clusters')
            copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3',clldir,cll));
        end
    end
end

%% Copy Dataset_3 to Data
% for c_idx = 1:length(cells)
%     cll = cells{c_idx};
%     clldir = cll(1:6);
%     files = dir(fullfile('E:\Data',clldir,cll));
%     mkdir(fullfile('G:\My Drive\Data',clldir,cll))
%     for f_idx = 1:length(files)
%         if ~files(f_idx).isdir
%             copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Data',clldir,cll));
%         end
%     end
% end

%% Dataset_3 - Tables
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FperSpike_0.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FperSpike_mla.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FperNSpikes_0.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FperNSpikes_mla.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FvsFiringRate_0.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FvsFiringRate_mla.mat'),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_3'));
% 
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FperSpike_0.mat'),fullfile('G:\My Drive\Data\Results'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FperSpike_mla.mat'),fullfile('G:\My Drive\Data\Results'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FperNSpikes_0.mat'),fullfile('G:\My Drive\Data\Results'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FperNSpikes_mla.mat'),fullfile('G:\My Drive\Data\Results'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FvsFiringRate_0.mat'),fullfile('G:\My Drive\Data\Results'));
% copyfile(fullfile('E:\Results\Dataset3_SIF_T_FvsFiringRate_mla.mat'),fullfile('G:\My Drive\Data\Results'));


%% fast                                                                    'bar_trialnums'   'no_bar_trialnums'
cells = {
    '190116_F1_C1'%, '81A07',     'fast',   'EpiFlash2TTrain', [1:17 18:47 78:92],false, [10:19 48:77], true}; % real crap! caffeine for later trials
    '190116_F3_C1'%, '81A07',     'fast',   'EpiFlash2TTrain', [16:45],false ,[1:15 46:75],true};  % control
    '190116_F3_C1'%, '81A07',     'fast',   'EpiFlash2T',      [16:30],true,[1:15] ,true};  % bar gets stuck,  caffeine
    '190227_F1_C1'%, '81A07',     'fast',   'EpiFlash2T',      [14:28],true ,[29:38],false};      % tibia at 90 deg. Impossible to track in DLC
    '190227_F1_C1'%, '81A07',     'fast',   'EpiFlash2TTrain', []     ,false,[1:15] ,false};      % tibia at 90 deg. Impossible to track
    '170616_F1_C1'%, '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};      % tibia at 90 deg. Impossible to track
    '190527_F1_C1'%, '81A07',     'fast',   'EpiFlash2TTrain', [14:90],true ,[]     ,false};
    '190605_F1_C1'%, '81A07',     'fast',   'EpiFlash2T',      [12:91],true ,[]     ,false};
    '190619_F1_C1'%, '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};
    '190619_F3_C1'%, '81A07',     'fast',   'EpiFlash2T',      [9:88] ,false,[]     ,false};
    
    % intermediate
    '180223_F1_C1'%,  '22A08',     'intermediate',     'EpiFlash2T',   [1:14], true,[], false};
    '180320_F1_C1'%,  '22A08',     'intermediate',     'EpiFlash2T',   [1:8], false,[], false};
    '180320_F1_C1'%,  '22A08',     'intermediate',     'EpiFlash2TTrain',   [1:53], true,[], false};
    '181118_F1_C1'%,  '22A08',     'intermediate',     'EpiFlash2TTrain',   [21:35], true,[1:20], true}; % tracked!
    '181205_F1_C1'%,  '22A08',     'intermediate',     'EpiFlash2TTrain',   [16:30 31:45], true, [1:15],true}; % MLA flowing in during 31:45
    
    % Slow
    '180111_F2_C1'%, '35C09',     'slow',   'EpiFlash2T', [1:9]  ,true ,[10:19],true}; % Not tracking yet % 1 kHz. crap spike detection
    '180307_F2_C1'%, '35C09',     'slow', 'EpiFlash2T','empty',[-150 -75  0 75 150]};
    '180621_F1_C1'%, '35C09',     'slow',   'EpiFlash2T',      [1:22,35:46],true ,[23:34],true};
    '180628_F2_C1'%, '35C09',     'slow',   'EpiFlash2T',      [1:6]  ,true ,[7:14] ,true}; % trials 15-29 are MLA trials. Interesting, or not.
    '181014_F1_C1'%, '35C09',     'slow',   'EpiFlash2TTrain', [1:10] ,true ,[11:18],true}; % tracked!
    '181021_F1_C1'%, '35C09',     'slow',   'EpiFlash2TTrain', [5:12] ,true ,[]     ,true};
    '181024_F2_C1'%, '35C09',     'slow',   'EpiFlash2TTrain', [1:4]  ,true ,[]     ,true};
    '181127_F1_C1'%, '35C09',     'slow',   'EpiFlash2TTrain',      [15:24],true ,[25:44],true};
    '181127_F2_C1'%, '35C09',     'slow',   'EpiFlash2TTrain',      [17:26],true ,[1:16] ,true}; % Clear, look at leg pose
    '181128_F1_C1'%, '35C09',     'slow',   'EpiFlash2T', [1:4],        []}; % Not much movement at all
    '181128_F2_C1'%, '35C09',     'slow',   'EpiFlash2TTrain', [16:20],true ,[1:10 21:25],true}; % Not much movement at all
    % How much is the probe actually moving?
    '190818_F1_C1'%, '35C09',     'slow',   'EpiFlash2T', [],false ,[],false}; % Not much movement at all
    '190819_F2_C1'%, '35C09',     'slow',   'EpiFlash2T', [],false ,[],false}; % Not much movement at all
    
    % Others!
    '180621_F3_C1'%, '35C09',     'other',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true}; % interesting non green cell! Start with this one to get protocol working
    '190811_F1_C1'%, '81A04',     'big bright - LTM',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true};
    '190812_F1_C1'%, '81A04',     'small bright - reductor',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true};
    '190813_F1_C1'%, '81A04',     'big dim - tarsus extensor',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true};
    '190815_F1_C1'%, '81A04',     'small bright - reductor nice fill',   'EpiFlash2T',      [1:4]  ,true ,[5:14] ,true};
    };

for c_idx = 1:length(cells)
    cll = cells{c_idx};
    clldir = cll(1:6);
    if ~exist(fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2',clldir,cll),'dir')
        files = dir(fullfile('E:\Data',clldir,cll));
        mkdir(fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2',clldir,cll))
        for f_idx = 1:length(files)
            if ~files(f_idx).isdir
                % copy non-movies
                if ~contains(files(f_idx).name,'.avi')
                    copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2',clldir,cll));
                end
            elseif strcmp(files(f_idx).name,'clusters')
                copyfile(fullfile('E:\Data',clldir,cll,files(f_idx).name),fullfile('G:\My Drive\Tuthill Lab Shared\shared_data\2020_Azevedo','Dataset_2',clldir,cll));
            end
        end
    end
end

%% Bar movies
cd E:\Data\171019\Run3

