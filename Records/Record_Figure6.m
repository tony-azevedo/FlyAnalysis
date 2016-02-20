%% Record_Figure6 - Vm measurements, spiking 
close all
savedir = '/Users/tony/Dropbox/RAnalysis_Data/Record_FS';
if ~isdir(savedir)
    mkdir(savedir)
end

Scripts = {
    'Script_Vm_HighFreqDepolB1s'
    'Script_Vm_BandPassHiB1s'
    'Script_Vm_BandPassLowB1s'
    'Script_Vm_LowPassB1s'
    };

figure6 = figure;
figure6.Units = 'inches';
set(figure6,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneColumn') 10]);
pnl = panel(figure6);
pnl.margin = [16 16 4 4];

figurerows = [2 2 5];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);

pnl(1).pack('h',{1/3 2/3})
pnl(1,2).pack('h',{1/2 1/2})
pnl(1,2).margin = [8 4 4 4];

%% Vm
% 
ax = pnl(1,1).select();
hold(ax,'on');
for cell_type = 1:length(Scripts)

    eval(Scripts{cell_type});
    
    for ac_ind = 1:length(analysis_cell)
        ac = analysis_cell(ac_ind);
        
        if isempty(ac.SweepTrial)
            continue
        end
        fprintf('%s: ',ac.name)
        trial = load(ac.SweepTrial);
        h = getShowFuncInputsFromTrial(trial);
        
        trials = findLikeTrials('name',trial.name,'datastruct',h.prtclData);
        trials = excludeTrials('trials',trials,'name',trial.name);
        
        x = makeInTime(trial.params);
        
        voltage = trials;
        for t_ind = 1:length(trials);
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
            switch h.currentPrtcl
                case 'Sweep'
                    voltage(t_ind) = mean(trial.voltage(x>0.1));
                otherwise
                    yymmdd = trial.name(regexp(trial.name,'\\\d\d\d\d\d\d','once')+(1:6));
                    if datenum(yymmdd,'yymmdd')<datenum('28-April-2015')
                        voltage(t_ind) = mean(trial.voltage(x<0));
                    else
                        voltage(t_ind) = mean(trial.voltage(x<0 & x>x(1)+.07));
                    end
                    
            end
        end
        
        Vm = mean(voltage);
        fprintf('%.2f\n',Vm)
        
        plot(ax,cell_type,Vm,'ok','displayname',ac.name,'tag',ac.genotype)
        
    end

end

Vm = [];
Vm_group = [];

for x = 1:length(Scripts)
l = findobj(ax,'type','line','xdata',x);
v_ = cell2mat(get(l,'ydata')); 
Vm = [Vm;v_];
Vm_group = [Vm_group;x*ones(size(v_,1),1)];
line(x+[-.2 .2],[mean(v_) mean(v_)],'parent',ax);
text(x,-28,['N=' num2str(length(l))],'parent',ax,'horizontalalignment','center');
end

% [p,tbl,stats] = anova1(Vm,Vm_group)
% [p,tbl,stats] = anova1(Vm(Vm_group==2|Vm_group==3),Vm_group(Vm_group==2|Vm_group==3))
% [p,tbl,stats] = anova1(Vm(Vm_group~=1),Vm_group(Vm_group~=1))
% [h,p] = ttest2(Vm(Vm_group==2),Vm(Vm_group==3))

set(ax,'xlim',[.5 4.5],'ylim',[-51 -25],'xtick',[1 2 3 4],'xticklabel',{'A2' 'BPH' 'BPL' 'LP'   })
ylabel(ax,'V_m (mV)');

% % barfig = figure;
% % set(barfig,'color',[1 1 1],'units','inches','position',[1 3 10 3.7],'name','Summary_Vm_Box');
% % 
% % pnl_stats = panel(barfig);
% % pnl_stats.margin = [20 20 10 10];
% % pnl_stats.pack('h',1);
% % 
% % to_ax = pnl_stats(1).select(); hold(to_ax,'on');
% % boxplot(to_ax,Vm,Vm_group,'plotstyle','traditional','notch','on');
% % 
% % 
% % figure
% % [p,tbl,stats] = anova1(Vm,Vm_group);
% % multcompare(stats);


%% Spiking

Script_Vm_BandPassHiB1s

ax_sweep = pnl(1,2,1).select();
trial = load(example_cell.SweepTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin),trial.voltage(xwin),'parent',ax_sweep,'color',[0 0 0])
axis(ax_sweep,'tight');
text(example_cell.SpikeInterval(1)+.05*diff(example_cell.SpikeInterval),-20,[num2str(round(mean(trial.current))) ' pA'],'parent',ax_sweep)

