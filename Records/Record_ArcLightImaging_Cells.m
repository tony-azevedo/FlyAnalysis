
%% Cells to Analyze
% Note 6/11/14:  I'm taking three cells out of the analysis: 140207 - due
% to motion; 140205 - likely the rogue PN in VT30609-Gal4; 140122 - same


analysis_grid = {
    '140117_F2_C1'  'UAS-ArcLight/VT30609-Gal4'   'sound responsive'        -50
    '140121_F2_C1'  'UAS-ArcLight;VT30609-Gal4'   'sound responsive'        -50 
    '140131_F3_C1'  'UAS-ArcLight;VT30609-Gal4'   'same kinds of currents'  -50
    '140206_F1_C1'  'UAS-ArcLight;VT30609-Gal4'   'same currents'           -50
    '140528_F1_C1'  'UAS-ArcLight;VT30609-Gal4'   'sound responsive'        -25
    '140530_F1_C1'  'UAS-ArcLight;VT30609-Gal4'   'A2 - sound responsive'        -25
    '140530_F2_C1'  'UAS-ArcLight;VT30609-Gal4'   'A2 - sound responsive'        -25
    '140602_F1_C1'  'UAS-ArcLight;VT30609-Gal4'   'sound responsive'        -25
    '140602_F2_C1'  'UAS-ArcLight;VT30609-Gal4'   'sound responsive'        -25
    '140603_F1_C1'  'UAS-ArcLight;VT30609-Gal4'   'sound responsive'        -25
    '150119_F1_C1'  'UAS-ArcLight;VT30609-Gal4'   'NOT SURE!!'              -50
    '150220_F1_C1'  'UAS-ArcLight;VT30609-Gal4'   'sound responsive'        -36
%     '150504_F1_C2'  'UAS-ArcLight;R45D07-Gal4'   'sound responsive'         -50
    '151123_F1_C1'  'UAS-ArcLight;R45D07-Gal4'   'sound responsive'         -47
    '151123_F1_C2'  'UAS-ArcLight;R45D07-Gal4'   'sound responsive'         -50
    '151123_F2_C1'  'UAS-ArcLight;R45D07-Gal4'   'sound responsive'         -50
}

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1};
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1};
end
fprintf('ArcLight: \n')
fprintf('\t%s\n',analysis_cells{:})

