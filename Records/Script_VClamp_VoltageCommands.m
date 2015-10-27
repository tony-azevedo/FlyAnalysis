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


%% Voltage Steps
close all

cs_names = dir([h.dir '\VoltageStep_Raw_*']);
trial = load(fullfile(h.dir,cs_names(1).name));

h = getShowFuncInputsFromTrial(trial);
    
blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock','steps','step'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock','step'});
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

x = makeInTime(trial.params);
i = -600;
f = 400;

%Create a figure with the number of columns drugs
fig = figure();
set(fig,'color',[1 1 1],'position',[197 204  1240 742],'name',[ac.name '_VoltageSteps']);
pnl = panel(fig);
pnl.margin = [18 18 10 10];
pnl.pack('h',length(blocktrials));
pnl.de.margin = [10 10 10 10];

ylims_voltage = [Inf -Inf];
ylims_current = [Inf -Inf];

steplims = [Inf -Inf];
currlims = [Inf -Inf];
    
for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
    pnl(bt_ind).pack('v',{2/4,1/4,1/4});
    [x,voltage,current] = PF_VoltageStepFam([pnl(bt_ind,1).select() pnl(bt_ind,2).select()],getShowFuncInputsFromTrial(trial),'');

    ylims_voltage(1) = min([ylims_voltage(1),min(min(voltage))]);
    ylims_voltage(2) = max([ylims_voltage(2),max(max(voltage))]);

    win = x>.005&x<.05; % where the max might occur;
    current_win = current(win,:);
    ylims_current(2) = max([ylims_current(2),max(current_win(:))]);
    
    win = (x>.005&x<.05)|(x>trial.params.stimDurInSec+.0003&x<trial.params.stimDurInSec+.01); % where the max might occur;
    current_win = current(win,:);
    ylims_current(1) = min([ylims_current(1),min(current_win(:))]);
    
    tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
    if ~isempty(tg),
        tg = drugmap.(tg);
    else tg = 'ctrl';
    end

    pnl(bt_ind).title(tg);

    PF_VoltageStepIVRelationship([pnl(bt_ind,3).select()],getShowFuncInputsFromTrial(trial),'');
    axis(pnl(bt_ind,3).select(),'tight'); %'ylim',[-100 300],'xlim',[-60 40]);
    xlims = get(pnl(bt_ind,3).select(),'xlim');
    steplims(1) = min([steplims(1) xlims(1)]);
    steplims(2) = max([steplims(2) xlims(2)]);
    ylims = get(pnl(bt_ind,3).select(),'ylim');
    currlims(1) = min([currlims(1) ylims(1)]);
    currlims(2) = max([currlims(2) ylims(2)]);

end
col_pnls = pnl(1).de;
pnls_hs = zeros(length(col_pnls),length(blocktrials));

for r_ind = 1:size(pnls_hs,1);
    for c_ind = 1:size(pnls_hs,2);
        pnls_hs(r_ind,c_ind) = pnl(c_ind,r_ind).select();
    end
end

set(pnls_hs([1,3],:),'ylim',ylims_current,...
    'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
set(pnls_hs([2],:),'ylim',ylims_voltage,...
    'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

ylabel(pnl(1,1).select(),'pA');
ylabel(pnl(1,2).select(),'mV');
xlabel(pnl(1,2).select(),'s');
xlabel(pnl(length(blocktrials),2).select(),regexprep(ac.name,'_','.'));

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,3).select(),'xlim',steplims,'ylim',currlims);
end

% set(pnl(1,1).select(),'tag','currents');
% set(pnl(1,2).select(),'tag','ramp');
% set(pnl(2).select(),'tag','Xsensitive');

if ~isdir(fullfile(savedir,'vSteps'))
    mkdir(fullfile(savedir,'vSteps'))
end

fn = fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps']),'fig');

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,1).select(),'xlim',[-.005 .02]);
end

fn = fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps_onset.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,1).select(),'xlim',trial.params.stimDurInSec+[-.005 .01]);
end

fn = fullfile(savedir,'vSteps',[ac.name, '_VoltageSteps_offset.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);


%% Voltage Step Subtractions 
close all

cs_names = dir([h.dir '\VoltageStep_Raw_*']);
trial = load(fullfile(h.dir,cs_names(1).name));

h = getShowFuncInputsFromTrial(trial);
    
blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock','steps','step'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock','step'});
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

x = makeInTime(trial.params);
i = -600;
f = 400;

%Create a figure with the number of columns drugs
fig = figure();
set(fig,'color',[1 1 1],'position',[197 9  1410 988],'name',[ac.name '_VoltageSteps']);
pnl = panel(fig);
pnl.margin = [18 18 10 10];
pnl.pack('h',length(blocktrials));
pnl.de.margin = [10 10 10 10];

ylims_voltage = [Inf -Inf];
ylims_current = [Inf -Inf];

steplims = [Inf -Inf];
currlims = [Inf -Inf];
    
