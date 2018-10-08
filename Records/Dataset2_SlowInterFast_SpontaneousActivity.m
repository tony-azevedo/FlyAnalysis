%% Workflows for spontaneous activity and sensory feedback


Workflow_35C09_180111_F2_C1_ForceProbePatching 
Workflow_35C09_180307_F2_C1_ForceProbePatching % Decent, but the head is visible. come back to this
Workflow_35C09_180313_F1_C1_ForceProbePatching % Decent, but no EMG, no spontaneous movement
Workflow_35C09_180621_F1_C1_ForceProbePatching % Ah! No movement
Workflow_35C09_180628_F2_C1_ForceProbePatching % Brilliant! 22A08, probably

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



%% Example trials of spontaneous movement and spiking etc
% slow trials
slow_spontaneous_trials = {
    'B:\Raw_Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_8.mat' % ok, not a lot of fast movements
    'B:\Raw_Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_5.mat' % Hell yeah!
    };
showProbeImage(load('B:\Raw_Data\180628\180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_5.mat'))

% intermediate
inter_spontaneous_trials = {
    'B:\Raw_Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_14.mat'         % slowly moves it up, lets go, a little bit of catching
    'B:\Raw_Data\180223\180223_F1_C1\EpiFlash2T_Raw_180223_F1_C1_8.mat'         % slowly moves it up, lets go, a little bit of catching
    'B:\Raw_Data\180320\180320_F1_C1\EpiFlash2T_Raw_180320_F1_C1_3.mat'         % hits low, fair number of spikes, decent sized  pulls
    'B:\Raw_Data\180320\180320_F1_C1\EpiFlash2TTrain_Raw_180320_F1_C1_40.mat'   % Sweet trial with big EMG units as well
    'B:\Raw_Data\180807\180807_F1_C1\Sweep2T_Raw_180807_F1_C1_10.mat'           % hits max, fair amoutn of movements
    };

% Fast trials
fast_spontaneous_trials = {
'B:\Raw_Data\170616\170616_F1_C1\EpiFlash2T_Raw_170616_F1_C1_41.mat'
    };

%% Input resistance for different cells (going to double for force/spike)

sz = [25 7];
varNames = {'CellID','Genotype','Cell_label','R_S_L','R_pulse','Protocol','Trialnums'};
varTypes = {'string','string','string','double','double','string','double'};

% rownames = {'170921_F1_C1', '171101_F1_C1','171102_F1_C1','171102_F2_C1','171103_F1_C1', '180308_F3_C1', '180404_F1_C1','180410_F1_C1', '180703_F3_C1'}

data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;
% T = table('VariableTypes',varTypes,'VariableNames',varNames,'RowNames',rownames)

