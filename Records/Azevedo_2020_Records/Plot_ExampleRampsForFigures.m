% Got some good neurons to show off

% '190116_F3_C1'
% '181205_F1_C1';
% '181127_F2_C1'
CellIDs = {
    '190116_F3_C1';
    '181205_F1_C1';
    '181127_F2_C1'
    };

positions = [0];
speeds = [50 100 150]; % interested in 150 100 50

clrs = [0 0 0
    .6 .6 .6];
lghtclrs = [.2 1 .2
    .7 1 .7];
stimclrs = [0 0 1
    .7 .7 1];

fig = figure;
fig.Position = [725          96        1175         880];
figure(fig);
set(fig,'color',[1 1 1])
panl = panel(fig);

hdivisions = [1 1 1 1]; hdivisions = num2cell(hdivisions/sum(hdivisions));
vdivisions = speeds*0+1; vdivisions = num2cell(vdivisions/sum(vdivisions));

panl.pack('h',hdivisions)  % response panel, stimulus panel
panl.margin = [10 10 2 10];
panl.fontname = 'Arial';

clear axs axl
axs = gobjects(length(hdivisions),length(vdivisions));
for c_idx = 1:(length(CellIDs)+1)
    panl(c_idx).pack('v',vdivisions);
    panl(c_idx).de.margin = [4 4 4 4];
    for s_idx = 1:length(speeds)
        panl(c_idx,s_idx).pack('v',{3/4 1/4});
        ax = panl(c_idx,s_idx,2).select(); ax.NextPlot = 'add'; %ax.Visible = 'off';
        ax = panl(c_idx,s_idx,1).select(); ax.NextPlot = 'add';
        axs(c_idx,s_idx) = ax;
    end
end
set(axs,'visible','off')

%% Fast and intermediate, average responses

