%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150722_F1_C2'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\150722\150722_F1_C2\VoltageCommand_Raw_150722_F1_C2_1.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\150722\150722_F1_C2\Sweep_Raw_150722_F1_C2_3.mat';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP' 'TEA' 'Cd'};
end

cnt = find(strcmp(analysis_cells,'150922_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\150922\150922_F2_C1\VoltageCommand_Raw_150922_F2_C1_1.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\150922\150922_F2_C1\Sweep_Raw_150922_F2_C1_5.mat';
    analysis_cell(cnt).trials.VoltageSine = ...
'C:\Users\tony\Raw_Data\150922\150922_F2_C1\VoltageSine_Raw_150922_F2_C1_2.mat';
    analysis_cell(cnt).drugs = {'' 'MLA' '4AP' 'TEA' 'TTX' 'ZD' };
end

cnt = find(strcmp(analysis_cells,'151001_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151001\151001_F1_C1\VoltageCommand_Raw_151001_F1_C1_1.mat';
    analysis_cell(cnt).trials.VoltageSine = ...
'C:\Users\tony\Raw_Data\151001\151001_F1_C1\VoltageSine_Raw_151001_F1_C1_98.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\151001\151001_F1_C1\Sweep_Raw_151001_F1_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

cnt = find(strcmp(analysis_cells,'151001_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151001\151001_F2_C1\VoltageCommand_Raw_151001_F2_C1_1.mat';
    analysis_cell(cnt).trials.VoltageSine = ...
'C:\Users\tony\Raw_Data\151001\151001_F2_C1\VoltageSine_Raw_151001_F2_C1_98.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\151001\151001_F2_C1\Sweep_Raw_151001_F2_C1_3.mat';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

cnt = find(strcmp(analysis_cells,'151021_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151021\151021_F3_C1\VoltageCommand_Raw_151021_F3_C1_1.mat';
    analysis_cell(cnt).trials.VoltageSine = ...
'C:\Users\tony\Raw_Data\151021\151021_F3_C1\VoltageSine_Raw_151021_F3_C1_2.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\151021\151021_F3_C1\Sweep_Raw_151021_F3_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP TEA'};
end

cnt = find(strcmp(analysis_cells,'151022_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151022\151022_F1_C1\VoltageCommand_Raw_151022_F1_C1_1.mat';
    analysis_cell(cnt).trials.VoltageSine = ...
'C:\Users\tony\Raw_Data\151022\151022_F1_C1\VoltageSine_Raw_151022_F1_C1_98.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\151022\151022_F1_C1\Sweep_Raw_151022_F1_C1_3.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA' 'Cd'};
end



cnt = find(strcmp(analysis_cells,'151210_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
'C:\Users\tony\Raw_Data\151210\151210_F1_C1\VoltageCommand_Raw_151210_F1_C1_1.mat';
    analysis_cell(cnt).trials.VoltageSine = ...
'C:\Users\tony\Raw_Data\151210\151210_F1_C1\VoltageSine_Raw_151210_F1_C1_98.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\151210\151210_F1_C1\Sweep_Raw_151210_F1_C1_2.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA' 'IBTX'};
end

cnt = find(strcmp(analysis_cells,'151210_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
'C:\Users\tony\Raw_Data\151210\151210_F2_C1\VoltageCommand_Raw_151210_F2_C1_1.mat';
    analysis_cell(cnt).trials.VoltageSine = ...
'C:\Users\tony\Raw_Data\151210\151210_F2_C1\VoltageSine_Raw_151210_F2_C1_98.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\151210\151210_F2_C1\Sweep_Raw_151210_F2_C1_2.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA' 'IBTX'};
end

cnt = find(strcmp(analysis_cells,'151210_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
'C:\Users\tony\Raw_Data\151210\151210_F3_C1\VoltageCommand_Raw_151210_F3_C1_1.mat';
    analysis_cell(cnt).trials.VoltageSine = ...
'C:\Users\tony\Raw_Data\151210\151210_F3_C1\VoltageSine_Raw_151210_F3_C1_98.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\tony\Raw_Data\151210\151210_F3_C1\Sweep_Raw_151210_F3_C1_2.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' 'IBTX' '4AP' 'TEA' };
end

%% Fru para

cnt = find(strcmp(analysis_cells,'150912_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151015\151015_F3_C1\VoltageCommand_Raw_151015_F3_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'MLA' '4AP TEA' 'TTX' 'ZD'};
end
cnt = find(strcmp(analysis_cells,'151015_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151015\151015_F3_C1\VoltageCommand_Raw_151015_F3_C1_1.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end

cnt = find(strcmp(analysis_cells,'151027_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151027\151027_F2_C1\VoltageCommand_Raw_151027_F2_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA'};
end

cnt = find(strcmp(analysis_cells,'151027_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151027\151027_F3_C1\VoltageCommand_Raw_151027_F3_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA'};
end

cnt = find(strcmp(analysis_cells,'151028_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151028\151028_F2_C1\VoltageCommand_Raw_151028_F2_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA'};
end


% No voltage sines '151016_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (dim cell body), CsAsp TEA internal'
% No voltage sines '151017_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'still some Na currents remaining, band pass, identical to the others'
% No voltage sines '151110_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (higher capacitance), CsAsp TEA internal'
% No voltage sines '151110_F1_C2'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (higher capacitance), CsAsp TEA internal'