T{1,:} = {'170921_F1_C1', '81A07',            'fast', [],     [],  [],              []      };
T{2,:} = {'171101_F1_C1', '81A07',            'fast', 73E6,   [],  [],              []      };
T{3,:} = {'171102_F1_C1', '81A07',            'fast', 61e6,   [],  [],              []      };
T{4,:} = {'171102_F2_C1', '81A07',            'fast', 75e6,   [],  [],              []      };
T{5,:} = {'171103_F1_C1', '81A07',            'fast', 52e6,   [],  [],              []      };
T{6,:} = {'180308_F3_C1', '81A07',            'fast', 170E6,  [],  [],              []      };
T{7,:} = {'180404_F1_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    30:68   };
T{8,:} = {'180410_F1_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    2:121   };
T{9,:} = {'180703_F3_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    1:108   };

T{10,:} = {'180222_F1_C1', '22A08',     'intermediate', [150E6],     [],  'CurrentStep2T',   98:126   };
T{11,:} = {'180223_F1_C1', '22A08',     'intermediate', [198E6],     [],  'EpiFlash2T',   1:7   };
T{12,:} = {'180320_F1_C1', '22A08',     'intermediate', [454E6],     [],  'EpiFlash2T',   1:8   };
T{13,:} = {'180405_F3_C1', '22A08',     'intermediate', [249E6],     [],  'EpiFlash2T',   42:85   };
T{14,:} = {'180807_F1_C1', '22A08',     'intermediate', [],     [],  'EpiFlash2T',   25:258   }; % seel and leak done at the wrong voltage
T{15,:} = {'180328_F4_C1', '22A08',     'intermediate', [400E6],     [],  'EpiFlash2T',   33:100   };
T{16,:} = {'180821_F1_C1', '22A08',     'intermediate', [],     [],  'EpiFlash2T',   1:181   };
T{17,:} = {'180822_F1_C1', '22A08',     'intermediate', [153E6],     [],  'EpiFlash2T',  1:118 };


T{18,:} = {'180111_F2_C1', '22A08',     'slow', [],         [],  'CurrentStep2T',    4:45    };
T{19,:} = {'180307_F2_C1', '22A08',     'slow', [],         [],  'CurrentStep2T',   7:33     };
T{20,:} = {'180313_F1_C1', '22A08',     'slow', [1690E6],   [],  'CurrentStep2T',    1:61     };
T{21,:} = {'180621_F1_C1', '22A08',     'slow', [],         [],  'CurrentStep2T',   1:50     };
T{22,:} = {'180628_F2_C1', '22A08',     'slow', [833E6],    [],  'CurrentStep2T',   17:64 }; % seel and leak done at the wrong voltage
T{23,:} = {'180328_F1_C1', '22A08',     'slow', [],         [],  'EpiFlash2T',      67:114    };
T{24,:} = {'180329_F1_C1', '22A08',     'slow', [],         [],  'EpiFlash2T',      102:165   };% MLA. Contol 9:101
T{25,:} = {'180702_F1_C1', '22A08',     'slow', [452E6],    [],  'EpiFlash2T',      11:100   };
% T{26,:} = {'180806_F1_C1', '22A08',     'slow', [],         [],  'EpiFlash2T',      1:72  };

% T = sortrows(T,'Cell_label');

Script_estimateInputResistanceFromCurrentPulses

R_S_L = T.R_S_L;
R_pulse= T.R_pulse;
indices = ones(size(R_pulse));
for i = 1:length(R_pulse)
    if isempty(R_pulse{i})
        R_pulse{i} = R_S_L{i};
        if isempty(R_S_L{i})
            indices(i) = 0;
        end
    end
end

x_ax_pos = ones(size(R_pulse));
cl = T.Cell_label
cl0 = unique(cl)
for i = 1:length(cl0)
    x_ax_pos(strcmp(cl,cl0{i})) = i;
end

x_ax_pos = x_ax_pos(logical(indices));
R_pulse = cell2mat(R_pulse);
x_ax_pos_sig = x_ax_pos+normrnd(0,.02,size(x_ax_pos));

figure
title('R_{in} across cell cells');
plot(x_ax_pos_sig ,R_pulse,'.k');
ax = gca;
ax.XTick = unique(x_ax_pos);
ax.XTickLabel = cl0;

ax.YTick = [0 2 4 6 8 10]*1E8;
ax.YTickLabel = {'0', '0.2','0.4','0.6','0.8','1'};


%T.R_best = nanmean([cell2mat(T.R_pulse) cell2mat(T.R_S_L)],2)

%% Spontaneous spike rates for different cells

sz = [25 7];
varNames = {'CellID','Genotype','Cell_label','R_S_L','R_pulse','Protocol','Trialnums'};
varTypes = {'string','string','string','double','double','string','double'};

% rownames = {'170921_F1_C1', '171101_F1_C1','171102_F1_C1','171102_F2_C1','171103_F1_C1', '180308_F3_C1', '180404_F1_C1','180410_F1_C1', '180703_F3_C1'}

data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;
% T = table('VariableTypes',varTypes,'VariableNames',varNames,'RowNames',rownames)

T{1,:} = {'170921_F1_C1', '81A07',            'fast', [],     [],  [],              []      };
T{2,:} = {'171101_F1_C1', '81A07',            'fast', 73E6,   [],  [],              []      };
T{3,:} = {'171102_F1_C1', '81A07',            'fast', 61e6,   [],  [],              []      };
T{4,:} = {'171102_F2_C1', '81A07',            'fast', 75e6,   [],  [],              []      };
T{5,:} = {'171103_F1_C1', '81A07',            'fast', 52e6,   [],  [],              []      };
T{6,:} = {'180308_F3_C1', '81A07',            'fast', 170E6,  [],  [],              []      };
T{7,:} = {'180404_F1_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    30:68   };
T{8,:} = {'180410_F1_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    2:121   };
T{9,:} = {'180703_F3_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    1:108   };

T{10,:} = {'180222_F1_C1', '22A08',     'intermediate', [150E6],     [],  'CurrentStep2T',   98:126   };
T{11,:} = {'180223_F1_C1', '22A08',     'intermediate', [198E6],     [],  'EpiFlash2T',   1:7   };
T{12,:} = {'180320_F1_C1', '22A08',     'intermediate', [454E6],     [],  'EpiFlash2T',   1:8   };
T{13,:} = {'180405_F3_C1', '22A08',     'intermediate', [249E6],     [],  'EpiFlash2T',   42:85   };
T{14,:} = {'180807_F1_C1', '22A08',     'intermediate', [],     [],  'EpiFlash2T',   25:258   }; % seel and leak done at the wrong voltage
T{15,:} = {'180328_F4_C1', '22A08/iav-LexA',     'intermediate', [400E6],     [],  'EpiFlash2T',   33:100   };
T{16,:} = {'180821_F1_C1', '22A08/iav-LexA',     'intermediate', [],     [],  'EpiFlash2T',   1:181   };
T{17,:} = {'180822_F1_C1', '22A08/iav-LexA',     'intermediate', [153E6],     [],  'EpiFlash2T',  1:118 };


T{18,:} = {'180111_F2_C1', '35C09',     'slow', [],         [],  'CurrentStep2T',    4:45    };
T{19,:} = {'180307_F2_C1', '35C09',     'slow', [],         [],  'CurrentStep2T',   7:33     };
T{20,:} = {'180313_F1_C1', '35C09',     'slow', [1690E6],   [],  'CurrentStep2T',    1:61     };
T{21,:} = {'180621_F1_C1', '35C09',     'slow', [],         [],  'CurrentStep2T',   1:50     };
T{22,:} = {'180628_F2_C1', '35C09',     'slow', [833E6],    [],  'CurrentStep2T',   17:64 }; % seel and leak done at the wrong voltage
T{23,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow', [],         [],  'EpiFlash2T',      67:114    };
T{24,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow', [],         [],  'EpiFlash2T',      102:165   };% MLA. Contol 9:101
T{25,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', [452E6],    [],  'EpiFlash2T',      11:100   };
% T{26,:} = {'180806_F1_C1', '22A08',     'slow', [],         [],  'EpiFlash2T',      1:72  };

% T = sortrows(T,'Cell_label');

Script_estimateInputResistanceFromCurrentPulses

R_S_L = T.R_S_L;
R_pulse= T.R_pulse;
indices = ones(size(R_pulse));
for i = 1:length(R_pulse)
    if isempty(R_pulse{i})
        R_pulse{i} = R_S_L{i};
        if isempty(R_S_L{i})
            indices(i) = 0;
        end
    end
end

x_ax_pos = ones(size(R_pulse));
cl = T.Cell_label
cl0 = unique(cl)
for i = 1:length(cl0)
    x_ax_pos(strcmp(cl,cl0{i})) = i;
end

x_ax_pos = x_ax_pos(logical(indices));
R_pulse = cell2mat(R_pulse);
x_ax_pos_sig = x_ax_pos+normrnd(0,.02,size(x_ax_pos));

figure
title('R_{in} across cell cells');
plot(x_ax_pos_sig ,R_pulse,'.k');
ax = gca;
ax.XTick = unique(x_ax_pos);
ax.XTickLabel = cl0;

ax.YTick = [0 2 4 6 8 10]*1E8;
ax.YTickLabel = {'0', '0.2','0.4','0.6','0.8','1'};


%% Table of flies with spontaneous movement trials with bar and no bar:
sz = [25 7];
varNames = {'CellID','Genotype','Cell_label','Protocol','bar_trialnums','no_bar_trialnums'};
varTypes = {'string','string','string','double','double','string','double'};

% rownames = {'170921_F1_C1', '171101_F1_C1','171102_F1_C1','171102_F2_C1','171103_F1_C1', '180308_F3_C1', '180404_F1_C1','180410_F1_C1', '180703_F3_C1'}

data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;
% T = table('VariableTypes',varTypes,'VariableNames',varNames,'RowNames',rownames)

T{1,:} =    {'180111_F2_C1', '35C09',     'slow',   'EpiFlash2T',   [1:9],          [10:19]};
T{end+1,:}= {'180621_F1_C1', '35C09',     'slow',   'EpiFlash2T',   [1:23,35:46],   [24:34]};
T{end+1,:}= {'180621_F3_C1', '35C09',     'slow',   'EpiFlash2T',   [1:4],          [5:14]}; % interesting non green cell! Start with this one to get protocol working
T{end+1,:}= {'180628_F2_C1', '35C09',     'slow',   'EpiFlash2T',   [1:6],          [7:14]}; % trials 15-29 are MLA trials. Interesting, or not.

T{end+1,:}= {'180223_F1_C1',  '22A08',     'intermediate',     'EpiFlashTrain2T',   [1:14],     []};
T{end+1,:}= {'180320_F1_C1',  '22A08',     'intermediate',     'EpiFlashTrain2T',   [1:91],     []};


