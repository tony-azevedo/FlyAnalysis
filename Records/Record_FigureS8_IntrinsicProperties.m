%% Record of Effects of drugs on chirps and sweep power
close all

Record_VClampCurrentIsolation_Cells

savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation';

figure7 = figure;
figure7.Units = 'inches';
set(figure7,'color',[1 1 1],'position',[1 .2 getpref('FigureSizes','NeuronTwoColumn'), .9*getpref('FigureSizes','NeuronOneAndHalfColumn')])

pnl = panel(figure7);
pnl.margin = [20 4 4 4];

% example chirps, in drugs (FruGal4),   example chirps, in drugs (VT27938)
% ZAPs in drugs FruGal4,                ZAPs in drugs VT27938
% Sweeps in drugs FruGal4,              Sweeps in drugs FruGal4
% Power in drugs FruGal4,               Power in drugs VT27938

% figurerows = [3 8 6];
% figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('h',2);
pnl(1).pack('v',5)
pnl(1,1).pack('h',3)
pnl(1,2).pack('h',3)
pnl(1,3).pack('h',3)
pnl(1,4).pack('h',3)
pnl(1,5).pack('h',3)

pnl(2).pack('v',5)
pnl(2,1).pack('h',3)
pnl(2,2).pack('h',3)
pnl(2,3).pack('h',3)
pnl(2,4).pack('h',3)
pnl(2,5).pack('h',3)

% lilgap = .004;
geno_idx = [1 2];

figure7stats = figure;
figure7stats.Units = 'inches';
set(figure7stats,'color',[1 1 1],'position',[1 .2 getpref('FigureSizes','NeuronOneColumn'),getpref('FigureSizes','NeuronOneColumn')])

st_pnl = panel(figure7stats);
st_pnl.margin = [20 16 4 4];
st_pnl.pack(2,2);
st_pnl(2,1).pack('v',2);

%% Chirps stuff
DRUGS = {'AchI','TTX','4AP_TEA'};

for type_idx = 1:length(geno_idx)    
    g_idx = find(genotype_idx==geno_idx(type_idx));

    clrs = distinguishable_colors(length(g_idx),{'w','k',[1 1 0],[1 1 1]*.8});
    %clrs(:) = .8;
    max_Z_ctrl = nan(length(g_idx),1);
    max_Z_drugs = nan(length(g_idx),1);
    for ac_idx = 1:length(g_idx)
        
        DRUGS = {'AchI','TTX','4AP_TEA'};
        clear tag_collections_ tag_collections_VS
        
        ac = analysis_cell(g_idx(ac_idx));
        trial = load(ac.trials.CurrentChirp);
        h = getShowFuncInputsFromTrial(trial);
        
        % Find trials for a drug condition

        tag_collections_VS = {};
        for pd_ind = 1:length(h.prtclData);
            %fprintf('\n%d - ', h.prtclData(pd_ind).trial);fprintf('%s;',h.prtclData(pd_ind).tags{:})
            tg_collection_str = sprintf('%s; ',h.prtclData(pd_ind).tags{:});
            if ~ismember(tg_collection_str,tag_collections_VS);
                tag_collections_VS{end+1} = tg_collection_str;
                %fprintf(1,'%s\n',tg_collection_str);
            end
        end

        concstrprfunc = @(c)regexprep(c,{'50uM','50 uM','5mM','10 mM','10mM','1uM','0mM','1 uM','\s'},{'','','','','','','','','_'});
        for tc_ind = 1:length(tag_collections_VS)
            tag_collections_{tc_ind} = concstrprfunc(tag_collections_VS{tc_ind});
            tag_collections_{tc_ind} = concstrprfunc(tag_collections_VS{tc_ind});
        end

        strprfunc = @(c)regexprep(c,{';','\s','_+','_$','\.'},{'','_','_','','_'});
        for tc_ind = 1:length(tag_collections_)
            tag_collections_{tc_ind} = strprfunc(tag_collections_{tc_ind});
            tag_collections_{tc_ind} = strprfunc(tag_collections_{tc_ind});
        end
        
        trial_seeds = nan(1,length(tag_collections_VS));
        
        warning('off','MATLAB:load:variableNotFound');
        for pd_ind = 1:length(h.prtclData);
            a_ind = find(max(trial.params.amps)== h.prtclData(pd_ind).amp);
            t_ind = find(strcmp(tag_collections_VS,sprintf('%s; ',h.prtclData(pd_ind).tags{:})));
            if isnan(trial_seeds(t_ind)) && max(trial.params.amps)== h.prtclData(pd_ind).amp
                trial_seeds(t_ind) = h.prtclData(pd_ind).trial;
                ex = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(t_ind))),'excluded');
                if isfield(ex,'excluded') && ex.excluded
                    trial_seeds(t_ind) = nan;
                end
            end
        end
        warning('on','MATLAB:load:variableNotFound');
                
        AchI_drug = '';
        for str = {'curare','MLA'};
            if ~isempty(strfind(tag_collections_{end},str));
                AchI_drug = str;
            end
        end
        
        DRUGS(strcmp(DRUGS,'AchI')) = AchI_drug;
        
        tag_idx = nan(size(DRUGS));
        for drg_idx = 1:length(DRUGS)
            for tg_idx = 1:length(tag_collections_VS);
                if length(tag_collections_{tg_idx}) >= length(DRUGS{drg_idx}) && ...
                        strcmp(tag_collections_{tg_idx}(end-length(DRUGS{drg_idx})+1:end),DRUGS{drg_idx})
                    tag_idx(drg_idx) = tg_idx;
                end
            end
        end
        
        [tag_idx,o] = sort(tag_idx);
        drugs = DRUGS(o);
