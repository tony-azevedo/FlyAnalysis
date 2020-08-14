%% Input resistance for different cells (going to double for force/spike)

varNames = {'CellID','Genotype','Cell_label','R_S_L','R_pulse','Protocol','Trialnums'};

sz = [2 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

% T{1,:} = {'170921_F1_C1', '81A07',            'fast', [],     [],  [],              []      };
T{1,:} = {'171101_F1_C1', '81A07',            'fast', 73E6,   [],  'Sweep2T',              1:8      };
% T{end+1,:} = {'171102_F1_C1', '81A07',            'fast', 61e6,   [],  [],              []      };
T{2,:} = {'171102_F2_C1', '81A07',            'fast', 75e6,   [],  [],              []      };
T{end+1,:} = {'171103_F1_C1', '81A07',            'fast', 52e6,   [],  [],              []      };
T{end+1,:} = {'180308_F3_C1', '81A07',            'fast', 170E6,  [],  [],              []      };
% T{end+1,:} = {'180404_F1_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    30:68   };
% T{end+1,:} = {'180410_F1_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    2:121   };
% T{end+1,:} = {'180703_F3_C1', '81A07/iav-LexA',   'fast', [],     [],  'EpiFlash2T',    1:108   };
T{end+1,:} = {'190116_F1_C1', '81A07',        'fast', 63E6,   [],  'Sweep2T',       1:10    };
T{end+1,:} = {'190116_F3_C1', '81A07',        'fast', 86E6,   [],  'EpiFlash2T',       1:30    };
T{end+1,:} = {'190227_F1_C1', '81A07',        'fast', [],    [],  'CurrentStep2T',       1:47    };
% T{end+1,:} = {'190228_F1_C1', '81A07/iav-LexA','fast', [],    [],  'CurrentStep2T',          1:8 };
T{end+1,:} = {'190527_F1_C1', '81A07',        'fast', 73E6,    [],  'CurrentStep2T',       1:10    };
T{end+1,:} = {'190605_F1_C1', '81A07',        'fast', 66E6,    [],  'CurrentStep2T',       1:20    };
T{end+1,:} = {'190619_F1_C1', '81A07',        'fast', [],    [],  'EpiFlash2T',       1:9    };
T{end+1,:} = {'190619_F3_C1', '81A07',        'fast', 68E6,    [],  'EpiFlash2T',       1:11    };


T{end+1,:} = {'180222_F1_C1', '22A08',     'intermediate', [150E6],     [],  'CurrentStep2T',   98:126   };
T{end+1,:} = {'180223_F1_C1', '22A08',     'intermediate', [198E6],     [],  'EpiFlash2T',   1:7   };
T{end+1,:} = {'180320_F1_C1', '22A08',     'intermediate', [454E6],     [],  'EpiFlash2T',   1:8   };
T{end+1,:} = {'180405_F3_C1', '22A08',     'intermediate', [249E6],     [],  'EpiFlash2T',   42:85   };
T{end+1,:} = {'180807_F1_C1', '22A08/ChR',     'intermediate', [],     [],  'EpiFlash2T',   25:258   }; % seel and leak done at the wrong voltage
% T{end+1,:} = {'180328_F4_C1', '22A08/iav-LexA',     'intermediate', [400E6],     [],  'EpiFlash2T',   33:100   };
% T{end+1,:} = {'180821_F1_C1', '22A08/iav-LexA',     'intermediate', [],     [],  'EpiFlash2T',   1:181   };
% T{end+1,:} = {'180822_F1_C1', '22A08/iav-LexA',     'intermediate', [153E6],     [],  'EpiFlash2T',  1:118 };
T{end+1,:} = {'181118_F1_C1', '22A08',  'intermediate', [],     [],  'Sweep2T',  1:25 };
T{end+1,:} = {'181205_F1_C1', '22A08',  'intermediate', [],     [],  'CurrentStep2T',  1:72 };
% T{end+1,:} = {'181220_F1_C1', '22A08/iav-LexA',   'intermediate', [],     [],  'EpiFlash2T',  36:83};

T{end+1,:} = {'180111_F2_C1', '35C09',     'slow', [],         [],  'CurrentStep2T',    4:45    };
% T{end+1,:} = {'180307_F2_C1', '35C09',     'slow', [],         [],  'CurrentStep2T',   7:33     };
T{end+1,:} = {'180313_F1_C1', '35C09',     'slow', [1690E6],   [],  'CurrentStep2T',    1:61     };
T{end+1,:} = {'180621_F1_C1', '35C09',     'slow', [],         [],  'CurrentStep2T',   1:50     };
% T{end+1,:} = {'180621_F3_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150]};
T{end+1,:} = {'180628_F2_C1', '35C09',     'slow', [833E6],    [],  'CurrentStep2T',   17:64 }; % seel and leak done at the wrong voltage
% T{end+1,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow', [],         [],  'EpiFlash2T',      67:114    };
% T{end+1,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow', [],         [],  'EpiFlash2T',      102:165   };% MLA. Contol 9:101
% T{end+1,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', [452E6],    [],  'EpiFlash2T',      11:100   };
% T{end+1,:} = {'180806_F1_C1', '22A08',     'slow', [],         [],  'EpiFlash2T',      1:72  };
T{end+1,:} = {'181014_F1_C1', '35C09',     'slow', [1258E6],         [],  'CurrentStep2T',   1:66     };
T{end+1,:} = {'181021_F1_C1', '35C09',     'slow', [349E6],         [],  'CurrentStep2T',   1:60     };
T{end+1,:} = {'181024_F2_C1', '35C09',    'slow', [992E6],         [],  'CurrentStep2T',   1:60     };
T{end+1,:} = {'181127_F1_C1', '35C09',     'slow', [478E6],         [],  'CurrentStep2T',   1:35     };
T{end+1,:} = {'181127_F2_C1', '35C09',     'slow', [224E6],         [],  'CurrentStep2T',   1:35     };
T{end+1,:} = {'181128_F1_C1', '35C09',     'slow', [257e6],         [],  'CurrentStep2T',   1:55     };
T{end+1,:} = {'181128_F2_C1', '35C09',     'slow', [420E6],         [],  'CurrentStep2T',   1:50     };

%wtidx = ~contains(T_RampAndStep_nodrugs.Genotype,'iav-LexA');

%% Figure 3E - Input Resistance

% Script_estimateInputResistanceFromCurrentPulses_saveData

figure
plot(Pulses.voltage(1,:))

%%

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
x_ax_pos_sig = x_ax_pos+normrnd(0,.1,size(x_ax_pos));

figure
title('R_{in} across cell cells');
plot(x_ax_pos_sig ,R_pulse,'.k');
ax = gca;
ax.XTick = unique(x_ax_pos);
ax.XTickLabel = cl0;
ax.NextPlot = 'add';
ylabel(ax,'R (G\Omega)');

ax.YTick = [0 2 4 6 8 10]*1E8;
ax.YTickLabel = {'0', '0.2','0.4','0.6','0.8','1'};

for l = 1:length(cl0)
    rs = R_pulse(x_ax_pos==l);
    errorbar(ax,l-.4,nanmedian(rs),nanstd(rs,1)/sqrt(sum(~isnan(rs))),'marker','.');
end

% Compare
figure
[~,~,stats] = anovan(R_pulse,x_ax_pos);
results = multcompare(stats);

%T.R_best = nanmean([cell2mat(T.R_pulse) cell2mat(T.R_S_L)],2)

%% Figure 
Script_showVmForEachType


%% Spontaneous spike rates for different cells

% Go back over to the Ramp dataset, use the peizo Steps to do this.

%% Other interesting notes
% 35C09 spikes without bar are a bit lower and slower. Compare here:

% Before I put the bar in
trial = load('F:\Acquisition\181021\181021_F1_C1\Sweep_Raw_181021_F1_C1_1.mat');

% vs.

% After
trial = load('F:\Acquisition\181021\181021_F1_C1\CurrentStep2T_Raw_181021_F1_C1_1.mat');

