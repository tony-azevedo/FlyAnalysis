%% VoltageRamps
% comparestims = {'VoltageRamp_m100_p20',...
%     'VoltageRamp_m70_p20','VoltageRamp_m70_p20_1s',...
%     'VoltageRamp_m60_p40', 'VoltageRamp_m60_p40_1s', 'VoltageRamp_m60_p40_h_1s',
%     'VoltageRamp_m50_p12_h_0_5s};

trial = load(ac.trials.VoltageCommand);
h = getShowFuncInputsFromTrial(trial);

ramptrials = ones(size(rampstims));
for r_ind = 1:length(ramptrials)
    pd_ind = 0;
    while pd_ind<length(h.prtclData)
        pd_ind = pd_ind+1;
        if strcmp(h.prtclData(pd_ind).stimulusName,rampstims{r_ind});
            break
        end
    end
    ramptrials(r_ind) = pd_ind;
end

for r_ind = 1:length(ramptrials)
    fprintf('%s\n',rampstims{r_ind})
trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(ramptrials(r_ind)).trial)));

blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock'});
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

x = makeInTime(trial.params);

fig = figure();
pnl = panel(fig);
set(fig,'color',[1 1 1],'position',[382 445 1064 533]);
pnl.pack('h',{1/2 1/2})
pnl.margin = [18 18 10 10];
pnl(1).pack('v',{3/4 1/4})
ylims = [Inf -Inf];

clrs = distinguishable_colors(size(blocktrials,2),{'w','k',[1 1 0],[1 1 1]*.75});
stim = VoltageCommand;
stim.setParams(trial.params)
stimvec = stim.getStimulus;

for bt_ind = 1:length(blocktrials)
    clr = clrs(bt_ind,:);
    trials = findLikeTrials('trial',blocktrials(bt_ind),'datastruct',h.prtclData);
    trials = excludeTrials('trials',trials,'name',trial.name);

    current = zeros(size(x));
    voltage = zeros(size(x));
    
    for t_ind = 1:length(trials);
        trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
        current = current+trial.current;
        voltage = voltage+trial.voltage;
    end
    current = current/length(trials);
    voltage_in = voltage/length(trials);
    voltage_hold = mean(voltage_in(x>0-.05 &x<0));
    stimvec = stim.getStimulus;
    voltage = stimvec.voltage+voltage_hold;
    
    ylims(1) = min([ylims(1) mean(current(x>.001 &x<0.002))]);
    ylims(2) = max([ylims(2) max(current)]);
    
    tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
    if ~isempty(tg),
        %tg = drugmap.(tg);
    else tg = 'ctrl';
    end
    
    line(x,current,'color',clr,'displayname',tg,'tag',tg,'parent',pnl(1,1).select());
    line(x,voltage_in,'color',clr,'displayname',tg,'tag',tg,'parent',pnl(1,2).select());
    Current.(regexprep(tg,'4','Four')) = smooth(current,10);
    Voltage.(regexprep(tg,'4','Four')) = voltage;
    %Current.(regexprep(tg,'4','Four')) = current;
    
end
legend(pnl(1,1).select(),'toggle');
l = findobj(fig,'Tag','legend');
set(l,'location','NorthWest','interpreter','none','box','off');
ylabel(pnl(1,1).select(),'pA');
title(pnl(1,1).select(),ac.name,'interpreter','none');

legend(pnl(1,2).select(),'toggle');
l = findobj(fig,'Tag','legend');
set(l,'location','NorthWest','interpreter','none','box','off');
%line(x,voltage,'color',[0 0 0],'displayname',tg,'parent',pnl(1,2).select());
ylabel(pnl(1,2).select(),'mV');
xlabel(pnl(1,2).select(),'s');

linkaxes([pnl(1,1).select() pnl(1,2).select()],'x');
xlim(pnl(1,1).select(),[-.1*trial.params.stimDurInSec trial.params.stimDurInSec+.1*trial.params.stimDurInSec]);
%xlim(pnl(1,1).select(),[1 2]);
ylim(pnl(1,1).select(),ylims + [-.1 .1]*diff(ylims));
%ylim(pnl(1,2).select(),[-100 10]);

fns = fieldnames(Current);
for fn_ind = 2:length(fns)
    clr = clrs(fn_ind,:);
    sensitive_current = smooth(Current.(fns{fn_ind-1})-Current.(fns{fn_ind}),20);
    
    i = 0.001;
    f = trial.params.stimDurInSec-i;
    
    tg = drugmap.(fns{fn_ind});
    
    line(Voltage.(fns{fn_ind})(x>i&x<f),sensitive_current(x>i&x<f),'color',clr,'displayname',tg,'tag',tg,'parent',pnl(2).select());
    switch tg
        case 'TEA'
            if strcmp(drugmap.(fns{fn_ind-1}),'4AP')
                dbldrg_sensitive_current = smooth(Current.(fns{fn_ind-2})-Current.(fns{fn_ind}),20);
                tg = '4AP_TEA';
                line(Voltage.(fns{fn_ind})(x>i&x<f),dbldrg_sensitive_current(x>i&x<f),'color',clr*.5,'displayname',tg,'tag',tg,'parent',pnl(2).select());
            end
        otherwise
    end
        
end
legend(pnl(2).select(),'toggle');
l = findobj(fig,'Tag','legend');
set(l,'location','NorthWest','interpreter','none','box','off');
ylabel(pnl(2).select(),'pA');
xlabel(pnl(2).select(),'mV');
title(pnl(2).select(),'X-sensitive currents');
xlim(pnl(2).select(),[-100 10]);

set(pnl(1,1).select(),'tag','currents');
set(pnl(1,2).select(),'tag','ramp');
set(pnl(2).select(),'tag','Xsensitive');

pnl.fontname = 'Arial';
pnl.fontsize = 10;

if ~isdir(fullfile(savedir,'ramps'))
    mkdir(fullfile(savedir,'ramps'))
end

fn = fullfile(savedir,'ramps',[ac.name,'_',rampstims{r_ind} '_Currents.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'ramps',[ac.name,'_',rampstims{r_ind} '_Currents']),'fig');

clear Current
end