%         drugs = DRUGS;
        drugs = drugs(~isnan(tag_idx));
        tag_idx = tag_idx(~isnan(tag_idx));
        trial_seeds_ = trial_seeds(tag_idx);
        fprintf('%s\n',ac.name)
        disp(tag_collections_')
        try
            fprintf('%d - %s\n%d - %s\n%d - %s\n',tag_idx(1),drugs{1},tag_idx(2),drugs{2},tag_idx(3),drugs{3});
        catch
            beep
            fprintf('%d - %s\n%d - %s\n%d - %s\n',tag_idx(1),drugs{1},tag_idx(2),drugs{2});
        end
        
        % average the currents across trials
        x = makeInTime(trial.params);
        xwin = x>=-trial.params.preDurInSec+.1 & x<=trial.params.stimDurInSec+trial.params.postDurInSec-.1;
%         xwin_Z = x>=trial.params.ramptime*1.5 & x<=trial.params.stimDurInSec-trial.params.ramptime*1.5;
        
        for c = 1:size(trial_seeds_,2)
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds_(c))));
            h = getShowFuncInputsFromTrial(trial);

            [Z,f,x,y,u,f_,Z_mag,Z_phase] = Script_CurrentChirpZAPFam(h);
            if c==1
                f_win = f_>=3;
                [~, max_Z_ctrl(ac_idx)] = max(Z_mag(f_win));
                f_win = f_(f_win);
                max_Z_ctrl(ac_idx) = f_win(max_Z_ctrl(ac_idx));
            end
            if c==size(trial_seeds_,2)
                f_win = f_>=3;
                [~, max_Z_drugs(ac_idx)] = max(Z_mag(f_win));
                f_win = f_(f_win);
                max_Z_drugs(ac_idx) = f_win(max_Z_drugs(ac_idx));
            end
            
            if strcmp(ac.name,'151022_F2_C1')||strcmp(ac.name,'151210_F3_C1')
                chirp_ax = pnl(type_idx,1,c).select(); hold(chirp_ax,'on');
                plot(chirp_ax,x(x>=0&x<10),y(x>=0&x<10),...
                    'displayname',ac.name,...
                    'displayname',[num2str(h.trial.params.amp),' V' ],...
                    'color',clrs(ac_idx,:));
                if type_idx==1
                    set(chirp_ax,'ylim',[-6 6])
                else
                    set(chirp_ax,'ylim',[-10 10])
                end
            end
            z_ax = pnl(type_idx,2,c).select(); hold(z_ax,'on');
            th_ax = pnl(type_idx,3,c).select(); hold(th_ax,'on');

            plot(z_ax,f_,Z_mag,...
                'displayname',ac.name,...
                'tag',drugs{c},...
                'color',clrs(ac_idx,:));
            plot(th_ax,f_,Z_phase,...
                'displayname',ac.name,...
                'tag',drugs{c},...
                'color',clrs(ac_idx,:));
                        
            set(z_ax,'xlim',[3 300])
            if type_idx==1
                set(z_ax,'ylim',[0 .6])
            else
                set(z_ax,'ylim',[0 1])
            end
            
            set(th_ax,'xlim',[3 300],'ylim',[-90 30])
            set(th_ax,'xlim',[3 300],'ylim',[-90 30])
            plot(th_ax,[3 300],[0 0],'color',[.8 .8 .8])
        end
        drawnow
    end
    statsclrs = [0 0 1;1 0 0];
    Rpeak_ax = st_pnl(1,1).select(); hold(Rpeak_ax,'on');
    set(Rpeak_ax,'tag','peak_drugs_vs_peak_ctrl');
    plot(Rpeak_ax,max_Z_ctrl,max_Z_drugs,'.','color',statsclrs(type_idx,:))
    if type_idx==1
        plot(Rpeak_ax,[0 100],[0 100],'-','color',[.8 .8 .8])
        st_pnl(1,1).ylabel('drugs (Hz)');
        st_pnl(1,1).xlabel('ctrl (Hz)');
        
    end
    
    fprintf('type %d: max_Z_ctrl\n',type_idx)
    disp(max_Z_ctrl)
    fprintf('type %d: max_Z_drugs\n',type_idx)
    disp(max_Z_drugs)
    
