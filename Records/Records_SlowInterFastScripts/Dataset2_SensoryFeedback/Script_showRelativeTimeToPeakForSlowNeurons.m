
speedclrs = [
.7 1 .7
.2 1 .2
0 .7 0
0 .4 0
    ]; 

rampVsPosF = figure;
% rampVsPosF.Position = [680 80 1177 898];
panl = panel(rampVsPosF);
panl.pack({1});
panl.margin = [18 18 10 10];
panl.fontname = 'Arial';
ax = panl(1).select(); ax.NextPlot = 'add';

L = 419.9858; %um, approximate length of lever arm
T_RmpStpSlowFR_noIav = T_RmpStpSlowFR(~contains(T_RmpStpSlowFR.Genotype,'iav-LexA'),:);
T_RampAndStep_slow = T_RampAndStep(~contains(T_RampAndStep.Genotype,'iav-LexA')&strcmp(T_RampAndStep.Cell_label,'slow'),:);

cellids = unique(T_RampAndStep_slow.CellID);
positions = unique(T_RampAndStep_slow.Position); positions = positions(positions<Inf);
speeds = unique(T_RampAndStep_slow.Speed); speeds = speeds(speeds<400);
displacement = -10;
didx = T_RampAndStep_slow.Displacement==displacement;
for cellid = cellids'
    cidx = strcmp(T_RampAndStep_slow.CellID,cellid{1});
    for position = positions'
        pidx = T_RampAndStep_slow.Position==position;
        for speed = speeds'
            sidx = T_RampAndStep_slow.Speed == speed;
            ridx = cidx&pidx&sidx & didx;
            if ~sum(ridx)
                continue;
            end
            VmRow = T_RampAndStep_slow(ridx,:);
            FRRow = T_RmpStpSlowFR_noIav(ridx,:);
            clridx = find(speeds==speed);
            plot(ax,VmRow.TimeToPeak,FRRow.TimeToPeak,'.','color',speedclrs(clridx,:));
            
        end
    end
end
plot(ax,[0 .4],[0 .4],'color',[.8 .8 .8])
ax.YLabel.String = 'Time to FR peak (s)';
ax.XLabel.String = 'Time to V_m peak (s)';

%%
% Pick good neurons
CellID = '181127_F2_C1';

clrs = [0 0 0
    .6 .6 .6];
lghtclrs = [.2 1 .2
    .7 1 .7];
stimclrs = [0 0 1
    .7 .7 1];

speedclrs = [
.7 1 .7
.2 1 .2
0 .7 0
0 .4 0
    ]; 

rampVsPosF = figure;
% rampVsPosF.Position = [680 80 1177 898];
panl = panel(rampVsPosF);
panl.pack({1});
panl.margin = [18 18 10 10];
panl.fontname = 'Arial';
ax = panl(1).select(); ax.NextPlot = 'add';

cidx = strcmp(T_RampAndStep_slow.CellID,CellID);
pidx = T_RampAndStep_slow.Position==0;
speeds = unique(T_RampAndStep_slow.Speed); speeds = speeds(speeds<400);
displacement = -10;
didx = T_RampAndStep_slow.Displacement==displacement;

for speed = speeds'
    sidx = T_RampAndStep_slow.Speed == speed;
    ridx = cidx&pidx&sidx & didx;
    clridx = find(speeds==speed);
    if ~sum(ridx)
        continue;
    end
    VmRow = T_RampAndStep_slow(ridx,:);
    FRRow = T_RmpStpSlowFR_noIav(ridx,:);

    group = VmRow.Trialnums{:};
    if isempty(group)
        continue
    end
    trialStem = fullfile(fileparts(Row.TableFile{:}),[Row.Protocol{:} '_Raw_' Row.CellID{:} '_%d.mat']); trialStem = regexprep(trialStem,'\\','\\\');
    trial = load(sprintf(trialStem,group(1)));
    t = makeInTime(trial.params); t = t(:)';
    twind = t > -.01 & t < trial.params.stimDurInSec - abs(VmRow.Displacement)/VmRow.Speed;

    v_ = nan(length(t),length(group));
    spikes_ = v_;
    
    for cnt = 1:length(group)
        trial = load(sprintf(trialStem,group(cnt)));
        if isfield(trial,'excluded') && trial.excluded
            continue
        end
        if ~isfield(trial,'spikes') || isempty(trial.spikes)
            continue
        end
        v_(:,cnt) = trial.voltage_1;
        
        spikes_(:,cnt) = 0;
        spikes_(trial.spikes,cnt) = 1;
    end
    if all(isnan(v_(:)))
        % all the trials were excluded
        continue
    end
    
    v = nanmean(v_,2);
    v = smooth(v,400);
    base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
    %v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
    DT = 10/300;
    fr = firingRate(t,spikes_,10/300);
    
    plot(ax,v(twind),fr(twind),'color',speedclrs(clridx,:));    
end
ax.YLabel.String = 'FR (Hz)';
ax.XLabel.String = 'V_m (mV)';


