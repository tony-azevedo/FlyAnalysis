%% R01 figures

%% Plot the fraction of trials in which the leg is in the target.

% get a filestem to be able to import measure tables
CellID = T_cell.CellID{1};
Dir = fullfile('F:\Acquisition\',CellID(1:6),CellID);
a = dir(fullfile(Dir,'*_MeasureTable.mat'));
measuretablestem = regexprep(a.name,CellID,'%s');

% go through each cell, load the measureTable, plot the fraction of trials
% in each block in which the fly is in the right place.
fig = figure;
fig.Position = [680 456 1059 522];
ax_bar = subplot(2,1,1,'parent',fig); ax_bar.NextPlot = 'add';
ax_pct = subplot(2,1,2,'parent',fig); ax_pct.NextPlot = 'add';

for c_ind = 1:length(T_cell.CellID)
    CellID = T_cell.CellID{c_ind};
    Dir = fullfile('F:\Acquisition\',CellID(1:6),CellID);

    T = load(fullfile(Dir,sprintf(measuretablestem,CellID)));
    T = T.T;
    
    blcks = unique(T.block(:));
    blcks = blcks(blcks~=0);
    oc_cnt = zeros(6,length(blcks));
    hiforce = false(size(blcks));
    for blck = 1:length(blcks)
        bl_outcomes = T.outcome(T.block==blcks(blck));
        allhi = all(T.hiforce(T.block==blcks(blck)));
        alllo = all(~T.hiforce(T.block==blcks(blck)));
        if allhi
            hiforce(blck) = true;
        elseif alllo
            hiforce(blck) = false;
        end
        for oc = 1:6
            oc_cnt(oc,blck) = sum(bl_outcomes==oc);%/length(bl_outcomes);
            
        end
    end
    usable_trials = (oc_cnt(1,:)+oc_cnt(2,:)+oc_cnt(3,:));
    less_usable = (oc_cnt(4,:)+oc_cnt(5,:)+oc_cnt(6,:));
    if hiforce(1)
        plot(ax_pct,blcks,(oc_cnt(1,:)+oc_cnt(2,:)+oc_cnt(3,:))./sum(oc_cnt,1),'.-','displayname',CellID);
    else
        plot(ax_pct,blcks-1,(oc_cnt(1,:)+oc_cnt(2,:)+oc_cnt(3,:))./sum(oc_cnt,1),'.-','displayname',CellID);
    end
    
    if hiforce(1)
        brs = bar(ax_bar,blcks'+.1*c_ind,[usable_trials(:),less_usable(:)]./sum(oc_cnt,1)',.09,'stacked');
        brs(1).FaceColor = [0 .4 .96];
        brs(1).EdgeColor = 'none';
        brs(2).FaceColor = [1 .45 .3];
        brs(2).EdgeColor = 'none';
    else
        brs = bar(ax_bar,blcks'-1+.1*c_ind,[usable_trials(:),less_usable(:)]./sum(oc_cnt,1)',.09,'stacked');
        brs(1).FaceColor = [0 .4 .96];
        brs(1).EdgeColor = 'none';
        brs(2).FaceColor = [1 .45 .3];
        brs(2).EdgeColor = 'none';
    end

end

ax_pct.XTick = 0:12;
ax_pct.XTickLabel = {'low','hi'};

ax_pct.YLim = [0 1];
plot(ax_pct,[0 16],[.5 .5],'color',[.8 .8 .8]);
plot(ax_bar,[0 17],[.5 .5],'color',[.8 .8 .8]);

ax_pct.XLim = [0 12];
ax_bar.XLim = [0 12];


%% Try a new routine where all the high vs. low target distributions are plotted for each fly
measuretablestem = 'LEDFlashWithPiezoCueControl_%s_MeasureTable.mat';
fpstem = regexprep(measuretablestem,'MeasureTable','ForceProbe');

fpcumfig = figure;
fpcumfig.Position = [680 199 560 779];
ax_cdf = subplot(4,1,1,'parent',fpcumfig); ax_cdf.NextPlot = 'add';
ax_pdf = subplot(4,1,2,'parent',fpcumfig); ax_pdf.NextPlot = 'add';
ax_hi = subplot(4,1,3,'parent',fpcumfig); ax_hi.NextPlot = 'add';
ax_lo = subplot(4,1,4,'parent',fpcumfig); ax_lo.NextPlot = 'add';

step = 2;
    
for c_ind = 1:length(T_cell.CellID)
    CellID = T_cell.CellID{c_ind};
    [T,bT,fp] = loadTableAndFPMatrix(CellID);

    hitarget = [mode(bT.target1(bT.hiforce)) 0];
    hitarget(2) = mode(bT.target2(bT.target1==hitarget(1)));
    lotarget = [mode(bT.target1(~bT.hiforce)) 0];
    lotarget(2) = mode(bT.target2(bT.target1==lotarget(1)));
    goodblocks = sort(...
        [bT.block(bT.target1==hitarget(1) & bT.target2==hitarget(2));
        bT.block(bT.target1==lotarget(1) & bT.target2==lotarget(2))]);
    
    isgoodblck =  arrayfun(@(x)ismember(x,goodblocks),T.block);
    % plot
    fpgood = fp(:,isgoodblck);
    x = sort(fpgood(:));
    xq = (round(x(1)):step:round(x(end)));
    [cdf_total,pdf_total] = smoothCummulative(x,xq);
    plot(ax_cdf,xq,cdf_total,'Color',[0 0 0])    
    plot(ax_pdf,xq(1:end-1)+step/2-hitarget(2),pdf_total,'Color',[.8 .8 .8],'DisplayName',CellID)
        
    % Hi target distributions
    hi = fp(:,T.hiforce & isgoodblck);
    x = sort(hi(:));
    [cdf_total,pdf_total] = smoothCummulative(x,xq);
    plot(ax_cdf,xq,cdf_total,'Color',hiclr);
    plot(ax_hi,xq(1:end-1)+step/2-hitarget(2),pdf_total,'Color',hiclr,'DisplayName',CellID)
    
    % Low target distributions
    lo = fp(:,~T.hiforce & isgoodblck);
    x = sort(lo(:));
    [cdf_total,pdf_total] = smoothCummulative(x,xq);
    plot(ax_cdf,xq,cdf_total,'Color',loclr);
    plot(ax_lo,xq(1:end-1)+step/2-lotarget(2)+100,pdf_total,'Color',loclr,'DisplayName',CellID)
    
    plot(ax_cdf,hitarget,-.05*c_ind*[1 1],'Linewidth',3,'Color',hiclr,'DisplayName',CellID)
    plot(ax_cdf,lotarget,-.05*c_ind*[1 1],'Linewidth',3,'Color',loclr,'DisplayName',CellID)
    
    plot(ax_pdf,hitarget-hitarget(2),-.01*c_ind*[1 1],'Linewidth',2,'Color',hiclr)
    plot(ax_pdf,lotarget-hitarget(2),-.01*c_ind*[1 1],'Linewidth',2,'Color',loclr)

    plot(ax_hi,hitarget-hitarget(2),-.01*c_ind*[1 1],'Linewidth',2,'Color',hiclr)
    plot(ax_lo,lotarget-lotarget(2)+100,-.01*c_ind*[1 1],'Linewidth',2,'Color',loclr)
end

linkaxes([ax_pdf, ax_hi, ax_lo]);
ax_pdf.XLim = [-150 150];
ax_pdf.YLim = [-0.05 .15];

set(findobj(ax_pdf,'DisplayName','210604_F1_C1'),'linewidth',2);
set(findobj(ax_hi,'DisplayName','210604_F1_C1'),'linewidth',2);
set(findobj(ax_lo,'DisplayName','210604_F1_C1'),'linewidth',2);

averagePDFs(ax_pdf,[-150 151]);
averagePDFs(ax_hi,[-150 151]);
averagePDFs(ax_lo,[-150 151]);


%% Aim 2.1: compare the sensory responses in two slow neurons.

measuretablestem = 'LEDFlashWithPiezoCueControl_%s_MeasureTable.mat';
fpstem = regexprep(measuretablestem,'MeasureTable','ForceProbe');

sens_cmp_fig = figure;
sens_cmp_fig.Position = [680 199 560 779];
ax_pre_ext = subplot(2,2,1,'parent',sens_cmp_fig); ax_pre_ext.NextPlot = 'add';
ax_delta_ext = subplot(2,2,2,'parent',sens_cmp_fig); ax_delta_ext.NextPlot = 'add';
ax_pre_flx = subplot(2,2,3,'parent',sens_cmp_fig); ax_pre_flx.NextPlot = 'add';
ax_delta_flx = subplot(2,2,4,'parent',sens_cmp_fig); ax_delta_flx.NextPlot = 'add';

for c_ind = 5:6
    CellID = T_cell.CellID{c_ind};
    [T,bT,fp] = loadTableAndFPMatrix(CellID);
    
    hitarget = [mode(bT.target1(bT.hiforce)) 0];
    hitarget(2) = mode(bT.target2(bT.target1==hitarget(1)));
    lotarget = [mode(bT.target1(~bT.hiforce)) 0];
    lotarget(2) = mode(bT.target2(bT.target1==lotarget(1)));
    goodblocks = sort(...
        [bT.block(bT.target1==hitarget(1) & bT.target2==hitarget(2));
        bT.block(bT.target1==lotarget(1) & bT.target2==lotarget(2))]);
    
    isgoodblck =  arrayfun(@(x)ismember(x,goodblocks),T.block);
    % plot
    fpgood = fp(:,isgoodblck);
    
    % All Lo or Hi trials
    ttl_stem = 'Lo %gV';
    pre_lo = [0 0];
    post_lo = [0 0];
    delta_lo = [0 0];
    delta_off_lo = [0 0];
    stps = [-5 5];
    for stp = [-5 5]
        idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp & isgoodblck;
        ttl = sprintf(ttl_stem,stp);
        %[fig] = plotPiezoStepResponse(T(idx,:),ttl);
        %[fig] = plotPiezoStepSpikes(T(idx,:),ttl);
        [fig,pre,post,delta_max,delta_min] = plotPiezoStepFiringRate(T(idx,:),ttl);
        frax = findobj(fig,'type','axes','tag','frax');
        frax.YLim = [0 100];
        frax.XLim = [-.85 -0.1];
        posax = findobj(fig,'type','axes','tag','posax');
        posax.YLim = [-max(T.target2(isgoodblck)) -min(T.target1(isgoodblck))];

        s = find(stp==stps);
        pre_lo(s) = pre;
        post_lo(s) = post;
        if s==1
            delta_lo(s) = delta_max;
            delta_off_lo(s) = delta_min;
        elseif s==2
            delta_lo(s) = delta_min;            
            delta_off_lo(s) = delta_max;
        end
    end
    
    ttl_stem = 'Hi %gV';
    pre_hi = [0 0];
    post_hi = [0 0];
    delta_hi = [0 0];
    delta_off_hi = [0 0];
    for stp = [-5 5]
        idx = T.outcome == 1 & T.hiforce & T.displacement == stp & isgoodblck;
        ttl = sprintf(ttl_stem,stp);
        [fig,pre,post,delta_max,delta_min] = plotPiezoStepFiringRate(T(idx,:),ttl);
        frax = findobj(fig,'type','axes','tag','frax');
        frax.YLim = [0 100];
        frax.XLim = [-.85 -0.1];
        posax = findobj(fig,'type','axes','tag','posax');
        posax.YLim = [-max(T.target2(isgoodblck)) -min(T.target1(isgoodblck))];

        s = find(stp==stps);
        pre_hi(s) = pre;
        post_hi(s) = post;
        if s==1
            delta_hi(s) = delta_max;
            delta_off_hi(s) = delta_min;
        elseif s==2
            delta_hi(s) = delta_min;            
            delta_off_hi(s) = delta_max;
        end
    end
    
    % compare sensory responses to high and lo
    plot(ax_pre_ext,[1,2],[pre_lo(1) pre_hi(1)],'.-');
    plot(ax_delta_ext,[1,2],[delta_lo(1) delta_hi(1)],'.-');
    plot(ax_pre_flx,[1,2],[pre_lo(2) pre_hi(2)],'.-');
    plot(ax_delta_flx,[1,2],[delta_lo(2) delta_hi(2)],'.-');

%     pre_lo
%     delta_lo
%     pre_hi
%     delta_hi
    
end
figure(sens_cmp_fig)

%% Aim 3.1: for the premotor neuron we have,210302_F1_C1
% pull out the reaching trials, show a few. For all the trials in which
% spike rate was zero, plot starting and ending forces.

% closeLook_210302_F1_C1_HCGal4_unknown, line 318


%% ************ functions ***********
function [x_,y_] = cummulativeEnvelope(x)
    x = sort(x(:));
    y = (1:length(x))'./length(x);
    [x_,Ix,Ix_] = unique(x,'last');
    y_ = y(Ix);
end

function [cdf_total,pdf_total] = smoothCummulative(x,xq)
[x_,y_] = cummulativeEnvelope(x);
if xq(1)<x_(1)
    x_ = [xq(1);x_];
    y_ = [0;y_];
end
if xq(end)>x_(end)
    x_ = [x_;xq(end)];
    y_ = [y_;1];
end

cdf_total = pchip(x_,y_,xq);
cdf_total(xq<x_(find(y_>0,1,'first'))) = 0;
cdf_total(xq>find(y_>0,1,'last')) = 1;
pdf_total = diff(cdf_total);
end


function obj = averagePDFs(ax_pdf,lims)
ls = findobj(ax_pdf,'type','line','linewidth',.5);
x = round(ls(1).XData);
x = x(x>=lims(1)&x<=lims(2));

bins = x;
pdfs = zeros(6,length(x));
for l_idx = 1:length(ls)
    x = round(ls(l_idx).XData);
    l = x>=lims(1)&x<=lims(2);
    y = ls(l_idx).YData;
    try pdfs(l_idx,:) = y(l);
    catch e
        if max(x(l))>=150
            pdfs(l_idx,size(pdfs,2)-length(y(l))+1:end) = y(l);
        else
            pdfs(l_idx,1:length(y(l))) = y(l);
        end
    end
end
pdf_bar = mean(pdfs,1);
pdf_total = pdf_bar/sum(pdf_bar);
obj = plot(ax_pdf,bins,pdf_total,'linewidth',1);
end