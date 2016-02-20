%% pJFRC7;VT27938-Gal4
cnt = find(strcmp(analysis_cells,'151007_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F1_C1\VoltageCommand_Raw_151007_F1_C1_4.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F1_C1\Sweep_Raw_151007_F1_C1_5.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

cnt = find(strcmp(analysis_cells,'151007_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F3_C1\VoltageCommand_Raw_151007_F3_C1_1.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\Anthony Azevedo\Raw_Data\151007\151007_F3_C1\Sweep_Raw_151007_F3_C1_3.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end

cnt = find(strcmp(analysis_cells,'151009_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151009\151009_F1_C1\VoltageCommand_Raw_151009_F1_C1_1.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\Anthony Azevedo\Raw_Data\151009\151009_F1_C1\Sweep_Raw_151009_F1_C1_6.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP TEA' 'TTX' 'ZD'};
end


cnt = find(strcmp(analysis_cells,'151022_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151022\151022_F2_C1\VoltageCommand_Raw_151022_F2_C1_1.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\Anthony Azevedo\Raw_Data\151022\151022_F2_C1\Sweep_Raw_151022_F2_C1_4.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA' 'Cd'};
end

cnt = find(strcmp(analysis_cells,'151029_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151029\151029_F3_C1\VoltageCommand_Raw_151029_F3_C1_3.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\Anthony Azevedo\Raw_Data\151029\151029_F3_C1\Sweep_Raw_151029_F3_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end


cnt = find(strcmp(analysis_cells,'151118_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151118\151118_F1_C1\VoltageCommand_Raw_151118_F1_C1_1.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\Anthony Azevedo\Raw_Data\151118\151118_F1_C1\Sweep_Raw_151118_F1_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end

cnt = find(strcmp(analysis_cells,'151121_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\Anthony Azevedo\Raw_Data\151121\151121_F3_C1\VoltageCommand_Raw_151121_F3_C1_4.mat';
    analysis_cell(cnt).trials.Sweep = ...
'C:\Users\Anthony Azevedo\Raw_Data\151121\151121_F3_C1\Sweep_Raw_151121_F3_C1_4.mat';

    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end



%% VT para: 

% Crazy outlier, big responses, outlier
cnt = find(strcmp(analysis_cells,'151017_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\PiezoSine_Raw_151017_F2_C1_32.mat';
analysis_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\PiezoStep_Raw_151017_F2_C1_1.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\PiezoSine_Raw_151017_F2_C1_252.mat';
analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\VoltageStep_Raw_151017_F2_C1_1.mat';
analysis_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\VoltageCommand_Raw_151017_F2_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\CurrentChirp_Raw_151017_F2_C1_1.mat';
    analysis_cell(cnt).drugs = {''};
end

% typical relationship, large, very nice responses, access fine
cnt = find(strcmp(analysis_cells,'151102_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\PiezoSine_Raw_151102_F1_C1_7.mat';
analysis_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\PiezoStep_Raw_151102_F1_C1_2.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\PiezoSine_Raw_151102_F1_C1_264.mat';
analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\VoltageStep_Raw_151102_F1_C1_1.mat';
analysis_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\VoltageCommand_Raw_151102_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\CurrentChirp_Raw_151102_F1_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA'};
end

% typical relationship but largest 
cnt = find(strcmp(analysis_cells,'151102_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\PiezoSine_Raw_151102_F2_C1_7.mat';
analysis_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\PiezoStep_Raw_151102_F2_C1_1.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\PiezoSine_Raw_151102_F2_C1_268.mat';
analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\VoltageStep_Raw_151102_F2_C1_1.mat';
analysis_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\VoltageCommand_Raw_151102_F2_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\CurrentChirp_Raw_151102_F2_C1_1.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA'};
end

% smaller, more low pass
cnt = find(strcmp(analysis_cells,'151104_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\PiezoSine_Raw_151104_F1_C2_7.mat';
analysis_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\PiezoStep_Raw_151104_F1_C2_7.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\PiezoSine_Raw_151104_F1_C2_268.mat';
analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\VoltageStep_Raw_151104_F1_C2_1.mat';
analysis_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\VoltageCommand_Raw_151104_F1_C2_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\CurrentChirp_Raw_151104_F1_C2_1.mat';
    analysis_cell(cnt).drugs = {''};
end

% also good looking, access is very stable
cnt = find(strcmp(analysis_cells,'151108_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\PiezoSine_Raw_151108_F2_C1_7.mat';
analysis_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\PiezoStep_Raw_151108_F2_C1_2.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\PiezoSine_Raw_151108_F2_C1_280.mat';
analysis_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\VoltageCommand_Raw_151108_F2_C1_1.mat';
analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\VoltageStep_Raw_151108_F2_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
    analysis_cell(cnt).drugs = {''};
end

% smaller, more low pass
cnt = find(strcmp(analysis_cells,'151109_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C1\PiezoSine_Raw_151109_F1_C1_7.mat';
analysis_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C1\PiezoStep_Raw_151109_F1_C1_2.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C1\PiezoSine_Raw_151109_F1_C1_268.mat';
analysis_cell(cnt).VoltageCommandTrial = ...
'';
analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C1\VoltageStep_Raw_151109_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
end

% smaller, more low pass, antiphase
cnt = find(strcmp(analysis_cells,'151109_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C2\PiezoSine_Raw_151109_F1_C2_7.mat';
analysis_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C2\PiezoStep_Raw_151109_F1_C2_1.mat';
analysis_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C2\PiezoSine_Raw_151109_F1_C2_282.mat';
analysis_cell(cnt).VoltageCommandTrial = ...
'';
analysis_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C2\VoltageStep_Raw_151109_F1_C2_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
    analysis_cell(cnt).drugs = {''};
end