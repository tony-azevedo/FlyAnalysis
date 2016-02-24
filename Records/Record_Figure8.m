%% Figure 8 intrinsic properties

% clear 
close all
figure8 = figure;

Record_VClampCurrentIsolation_Cells
figure8.Units = 'inches';
set(figure8,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneColumn'),9.5])
pnl = panel(figure8);

figurerows = [2 3 3 3];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);
pnl.margin = [16 16 4 4];


%% Plot VStep Fam for example cells
pnl(1).pack('h',3) 
pnl(1).margin = [4 4 4 4];
pnl(2).pack('h',3) 
pnl(2).margin = [16 10 4 4];

ylims = [Inf, -Inf];

geno_idx = [3 1 2];

d1 = getpref('FigureMaking','CurrentFilter');
dT = [...
    0.0004 0.0003
    0.00035 0.00018
    0.0003 0.00018];

for type_idx =  1:length(geno_idx)
    pnl(1,type_idx).pack('v',{1/6 5/6});
    stimax = pnl(1,type_idx,1).select();
    famax = pnl(1,type_idx,2).select();
    
    trial = load(example_fig8.VoltageStep{type_idx});
    h = getShowFuncInputsFromTrial(trial);
    t = findLikeTrials('name',h.trial.name);
    blocktrials = findBlockTrials(h.trial,h.prtclData);

    x = makeInTime(h.trial.params);
    x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
    voltage = 0;
    current = zeros(length(x),length(blocktrials));
    steps = blocktrials;
    for bt_ind = 1:length(blocktrials);
        trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
 
        steps(bt_ind) = trial.params.step;
        line(x,VoltageStepStim(trial.params),'parent',stimax,'color',[.8 .8 .8],'tag','VStep','userdata',steps(bt_ind));

        voltage_ = 0;
        trials = findLikeTrials('name',trial.name,'datastruct',h.prtclData);
        for t_ind = 1:length(trials);
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
            voltage_ = voltage_ + mean(trial.voltage(x>-trial.params.stimDurInSec+.07&x<0));
            current(:,bt_ind) = current(:,bt_ind)+trial.current;
        end
        voltage_ = voltage_/t_ind;
        voltage = voltage+voltage_;
        
        current(:,bt_ind) = current(:,bt_ind)/length(trials);
        current(x_transwin,bt_ind) = nan;

        line(x,current(:,bt_ind),'parent',famax,'color',0*[.8 .8 .8],'tag','I','userdata',steps(bt_ind));

    end
    delete(findobj(stimax,'type','line','userdata',25))
    delete(findobj(famax,'type','line','userdata',25))
    
    voltage = voltage/bt_ind;
    set(findobj(stimax,'type','line','tag','VStep'),'userdata',voltage);
    set([stimax,famax],'xlim',[-.03 trial.params.stimDurInSec+.03],...
        'tickdir','out','xtick',[],'xcolor',[1 1 1],'ytick',[],'ycolor',[1 1 1]);
    set(famax,'ylim',[-570 200])

    ac = analysis_cell(genotype_idx==geno_idx(type_idx));
    clrs = distinguishable_colors(length(ac),{'w','k',[1 1 0],[1 1 1]*.75});

    iv_ax = pnl(2,type_idx).select(); hold(iv_ax,'on');
    
    for ac_idx = 1:length(ac)
        
        disp(ac(ac_idx).name)
        trial = load(ac(ac_idx).trials.VoltageStep);
        h = getShowFuncInputsFromTrial(trial);
        t = findLikeTrials('name',h.trial.name);
 
        [V,I,Base] = PF_VoltageStepIVRelationship_NoPlot(h,'');
        plot(iv_ax,V(V<=20)-Base,I(V<=20),...
            'tag',ac(ac_idx).name,...
            'displayname',[num2str(h.trial.params.step),' V' ],...
            'color',clrs(ac_idx,:));
        drawnow
    end
    set(iv_ax,'xlim',[-62 17],'ylim',[-300 500],...
        'tickdir','out','ytick',[],'ycolor',[1 1 1]);
    
end
iv_ax = pnl(2,1).select(); 
set(iv_ax,'ytickmode','auto','ycolor',[0 0 0]);

%% plot the on and off steps 
pnl(3).pack('h',2) 
pnl(3).margin = [16 10 4 4];

