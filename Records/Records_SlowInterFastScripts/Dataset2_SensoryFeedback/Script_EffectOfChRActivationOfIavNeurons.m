T_RampAndStep_noIav = T_RampAndStep(~contains(T_RampAndStep.Genotype,'iav-LexA'),:);
T_RampAndStep_Iav = T_RampAndStep(contains(T_RampAndStep.Genotype,'iav-LexA'),:);
labels = unique(T_RampAndStep.Cell_label);

figure
ax = subplot(1,1,1); ax.NextPlot = 'add';

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

for lbl_idx = 1:length(labels)
    label = labels{lbl_idx};
    
    % plot non iav for 0,-10,150
    lblidx = strcmp(T_RampAndStep_noIav.Cell_label,label);
    posidx = T_RampAndStep_noIav.Position==0;
    stpidx = T_RampAndStep_noIav.Displacement==-10;
    spdidx = T_RampAndStep_noIav.Speed==150;
    
    peaks_noniav = T_RampAndStep_noIav.Peak(lblidx & posidx & stpidx & spdidx);
    plot(lbl_idx-.2*ones(size(peaks_noniav)),peaks_noniav,'Linestyle','none','Marker','.','Color',clrs(lbl_idx,:));
    
    % plot iav for 0,-10,150
    lblidx = strcmp(T_RampAndStep_Iav.Cell_label,label);
    posidx = T_RampAndStep_Iav.Position==0;
    stpidx = T_RampAndStep_Iav.Displacement==-10;
    spdidx = T_RampAndStep_Iav.Speed==150;
    
    peaks_iav = T_RampAndStep_Iav.Peak(lblidx & posidx & stpidx & spdidx);
    plot(lbl_idx+.2*ones(size(peaks_iav)),peaks_iav,'Linestyle','none','Marker','.','Color',clrs(lbl_idx,:));

    [h,p] = ttest2(peaks_noniav,peaks_iav,'tail','right','vartype','unequal','alpha',0.01);
    txt = text(lbl_idx,12.5,sprintf('p=%.2f',p)); txt.HorizontalAlignment = 'center';
    switch h
        case 1
            txt.Color = [.3 .5 1];
        case 0
            txt.Color = [1 .2 .05];
    end
end
ax.XTick = [1 2 3 4];
ax.XTickLabel = [labels; {'slow FR'}];
ax.XLim = [0 5];

lbl_idx = 4;
% Now for firing rate of slow neurons
T_RmpStpSlowFR_noIav = T_RmpStpSlowFR(~contains(T_RmpStpSlowFR.Genotype,'iav-LexA'),:);
T_RmpStpSlowFR_Iav = T_RmpStpSlowFR(contains(T_RmpStpSlowFR.Genotype,'iav-LexA'),:);
labels = unique(T_RmpStpSlowFR.Cell_label);
    
% plot non iav for 0,-10,150
lblidx = strcmp(T_RmpStpSlowFR_noIav.Cell_label,label);
posidx = T_RmpStpSlowFR_noIav.Position==0;
stpidx = T_RmpStpSlowFR_noIav.Displacement==-10;
spdidx = T_RmpStpSlowFR_noIav.Speed==150;

peaks_noniav = T_RmpStpSlowFR_noIav.Peak(lblidx & posidx & stpidx & spdidx);
plot(lbl_idx-.2*ones(size(peaks_noniav)),peaks_noniav/10,'Linestyle','none','Marker','.','Color',clrs(3,:));

% plot iav for 0,-10,150
lblidx = strcmp(T_RmpStpSlowFR_Iav.Cell_label,label);
posidx = T_RmpStpSlowFR_Iav.Position==0;
stpidx = T_RmpStpSlowFR_Iav.Displacement==-10;
spdidx = T_RmpStpSlowFR_Iav.Speed==150;

peaks_iav = T_RmpStpSlowFR_Iav.Peak(lblidx & posidx & stpidx & spdidx);
plot(lbl_idx+.2*ones(size(peaks_iav)),peaks_iav/10,'Linestyle','none','Marker','.','Color',clrs(3,:));

[h,p] = ttest2(peaks_noniav,peaks_iav,'tail','right','vartype','unequal','alpha',0.01);
txt = text(lbl_idx,12.5,sprintf('p=%.2f',p)); txt.HorizontalAlignment = 'center';
switch h
    case 1
        txt.Color = [.3 .5 1];
    case 0
        txt.Color = [1 .2 .05];
end