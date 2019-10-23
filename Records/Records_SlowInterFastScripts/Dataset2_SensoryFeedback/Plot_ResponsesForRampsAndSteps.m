% Pick good neurons

% CellID = '181205_F1_C1';
positions = [-150 75 0 75 150];
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

hdivisions = positions*0+1; hdivisions = num2cell(hdivisions/sum(hdivisions));
vdivisions = speeds*0+1; vdivisions = num2cell(vdivisions/sum(vdivisions));

panl.pack('h',hdivisions)  % response panel, stimulus panel
panl.margin = [10 10 2 10];
panl.fontname = 'Arial';
% panl(1).marginbottom = 2;
clear axs axl
axs = gobjects(length(hdivisions),length(vdivisions));
for p_idx = 1:length(positions)
    panl(p_idx).pack('v',vdivisions);
    panl(p_idx).de.margin = [4 4 4 4];
    for s_idx = 1:length(speeds)        
        panl(p_idx,s_idx).pack('v',{3/4 1/4});
        ax = panl(p_idx,s_idx,2).select(); ax.NextPlot = 'add'; %ax.Visible = 'off';
        ax = panl(p_idx,s_idx,1).select(); ax.NextPlot = 'add';
        axs(p_idx,s_idx) = ax;
    end
end
set(axs,'visible','off')

T_Cell = T_RampAndStep(strcmp(T_RampAndStep.CellID,CellID),:);

for p_idx = 1:length(positions)
    position = positions(p_idx);
    posidx = T_Cell.Position == position;
    panl(p_idx).pack('v',vdivisions);
    panl(p_idx).de.margin = [4 4 4 4];
    
    for s_idx = 1:length(speeds)
        
        spdidx = T_Cell.Speed(:)==speeds(s_idx);
        
        for dsp = [-10 10]
            dspidx = T_Cell.Displacement(:)==dsp;
        
            ridx = posidx & spdidx &dspidx; % & sidx;
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
            v_ = nan(length(t),length(group));
            % spikes_ = v_;
        
            for cnt = 1:length(group)
                trial = load(sprintf(trialStem,group(cnt)));
                if isfield(trial,'excluded') && trial.excluded
                    continue
                end
                v_(:,cnt) = trial.voltage_1;
                
            end
            if all(isnan(v_(:)))
                continue
            end
        
            v = nanmean(v_,2);
            base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            %v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));

            ax = panl(p_idx,s_idx,1).select(); ax.NextPlot = 'add';
            
            panl(p_idx,s_idx).title(sprintf('v=%d',speeds(s_idx))); 
            plot(ax,t,v_(:,1),'color',lghtclrs((sign(dsp)+1)/2+1,:));
            plot(ax,t,v,'color',clrs((sign(dsp)+1)/2+1,:));
            % plot(ax1,[t(1) t(find(t<0,1,'last'))],T_Cell.Rest(ridx)*[1 1],'Color',[.8 .8 .8]);
            % plot(ax1,t,fr);
            % plot(ax1,t(idx),T_Cell.Peak(ridx),'o');
            
            ax.XLim = [t(1) t(end)];
            ax = panl(p_idx,s_idx,2).select(); ax.NextPlot = 'add'; ax.Visible = 'off';
            plot(ax,t,PiezoRampStim(trial.params)+trial.params.displacementOffset,'color',stimclrs([-10 10]==dsp,:));
            
            %plot(ax2,v(twind),fr(twind));
            drawnow
            %pause();
            %pause(.02)
            
        end
    end
end
ylims = [
    -61 -51
    -50 -40];
set(axs,'ylim',ylims(strcmp({'fast','intermediate'},Row.Cell_label),:))
set(axs,'ylim',ylims(strcmp({'fast','intermediate'},Row.Cell_label),:))
set(axs(1,:),'visible','on')
set(axs(1,:),'xcolor',[1 1 1])

