% Slow Workflows

% Slow
Workflow_35C09_180111_F1_C1_ForceProbePatching
Workflow_35C09_180307_F2_C1_ForceProbePatching
Workflow_35C09_180313_F1_C1_ForceProbePatching
Workflow_35C09_180621_F1_C1_ForceProbePatching
Workflow_35C09_180628_F2_C1_ForceProbePatching


%% Intermediate workflows
Workflow_22A08_180222_F1_C1_ForceProbePatching % clear movement of the bar with single spikes, very nice!
Workflow_22A08_180223_F1_C1_ForceProbePatching
Workflow_22A08_180320_F1_C1_ForceProbePatching
Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching
Workflow_22A08_180807_F1_C1_ChRStimulation_ForceProbePatching


%% Fast work flows

% 81A07 - with ChR
Workflow_81A07_171101_F1_C1_ForceProbePatching
Workflow_81A07_171102_F1_C1_ForceProbePatching
Workflow_81A07_171102_F2_C1_ForceProbePatching
Workflow_81A07_171103_F1_C1_ForceProbePatching
Workflow_81A07_180308_F3_C1_ForceProbePatching


%% Others

% Slow
% 81A06
Workflow_81A06_171025_F1_C1_ForceProbePatching % 171025_F1_C1

% Workflow_81A06_171107_F1_C2_ForceProbePatching % not much leg movement
Workflow_81A06_171116_F1_C1_ForceProbePatching % Good cell, current injection nice, still need to 


% Intermediate workflows

% 81A06
% Interesting cell, used the spike current hack thing, even had a signal in
% the EMG. 
Workflow_81A06_171026_F2_C1_ForceProbePatching 

% no spiking, not clear what this was, but large sensory responses that
% don't really look like 
Workflow_81A06_171107_F1_C1_ForceProbePatching 

% first really clear evidence of intermediate neuron, with a nice fill
Workflow_81A06_171122_F1_C1_ForceProbePatching

% Nice spikes, good strong responses to sensory information. piezo ramp
% videos
Workflow_81A06_180112_F1_C1_ForceProbePatching


%% Steps 
varNames = {'CellID','Genotype','Cell_label','Protocol','Trialnums','Position','Step','Peak','TimeToPeak','Area'};
varTypes = {'string','string','string','double','double','string','double'};

sz = [1 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

T{1,:} = {'171101_F1_C1', '81A07',            'fast', 'PiezoStep2T',     [],  [],              [],      [],[],[]};

T{2,:} = {'180223_F1_C1', '22A08',            'intermediate', 'PiezoStep2T',     1:180,  [],              [],      [],[],[]};
T{2,:} = {'180320_F1_C1', '22A08',            'intermediate', 'PiezoStep2T',     [],  [],              [],      [],[],[]};


% %% Ramps 
% sz = [25 7];
% varNames = {'CellID','Genotype','Cell_label','Protocol','Trialnums','Position','Peaks'};
% varTypes = {'string','string','string','double','double','string','double'};
% 
% data = cell(sz);
% T = cell2table(data);
% T.Properties.VariableNames = varNames;
% % T = table('VariableTypes',varTypes,'VariableNames',varNames,'RowNames',rownames)
% 
% T{1,:} = {'170921_F1_C1', '81A07',            'fast', [],     [],  [],              []      };


%% Sines

%% Fill out table

stepcell = T.CellID{2};

datafilename = fullfile('B:\Raw_Data',stepcell(1:regexp(stepcell,'_')-1),stepcell);
data = load(fullfile(datafilename,['PiezoStep2T_' stepcell '.mat'])); data = data.data;
    
% nums keeps track of the trials that have been put away. Just need a
% vector of trials
nums = nan(size(data));
for i = 1:length(data)
    nums(i) = data(i).trial;
end

for tag = 1:length(tags_dist)
    tag = tags_
    
end

% pos_step_trialnum_database = {
%     '180223_F1_C1'  1:6    121:135     151:165     61:75   91:105
%     '180320_F1_C1'  1:30    121:135     151:165     61:75   91:105
% };
% 
% neg_step_trialnum_database = {
%     '180320_F1_C1'  31:60   136:150     166:180     76:90   106:120
% };


%% Go through and plot the data



pos_step_trialnum_database = {
    '180223_F1_C1'  1:6    121:135     151:165     61:75   91:105
    '180320_F1_C1'  1:30    121:135     151:165     61:75   91:105
};

neg_step_trialnum_database = {
    '180320_F1_C1'  31:60   136:150     166:180     76:90   106:120
};

pos_ramp_trialnum_database = {
    '180320_F1_C1'  1:30    118:132     163:177     58:72   88:102
};

neg_ramp_trialnum_database = {
    '180320_F1_C1'  31:57   133:162     178:207     73:87   103:117
};
