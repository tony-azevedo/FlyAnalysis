% Record_VoltageClamp

%% Checklist

analysis_cells = {...
'150420_F1_C1'
'150423_F1_C2'
'150425_F1_C1' % High pass, evidence of unclamped spikes
                %'150425_F1_C2'
'150425_F1_C3'
'150425_F1_C4'
'150425_F1_C5'

'150425_F2_C1'
'150425_F2_C2'
'150425_F2_C3'

'150426_F1_C1' % Cs internal, oscillations in current and voltage, tail currents
'150426_F2_C1' % iffy
'150427_F1_C1'

'150427_F1_C3' % Cs,TTX, this one is special, started in TTX
'150421_F1_C1'
'141129_F2_C1'
};


analysis_cells_internal = {...
'QX-314, Cs'
'QX-314, Cs'
'QX-314/Cs'

'QX-314/Cs'
'QX-314/Cs'
'QX-314/Cs'

'QX-314/Cs'
'QX-314/Cs'
'QX-314/Cs'

'Cs'
'Cs'
'Cs'

'Cs/TTX'
'KAsp'
'KAsp'
};


analysis_cells_comment = {...
'QX-314, Cs, TTX afterward, 100Hz is a weird one, has ringing'
'QX-314, Cs, TTX afterward, blew up the cell, but saw large events. Probably a spiker'
'QX-314/Cs, Non-spiker, high-pass, based on low input resistance and small spikes in current clamp. unclamped spikes in voltage clamp, large depolarizations'
''
''
''
''
''
''
''
''
''
''
''
''
'KAsp'
'KAsp'
};

analysis_cells_genotype = {...
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'10XUAS-GFP;FruGal4'
'GH86;pJFRC7'
};

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c);
    analysis_cell(c).genotype = analysis_cells_genotype(c);
    analysis_cell(c).comment = analysis_cells_comment(c);
    analysis_cell(c).internal = analysis_cells_internal(c);
end
%%

cnt = find(strcmp(analysis_cells,'150420_F1_C1'));
analysis_cell(cnt).PiezoStep_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_109.mat';
analysis_cell(cnt).PiezoStep_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_217.mat';
analysis_cell(cnt).PiezoStep_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_m40 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_0 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';

%%

cnt = find(strcmp(analysis_cells,'150423_F1_C2'));
analysis_cell(cnt).SweepIClamp = 'C:\Users\Anthony Azevedo\Raw_Data\150423\150423_F1_C2\Sweep_Raw_150423_F1_C2_1.mat';
analysis_cell(cnt).SweepVClamp = 'C:\Users\Anthony Azevedo\Raw_Data\150423\150423_F1_C2\Sweep_Raw_150423_F1_C2_7.mat';

%% 150425_F1_C1

cnt = find(strcmp(analysis_cells,'150425_F1_C1'));

%analysis_cell(cnt).BreakIn = '';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\Sweep_Raw_150425_F1_C1_25.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\Sweep_Raw_150425_F1_C1_40.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\Sweep_Raw_150425_F1_C1_35.mat';
analysis_cell(cnt).SweepIClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\Sweep_Raw_150425_F1_C1_29.mat';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\Sweep_Raw_150425_F1_C1_5.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\Sweep_Raw_150425_F1_C1_18.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\Sweep_Raw_150425_F1_C1_16.mat';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\Sweep_Raw_150425_F1_C1_9.mat';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\VoltagePlateau_Raw_150425_F1_C1_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\VoltageStep_Raw_150425_F1_C1_1.mat';
analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\CurrentStep_Raw_150425_F1_C1_1.mat';
% analysis_cell(cnt).CurrentStep_m80 = '';
analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C1\CurrentChirp_Raw_150425_F1_C1_1.mat';

%% 150425_F1_C3