geno_idx = [3 1 2];
dT = [...
    0.0004 0.0003
    0.00035 0.00018
    0.0003 0.00018];

on_ax = pnl(3,2).select(); hold(on_ax,'on');
off_ax = pnl(3,1).select(); hold(off_ax,'on');

lght_clrs = [
    .7 1 .7
    .7 .7 1
    1 .7 .7];
clrs = [
    0 .5 0
    0 0 .7
    .7 0 0];

for type_idx = 1:length(geno_idx)
    ac = analysis_cell(genotype_idx==geno_idx(type_idx));
    %clrs = distinguishable_colors(length(ac),{'w','k',[1 1 0],[1 1 1]*.75});
    
    for ac_idx = 1:length(ac)
        
        disp(ac(ac_idx).name)
        trial = load(ac(ac_idx).trials.VoltageStep);
        h = getShowFuncInputsFromTrial(trial);
        if ~sum(h.trial.params.steps == -60)
            continue
        end
        for pd_ind = 1:length(h.prtclData);
            
            if h.prtclData(pd_ind).step == -60 && isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'TTX')) 
%                     (~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'curare')) || ~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'MLA'))) && ...
                    
                ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
                if isfield(ex,'excluded') && ex.excluded
                    continue
                else
                    break
                end
            end
        end
        trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
        h = getShowFuncInputsFromTrial(trial);
        trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
        
        x = makeInTime(trial.params);        
        x_win = x>=trial.params.stimDurInSec-.004 & x<trial.params.stimDurInSec+.008;
        x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));

        current = zeros(size(x));        
        for trial_ind = 1:length(trials);
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
            current = current+trial.current;
        end
        current = current/length(trials);
        current(x_transwin) = nan;
        
        plot(off_ax,x(x_win),current(x_win),...
            'tag',['geno_' num2str(type_idx)],...
            'displayname',ac(ac_idx).name,...
            'color',lght_clrs(type_idx,:));
        drawnow
 
        % step up
        trial = load(ac(ac_idx).trials.VoltageStep);
        h = getShowFuncInputsFromTrial(trial);
        if ~sum(h.trial.params.steps == 10)
            continue
        end
        for pd_ind = 1:length(h.prtclData);
            
            if h.prtclData(pd_ind).step == 10 && isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'TTX'))