for c_idx = 1:2 %length(positions)
    T_Cell = T_RampAndStep(strcmp(T_RampAndStep.CellID,CellIDs{c_idx}),:);
    
    posidx = T_Cell.Position == 0;
    
    for s_idx = 1:length(speeds)
        
        spdidx = T_Cell.Speed(:)==speeds(s_idx);
        
        for dsp = [-10 10]
            dspidx = T_Cell.Displacement(:)==dsp;
            
            ridx = posidx & spdidx &dspidx; % & sidx;
            
            Row = T_Cell(ridx,:);
            group = Row.Trialnums{:};
            
            trialStem = fullfile(fileparts(Row.TableFile{:}),[Row.Protocol{:} '_Raw_' Row.CellID{:} '_%d.mat']); trialStem = regexprep(trialStem,'\\','\\\');
            trial = load(sprintf(trialStem,group(1)));
            t = makeInTime(trial.params); t = t(:)';
            v_ = nan(length(t),length(group));
            % spikes_ = v_;
            
            for cnt = 1:length(group)
                trial = load(sprintf(trialStem,group(cnt)));
                if isfield(trial,'excluded') && trial.excluded
                    continue
                end
                v_(:,cnt) = trial.voltage_1;
                
            end
            
            v = nanmean(v_,2);
            base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            if dsp==-10
                base0 = base;
            end
            %v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            
            ax = panl(c_idx,s_idx,1).select(); ax.NextPlot = 'add';
            
            %panl(c_idx,s_idx).title(sprintf('v=%d',speeds(s_idx)));
            %plot(ax,t,v_(:,1),'color',lghtclrs((sign(dsp)+1)/2+1,:));
            plot(ax,t,v-base0,'color',clrs((sign(dsp)+1)/2+1,:));
            % plot(ax1,[t(1) t(find(t<0,1,'last'))],T_Cell.Rest(ridx)*[1 1],'Color',[.8 .8 .8]);
            % plot(ax1,t,fr);
            % plot(ax1,t(idx),T_Cell.Peak(ridx),'o');
            
            ax.XLim = [t(1) t(end)];
            ax = panl(c_idx,s_idx,2).select(); ax.NextPlot = 'add'; ax.Visible = 'off';
            plot(ax,t,PiezoRampStim(trial.params)+trial.params.displacementOffset,'color',stimclrs([-10 10]==dsp,:));
            
            %plot(ax2,v(twind),fr(twind));
            drawnow
            %pause();
            %pause(.02)
            
        end
    end
end

%%

set(axs(1,:),'ylim',[-.8 4.2])
set(axs(2,:),'ylim',[-.8 4.2])

set(axs(1,1),'visible','on','tickdir','out')
set(axs(1,1),'xcolor',[1 1 1],'xtick',[])
set(axs(1,end),'xcolor',[0 0 0],'xtick',[0 .5])

set(axs(2,1),'visible','on','tickdir','out')
set(axs(2,1),'xcolor',[1 1 1],'xtick',[])


%% Slow, average responses

c_idx = 3;

T_Cell = T_RampAndStep(strcmp(T_RampAndStep.CellID,CellIDs{c_idx}),:);

posidx = T_Cell.Position == 0;

for s_idx = 1:length(speeds)
    
    spdidx = T_Cell.Speed(:)==speeds(s_idx);
    
    for dsp = [-10 10]
        dspidx = T_Cell.Displacement(:)==dsp;
        
        ridx = posidx & spdidx &dspidx; % & sidx;
        
        Row = T_Cell(ridx,:);
        group = Row.Trialnums{:};
        
        trialStem = fullfile(fileparts(Row.TableFile{:}),[Row.Protocol{:} '_Raw_' Row.CellID{:} '_%d.mat']); trialStem = regexprep(trialStem,'\\','\\\');
        trial = load(sprintf(trialStem,group(1)));
        t = makeInTime(trial.params); t = t(:)';
        v_ = nan(length(t),length(group));
        spikes_ = v_;
        
        ax = panl(c_idx+1,s_idx,1).select();
        for cnt = 1:length(group)
            trial = load(sprintf(trialStem,group(cnt)));
            if isfield(trial,'excluded') && trial.excluded
                continue
            end
            v_(:,cnt) = trial.voltage_1;
            N = -sign(dsp)*cnt;
            ticks = raster(ax,t(trial.spikes),N+[-.4 .4]);
            set(ticks,'Color',clrs((sign(dsp)+1)/2+1,:))
            spikes_(:,cnt) = 0;
            spikes_(trial.spikes,cnt) = 1;
        end
        
        v = nanmean(v_,2);
        base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
        
        %v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
        
        ax = panl(c_idx,s_idx,1).select(); ax.NextPlot = 'add';        
        plot(ax,t,v_(:,1),'color',clrs((sign(dsp)+1)/2+1,:));        
        ax.XLim = [t(1) t(end)];
        
        ax = panl(c_idx,s_idx,2).select(); ax.NextPlot = 'add'; ax.Visible = 'off';
        plot(ax,t,PiezoRampStim(trial.params)+trial.params.displacementOffset,'color',stimclrs([-10 10]==dsp,:));
        ax.XLim = [t(1) t(end)];
        
        ax = panl(c_idx+1,s_idx,2).select(); ax.NextPlot = 'add'; ax.Visible = 'on';
        ax.YLim = [0 125];
        ax.TickDir = 'out';
        ax.XTick = [];

        DT = 10/300;
        fr = firingRate(t,spikes_,DT);
        rest = mean(fr(t<0));
        plot(ax,t,fr,'color',clrs((sign(dsp)+1)/2+1,:));
        ax.XLim = [t(1) t(end)];

        %plot(ax2,v(twind),fr(twind));
        drawnow
        %pause();
        %pause(.02)
                
    end
end

%%

set(axs(3,:),'ylim',[-45 -25])

set(axs(3,:),'visible','on','tickdir','out')
set(axs(3,:),'xcolor',[1 1 1],'xtick',[])

%%
panl.marginleft=18;