end

%% Sweeps stuff
DRUGS = {'AchI','TTX','4AP_TEA'};

statsclrs = [1 0 1;0 .5 0];
Rpeak_ax = st_pnl(1,1).select(); hold(Rpeak_ax,'on');

Vm_ax = st_pnl(1,2).select(); hold(Vm_ax,'on');
Variance_ax = st_pnl(2,2).select(); hold(Variance_ax,'on');

for type_idx = 1:length(geno_idx)    
    g_idx = find(genotype_idx==geno_idx(type_idx));

    clrs = distinguishable_colors(length(g_idx),{'w','k',[1 1 0],[1 1 1]*.8});
    %clrs(:) = .8;
    max_Z_ctrl = nan(length(g_idx),1);
    max_Z_drugs = nan(length(g_idx),1);
    for ac_idx = 1:length(g_idx)
        
        DRUGS = {'AchI','TTX','4AP_TEA'};
        clear tag_collections_ tag_collections_VS
        
        ac = analysis_cell(g_idx(ac_idx));
        trial = load(ac.trials.Sweep);
        h = getShowFuncInputsFromTrial(trial);
        
        % Find trials for a drug condition

        tag_collections_VS = {};
        for pd_ind = 1:length(h.prtclData);
            %fprintf('\n%d - ', h.prtclData(pd_ind).trial);fprintf('%s;',h.prtclData(pd_ind).tags{:})
            tg_collection_str = sprintf('%s; ',h.prtclData(pd_ind).tags{:});
            if ~ismember(tg_collection_str,tag_collections_VS);
                tag_collections_VS{end+1} = tg_collection_str;
                %fprintf(1,'%s\n',tg_collection_str);
            end
        end

        concstrprfunc = @(c)regexprep(c,{'50uM','50 uM','5mM','10 mM','10mM','1uM','0mM','1 uM','\s'},{'','','','','','','','','_'});
        for tc_ind = 1:length(tag_collections_VS)
            tag_collections_{tc_ind} = concstrprfunc(tag_collections_VS{tc_ind});
            tag_collections_{tc_ind} = concstrprfunc(tag_collections_VS{tc_ind});
        end

        strprfunc = @(c)regexprep(c,{';','\s','_+','_$','\.'},{'','_','_','','_'});
        for tc_ind = 1:length(tag_collections_)
            tag_collections_{tc_ind} = strprfunc(tag_collections_{tc_ind});
            tag_collections_{tc_ind} = strprfunc(tag_collections_{tc_ind});
        end
        
        trial_seeds = nan(1,length(tag_collections_VS));
        
        warning('off','MATLAB:load:variableNotFound');
        for pd_ind = 1:length(h.prtclData);
            t_ind = find(strcmp(tag_collections_VS,sprintf('%s; ',h.prtclData(pd_ind).tags{:})));
            if isnan(trial_seeds(t_ind))
                trial_seeds(t_ind) = h.prtclData(pd_ind).trial;
                ex = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds(t_ind))),'excluded');
                if isfield(ex,'excluded') && ex.excluded
                    trial_seeds(t_ind) = nan;
                end
            end
        end
        warning('on','MATLAB:load:variableNotFound')
        
        AchI_drug = '';
        for str = {'curare','MLA'};
            if ~isempty(strfind(tag_collections_{end},str));
                AchI_drug = str;
            end
        end
        
        DRUGS(strcmp(DRUGS,'AchI')) = AchI_drug;
        
        tag_idx = nan(size(DRUGS));
        for drg_idx = 1:length(DRUGS)
            for tg_idx = 1:length(tag_collections_VS);
                if length(tag_collections_{tg_idx}) >= length(DRUGS{drg_idx}) && ...
                        strcmp(tag_collections_{tg_idx}(end-length(DRUGS{drg_idx})+1:end),DRUGS{drg_idx})
                    tag_idx(drg_idx) = tg_idx;
                end
            end
        end
        
        [tag_idx,o] = sort(tag_idx);
        drugs = DRUGS(o);