%                     (~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'curare')) || ~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'MLA'))) && ...

                ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
                if isfield(ex,'excluded') && ex.excluded
                    continue
                else
                    break
                end
            end
        end
        trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
        h = getShowFuncInputsFromTrial(trial);
        trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
        
        x = makeInTime(trial.params);        
        x_win = x>=-.015 & x<+.03;
        x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));

        current = zeros(size(x));        
        for trial_ind = 1:length(trials);
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
            current = current+trial.current;
        end
        current = current/length(trials);
        current(x_transwin) = nan;
        
        plot(on_ax,x(x_win),current(x_win),...
            'tag',['geno_' num2str(type_idx)],...
            'displayname',ac(ac_idx).name,...
            'color',lght_clrs(type_idx,:));
        drawnow

        
    end
    set(off_ax,'ylim',[-800 100],...
        'tickdir','out');
    
    l = findobj(off_ax,'type','line','tag',['geno_' num2str(type_idx)]);
    set(l,'color',lght_clrs(type_idx,:));
    y = cell2mat(get(l,'ydata'));
    line(get(l(1),'xdata'),mean(y,1),'parent',off_ax,...
        'color',clrs(type_idx,:),'linestyle','-',...
        'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);

    set(on_ax,'ylim',[-50 250],...
        'tickdir','out');
    
    l = findobj(on_ax,'type','line','tag',['geno_' num2str(type_idx)]);
    set(l,'color',lght_clrs(type_idx,:));
    y = cell2mat(get(l,'ydata'));
    line(get(l(1),'xdata'),mean(y,1),'parent',on_ax,...
        'color',clrs(type_idx,:),'linestyle','-',...
        'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);

end
% iv_ax = pnl(2,1).select(); 
% set(iv_ax,'ytickmode','auto','ycolor',[0 0 0]);

%savePDFandFIG(figure8,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8',[],'Figure8');

%% plot the on and off steps for the para
pnl(4).pack('h',2) 
pnl(4).margin = [16 10 4 4];

Record_VClampCurrentIsolation_Cells

clear analysis_cell analysis_cells
analysis_grid = cesiumPara_grid;
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end
genotypes = analysis_grid(:,2);
[genotype_set,~,genotype_idx] = unique(genotypes);

Script_VClamp_Cells_A2
Script_VClamp_Cells_Fru
Script_VClamp_Cells_VT


geno_idx = [3 1 2];
dT = [...
    0.0004 0.0003
    0.00035 0.00018
    0.0003 0.00018];


on_ax = pnl(4,2).select(); hold(on_ax,'on');
off_ax = pnl(4,1).select(); hold(off_ax,'on');

lght_clrs = [
    .7 1 .7
    .7 .7 1
    1 .7 .7];
clrs = [
    0 .5 0
    0 0 .7
    .7 0 0];

for type_idx = 1:length(geno_idx)
    ac = analysis_cell(genotype_idx==geno_idx(type_idx));
    %clrs = distinguishable_colors(length(ac),{'w','k',[1 1 0],[1 1 1]*.75});
    
    for ac_idx = 1:length(ac)
        
        disp(ac(ac_idx).name)
        trial = load(ac(ac_idx).trials.VoltageStep);
        h = getShowFuncInputsFromTrial(trial);
        if ~sum(h.trial.params.steps == -60)
            continue
        end
        for pd_ind = 1:length(h.prtclData);
            
            if h.prtclData(pd_ind).step == -60 && isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'TTX')) 
%                     (~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'curare')) || ~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'MLA'))) && ...
                    
                ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
                if isfield(ex,'excluded') && ex.excluded
                    continue
                else
                    break
                end
            end
        end
        trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
        h = getShowFuncInputsFromTrial(trial);
        trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
        
        x = makeInTime(trial.params);        
        x_win = x>=trial.params.stimDurInSec-.004 & x<trial.params.stimDurInSec+.008;
        x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));

        current = zeros(size(x));        
        for trial_ind = 1:length(trials);
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
            current = current+trial.current;
        end
        current = current/length(trials);
        current(x_transwin) = nan;
        
        plot(off_ax,x(x_win),current(x_win),...
            'tag',['geno_' num2str(type_idx)],...
            'displayname',ac(ac_idx).name,...
            'color',lght_clrs(type_idx,:));
        drawnow
 
        % step up
        trial = load(ac(ac_idx).trials.VoltageStep);
        h = getShowFuncInputsFromTrial(trial);
        if ~sum(h.trial.params.steps == 10)
            continue
        end
        for pd_ind = 1:length(h.prtclData);
            
            if h.prtclData(pd_ind).step == 10 && isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'TTX'))
