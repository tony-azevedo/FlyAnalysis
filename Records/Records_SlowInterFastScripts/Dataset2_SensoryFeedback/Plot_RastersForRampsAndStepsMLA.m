% Pick good neurons
% CellID = '181128_F2_C1';
positions = [-150 -75 0 75 150];
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

hdivisions = [1 1 1 1 1]; hdivisions = num2cell(hdivisions/sum(hdivisions));
vdivisions = speeds*0+1; vdivisions = num2cell(vdivisions/sum(vdivisions));

panl.pack('h',hdivisions)  % response panel, stimulus panel
panl.margin = [10 10 2 10];
panl.fontname = 'Arial';
% panl(1).marginbottom = 2;
clear axs axl
axs = gobjects(length(hdivisions),length(vdivisions));
axs2 = gobjects(length(hdivisions),length(vdivisions));
for m_idx = 1:length(hdivisions)
    panl(m_idx).pack('v',vdivisions);
    panl(m_idx).de.margin = [4 4 4 4];
    for s_idx = 1:length(speeds)        
        panl(m_idx,s_idx).pack('v',{3/4 1/4});
        ax = panl(m_idx,s_idx,2).select(); ax.NextPlot = 'add'; ax.Visible = 'off';             
        axs2(m_idx,s_idx) = ax;
        if m_idx == 1   
            % panl(p_idx,s_idx,2).title(sprintf('v=%d',speeds(s_idx))); 
            ax.Visible = 'on';
            ax.XColor = [1 1 1];
            ax.YLim = [0 50];
        end

        ax = panl(m_idx,s_idx,1).select(); ax.NextPlot = 'add'; 

        axs(m_idx,s_idx) = ax;
    end
end
title(axs(1,1),'Control')
title(axs(2,1),'MLA')
set(axs,'visible','off')


T_Cell = T_RmpStpSlowFR(strcmp(T_RmpStpSlowFR.CellID,CellID),:);
posidx = T_Cell.Position == 0;
mlaidx = T_Cell.mla;
T_Cell = T_Cell(posidx|mlaidx,:);

for m_idx = [0 1]
    mlaidx = T_Cell.mla==m_idx;
    
    for s_idx = 1:length(speeds)
        
        spdidx = T_Cell.Speed(:)==speeds(s_idx);
        
        for dsp = [-10 10]
            dspidx = T_Cell.Displacement(:)==dsp;
        
            ridx = mlaidx & spdidx &dspidx; 
            if ~sum(ridx)
                continue
            end
            
            Row = T_Cell(ridx,:);
            group = Row.Trialnums{:};
            if isempty(group)
                continue
            end
            trialStem = fullfile(fileparts(Row.TableFile{:}),[Row.Protocol{:} '_Raw_' Row.CellID{:} '_%d.mat']); trialStem = regexprep(trialStem,'\\','\\\');
            trial = load(sprintf(trialStem,group(1)));
            t = makeInTime(trial.params); t = t(:)';
            %v_ = nan(length(t),length(group));
            spikes_ = nan(length(t),length(group));
            rest = group*nan;
            
            twind = t>-trial.params.preDurInSec+.06;
            ax = panl(m_idx+1,s_idx,1).select(); 
            for cnt = 1:length(group)
                
                %% assume that the trials are in one group, first one is a little different
                % Does that trial determine the resting spike rate of the
                % rest? Answer, no, I don't think so, it's just higher!
                trial = load(sprintf(trialStem,group(cnt)));
                N = -sign(dsp)*cnt;
                if isfield(trial,'excluded') && trial.excluded
                    blanktrials = raster(ax,0,N+[-.4 .4]);
                    set(blanktrials,'linewidth',4,'color',[1 .7 .7]);
                    continue
                end
                if ~isfield(trial,'spikes') || isempty(trial.spikes)
                    blanktrials = raster(ax,0,N+[-.4 .4]);
                    set(blanktrials,'linewidth',4,'color',[1 .7 .7]);
                    continue
                end
                %v_(:,cnt) = trial.voltage_1;
                
                ticks = raster(ax,t(trial.spikes),N+[-.4 .4]);
                set(ticks,'Color',clrs((sign(dsp)+1)/2+1,:))
                spikes_(:,cnt) = 0;
                spikes_(trial.spikes,cnt) = 1;
                DT = 10/300;
                fr = firingRate(t,spikes_(:,cnt),10/300);
                
                 rest(cnt) = mean(fr(t<0&twind));
            end
            if all(isnan(rest))
                % all the trials were excluded
                continue
            end
        
            %             v = nanmean(v_,2);
            %             base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            %             %v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            %             DT = 10/300;
            %             fr = firingRate(t,spikes_,10/300);

            %plot(ax,t,v-base,'color',clrs((sign(dsp)+1)/2+1,:));
            %             plot(ax,[t(1) t(find(t<0,1,'last'))],T_Cell.Rest(ridx)*[1 1],'Color',[.8 .8 .8]);
            %             plot(ax,t,fr,'Color',clrs((sign(dsp)+1)/2+1,:));
            %             plot(ax,T_Cell.TimeToPeak(ridx),T_Cell.Peak(ridx),'ro');
 
            ax = panl(m_idx+1,s_idx,2).select(); ax.NextPlot = 'add'; ax.Visible = 'off';
            plot(ax,group,rest,'color',stimclrs([-10 10]==dsp,:),'linestyle','none','marker','.');
            ax.YLim = [10 80];

            %plot(ax2,v(twind),fr(twind));
            drawnow
            %pause();
            %pause(.02)
            
        end
    end
end
set(axs,'XLim',[t(1) t(end)]);
set(axs,'ylim',[-16 16])
set(axs2,'ylim',[10 80])
set(axs2(1,:),'visible','on')
set(axs2(1,:),'xcolor',[1 1 1])
% set(axs(1,:),'visible','on')
% set(axs(1,:),'xcolor',[1 1 1])

