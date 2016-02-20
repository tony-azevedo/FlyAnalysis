%% %%%%%%% Sham Cells %%%%%%%%%%

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150923_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150923\150923_F1_C1\VoltageCommand_Raw_150923_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'aBTX' '4AP' 'TEA' 'TTX' 'ZD' };
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151005_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151005\151005_F1_C1\VoltageCommand_Raw_151005_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151005_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151005\151005_F2_C1\VoltageCommand_Raw_151005_F2_C1_25.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151006_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151006\151006_F3_C1\VoltageCommand_Raw_151006_F3_C1_11.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151006_F3_C2'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151006\151006_F3_C2\VoltageCommand_Raw_151006_F3_C2_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% %%%%%%%% Interesting cells %%%%%%%%%%%%%%

%% Na activation caused this cell to have some hysteresis 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151117_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
'C:\Users\Anthony Azevedo\Raw_Data\151117\151117_F1_C1\VoltageCommand_Raw_151117_F1_C1_2.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\Anthony Azevedo\Raw_Data\151117\151117_F1_C1\Sweep_Raw_151117_F1_C1_4.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end