for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
    pnl(bt_ind).pack('v',{2/5,1/5,2/5});
    
    [x,voltage,current] = PF_VoltageStepFam([pnl(bt_ind,1).select() pnl(bt_ind,2).select()],getShowFuncInputsFromTrial(trial),'');

    ylims_voltage(1) = min([ylims_voltage(1),min(min(voltage))]);
    ylims_voltage(2) = max([ylims_voltage(2),max(max(voltage))]);

    win = x>.005&x<.05; % where the max might occur;
    current_win = current(win,:);
    ylims_current(2) = max([ylims_current(2),max(current_win(:))]);

    win = (x>.005&x<.05)|(x>trial.params.stimDurInSec+.0003&x<trial.params.stimDurInSec+.01); % where the max might occur;
    current_win = current(win,:);
    ylims_current(1) = min([ylims_current(1),min(current_win(:))]);
    
    tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
    if ~isempty(tg),
        tg = drugmap.(tg);
    else tg = 'ctrl';
    end
    
    if bt_ind == 1
        current_0 = current;
        for c_ind = 1:size(current_0,2);
            current_0(:,c_ind) = smooth(current_0(:,c_ind),5);
        end
    else
        current_1 = current;
        for c_ind = 1:size(current_1,2);
            current_1(:,c_ind) = smooth(current_1(:,c_ind),5);
        end

        current_diff = current_0-current_1;
        for v_ind = 1:size(current_diff,2)
            line(x,current_diff(:,v_ind),...
                'parent',pnl(bt_ind,3).select(),...
                'color',[0 1 0] + [ 0 -1 1]*(v_ind-1)/max([size(current_diff,2)-1,1]));
        end
        xlim(pnl(bt_ind,3).select(),[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
        current_0 = current_1;
    end
    
    pnl(bt_ind).title(tg);
end
col_pnls = pnl(1).de;
pnls_hs = zeros(length(col_pnls),length(blocktrials));

for r_ind = 1:size(pnls_hs,1);
    for c_ind = 1:size(pnls_hs,2);
        pnls_hs(r_ind,c_ind) = pnl(c_ind,r_ind).select();
    end
end
set(pnls_hs([1,3],:),'ylim',ylims_current,...
    'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
set(pnls_hs([2],:),'ylim',ylims_voltage,...
    'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

ylabel(pnl(1,1).select(),'pA');
ylabel(pnl(1,2).select(),'mV');
ylabel(pnl(1,3).select(),'pA');
xlabel(pnl(1,2).select(),'s');
xlabel(pnl(length(blocktrials),2).select(),regexprep(ac.name,'_','.'));

if ~isdir(fullfile(savedir,'vSteps_sbtrct'))
    mkdir(fullfile(savedir,'vSteps_sbtrct'))
end

fn = fullfile(savedir,'vSteps_sbtrct',[ac.name, '_VoltageSubtraction.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'vSteps_sbtrct',[ac.name, '_VoltageSubtraction']),'fig');

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,1).select(),'xlim',[-.005 .02]);
    set(pnl(bt_ind,3).select(),'xlim',[-.005 .02]);
end

fn = fullfile(savedir,'vSteps_sbtrct',[ac.name, '_VoltageSubtraction_onset.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
    set(pnl(bt_ind,1).select(),'xlim',trial.params.stimDurInSec+[-.005 .01]);
    set(pnl(bt_ind,3).select(),'xlim',trial.params.stimDurInSec+[-.005 .01]);
end

fn = fullfile(savedir,'vSteps_sbtrct',[ac.name, '_VoltageSubtraction_offset.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

%% Voltage Sines
close all

cs_names = dir([h.dir '\VoltageSine_Raw_*']);
trial = load(fullfile(h.dir,cs_names(end).name));

h = getShowFuncInputsFromTrial(trial);

tag_collections_VS = {};
for pd_ind = 1:length(h.prtclData);    
    tg_collection_str = sprintf('%s; ',h.prtclData(pd_ind).tags{:});
    if ~ismember(tg_collection_str,tag_collections_VS);
        tag_collections_VS{end+1} = tg_collection_str;
        fprintf(1,'%s\n',tg_collection_str);
    end
end

trial_seeds = nan(length(trial.params.amps),length(trial.params.freqs),length(tag_collections_VS));

for pd_ind = 1:length(h.prtclData);    
    a_ind = find(trial.params.amps== h.prtclData(pd_ind).amp);
    f_ind = find(trial.params.freqs== h.prtclData(pd_ind).freq);
    t_ind = find(strcmp(tag_collections_VS,sprintf('%s; ',h.prtclData(pd_ind).tags{:})));
    if isnan(trial_seeds(a_ind,f_ind,t_ind))
        trial_seeds(a_ind,f_ind,t_ind) = h.prtclData(pd_ind).trial;
        ex = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,t_ind))),'excluded');
        if isfield(ex,'excluded') && ex.excluded
            trial_seeds(a_ind,f_ind,t_ind) = nan;
        end
    end 
end

if ~isdir(fullfile(savedir,'vSines'))
    mkdir(fullfile(savedir,'vSines'))
end

% Combine TEA, 4AP and ZD and Cd
%trial_seeds = trial_seeds(:,:,[1,2,5]);

clrs = distinguishable_colors(size(trial_seeds,3),{'w','k',[1 1 0],[1 1 1]*.75});

for a_ind = 1:size(trial_seeds,1)
% a_ind = 2
    fig = figure();
    set(fig,'color',[1 1 1],'position',[28 34 1767 948],'name',[ac.name '_VoltageSine_' num2str(trial.params.amps(a_ind)) 'V']);
    %set(fig,'color',[1 1 1],'units','inches','position',[1 2 10 7],'name',[ac.name '_VoltageSine_' num2str(trial.params.amps(a_ind)) 'V']);
    pnl = panel(fig);
    pnl.margin = [18 18 10 10];
    pnl.pack('h',size(trial_seeds,2));
    pnl.de.margin = [10 10 10 10];
    
    ylims = [Inf -Inf];
    ylims_voltage = [Inf -Inf];

    stim = VoltageSine;
    
    for f_ind = 1:size(trial_seeds,2)

        rownum = size(trial_seeds,3)+2;

        pnl(f_ind).pack('v',size(trial_seeds,3)+2);
        trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,1))));
        trials = findLikeTrials('name',trial.name);
        x = makeInTime(trial.params);
        i = -0.02;
        f = 0.075;

        voltage = zeros(size(trial.voltage));
        
        for tr_ind = trials
            trial = load(fullfile(h.dir,sprintf(h.trialStem,tr_ind)));
            voltage = voltage+trial.voltage;
        end
        voltage = smooth(voltage/length(trials),20);
        
        trial.params.freqs = trial.params.freq;
        stim.setParams(trial.params)
        stimvec = stim.getStimulus;
        dV_dt = gradient(stimvec.voltage(x>0.02 & x<f));
        below = dV_dt<0;
        above = dV_dt>=0;
        down_cross = find(below(2:end).*above(1:end-1)) + sum(x<=0.02);
        dI = max([floor(length(down_cross)/3) 1]);
        peaktimes = fliplr(down_cross(end:-dI:1));
        peaktimes = x(peaktimes);
        
        ylims_voltage(1) = min([ylims_voltage(1) min(voltage(x>i &x<f))]);
        ylims_voltage(2) = max([ylims_voltage(2) max(voltage(x>i &x<f))]);

        line(x(x>i&x<f),stimvec.voltage(x>i&x<f),'color',[0 0 0],'parent',pnl(f_ind,1).select(),'tag','commandvoltage');
        for x_ind = 1:length(peaktimes)
            line([peaktimes(x_ind) peaktimes(x_ind)],[mean(voltage(x>i&x<f)) mean(voltage(x>i&x<f))],'color',[1 1 1]*.75,'parent',pnl(f_ind,1).select(),'tag','fiducials');
        end
        for t_ind = 1:size(trial_seeds,3)
            clr = clrs(t_ind,:);
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,t_ind))));
            trials = findLikeTrials('name',trial.name);
            x = makeInTime(trial.params);
            voltage = zeros(size(trial.voltage));
            
            for tr_ind = trials
                trial = load(fullfile(h.dir,sprintf(h.trialStem,tr_ind)));
                voltage = voltage+trial.voltage;
            end
            voltage = voltage/length(trials);
            line(x(x>i&x<f),voltage(x>i&x<f),'color',clr,'parent',pnl(f_ind,1).select());
            ylims_voltage(1) = min([ylims_voltage(1) min(voltage(x>i &x<f))]);
            ylims_voltage(2) = max([ylims_voltage(2) max(voltage(x>i &x<f))]);

        end
        uistack(findobj(pnl(f_ind,1).select(),'tag','commandvoltage'),'top');

        for t_ind = 1:size(trial_seeds,3)

            clr = clrs(t_ind,:);
            
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,t_ind))));

            tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));

            trials = findLikeTrials('name',trial.name);
            
            x = makeInTime(trial.params);

            current = zeros(size(trial.voltage));
            for tr_ind = trials
                trial = load(fullfile(h.dir,sprintf(h.trialStem,tr_ind)));
                current = current+trial.current;
            end
            current = smooth(current/length(trials),5);
            
            line(x(x>i&x<f),current(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(f_ind,2).select());

            ylims(1) = min([ylims(1) min(current(x>i &x<f))]);
            ylims(2) = max([ylims(2) max(current(x>i &x<f))]);
            
            tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
            if ~isempty(tg),
                %tg = drugmap.(tg);
            else tg = 'ctrl';
            end

            if t_ind==1,
                current_0 = current;
            elseif t_ind <= size(trial_seeds,3)
                current_1 = current;
                if length(current_1)>length(current_0)
                    current_diff = current_0-current_1(1:length(current_0));
                    x = x(1:length(current_0));
                else
                    current_diff = current_0(1:length(current_1))-current_1;
                end
                tg = drugmap.(regexprep(tg,'4','Four'));
                line(x(x>i&x<f),current_diff(x>i&x<f),'color',clr,'displayname',tg,'tag',[tg '_' num2str(trial.params.freq)],'parent',pnl(f_ind,1+t_ind).select());
                for x_ind = 1:length(peaktimes)
                    line([peaktimes(x_ind) peaktimes(x_ind)],[mean(current_diff(x>i&x<f)) mean(current_diff(x>i&x<f))],'color',[1 1 1]*.75,'parent',pnl(f_ind,1+t_ind).select(),'tag','fiducials');
                end
                
                ylabel(pnl(1,1+t_ind).select(),[tg '-sensitive (pA)']);
                
                current_0 = current_1;
                
                ylims(1) = min([ylims(1) min(current_diff(x>i &x<f))]);
                ylims(2) = max([ylims(2) max(current_diff(x>i &x<f))]);
            end
            if t_ind == size(trial_seeds,3) && t_ind > 1
                line(x(x>i&x<f),current_1(x>i&x<f),'color',clr,'displayname','rem','parent',pnl(f_ind,2+t_ind).select());
                for x_ind = 1:length(peaktimes)
                    line([peaktimes(x_ind) peaktimes(x_ind)],[mean(current_1(x>i&x<f)) mean(current_1(x>i&x<f))],'color',[1 1 1]*.75,'parent',pnl(f_ind,2+t_ind).select(),'tag','fiducials');
                end
                
            end
            set(pnl(f_ind,2).select(),'xlim',[i f],...
                'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
        end
        title(pnl(f_ind,1).select(),[num2str(trial.params.freqs(f_ind)) ' Hz'],'interpreter','none');
        
        for x_ind = 1:length(peaktimes)
            line([peaktimes(x_ind) peaktimes(x_ind)],[mean(current_1(x>i&x<f)) mean(current_1(x>i&x<f))],'color',[1 1 1]*.75,'parent',pnl(f_ind,2).select(),'tag','fiducials');
        end

        drawnow

    end
    
    col_pnls = pnl(1).de;
    pnls_hs = zeros(length(col_pnls),length(trial.params.freqs));
    
    for f_ind = 1:size(trial_seeds,2);
        col_pnls = pnl(f_ind).de;
        for d_ind = 1:length(col_pnls)
            pnls_hs(d_ind,f_ind) = col_pnls{d_ind}.select();
        end
    end
    set(pnls_hs(:),'xlim',[i f],...
        'ytick',[],'yticklabel',{},'ycolor',[1 1 1],...
        'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
     
    for r = 3:rownum-1
        c = pnls_hs(r,1);
        line([i,f],[0 0],'parent',c,'color',[.8 .8 .8],'tag','baseline');
    end

    maxdiff = -Inf;
    for r = 1:rownum
        curraxes = pnls_hs(r,:);
        ylims = [Inf -Inf];
        for c = curraxes
            axis(c,'tight');
            yl = get(c,'ylim');
            ylims(1) = min([ylims(1) min(yl)]);
            ylims(2) = max([ylims(2) max(yl)]);
        end
        set(curraxes(:),'ylim',ylims);
        linkaxes(curraxes(:),'y');
        if r>2 && r<rownum
            maxdiff = max(maxdiff,diff(ylims));
        end
    end
    for r = 3:rownum-1
        c = pnls_hs(r,1);
        yl = get(c,'ylim');
        cdiff = maxdiff-diff(yl);
        set(c,'ylim',cdiff/2*[-1 1]+yl);
    end
    ylims = get(pnls_hs(2,1),'ylim');
    set(pnls_hs(rownum,:),'ylim',ylims);

    for r = 1:rownum
        cs = pnls_hs(r,:);
        yl = get(cs(1),'ylim');
        fs = findobj(cs,'tag','fiducials');
        set(fs,'ydata',yl);
    end
    
    voltaxes = pnls_hs(1,:);
    linkaxes(voltaxes(:),'y');
    set(voltaxes,'ylim',ylims_voltage);
    xlabel(pnls_hs(end,end),regexprep(ac.name,'_','.'));
    
    
    % Finished with all columns (frequencies). Clean up plot
    ylabel(pnl(1,1).select(),'mV');
    ylabel(pnl(1,2).select(),'pA');
    for d_ind = 1:length(col_pnls)
        set(pnl(1,d_ind).select(),...
            'ytickmode','auto','yticklabelmode','auto','ycolor',[0 0 0]);
    end
    xlabel(pnl(1,d_ind).select(),'s');
    set(pnl(1,d_ind).select(),'xtickmode','auto','xticklabelmode','auto','xcolor',[0 0 0]);
    
    pnl.fontsize = 10;
    %pnl.fontsize = 18;
    pnl.fontname = 'Arial';
    
    fn = fullfile(savedir,'vSines',[ac.name, '_VoltageSine_Currents_' regexprep(num2str(trial.params.amp),'\.','_') 'V.pdf']);
    figure(fig)
    eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

    set(fig,'paperpositionMode','auto');
    saveas(fig,fullfile(savedir,'vSines',[ac.name, '_VoltageSine_Currents_' regexprep(num2str(trial.params.amp),'\.','_') 'V']),'fig');

end

%% Voltage Sines impedance plots
trial = load(ac.trials.VoltageCommand);
h = getShowFuncInputsFromTrial(trial);

cs_names = dir([h.dir '\VoltageSine_Raw_*']);
trial = load(fullfile(h.dir,cs_names(end).name));

h = getShowFuncInputsFromTrial(trial);

tag_collections_VS = {};
for pd_ind = 1:length(h.prtclData);    
    tg_collection_str = sprintf('%s; ',h.prtclData(pd_ind).tags{:});
    if ~ismember(tg_collection_str,tag_collections_VS);
        tag_collections_VS{end+1} = tg_collection_str;
        fprintf(1,'%s\n',tg_collection_str);
    end
end

trial_seeds = nan(length(trial.params.amps),length(trial.params.freqs),length(tag_collections_VS));

for pd_ind = 1:length(h.prtclData);    
    a_ind = find(trial.params.amps== h.prtclData(pd_ind).amp);
    f_ind = find(trial.params.freqs== h.prtclData(pd_ind).freq);
    t_ind = find(strcmp(tag_collections_VS,sprintf('%s; ',h.prtclData(pd_ind).tags{:})));
    if isnan(trial_seeds(a_ind,f_ind,t_ind))
        trial_seeds(a_ind,f_ind,t_ind) = h.prtclData(pd_ind).trial;
        ex = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,t_ind))),'excluded');
        if isfield(ex,'excluded') && ex.excluded
            trial_seeds(a_ind,f_ind,t_ind) = nan;
        end
    end 
