% Script_computeCorrelationOfResistanceReflexAndPosition

steps = T_Ramp.Displacement;
T_m10 = T_Ramp(steps==-10,:);
T_m10 = T_m10(:,[1 7 8 9 10 11 3 2]);

% Plot the peaks for 150 speed
speeds = T_m10.Speed;
T_m10_150 = T_m10(speeds==150,:);

geno_l = true(size(T_m10_150.Genotype));
for g = 1:length(T_m10_150.Genotype) 
    if ~isempty(regexp(T_m10_150.Genotype{g},'/iav-LexA','once'))
        geno_l(g) = false;
    end
end
T_m10_150 = T_m10_150(geno_l,:);

% double check trial nums
for c = 1:length(T_m10_150.CellID)
    fprintf(1,'%d - %.2f - \t%s: [\t',c,T_m10_150.Peak(c),T_m10_150.CellID{c});
    fprintf(1,'%d\t',T_m10_150.Trialnums{c});
    fprintf(1,']\n');
end    

peaks = T_m10_150.Peak;

x_ax_pos = ones(size(peaks));
cl = T_m10_150.Cell_label;
cl0 = unique(cl);
for i = 1:length(cl0)
    x_ax_pos(strcmp(cl,cl0{i})) = i;
end

x_ax_pos_sig = x_ax_pos+T_m10_150.Position/500;% + normrnd(0,.02,size(x_ax_pos));

figure
ax = subplot(1,1,1);
title(ax,'Resistance Reflex');
hold(ax,'on')
for r_idx = 1:length(x_ax_pos_sig)
    plot(x_ax_pos_sig(r_idx) ,peaks(r_idx),'.k','tag',T_m10_150.CellID{r_idx});
end

R = zeros(size(cl0));
P = R;
for i = 1:length(cl0)
    [R_,P_] = corrcoef(T_m10_150.Peak(strcmp(cl,cl0{i})),T_m10_150.Position(strcmp(cl,cl0{i})));
    R(i) = R_(1,2);
    P(i) = P_(1,2);
    txt = text(i,-.5,sprintf('%.2f (%.2f)',R(i),P(i)));
    txt.HorizontalAlignment = 'center';
end
% for i = 1:length(cl0)
%     typrows = T_m10_150(strcmp(cl,cl0{i}),:);
%     cells = unique(typrows.CellID);
%     peaks = typrows.Peak;
%     for c = 1:length(cells)
%         peaks_ = typrows.Peak(strcmp(typrows.CellID,cells{c}));
%         peaks(strcmp(typrows.CellID,cells{c})) = peaks_/max(peaks_);
%     end
%     [R_,P_] = corrcoef(peaks,T_m10_150.Position(strcmp(cl,cl0{i})));
%     R(i) = R_(1,2);
%     P(i) = P_(1,2);
%     txt = text(i,-.5,sprintf('%.2f (%.2f)',R(i),P(i)));
%     txt.HorizontalAlignment = 'center';
% end

ax = gca;
ax.XTick = [unique(x_ax_pos); 4.5];
ax.XTickLabel = [cl0;{'slow FR'}];

ax.YLim = [-2 14];
ax.YTick = [0 2 4 6 8 10 12];
ax.YTickLabel = {'0', '2','4','6','8','10','12'};
ylabel(ax,'mV'); 

% Add firing rate for slow neurons
steps = SlowRampRows.Displacement;
T_m10 = SlowRampRows(steps==-10,:);
T_m10 = T_m10(:,[1 7 8 9 10 11 3 2]);
speeds = T_m10.Speed;
T_m10_150 = T_m10(speeds==150,:);

geno_l = true(size(T_m10_150.Genotype));
for g = 1:length(T_m10_150.Genotype) 
    if ~isempty(regexp(T_m10_150.Genotype{g},'/iav-LexA','once'))
        geno_l(g) = false;
    end
end
T_m10_150 = T_m10_150(geno_l,:);
peaks = T_m10_150.Peak;
x_ax_pos = ones(size(peaks))*4.5;
x_ax_pos_sig = x_ax_pos+T_m10_150.Position/500;% + normrnd(0,.02,size(x_ax_pos));
 
[R_,P_] = corrcoef(T_m10_150.Peak,T_m10_150.Position);
txt = text(4.5,-.5,sprintf('%.2f (%.2f)',R_(1,2),P_(1,2)));
txt.HorizontalAlignment = 'center';

for r_idx = 1:length(x_ax_pos_sig)
    plot(x_ax_pos_sig(r_idx) ,peaks(r_idx)/10,'.k','tag',T_m10_150.CellID{r_idx});
end

yyaxis right
ax.YLim = [-20 140];
ylabel('FR (Hz)');