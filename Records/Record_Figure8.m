%% Figure 8 intrinsic properties

% clear 
close all
figure8 = figure;

Record_VClampCurrentIsolation_Cells
figure8.Units = 'inches';
set(figure8,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneColumn'),10])
pnl = panel(figure8);

figurerows = [2 3 3 3];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);
pnl.margin = [16 16 4 4];

%% Plot VStep Fam for example cells
% pnl(1).pack('h',3) 
% pnl(1).margin = [4 4 4 4];
% 
% ylims = [Inf, -Inf];
% 
% geno_idx = [3 1 2];
% 
% d1 = getpref('FigureMaking','CurrentFilter');
% dT = [...
%     0.0004 0.0003
%     0.00035 0.00018
%     0.0003 0.00018];
% 
% for type_idx =  1:length(geno_idx)
%     pnl(1,type_idx).pack('v',{1/10 3/10 3/10 3/10});
%     stimax = pnl(1,type_idx,1).select();
%     
%     cnt = find(strcmp(analysis_cells,example_fig8.example_cells{type_idx}));
%     
%     for drug_idx = 1:length(analysis_cell(cnt).VSdrugs)
%         famax = pnl(1,type_idx,drug_idx+1).select();
% 
%         trial = load(analysis_cell(cnt).trials.VoltageStep_Drugs{drug_idx});
%         h = getShowFuncInputsFromTrial(trial);
%         t = findLikeTrials('name',h.trial.name);
%         blocktrials = findBlockTrials(h.trial,h.prtclData);
%         
%         x = makeInTime(h.trial.params);
%         x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
%         voltage = 0;
%         if drug_idx >1
%             current_0 = current;
%         end
%         current = zeros(length(x),length(blocktrials));
%         steps = blocktrials;
%         for bt_ind = 1:length(blocktrials);
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
%             
%             steps(bt_ind) = trial.params.step;
%             if drug_idx==1
%                 line(x,VoltageStepStim(trial.params),'parent',stimax,'color',[.8 .8 .8],'tag','VStep','userdata',steps(bt_ind));
%             end
%             
%             voltage_ = 0;
%             trials = findLikeTrials('name',trial.name,'datastruct',h.prtclData);
%             for t_ind = 1:length(trials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
%                 voltage_ = voltage_ + mean(trial.voltage(x>-trial.params.stimDurInSec+.062&x<0));
%                 current(:,bt_ind) = current(:,bt_ind)+trial.current;
%             end
%             voltage_ = voltage_/t_ind;
%             voltage = voltage+voltage_;
%             
%             current(:,bt_ind) = current(:,bt_ind)/length(trials);
%             current(x_transwin,bt_ind) = nan;
%             
%             if drug_idx==1
%                 line(x,current(:,bt_ind),'parent',famax,'color',0*[.8 .8 .8],'tag','I','userdata',steps(bt_ind));
%             else
%                 line(x,current_0(:,bt_ind)-current(:,bt_ind),'parent',famax,'color',0*[.8 .8 .8],'tag','I','userdata',steps(bt_ind));
%             end
%         end            
%         delete(findobj(stimax,'type','line','userdata',25))
%         delete(findobj(famax,'type','line','userdata',25))
%     
%         voltage = voltage/bt_ind;
%         set(findobj(stimax,'type','line','tag','VStep'),'userdata',voltage);
%         set([stimax,famax],'xlim',[-.03 trial.params.stimDurInSec+.03],...
%             'tickdir','out','xtick',[],'xcolor',[1 1 1],'ytick',[],'ycolor',[1 1 1]);
%         set(famax,'ylim',[-570 220])
%         drawnow
%     end
% end

%% Plot the IV curves for all the cells
% pnl(2).pack('h',3) 
% pnl(2).margin = [16 10 4 4];
% 
% 
% for type_idx =  1:length(geno_idx)
%   
%     ac = analysis_cell(genotype_idx==geno_idx(type_idx));
%     %clrs = distinguishable_colors(length(ac),{'w','k',[1 1 0],[1 1 1]*.75});
%     clrs = distinguishable_colors(length(ac(end).VSdrugs),{'w','k',[1 1 0],[1 1 1]*.75});
%     lightclrs = distinguishable_colors(length(ac(end).VSdrugs),{'w','k',[1 1 0],[1 1 1]*.75});
%     
%     iv_ax = pnl(2,type_idx).select(); hold(iv_ax,'on');
%     
%     for ac_idx = 1:length(ac)
%         for drug_idx = 1:length(ac(ac_idx).VSdrugs)
% 
%             disp(ac(ac_idx).name)
%             if isempty(ac(ac_idx).trials.VoltageStep_Drugs{drug_idx})
%                 continue
%             end
%             trial = load(ac(ac_idx).trials.VoltageStep_Drugs{drug_idx});
% 
%             h = getShowFuncInputsFromTrial(trial);
%             blocktrials = findBlockTrials(h.trial,h.prtclData);
%         
%             x = makeInTime(h.trial.params);
%             voltage = 0;
%             if drug_idx >1
%                 current_0 = current;
%             end
%             current = zeros(length(x),length(blocktrials));
%             steps = blocktrials;
%             for bt_ind = 1:length(blocktrials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,blocktrials(bt_ind))));
%             
%                 steps(bt_ind) = trial.params.step;            
%                 voltage_ = 0;
%                 trials = findLikeTrials('name',trial.name,'datastruct',h.prtclData);
% 
%                 for t_ind = 1:length(trials);
%                     trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
%                     voltage_ = voltage_ + mean(trial.voltage(x>-trial.params.stimDurInSec+.062&x<0));
%                     current(:,bt_ind) = current(:,bt_ind)+trial.current;
%                 end
%                 voltage_ = voltage_/t_ind;
%                 voltage = voltage+voltage_;
%             
%                 current(:,bt_ind) = current(:,bt_ind)/length(trials);
%             
%                 if drug_idx==1
%                     I_base(bt_ind) = nanmean(current(x<=0& x>-trial.params.stimDurInSec+.07,bt_ind));
%                     I_mean(bt_ind) = mean(current(x>trial.params.stimDurInSec/2 & x<trial.params.stimDurInSec,bt_ind));
%                 else
%                     current_ = current_0(:,bt_ind)-current(:,bt_ind);
%                     I_base(bt_ind) = nanmean(current_(x<=0& x>-trial.params.stimDurInSec+.07));
%                     I_mean(bt_ind) = mean(current_(x>trial.params.stimDurInSec/2 & x<trial.params.stimDurInSec));
%                 end
%                 if drug_idx==3
%                     I_mean_rem(bt_ind) = mean(current(x>trial.params.stimDurInSec/2 & x<trial.params.stimDurInSec,bt_ind));
%                 end
%             end
%             voltage = voltage/bt_ind;
%             plot(iv_ax,steps(steps<20),I_mean(steps<20),...
%                 'userdata',voltage,...
%                 'tag',[ac(ac_idx).name '_' regexprep(ac(ac_idx).VSdrugs{drug_idx},{'curare','MLA'},{'AchI','AchI'})],...
%                 'displayname',[num2str(h.trial.params.step),' V' ],...
%                 'color',lightclrs(drug_idx,:),'linestyle','none','marker','o','markeredgecolor',[.9 .9 .9]);
%             drawnow
%             if drug_idx==3
%                 plot(iv_ax,steps(steps<20),I_mean_rem(steps<20),...
%                     'userdata',voltage,...
%                     'tag',[ac(ac_idx).name '_rem'],...
%                     'displayname',[num2str(h.trial.params.step),' V' ],...
%                     'color',lightclrs(drug_idx,:),'linestyle','none','marker','o','markeredgecolor',[0.5 1 .5]);
%                 drawnow
%             end
% 
%         end
%         clear I_mean_rem
%     end
%     cond_ = {ac(ac_idx).VSdrugs{:},'rem'};
%     clrs = distinguishable_colors(length(cond_),{'w','k',[1 1 0],[1 1 1]*.75});
% 
%     for drug_idx = 1:length(cond_)
%         l = findobj(iv_ax,'type','line','-regexp','tag',regexprep(cond_{drug_idx},{'curare','MLA'},{'AchI','AchI'}));
%         v = [];
%         for i = 1:length(l)
%             v = union(v,get(l(i),'xdata'));
%         end
%         y = nan(length(l),length(v));
%         for i = 1:length(l)
%             v_ = get(l(i),'xdata');
%             y_ = get(l(i),'ydata');
%             [~,iv,iv_] = intersect(v,v_);
%             y(i,iv) = y_(iv_);
%         end  
%         delete(l);
%         
%         plot(v,nanmean(y,1),'parent',iv_ax,...
%             'color',clrs(drug_idx,:),'tag',regexprep(cond_{drug_idx},{'curare','MLA'},{'AchI','AchI'}));
%         e = nanstd(y)/sqrt(length(l));
%         errorbar(v,nanmean(y,1),e,'parent',iv_ax,...
%             'color',clrs(drug_idx,:),'tag',regexprep(cond_{drug_idx},{'curare','MLA'},{'AchI','AchI'}));
%     end
%     
%     set(iv_ax,'xlim',[-63 20],'ylim',[-200 250],'tickdir','out');
% end
% iv_ax = pnl(2,1).select(); 
% set(iv_ax,'ytickmode','auto','ycolor',[0 0 0]);