%         drugs = DRUGS;
        drugs = drugs(~isnan(tag_idx));
        tag_idx = tag_idx(~isnan(tag_idx));
        trial_seeds_ = trial_seeds(tag_idx);
        fprintf('%s\n',ac.name)
        disp(tag_collections_')
        try
            fprintf('%d - %s - trial: %d\n%d - %s - trial: %d\n%d - %s - trial: %d\n',...
                tag_idx(1),drugs{1},trial_seeds_(1),...
                tag_idx(2),drugs{2},trial_seeds_(2),...
                tag_idx(3),drugs{3},trial_seeds_(3));
        catch
            beep
            fprintf('%d - %s\n%d - %s\n%d - %s\n',tag_idx(1),drugs{1},tag_idx(2),drugs{2});
        end
        
        % average the currents across trials
        x = makeTime(h.trial.params);
        xwin = x>=.08;
        % f = trial.params.sampratein/length(x(xwin))*[0:length(x(xwin))/2];
        % f = [f, fliplr(f(2:end-1))];
        [Pxx,f] = pwelch(h.trial.voltage-mean(h.trial.voltage,1),h.trial.params.sampratein,[],[],h.trial.params.sampratein);
        
        Vm_drugs = nan(size(trial_seeds_));
        Variance_drugs = nan(size(trial_seeds_));
        Variance_PS_drugs = nan(size(trial_seeds_));
        for c = 1:size(trial_seeds_,2)
            if isnan(trial_seeds_(c))
                continue
            end
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds_(c))));
            h = getShowFuncInputsFromTrial(trial);

            trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);

            y = zeros(length(f),length(trials));
            vm = 0;
            Variance = 0;
            Variance_PS = 0;
            for t = 1:length(trials)
                trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t))));
                
                vm = vm+mean(trial.voltage(xwin),1);
                
                voltage = trial.voltage(xwin)-mean(trial.voltage(xwin),1);
                Variance = Variance+sum(voltage.^2)/(length(voltage));%*diff(t(1:2)));

                [Pxx,f] = pwelch(trial.voltage(xwin)-mean(trial.voltage(xwin),1),h.trial.params.sampratein,[],[],h.trial.params.sampratein);
                y(:,t) = Pxx;%/diff(f(1:2));
                
                P = sum(Pxx((f>10&f<58.5)|(f>61.5)));
                Variance_PS = Variance_PS+P;
            end
                        
            vm = vm/length(trials);
            Vm_drugs(c) = vm;
            Variance = Variance/length(trials);
            Variance_drugs(c) = Variance;
            Variance_PS = Variance_PS/length(trials);
            Variance_PS_drugs(c) = Variance_PS;
            
            if strcmp(ac.name,'151022_F2_C1')||strcmp(ac.name,'151210_F3_C1')
                sweep_ax = pnl(type_idx,4,c).select(); hold(sweep_ax,'on');
                plot(sweep_ax,x(xwin),trial.voltage(xwin),...
                    'displayname',ac.name,...
                    'tag',[drugs{c} '_' num2str(trial.params.trial)],...
                    'color',clrs(ac_idx,:));
                set(sweep_ax,'ylim',[-50 -35],'xlim', [1.5 2])
            end
            
            %             if o(c)==1 || o(c)==3
            %                 if o(c)==1
            %                     ps_ax = pnl(type_idx,5,1).select(); hold(ps_ax,'on');
            %                 else
            %                     ps_ax = pnl(type_idx,5,2).select(); hold(ps_ax,'on');
            %                 end
            %
            %             end
            if o(2)== 3
                clr = [1 0 0];
            elseif o(2)==2
                clr = [0 0 1];
            end
            
            ps_ax = pnl(type_idx,5,c).select(); hold(ps_ax,'on');
            set(ps_ax,'tag',['PSax_' num2str(type_idx) '_' num2str(c)])
            loglog(ps_ax,f,mean(y,2),...
                'displayname',ac.name,...
                'tag',[drugs{c} '_' num2str(trials(1))],...
                'color',clr); %clrs(ac_idx,:));
            
            set(ps_ax,'xscale','log','xlim',[1 1000],'yscale','log','ylim',[1E-7 1E-1])

        end
        indx = 1:length(Vm_drugs);
        set(Vm_ax,'tag','Vm_vs_drugs');

        if o(2)== 3
            clr = [1 0 0];
        elseif o(2)==2
            clr = [0 0 1];
        end

        plot(Vm_ax,indx+3*(type_idx-1),Vm_drugs(o),...
            'marker','o','markeredgecolor',clr,'markerfacecolor','none',...
            'linestyle','-','color',clr,...
            'displayname',ac.name)
        set(Vm_ax,'ylim',[-55 -27])

