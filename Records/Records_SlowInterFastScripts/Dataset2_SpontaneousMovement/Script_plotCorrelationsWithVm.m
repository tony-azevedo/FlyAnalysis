% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

CellID = T_StepCells.CellID;

figure
ax = subplot(1,5,1:4);
ax1 = subplot(1,5,5); ax1.NextPlot = 'add';
ax1.XLim = [0 4];

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

delays = nan(length(CellID),1);

for cidx = 1:length(CellID)
    cellid = CellID{cidx};
    T_Cell = T_Step(contains(T_Step.CellID,cellid),:);
    if contains(T_Cell.Genotype,'iav')
        continue
    end
    if contains(T_Cell.Genotype,'35C09')
        continue
    end


    posidx  = T_Cell.Position==0;
    dspidx = T_Cell.Displacement==-10;
    T_row = T_Cell(posidx&dspidx,:);
    
    group = T_row.Trialnums{1};
    
    Dir = fullfile('E:\Data',cellid(1:6),cellid);
    if ~exist(Dir,'dir')
        Dir = fullfile('F:\Acquisition',cellid(1:6),cellid);
    end
    cd(Dir);
    
    trialStem = [T_row.Protocol{1} '_Raw_' cellid '_%d.mat'];
    trial = load(fullfile(Dir,sprintf(trialStem,group(1))));
    t = makeInTime(trial.params); t = t(:)';
    
    ft = makeFrameTime(trial);

    v_ = nan(length(group),length(t));
    sgs_ = v_;
    for cnt = 1:length(group)
        trial = load(sprintf(trialStem,group(cnt)));
        if isfield(trial,'excluded') && trial.excluded
            continue
        end
        v_(cnt,:) = trial.voltage_1;
        sgs_(cnt,:) = trial.sgsmonitor;
        
        % downsample voltage by piling values into the frame times
        v = nan(size(ft));
        ft_ = [ft(1)-diff(ft(1:2)); ft];
        for i = 1:length(ft)
            v(i) = median(trial.voltage_1(t>ft_(i)&t<=ft_(i+1)));
        end

    end
    if all(isnan(v_(:)))
        continue
    end

    cc = cov(v-mean(v),trial.legPositions.Tibia_Angle-mean(trial.legPositions.Tibia_Angle));
    cc = corrcoef(v-mean(v),trial.legPositions.Tibia_Angle-mean(trial.legPositions.Tibia_Angle));

    
    sgs = nanmean(sgs_,1);
    velocity = diff(sgs(t>0&t<.01))/diff(t(1:2));
    speed = smooth(velocity);
    speed = max(speed*sign(displacement(D)));
    DT_step = abs(trial.params.displacement)/speed;
    DT_step = round((DT_step+trial.params.preDurInSec)*trial.params.sampratein)+1;
    DT_halfstep = trial.params.stimDurInSec/4; % the step time is too short, give it a sec before measuring area
    DT_halfstep = round((DT_halfstep+trial.params.preDurInSec)*trial.params.sampratein)+1;
    DT_return = trial.params.stimDurInSec-trial.params.stimDurInSec/4;
    DT_return = round((DT_return+trial.params.preDurInSec)*trial.params.sampratein)+1;


    v = nanmean(v_,1);
    % base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
    base = mean(v(t<0 &t>-.02));
    % v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
    v = v-mean(v(t<0 &t>-.02));

    [~,ttpk] = max(v(t>=0&t<t(DT_return)));
    ttpk = ttpk+sum(t<0);
    peak = mean(v(ttpk-5:ttpk+5));
    l1070 = t(:)'>0&t(:)'<t(ttpk) & v>peak*.1 & v<peak*.7;
    if contains(T_Cell.CellID,'190116_F3_C1')
        l1070 = t(:)'>0&t(:)'<t(ttpk) & v>peak*.1 & v<peak*.4;
    end

    v1070 = v(l1070);
    t1070 = t(l1070);
    coef = polyfit(t1070,v1070,1);
    delay = -coef(2)/coef(1);

    delays(cidx) =  -coef(2)/coef(1);
    
    cla(ax)
    groupid = [cellid ': [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
    title(ax,groupid); hold(ax,'on')
    plot(ax,t(t>-.03&t<0.2),sgs(:,t>-.03&t<0.2)/-10 * 3 + base,'color',[.7 .7 1]); hold(ax,'on')
    plot(ax,t(t>-.03&t<0.2),v_(:,t>-.03&t<0.2),'color',[1 .7 .7]); hold(ax,'on')
    plot(ax,t(t>-.03&t<.1),v(t>-.03&t<.1)+base,'color',[.7 0 0]); hold(ax,'on')
    plot(ax,t1070,(coef(1)*t1070+coef(2))+base,'color',[0 0 0],'LineWidth',2)
    plot(ax,[.001 0.012],(coef(1)*([.001 0.012])+coef(2))+base,'color',[1 1 1]*.5)
    plot(ax,[-.01 0.02],[1 1]*base,'color',[1 1 1]*.5)
    %plot(ax,t(ttpk),T_row.Peak+base,'bo');
    %plot(ax,t(DT_step),T_row.Peak_step+base,'co');
    plot(ax,delays(cidx),base,'ko');
    ax.YLim = base+[-2 6];
    ax.XLim = [-.01 0.02];
    
    lblidx = find(strcmp({'fast','intermediate','slow'},T_row.Cell_label));

    plot(ax1,lblidx,delay,'Linestyle','none','Marker','.','Markersize',18,'Color',clrs(lblidx,:));

    drawnow
end

ax1.YLim = [0 7]*1E-3;
%% Firing rate onset for slow neurons

% 
% for cidx = 1:length(CellID)
%     cellid = CellID{cidx};
%     T_Cell = T_Step(contains(T_Step.CellID,cellid),:);
%     if ~contains(T_Cell.Genotype,'35C09')
%         continue
%     end
%     if contains(T_Cell.Genotype,'iav')
%         continue
%     end
% 
%     posidx  = T_Cell.Position==0;
%     dspidx = T_Cell.Displacement==-10;
%     T_row = T_Cell(posidx&dspidx,:);
%     
%     group = T_row.Trialnums{1};
%     
%     Dir = fullfile('E:\Data',cellid(1:6),cellid);
%     if ~exist(Dir,'dir')
%         Dir = fullfile('F:\Acquisition',cellid(1:6),cellid);
%     end
%     cd(Dir);
%     
%     trialStem = [T_row.Protocol{1} '_Raw_' cellid '_%d.mat'];
%     trial = load(fullfile(Dir,sprintf(trialStem,group(1))));
%     t = makeInTime(trial.params); t = t(:)';
%     DT_step = abs(T_row.Displacement)/T_row.Speed;
%     DT_return = trial.params.stimDurInSec-DT_step;
%     DT_step = round((DT_step+trial.params.preDurInSec)*trial.params.sampratein)+1;
%     DT_return = round((DT_return+trial.params.preDurInSec)*trial.params.sampratein)+1;   
% 
%     v_ = nan(length(t),length(group));
%     spikes_ = v_;
%     
%     for cnt = 1:length(group)
%         trial = load(sprintf(trialStem,group(cnt)));
%         if isfield(trial,'excluded') && trial.excluded
%             continue
%         end
%         if ~isfield(trial,'spikes')
%             continue
%         end
%         v_(:,cnt) = trial.voltage_1;
%         
%         spikes_(:,cnt) = 0;
%         spikes_(trial.spikes,cnt) = 1;
%         
%     end
%     if all(isnan(v_(:)))
%         continue
%     end
%     % ignore the prepulse
%     twind = t>-trial.params.preDurInSec+.06;
%     
%     DT = 10/300;
%     fr = firingRate(t,spikes_,10/300);
%     
%     [~,ttpk] = max(fr(t>0 & t<t(DT_return)));
%     ttpk = ttpk+trial.params.preDurInSec*trial.params.sampratein+1;
%     rest = mean(fr(twind & t<0));
% 
%     peak = mean(fr(ttpk+[-10 10]));
%     l1070 = t(:)>0&t(:)<t(ttpk) & fr>peak*.1 & fr<peak*.7;
%     fr1070 = fr(l1070);
%     t1070 = t(l1070);
%     coef = polyfit(t1070,fr1070,1);
%     delay = -coef(2)/coef(1);
% 
%     delays(cidx) =  -coef(2)/coef(1);
%     
%     cla(ax)
%     groupid = [cellid ': [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
%     title(ax,groupid); hold(ax,'on')
%     plot(ax,t(t>-.03&t<.1),fr(t>-.03&t<.1)+base,'color',[1 .7 .7]); hold(ax,'on')
%     plot(ax,t1070,(coef(1)*t1070+coef(2))+base,'color',[0 0 0],'LineWidth',2)
%     plot(ax,[.001 0.012],(coef(1)*([.001 0.012])+coef(2))+base,'color',[1 1 1]*.5)
%     plot(ax,[-.01 0.02],[1 1]*base,'color',[1 1 1]*.5)
%     plot(ax,delays(cidx),base,'ko');
%     ax.YLim = base+[-2 6];
%     ax.XLim = [-.01 0.02];
%     
%     lblidx = find(strcmp({'fast','intermediate','slow'},T_row.Cell_label));
% 
%     plot(ax1,lblidx,delay,'Linestyle','none','Marker','.','Markersize',18,'Color',clrs(lblidx,:));
% 
%     drawnow
% end