%% plot the on and off steps in drug conditions
% pnl(3).pack('h',2) 
% pnl(3).margin = [16 10 4 4];
% 
% geno_idx = [3 1 2];
% dT = [...
%     0.0004 0.0003
%     0.00035 0.00018
%     0.0003 0.00018];
% 
% on_ax = pnl(3,1).select(); hold(on_ax,'on');
% off_ax = pnl(3,2).select(); hold(off_ax,'on');
% 
% lght_clrs = [
%     .7 1 .7
%     .7 .7 1
%     1 .7 .7];
% clrs = [
%     0 .5 0
%     0 0 .7
%     .7 0 0];
% 
% for type_idx = 1:length(geno_idx)
%     ac = analysis_cell(genotype_idx==geno_idx(type_idx));
%     %clrs = distinguishable_colors(length(ac),{'w','k',[1 1 0],[1 1 1]*.75});
%     
%     for ac_idx = 1:length(ac)
%         
%         disp(ac(ac_idx).name)
%         TEA_idx = find(strcmp(ac(ac_idx).VSdrugs,'4APTEA'));
%         TTX_idx = find(strcmp(ac(ac_idx).VSdrugs,'TTX'));
%         
%         for idx = TEA_idx-1:TEA_idx
%             trial = load(ac(ac_idx).trials.VoltageStep_Drugs{idx});
%             h = getShowFuncInputsFromTrial(trial);
%             if ~sum(h.trial.params.steps == 10)
%                 continue
%             end
%             
%             for pd_ind = trial.params.trial:trial.params.trial+length(h.trial.params.steps)
%                 if h.prtclData(pd_ind).step == 10
%                     TEA_ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
%                     if isfield(TEA_ex,'excluded') && TEA_ex.excluded
%                         continue
%                     else
%                         break
%                     end
%                 end
%             end
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
%             h = getShowFuncInputsFromTrial(trial);
%             trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
%             
%             if idx == TEA_idx-1
%             x = makeInTime(trial.params);
%             x_win = x>=-.015 & x<+.03;
%             x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
%             end
%             
%             current = zeros(size(x));
%             for trial_ind = 1:length(trials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
%                 current = current+trial.current;
%             end
%             current = current/length(trials);
%             current(x_transwin) = nan;
% 
%             if idx == TEA_idx-1
%                 current_ = current;
%             elseif idx == TEA_idx
%                 plot(on_ax,x(x_win),current_(x_win)-current(x_win),...
%                     'tag',['geno_' num2str(type_idx)],...
%                     'displayname',ac(ac_idx).name,...
%                     'color',lght_clrs(type_idx,:));
%                 drawnow
%             end
%         end
%         
%         for idx = TTX_idx-1:TTX_idx
%             trial = load(ac(ac_idx).trials.VoltageStep_Drugs{idx});
%             h = getShowFuncInputsFromTrial(trial);
%             if ~sum(h.trial.params.steps == -60)
%                 continue
%             end
%             
%             for pd_ind = trial.params.trial:trial.params.trial+length(h.trial.params.steps)
%                 if h.prtclData(pd_ind).step == -60
%                     TEA_ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
%                     if isfield(ex,'excluded') && ex.excluded
%                         continue
%                     else
%                         break
%                     end
%                 end
%             end
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
%             h = getShowFuncInputsFromTrial(trial);
%             trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
%             
%             if idx == TTX_idx-1
%                 x = makeInTime(trial.params);
%                 x_win = x>=trial.params.stimDurInSec-.004 & x<trial.params.stimDurInSec+.008;
%                 x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
%             end
%             
%             current = zeros(size(x));
%             for trial_ind = 1:length(trials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
%                 current = current+trial.current;
%             end
%             current = current/length(trials);
%             current(x_transwin) = nan;
%             
%             if idx == TTX_idx-1
%                 current_ = current;
%             elseif idx == TTX_idx
%                 plot(off_ax,x(x_win),current_(x_win)-current(x_win),...
%                     'tag',['geno_' num2str(type_idx)],...
%                     'displayname',ac(ac_idx).name,...
%                     'color',lght_clrs(type_idx,:));
%                 drawnow
%             end
%         end
%         
%     end
%     set(off_ax,'ylim',[-800 100],...
%         'tickdir','out');
%     
%     l = findobj(off_ax,'type','line','tag',['geno_' num2str(type_idx)]);
%     set(l,'color',lght_clrs(type_idx,:));
%     y = cell2mat(get(l,'ydata'));
%     line(get(l(1),'xdata'),mean(y,1),'parent',off_ax,...
%         'color',clrs(type_idx,:),'linestyle','-',...
%         'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);
% 
%     set(on_ax,'ylim',[-50 250],...
%         'tickdir','out');
%     
%     l = findobj(on_ax,'type','line','tag',['geno_' num2str(type_idx)]);
%     set(l,'color',lght_clrs(type_idx,:));
%     y = cell2mat(get(l,'ydata'));
%     line(get(l(1),'xdata'),mean(y,1),'parent',on_ax,...
%         'color',clrs(type_idx,:),'linestyle','-',...
%         'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);
% 
% end

% savePDFandFIG(figure8,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8',[],'Figure8');

%% plot the on and off steps in drug conditions
pnl(3).margin = [16 10 4 4];

geno_idx = [3 1 2];
dT = [...
    0.0004 0.0003
    0.00035 0.00018
    0.0003 0.00018];

on_ax = pnl(3).select(); hold(on_ax,'on');
gap = .01;

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
        TEA_idx = find(strcmp(ac(ac_idx).VSdrugs,'4APTEA'));
        TTX_idx = find(strcmp(ac(ac_idx).VSdrugs,'TTX'));
        
        for idx = TEA_idx-1:TEA_idx
            trial = load(ac(ac_idx).trials.VoltageStep_Drugs{idx});
            h = getShowFuncInputsFromTrial(trial);
            if ~sum(h.trial.params.steps == 10)
                continue
            end
            
            for pd_ind = trial.params.trial:trial.params.trial+length(h.trial.params.steps)
                if h.prtclData(pd_ind).step == 10
                    TEA_ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
                    if isfield(TEA_ex,'excluded') && TEA_ex.excluded
                        continue
                    else
                        break
                    end
                end
            end
            trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
            h = getShowFuncInputsFromTrial(trial);
            trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
            
            if idx == TEA_idx-1
            x = makeInTime(trial.params);
            x_win_on = x>-.01 & x<0.06;
            x_win_off = x>=trial.params.stimDurInSec-.005 & x<trial.params.stimDurInSec+.01;
            x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
            end
            
            current = zeros(size(x));
            for trial_ind = 1:length(trials);
                trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
                current = current+trial.current;
            end
            current = current/length(trials);
            current(x_transwin) = nan;

            if idx == TEA_idx-1
                current_ = current;
            elseif idx == TEA_idx
                gap_ = 0.03+gap;
                plot(on_ax,x(x_win_on),current_(x_win_on)-current(x_win_on),...
                    'tag',['on_TEA_geno_' num2str(type_idx)],...
                    'displayname',ac(ac_idx).name,...
                    'color',lght_clrs(type_idx,:));
%                 plot(on_ax,x(x_win_off)-trial.params.stimDurInSec+gap_,current_(x_win_off)-current(x_win_off),...
%                     'tag',['off_TEA_geno_' num2str(type_idx)],...
%                     'displayname',ac(ac_idx).name,...
%                     'color',lght_clrs(type_idx,:));
                drawnow
            end
        end
                
        for idx = TTX_idx-1:TTX_idx
            trial = load(ac(ac_idx).trials.VoltageStep_Drugs{idx});
            h = getShowFuncInputsFromTrial(trial);
            if ~sum(h.trial.params.steps == -60)
                continue
            end
            
            for pd_ind = trial.params.trial:trial.params.trial+length(h.trial.params.steps)
                if h.prtclData(pd_ind).step == -60
                    TTX_ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
                    if isfield(TTX_ex,'excluded') && TTX_ex.excluded
                        continue
                    else
                        break
                    end
                end
            end
            trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
            h = getShowFuncInputsFromTrial(trial);
            trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
            
            if idx == TTX_idx-1
                x = makeInTime(trial.params);
                x_win_on = x>-.01 & x<0.03;
                x_win_off = x>=trial.params.stimDurInSec-.005 & x<trial.params.stimDurInSec+.01;
                x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
            end
            
            current = zeros(size(x));
            for trial_ind = 1:length(trials);
                trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
                current = current+trial.current;
            end
            current = current/length(trials);
            current(x_transwin) = nan;
            
            if idx == TTX_idx-1
                current_ = current;
            elseif idx == TTX_idx
                gap_ = 0.03+gap;
%                 plot(on_ax,x(x_win_on),current_(x_win_on)-current(x_win_on),...
%                     'tag',['on_TTX_geno_' num2str(type_idx)],...
%                     'displayname',ac(ac_idx).name,...
%                     'color',lght_clrs(type_idx,:));
                plot(on_ax,x(x_win_off)-trial.params.stimDurInSec+gap_,current_(x_win_off)-current(x_win_off),...
                    'tag',['off_TTX_geno_' num2str(type_idx)],...
                    'displayname',ac(ac_idx).name,...
                    'color',lght_clrs(type_idx,:));
                drawnow
            end
        end
        
    end
    set(on_ax,'ylim',[-20 130],'xlim',[-.005 gap_+0.01],...
        'tickdir','out');
    
    l = findobj(on_ax,'type','line','tag',['off_TTX_geno_' num2str(type_idx)]);
    set(l,'color',lght_clrs(type_idx,:));
    x = l(1).XData;
    y = cell2mat(get(l,'ydata'));
    y_ = nanmean(y,1);
    line(x,y_,'parent',on_ax,...
        'color',clrs(type_idx,:),'linestyle','-',...
        'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);
    
    sem_up = nanstd(y,[],1)/sqrt(size(y,1));
    sem_down = y_-sem_up;
    sem_up = y_+sem_up;
    
    line(x,sem_down,'parent',on_ax,'color',[.8 1 1]*(10 - (type_idx-1))/10,'tag',['off_TTX_geno_sem_' num2str(type_idx)]);
    line(x,sem_up,'parent',on_ax,'color',[.8 1 1]*(10 - (type_idx-1))/10,'tag',['off_TTX_geno_sem_' num2str(type_idx)]);
    delete(l);
    
    l = findobj(on_ax,'type','line','tag',['on_TEA_geno_' num2str(type_idx)]);
    set(l,'color',lght_clrs(type_idx,:));
    x = l(1).XData;
    y = cell2mat(get(l,'ydata'));
    y_ = mean(y,1);
    line(x,y_,'parent',on_ax,...
        'color',clrs(type_idx,:),'linestyle','-',...
        'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);

    sem_up = std(y,[],1)/sqrt(size(y,1));
    sem_down = y_-sem_up;
    sem_up = y_+sem_up;
    
    line(x,sem_down,'parent',on_ax,'color',[1 .8 1]*(10 - (type_idx-1))/10,'tag',['on_TEA_geno__sem_' num2str(type_idx)]);
    line(x,sem_up,'parent',on_ax,'color',[1 .8 1]*(10 - (type_idx-1))/10,'tag',['on_TEA_geno__sem_' num2str(type_idx)]);

    x = get(l(1),'xdata');
    ftemp = figure;
    ax = subplot(1,1,1);
    for j = 1:size(y,1)
        
        y_ = y(j,:);
        y_ = y_(x>0);
        x_ = x(x>0);
        x_ = x_(~isnan(y_));
        y_ = y_(~isnan(y_));
        
        kon = nlinfit(x_-x_(1),y_,@exponential,[100,-100,.001]);
        kon_vec(j) = kon(3)*1000;
        plot(ax,x_,y_), hold on;
        plot(x_,exponential(kon,x_-x_(1)),'k');
        text(0.03,kon(1),sprintf('k_a = %.2f ms',kon(3)*1000),'verticalalignment','bottom','horizontalalignment','right','parent',ax);
        pause
        cla(ax);
    end
    close(ftemp);
    
    x_ = get(l(1),'xdata');
    y_ = mean(y,1);
    y_ = y_(x_>0);
    x_ = x_(x_>0);
    x_ = x_(~isnan(y_));
    y_ = y_(~isnan(y_));
    
    kon = nlinfit(x_-x_(1),y_,@exponential,[100,-100,.001]);
%     line(x,exponential(kon,x-x(1)),'color',get(ls(l),'color')+[0 .7 0],'parent',VstepTTX_pnl_hs(1,2));
%     line(x_,exponential(kon,x_-x_(1)),'color',[0 0 0],'parent',on_ax,'linewidth',2);
    text(0.03,kon(1),sprintf('k_a = %.2f ms',kon(3)*1000),'verticalalignment','bottom','horizontalalignment','right','parent',on_ax);
    %delete(l);
    
    disp(type_idx)
    disp(kon);
    kon_cell{type_idx} = kon_vec;
end

% savePDFandFIG(figure8,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8',[],'Figure8_sem_on');
% 
% figure8_off_ax = figure;
% 
% Record_VClampCurrentIsolation_Cells
% figure8_off_ax.Units = 'inches';
% set(figure8_off_ax,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneColumn'),10])
% pnl_2 = panel(figure8_off_ax);
% 
% figurerows = [8 4 4];
% figurerows = num2cell(figurerows/sum(figurerows));
% pnl_2.pack('v',figurerows);
% pnl_2.margin = [16 16 4 4];
% 
% pnl_2(3).margin = [16 10 4 4];
% 
% off_ax = pnl_2(3).select(); hold(off_ax,'on');
% tmp = copyobj(get(on_ax,'children'),off_ax);
% 
% set(off_ax,'ylim',[-800 60],'xlim',[-.005 gap_+0.01],...
%     'tickdir','out');
% 
% savePDFandFIG(figure8_off_ax,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8',[],'Figure8_sem_off');
% 

%% Stats on kon
%[H,P,CI] = ttest(kon_cell{2},kon_cell{3})
[P,H,CI] = ranksum(kon_cell{2},kon_cell{3})
[P,ANOVATAB,STATS] = kruskalwallis([kon_cell{2}',kon_cell{3}'],{'hi','lowmid'},'on')

%% plot the on and off steps in normal conditions
% pnl(3).pack('h',2) 
% pnl(3).margin = [16 10 4 4];
% 
% geno_idx = [3 1 2];
% dT = [...
%     0.0004 0.0003
%     0.00035 0.00018
%     0.0003 0.00018];
% 
% on_ax = pnl(3,2).select(); hold(on_ax,'on');
% off_ax = pnl(3,1).select(); hold(off_ax,'on');
% 
% lght_clrs = [
%     .7 1 .7
%     .7 .7 1
%     1 .7 .7];
% clrs = [
%     0 .5 0
%     0 0 .7
%     .7 0 0];
% 
% for type_idx = 1:length(geno_idx)
%     ac = analysis_cell(genotype_idx==geno_idx(type_idx));
%     %clrs = distinguishable_colors(length(ac),{'w','k',[1 1 0],[1 1 1]*.75});
%     
%     for ac_idx = 1:length(ac)
%         
%         disp(ac(ac_idx).name)
%         trial = load(ac(ac_idx).trials.VoltageStep);
%         h = getShowFuncInputsFromTrial(trial);
%         if ~sum(h.trial.params.steps == -60)
%             continue
%         end
%         for pd_ind = 1:length(h.prtclData);
%             
%             if h.prtclData(pd_ind).step == -60 && isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'TTX')) 
% %                     (~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'curare')) || ~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'MLA'))) && ...
%                     
%                 ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
%                 if isfield(ex,'excluded') && ex.excluded
%                     continue
%                 else
%                     break
%                 end
%             end
%         end
%         trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
%         h = getShowFuncInputsFromTrial(trial);
%         trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
%         
%         x = makeInTime(trial.params);        
%         x_win = x>=trial.params.stimDurInSec-.004 & x<trial.params.stimDurInSec+.008;
%         x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
% 
%         current = zeros(size(x));        
%         for trial_ind = 1:length(trials);
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
%             current = current+trial.current;
%         end
%         current = current/length(trials);
%         current(x_transwin) = nan;
%         
%         plot(off_ax,x(x_win),current(x_win),...
%             'tag',['geno_' num2str(type_idx)],...
%             'displayname',ac(ac_idx).name,...
%             'color',lght_clrs(type_idx,:));
%         drawnow
%  
%         % step up
%         trial = load(ac(ac_idx).trials.VoltageStep);
%         h = getShowFuncInputsFromTrial(trial);
%         if ~sum(h.trial.params.steps == 10)
%             continue
%         end
%         for pd_ind = 1:length(h.prtclData);
%             
%             if h.prtclData(pd_ind).step == 10 && isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'TTX'))
% %                     (~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'curare')) || ~isempty(strfind(sprintf('%s',h.prtclData(pd_ind).tags{:}),'MLA'))) && ...
% 
%                 ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
%                 if isfield(ex,'excluded') && ex.excluded
%                     continue
%                 else
%                     break
%                 end
%             end
%         end
%         trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
%         h = getShowFuncInputsFromTrial(trial);
%         trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
%         
%         x = makeInTime(trial.params);        
%         x_win = x>=-.015 & x<+.03;
%         x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
% 
%         current = zeros(size(x));        
%         for trial_ind = 1:length(trials);
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
%             current = current+trial.current;
%         end
%         current = current/length(trials);
%         current(x_transwin) = nan;
%         
%         plot(on_ax,x(x_win),current(x_win),...
%             'tag',['geno_' num2str(type_idx)],...
%             'displayname',ac(ac_idx).name,...
%             'color',lght_clrs(type_idx,:));
%         drawnow
% 
%         
%     end
%     set(off_ax,'ylim',[-800 100],...
%         'tickdir','out');
%     
%     l = findobj(off_ax,'type','line','tag',['geno_' num2str(type_idx)]);
%     set(l,'color',lght_clrs(type_idx,:));
%     y = cell2mat(get(l,'ydata'));
%     line(get(l(1),'xdata'),mean(y,1),'parent',off_ax,...
%         'color',clrs(type_idx,:),'linestyle','-',...
%         'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);
% 
%     set(on_ax,'ylim',[-50 250],...
%         'tickdir','out');
%     
%     l = findobj(on_ax,'type','line','tag',['geno_' num2str(type_idx)]);
%     set(l,'color',lght_clrs(type_idx,:));
%     y = cell2mat(get(l,'ydata'));
%     line(get(l(1),'xdata'),mean(y,1),'parent',on_ax,...
%         'color',clrs(type_idx,:),'linestyle','-',...
%         'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);
% 
% end
% iv_ax = pnl(2,1).select(); 
% set(iv_ax,'ytickmode','auto','ycolor',[0 0 0]);
% 
% savePDFandFIG(figure8,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8',[],'Figure8');

%% plot the on and off steps in para conditions
% pnl(3).margin = [16 10 4 4];
% 
% geno_idx = [3 1 2];
% dT = [...
%     0.0004 0.0003
%     0.00035 0.00018
%     0.0003 0.00018];
% 
% on_ax = pnl(3).select(); hold(on_ax,'on');
% gap = .01;
% 
% lght_clrs = [
%     .7 1 .7
%     .7 .7 1
%     1 .7 .7];
% clrs = [
%     0 .5 0
%     0 0 .7
%     .7 0 0];
% 
% types = {
%     'a2_cell'
%     'fru_cell'
%     'vt_cell'
%     };
% Record_VoltageClampInputCurrents
% 
% for type_idx = 1:length(types)
%     clear transfer freqs dsplcmnts f
%     disp(types{type_idx})
%     eval(['analysis_cell = ' types{type_idx} ';']);
%     eval(['analysis_cells = ' types{type_idx} 's;']);
% 
%     ac = analysis_cell;
%     %clrs = distinguishable_colors(length(ac),{'w','k',[1 1 0],[1 1 1]*.75});
%     
%     for ac_idx = 1:length(ac)
%         
%         disp(ac(ac_idx).name)
%         TEA_idx = find(strcmp(ac(ac_idx).VSdrugs,'4APTEA'));
%         TTX_idx = find(strcmp(ac(ac_idx).VSdrugs,'TTX'));
%         
%         for idx = TEA_idx-1:TEA_idx
%             trial = load(ac(ac_idx).trials.VoltageStep_Drugs{idx});
%             h = getShowFuncInputsFromTrial(trial);
%             if ~sum(h.trial.params.steps == 10)
%                 continue
%             end
%             
%             for pd_ind = trial.params.trial:trial.params.trial+length(h.trial.params.steps)
%                 if h.prtclData(pd_ind).step == 10
%                     TEA_ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
%                     if isfield(TEA_ex,'excluded') && TEA_ex.excluded
%                         continue
%                     else
%                         break
%                     end
%                 end
%             end
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
%             h = getShowFuncInputsFromTrial(trial);
%             trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
%             
%             if idx == TEA_idx-1
%                 x = makeInTime(trial.params);
%                 x_win_on = x>-.01 & x<0.03;
%                 x_win_off = x>=trial.params.stimDurInSec-.005 & x<trial.params.stimDurInSec+.01;
%                 x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
%             end
%             
%             current = zeros(size(x));
%             for trial_ind = 1:length(trials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
%                 current = current+trial.current;
%             end
%             current = current/length(trials);
%             current(x_transwin) = nan;
% 
%             if idx == TEA_idx-1
%                 current_ = current;
%             elseif idx == TEA_idx
%                 gap_ = 0.03+gap;
%                 plot(on_ax,x(x_win_on),current_(x_win_on)-current(x_win_on),...
%                     'tag',['on_TEA_geno_' num2str(type_idx)],...
%                     'displayname',ac(ac_idx).name,...
%                     'color',lght_clrs(type_idx,:));
% %                 plot(on_ax,x(x_win_off)-trial.params.stimDurInSec+gap_,current_(x_win_off)-current(x_win_off),...
% %                     'tag',['off_TEA_geno_' num2str(type_idx)],...
% %                     'displayname',ac(ac_idx).name,...
% %                     'color',lght_clrs(type_idx,:));
%                 drawnow
%             end
%         end
%                 
%         for idx = TTX_idx-1:TTX_idx
%             trial = load(ac(ac_idx).trials.VoltageStep_Drugs{idx});
%             h = getShowFuncInputsFromTrial(trial);
%             if ~sum(h.trial.params.steps == -60)
%                 continue
%             end
%             
%             for pd_ind = trial.params.trial:trial.params.trial+length(h.trial.params.steps)
%                 if h.prtclData(pd_ind).step == -60
%                     TTX_ex = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)),'excluded');
%                     if isfield(TTX_ex,'excluded') && TTX_ex.excluded
%                         continue
%                     else
%                         break
%                     end
%                 end
%             end
%             trial = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(pd_ind).trial)));
%             h = getShowFuncInputsFromTrial(trial);
%             trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
%             
%             if idx == TTX_idx-1
%                 x = makeInTime(trial.params);
%                 x_win_on = x>-.01 & x<0.03;
%                 x_win_off = x>=trial.params.stimDurInSec-.005 & x<trial.params.stimDurInSec+.01;
%                 x_transwin = (x>0&x<dT(type_idx,1))|(x>trial.params.stimDurInSec&x<trial.params.stimDurInSec+dT(type_idx,2));
%             end
%             
%             current = zeros(size(x));
%             for trial_ind = 1:length(trials);
%                 trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
%                 current = current+trial.current;
%             end
%             current = current/length(trials);
%             current(x_transwin) = nan;
%             
%             if idx == TTX_idx-1
%                 current_ = current;
%             elseif idx == TTX_idx
%                 gap_ = 0.03+gap;
% %                 plot(on_ax,x(x_win_on),current_(x_win_on)-current(x_win_on),...
% %                     'tag',['on_TTX_geno_' num2str(type_idx)],...
% %                     'displayname',ac(ac_idx).name,...
% %                     'color',lght_clrs(type_idx,:));
%                 plot(on_ax,x(x_win_off)-trial.params.stimDurInSec+gap_,current_(x_win_off)-current(x_win_off),...
%                     'tag',['off_TTX_geno_' num2str(type_idx)],...
%                     'displayname',ac(ac_idx).name,...
%                     'color',lght_clrs(type_idx,:));
%                 drawnow
%             end
%         end
%         
%     end
%     set(on_ax,'ylim',[-20 130],'xlim',[-.005 gap_+0.01],...
%         'tickdir','out');
%     
%     l = findobj(on_ax,'type','line','tag',['off_TTX_geno_' num2str(type_idx)]);
%     set(l,'color',lght_clrs(type_idx,:));
%     x = l(1).XData;
%     y = cell2mat(get(l,'ydata'));
%     y_ = nanmean(y,1);
%     line(x,y_,'parent',on_ax,...
%         'color',clrs(type_idx,:),'linestyle','-',...
%         'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);
%     
%     sem_up = nanstd(y,[],1)/sqrt(size(y,1));
%     sem_down = y_-sem_up;
%     sem_up = y_+sem_up;
%     
%     line(x,sem_down,'parent',on_ax,'color',[.8 1 1]*(10 - (type_idx-1))/10,'tag',['off_TTX_geno_sem_' num2str(type_idx)]);
%     line(x,sem_up,'parent',on_ax,'color',[.8 1 1]*(10 - (type_idx-1))/10,'tag',['off_TTX_geno_sem_' num2str(type_idx)]);
%     delete(l);
%     
%     l = findobj(on_ax,'type','line','tag',['on_TEA_geno_' num2str(type_idx)]);
%     set(l,'color',lght_clrs(type_idx,:));
%     x = l(1).XData;
%     y = cell2mat(get(l,'ydata'));
%     y_ = mean(y,1);
%     line(x,y_,'parent',on_ax,...
%         'color',clrs(type_idx,:),'linestyle','-',...
%         'tag',['ave_geno_' num2str(type_idx)],'DisplayName',[ac(1).genotype]);
% 
%     sem_up = std(y,[],1)/sqrt(size(y,1));
%     sem_down = y_-sem_up;
%     sem_up = y_+sem_up;
%     
%     line(x,sem_down,'parent',on_ax,'color',[1 .8 1]*(10 - (type_idx-1))/10,'tag',['on_TEA_geno__sem_' num2str(type_idx)]);
%     line(x,sem_up,'parent',on_ax,'color',[1 .8 1]*(10 - (type_idx-1))/10,'tag',['on_TEA_geno__sem_' num2str(type_idx)]);
% 
%     x_ = get(l(1),'xdata');
%     y_ = mean(y,1);
%     y_ = y_(x_>0);
%     x_ = x_(x_>0);
%     x_ = x_(~isnan(y_));
%     y_ = y_(~isnan(y_));
%     
%     kon = nlinfit(x_-x_(1),y_,@exponential,[100,-100,.001]);
% %     line(x,exponential(kon,x-x(1)),'color',get(ls(l),'color')+[0 .7 0],'parent',VstepTTX_pnl_hs(1,2));
% %     line(x_,exponential(kon,x_-x_(1)),'color',[0 0 0],'parent',on_ax,'linewidth',2);
%     text(0.03,kon(1),sprintf('k_a = %.2f ms',kon(3)*1000),'verticalalignment','bottom','horizontalalignment','right','parent',on_ax);
%     delete(l);
%     
%     disp(type_idx)
%     disp(kon);
% end
% 
% savePDFandFIG(figure8,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8',[],'Figure8_para_sem_on');
% 
% figure8_off_ax = figure;
% 
% Record_VClampCurrentIsolation_Cells
% figure8_off_ax.Units = 'inches';
% set(figure8_off_ax,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneColumn'),10])
% pnl_2 = panel(figure8_off_ax);
% 
% figurerows = [8 4 4];
% figurerows = num2cell(figurerows/sum(figurerows));
% pnl_2.pack('v',figurerows);
% pnl_2.margin = [16 16 4 4];
% 
% pnl_2(3).margin = [16 10 4 4];
% 
% off_ax = pnl_2(3).select(); hold(off_ax,'on');
% tmp = copyobj(get(on_ax,'children'),off_ax);
% 
% set(off_ax,'ylim',[-800 60],'xlim',[-.005 gap_+0.01],...
%     'tickdir','out');
% 
% savePDFandFIG(figure8_off_ax,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8',[],'Figure8_para_sem_off');

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