%         if type_idx== 1
%             clr = [1 .5 .5];
%         elseif type_idx== 2
%             clr = [.5 .5 1];
%         end
%         
%         plot(Variance_ax,indx+3*(type_idx-1),Variance_drugs,...
%             'marker','o','markeredgecolor',clr,'markerfacecolor','none',...
%             'linestyle','-','color',clr,...
%             'displayname',ac.name)
%         %set(Variance_ax,'ylim',[-55 -27])

        if type_idx== 1
            clr = [0 0 .5];
        elseif type_idx== 2
            clr = [.5 0 0];
        end
        
        plot(Variance_ax,indx+3*(type_idx-1),Variance_PS_drugs,...
            'marker','o','markeredgecolor',clr,'markerfacecolor','none',...
            'linestyle','-','color',clr,...
            'displayname',ac.name)
        %set(Variance_ax,'ylim',[-55 -27])
        
        
        drawnow
    end
%     if type_idx==1
%         plot(Rpeak_ax,[0 100],[0 100],'-','color',[.8 .8 .8])
%         st_pnl(1,1).ylabel('drugs (Hz)');
%         st_pnl(1,1).xlabel('ctrl (Hz)');
        
%     end
    
%     fprintf('type %d: max_Z_ctrl\n',type_idx)
%     disp(max_Z_ctrl)
%     fprintf('type %d: max_Z_drugs\n',type_idx)
%     disp(max_Z_drugs)
    
end

%% 

clrs = {    [0 0 0.5]   [.5 0 0]   
            [0 0 1]     [1 0 0] 
            [.5 .5 1]   [1 .5 .5]};
        
for type_idx = 1:2
    PS_ax = st_pnl(2,1,type_idx).select(); hold(PS_ax,'on')
    set(PS_ax,'xscale','log','xlim',[1 300],'yscale','log','ylim',[1E-5  1E-1])
    for c = 1:3
        l = get(pnl(type_idx,5,c).select(),'children');
        x = l(1).XData;
        y = cell2mat(get(l,'YData'));
        y_ = mean(y,1);
        plot(PS_ax, x,y_,'color',clrs{c,type_idx});
        
    end
end



%%

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure7/';
savePDFandFIG(figure7,savedir,[],'FigureS7_IntrinsicProperties')

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure7/';
savePDFandFIG(figure7stats,savedir,[],'FigureS7_IP_Stats')

% %% 
% 
% close all
% uiopen('C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure7\FigureS7_IP_Stats.fig',1)
% figure7stats = gcf;
% uiopen('C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure7\FigureS7_IntrinsicProperties.fig',1)
% figure7 = gcf;
% 
% 