end

clrs = distinguishable_colors(size(trial_seeds,3),{'w','k',[1 1 0],[1 1 1]*.75});

if ~isdir(fullfile(savedir,'vImpedance'))
    mkdir(fullfile(savedir,'vImpedance'))
end

stim = VoltageSine;
for a_ind = 1:size(trial_seeds,1)
    fig = figure();
    set(fig,'color',[1 1 1],'position',[1 1 820 980],'name',[ac.name '_VS_Z' num2str(trial.params.amps(a_ind)) 'V']);
    pnl = panel(fig);
    pnl.margin = [18 18 10 10];
    pnl.pack('h',size(trial_seeds,2));
    pnl.de.margin = [10 10 10 10];
    
    rlims = [Inf -Inf]; % resistance limits
    xlims = [Inf -Inf]; % reactance limits

    ylims_V = [Inf -Inf]; % resistance limits
    ylims_I = [Inf -Inf]; % resistance limits

    for f_ind = 1:size(trial_seeds,2)

        rownum = size(trial_seeds,3)+2;

        pnl(f_ind).pack('v',size(trial_seeds,3)+2);
        trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,1))));
        trials = findLikeTrials('name',trial.name);
        x = makeInTime(trial.params);
        i = .03;
        f = trial.params.stimDurInSec -.03;
        
        trial.params.freqs = trial.params.freq;
        trial.params.amps = trial.params.amp;
        stim.setParams('-q',trial.params)
        voltage = stim.getStimulus.voltage;

        Vz = hilbert(voltage);
        line(x(x>i&x<i+.075),real(Vz(x>i&x<i+.075)),'color',[0 0 0],'displayname','V','parent',pnl(f_ind,1).select());

        Vz = Vz(x>i&x<f);

        ylims_V(1) = min([ylims_V(1) min(voltage(x>i&x<f))]);
        ylims_V(2) = max([ylims_V(2) max(voltage(x>i&x<f))]);

        dV_dt = gradient(voltage(x>i&x<i+.075));
        below = dV_dt<0;
        above = dV_dt>=0;
        down_cross = find(below(2:end).*above(1:end-1)); 
        peak_i = down_cross(1); 
        dPeak = round(diff(down_cross(1:2))/4); 

        down_cross = down_cross + sum(x<=i);

        dI = max([floor(length(down_cross)/3) 1]);
        peaktimes = down_cross(end:-dI:1);
        peaktimes = x(flipud(peaktimes(:)));

        for x_ind = 1:length(peaktimes)
            line([peaktimes(x_ind) peaktimes(x_ind)],[0 0],'color',[1 1 1]*.75,'parent',pnl(f_ind,1).select(),'tag','fiducials');
        end

        for t_ind = 1:size(trial_seeds,3)

            clr = clrs(t_ind,:);
            
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,t_ind))));

            tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));

            trials = findLikeTrials('name',trial.name);
            
            x = makeInTime(trial.params);

            current = zeros(size(trial.voltage));
            for tr_ind = trials
                trial = load(fullfile(h.dir,sprintf(h.trialStem,tr_ind)));
                current = current+trial.current;
            end
            current = smooth(current/length(trials),10);
            Iz = hilbert(current-mean(current(x>trial.params.preDurInSec+.06&x<6)));
            line(x(x>i&x<i+.075),current(x>i&x<i+.075),'color',clr,'displayname',tg,'parent',pnl(f_ind,2).select());

            ylims_I(1) = min([ylims_I(1) min(current(x>i&x<f))]);
            ylims_I(2) = max([ylims_I(2) max(current(x>i&x<f))]);

            Iz = Iz(x>i&x<f);

            Zz = 1E-3*Vz./(Iz*1E-12);

            tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
            if ~isempty(tg),
                %tg = drugmap.(tg);
            else tg = 'ctrl';
            end

            line(real(Zz),imag(Zz),'color',clr,'displayname',tg,'parent',pnl(f_ind,2+t_ind).select());
            
            line(real(Zz(peak_i:peak_i+dPeak)),imag(Zz(peak_i:peak_i+dPeak)),...
                'color',[1 1 0],'linewidth',2,'parent',pnl(f_ind,2+t_ind).select());
            line(real(Zz(peak_i)),imag(Zz(peak_i)),...
                'markerfacecolor',[1 1 0],'linestyle','none','marker','+','parent',pnl(f_ind,2+t_ind).select());
            line(real(Zz(peak_i+dPeak)),imag(Zz(peak_i+dPeak)),...
                'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(f_ind,2+t_ind).select());

            line([0 mean(real(Zz))],[0 mean(imag(Zz))],'color',[1 1 1]*.75,'displayname',tg,'parent',pnl(f_ind,2+t_ind).select());

            
            rlims(1) = min([rlims(1) min(real(Zz))]);
            rlims(2) = max([rlims(2) max(real(Zz))]);
            xlims(1) = min([xlims(1) min(imag(Zz))]);
            xlims(2) = max([xlims(2) max(imag(Zz))]);


            if strcmp(ac.genotype,'modelcell')
                r_low = 342E6;
                r_hi = 504E6;
                r_b = 10E6;
                
                c_p = 33E-12;
                c_s = 5E-12;
                
                % for the low resistance, high series resistance (bath)
                % model cell
                r_hi = 333E6;
                r_b = 35E6;
                                
                % calculate impedance for the model cell (real and imaginary parts);
                % Z = R + jX
                switch tg
                    case 'ctrl'
                        r1 = r_low;
                    case 'HighR_50mOhm'
                        r1 = r_hi;
                end
                
                x1 = 0;

                r2 = 0;
                w = trial.params.freq;
                x2 = -1/(2*pi*w*c_p);
                x_s = -1/(2*pi*w*c_s);
                
                R = ((x1*r2 + x2*r1)*(x1 + x2) + (r1*r2 - x1*x2)*(r1 + r2)) / ...
                    ((r1^2 + r2^2) + (x1^2 + x2^2));
                R = R+r_b;
                
                X = ((x1*r2 + x2*r1)*(r1 + r2) - (r1*r2 - x1*x2)*(x1 + x2)) / ...
                    ((r1^2 + r2^2) + (x1^2 + x2^2));

                line(R,X,'color',[1 1 0],'displayname',[tg '0'],...
                    'markerfacecolor',[0 1 .5],'markeredgecolor',[0 0 1],...
                    'linestyle','none','marker','o','parent',pnl(f_ind,2+t_ind).select());
            end

            if t_ind == 1
                for x_ind = 1:length(peaktimes)
                    line([peaktimes(x_ind) peaktimes(x_ind)],[mean(current(x>i&x<f)) mean(current(x>i&x<f))],...
                        'color',[1 1 1]*.75,'parent',pnl(f_ind,2).select(),'tag','fiducials');
                end
            end
            if t_ind>1
                tg = drugmap.(regexprep(tg,'4','Four'));
            end
            ylabel(pnl(1,2+t_ind).select(),[tg ' (Ohm)']);
            ylabel(pnl(1,3).select(),'Reactance (Ohm)');

        end
        title(pnl(f_ind,1).select(),[num2str(trial.params.freqs(f_ind)) ' Hz'],'interpreter','none');
        xlabel(pnl(f_ind,t_ind+2).select(),'Resistance (Ohm)');

        drawnow

    end
   
    col_pnls = pnl(1).de;
    pnls_hs = zeros(length(col_pnls),length(trial.params.freqs));
    
    for f_ind = 1:size(trial_seeds,2);
        col_pnls = pnl(f_ind).de;
        for d_ind = 1:length(col_pnls)
            pnls_hs(d_ind,f_ind) = col_pnls{d_ind}.select();
        end
    end
    
    rlims(1) = min([rlims(1) 0]);
    rlims(2) = max([rlims(2) 0]);
    xlims(1) = min([xlims(1) 0]);
    xlims(2) = max([xlims(2) 0]);
    
    set(pnls_hs(3:end,:),'xlim',rlims,'ylim',xlims)%,...
    
    set(pnls_hs(1,:),'ylim',ylims_V,'xlim',[i i+0.075])%,...
    set(pnls_hs(2,:),'ylim',ylims_I,'xlim',[i i+0.075])%,...
    
    for r = 1:2
        cs = pnls_hs(r,:);
        yl = get(cs(1),'ylim');
        fs = findobj(cs,'tag','fiducials');
        set(fs,'ydata',yl);
    end
    
    set(pnls_hs(1:2,2:end),...
        'ytick',[],'yticklabel',{},'ycolor',[1 1 1],...
        'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

    ylabel(pnl(1,1).select(),'mV)');
    ylabel(pnl(1,2).select(),'pA');
    xlabel(pnl(1,2).select(),'s');
    
    ylabel(pnl(length(trial.params.freqs),rownum).select(),regexprep(ac.name,'_','.'));
        
    fn = fullfile(savedir,'vImpedance',[ac.name, '_VoltageSine_Z_' regexprep(num2str(trial.params.amp),'\.','_') 'V.pdf']);
    figure(fig)
    eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

    set(fig,'paperpositionMode','auto');
    saveas(fig,fullfile(savedir,'vImpedance',[ac.name, '_VoltageSine_Currents_' regexprep(num2str(trial.params.amp),'\.','_') 'V']),'fig');

end

%% Voltage Sine conductances
close all

cs_names = dir([h.dir '\VoltageSine_Raw_*']);
trial = load(fullfile(h.dir,cs_names(end).name));

h = getShowFuncInputsFromTrial(trial);

tag_collections_VS = {};
for pd_ind = 1:length(h.prtclData);    
    tg_collection_str = sprintf('%s; ',h.prtclData(pd_ind).tags{:});
    if ~ismember(tg_collection_str,tag_collections_VS);
        tag_collections_VS{end+1} = tg_collection_str;
        fprintf(1,'%s\n',tg_collection_str);
    end
end

trial_seeds = nan(length(trial.params.amps),length(trial.params.freqs),length(tag_collections_VS));

for pd_ind = 1:length(h.prtclData);    
    a_ind = find(trial.params.amps== h.prtclData(pd_ind).amp);
    f_ind = find(trial.params.freqs== h.prtclData(pd_ind).freq);
    t_ind = find(strcmp(tag_collections_VS,sprintf('%s; ',h.prtclData(pd_ind).tags{:})));
    if isnan(trial_seeds(a_ind,f_ind,t_ind))
        trial_seeds(a_ind,f_ind,t_ind) = h.prtclData(pd_ind).trial;
    end 
end

if ~isdir(fullfile(savedir,'vConductance'))
    mkdir(fullfile(savedir,'vConductance'))
end

% Combine TEA, 4AP and ZD and Cd
%trial_seeds = trial_seeds(:,:,[1,2,5]);

clrs = distinguishable_colors(size(trial_seeds,3),{'w','k',[1 1 0],[1 1 1]*.75});

for a_ind = 1:size(trial_seeds,1)
    fig = figure();
    set(fig,'color',[1 1 1],'position',[17 66 1872 916],'name',[ac.name '_VoltageSine_' num2str(trial.params.amps(a_ind)) 'V']);
    %set(fig,'color',[1 1 1],'units','inches','position',[1 2 10 7],'name',[ac.name '_VoltageSine_' num2str(trial.params.amps(a_ind)) 'V']);
    pnl = panel(fig);
    pnl.margin = [20 20 2 2];
    pnl.pack('h',size(trial_seeds,2));
    pnl.de.margin = [10 10 10 10];
    
    ylims = [Inf -Inf];
    ylims_g = [Inf -Inf];
    ylims_voltage = [Inf -Inf];

    stim = VoltageSine;
    
    for f_ind = 1:size(trial_seeds,2)

        rownum = size(trial_seeds,3)+2;

        pnl(f_ind).pack('v',size(trial_seeds,3)+2);
        trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,1))));
        trials = findLikeTrials('name',trial.name);
        x = makeInTime(trial.params);
        i = -0.02;
        f = 0.075;

        voltage = zeros(size(trial.voltage));
        
        for tr_ind = trials
            trial = load(fullfile(h.dir,sprintf(h.trialStem,tr_ind)));
            voltage = voltage+trial.voltage;
        end
        voltage = smooth(voltage/length(trials),20);
        V_hold = mean(voltage(x>-(trial.params.preDurInSec-0.06) & x<0));
        
        trial.params.freqs = trial.params.freq;
        stim.setParams(trial.params)
        stimvec = stim.getStimulus;
        dV_dt = gradient(stimvec.voltage(x>0.02 & x<f));
        below = dV_dt<0;
        above = dV_dt>=0;
        down_cross = find(below(2:end).*above(1:end-1)) + sum(x<=0.02);
        dI = max([floor(length(down_cross)/3) 1]);
        peaktimes = fliplr(down_cross(end:-dI:1));
        peaktimes = x(peaktimes);
        
        voltage = stimvec.voltage+V_hold;
        ylims_voltage(1) = min([ylims_voltage(1) min(voltage(x>i &x<f))]);
        ylims_voltage(2) = max([ylims_voltage(2) max(voltage(x>i &x<f))]);

        line(x(x>i&x<f),voltage(x>i&x<f),'color',[0 0 0],'parent',pnl(f_ind,1).select());
        for x_ind = 1:length(peaktimes)
            line([peaktimes(x_ind) peaktimes(x_ind)],[mean(voltage(x>i&x<f)) mean(voltage(x>i&x<f))],'color',[1 1 1]*.75,'parent',pnl(f_ind,1).select(),'tag','fiducials');
        end

        for t_ind = 1:size(trial_seeds,3)

            clr = clrs(t_ind,:);
            
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,t_ind))));

            tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));

            trials = findLikeTrials('name',trial.name);
            
            x = makeInTime(trial.params);

            current = zeros(size(trial.voltage));
            for tr_ind = trials
                trial = load(fullfile(h.dir,sprintf(h.trialStem,tr_ind)));
                current = current+trial.current;
            end
            current = smooth(current/length(trials),5);
                                    
            line(x(x>i&x<f),current(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(f_ind,2).select());

            ylims(1) = min([ylims(1) min(current(x>i &x<f))]);
            ylims(2) = max([ylims(2) max(current(x>i &x<f))]);
            

            if t_ind==1,
                current_0 = current;
            elseif t_ind <= size(trial_seeds,3)
                current_1 = current;
                current_diff = current_0-current_1;
                
                tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
                if ~isempty(tg),
                    drug = drugmap.(tg);
                    Erev = Emap.(regexprep(drug,'4','Four'));
                else
                    tg = 'ctrl';
                    drug = '';
                    Erev = V_hold;
                end
                tg = drugmap.(regexprep(tg,'4','Four'));

                g_diff = current_diff./(voltage-Erev);

                line(x(x>i&x<f),g_diff(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(f_ind,1+t_ind).select());
                for x_ind = 1:length(peaktimes)
                    line([peaktimes(x_ind) peaktimes(x_ind)],[mean(g_diff(x>i&x<f)) mean(g_diff(x>i&x<f))],'color',[1 1 1]*.75,'parent',pnl(f_ind,1+t_ind).select(),'tag','fiducials');
                end
                
                ylabel(pnl(1,1+t_ind).select(),[tg '-sensitive (nS)']);
                
                current_0 = current_1;
                
                ylims_g(1) = min([ylims_g(1) min(g_diff(x>i &x<f))]);
                ylims_g(2) = max([ylims_g(2) max(g_diff(x>i &x<f))]);
            end
            if t_ind == size(trial_seeds,3) && t_ind > 1
                line(x(x>i&x<f),current_1(x>i&x<f),'color',clr,'displayname','rem','parent',pnl(f_ind,2+t_ind).select());
                for x_ind = 1:length(peaktimes)
                    line([peaktimes(x_ind) peaktimes(x_ind)],[mean(current_1(x>i&x<f)) mean(current_1(x>i&x<f))],'color',[1 1 1]*.75,'parent',pnl(f_ind,2+t_ind).select(),'tag','fiducials');
                end
                
            end
            set(pnl(f_ind,2).select(),'xlim',[i f],...
                'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
        end
        title(pnl(f_ind,1).select(),[num2str(trial.params.freqs(f_ind)) ' Hz'],'interpreter','none');
        
        for x_ind = 1:length(peaktimes)
            line([peaktimes(x_ind) peaktimes(x_ind)],[mean(current_1(x>i&x<f)) mean(current_1(x>i&x<f))],'color',[1 1 1]*.75,'parent',pnl(f_ind,2).select(),'tag','fiducials');
        end

        drawnow

    end
    
    col_pnls = pnl(1).de;
    pnls_hs = zeros(length(col_pnls),length(trial.params.freqs));
    
    for f_ind = 1:size(trial_seeds,2);
        col_pnls = pnl(f_ind).de;
        for d_ind = 1:length(col_pnls)
            pnls_hs(d_ind,f_ind) = col_pnls{d_ind}.select();
        end
    end
    set(pnls_hs(:),'xlim',[i f],...
        'ytick',[],'yticklabel',{},'ycolor',[1 1 1],...
        'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
    
    for r = 3:rownum-1
        c = pnls_hs(r,1);
        line([i,f],[0 0],'parent',c,'color',[.8 .8 .8],'tag','baseline');
    end
    
    maxdiff = -Inf;
    for r = 1:rownum
        curraxes = pnls_hs(r,:);
        ylims = [Inf -Inf];
        for c = curraxes
            axis(c,'tight');
            yl = get(c,'ylim');
            ylims(1) = min([ylims(1) min(yl)]);
            ylims(2) = max([ylims(2) max(yl)]);
        end
        set(curraxes(:),'ylim',ylims);
        linkaxes(curraxes(:),'y');
        if r>2 && r<rownum
            maxdiff = max(maxdiff,diff(ylims));
        end
    end
    for r = 3:rownum-1
        c = pnls_hs(r,1);
        yl = get(c,'ylim');
        cdiff = maxdiff-diff(yl);
        set(c,'ylim',cdiff/2*[-1 1]+yl);
    end
    ylims = get(pnls_hs(2,1),'ylim');
    set(pnls_hs(rownum,:),'ylim',ylims);
    for r = 1:rownum
        cs = pnls_hs(r,:);
        yl = get(cs(1),'ylim');
        fs = findobj(cs,'tag','fiducials');
        set(fs,'ydata',yl);
    end
    
    voltaxes = pnls_hs(1,:);
    linkaxes(voltaxes(:),'y');
    set(voltaxes,'ylim',ylims_voltage);
    xlabel(pnls_hs(end,end),regexprep(ac.name,'_','.'));
    
    % Finished with all columns (frequencies). Clean up plot
    ylabel(pnl(1,1).select(),'mV');
    ylabel(pnl(1,2).select(),'pA');
    for d_ind = 1:length(col_pnls)
        set(pnl(1,d_ind).select(),...
            'ytickmode','auto','yticklabelmode','auto','ycolor',[0 0 0]);
    end
    xlabel(pnl(1,d_ind).select(),'s');
    set(pnl(1,d_ind).select(),'xtickmode','auto','xticklabelmode','auto','xcolor',[0 0 0]);
    
    pnl.fontsize = 10;
    pnl.fontname = 'Arial';

    
    fn = fullfile(savedir,'vConductance',[ac.name, '_VoltageSine_Conductances_' regexprep(num2str(trial.params.amp),'\.','_') 'V.pdf']);
    figure(fig)
    eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
    
    set(fig,'paperpositionMode','auto');
    saveas(fig,fullfile(savedir,'vConductance',[ac.name, '_VoltageSine_Conductances_' regexprep(num2str(trial.params.amp),'\.','_') 'V']),'fig');

end


%% Other routines

% %% Voltage Sines phase plots
% close all
% 
% trial = load(ac.trials.VoltageCommand);
% h = getShowFuncInputsFromTrial(trial);
% 
% cs_names = dir([h.dir '\VoltageSine_Raw_*']);
% trial = load(fullfile(h.dir,cs_names(end).name));
% 
% h = getShowFuncInputsFromTrial(trial);
% 
% tag_collections_VS = {};
% for pd_ind = 1:length(h.prtclData);    
%     tg_collection_str = sprintf('%s; ',h.prtclData(pd_ind).tags{:});
%     if ~ismember(tg_collection_str,tag_collections_VS);
%         tag_collections_VS{end+1} = tg_collection_str;
%         fprintf(1,'%s\n',tg_collection_str);
%     end
% end
% 
% trial_seeds = nan(length(trial.params.amps),length(trial.params.freqs),length(tag_collections_VS));
% 
% for pd_ind = 1:length(h.prtclData);    
%     a_ind = find(trial.params.amps== h.prtclData(pd_ind).amp);
%     f_ind = find(trial.params.freqs== h.prtclData(pd_ind).freq);
%     t_ind = find(strcmp(tag_collections_VS,sprintf('%s; ',h.prtclData(pd_ind).tags{:})));
%     if isnan(trial_seeds(a_ind,f_ind,t_ind))
%         trial_seeds(a_ind,f_ind,t_ind) = h.prtclData(pd_ind).trial;
%     end 
% end
% 
% clrs = distinguishable_colors(size(trial_seeds,3),{'w','k',[1 1 0],[1 1 1]*.75});
% 
% for a_ind = 1:size(trial_seeds,1)
%     fig = figure();
%     set(fig,'color',[1 1 1],'position',[1 1 820 980],'name',[ac.name '_VoltageSine_' num2str(trial.params.amps(a_ind)) 'V']);
%     pnl = panel(fig);
%     pnl.margin = [18 18 10 10];
%     pnl.pack('h',size(trial_seeds,2));
%     pnl.de.margin = [10 10 10 10];
%     
%     ylims = [Inf -Inf];
%     xlims_voltage = [Inf -Inf];
%     ylims_voltage = [Inf -Inf];
% 
%     for f_ind = 1:size(trial_seeds,2)
% 
%         rownum = size(trial_seeds,3)+2;
% 
%         pnl(f_ind).pack('v',size(trial_seeds,3)+2);
%         trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,1))));
%         trials = findLikeTrials('name',trial.name);
%         x = makeInTime(trial.params);
%         i = .03;
%         f = trial.params.stimDurInSec -.03;
% 
%         voltage = zeros(size(trial.voltage));
%         
%         for tr_ind = trials
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,tr_ind)));
%             voltage = voltage+trial.voltage;
%         end
%         voltage = smooth(voltage/length(trials),20);
%         
%         xlims_voltage(1) = min([xlims_voltage(1) min(voltage(x>i &x<f))]);
%         xlims_voltage(2) = max([xlims_voltage(2) max(voltage(x>i &x<f))]);
% 
%         dV_dt = gradient(voltage,diff(x(1:2)));
%         
%         ylims_voltage(1) = min([ylims_voltage(1) min(dV_dt(x>i &x<f))]);
%         ylims_voltage(2) = max([ylims_voltage(2) max(dV_dt(x>i &x<f))]);
% 
%         line(voltage(x>i&x<f),dV_dt(x>i&x<f),'color',[0 0 0],'displayname','VClamp_command','parent',pnl(f_ind,1).select());
% 
%         line(voltage(x>i&x<i+0.0036),dV_dt(x>i&x<i+0.0036),...
%             'color',[1 1 0],'linewidth',2,'displayname','VClamp_command','parent',pnl(f_ind,1).select());
%         line(voltage(x>i&x<i+1/trial.params.sampratein),dV_dt(x>i&x<i+1/trial.params.sampratein),...
%             'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(f_ind,1).select());
%         line(voltage(x>i+0.0036 & x<i+0.0036+2/trial.params.sampratein),dV_dt(x>i+0.0036&x<i+0.0036+2/trial.params.sampratein),...
%             'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(f_ind,1).select());
% 
%         for t_ind = 1:size(trial_seeds,3)
% 
%             clr = clrs(t_ind,:);
%             
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(a_ind,f_ind,t_ind))));
% 
%             tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
% 
%             trials = findLikeTrials('name',trial.name);
%             
%             x = makeInTime(trial.params);
% 
%             current = zeros(size(trial.voltage));
%             for tr_ind = trials
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,tr_ind)));
%                 current = current+trial.current;
%             end
%             current = smooth(current/length(trials),10);
%             
%             tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
%             if ~isempty(tg),
%                 %tg = drugmap.(tg);
%             else tg = 'ctrl';
%             end
% 
%             if t_ind==1,
%                 current_0 = current;
%                 
%                 line(voltage(x>i&x<f),current(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(f_ind,2).select());
%                 line(voltage(x>i&x<i+0.0036),current(x>i&x<i+0.0036),...
%                     'color',[1 1 0],'linewidth',2,'parent',pnl(f_ind,2).select());
%                 line(voltage(x>i&x<i+1/trial.params.sampratein),current(x>i&x<i+1/trial.params.sampratein),...
%                     'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(f_ind,2).select());
%                 line(voltage(x>i+0.0036 & x<i+0.0036+2/trial.params.sampratein),current(x>i+0.0036&x<i+0.0036+2/trial.params.sampratein),...
%                     'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(f_ind,2).select());
% 
%             elseif t_ind <= size(trial_seeds,3)
%                 current_1 = current;
%                 current_diff = current_0-current_1;
%                 tg = drugmap.(regexprep(tg,'4','Four'));
%                 
%                 line(voltage(x>i&x<f),current_diff(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(f_ind,t_ind+1).select());
%                 line(voltage(x>i&x<i+0.0036),current_diff(x>i&x<i+0.0036),...
%                     'color',[1 1 0],'linewidth',2,'parent',pnl(f_ind,t_ind+1).select());
%                 line(voltage(x>i&x<i+1/trial.params.sampratein),current_diff(x>i&x<i+1/trial.params.sampratein),...
%                     'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(f_ind,t_ind+1).select());
%                 line(voltage(x>i+0.0036 & x<i+0.0036+2/trial.params.sampratein),current_diff(x>i+0.0036&x<i+0.0036+2/trial.params.sampratein),...
%                     'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(f_ind,t_ind+1).select());
% 
%                 ylabel(pnl(1,1+t_ind).select(),[tg '-sensitive (pA)']);
%                 
%                 current_0 = current_1;
%                 
%                 ylims(1) = min([ylims(1) min(current_diff(x>i &x<f))]);
%                 ylims(2) = max([ylims(2) max(current_diff(x>i &x<f))]);
%             
%                 if t_ind == 2
%                     line(voltage(x>i&x<f),current(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(f_ind,2).select());
%                     line(voltage(x>i&x<i+0.0036),current(x>i&x<i+0.0036),...
%                         'color',[1 1 0],'linewidth',2,'parent',pnl(f_ind,2).select());
%                     line(voltage(x>i&x<i+1/trial.params.sampratein),current(x>i&x<i+1/trial.params.sampratein),...
%                         'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(f_ind,2).select());
%                     line(voltage(x>i+0.0036 & x<i+0.0036+2/trial.params.sampratein),current(x>i+0.0036&x<i+0.0036+2/trial.params.sampratein),...
%                         'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(f_ind,2).select());
%                     
%                 end
% 
%             end
%             
%             if t_ind == size(trial_seeds,3) && t_ind > 1
% 
%                 line(voltage(x>i&x<f),current_1(x>i&x<f),'color',clr,'displayname','rem','parent',pnl(f_ind,2+t_ind).select());
%                 line(voltage(x>i&x<i+0.0036),current_1(x>i&x<i+0.0036),...
%                     'color',[1 1 0],'linewidth',2,'parent',pnl(f_ind,2+t_ind).select());
%                 line(voltage(x>i&x<i+1/trial.params.sampratein),current_1(x>i&x<i+1/trial.params.sampratein),...
%                     'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(f_ind,2+t_ind).select());
%                 line(voltage(x>i+0.0036 & x<i+0.0036+2/trial.params.sampratein),current_1(x>i+0.0036&x<i+0.0036+2/trial.params.sampratein),...
%                     'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(f_ind,2+t_ind).select());
% 
%             end
%             
%         end
%         title(pnl(f_ind,1).select(),[num2str(trial.params.freqs(f_ind)) ' Hz'],'interpreter','none');
% 
%         drawnow
% 
%     end
%    
%     col_pnls = pnl(1).de;
%     pnls_hs = zeros(length(col_pnls),length(trial.params.freqs));
%     
%     for f_ind = 1:size(trial_seeds,2);
%         col_pnls = pnl(f_ind).de;
%         for d_ind = 1:length(col_pnls)
%             pnls_hs(d_ind,f_ind) = col_pnls{d_ind}.select();
%         end
%     end
%     set(pnls_hs(:),'xlim',xlims_voltage,...
%         'ytick',[],'yticklabel',{},'ycolor',[1 1 1],...
%         'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
%     set(pnls_hs(1,:),'ylim',ylims_voltage);
%        
%     maxdiff = -Inf;
%     for r = 1:rownum
%         curraxes = pnls_hs(r,:);
%         ylims = [Inf -Inf];
%         for c = curraxes
%             axis(c,'tight');
%             yl = get(c,'ylim');
%             ylims(1) = min([ylims(1) min(yl)]);
%             ylims(2) = max([ylims(2) max(yl)]);
%         end
%         set(curraxes(:),'ylim',ylims);
%         linkaxes(curraxes(:),'y');
%         if r>2 && r<rownum
%             maxdiff = max(maxdiff,diff(ylims));
%         end
%     end
%     for r = 3:rownum-1
%         c = pnls_hs(r,1);
%         yl = get(c,'ylim');
%         cdiff = maxdiff-diff(yl);
%         set(c,'ylim',cdiff/2*[-1 1]+yl);
%     end
% 
%     ylabel(pnl(length(trial.params.freqs),rownum).select(),regexprep(ac.name,'_','.'));
%     
%     
%     % Finished with all columns (frequencies). Clean up plot
%     ylabel(pnl(1,1).select(),'dV/dt (mV/s)');
%     ylabel(pnl(1,2).select(),'pA');
%     for d_ind = 1:length(col_pnls)
%         set(pnl(1,d_ind).select(),...
%             'ytickmode','auto','yticklabelmode','auto','ycolor',[0 0 0]);
%     end
%     xlabel(pnl(1,d_ind).select(),'mV');
%     set(pnl(1,d_ind).select(),'xtickmode','auto','xticklabelmode','auto','xcolor',[0 0 0]);
%     
%     fn = fullfile(savedir,[ac.name, '_VoltageSine_IvsV_' regexprep(num2str(trial.params.amp),'\.','_') 'V.pdf']);
%     figure(fig)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
%     
% %     exfig = figure();
% %     example_column = 2;
% %     set(exfig,'color',[1 1 1],'position',[346 9 453 988]);
% %     
% %     col_pnls = pnl(example_column).de;
% %     for d_ind = 1:length(col_pnls)
% %         ax = copyobj(col_pnls{d_ind}.select(),exfig);
% %         pos = get(ax,'position');
% %         set(ax,'position',[.1 pos(2) .8 pos(4)],...
% %             'ytickmode','auto','yticklabelmode','auto','ycolor',[0 0 0],...
% %             'xtickmode','auto','xticklabelmode','auto','xcolor',[0 0 0],...
% %             'xgrid','on','ygrid','on');
% %         legend(ax,'toggle');
% %         l = findobj(exfig,'Tag','legend');
% %         set(l,'location','NorthWest','interpreter','none');
% %         if d_ind==2
% %             legend(ax,'toggle');
% %         end
% %     end
% %     
% %     fn = fullfile(savedir,[ac.name, '_VoltageSine_Example' foldXs{X_ind} 'X.pdf']);
% %     figure(exfig)
% %     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% 
% end
% 
% 
% %% Voltage Plateau for NaV current
% close all
% 
% cs_names = dir([h.dir '\VoltagePlateau_Raw_*']);
% trial = load(fullfile(h.dir,cs_names(end).name));
% 
% h = getShowFuncInputsFromTrial(trial);
%     
% blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock','steps','step'});
% t = 1;
% while t <= length(blocktrials)
%     trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock','step'});
%     blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
%     t = t+1;
% end
% 
% x = makeInTime(trial.params);
% % i = -600;
% % f = 400;
% 
% %Create a figure with the number of columns drugs
% fig = figure();
% set(fig,'color',[1 1 1],'position',[197 204  1240 742],'name',[ac.name '_VoltageSteps']);
% pnl = panel(fig);
% pnl.margin = [18 18 10 10];
% pnl.pack('h',length(blocktrials));
% pnl.de.margin = [10 10 10 10];
% 
% ylims = [Inf -Inf];
% ylims_voltage = [Inf -Inf];
% 
% steplims = [Inf -Inf];
% currlims = [Inf -Inf];
%     
% for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%     trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
%     % pnl(bt_ind).pack('v',{2/4,1/4,1/4});
%     PF_VoltageStepFam([pnl(bt_ind,1).select() pnl(bt_ind,2).select()],getShowFuncInputsFromTrial(trial),'');
%         
%     tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
%     if ~isempty(tg),
%         tg = drugmap.(tg);
%     else tg = 'ctrl';
%     end
% 
%     pnl(bt_ind).title(tg);
%     set(pnl(bt_ind,1).select(),'ylim',[i f],...
%         'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
%     set(pnl(bt_ind,2).select(),'ylim',[-100 10],...
%         'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
% 
%     PF_VoltageStepIVRelationship([pnl(bt_ind,3).select()],getShowFuncInputsFromTrial(trial),'');
%     axis(pnl(bt_ind,3).select(),'tight'); %'ylim',[-100 300],'xlim',[-60 40]);
%     xlims = get(pnl(bt_ind,3).select(),'xlim');
%     steplims(1) = min([steplims(1) xlims(1)]);
%     steplims(2) = max([steplims(2) xlims(2)]);
%     ylims = get(pnl(bt_ind,3).select(),'ylim');
%     currlims(1) = min([currlims(1) ylims(1)]);
%     currlims(2) = max([currlims(2) ylims(2)]);
% 
% end
% 
% ylabel(pnl(1,1).select(),'pA');
% ylabel(pnl(1,2).select(),'mV');
% xlabel(pnl(1,2).select(),'s');
% xlabel(pnl(length(blocktrials),2).select(),regexprep(ac.name,'_','.'));
% 
% for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%     set(pnl(bt_ind,3).select(),'xlim',steplims,'ylim',currlims);
% end
% 
% fn = fullfile(savedir,[ac.name, '_VoltageSteps.pdf']);
% figure(fig)
% eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% 
% for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%     set(pnl(bt_ind,1).select(),'xlim',[-.005 .02]);
% end
% 
% fn = fullfile(savedir,[ac.name, '_VoltageSteps_onset.pdf']);
% figure(fig)
% eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% 
% for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%     set(pnl(bt_ind,1).select(),'xlim',trial.params.stimDurInSec+[-.005 .01]);
% end
% 
% fn = fullfile(savedir,[ac.name, '_VoltageSteps_offset.pdf']);
% figure(fig)
% eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% 
% %% Current Steps
% 
% cs_names = dir([h.dir '\CurrentStep_Raw_*']);
% if length(cs_names)>0
%     
% trial = load(fullfile(h.dir,cs_names(end).name));
% 
% h = getShowFuncInputsFromTrial(trial);
%     
% blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock','steps','step'});
% t = 1;
% while t <= length(blocktrials)
%     trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock','step'});
%     blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
%     t = t+1;
% end
% 
% x = makeInTime(trial.params);
% i = -160;
% f = 40;
% 
% %Create a figure with the number of columns drugs
% fig = figure();
% set(fig,'color',[1 1 1],'position',[1 355 1920 570],'name',[ac.name '_VoltageSteps']);
% pnl = panel(fig);
% pnl.margin = [18 18 10 10];
% pnl.pack('h',length(blocktrials));
% pnl.de.margin = [10 10 10 10];
% 
% ylims = [Inf -Inf];
% ylims_voltage = [Inf -Inf];
% 
%     
% for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%     trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
%     pnl(bt_ind).pack('v',{2/3,1/3});
%     PF_CurrentStepFam([pnl(bt_ind,1).select() pnl(bt_ind,2).select()],getShowFuncInputsFromTrial(trial),'');
%         
%     tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
%     if ~isempty(tg),
%         tg = drugmap.(tg);
%     else tg = 'ctrl';
%     end
% 
%     pnl(bt_ind).title(tg);
%     set(pnl(bt_ind,1).select(),'ylim',[i f],...
%         'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
% end
% 
% ylabel(pnl(1,1).select(),'mV');
% ylabel(pnl(1,2).select(),'pA');
% xlabel(pnl(1,2).select(),'s');
% 
% xlabel(pnl(length(blocktrials),2).select(),regexprep(ac.name,'_','.'));
% 
% fn = fullfile(savedir,[ac.name, '_CurrentSteps.pdf']);
% figure(fig)
% eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% 
% end
% 
% %% Current Chirps
% close all
% cs_names = dir([h.dir '\CurrentChirp_Raw_*']);
% trial = load(fullfile(h.dir,cs_names(end).name));
% 
% h = getShowFuncInputsFromTrial(trial);
%     
% blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock','amps','amp'});
% t = 1;
% while t <= length(blocktrials)
%     trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock','amp'});
%     blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
%     t = t+1;
% end
% 
% %blocktrials = blocktrials([1,2,5]);
% blocktrials = blocktrials+1;
% x = makeInTime(trial.params);
% i = 0;
% f = .6;
% 
% %Create a figure with the number of columns drugs
% fig = figure();
% set(fig,'color',[1 1 1],'units','inches','position',[1 3 10 7],'name',[ac.name '_CurrentChirps']);
% pnl = panel(fig);
% pnl.margin = [20 18 6 12];
% pnl.pack('h',length(blocktrials));
% pnl.de.margin = [20 18 2 2];
% 
% ylims = [Inf -Inf];
% ylims_voltage = [Inf -Inf];
% 
% maxdiff = -Inf;
% for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%     trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
%     
%     pnl(bt_ind).pack('v',{3/10,1/10,3/10,3/10});
% 
%     trials = findLikeTrials('trial',blocktrials(bt_ind),'datastruct',h.prtclData);
%     current = zeros(size(x));
%     voltage = zeros(size(x));
%     for t_ind = 1:length(trials);
%         trial_temp = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
%         current = current+trial_temp.current;
%         voltage = voltage+trial_temp.voltage;
%     end
%     current = current/length(trials);
%     voltage = smooth(voltage/length(trials),10);
%     line(x,voltage,'parent',pnl(bt_ind,1).select(),'color',[0 0 0]);
%     line(x,current,'parent',pnl(bt_ind,2).select(),'color',[1 1 1]*.7);
% 
%     xlim(pnl(bt_ind,1).select(),[-.1 trial.params.stimDurInSec+.1]);
%     axis(pnl(bt_ind,2).select(),'tight');
%     set(pnl(bt_ind,2).select(),'xlim',[-.1 trial.params.stimDurInSec+.1],'xtick',[],'ytick',[]);
% 
%     PF_CurrentChirpZAPFam([pnl(bt_ind,3).select() pnl(bt_ind,4).select()],getShowFuncInputsFromTrial(trial),'');
%         
%     tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
%     if ~isempty(tg),
%         tg = drugmap.(tg);
%     else tg = 'ctrl';
%     end
% 
%     title(pnl(bt_ind,1).select(),tg);
%     axis(pnl(bt_ind,1).select(),'tight');
%     ylims = get(pnl(bt_ind,1).select(),'ylim');
%     maxdiff = max([maxdiff diff(ylims)]);
%     
%     set(pnl(bt_ind,3).select(),'ylim',[i f],...
%         'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
%     set(pnl(bt_ind,4).select(),'ylim',[-180 180]);
% end
% for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%     ylims = get(pnl(bt_ind,1).select(),'ylim');
%     set(pnl(bt_ind,1).select(),'ylim',ylims(1) + diff(ylims)/2 + maxdiff*[-1/2 1/2]);
% end
% ylabel(pnl(1,1).select(),'mV');
% ylabel(pnl(1,3).select(),'|Z(f)| (G\Omega)');
% ylabel(pnl(1,4).select(),'phase');
% xlabel(pnl(1,4).select(),'Hz');
% pnl.fontname = 'Arial';
% pnl.fontsize = 18;
% 
% xlabel(pnl(length(blocktrials),4).select(),regexprep(ac.name,'_','.'));
% 
% fn = fullfile(savedir,[ac.name, '_CurrentChirps.pdf']);
% figure(fig)
% eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% 
% %% SineResponse stimuli, plots are scaled to match amplitude
% close all
% if ~isempty(foldXs{1})
% for X_ind = 1:length(foldXs)*--
%     X_stimnames = foldX_stimnames{X_ind};
%     
%     %Create a figure with the number of rows in stimnames (frequency)
%     fig = figure();
%     set(fig,'color',[1 1 1],'position',[1 1 1920 1004],'name',[ac.name '_SineResponses_' foldXs{X_ind} 'X']);
%     pnl = panel(fig);
%     pnl.margin = [18 18 10 10];
%     pnl.pack('h',length(X_stimnames));
%     pnl.de.margin = [6 6 6 6];
%     
%     ylims = [Inf -Inf];
%     ylims_voltage = [Inf -Inf];
%     for S_ind = 1:length(X_stimnames)
%         sn = X_stimnames{S_ind};
%         
%         pd_ind = 0;
%         while pd_ind<length(h.prtclData)
%             pd_ind = pd_ind+1;
%             if strcmp(h.prtclData(pd_ind).stimulusName,sn)
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
%                 break
%             end
%         end
%         
%         blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock'});
%         t = 1;
%         while t <= length(blocktrials)
%             trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock'});
%             blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
%             t = t+1;
%         end
%         
%         x = makeInTime(trial.params);
%         i = -0.03;
%         f = 0.075;
%         
%         rownum = length(blocktrials)+2;
%         pnl(S_ind).pack('v',rownum);
%         
%         clrs = distinguishable_colors(size(blocktrials,2),{'w','k',[1 1 0],[1 1 1]*.75});
% 
%         for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%             clr = clrs(bt_ind,:);
%             trials = findLikeTrials('trial',blocktrials(bt_ind),'datastruct',h.prtclData);
%             
%             current = zeros(size(x));
%             voltage = zeros(size(x));
%             
%             for t_ind = 1:length(trials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
%                 current = current+trial.current;
%                 voltage = voltage+trial.voltage;
%             end
%             current = smooth(current/length(trials),10);
%             voltage = voltage/length(trials);
%             
%             ylims(1) = min([ylims(1) min(current(x>i &x<f))]);
%             ylims(2) = max([ylims(2) max(current(x>i &x<f))]);
%             
%             tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
%             if ~isempty(tg),
%                 %tg = drugmap.(tg);
%             else tg = 'ctrl';
%             end
%             
%             line(x(x>i&x<f),current(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(S_ind,2).select());
%             
%             if bt_ind==1,
%                 current_0 = current;
%             elseif bt_ind <= length(blocktrials)
%                 current_1 = current;
%                 current_diff = current_0-current_1;
%                 tg = drugmap.(regexprep(tg,'4','Four'));
%                 line(x(x>i&x<f),current_diff(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(S_ind,1+bt_ind).select());
%                 ylabel(pnl(1,1+bt_ind).select(),[tg '-sensitive (pA)']);
%                 
%                 current_0 = current_1;
%                 
%                 ylims(1) = min([ylims(1) min(current_diff(x>i &x<f))]);
%                 ylims(2) = max([ylims(2) max(current_diff(x>i &x<f))]);
%             end
%             if bt_ind == length(blocktrials) && bt_ind > 1
%                 line(x(x>i&x<f),current_1(x>i&x<f),'color',clr,'displayname','rem','parent',pnl(S_ind,2+bt_ind).select());
%             end
%             
%         end
%         
%         % legend(pnl(S_ind,1).select(),'toggle');
%         % l = findobj(fig,'Tag','legend');
%         % set(l,'location','NorthWest','interpreter','none','box','off');
%         %ylabel(pnl(S_ind,1).select(),'pA');
%         title(pnl(S_ind,1).select(),sn,'interpreter','none');
%         line(x(x>i&x<f),voltage(x>i&x<f),'color',[0 0 0],'displayname','VClamp_command','parent',pnl(S_ind,1).select());
%         ylims_voltage(1) = min([ylims_voltage(1) min(voltage(x>i &x<f))]);
%         ylims_voltage(2) = max([ylims_voltage(2) max(voltage(x>i &x<f))]);
%         drawnow
%     end
%     
%     col_pnls = pnl(1).de;
%     pnls_hs = zeros(length(col_pnls),length(X_stimnames));
%     
%     for S_ind = 1:length(X_stimnames)
%         col_pnls = pnl(S_ind).de;
%         for d_ind = 1:length(col_pnls)
%             pnls_hs(d_ind,S_ind) = col_pnls{d_ind}.select();
%         end
%     end
%     set(pnls_hs(:),'xlim',[i f],...
%         'ytick',[],'yticklabel',{},'ycolor',[1 1 1],...
%         'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
%         
%     maxdiff = -Inf;
%     for r = 1:rownum
%         curraxes = pnls_hs(r,:);
%         ylims = [Inf -Inf];
%         for c = curraxes
%             axis(c,'tight');
%             yl = get(c,'ylim');
%             ylims(1) = min([ylims(1) min(yl)]);
%             ylims(2) = max([ylims(2) max(yl)]);
%         end
%         set(curraxes(:),'ylim',ylims);
%         linkaxes(curraxes(:),'y');
%         if r>2 && r<rownum
%             maxdiff = max(maxdiff,diff(ylims));
%         end
%     end
%     for r = 3:rownum-1
%         c = pnls_hs(r,1);
%         yl = get(c,'ylim');
%         cdiff = maxdiff-diff(yl);
%         set(c,'ylim',cdiff/2*[-1 1]+yl);
%     end
% 
%     voltaxes = pnls_hs(1,:);
%     linkaxes(voltaxes(:),'y');
%     set(voltaxes,'ylim',ylims_voltage);
%     ylabel(pnl(length(X_stimnames),rownum).select(),regexprep(ac.name,'_','.'));
%     
%     
%     % Finished with all columns (frequencies). Clean up plot
%     ylabel(pnl(1,1).select(),'mV');
%     ylabel(pnl(1,2).select(),'pA');
%     for d_ind = 1:length(col_pnls)
%         set(pnl(1,d_ind).select(),...
%             'ytickmode','auto','yticklabelmode','auto','ycolor',[0 0 0]);
%     end
%     xlabel(pnl(1,d_ind).select(),'s');
%     set(pnl(1,d_ind).select(),'xtickmode','auto','xticklabelmode','auto','xcolor',[0 0 0]);
%     
%     fn = fullfile(savedir,[ac.name, '_SinResp_BPH_Currents_' foldXs{X_ind} 'X.pdf']);
%     figure(fig)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
%     
%     exfig = figure();
%     example_column = 2;
%     set(exfig,'color',[1 1 1],'position',[346 9 453 988]);
%     
%     col_pnls = pnl(example_column).de;
%     for d_ind = 1:length(col_pnls)
%         ax = copyobj(col_pnls{d_ind}.select(),exfig);
%         pos = get(ax,'position');
%         set(ax,'position',[.1 pos(2) .8 pos(4)],...
%             'ytickmode','auto','yticklabelmode','auto','ycolor',[0 0 0],...
%             'xtickmode','auto','xticklabelmode','auto','xcolor',[0 0 0],...
%             'xgrid','on','ygrid','on');
%         legend(ax,'toggle');
%         l = findobj(exfig,'Tag','legend');
%         set(l,'location','NorthWest','interpreter','none');
%         if d_ind==2
%             legend(ax,'toggle');
%         end
%     end
%     
%     fn = fullfile(savedir,[ac.name, '_SinResp_BPL_example_' foldXs{X_ind} 'X.pdf']);
%     figure(exfig)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% end
% 
% end
% 
% 
% %% Phase plots
% close all
% if ~isempty(foldXs{1})
% 
% for X_ind = 1:length(foldXs)
% 
%     X_stimnames = foldX_stimnames{X_ind};
%     
%     %Create a figure with the number of rows in stimnames (frequency)
%     fig = figure();
%     set(fig,'color',[1 1 1],'position',[4 10 1916 935],'name',[ac.name '_SineResponses_' foldXs{X_ind} 'X']);
%     pnl = panel(fig);
%     pnl.margin = [18 18 10 10];
%     pnl.pack('h',length(X_stimnames));
%     pnl.de.margin = [6 6 6 6];
% 
%     ylims = [Inf -Inf];
%     ylims_voltage = [Inf -Inf];
% 
%     for S_ind = 1:length(X_stimnames)
%         sn = X_stimnames{S_ind};
%         
%         pd_ind = 0;
%         while pd_ind<length(h.prtclData)
%             pd_ind = pd_ind+1;
%             if strcmp(h.prtclData(pd_ind).stimulusName,sn)
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
%                 break
%             end
%         end
%         
%         blocktrials = findLikeTrials('name',trial.name,'exclude',{'tags','trialBlock'});
%         t = 1;
%         while t <= length(blocktrials)
%             trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData,'exclude',{'trialBlock'});
%             blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
%             t = t+1;
%         end
%         
%         x = makeInTime(trial.params);
%         i = .03;
%         f = trial.params.stimDurInSec -.03;
%         
%         rownum = length(blocktrials)+2;
%         pnl(S_ind).pack('v',rownum);
%         
%         clrs = distinguishable_colors(size(blocktrials,2),{'w','k',[1 1 0],[1 1 1]*.75});
% 
%         for bt_ind = 1:length(blocktrials) % assuming the next trial block should be subtracted
%             clr = clrs(bt_ind,:);
%             trials = findLikeTrials('trial',blocktrials(bt_ind),'datastruct',h.prtclData);
%             
%             current = zeros(size(x));
%             voltage = zeros(size(x));
%             
%             for t_ind = 1:length(trials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
%                 current = current+trial.current;
%                 voltage = voltage+trial.voltage;
%             end
%             current = smooth(current/length(trials),10);
%             voltage = smooth(voltage/length(trials),10);
%             
%             ylims(1) = min([ylims(1) min(current(x>i &x<f))]);
%             ylims(2) = max([ylims(2) max(current(x>i &x<f))]);
%             
%             tg = strprfunc(strprfunc(sprintf('%s; ',trial.tags{:})));
%             if ~isempty(tg),
%                 %tg = drugmap.(tg);
%             else tg = 'ctrl';
%             end
%             
%             
%             if bt_ind==1,
%                 current_0 = current;
%                 line(voltage(x>i&x<f),current(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(S_ind,2).select());
% 
%                 line(voltage(x>i&x<i+0.0036),current(x>i&x<i+0.0036),'color',[1 1 0],'linewidth',2,'displayname','VClamp_command','parent',pnl(S_ind,2).select());
%                 line(voltage(x>i&x<i+1/trial.params.sampratein),current(x>i&x<i+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(S_ind,2).select());
%                 line(voltage(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),current(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(S_ind,2).select());
%             elseif bt_ind <= length(blocktrials)
%                 current_1 = current;
%                 current_diff = current_0-current_1;
%                 tg = drugmap.(regexprep(tg,'4','Four'));
%                 line(voltage(x>i&x<f),current_diff(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(S_ind,bt_ind+1).select());
% 
%                 line(voltage(x>i&x<i+0.0036),current_diff(x>i&x<i+0.0036),'color',[1 1 0],'linewidth',2,'displayname','VClamp_command','parent',pnl(S_ind,bt_ind+1).select());
%                 line(voltage(x>i&x<i+1/trial.params.sampratein),current_diff(x>i&x<i+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(S_ind,bt_ind+1).select());
%                 line(voltage(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),current_diff(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(S_ind,bt_ind+1).select());
% 
%                 ylabel(pnl(1,1+bt_ind).select(),[tg '-sensitive (pA)']);
%                 
%                 current_0 = current_1;
%                 
%                 ylims(1) = min([ylims(1) min(current_diff(x>i &x<f))]);
%                 ylims(2) = max([ylims(2) max(current_diff(x>i &x<f))]);
% 
%                 if bt_ind== 2
%                     line(voltage(x>i&x<f),current(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(S_ind,2).select());
%                     
%                     line(voltage(x>i&x<i+0.0036),current(x>i&x<i+0.0036),'color',[1 1 0],'linewidth',2,'displayname','VClamp_command','parent',pnl(S_ind,2).select());
%                     line(voltage(x>i&x<i+1/trial.params.sampratein),current(x>i&x<i+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(S_ind,2).select());
%                     line(voltage(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),current(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(S_ind,2).select());
%                 end
%             end
%             if bt_ind == length(blocktrials) && bt_ind>1
%                 line(voltage(x>i&x<f),current_1(x>i&x<f),'color',clr,'displayname','rem','parent',pnl(S_ind,2+bt_ind).select());
% 
%                 line(voltage(x>i&x<i+0.0036),current_1(x>i&x<i+0.0036),'color',[1 1 0],'linewidth',2,'displayname','VClamp_command','parent',pnl(S_ind,bt_ind+2).select());
%                 line(voltage(x>i&x<i+1/trial.params.sampratein),current_1(x>i&x<i+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(S_ind,bt_ind+2).select());
%                 line(voltage(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),current_1(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(S_ind,bt_ind+2).select());
%             end
%             
%         end
%         
%         % legend(pnl(S_ind,1).select(),'toggle');
%         % l = findobj(fig,'Tag','legend');
%         % set(l,'location','NorthWest','interpreter','none','box','off');
%         % ylabel(pnl(S_ind,1).select(),'pA');
%         
%         title(pnl(S_ind,1).select(),sn,'interpreter','none');
%         dV_dt = gradient(voltage,diff(x(1:2)));
%         
%         line(voltage(x>i&x<f),dV_dt(x>i&x<f),'color',[0 0 0],'displayname','VClamp_command','parent',pnl(S_ind,1).select());
% 
%         line(voltage(x>i&x<i+0.0036),dV_dt(x>i&x<i+0.0036),'color',[1 1 0],'linewidth',2,'displayname','VClamp_command','parent',pnl(S_ind,1).select());
%         line(voltage(x>i&x<i+1/trial.params.sampratein),dV_dt(x>i&x<i+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','o','parent',pnl(S_ind,1).select());
%         line(voltage(x>i+0.0036 & x<i+0.0036+1/trial.params.sampratein),dV_dt(x>i+0.0036&x<i+0.0036+1/trial.params.sampratein),'markerfacecolor',[1 1 0],'linestyle','none','marker','v','parent',pnl(S_ind,1).select());
% 
%         ylims_voltage(1) = min([ylims_voltage(1) min(dV_dt(x>i &x<f))]);
%         ylims_voltage(2) = max([ylims_voltage(2) max(dV_dt(x>i &x<f))]);
%         drawnow
%     end
%     
%     col_pnls = pnl(1).de;
%     pnls_hs = zeros(length(col_pnls),length(X_stimnames));
%     
%     for S_ind = 1:length(X_stimnames)
%         col_pnls = pnl(S_ind).de;
%         for d_ind = 1:length(col_pnls)
%             pnls_hs(d_ind,S_ind) = col_pnls{d_ind}.select();
%             axis(pnls_hs(d_ind,S_ind),'tight');
%         end
%     end
%     
%     xlims = [Inf -Inf];
%     for r = 1:rownum
%         curraxes = pnls_hs(r,:);
%         ylims = [Inf -Inf];
%         for c = curraxes
%             axis(c,'tight');
%             yl = get(c,'ylim');
%             ylims(1) = min([ylims(1) min(yl)]);
%             ylims(2) = max([ylims(2) max(yl)]);
%             
%             xl = get(c,'xlim');
%             xlims(1) = min([xlims(1) min(xl)]);
%             xlims(2) = max([xlims(2) max(xl)]);
%             
%         end
%         set(curraxes(:),'ylim',ylims);
%         linkaxes(curraxes(:),'y');
%     end
%  
%     set(pnls_hs(:),'xlim',xlims,...
%         'ytick',[],'yticklabel',{},'ycolor',[1 1 1],...
%         'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);
%     
%     xlabel(pnl(length(X_stimnames),rownum).select(),regexprep(ac.name,'_','.'));
% 
%     % Finished with all columns (frequencies). Clean up plot
%     ylabel(pnl(1,1).select(),'dV/dt (V/s)');
%     for d_ind = 1:length(col_pnls)
%         set(pnl(1,d_ind).select(),...
%             'ytickmode','auto','yticklabelmode','auto','ycolor',[0 0 0]);
%     end
%     xlabel(pnl(1,d_ind).select(),'mV');
%     set(pnl(1,d_ind).select(),'xtickmode','auto','xticklabelmode','auto','xcolor',[0 0 0]);
%     
%     fn = fullfile(savedir,[ac.name, '_SinResp_BPH_IvsV_' foldXs{X_ind} 'X.pdf']);
%     figure(fig)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
%     
%     exfig = figure();
%     example_column = 2;
%     set(exfig,'color',[1 1 1],'position',[346 9 453 988]);
%     
%     col_pnls = pnl(example_column).de;
%     for d_ind = 1:length(col_pnls)
%         ax = copyobj(col_pnls{d_ind}.select(),exfig);
%         pos = get(ax,'position');
%         set(ax,'position',[.1 pos(2) .8 pos(4)],...
%             'ytickmode','auto','yticklabelmode','auto','ycolor',[0 0 0],'xgrid','on','ygrid','on');
%         %legend(ax,'toggle');
%         %l = findobj(exfig,'Tag','legend');
%         %set(l,'location','NorthWest','interpreter','none');
%     end
%     set(ax,'xtickmode','auto','xticklabelmode','auto','xcolor',[0 0 0]);
%     
%     fn = fullfile(savedir,[ac.name, '_SinResp_BPH_IvsVexmpl_' foldXs{X_ind} 'X.pdf']);
%     figure(exfig)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% end
% end
% 



