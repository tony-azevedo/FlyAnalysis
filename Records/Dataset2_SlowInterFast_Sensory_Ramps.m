% Slow Workflows

% Slow
% Workflow_35C09_180111_F1_C1_ForceProbePatching
% Workflow_35C09_180307_F2_C1_ForceProbePatching
% Workflow_35C09_180313_F1_C1_ForceProbePatching
% 
% Workflow_35C09_180621_F1_C1_ForceProbePatching % 
% Workflow_35C09_180628_F2_C1_ForceProbePatching % spike detection complete
% Workflow_35C09_181014_F1_C1_ForceProbePatching % complete!
% 
% Workflow_35C09_181021_F1_C1_ForceProbePatching % spike detection and leg movement complete
% Workflow_35C09_181024_F2_C1_ForceProbePatching
% Workflow_35C09_181127_F1_C1_ForceProbePatching
% Workflow_35C09_181127_F2_C1_ForceProbePatching
% 
% Workflow_35C09_181128_F1_C1_ForceProbePatching
% Workflow_35C09_181128_F2_C1_ForceProbePatching


%% Intermediate workflows
% Workflow_22A08_180222_F1_C1_ForceProbePatching % clear movement of the bar with single spikes, very nice!
% Workflow_22A08_180223_F1_C1_ForceProbePatching
% Workflow_22A08_180320_F1_C1_ForceProbePatching
% 
% Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching
% Workflow_22A08_180807_F1_C1_ChRStimulation_ForceProbePatching
% 
% Workflow_22A08_181118_F1_C1_ForceProbePatching
% 
% Workflow_22A08_181205_F1_C1_ForceProbePatching


%% Fast work flows

% 81A07 - with ChR
% Workflow_81A07_171101_F1_C1_ForceProbePatching
% Workflow_81A07_171102_F1_C1_ForceProbePatching
% Workflow_81A07_171102_F2_C1_ForceProbePatching
% Workflow_81A07_171103_F1_C1_ForceProbePatching
% Workflow_81A07_180308_F3_C1_ForceProbePatching

% 
%% Others
% 
% % Slow
% % 81A06
% Workflow_81A06_171025_F1_C1_ForceProbePatching % 171025_F1_C1
% 
% % Workflow_81A06_171107_F1_C2_ForceProbePatching % not much leg movement
% Workflow_81A06_171116_F1_C1_ForceProbePatching % Good cell, current injection nice, still need to 
% 
% 
% % Intermediate workflows
% 
% % 81A06
% % Interesting cell, used the spike current hack thing, even had a signal in
% % the EMG. 
% Workflow_81A06_171026_F2_C1_ForceProbePatching 
% 
% % no spiking, not clear what this was, but large sensory responses that
% % don't really look like 
% Workflow_81A06_171107_F1_C1_ForceProbePatching 
% 
% % first really clear evidence of intermediate neuron, with a nice fill
% Workflow_81A06_171122_F1_C1_ForceProbePatching
% 
% % Nice spikes, good strong responses to sensory information. piezo ramp
% % videos
% Workflow_81A06_180112_F1_C1_ForceProbePatching



%% Ramps 
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','Displacement','Speed',	'Peak','TimeToPeak','Area','MLA'};
varTypes = {'string','string',  'string',    'string',  'string',   'double',   'double',  'double',   'double'      , 'double','string','double','double','double'};