cnt = find(strcmp(analysis_cells,'150425_F1_C3'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_25.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_37.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_33.mat';
analysis_cell(cnt).SweepIClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_29.mat';

'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_21.mat';
analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_5.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_17.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_13.mat';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_9.mat';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\VoltagePlateau_Raw_150425_F1_C3_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\VoltageStep_Raw_150425_F1_C3_12.mat';
analysis_cell(cnt).VoltageStep_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\VoltageStep_Raw_150425_F1_C3_46.mat';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\CurrentStep_Raw_150425_F1_C3_31.mat';
analysis_cell(cnt).CurrentStep_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\CurrentStep_Raw_150425_F1_C3_1.mat';
% analysis_cell(cnt).CurrentStep_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\VoltageStep_Raw_150425_F1_C3_46.mat';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\CurrentChirp_Raw_150425_F1_C3_1.mat';

%% 150425_F1_C4

cnt = find(strcmp(analysis_cells,'150425_F1_C4'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C4\Sweep_Raw_150425_F1_C4_1.mat';

analysis_cell(cnt).SweepIClamp_rest = '';
analysis_cell(cnt).SweepIClamp_m20 = '';
analysis_cell(cnt).SweepIClamp_m60 = '';
analysis_cell(cnt).SweepIClamp_m80 = '';

'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C3\Sweep_Raw_150425_F1_C3_21.mat';
analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C4\Sweep_Raw_150425_F1_C4_2.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C4\Sweep_Raw_150425_F1_C4_14.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C4\Sweep_Raw_150425_F1_C4_10.mat';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C4\Sweep_Raw_150425_F1_C4_7.mat';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C4\VoltagePlateau_Raw_150425_F1_C4_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C4\VoltageStep_Raw_150425_F1_C4_1.mat';
analysis_cell(cnt).VoltageStep_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C4\VoltageStep_Raw_150425_F1_C4_45.mat';

analysis_cell(cnt).CurrentStep = '';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = '';

%% 150425_F1_C5

cnt = find(strcmp(analysis_cells,'150425_F1_C5'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\Sweep_Raw_150425_F1_C5_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\Sweep_Raw_150425_F1_C5_14.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\Sweep_Raw_150425_F1_C5_22.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\Sweep_Raw_150425_F1_C5_18.mat';
analysis_cell(cnt).SweepIClamp_m80 = '';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\Sweep_Raw_150425_F1_C5_2.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\Sweep_Raw_150425_F1_C5_11.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\Sweep_Raw_150425_F1_C5_6.mat';
analysis_cell(cnt).SweepVClamp_m80 = '';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\VoltagePlateau_Raw_150425_F1_C5_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\VoltageStep_Raw_150425_F1_C5_1.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\CurrentStep_Raw_150425_F1_C5_10.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F1_C5\CurrentChirp_Raw_150425_F1_C5_1.mat';

%% 150425_F2_C1

cnt = find(strcmp(analysis_cells,'150425_F2_C1'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_22.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_18.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_15.mat';
analysis_cell(cnt).SweepIClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_10.mat';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_2.mat';
analysis_cell(cnt).SweepVClamp_0 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_29.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_30.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_35.mat';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\Sweep_Raw_150425_F2_C1_38.mat';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\VoltagePlateau_Raw_150425_F2_C1_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\VoltageStep_Raw_150425_F2_C1_1.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\CurrentStep_Raw_150425_F2_C1_1.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C1\CurrentChirp_Raw_150425_F2_C1_1.mat';

%% 150425_F2_C2

cnt = find(strcmp(analysis_cells,'150425_F2_C2'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C2\Sweep_Raw_150425_F2_C2_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C2\Sweep_Raw_150425_F2_C2_7.mat';
analysis_cell(cnt).SweepIClamp_m20 = '';
analysis_cell(cnt).SweepIClamp_m60 = '';
analysis_cell(cnt).SweepIClamp_m80 = '';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C2\Sweep_Raw_150425_F2_C2_2.mat';
analysis_cell(cnt).SweepVClamp_m20 = '';
analysis_cell(cnt).SweepVClamp_m60 = '';
analysis_cell(cnt).SweepVClamp_m80 = '';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C2\VoltagePlateau_Raw_150425_F2_C2_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C2\VoltageStep_Raw_150425_F2_C2_1.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C2\CurrentStep_Raw_150425_F2_C2_1.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C2\CurrentChirp_Raw_150425_F2_C2_1.mat';

%% 150425_F2_C3

cnt = find(strcmp(analysis_cells,'150425_F2_C3'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_6.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_22.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_15.mat';
analysis_cell(cnt).SweepIClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_11.mat';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_2.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_30.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_34.mat';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\Sweep_Raw_150425_F2_C3_38.mat';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\VoltagePlateau_Raw_150425_F2_C3_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\VoltageStep_Raw_150425_F2_C3_1.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\CurrentStep_Raw_150425_F2_C3_1.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150425\150425_F2_C3\CurrentChirp_Raw_150425_F2_C3_1.mat';

%% 150426_F1_C1

cnt = find(strcmp(analysis_cells,'150426_F1_C1'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_10.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_15.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_19.mat';
analysis_cell(cnt).SweepIClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_22.mat';

% rest is -33
analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_32.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_36.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_45.mat';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_46.mat';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\VoltagePlateau_Raw_150426_F1_C1_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\VoltageStep_Raw_150426_F1_C1_1.mat';
analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\CurrentStep_Raw_150426_F1_C1_32.mat';
analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\CurrentStep_Raw_150426_F1_C1_1.mat';
analysis_cell(cnt).CurrentStep_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\CurrentStep_Raw_150426_F1_C1_32.mat';
analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\CurrentChirp_Raw_150426_F1_C1_6.mat';

%% 150426_F1_C1 TTX

cnt = find(strcmp(analysis_cells,'150426_F1_C1'));

analysis_cell(cnt).BreakIn = '';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_58.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_64.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_69.mat';
analysis_cell(cnt).SweepIClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_70.mat';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\Sweep_Raw_150426_F1_C1_56.mat';
analysis_cell(cnt).SweepVClamp_m20 = '';
analysis_cell(cnt).SweepVClamp_m60 = '';
analysis_cell(cnt).SweepVClamp_m80 = '';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\VoltagePlateau_Raw_150426_F1_C1_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\VoltageStep_Raw_150426_F1_C1_61.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\CurrentStep_Raw_150426_F1_C1_61.mat'; % with Cd: 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F1_C1\CurrentStep_Raw_150426_F1_C1_93.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = '';

%% 150426_F2_C1

cnt = find(strcmp(analysis_cells,'150426_F2_C1'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\Sweep_Raw_150426_F2_C1_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\Sweep_Raw_150426_F2_C1_6.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\Sweep_Raw_150426_F2_C1_13.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\Sweep_Raw_150426_F2_C1_16.mat';
analysis_cell(cnt).SweepIClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\Sweep_Raw_150426_F2_C1_18.mat';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\Sweep_Raw_150426_F2_C1_2.mat';
analysis_cell(cnt).SweepVClamp_m20 = '';
analysis_cell(cnt).SweepVClamp_m60 = '';
analysis_cell(cnt).SweepVClamp_m80 = '';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\VoltagePlateau_Raw_150426_F2_C1_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\VoltageStep_Raw_150426_F2_C1_1.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\CurrentStep_Raw_150426_F2_C1_1.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\CurrentStep_Raw_150426_F2_C1_31.mat';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150426\150426_F2_C1\CurrentChirp_Raw_150426_F2_C1_1.mat';

%% 150427_F1_C1

cnt = find(strcmp(analysis_cells,'150427_F1_C1'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_6.mat';
analysis_cell(cnt).SweepIClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_11.mat';
analysis_cell(cnt).SweepIClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_15.mat';
analysis_cell(cnt).SweepIClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_21.mat';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_2.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_26.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_30.mat';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_35.mat';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\VoltagePlateau_Raw_150427_F1_C1_1.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\VoltageStep_Raw_150427_F1_C1_1.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

%'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\CurrentStep_Raw_150427_F1_C1_45.mat';
%
analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\CurrentStep_Raw_150427_F1_C1_1.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\CurrentStep_Raw_150427_F1_C1_45.mat';


analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\CurrentChirp_Raw_150427_F1_C1_1.mat';

%% 150427_F1_C1 TTX

cnt = find(strcmp(analysis_cells,'150427_F1_C1'));

analysis_cell(cnt).BreakIn = '';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_52.mat';
analysis_cell(cnt).SweepIClamp_m20 = '';
analysis_cell(cnt).SweepIClamp_m60 = '';
analysis_cell(cnt).SweepIClamp_m80 = '';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_45.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_55.mat';
analysis_cell(cnt).SweepVClamp_m60 = '';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\Sweep_Raw_150427_F1_C1_60.mat';

analysis_cell(cnt).VoltagePlateau = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\VoltagePlateau_Raw_150427_F1_C1_4.mat';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\VoltageStep_Raw_150427_F1_C1_35.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\CurrentStep_Raw_150427_F1_C1_49.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C1\CurrentChirp_Raw_150427_F1_C1_15.mat';

%% 150427_F1_C3

cnt = find(strcmp(analysis_cells,'150427_F1_C3'));

analysis_cell(cnt).BreakIn = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\Sweep_Raw_150427_F1_C3_1.mat';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\Sweep_Raw_150427_F1_C3_6.mat';
analysis_cell(cnt).SweepIClamp_m20 = '';
analysis_cell(cnt).SweepIClamp_m60 = '';
analysis_cell(cnt).SweepIClamp_m80 = '';

analysis_cell(cnt).SweepVClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\Sweep_Raw_150427_F1_C3_2.mat';
analysis_cell(cnt).SweepVClamp_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\Sweep_Raw_150427_F1_C3_22.mat';
analysis_cell(cnt).SweepVClamp_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\Sweep_Raw_150427_F1_C3_18.mat';
analysis_cell(cnt).SweepVClamp_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\Sweep_Raw_150427_F1_C3_14.mat';

analysis_cell(cnt).VoltagePlateau = '';

analysis_cell(cnt).VoltageStep = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\VoltageStep_Raw_150427_F1_C3_1.mat';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\CurrentStep_Raw_150427_F1_C3_1.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150427\150427_F1_C3\CurrentChirp_Raw_150427_F1_C3_1.mat';

%% 150421_F1_C1

cnt = find(strcmp(analysis_cells,'150421_F1_C1'));

analysis_cell(cnt).BreakIn = '';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\Sweep_Raw_150421_F1_C1_2.mat';
analysis_cell(cnt).SweepIClamp_m20 = '';
analysis_cell(cnt).SweepIClamp_m60 = '';
analysis_cell(cnt).SweepIClamp_m80 = '';

analysis_cell(cnt).SweepVClamp_rest = '';
analysis_cell(cnt).SweepVClamp_m20 = '';
analysis_cell(cnt).SweepVClamp_m60 = '';
analysis_cell(cnt).SweepVClamp_m80 = '';

analysis_cell(cnt).VoltagePlateau = '';

analysis_cell(cnt).VoltageStep = '';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\CurrentStep_Raw_150421_F1_C1_1.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\CurrentChirp_Raw_150421_F1_C1_1.mat';

%% 141129_F2_C1

cnt = find(strcmp(analysis_cells,'141129_F2_C1'));

analysis_cell(cnt).BreakIn = '';

analysis_cell(cnt).SweepIClamp_rest = 'C:\Users\Anthony Azevedo\Raw_Data\141129\141129_F2_C1\Sweep_Raw_141129_F2_C1_1.mat';
analysis_cell(cnt).SweepIClamp_m20 = '';
analysis_cell(cnt).SweepIClamp_m60 = '';
analysis_cell(cnt).SweepIClamp_m80 = '';

analysis_cell(cnt).SweepVClamp_rest = '';
analysis_cell(cnt).SweepVClamp_m20 = '';
analysis_cell(cnt).SweepVClamp_m60 = '';
analysis_cell(cnt).SweepVClamp_m80 = '';

analysis_cell(cnt).VoltagePlateau = '';

analysis_cell(cnt).VoltageStep = '';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = 'C:\Users\Anthony Azevedo\Raw_Data\141129\141129_F2_C1\CurrentStep_Raw_141129_F2_C1_1.mat';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = 'C:\Users\Anthony Azevedo\Raw_Data\141129\141129_F2_C1\CurrentChirp_Raw_141129_F2_C1_1.mat';

%% 

cnt = find(strcmp(analysis_cells,''));

analysis_cell(cnt).BreakIn = '';

analysis_cell(cnt).SweepIClamp_rest = '';
analysis_cell(cnt).SweepIClamp_m20 = '';
analysis_cell(cnt).SweepIClamp_m60 = '';
analysis_cell(cnt).SweepIClamp_m80 = '';

analysis_cell(cnt).SweepVClamp_rest = '';
analysis_cell(cnt).SweepVClamp_m20 = '';
analysis_cell(cnt).SweepVClamp_m60 = '';
analysis_cell(cnt).SweepVClamp_m80 = '';

analysis_cell(cnt).VoltagePlateau = '';

analysis_cell(cnt).VoltageStep = '';
analysis_cell(cnt).VoltageStep_m80 = '';

analysis_cell(cnt).CurrentStep = '';
analysis_cell(cnt).CurrentStep_m20 = '';
% analysis_cell(cnt).CurrentStep_m80 = '';

analysis_cell(cnt).CurrentChirp = '';

%% Comparison of time course of events in voltage clamp and current clamp - 150423_F1_C2

IClamptrial = load(analysis_cell(2).SweepIClamp);
VClamptrial = load(analysis_cell(2).SweepVClamp);

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,Dir,trialStem,dfile] = ...
    extractRawIdentifiers(analysis_cell(2).SweepIClamp);

data = load(dfile); data = data.data;

Itrials = findLikeTrials('name',analysis_cell(2).SweepIClamp,'datastruct',data);
Vtrials = findLikeTrials('name',analysis_cell(2).SweepVClamp,'datastruct',data);

x = makeInTime(IClamptrial.params);
voltage = zeros(sum(x>0.06),length(Itrials));
current = zeros(sum(x>0.06),length(Vtrials));

for it_ind = 1:length(Itrials)
    IClamptrial = load([Dir sprintf(trialStem,Itrials(it_ind))]);
        
    voltage_temp = IClamptrial.voltage;
    voltage(:,it_ind) = voltage_temp(x>0.06);
end

for it_ind = 1:length(Vtrials)
    VClamptrial = load([Dir sprintf(trialStem,Vtrials(it_ind))]);
    
    current_temp = VClamptrial.current;
    current(:,it_ind) = current_temp(x>0.06);
end

x = x(x>0.06)-0.06;
f = VClamptrial.params.sampratein/length(x)*[0:length(x)/2]; f = [f, fliplr(f(2:end-1))];

fig = figure(1); clf
subplot(2,3,[1 2])
plot(x,voltage(:,1));
xlabel('s');
ylabel('mV');

subplot(2,3,[4 5])
plot(x,current(:,1));
linkaxes([subplot(2,3,[1 2]),subplot(2,3,[4 5])],'x')
xlabel('s');
ylabel('mV');

% subplot(2,3,3)
% [Py,f_pw] = pwelch(voltage-mean(voltage),VClamptrial.params.sampratein,[],[],VClamptrial.params.sampratein);
% loglog(subplot(2,3,3),f_pw,Py/diff(f(1:2)),'color',[.7 0 0]); hold on
% xlim([1 1000])
% ylim([10E-5 1])
% 
% subplot(2,3,6)
% [Py,f_pw] = pwelch(current-mean(current),VClamptrial.params.sampratein,[],[],VClamptrial.params.sampratein);
% loglog(subplot(2,3,6),f_pw,Py/diff(f(1:2)),'color',[.7 0 0]); hold on
% xlim([1 1000])
% ylim([10E-5 5])

% linkaxes([subplot(2,3,3),subplot(2,3,6)],'x')

subplot(2,3,3),hold on
x_cor_mean_volt = [];
for it_ind = 1:length(Itrials)
    [xcor, lags] = xcorr(voltage(:,it_ind)-mean(voltage(:,it_ind)));
    plot(lags/VClamptrial.params.sampratein,xcor,'color',[.8 .8 1]);
    if isempty(x_cor_mean_volt)
        x_cor_mean_volt=xcor;
    else
        x_cor_mean_volt = x_cor_mean_volt+xcor;
    end
end
x_cor_mean_volt = x_cor_mean_volt/length(Vtrials);
plot(lags/VClamptrial.params.sampratein,x_cor_mean_volt,'color',[0 0 .7]);
xlabel('s');
ylabel('mV^2');

subplot(2,3,6),hold on
x_cor_mean_curr = [];
for it_ind = 1:length(Vtrials)
    [xcor, lags] = xcorr(current(:,it_ind)-mean(current(:,it_ind)));
    plot(lags/VClamptrial.params.sampratein,xcor,'color',[.8 .8 1]);
    if isempty(x_cor_mean_curr)
        x_cor_mean_curr=xcor;
    else
        x_cor_mean_curr = x_cor_mean_curr+xcor;
    end
end
x_cor_mean_curr = x_cor_mean_curr/length(Vtrials);
plot(lags/VClamptrial.params.sampratein,x_cor_mean_curr,'color',[0 0 .7]);
xlabel('s');
ylabel('pA^2');


linkaxes([subplot(2,3,3),subplot(2,3,6)],'x')

xlim([-.04 .04])


figure(2), hold on
peak_of_interest = find(lags/VClamptrial.params.sampratein > .2 & lags/VClamptrial.params.sampratein < .3);

poi_curr = max(x_cor_mean_curr(peak_of_interest));
poi_volt = max(x_cor_mean_volt(peak_of_interest));

plot(lags/VClamptrial.params.sampratein,x_cor_mean_curr/poi_curr,'color',[0 .7 .7]);
plot(lags/VClamptrial.params.sampratein,x_cor_mean_volt/poi_volt,'color',[1 0 1]);


%% Diagnostic for each cell 

% for cnt = 3:10
cnt = find(strcmp(analysis_cells,'150426_F1_C1'));

fig = figure(3);
clf(fig);
set(fig,'color',[1 1 1],'position',[634 9 1061 988])
panl = panel(fig);

panl.pack('v',{1/5 1/5 1/5 1/5 1/5})  % response panel, stimulus panel
panl.fontname = 'Arial';
panl.fontsize = 12;
% panl(1).marginbottom = 2;
% panl(2).margintop = 8;

panl(1).pack('h',{1/2 1/2})
panl(1,1).pack('h',{1/2 1/2})
panl(1,2).pack('v',{1/2 1/2})
panl(2).pack('h',{2/3 1/3})
panl(3).pack('h',{1/2 1/4 1/4})
panl(4).pack('h',{2/3 1/3})
panl(5).pack('h',{1/2 1/4 1/4})
panl.select('all');
set(panl.de.axis,'tickdir','out')

panl.margin = [18 10 10 18];
panl.de.margin = [16 16 16 16];
panl.de.fontsize = 8;

panl(1,2,1).marginbottom = 2;
panl(1,2,2).margintop = 2;

panl.title([regexprep(analysis_cell(cnt).name,'_','\\_'),': ',analysis_cell(cnt).internal]);


% plot the input resistance curve first

p_p = .08; % Go after the prepulse

ax_trace = panl(2,1).select(); hold(ax_trace,'on');
ax_corr = panl(2,2).select(); hold(ax_corr,'on');
% ax_peak = subplot(2,2,4,'parent',fig); hold on

% rest
if ~isempty(analysis_cell(cnt).SweepVClamp_rest);
VClamptrial = load(analysis_cell(cnt).SweepVClamp_rest);
light_colr = [.8 .8 1];
dark_colr = [0 0 1] + [0 1  -1]*0/3;
Script_VoltageClamp_ISweepDiagnostics
end

% -20
if ~isempty(analysis_cell(cnt).SweepVClamp_m20);
VClamptrial = load(analysis_cell(cnt).SweepVClamp_m20); %#ok<*NASGU>
light_colr = [.8 .8 1];
dark_colr = [0 0 1] + [0 1  -1]*1/3;
Script_VoltageClamp_ISweepDiagnostics
end

% -60
if ~isempty(analysis_cell(cnt).SweepVClamp_m60);
VClamptrial = load(analysis_cell(cnt).SweepVClamp_m60);
light_colr = [.8 .8 1];
dark_colr = [0 0 1] + [0 1  -1]*2/3;
Script_VoltageClamp_ISweepDiagnostics
end

% -80
if ~isempty(analysis_cell(cnt).SweepVClamp_m80);
VClamptrial = load(analysis_cell(cnt).SweepVClamp_m80);
light_colr = [.8 .8 1];
dark_colr = [0 0 1] + [0 1  -1]*3/3;
Script_VoltageClamp_ISweepDiagnostics
end

set(ax_trace,'xlim',[2.3,2.4])

%  Current traces
ax_trace = panl(4,1).select(); hold(ax_trace,'on');
ax_corr = panl(4,2).select(); hold(ax_corr,'on');

% rest
if ~isempty(analysis_cell(cnt).SweepIClamp_rest);
IClamptrial = load(analysis_cell(cnt).SweepIClamp_rest);
light_colr = [.8 .8 1];
dark_colr = [0 0 1] + [0 1  -1]*0/3;
Script_VoltageClamp_VSweepDiagnostics
end

% -20
if ~isempty(analysis_cell(cnt).SweepIClamp_m20);
IClamptrial = load(analysis_cell(cnt).SweepIClamp_m20); %#ok<*NASGU>
light_colr = [.8 .8 1];
dark_colr = [0 0 1] + [0 1  -1]*1/3;
Script_VoltageClamp_VSweepDiagnostics
end

% -60
if ~isempty(analysis_cell(cnt).SweepIClamp_m60);
IClamptrial = load(analysis_cell(cnt).SweepIClamp_m60);
light_colr = [.8 .8 1];
dark_colr = [0 0 1] + [0 1  -1]*2/3;
Script_VoltageClamp_VSweepDiagnostics
end

% -80
if ~isempty(analysis_cell(cnt).SweepIClamp_m80);
IClamptrial = load(analysis_cell(cnt).SweepIClamp_m80);
light_colr = [.8 .8 1];
dark_colr = [0 0 1] + [0 1  -1]*3/3;
Script_VoltageClamp_VSweepDiagnostics
end

axis(ax_trace,'tight')
set(ax_trace,'xlim',[2.3,2.4])

% Voltage Steps
ax_trace = panl(3,1).select(); hold(ax_trace,'on');
ax_zooml = panl(3,2).select(); hold(ax_zooml,'on');
ax_zoomr = panl(3,3).select(); hold(ax_zoomr,'on');

if ~isempty(analysis_cell(cnt).VoltageStep);
VClamptrial = load(analysis_cell(cnt).VoltageStep); %#ok<*FNDSB>
Script_VoltageClamp_VStep
end


% Current Steps
ax_trace = panl(5,1).select(); hold(ax_trace,'on');
ax_zooml = panl(5,2).select(); hold(ax_zooml,'on');
ax_zoomr = panl(5,3).select(); hold(ax_zoomr,'on');

if ~isempty(analysis_cell(cnt).CurrentStep);
IClamptrial = load(analysis_cell(cnt).CurrentStep);
Script_VoltageClamp_IStep
end

 
% Current Chirps
ax_trace = panl(1,2,1).select(); hold(ax_trace,'on');
ax_zap = panl(1,2,2).select(); hold(ax_zooml,'on');
% fig = figure;
% ax_trace = subplot(2,1,1); hold(ax_trace,'on');
% ax_zap = subplot(2,1,2); hold(ax_zap,'on');
if ~isempty(analysis_cell(cnt).CurrentChirp);
IClamptrial = load(analysis_cell(cnt).CurrentChirp);
Script_VoltageClamp_IChirp
end

% Break-in sweep
ax_first = panl(1,1,1).select(); hold(ax_first,'on');
ax_last = panl(1,1,2).select(); hold(ax_last,'on');

if ~isempty(analysis_cell(cnt).BreakIn);
VClamptrial = load(analysis_cell(cnt).BreakIn);
Script_VoltageClamp_BreakIn
end