ax_spike = pnl(1,2,2).select();
trial = load(example_cell.SpikeTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin),trial.voltage(xwin),'parent',ax_spike,'color',[0 0 0])
axis(ax_spike,'tight');

text(example_cell.SpikeInterval(1)+.05*diff(example_cell.SpikeInterval),-20,[num2str(round(mean(trial.current))) ' pA'],'parent',ax_spike)

set([ax_sweep ax_spike],'ylim',[-90 0],'xcolor',[1 1 1],'xtick',[],'tickdir','out');
set([ ax_spike],'ycolor',[1 1 1],'ytick',[]);

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure6/';
savePDF(figure6,savedir,[],['Figure6_' example_cell.name]);


%% Cell-Attached
% Could also look at all the neurons in which we didn't see a spike during
% the seal test, before breaking in.
% Record_CellAttachedB1
gh298_trials = {
'C:\Users\tony\Raw_Data\130930\130930_F1_C1\Sweep_Raw_130930_F1_C1_1.mat' % GH298
%'C:\Users\tony\Raw_Data\130930\130930_F1_C2\Sweep_Raw_130930_F1_C2_4.mat' % GH298
'C:\Users\tony\Raw_Data\Archive\25-Jun-2013\25-Jun-2013_F1_C1\Sweep_Raw_25-Jun-2013_F1_C1_1.mat' % GH298
};

gh86_trials = {
'C:\Users\tony\Raw_Data\131022\131022_F1_C1\Sweep_Raw_131022_F1_C1_2.mat' % BS
'C:\Users\tony\Raw_Data\131112\131112_F1_C1\Sweep_Raw_131112_F1_C1_3.mat' % BS
'C:\Users\tony\Raw_Data\131112\131112_F1_C2\Sweep_Raw_131112_F1_C2_3.mat' % GH86

'C:\Users\tony\Raw_Data\131112\131112_F3_C1\Sweep_Raw_131112_F3_C1_3.mat' % BS
};

pnl(2).pack('h',{1/2 2/2})
pnl(2).margin = [4 4 4 4];
pnl(2,1).pack('v',{1/2 1/2})
pnl(2,1).margin = [4 4 4 4];

for tr = 1:length(gh298_trials)
    trial = load(gh298_trials{tr});
    t = makeInTime(trial.params);
    c = trial.current(1:length(t));
    ax = pnl(2,1,tr).select();
        
    c = (c - mean(c(t<1)))/(std(c(t<1)));
    line(t,c,'parent',ax,...
        'color',[0 0 0],...
        'Displayname',getFlyGenotype(trial.name));
    set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(ax,'ylim',[-20 10])
    set(ax,'xlim',[0 1])
    
    % This is for the strange neurons
%     if x == 3 && y== 8
%         set(ax,'ylim',[-10 5])
%     end
%     if x == 2 && y== 8
%         set(ax,'ylim',[-10 5])
%     end
end

pnl(2,2).pack('v',{1/4 1/4 1/4 1/4})
pnl(2,2).margin = [4 4 4 4];
for tr = 1:length(gh86_trials)
    trial = load(gh86_trials{tr});
    t = makeInTime(trial.params);
    c = trial.current(1:length(t));
    ax = pnl(2,2,tr).select();
        
    c = (c - mean(c(t<1)))/(std(c(t<1)));
    line(t,c,'parent',ax,...
        'color',[0 0 0],...
        'Displayname',getFlyGenotype(trial.name));
    set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(ax,'ylim',[-20 10])
    set(ax,'xlim',[0 1])
    
    % This is for the strange neurons
%     if x == 3 && y== 8
%         set(ax,'ylim',[-10 5])
%     end
%     if x == 2 && y== 8
%         set(ax,'ylim',[-10 5])
%     end
end

%% ArcLight figure

Record_ArcLightImaging_Cells
fn = fullfile('C:\Users\tony\Dropbox\RAnalysis_Data\Record_ArcLightImaging\NoCorrection','Break_in_output.mat');
if exist(fn,'file')==2
    load(fn);
else
keyboard
end

pnl(3).pack('v',{1/2 1/2})
pnl(3,1).pack('h',{4/9 5/9});
pnl(3,1,2).pack('v',{2/5 2/5 1/5});
pnl(3,1).margin = [4 16 4 4];
pnl(3,1,2).margin = [4 4 4 4];
pnl(3,1,2,1).margin = [4 4 4 4];
pnl(3,1,2,2).margin = [4 4 4 4];
pnl(3,1,2,3).margin = [4 4 4 4];

