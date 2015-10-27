
%% 'pJFRC7/+;63A03-Gal4/+'

% cnt = find(strcmp(analysis_cells,'150617_F2_C1'));
% analysis_cell(cnt).trials.VoltageCommand = ...
% 'C:\Users\Anthony Azevedo\Raw_Data\150617\150617_F2_C1\VoltageCommand_Raw_150617_F2_C1_1.mat';

%% '10XUAS-mCD8:GFP/+;FruGal4/+'

cnt = find(strcmp(analysis_cells,'150704_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150704\150704_F1_C1\VoltageCommand_Raw_150704_F1_C1_119.mat';
    
    analysis_cell(cnt).stem = 'SineResponse_BPL_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' '4AP' 'Cs' 'ttx'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+

cnt = find(strcmp(analysis_cells,'150706_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150706\150706_F1_C1\VoltageCommand_Raw_150706_F1_C1_1.mat';
    
    analysis_cell(cnt).stem = 'SineResponse_BPL_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP' 'Cs' 'Cd'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150709_F1_C2'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150709\150709_F1_C2\VoltageCommand_Raw_150709_F1_C2_80.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPL_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP' 'TEA' 'Cs'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150715_F0_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150715\150715_F0_C1\VoltageCommand_Raw_150715_F0_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {''};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150718_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150718\150718_F1_C1\VoltageCommand_Raw_150718_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP' 'TEA' 'Cs'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150720_F1_C2'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150720\150720_F1_C2\VoltageCommand_Raw_150720_F1_C2_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP' 'TEA' 'Cs'};
end

%% BPL: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150721_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150721\150721_F2_C1\VoltageCommand_Raw_150721_F2_C1_24.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPL_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP' 'TEA' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150722_F1_C2'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150722\150722_F1_C2\VoltageCommand_Raw_150722_F1_C2_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPL_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP' 'TEA' 'Cd'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150723_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150723\150723_F1_C1\VoltageCommand_Raw_150723_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPL_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'Cs' 'TTX' '4AP' 'TEA' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150727_F0_C0'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150727\150727_F0_C0\VoltageCommand_Raw_150727_F0_C0_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'High'};
end

%% BPL: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150730_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150730\150730_F3_C1\VoltageCommand_Raw_150730_F3_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'Ca' 'TTX' 'TEA' '4AP'};
end

%% BPL: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150826_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150826\150826_F1_C1\VoltageCommand_Raw_150826_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'Ca' 'Cd' 'TTX' 'TEA' '4AP'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150826_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150826\150826_F1_C1\VoltageCommand_Raw_150826_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'Ca' 'Cd' 'TTX' 'TEA' '4AP'};
end


%% 15 - BPL: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150827_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150827\150827_F2_C1\VoltageCommand_Raw_150827_F2_C1_11.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'Ca' 'Cd' 'TTX' 'TEA' '4AP'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150902_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150902\150902_F1_C1\VoltageCommand_Raw_150902_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX 1uM TEA 10 mM 4AP 5 mM' 'MLA 200 nM'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150903_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150903\150903_F1_C1\VoltageCommand_Raw_150903_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX 1uM 4AP 5mM TEA 10 mM ZD 50 uM' };
end

%% BPH: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150903_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150903\150903_F2_C1\VoltageCommand_Raw_150903_F2_C1_10.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' 'TEA' '4AP'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150903_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150903\150903_F3_C1\VoltageCommand_Raw_150903_F3_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX 4AP TEA' 'CTX 20 nM' 'ZD 50 uM' 'Cd 200 uM' 'CTX 100 nM'};
end

%% 'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'
cnt = find(strcmp(analysis_cells,'150911_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150911\150911_F1_C1\VoltageCommand_Raw_150911_F1_C1_9.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP TEA ZD Cd'};
end

%% 'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'
cnt = find(strcmp(analysis_cells,'150912_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150912\150912_F1_C1\VoltageCommand_Raw_150912_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'MLA' 'TTX'};
end

%% 'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'
cnt = find(strcmp(analysis_cells,'150912_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150912\150912_F2_C1\VoltageCommand_Raw_150912_F2_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'MLA' 'TTX' '4AP' 'TEA' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150913_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150913\150913_F2_C1\VoltageCommand_Raw_150913_F2_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'MLA' 'TTX' '4AP' 'TEA' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150922_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150922\150922_F2_C1\VoltageCommand_Raw_150922_F2_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'MLA' '4AP' 'TEA' 'TTX' 'ZD' };
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150923_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150923\150923_F1_C1\VoltageCommand_Raw_150923_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'aBTX' '4AP' 'TEA' 'TTX' 'ZD' };
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150926_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150926\150926_F1_C1\VoltageCommand_Raw_150926_F1_C1_3.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'compensation' };
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151001_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151001\151001_F1_C1\VoltageCommand_Raw_151001_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151001_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151001\151001_F2_C1\VoltageCommand_Raw_151001_F2_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151002_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151002\151002_F2_C1\VoltageCommand_Raw_151002_F2_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
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

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151007_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F1_C1\VoltageCommand_Raw_151007_F1_C1_4.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151007_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F3_C1\VoltageCommand_Raw_151007_F3_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151007_F4_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F4_C1\VoltageCommand_Raw_151007_F4_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end

%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151009_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151009\151009_F1_C1\VoltageCommand_Raw_151009_F1_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end

%% 'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'
cnt = find(strcmp(analysis_cells,'151015_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151015\151015_F3_C1\VoltageCommand_Raw_151015_F3_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end


%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150928_F0_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\150928\150928_F0_C1\VoltageCommand_Raw_150928_F0_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'Rs Comp' 'WC Comp' 'RS off'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151021_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151021\151021_F1_C1\VoltageCommand_Raw_151021_F1_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151021_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151021\151021_F3_C1\VoltageCommand_Raw_151021_F3_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP TEA'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151022_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151022\151022_F1_C1\VoltageCommand_Raw_151022_F1_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA' 'Cd'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151022_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151022\151022_F2_C1\VoltageCommand_Raw_151022_F2_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA' 'Cd'};
end