sz = [2 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

%T{1,:} = {'170921_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[                  ], [],[1 2 3],[],[],[],[],[],[]}; % no steps
T{1,:} = {'171101_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};% just 0 position
%T{3,:} = {'171102_F1_C1', '81A07',            'fast', 'PiezoStep2T','empty',[                  ], [],[1 2 3],[],[],[],[],[],[]}; % no steps
T{2,:} = {'171102_F2_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]}; % said -200 in the notes, but suspect this was from the previous EpiFlash set
T{end+1,:} = {'171103_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180308_F3_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180404_F1_C1', '81A07/iav-LexA',   'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180410_F1_C1', '81A07/iav-LexA',   'fast',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180703_F3_C1', '81A07/iav-LexA',   'fast',  'PiezoRamp2T','empty',[0                  ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'190116_F1_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'190116_F3_C1', '81A07',            'fast', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};

T{end+1,:} = {'180222_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180223_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180320_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180405_F3_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180807_F1_C1', '22A08',            'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180328_F4_C1', '22A08/iav-LexA',     'intermediate', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180821_F1_C1', '22A08/iav-LexA',     'intermediate', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181118_F1_C1', '22A08',            'intermediate',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181205_F1_C1', '22A08',            'intermediate',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};

T{end+1,:} = {'180111_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
% T{17,:} = {'180307_F2_C1', '35C09',     'slow', 'PiezoStep2T','empty',[-150 -75  0 75 120], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180313_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180621_F1_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180628_F2_C1', '35C09',     'slow', 'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]}; % MLA
T{end+1,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow',  'PiezoRamp2T','empty',[0                 ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', 'PiezoRamp2T','empty',[0                  ], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181014_F1_C1', '35C09',     'slow',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181021_F1_C1', '35C09',     'slow',  'PiezoRamp2T','empty',[     -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181024_F2_C1', '35C09',     'slow',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181127_F1_C1', '35C09',     'slow',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181127_F2_C1', '35C09',     'slow',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181128_F1_C1', '35C09',     'slow',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};
T{end+1,:} = {'181128_F2_C1', '35C09',     'slow',  'PiezoRamp2T','empty',[-150 -75  0 75 150], [],[1 2 3],[],[],[],[],[],[]};

Script_estimateRampResponseData
% clear T_Ramp
% writetable(T_Ramp,'E:\Results\Dataset2_SIF_Sensory_RampData')
% T_Ramp2 = readtable('E:\Results\Dataset2_SIF_Sensory_RampData');


%% Steps 
% varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','Displacement',  'Speed','Peak',      'TimeToPeak',  'Area', 'MLA'};
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','Step',          'Peak', 'TimeToPeak','Area',        'Delay','Speed'};
T.Properties.VariableNames = varNames;
Script_estimateStepResponseData


%% Plot the peaks across speed
clrs = [0 0 0
    1 0 1
    0 .5 0];
cids = unique(T_Ramp.CellID);
clbls = unique(T.Cell_label);

figure
ax1 = subplot(1,3,1); hold(ax1,'on');
plot(ax1,[-10 10],[0 0],'color',[1 1 1]*.8)
ax2 = subplot(1,3,2); hold(ax2,'on');
plot(ax2,[-10 10],[0 0],'color',[1 1 1]*.8)
ax3 = subplot(1,3,3); hold(ax3,'on');
plot(ax3,[-10 10],[0 0],'color',[1 1 1]*.8)
for cidx = 1:length(cids)
    dcpl = cell2mat(T_Ramp.Displacement);
    idx = strcmp(T_Ramp.CellID,cids{cidx}) & dcpl==-10;
    posidx = cell2mat(T_Ramp.Position)==0;

    x = cell2mat(T_Ramp.Speed(idx&posidx));
    y = cell2mat(T_Ramp.Peak(idx&posidx));

    y = y(x==50|x==100|x == 150| x==300);
    x = x(x==50|x==100|x == 150| x==300);
    
    typ = find(strcmp(clbls,T_Ramp.Cell_label{find(idx,1)}));
    clr = clrs(strcmp(clbls,T_Ramp.Cell_label{find(idx,1)}),:);
    eval(['ax = ax' num2str(typ) ';']);
    plot(ax,x,y,'color',clr,'marker','.');
end
ax1.XLim = [40 310];
ax2.XLim = [40 310];
ax3.XLim = [40 310];
ax1.YLim = [0 15];
ax2.YLim = [0 15];
ax3.YLim = [0 15];

%% Plot the peaks for -10 step, 150 speed
steps = cell2mat(T_Ramp.Displacement);
T_m10 = T_Ramp(steps==-10,:);
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
T_m10_50 = T_m10_50(geno_l,:);

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

%% Plot the peaks vs speed for each category at each displacement, no steps

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];
cids = unique(T_Ramp.CellID);
clbls = unique(T.Cell_label);

rampVsPosF = figure;
rampVsPosF.Position = [680 80 1177 898];
panl = panel(rampVsPosF);
panl.pack('v',{1/5 1/5 1/5 2/5});
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';

positions = [-150 -75 0 75 150];
dps = [
  -61.3904
  -40.9269
  -20.4635
   20.4635
   40.9269
   61.3904];

ratio = 2.4;
xtick = repmat(dps,1,5)/ratio+repmat(positions,length(dps),1);
xticklabels = num2str(repmat(round(dps*10)/10,6,1));

for a = 1:3
    ax = panl(a).select(); hold(ax,'on');
    plot(ax,[-180 180],[0 0],'color',[1 1 1]*.8)
    ax.XTick = xtick(:);
    ax.XTickLabel = xticklabels;
    ax.XTickLabelRotation = 45;
end
panl(2).ylabel('PSP peak (mV)');
panl(3).xlabel('Angular velocity (degree/s)');

% ax = panl(4).select(); hold(ax,'on');

L = 419.9858; %um

for cidx = 1:length(cids)    
   
    idx = strcmp(T_Ramp.CellID,cids{cidx});
    typ = find(strcmp(clbls,T_Ramp.Cell_label{find(idx,1)}));
    ax = panl(typ).select(); hold(ax,'on'); %#ok<FNDSB>
    
    positions = (T_Ramp.Positions{find(idx,1)});
    if length(positions)==1
        continue
    end
    cell_y = nan(size(positions));
    cell_x = positions;
    for pos = positions
        posidx = idx & cell2mat(T_Ramp.Position) == pos;
        if ~sum(posidx)
            fprintf('%s is missing data for position %d\n',cids{cidx},pos);
            continue
        end
        x = cell2mat(T_Ramp.Speed(posidx)) .* sign(cell2mat(T_Ramp.Displacement(posidx))) *3; % 3um/V, speed in V/sec, 
        y = cell2mat(T_Ramp.Peak(posidx));
        y = y.*-sign(x);
        
        [x,o] = sort(x);
        y = y(o);

        w = x/L;
        dps = w/(2*pi)*360;

        clr = clrs(strcmp(clbls,T_Ramp.Cell_label{find(posidx,1)}),:);
        ltclr = lightclrs(strcmp(clbls,T_Ramp.Cell_label{find(posidx,1)}),:);
        plot(ax,dps/ratio+pos,y,'color',clr,'marker','.');

    end
end


%% Plot the peaks vs speed for each category at each displacement, including steps

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];
cids = unique(T_Ramp.CellID);
clbls = unique(T.Cell_label);

rampVsPosF = figure;
rampVsPosF.Position = [680 80 1177 898];
panl = panel(rampVsPosF);
panl.pack('v',{1/5 1/5 1/5 2/5});
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';

positions = [-150 -75 0 75 150];
dps = [-272.8463
  -40.9269
   40.9269
  272.8463];
ratio = 10;
xtick = repmat(dps,1,5)/ratio+repmat(positions,length(dps),1);
xticklabels = num2str(repmat(round(dps*10)/10,6,1));

for a = 1:3
    ax = panl(a).select(); hold(ax,'on');
    plot(ax,[-180 180],[0 0],'color',[1 1 1]*.8)
    ax.XTick = xtick(:);
    ax.XTickLabel = xticklabels;
    ax.XTickLabelRotation = 45;
end
panl(2).ylabel('PSP peak (mV)');
panl(3).xlabel('Angular velocity (degree/s)');

% ax = panl(4).select(); hold(ax,'on');

L = 419.9858; %um

for cidx = 1:length(cids)    
   
    idx = strcmp(T_Ramp.CellID,cids{cidx});
    typ = find(strcmp(clbls,T_Ramp.Cell_label{find(idx,1)}));
    ax = panl(typ).select(); hold(ax,'on'); %#ok<FNDSB>
    
    positions = (T_Ramp.Positions{find(idx,1)});
    if length(positions)==1
        continue
    end
    cell_y = nan(size(positions));
    cell_x = positions;
    for pos = positions
        posidx = idx & cell2mat(T_Ramp.Position) == pos;
        if ~sum(posidx)
            fprintf('%s is missing data for position %d\n',cids{cidx},pos);
            continue
        end
        x = cell2mat(T_Ramp.Speed(posidx)) .* sign(cell2mat(T_Ramp.Displacement(posidx))) *3; % 3um/V, speed in V/sec, 
        y = cell2mat(T_Ramp.Peak(posidx));
        y = y.*-sign(x);
        
        
        if ~exist('T_Step','var')
            fprintf('No T_Step, run Dataset2_SlowInterFast_Sensory_Steps');
        else
            neg_fast_idx = cell2mat(T_Step.Step) == -10 & strcmp(T_Step.CellID,cids{cidx}) & cell2mat(T_Step.Position) == pos;
            neg_fast = -1 * cell2mat(T_Step.Speed(neg_fast_idx));
            neg_peak = cell2mat(T_Step.Peak(neg_fast_idx));
            pos_fast_idx = cell2mat(T_Step.Step) == 10 & strcmp(T_Step.CellID,cids{cidx}) & cell2mat(T_Step.Position) == pos;
            pos_fast = cell2mat(T_Step.Speed(pos_fast_idx));
            pos_peak =  -1 * cell2mat(T_Step.Peak(pos_fast_idx));
            
            x = [x; neg_fast; pos_fast];
            y = [y; neg_peak; pos_peak];
            
        end
        
        [x,o] = sort(x);
        y = y(o);

        w = x/L;
        dps = w/(2*pi)*360;

        clr = clrs(strcmp(clbls,T_Ramp.Cell_label{find(posidx,1)}),:);
        ltclr = lightclrs(strcmp(clbls,T_Ramp.Cell_label{find(posidx,1)}),:);
        plot(ax,dps/ratio+pos,y,'color',clr,'marker','.');

        
        step10atposidx = posidx & cell2mat(T_Ramp.Displacement)==-10;
        if sum(step10atposidx)
            % cell_x(pos == positions) = pos;
            cell_y(pos == positions) = nanmean(cell2mat(T_Ramp.Peak(step10atposidx)));
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
        if length(lns(ln).YData)==length(xs)
            ys(ln,:) = lns(ln).YData;
        else
            [~,idx] = intersect(xs,lns(ln).XData);
            ys(ln,idx) = lns(ln).YData;
        end
    end
    plot(ax,xs,nanmean(ys,1),'color',clrs(typ,:),'marker','.','tag',['type' num2str(typ)],'linewidth',2,'markersize',10);
end

ax.XLim = [-200 200];
ax.YLim = [-.1 1.1];
ax.XTick = xs;

% angle calculation based on Methods_LegMeasurements
tl = {};
for pos = positions
    tl{pos==positions} = num2str(round(asind(pos/L)*10)/10);
end
ax.XTickLabel = tl;
xlabel(ax,'Leg Angle (Degrees)');

%% Get firing rate data on slow neurons
Script_estimateSpikeRatesForRampsAndSteps
head(SlowRampRows)

% Plot the peaks vs speed for each category at each displacement, including steps

clrs = [0 .5 0];
lightclrs = [.7 1 .7];
cids = unique(SlowRampRows.CellID);
clbls = unique(SlowRampRows.Cell_label);

rampFRVsPosF = figure;
rampFRVsPosF.Position = [680 80 1177 898];
panl = panel(rampFRVsPosF);
panl.pack('v',{1/5 1/5 1/5 2/5});
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';

positions = [-150 -75 0 75 150];
dps = [-272.8463
  -40.9269
   40.9269
  272.8463];
ratio = 10;
xtick = repmat(dps,1,5)/ratio+repmat(positions,length(dps),1);
xticklabels = num2str(repmat(round(dps*10)/10,6,1));

for a = 1:length(clbls)
    ax = panl(a).select(); hold(ax,'on');
    plot(ax,[-180 180],[0 0],'color',[1 1 1]*.8)
    ax.XTick = xtick(:);
    ax.XTickLabel = xticklabels;
    ax.XTickLabelRotation = 45;
end
panl(1).ylabel('FR peak (sp/sec)');
panl(1).xlabel('Angular velocity (degree/s)');

% ax = panl(4).select(); hold(ax,'on');

L = 419.9858; %um

for cidx = 1:length(cids)    
   
    idx = strcmp(SlowRampRows.CellID,cids{cidx});
    % typ = find(strcmp(clbls,SlowRampRows.Cell_label{find(idx,1)}));
    ax = panl(typ).select(); hold(ax,'on'); %#ok<FNDSB>
    
    positions = (SlowRampRows.Positions{find(idx,1)});
    %     if length(positions)==1
    %         continue
    %     end
    cell_y = nan(size(positions));
    cell_x = positions;
    for position = positions
        posidx = idx & cell2mat(SlowRampRows.Position) == position;
        if ~sum(posidx)
            fprintf('%s is missing data for position %d\n',cids{cidx},position);
            continue
        end
        x = cell2mat(T_Ramp.Speed(posidx)) .* sign(cell2mat(T_Ramp.Displacement(posidx))) *3; % 3um/V, speed in V/sec, 
        y = cell2mat(T_Ramp.Peak(posidx));
        y = y.*-sign(x);
        
        
        if ~exist('T_Step','var')
            fprintf('No T_Step, run Dataset2_SlowInterFast_Sensory_Steps');
        else
            neg_fast_idx = cell2mat(T_Step.Step) == -10 & strcmp(T_Step.CellID,cids{cidx}) & cell2mat(T_Step.Position) == pos;
            neg_fast = -1 * cell2mat(T_Step.Speed(neg_fast_idx));
            neg_peak = cell2mat(T_Step.Peak(neg_fast_idx));
            pos_fast_idx = cell2mat(T_Step.Step) == 10 & strcmp(T_Step.CellID,cids{cidx}) & cell2mat(T_Step.Position) == pos;
            pos_fast = cell2mat(T_Step.Speed(pos_fast_idx));
            pos_peak =  -1 * cell2mat(T_Step.Peak(pos_fast_idx));
            
            x = [x; neg_fast; pos_fast];
            y = [y; neg_peak; pos_peak];
            
        end
        
        [x,o] = sort(x);
        y = y(o);

        w = x/L;
        dps = w/(2*pi)*360;

        clr = clrs(strcmp(clbls,T_Ramp.Cell_label{find(posidx,1)}),:);
        ltclr = lightclrs(strcmp(clbls,T_Ramp.Cell_label{find(posidx,1)}),:);
        plot(ax,dps/ratio+pos,y,'color',clr,'marker','.');

        
        step10atposidx = posidx & cell2mat(T_Ramp.Displacement)==-10;
        if sum(step10atposidx)
            % cell_x(pos == positions) = pos;
            cell_y(pos == positions) = nanmean(cell2mat(T_Ramp.Peak(step10atposidx)));
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
        if length(lns(ln).YData)==length(xs)
            ys(ln,:) = lns(ln).YData;
        else
            [~,idx] = intersect(xs,lns(ln).XData);
            ys(ln,idx) = lns(ln).YData;
        end
    end
    plot(ax,xs,nanmean(ys,1),'color',clrs(typ,:),'marker','.','tag',['type' num2str(typ)],'linewidth',2,'markersize',10);
end

ax.XLim = [-200 200];
ax.YLim = [-.1 1.1];
ax.XTick = xs;

% angle calculation based on Methods_LegMeasurements
tl = {};
for pos = positions
    tl{pos==positions} = num2str(round(asind(pos/L)*10)/10);
end
ax.XTickLabel = tl;
xlabel(ax,'Leg Angle (Degrees)');

