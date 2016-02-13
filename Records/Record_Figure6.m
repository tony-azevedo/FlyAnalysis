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

figure1 = figure;
figure1.Units = 'inches';
set(figure1,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneColumn') 10]);
pnl = panel(figure1);
pnl.margin = [16 16 4 4];

figurerows = [2 3 5];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);

pnl(1).pack('h',{1/3 2/3})
pnl(1,2).pack('h',{1/2 1/2})
pnl(1,2).margin = [4 4 4 4];


%% Vm
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

set(ax,'xlim',[.5 4.5],'ylim',[-51 -25],'xtick',[1 2 3 4],'xticklabel',{'A2' 'BPH' 'BPL' 'LP'   })
ylabel(ax,'V_m (mV)');


%% Spiking

Script_Vm_BandPassHiB1s

ax_sweep = pnl(1,2,1).select();
trial = load(example_cell.SweepTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin),trial.voltage(xwin),'parent',ax_sweep)
axis(ax_sweep,'tight');

ax_spike = pnl(1,2,2).select();
trial = load(example_cell.SpikeTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin),trial.voltage(xwin),'parent',ax_spike)
axis(ax_spike,'tight');

set([ax_sweep ax_spike],'ylim',[-90 10],'xcolor',[1 1 1],'xtick',[],'ycolor',[1 1 1],'ytick',[]);

% barfig = figure;
% set(barfig,'color',[1 1 1],'units','inches','position',[1 3 10 3.7],'name','Summary_Vm_Box');
% 
% pnl_stats = panel(barfig);
% pnl_stats.margin = [20 20 10 10];
% pnl_stats.pack('h',1);
% 
% to_ax = pnl_stats(1).select(); hold(to_ax,'on');
% boxplot(to_ax,Vm,Vm_group,'plotstyle','traditional','notch','on');
% 
% 
% figure
% [p,tbl,stats] = anova1(Vm,Vm_group);
% multcompare(stats);