%% 
cnt = find(strcmp(analysis_cells,'140117_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140117_F2_C1';
analysis_cell(cnt).comment = {'Bright, isolated','Prepoints on Voltage Plateau too few to get good dFoverF relationship'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\tony\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_2.mat';...
    'C:\Users\tony\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
analysis_cell(cnt).breakin_trial = {...
    'C:\Users\tony\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_2.mat';...
    };
analysis_cell(cnt).plateau_trial = {...
    'C:\Users\tony\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
end
cnt = find(strcmp(analysis_cells,'140121_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140121_F2_C1';
analysis_cell(cnt).comment = {'Example Cell, sound responsive, not spiking, just great! This is the Example cell for figure'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\tony\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';...
    'C:\Users\tony\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
analysis_cell(cnt).breakin_trial = {...
    'C:\Users\tony\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';...
    };
analysis_cell(cnt).plateau_trial = {...
    'C:\Users\tony\Raw_Data\140121\140121_F2_C1\VoltagePlateau_Raw_140121_F2_C1_4.mat';...
    };

end
cnt = find(strcmp(analysis_cells,'140131_F3_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140131_F3_C1';
analysis_cell(cnt).comment = {'Moving.  Nice bright cell, not sound responsive, otherwise classic B1'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\tony\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    'C:\Users\tony\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };
analysis_cell(cnt).breakin_trial = {...
    'C:\Users\tony\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    };
analysis_cell(cnt).plateau_trial = {...
    'C:\Users\tony\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };
end


cnt = find(strcmp(analysis_cells,'140206_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140206_F1_C1';
analysis_cell(cnt).comment = {'Movement, Not sound responsive.  Good looking cell'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\tony\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    'C:\Users\tony\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_1.mat';...
    'C:\Users\tony\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    'C:\Users\tony\Raw_Data\140206\140206_F1_C1\PiezoSine_Raw_140206_F1_C1_26.mat';...
    };
analysis_cell(cnt).breakin_trial = {...
    'C:\Users\tony\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    };
analysis_cell(cnt).plateau_trial = {...
    'C:\Users\tony\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    };
end

cnt = find(strcmp(analysis_cells,'140528_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140528_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -25, pretty good cell. Changed gain in Iclamp, though this doesnt matter'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\140528\140528_F1_C1\Sweep_Raw_140528_F1_C1_1.mat';
'C:\Users\tony\Raw_Data\140528\140528_F1_C1\VoltagePlateau_Raw_140528_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\140528\140528_F1_C1\Sweep_Raw_140528_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\140528\140528_F1_C1\VoltagePlateau_Raw_140528_F1_C1_1.mat';
    };
end

cnt = find(strcmp(analysis_cells,'140530_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140530_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -25, High Frequency cell.'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\140530\140530_F1_C1\Sweep_Raw_140530_F1_C1_1.mat';
'C:\Users\tony\Raw_Data\140530\140530_F1_C1\VoltagePlateau_Raw_140530_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\140530\140530_F1_C1\Sweep_Raw_140530_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\140530\140530_F1_C1\VoltagePlateau_Raw_140530_F1_C1_1.mat';
    };
end

cnt = find(strcmp(analysis_cells,'140530_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140530_F2_C1';
analysis_cell(cnt).comment = {
'Break in at -25, High Frequency cell.'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\140530\140530_F2_C1\Sweep_Raw_140530_F2_C1_1.mat';
'C:\Users\tony\Raw_Data\140530\140530_F2_C1\VoltagePlateau_Raw_140530_F2_C1_2.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\140530\140530_F2_C1\Sweep_Raw_140530_F2_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\140530\140530_F2_C1\VoltagePlateau_Raw_140530_F2_C1_2.mat';
    };
end

cnt = find(strcmp(analysis_cells,'140602_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140602_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -25, Mid Range Spiking.'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\140602\140602_F1_C1\Sweep_Raw_140602_F1_C1_1.mat';
'C:\Users\tony\Raw_Data\140602\140602_F1_C1\VoltagePlateau_Raw_140602_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\140602\140602_F1_C1\Sweep_Raw_140602_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\140602\140602_F1_C1\VoltagePlateau_Raw_140602_F1_C1_1.mat';
    };
end

cnt = find(strcmp(analysis_cells,'140602_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140602_F2_C1';
analysis_cell(cnt).comment = {
'Break in at -25, Mid range, non spiking. Motion artifact'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\140602\140602_F2_C1\Sweep_Raw_140602_F2_C1_2.mat';
'C:\Users\tony\Raw_Data\140602\140602_F2_C1\VoltagePlateau_Raw_140602_F2_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\140602\140602_F2_C1\Sweep_Raw_140602_F2_C1_2.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\140602\140602_F2_C1\VoltagePlateau_Raw_140602_F2_C1_1.mat';
    };
end

cnt = find(strcmp(analysis_cells,'140603_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '140603_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -25, Mid range, non spiking. There is a delay in the acquisition. didnt have the exposure trace'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\140603\140603_F1_C1\Sweep_Raw_140603_F1_C1_1.mat';
'C:\Users\tony\Raw_Data\140603\140603_F1_C1\VoltagePlateau_Raw_140603_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\140603\140603_F1_C1\Sweep_Raw_140603_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\140603\140603_F1_C1\VoltagePlateau_Raw_140603_F1_C1_1.mat';
    };
end

cnt = find(strcmp(analysis_cells,'150119_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '150119_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -50, Not sure this is a B1 neuron, no sound responses, have to image the cell'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\150119\150119_F1_C1\Sweep_Raw_150119_F1_C1_1.mat';
'C:\Users\tony\Raw_Data\150119\150119_F1_C1\VoltagePlateau_Raw_150119_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\150119\150119_F1_C1\Sweep_Raw_150119_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\150119\150119_F1_C1\VoltagePlateau_Raw_150119_F1_C1_1.mat';
    };
end

cnt = find(strcmp(analysis_cells,'150220_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '150220_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -37, nonspiking band-pass low'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\150220\150220_F1_C1\Sweep_Raw_150220_F1_C1_1.mat';
'C:\Users\tony\Raw_Data\150220\150220_F1_C1\VoltagePlateau_Raw_150220_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\150220\150220_F1_C1\Sweep_Raw_150220_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\150220\150220_F1_C1\VoltagePlateau_Raw_150220_F1_C1_1.mat';
    };
end

cnt = find(strcmp(analysis_cells,'150504_F1_C2'));
if ~isempty(cnt)
analysis_cell(cnt).name = '150504_F1_C2';
analysis_cell(cnt).comment = {
'Break in at -50, low pass neuron'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\150504\150504_F1_C2\Sweep_Raw_150504_F1_C2_1.mat';
'C:\Users\tony\Raw_Data\150504\150504_F1_C2\VoltagePlateau_Raw_150504_F1_C2_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\150504\150504_F1_C2\Sweep_Raw_150504_F1_C2_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\150504\150504_F1_C2\VoltagePlateau_Raw_150504_F1_C2_1.mat';
    };
end

cnt = find(strcmp(analysis_cells,'151123_F1_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '151123_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -50, low pass neuron'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\151123\151123_F1_C1\Sweep_Raw_151123_F1_C1_7.mat';
'C:\Users\tony\Raw_Data\151123\151123_F1_C1\VoltagePlateau_Raw_151123_F1_C1_6.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\151123\151123_F1_C1\Sweep_Raw_151123_F1_C1_7.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\151123\151123_F1_C1\VoltagePlateau_Raw_151123_F1_C1_6.mat';
    };
end

cnt = find(strcmp(analysis_cells,'151123_F1_C2'));
if ~isempty(cnt)
analysis_cell(cnt).name = '151123_F1_C2';
analysis_cell(cnt).comment = {
'Break in at -50, low pass neuron'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\151123\151123_F1_C2\Sweep_Raw_151123_F1_C2_1.mat';
'C:\Users\tony\Raw_Data\151123\151123_F1_C2\VoltagePlateau_Raw_151123_F1_C2_2.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\151123\151123_F1_C2\Sweep_Raw_151123_F1_C2_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\151123\151123_F1_C2\VoltagePlateau_Raw_151123_F1_C2_2.mat';
    };
end

cnt = find(strcmp(analysis_cells,'151123_F2_C1'));
if ~isempty(cnt)
analysis_cell(cnt).name = '151123_F2_C1';
analysis_cell(cnt).comment = {
'Break in at -50, Band pass low neuron'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\tony\Raw_Data\151123\151123_F2_C1\Sweep_Raw_151123_F2_C1_1.mat';
'C:\Users\tony\Raw_Data\151123\151123_F2_C1\VoltagePlateau_Raw_151123_F2_C1_6.mat';
        };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\tony\Raw_Data\151123\151123_F2_C1\Sweep_Raw_151123_F2_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\tony\Raw_Data\151123\151123_F2_C1\VoltagePlateau_Raw_151123_F2_C1_6.mat';
    };
end

fprintf('Currently analyzing %d cells.\n\n',length(analysis_cell))
for c_ind = 1:length(analysis_cell)
    fprintf('Cell %d ID: %s\n', c_ind,analysis_cell(c_ind).name);
    fprintf('Comment: %s\n\n', analysis_cell(c_ind).comment{1});
end

backgroundCorrectionFlag =0;
if backgroundCorrectionFlag
    savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_ArcLightImaging\BackgroundCorrection';
else
    savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_ArcLightImaging\NoCorrection';
end
if ~isdir(savedir)
    mkdir(savedir)
end    