ax1 = pnl(3,1,2,1).select();
% c_ind = 2; breakin_offset = 0;  % 140121_F2_C1 sound responsive
% % c_ind = 11; breakin_offset = 0; % 150119_F1_C1 NOT SURE!!
% % c_ind = 1; breakin_offset = 0; % 140117_F2_C1 sound responsive
%  c_ind = 4; breakin_offset = 0; % 140206_F1_C1 same currents
 c_ind = 15; breakin_offset = 0.04; % 140206_F1_C1 same currents

disp(analysis_cell(c_ind).name)
trial = load(analysis_cell(c_ind).exampletrials{1});
% Bring up the quickShow_sweep Fig
sweepfig = figure;
UnabridgedSweep(sweepfig,getShowFuncInputsFromTrial(trial),'Save','BGCorrectImages',false);

inax = findobj(sweepfig,'tag','quickshow_dFoverF_ax');
l = copyobj(findobj(inax,'type','line'),ax1);
et = get(l,'xdata');
et = et(:);

xlims = breakinDeltaT(c_ind)+[-0.262 0.7];
et_window = et(et>=xlims(1) & et <= xlims(2));
et_window = et_window-breakinDeltaT(c_ind);
df = get(l,'ydata');
df = df(:);
detrend = df(et>=xlims(1) & et <= xlims(2));

breakin_dF_model = [...
    base_coeffout(c_ind,1)*et_window(et_window <= 0) + base_coeffout(c_ind,2); ...
    exponential(exp_coeffout(c_ind,:),et_window(et_window > 0))];

detrend(et_window <= 0) = ... % detrend baseline
    detrend(et_window <= 0) - ...
    breakin_dF_model(et_window <= 0);
detrend(et_window <= 0) = ... % add back final baseline point
    detrend(et_window <= 0) + ...
    repmat(breakin_dF_model(find(et_window<=0,1,'last')),size(et_window(et_window <= 0)));
detrend(et_window > 0) = ... % detrend baseline
    detrend(et_window > 0) - ...
    breakin_dF_model(et_window > 0);
detrend(et_window > 0) = ... % add back final baseline point
    detrend(et_window > 0) + ...
    repmat(breakin_dF_model(find(et_window>0,1,'first')),size(et_window(et_window > 0)));
detrend = detrend - mean(detrend(et_window <= 0),1);
df(et>=xlims(1) & et <= xlims(2)) = detrend;
set(l,'ydata',df);

ylabel(ax1,'\DeltaF/F (%)')
set(ax1,'YLim',[-.5 2],'xtick',[],'xColor',[1 1 1]);

%xlims = [3.16 3.56];
xlims = breakinDeltaT(c_ind)+[-0.18 0.24];

% current break in panel
ax2 = pnl(3,1,2,2).select();
inax = findobj(sweepfig,'tag','quickshow_inax');
copyobj(findobj(inax,'type','line'),ax2);
ylabel(ax2,'pA')
set(ax2,'ylim',[-250 150],'xtick',[],'xColor',[1 1 1]);

% V break in panel
ax3 = pnl(3,1,2,3).select();
outax = findobj(sweepfig,'tag','quickshow_outax');
copyobj(findobj(outax,'type','line'),ax3);
set(ax3,'ylim',[-51 -44]);
ylabel(ax3,'mV')
xlabel(ax3,'Time (s)')

%set([ax1,ax2,ax3],'xlim',xlims,'Tickdir','out');
set(ax1,'xlim',xlims,'Tickdir','out');
set([ax2,ax3],'xlim',xlims+breakin_offset,'Tickdir','out');
set(findobj([ax1,ax2,ax3],'type','line'),'color',[0 0 0]);


pnl(3,2).pack('h',{1/2 1/2});
ax = pnl(3,2,1).select(); hold(ax,'on');
colors = distinguishable_colors(size(breakin_dF_dF_detrended,1));
for t_ind = 1:size(breakin_dF_dF_detrended,1)
    plot(ax, breakin_exposure_time_windows(t_ind,:),breakin_dF_dF_detrended(t_ind,:),...
        '-','color',colors(t_ind,:),...
        'displayname',analysis_cell(t_ind).name);
    x_p = breakin_exposure_time_windows(t_ind,:) > .03 & breakin_exposure_time_windows(t_ind,:) <.2;
    x_n = breakin_exposure_time_windows(t_ind,:) > -.2 & breakin_exposure_time_windows(t_ind,:) <.02;
    DeltaF_breakin_detrended(t_ind) = mean(breakin_dF_dF_detrended(t_ind,x_p),2)-...
        mean(breakin_dF_dF_detrended(t_ind,x_n),2); %#ok<SAGROW>
    
