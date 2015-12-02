%% PiezoStepComparisons
fig = figure;
set(fig,'color',[1 1 1],'position',[286 558 1033 420])
pnl = panel(fig);

pnl.pack('h',length(analysis_cell)+1)  % response panel, stimulus panel
pnl.margin = [18 10 2 10];
pnl.fontname = 'Arial';
%panl(1).marginbottom = 2;
pnl(length(analysis_cell)+1).pack('v',{3/7,3/7,1/7})

for cnt = 1:length(analysis_cell)
    trial = load(analysis_cell(cnt).PiezoStepTrial_IClamp);
    obj = getShowFuncInputsFromTrial(trial);
    
    trials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData);
    x = makeInTime(obj.trial.params);
    voltage = zeros(size(x));
    sgs = zeros(size(x));
    
    for t_ind = 1:length(trials);
        trial = load(fullfile(obj.dir,sprintf(obj.trialStem,trials(t_ind))));
        voltage = voltage+trial.voltage;
        sgs = sgs+trial.sgsmonitor;
    end
    voltage_ctrl = voltage/length(trials);
    sgs = sgs/length(trials);
    bsline_ctrl = mean(voltage_ctrl(x<0&x>-.1));
    peak_ctrl = max(voltage_ctrl(x>0&x<.05));
    
    
    % Drug
    trial = load(analysis_cell(cnt).PiezoStepTrial_IClamp_Drug);
    obj = getShowFuncInputsFromTrial(trial);
    
    trials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData);
    x = makeInTime(obj.trial.params);
    voltage = zeros(size(x));
    
    for t_ind = 1:length(trials);
        trial = load(fullfile(obj.dir,sprintf(obj.trialStem,trials(t_ind))));
        voltage = voltage+trial.voltage;
    end
    voltage_drug = voltage/length(trials);
    bsline_drug = mean(voltage_drug(x<0&x>-.1));
    peak_drug = max(voltage_drug(x>0&x<.05));
    
    % Plot
    pnl(cnt).pack('v',{3/7,3/7,1/7})
    ax = pnl(cnt,1).select();
    plot(ax,x,voltage_ctrl,'color',[0 0 0],'displayname','ctrl');
    ylabel(ax,'mV')
    pnl(cnt,1).title(regexprep(analysis_cell(cnt).name,'_','\\_'))
    
    ax = pnl(cnt,2).select();
    plot(ax,x,voltage_drug,'color',[0 0 0],'displayname',analysis_cell(cnt).Drug);
    ylabel(ax,'mV')
    text(-.09,-30,analysis_cell(cnt).Drug,'fontsize',7,'parent',ax);
    
    ax = pnl(cnt,3).select();
    plot(ax,x,sgs,'color',[0 0 1],'displayname','sgs');
    ylabel(ax,'V')

    linkaxes([pnl(cnt,1).select(),pnl(cnt,2).select(),pnl(cnt,3).select()],'x')
    xlim(ax,[-.1 .1])
    
    linkaxes([pnl(cnt,1).select(),pnl(cnt,2).select()],'y')
    ylim(pnl(cnt,1).select(),[-50 -25])
    ylim(ax,[3.5 6.5])
    
    ax = pnl(length(analysis_cell)+1,1).select();
    line([0 1],[peak_ctrl-bsline_ctrl,peak_drug-bsline_drug],...
        'parent',ax,...
        'color',[0 0 0],'linestyle','-',...
        'marker','o','markeredgecolor',[0 0 0],'markerfacecolor',[0 0 0]);

    ax = pnl(length(analysis_cell)+1,2).select();
    line([0 1],[bsline_ctrl,bsline_drug],...
        'parent',ax,...
        'color',[0 0 0],'linestyle','-',...
        'marker','o','markeredgecolor',[0 0 0],'markerfacecolor',[0 0 0]);
end
set(pnl(length(analysis_cell)+1,1).select(),'xticklabel',{'ctrl','drug'},'xtick',[0 1],'tag','dots')
xlim(pnl(length(analysis_cell)+1,1).select(),[-.5 1.5])
ylim(pnl(length(analysis_cell)+1,1).select(),[0 6]);

set(pnl(length(analysis_cell)+1,2).select(),'xticklabel',{'ctrl','drug'},'xtick',[0 1],'tag','Vm')
xlim(pnl(length(analysis_cell)+1,2).select(),[-.5 1.5])
%ylim(pnl(length(analysis_cell)+1,2).select(),[0 6]);