%                     (~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'curare')) || ~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'MLA'))) && ...

                ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
                if isfield(ex,'excluded') && ex.excluded
                    continue
                else
                    break
                end
            end
        end
        trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
        h = getShowFuncInputsFromTrial(trial);
        trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
        
        x = makeInTime(trial.params);        
        x_win = x>=-.015 & x<+.03;
        x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));

        current = zeros(size(x));        
        for trial_ind = 1:length(trials);
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
            current = current+trial.current;
        end
        current = current/length(trials);
        current(x_transwin) = nan;
        
        plot(on_ax,x(x_win),current(x_win),...
            'tag',['geno_' num2str(type_idx)],...
            'displayname',ac(ac_idx).name,...
            'color',lght_clrs(type_idx,:));
        drawnow

        
    end
    set(off_ax,'ylim',[-800 100],...
        'tickdir','out');
    
    l = findobj(off_ax,'type','line','tag',['geno_' num2str(type_idx)]);
    set(l,'color',lght_clrs(type_idx,:));
    y = cell2mat(get(l,'ydata'));
    line(get(l(1),'xdata'),mean(y,1),'parent',off_ax,...
        'color',clrs(type_idx,:),'linestyle','-',...
        'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);

    set(on_ax,'ylim',[-50 250],...
        'tickdir','out');

    l = findobj(on_ax,'type','line','tag',['geno_' num2str(type_idx)]);
    set(l,'color',lght_clrs(type_idx,:));
    y = cell2mat(get(l,'ydata'));
    line(get(l(1),'xdata'),mean(y,1),'parent',on_ax,...
        'color',clrs(type_idx,:),'linestyle','-',...
        'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);

end
% iv_ax = pnl(2,1).select(); 
% set(iv_ax,'ytickmode','auto','ycolor',[0 0 0]);

savePDFandFIG(figure8,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8',[],'Figure8');


%% Voltage step and Current chirp data for all fru, vt, offtarget cells with Cs internal

% 
% for t_ind = 1:3
%     clear transfer freqs dsplcmnts f
%     disp(types{t_ind})
%     eval(['analysis_cell = ' types{t_ind} ';']);
%     eval(['analysis_cells = ' types{t_ind} 's;']);
%             
%     pnl(r,t_ind).pack('v',{1/2 1/2});
%     step_ax_d = pnl(r,t_ind,2).select();
%     pnl(r,t_ind,2).margintop = 4;
%     step_ax_u = pnl(r,t_ind,1).select();
%     pnl(r,t_ind,1).marginbottom = 4;
%     pnl(r,t_ind,1).title(types{t_ind}(1:regexp(types{t_ind},'_')-1))
%     hold(step_ax_d,'on');
%     hold(step_ax_u,'on');
%     if t_ind ==1
%         pnl(r,t_ind,1).ylabel('pA');
%         pnl(r,t_ind,2).ylabel('pA');
%         pnl(r,t_ind,2).xlabel('s');
%         text(0.01,-100,'\DeltaV=15 mV','parent',step_ax_u);
%         text(0.11,-100,'\DeltaV=-60 mV','parent',step_ax_d);
%     end
%     
%     pnl(r+1,t_ind).pack('h',{1/2 1/2});
%     iv_ax = pnl(r+1,t_ind,1).select();
%     ramp_ax = pnl(r+1,t_ind,2).select();
%     pnl(r+1,t_ind).marginbottom = 16;
%     hold(iv_ax,'on');
%     hold(ramp_ax,'on');
%     if t_ind ==1
%         pnl(r+1,t_ind,1).ylabel('\DeltaI pA');
%         pnl(r+1,t_ind,1).xlabel('\DeltaV mV');
%         text(-60,100,'Steps','parent',iv_ax);
%         text(-60,100,'Ramps','parent',ramp_ax);
%     end
% 
%     pnl(r+2,t_ind).pack('v',{1/7 3/7 3/7});
%     chirp_ax = pnl(r+2,t_ind,1).select();
%     pnl(r+2,t_ind,1).marginbottom = 10;
%     pnl(r+2,t_ind,1).margintop = 16;
%     z_ax = pnl(r+2,t_ind,2).select();
%     pnl(r+2,t_ind,2).marginbottom = 4;
%     th_ax = pnl(r+2,t_ind,3).select();
%     pnl(r+2,t_ind,3).margintop = 4;
%     hold(chirp_ax,'on');
%     hold(z_ax,'on');
%     hold(th_ax,'on');
%     if t_ind ==1
%         pnl(r+2,t_ind,1).ylabel('\DeltaV mV');
%         pnl(r+2,t_ind,1).xlabel('s');
%         pnl(r+2,t_ind,2).ylabel('|Z| mV');
%         pnl(r+2,t_ind,3).ylabel('\Theta deg');
%         pnl(r+2,t_ind,3).xlabel('Hz');
%         text(100,2,'Current Chirp','parent',z_ax);
%     end
% 
%     %clrs = parula(length(analysis_cell)+1);
%     %clrs = clrs(1:end-1,:);
%     clrs = distinguishable_colors(length(analysis_cell),{'w','k',[1 1 0],[1 1 1]*.75});
% 
%     for c_ind = 1:length(analysis_cell)
%         disp(analysis_cell(c_ind).name)
%         if ~isempty(analysis_cell(c_ind).VoltageStepTrial)
%             trial = load(analysis_cell(c_ind).VoltageStepTrial);
%             h = getShowFuncInputsFromTrial(trial);
%             t = findLikeTrials('name',h.trial.name);
%             
%             x = makeInTime(h.trial.params);
%             xwin = x>.1-.01 & x<=.1+0.03;
%             
%             y = nan(length(t),sum(xwin));
%             for tr_ind = 1:length(t)
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,t(tr_ind))));
%                 y(tr_ind,:) = trial.current(xwin);
%             end
%             plot(step_ax_d,x(xwin),mean(y,1),...
%                 'displayname',[num2str(h.trial.params.step),' V' ],...
%                 'color',clrs(c_ind,:));
%             
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,t(1)+diff(t(1:2))-1)));
%             h = getShowFuncInputsFromTrial(trial);
%             t = findLikeTrials('name',h.trial.name);
%             xwin = x>-.01 & x<=0.03;
%             
%             y = nan(length(t),sum(xwin));
%             for tr_ind = 1:length(t)
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,t(tr_ind))));
%                 y(tr_ind,:) = trial.current(xwin);
%             end
%             plot(step_ax_u,x(xwin),mean(y,1),...
%                 'displayname',[num2str(h.trial.params.step),' V' ],...
%                 'color',clrs(c_ind,:));
%             
%             [V,I,Base] = PF_VoltageStepIVRelationship_NoPlot(h,'');
%             plot(iv_ax,V-Base,I,...
%                 'tag',analysis_cell(c_ind).name,...
%                 'displayname',[num2str(h.trial.params.step),' V' ],...
%                 'color',clrs(c_ind,:));
%         end
%         
%         if ~isempty(analysis_cell(c_ind).VoltageCommandTrial)
%             trial = load(analysis_cell(c_ind).VoltageCommandTrial);
%             h = getShowFuncInputsFromTrial(trial);
%             trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
% 
%             [stimvec,x] = VoltageCommandStim(trial.params);
%     
%             current = zeros(size(x));
%             voltage = zeros(size(x));
%             
%             for trial_ind = 1:length(trials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
%                 current = current+trial.current;
%                 voltage = voltage+trial.voltage;
%             end
%             current = current/length(trials);
%             d1 = getpref('FigureMaking','CurrentFilter');
%             if d1.SampleRate ~= trial.params.sampratein
%                 d1 = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',trial.params.sampratein);
%             end
%             current = filtfilt(d1,current);
% 
%             voltage_in = voltage/length(trials);
%             voltage_hold = mean(voltage_in(x>0-.05 &x<0));
%             voltage = stimvec; %+voltage_hold;
%             
%             plot(ramp_ax,voltage(x>=0.5&x<1),current(x>=0.5&x<1),...
%                 'tag',analysis_cell(c_ind).name,...
%                 'displayname',analysis_cell(c_ind).name,...
%                 'color',clrs(c_ind,:));
% 
%         end
% 
%         if ~isempty(analysis_cell(c_ind).CurrentChirpTrial)
%             trial = load(analysis_cell(c_ind).CurrentChirpTrial);
%             h = getShowFuncInputsFromTrial(trial);
%             
%             [Z,f,x,y,u,f_,Z_mag,Z_phase] = Script_CurrentChirpZAPFam(h);
%             
%             plot(chirp_ax,x(x>=0&x<10),y(x>=0&x<10),...            
%                 'tag',analysis_cell(c_ind).name,...
%                 'displayname',[num2str(h.trial.params.amp),' V' ],...
%                 'color',clrs(c_ind,:));
%             plot(z_ax,f_,Z_mag,...            
%                 'tag',analysis_cell(c_ind).name,...
%                 'displayname',[num2str(h.trial.params.amp),' V' ],...
%                 'color',clrs(c_ind,:));
%             plot(th_ax,f_,Z_phase,...            
%                 'tag',analysis_cell(c_ind).name,...
%                 'displayname',[num2str(h.trial.params.amp),' V' ],...
%                 'color',clrs(c_ind,:));
%         end
% 
%     end
%     set(step_ax_d,'ylim',getpref('FigureMaking','Figure5VStepYlims'))
%     set(step_ax_u,'ylim',getpref('FigureMaking','Figure5VStepYlims'))
%     
%     set(iv_ax,'ylim',getpref('FigureMaking','Figure5VStepYlims'))
%     set(iv_ax,'xlim',[-62 17])
%     set(ramp_ax,'ylim',getpref('FigureMaking','Figure5VStepYlims'))
%     set(ramp_ax,'xlim',[-62 17])
%     
%     set(chirp_ax,'ylim',getpref('FigureMaking','Figure5IChirpYlims'))
%     set(z_ax,'ylim',getpref('FigureMaking','Figure5IChirpZYlims'))
%     set(th_ax,'ylim',[-180 60])
%     figure(figure8)
%     drawnow
% end
% 
% savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
% savePDF(figure8,savedir,[],'Figure5_CsPara_IntrinsicProperties')
