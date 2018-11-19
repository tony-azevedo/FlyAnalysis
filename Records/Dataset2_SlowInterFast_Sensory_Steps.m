% Slow Workflows

% Slow
Workflow_35C09_180111_F1_C1_ForceProbePatching
Workflow_35C09_180307_F2_C1_ForceProbePatching
Workflow_35C09_180313_F1_C1_ForceProbePatching

Workflow_35C09_180621_F1_C1_ForceProbePatching
Workflow_35C09_180628_F2_C1_ForceProbePatching % working on
Workflow_35C09_181014_F1_C1_ForceProbePatching % complete!

Workflow_35C09_181021_F1_C1_ForceProbePatching
Workflow_35C09_181024_F2_C1_ForceProbePatching


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
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums', 'Step',  'Peak',    'TimeToPeak','Area','Delay','Speed'};
varTypes = {'string','string',  'string',   'string',   'string',   'double',   'double',   'string',   'double','double',  'double',   'double','double','double'};

sz = [1 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

%T{1,:} = {'170921_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[                  ], [],[1 2 3],[],[],[],[],[],[]}; % no steps
T{1,:} = {'171101_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};% just 0 position
%T{end+1,:} = {'171102_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[                  ], [],[1 2 3],[],[],[],[],[],[]}; % no steps
T{end+1,:} = {'171102_F2_C1', '81A07',            'fast', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]}; % said -200 in the notes, but suspect this was from the previous EpiFlash set
T{end+1,:} = {'171103_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
    T{end+1,:} = {'180308_F3_C1', '81A07',            'fast', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180404_F1_C1', '81A07/iav-LexA',   'fast', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180410_F1_C1', '81A07/iav-LexA',   'fast',  'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180703_F3_C1', '81A07/iav-LexA',   'fast',  'PiezoStep2T','empty',[0                  ], [],[1 2 3],[],[],[],[],[],[]};

T{end+1,:} = {'180222_F1_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180223_F1_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]}; % Weird one! 1st set of trials ok.
T{end+1,:} = {'180320_F1_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180405_F3_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180807_F1_C1', '22A08',            'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180328_F4_C1', '22A08/iav-LexA',     'intermediate', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180821_F1_C1', '22A08/iav-LexA',     'intermediate', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180822_F1_C1', '22A08/iav-LexA',     'intermediate',  'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};

T{end+1,:} = {'180111_F2_C1', '35C09',     'slow', 'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
% T{end+1,:} = {'180307_F2_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 120], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180313_F1_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180621_F1_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180628_F2_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]}; % MLA
T{end+1,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow',  'PiezoStep2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow',  'PiezoStep2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', 'PiezoStep2T','empty',[0                  ], [],[1 2 3],[],[],[],[],[],[]};


Script_estimateStepResponseData

%% Plot the peaks across step size -10 step
clrs = [0 0 0
    1 0 1
    0 .5 0];
cids = unique(T_Step.CellID);
clbls = unique(T.Cell_label);

figure
ax = subplot(1,1,1); hold(ax,'on');
plot(ax,[-10 10],[0 0],'color',[1 1 1]*.8)
for cidx = 1:length(cids)
    idx = strcmp(T_Step.CellID,cids{cidx});
    x = cell2mat(T_Step.Step(idx));
    y = cell2mat(T_Step.Peak(idx));
    y = y.*-sign(x);
    typ = find(strcmp(clbls,T_Step.Cell_label{find(idx,1)}));
    clr = clrs(strcmp(clbls,T_Step.Cell_label{find(idx,1)}),:);
    plot(ax,x,y,'color',clr,'marker','.');
end
ax.XLim = [-11 11];


%% Plot the delay for any good (ie non iav) fast or intermediate cells 


clrs = [0 0 0
    1 0 1
    0 .5 0];
cids = unique(T_Step.CellID);
clbls = unique(T.Cell_label);

figure
ax = subplot(1,1,1); hold(ax,'on');
% plot(ax,[-10 10],[0 0],'color',[1 1 1]*.8)
for cidx = 1:length(cids)
    idx = strcmp(T_Step.CellID,cids{cidx});
    if ~isempty(regexp(T_Step.Genotype{find(idx,1)},'iav','once'))
        continue
    end
    step_idx = cell2mat(T_Step.Step);
    x = cell2mat(T_Step.Step(idx));
    y = cell2mat(T_Step.Delay(idx));
    
    delay = y(x==-10);
    typ = find(strcmp(clbls,T_Step.Cell_label{find(idx,1)}));
    clr = clrs(strcmp(clbls,T_Step.Cell_label{find(idx,1)}),:);
    plot(ax,typ,delay,'marker','o','markeredgecolor',clr,'markerfacecolor',clr,'tag',cids{cidx});
end
ax.XLim = [.5 3.5];


%% Plot the peaks across step size and position

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];
cids = unique(T_Step.CellID);
clbls = unique(T.Cell_label);

stepVsPosF = figure;
stepVsPosF.Position = [680   405   560   573];
panl = panel(stepVsPosF);
panl.pack('v',{1/5 1/5 1/5 2/5});
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';

for a = 1:3
    ax = panl(a).select(); hold(ax,'on');
    plot(ax,[-180 180],[0 0],'color',[1 1 1]*.8)
    ax.XTick = [-150 -75 0 75 150];
end
panl(2).ylabel('PSP peak (mV)');
panl(3).xlabel('Leg position (\mum)');

ax = panl(4).select(); hold(ax,'on');

for cidx = 1:length(cids)    
   
    idx = strcmp(T_Step.CellID,cids{cidx});
    typ = find(strcmp(clbls,T_Step.Cell_label{find(idx,1)}));
    ax = panl(typ).select(); hold(ax,'on');

    positions = (T_Step.Positions{find(idx,1)});
    if length(positions)==1
        continue
    end
    cell_y = nan(size(positions));
    cell_x = positions;
    for pos = positions
        posidx = idx & cell2mat(T_Step.Position) == pos;
        if ~sum(posidx)
            fprintf('%s is missing data for position %d\n',cids{cidx},pos);
            continue
        end
        x = cell2mat(T_Step.Step(posidx)) * 3;
        y = cell2mat(T_Step.Peak(posidx));
        y = y.*-sign(x);
        clr = clrs(strcmp(clbls,T_Step.Cell_label{find(posidx,1)}),:);
        ltclr = lightclrs(strcmp(clbls,T_Step.Cell_label{find(posidx,1)}),:);
        plot(ax,x+pos,y,'color',clr,'marker','.');
        
        step10atposidx = posidx & cell2mat(T_Step.Step)==-10;
        if sum(step10atposidx)
            % cell_x(pos == positions) = pos;
            cell_y(pos == positions) = cell2mat(T_Step.Peak(step10atposidx));
        end
    end
    ax = panl(4).select(); hold(ax,'on');
    plot(ax,cell_x,cell_y/max(cell_y),'color',ltclr,'marker','.','tag',['type' num2str(typ)]);
end

ax = panl(4).select(); hold(ax,'on');
for typ = 1:length(clbls)
    lns = findobj(ax,'type','line','tag',['type' num2str(typ)]);
    xs = lns(1).XData;
    ys = nan(length(lns),length(xs));
    for ln = 1:length(lns)
        ys(ln,:) = lns(ln).YData;
    end
    plot(ax,xs,nanmean(ys,1),'color',clrs(typ,:),'marker','.','tag',['type' num2str(typ)],'linewidth',2,'markersize',10);
end

ax.XLim = [-200 200];
ax.YLim = [-.1 1.1];
ax.XTick = xs;

% angle calculation based on Methods_LegMeasurements
L = 419.9858; %um
tl = {};
for pos = positions
    tl{pos==positions} = num2str(round(asind(pos/L)*10)/10);
end
ax.XTickLabel = tl;
xlabel(ax,'Leg Angle (Degrees)');

%%


%% Sines
