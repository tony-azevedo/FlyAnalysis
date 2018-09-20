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
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','Step','Peak','TimeToPeak','Area','Delay'};
varTypes = {'string','string','string','double','double','string','double'};

sz = [1 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

%T{1,:} = {'170921_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[                  ], [],[1 2 3],[],[],[],[],[]}; % no steps
T{1,:} = {'171101_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};% just 0 position
%T{end+1,:} = {'171102_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[                  ], [],[1 2 3],[],[],[],[],[]}; % no steps
T{end+1,:} = {'171102_F2_C1', '81A07',            'fast', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]}; % said -200 in the notes, but suspect this was from the previous EpiFlash set
T{end+1,:} = {'171103_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
    T{end+1,:} = {'180308_F3_C1', '81A07',            'fast', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180404_F1_C1', '81A07/iav-LexA',   'fast', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180410_F1_C1', '81A07/iav-LexA',   'fast',  'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180703_F3_C1', '81A07/iav-LexA',   'fast',  'PiezoStep2T','empty',[0                  ], [],[1 2 3],[],[],[],[],[]};

T{end+1,:} = {'180222_F1_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180223_F1_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]}; % Weird one! 1st set of trials ok.
T{end+1,:} = {'180320_F1_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180405_F3_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180807_F1_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180328_F4_C1', '22A08/iav-LexA',     'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180821_F1_C1', '22A08/iav-LexA',     'intermediate', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180822_F1_C1', '22A08/iav-LexA',     'intermediate',  'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};

T{end+1,:} = {'180111_F2_C1', '35C09',     'slow', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
% T{end+1,:} = {'180307_F2_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 120], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180313_F1_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180621_F1_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180628_F2_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]}; % MLA
T{end+1,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow',  'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow',  'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{end+1,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', 'PiezoStep2T','empty',[0                  ], [],[1 2 3],[],[],[],[],[]};


Script_estimateStepResponseData


%% Plot the peaks across step size -10 step
clrs = [0 0 0
    1 0 1
    0 .5 0];
cids = unique(T_new.CellID);
clbls = unique(T.Cell_label);

figure
ax = subplot(1,1,1); hold(ax,'on');
plot(ax,[-10 10],[0 0],'color',[1 1 1]*.8)
for cidx = 1:length(cids)
    idx = strcmp(T_new.CellID,cids{cidx});
    x = cell2mat(T_new.Step(idx));
    y = cell2mat(T_new.Peak(idx));
    y = y.*-sign(x);
    typ = find(strcmp(clbls,T_new.Cell_label{find(idx,1)}));
    clr = clrs(strcmp(clbls,T_new.Cell_label{find(idx,1)}),:);
    plot(ax,x,y,'color',clr,'marker','.');
end
ax.XLim = [-11 11];


%% Plot the delay for any good (ie non iav) fast or intermediate cells 


clrs = [0 0 0
    1 0 1
    0 .5 0];
cids = unique(T_new.CellID);
clbls = unique(T.Cell_label);

figure
ax = subplot(1,1,1); hold(ax,'on');
% plot(ax,[-10 10],[0 0],'color',[1 1 1]*.8)
for cidx = 1:length(cids)
    idx = strcmp(T_new.CellID,cids{cidx});
    if ~isempty(regexp(T_new.Genotype{find(idx,1)},'iav','once'))
        continue
    end
    step_idx = cell2mat(T_new.Step);
    x = cell2mat(T_new.Step(idx));
    y = cell2mat(T_new.Delay(idx));
    
    delay = y(x==-10);
    typ = find(strcmp(clbls,T_new.Cell_label{find(idx,1)}));
    clr = clrs(strcmp(clbls,T_new.Cell_label{find(idx,1)}),:);
    plot(ax,typ,delay,'marker','o','markeredgecolor',clr,'markerfacecolor',clr,'tag',cids{cidx});
end
ax.XLim = [.5 3.5];



%% Ramps 
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','Displacement','Speed','Peak','TimeToPeak','Area'};
varTypes = {'string','string','string','double','double','string','double'};

sz = [2 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

%T{1,:} = {'170921_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[                  ], [],[1 2 3],[],[],[],[],[]}; % no steps
T{1,:} = {'171101_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};% just 0 position
%T{3,:} = {'171102_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[                  ], [],[1 2 3],[],[],[],[],[]}; % no steps
T{2,:} = {'171102_F2_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]}; % said -200 in the notes, but suspect this was from the previous EpiFlash set
T{3,:} = {'171103_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{4,:} = {'180308_F3_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{5,:} = {'180404_F1_C1', '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{6,:} = {'180410_F1_C1', '81A07/iav-LexA',   'fast',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{7,:} = {'180703_F3_C1', '81A07/iav-LexA',   'fast',  'PiezoRamp2T','empty',[0                  ], [],[1 2 3],[],[],[],[],[]};

T{8,:} = {'180222_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{9,:} = {'180223_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{10,:} = {'180320_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{11,:} = {'180405_F3_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{12,:} = {'180807_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{13,:} = {'180328_F4_C1', '22A08/iav-LexA',     'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{14,:} = {'180821_F1_C1', '22A08/iav-LexA',     'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{15,:} = {'180822_F1_C1', '22A08/iav-LexA',     'intermediate',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};

T{16,:} = {'180111_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
% T{17,:} = {'180307_F2_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 120], [],[1 2 3],[],[],[],[],[]};
T{17,:} = {'180313_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{18,:} = {'180621_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{19,:} = {'180628_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]}; % MLA
T{20,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[]};
T{21,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow',  'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[]};
T{22,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',[0                  ], [],[1 2 3],[],[],[],[],[]};


Script_estimateRampResponseData

%% Plot the peaks across speed
clrs = [0 0 0
    1 0 1
    0 .5 0];
cids = unique(T_new.CellID);
clbls = unique(T.Cell_label);

figure
ax = subplot(1,1,1); hold(ax,'on');
plot(ax,[-10 10],[0 0],'color',[1 1 1]*.8)
for cidx = 1:length(cids)
    dcpl = cell2mat(T_new.Displacement);
    idx = strcmp(T_new.CellID,cids{cidx}) & dcpl==-10;
    x = cell2mat(T_new.Speed(idx));
    y = cell2mat(T_new.Peak(idx));

    y = y(x==50|x==100|x == 150);
    x = x(x==50|x==100|x == 150);
    
    typ = find(strcmp(clbls,T_new.Cell_label{find(idx,1)}));
    clr = clrs(strcmp(clbls,T_new.Cell_label{find(idx,1)}),:);
    plot(ax,x,y,'color',clr,'marker','.');
end
ax.XLim = [45 155];


%% Plot the peaks for -10 step, 150 speed
steps = cell2mat(T_new.Displacement);
T_m10 = T_new(steps==-10,:);
T_m10 = T_m10(:,[1 8 9 10 11 3 2]);

% Plot the peaks for 150 speed
speeds = cell2mat(T_m10.Speed);
T_m10_50 = T_m10(speeds==150,:);

geno_l = true(size(T_m10_50.Genotype));
for g = 1:length(T_m10_50.Genotype) 
    if ~isempty(regexp(T_m10_50.Genotype{g},'/iav-LexA','once'))
        geno_l(g) = false;
    end
end
% T_m10_50 = T_m10_50(geno_l,:);

% double check trial nums
for c = 1:length(T_m10_50.CellID)
    fprintf(1,'%d - %.2f - %s: [\t',c,T_m10_50.Peak{c},T_m10_50.CellID{c});
    fprintf(1,'%d\t',T_m10_50.Trialnums{c});
    fprintf(1,']\n');
end    

peaks = cell2mat(T_m10_50.Peak);

x_ax_pos = ones(size(peaks));
cl = T_m10_50.Cell_label;
cl0 = unique(cl);
for i = 1:length(cl0)
    x_ax_pos(strcmp(cl,cl0{i})) = i;
end

x_ax_pos_sig = x_ax_pos+normrnd(0,.02,size(x_ax_pos));

cellID = T_m10_50.CellID;

figure
ax = subplot(1,1,1);
title(ax,'Resistance Reflex');
hold(ax,'on')
for r_idx = 1:length(x_ax_pos_sig)
    plot(x_ax_pos_sig(r_idx) ,peaks(r_idx),'.k','tag',cellID{r_idx});
end

ax = gca;
ax.XTick = unique(x_ax_pos);
ax.XTickLabel = cl0;
 
ax.YLim = [-2 12];
ax.YTick = [0 2 4 6 8 10];
ax.YTickLabel = {'0', '2','4','6','8','10'};
ylabel(ax,'mV'); 

%% Plot the peaks vs speed for each category
steps = cell2mat(T_new.Displacement);
T_m10 = T_new(steps==-10,:);
T_m10 = T_m10(:,[1 8 9 10 11 3 2]);

% Plot the peaks for 150 speed
speeds = cell2mat(T_m10.Speed);
T_m10_50 = T_m10(speeds==150,:);

geno_l = true(size(T_m10_50.Genotype));
for g = 1:length(T_m10_50.Genotype) 
    if ~isempty(regexp(T_m10_50.Genotype{g},'/iav-LexA','once'))
        geno_l(g) = false;
    end
end
% T_m10_50 = T_m10_50(geno_l,:);

% double check trial nums
for c = 1:length(T_m10_50.CellID)
    fprintf(1,'%d - %.2f - %s: [\t',c,T_m10_50.Peak{c},T_m10_50.CellID{c});
    fprintf(1,'%d\t',T_m10_50.Trialnums{c});
    fprintf(1,']\n');
end    

peaks = cell2mat(T_m10_50.Peak);

x_ax_pos = ones(size(peaks));
cl = T_m10_50.Cell_label;
cl0 = unique(cl);
for i = 1:length(cl0)
    x_ax_pos(strcmp(cl,cl0{i})) = i;
end

x_ax_pos_sig = x_ax_pos+normrnd(0,.02,size(x_ax_pos));

cellID = T_m10_50.CellID;

figure
ax = subplot(1,1,1);
title(ax,'Resistance Reflex');
hold(ax,'on')
for r_idx = 1:length(x_ax_pos_sig)
    plot(x_ax_pos_sig(r_idx) ,peaks(r_idx),'.k','tag',cellID{r_idx});
end

ax = gca;
ax.XTick = unique(x_ax_pos);
ax.XTickLabel = cl0;
 
ax.YLim = [-2 12];
ax.YTick = [0 2 4 6 8 10];
ax.YTickLabel = {'0', '2','4','6','8','10'};
ylabel(ax,'mV'); 

%% Sines
