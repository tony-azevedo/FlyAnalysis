%% Table of data for calculating EPSP response to ChR Activation

varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Trialnums'};%'FlashStrength','Peak','SizeOfInhibition'};

sz = [2 length(varNames)];
data = cell(sz);
T_iavChr = cell2table(data);
T_iavChr.Properties.VariableNames = varNames;

T_iavChr{1,:} = {'180404_F1_C1', '81A07/iav-LexA',            'fast', 'EpiFlash2T','empty',[13:150]};% just 0 position
T_iavChr{2,:} = {'180410_F1_C1', '81A07/iav-LexA',            'fast', 'EpiFlash2T','empty',[2:201]};% just 0 position
T_iavChr{end+1,:} = {'180703_F3_C1', '81A07/iav-LexA',            'fast', 'EpiFlash2T','empty',[1:108]};
% T_iavChr{end+1,:} = {'190228_F1_C1', '81A07/iav-LexA',            'fast', 'EpiFlash2T','empty',[1:186]};

T_iavChr{end+1,:} = {'180328_F4_C1', '22A08/iav-LexA',    'intermediate', 'EpiFlash2T','empty',[1:100]}; 
T_iavChr{end+1,:} = {'180821_F1_C1', '22A08/iav-LexA',    'intermediate', 'EpiFlash2T','empty',[1:191]}; 
T_iavChr{end+1,:} = {'180822_F1_C1', '22A08/iav-LexA',    'intermediate', 'EpiFlash2T','empty',[1:118]};
T_iavChr{end+1,:} = {'181220_F1_C1', '22A08/iav-LexA',   'intermediate', 'EpiFlash2T','empty',[1:156]};

T_iavChr{end+1,:} = {'180328_F1_C1', '35C09/iav-LexA',    'slow', 'EpiFlash2T','empty',[67:114]};
T_iavChr{end+1,:} = {'180329_F1_C1', '35C09/iav-LexA',    'slow', 'EpiFlash2T','empty',[9:101]};
T_iavChr{end+1,:} = {'180702_F1_C1', '35C09/iav-LexA',    'slow', 'EpiFlash2T','empty',[14:98]};
T_iavChr{end+1,:} = {'180806_F2_C1', '35C09/iav-LexA',    'slow', 'EpiFlash2T','empty',[1:144]};

Script_tableOfIavChRActivation

%%
Script_plotPeakTroughProbeFromIavChr

%% Script Plot interesting examplars
Script_plotIavChrExemplars

%% Choose exemplars
T_input = T_iavChrFlash(contains(T_iavChrFlash.CellID,'180702_F1_C1'),:);

% Beautiful example of hyperpolarization following strong movements!
% T_input = T_iavChrFlash(...
%                 contains(T_iavChrFlash.CellID,'180702_F1_C1') ...
%               & 0.0158 == round(T_iavChrFlash.FlashStrength*1E4)/1E4...
%               ,:);
% Does not leg go
% T_input = T_iavChrFlash(...
%                 contains(T_iavChrFlash.CellID,'180702_F1_C1') ...
%               & 0.0016 == round(T_iavChrFlash.FlashStrength*1E4)/1E4...
%               ,:);
Script_plotIaChrExampleFlashStrengths


%% Light intensity relationship 
RedLEDPowerVsExternalVoltage

%% Example trials from each type (Not complete) 

% 81A07 - one option
% maxes out
trial = load('E:\Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_63.mat');

% small activation, just pulls
trial = load('E:\Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_44.mat');

% small movements, inhibition
trial = load('E:\Data\180404\180404_F1_C1\EpiFlash2T_Raw_180404_F1_C1_36.mat');


% 81A07 - option two
% maxes out
trial = load('E:\Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_6.mat');

% inhibited initially but pulls, no letting go
trial = load('E:\Data\180410\180410_F1_C1\EpiFlash2T_Raw_180410_F1_C1_77.mat');


% 22A08 - option only 1

% low range, just pulls, lets go in one case
trial = load('E:\Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_26.mat');

% middle range, fly lets go of the bar.
trial = load('E:\Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_27.mat');

% maxes out
trial = load('E:\Data\180328\180328_F4_C1\EpiFlash2T_Raw_180328_F4_C1_24.mat');

% 35C09 - couple of options

% lets go of bar, Vm tracks bar movement perfectly, spikes are a little
% hard to detect,
trial = load('E:\Data\180328\180328_F1_C1\EpiFlash2T_Raw_180328_F1_C1_102.mat');

% 35C09 - option 2
% excited, then inhibited, pulls on bar
trial = load('E:\Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_43.mat');

% excited, inhibited, slowly releases the bar
trial = load('E:\Data\180329\180329_F1_C1\EpiFlash2T_Raw_180329_F1_C1_44.mat');

% 35C09 - option 3
% hyperpolarization, some spiking during hyperpolarization, lets go in many
% cases
trial = load('E:\Data\180702\180702_F1_C1\EpiFlash2T_Raw_180702_F1_C1_16.mat');

%% Where the analysis belongs
savedir = 'G:\My Drive\Projects\FlySensorimotor\Analysis\Dataset5_iavChr';
winopen(savedir);