end

ylabel(ax,'% \DeltaF/F')
xlabel(ax,'Time from break-in (s)');
axes(ax);
textbp('Frames, 20 ms exposure');

plot(ax,[-.2 -.2],get(ax,'ylim'),'--', 'color',[1 .9 .9]);
plot(ax,[-.02 -.02],get(ax,'ylim'),'--','color',[1 .9 .9]);
plot(ax,[.03 .03],get(ax,'ylim'),'--','color',[.9 .9 1]);
plot(ax,[.2 .2],get(ax,'ylim'),'--','color',[.9 .9 1]);
set(ax,'Tickdir','out');

ax = pnl(3,2,2).select(); hold(ax,'on');
for df_ind = 1:length(DeltaF_breakin_detrended)
    plot(ax,commandvoltage(df_ind),DeltaF_breakin_detrended(df_ind),'o','color',colors(df_ind,:),'markerfacecolor',colors(df_ind,:),'DisplayName',analysis_cell(df_ind).name);
end
%legend(ax,'show','location','best')
plot(ax,[0 0],get(ax,'ylim'),'k:')
plot(ax,get(ax,'xlim'),[0 0],'k:')
xlim(ax,[-50,-20])

ylabel(ax,'% \DeltaF/F')
xlabel(ax,'V_m (mV)');
set(ax,'Tickdir','out');

% recolor and other stuff
%Traces panel
traces_ax = pnl(3,2,1).select();
traces = findobj(traces_ax,'type','line','linestyle','-');

% Dots panel
dots_ax = pnl(3,2,2).select();
dots = findobj(dots_ax,'type','line','Marker','o');
x = nan(size(dots));
y = x;
for i = 1:length(x)
    x(i) = get(dots(i),'xdata');
    y(i) = get(dots(i),'ydata');
end

m = 32;
clrs = redblue(m);
cmin = min(x);
cmax = max(x);
for i = 1:length(x)
    idx = fix((x(i)-cmin)/(cmax-cmin)*m)+1;
    idx(idx<1) = 1;
    idx(idx>m) = m;

    set(dots(i),'markerFaceColor',0.8*clrs(idx,:),'markerEdgeColor',0.8*clrs(idx,:));
    set(findobj(traces,'displayname',get(dots(i),'displayname')),'color',0.8*clrs(idx,:));
end

set(findobj(dots,'displayname','140530_F1_C1'),'markerFaceColor','none');
set(findobj(dots,'displayname','140530_F2_C1'),'markerFaceColor','none');

% [p,s] = polyfit(x,y,1);
% line([min(x) max(x)],p(1)*[min(x) max(x)]+p(2),'parent',dots_ax,'linestyle','-','color',[.8 .8 .8]);

fitresult = fit(x,y,'poly1');
p21 = predint(fitresult,x,0.95,'functional','off');
[x_,o] = sort(x);
line([min(x) max(x)],fitresult.p1*[min(x) max(x)]+fitresult.p2,'parent',dots_ax,'linestyle','-','color',[.8 .8 .8]);
line(x_,p21(o,:),'parent',dots_ax,'linestyle','-','linewidth',1,'color',[.8 1 .8]);
x_s = (-40:.01:-25);
p21 = predint(fitresult,x_s,0.95,'functional','off');
x_s_min = x_s(abs(p21(:,1))==min(abs(p21(:,1))));
x_s_max = x_s(abs(p21(:,2))==min(abs(p21(:,2))));
line([x_s_min, x_s_max],[0 0],'parent',dots_ax,'linestyle','-','linewidth',2,'color',0*[.8 1 .8]);

% fitresult = fit(y,x,'poly1');
% p21 = predint(fitresult,y,0.95,'functional','off');
% [y_,o] = sort(y);
% line(fitresult.p1*[min(y) max(y)]+fitresult.p2,[min(y) max(y)],'parent',dots_ax,'linestyle','-','color',[.8 .8 .8]);
% line(p21(o,1),y_,'parent',dots_ax,'linestyle','-','linewidth',1,'color',[.8 1 .8]);
% line(p21(o,2),y_,'parent',dots_ax,'linestyle','-','linewidth',1,'color',[.8 1 .8]);
% p21 = predint(fitresult,0,0.95,'functional','off');
% line(p21,[0 0],'parent',dots_ax,'linestyle','-','linewidth',2,'color',0*[.8 1 .8]);

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure6/';
savePDF(figure6,savedir,[],'Figure6');

