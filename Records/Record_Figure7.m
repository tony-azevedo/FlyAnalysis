%% Record of V-gated conductance analysis
close all

Record_VClampCurrentIsolation_Cells

savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation';

figure7 = figure;
figure7.Units = 'inches';
set(figure7,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronTwoColumn'), .9*getpref('FigureSizes','NeuronOneAndHalfColumn')])

pnl = panel(figure7);
pnl.margin = [20 4 4 4];

figurerows = [3 8 6];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);

pnl(1).pack('h',3)
% pnl(1).margin = [4 4 4 4];

pnl(2).pack('h',3)
pnl(2).margin = [4 4 4 4];
lilgap = .004;

pnl(3).pack('h',3)
pnl(3).margin = [4 4 4 4];

warning('off')
geno_idx = [3 1 2];

for type_idx = 1:length(geno_idx)
    DRUGS = {'AchI','TTX','4AP_TEA'};
    
    figurerows = [1 4*ones(size((1:length(DRUGS)+1)))];
    figurerows = num2cell(figurerows/sum(figurerows));
    pnl(2,type_idx).pack('v',figurerows)
    pnl(2,type_idx,1).pack('h',{1/10 9/10});     
    stimax = pnl(2,type_idx,1,2).select();
    set(stimax,'tag',['stimax_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[],'ycolor',[1 1 1],'ytick',[]);

    for c = 1:length(DRUGS)
        pnl(2,type_idx,c+1).pack('h',{1/10 9/10});     
        
        drugax = pnl(2,type_idx,c+1,1).select();
        set(drugax,'tag',[DRUGS{c} '_b_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[]);
        baseax = pnl(2,type_idx,c+1,2).select();
        set(baseax,'tag',[DRUGS{c} '_c_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[])%,'ycolor',[1 1 1],'ytick',[]);
    end
    pnl(2,type_idx,c+2).pack('h',{1/10 9/10});

    drugax = pnl(2,type_idx,c+2,1).select();
    set(drugax,'tag',['remainder_b_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[]);
    baseax = pnl(2,type_idx,c+2,2).select();
    set(baseax,'tag',['remainder_c_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[])%,'ycolor',[1 1 1],'ytick',[]);

    % set up Z axes
    pnl(3,type_idx).pack('h',{1/10 9/10});
    figurerows = [1 1];
    figurerows = num2cell(figurerows/sum(figurerows));

    % BODE PLOT
    pnl(3,type_idx,2).pack('v',figurerows)    
    magax = pnl(3,type_idx,2,1).select();
    set(magax,'tag',['Z_mag_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[]);
    phaseax = pnl(3,type_idx,2,2).select();
    set(phaseax,'tag',['Z_phase_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[]);
    
    % Complex PLOT
%     Zax = pnl(3,type_idx,2).select();
%     set(Zax,'tag',['Z_' num2str(type_idx)],'tickdir','out');
   

end

%% plot 25 Hz oscillations and command potentials for A2 cells, Fru and VT cells

ex_trials = {example_a2.VoltageSineTrial
    example_fru.VoltageSineTrial
    example_vt.VoltageSineTrial
    };

ylims = [Inf -Inf];

for fc = 1:length(ex_trials)
    pnl(1,fc).pack('h',4)
    pnl(1,fc).margin = [8 8 8 8];
    
    trial = load(ex_trials{fc});
    h = getShowFuncInputsFromTrial(trial);
    x = makeInTime(trial.params);
    sine_trials = findLikeTrials('name',trial.name,'exclude',{'freq'});
    t = 1;
    while t <= length(sine_trials)
        trials = findLikeTrials('trial',sine_trials(t),'datastruct',h.prtclData);
        sine_trials = setdiff(sine_trials,setdiff(trials,sine_trials(t)));
        t = t+1;
    end
    
    for st = 1:length(sine_trials)
        
        pnl(1,fc,st).pack('v',{1/8 7/8})
        pnl(1,fc,st).margin = [4 4 4 4];
        pnl(1,fc,st).de.margin = [4 4 4 4];
        
        stimax = pnl(1,fc,st,1).select();
        currax = pnl(1,fc,st,2).select();
        curraxes(fc,st) = currax;
        trial = load(fullfile(h.dir,sprintf(h.trialStem,sine_trials(st))));
        
        line(x,VoltageSineStim(trial.params),'parent',stimax,'color',.8*[1 1 1])
        
        d1 = getpref('FigureMaking','CurrentFilter');
        trials = findLikeTrials('name',trial.name);
        y = zeros(length(trial.current),length(trials));
        for t = 1:length(trials)
            trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t))));
            y(:,t) = trial.current;
        end
        y_ = mean(y,2);
        for c = 1:size(y,2);
            y(:,c) = filtfilt(d1,y(:,c));
        end
        y_ = filtfilt(d1,y_);
        
        line(x,y(:,1),'parent',currax,'color',0*[1 1 1])
        % line(x,y_,'parent',currax,'color',0*[1 1 1])
        % sem_up = std(y,[],2)/sqrt(length(trials));
        % sem_down = y_-sem_up;
        % sem_up = y_+sem_up;
        %
        % line(x(x_win),sem_down(x_win),'parent',ax,'color',[1 .7 .7],'tag',savetag);
        % line(x(x_win),sem_up(x_win),'parent',ax,'color',[1 .7 .7],'tag',savetag);
        
        axis(currax,'tight');
        ylims = [...
            min([ylims(1) min(get(currax,'ylim'))]),...
            max([ylims(2) max(get(currax,'ylim'))])];
        
        set([stimax,currax],'xlim',[-.04 0.08],'xcolor',[1 1 1],'xtick',[],'ycolor',[1 1 1],'ytick',[],'tickdir','out')
    end
end
set(curraxes(:),'ylim',ylims);
set(pnl(1,1,1,2).select(),'ycolor',0*[1 1 1],'ytickmode','auto')


%% For Fru, 

warning('off')
geno_idx = [3 1 2];
for type_idx = 1:length(geno_idx)
    DRUGS = {'AchI','TTX','4AP_TEA'};
    
    g_idx = find(genotype_idx==geno_idx(type_idx));

    clrs = distinguishable_colors(length(g_idx),{'w','k',[1 1 0],[1 1 1]*.8});
    clrs(:) = .8;
    for ac_idx = 1:length(g_idx)
        
        DRUGS = {'AchI','TTX','4AP_TEA'};
        clear tag_collections_ tag_collections_VS
        
        ac = analysis_cell(g_idx(ac_idx));
        trial = load(ac.trials.VoltageSine);
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
        
        %trial_seeds_allamps = reshape(trial_seeds(~isnan(trial_seeds)),length(trial.params.amps),length(trial.params.freqs),[]);
        trial_seeds_allamps = reshape(trial_seeds,length(trial.params.amps),length(trial.params.freqs),[]);
        trial_seeds = trial_seeds_allamps(2,:,:);
        %trial_seeds = reshape(trial_seeds(~isnan(trial_seeds)),length(trial.params.freqs),[]);
        trial_seeds = reshape(trial_seeds,length(trial.params.freqs),[]);
                
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
        drugs = drugs(~isnan(tag_idx));
        tag_idx = tag_idx(~isnan(tag_idx));
        trial_seeds_ = trial_seeds(:,tag_idx);
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
        xwin = x>=trial.params.ramptime & x<=trial.params.stimDurInSec-trial.params.ramptime;
        xwin_Z = x>=trial.params.ramptime*1.5 & x<=trial.params.stimDurInSec-trial.params.ramptime*1.5;
        d1 = getpref('FigureMaking','CurrentFilter');
        
        x_start = 0;
        Z_w = zeros(size(trial_seeds_));
        baselinecurrent = zeros(size(trial_seeds_,1),size(trial_seeds_,2)+1);
        baselinecurrent_ = baselinecurrent;

        for r = 1:size(trial_seeds_,1)

            current = zeros(sum(xwin),size(trial_seeds_,2));
            
            Z_ = zeros(sum(xwin_Z),size(trial_seeds_,2));
            for c = 1:size(trial_seeds_,2)
                trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds_(r,c))));
                
                trials = findLikeTrials('name',trial.name);

         % store that in some structure
                Z = zeros(size(xwin));
                s = VoltageSineStim(trial.params)/trial.params.amp;
                Vz = hilbert(s);
                               
                for t = 1:length(trials)
                    trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds_(r,c))));
                    trial.current = filtfilt(d1,trial.current);
                    Z = Z + trial.current;
                    current(:,c) = current(:,c)+trial.current(xwin);
                    baselinecurrent(r,c) = baselinecurrent(r,c)+mean(trial.current(x<0&x>-trial.params.preDurInSec+.075));
                end
                current(:,c) = current(:,c)/t;
                baselinecurrent(r,c) = baselinecurrent(r,c)/t;
                
                Z = Z/t;
                Z = hilbert(Z - mean(Z(x>0&x<trial.params.stimDurInSec)));
                Z_(:,c) = 1E-3*Vz(xwin_Z)./(Z(xwin_Z)*1E-12);
                Z_w(r,c) = mean(Z_(:,c));
            end
            
            current_ = zeros(size(current,1),size(current,2)+1);
            current_(:,1) = current(:,1);
            % After getting all the conditions, subtract one from the next
            
            baselinecurrent_(r,1) = baselinecurrent(r,1);
            for c = 2:size(current,2)
                current_(:,c) = current(:,c-1)-current(:,c);
                baselinecurrent_(r,c) = baselinecurrent(r,c-1)-baselinecurrent(r,c);
            end
            current_(:,end) = current(:,end);
            baselinecurrent_(r,end) = baselinecurrent(r,c);
            
            
            % then calculate the cycle average

            s = VoltageSineStim(trial.params)/trial.params.amp;
            [cyclemat,ascd,peak,desc,vall] = findSineCycle(s(xwin),0,[]);
            N = min(diff(ascd));
            x_ = x(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+N-1));
            x_ = x_-x_(1);
            s_ = s(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+N-1));

            current_cycles = zeros(N,size(current_,2));
            for c = 1:size(current_cycles,2)
                y = zeros(N,length(diff(ascd)));
                y_inwin = current_(:,c);
                for dN = 1:length(diff(ascd))
                    y(:,dN) = y_inwin(ascd(dN):ascd(dN)+N-1);
                end
                current_cycles(:,c) = mean(y,2);
            end
            
            drugs_ = drugs;
            drugs_{strcmp(drugs_,AchI_drug)} = 'AchI';
            x_ = x_+x_start;
            
            
            % then plot in the appropriate window

            stimax = findobj('type','axes','tag',['stimax_' num2str(type_idx)]);
            line(x_,s_,'parent',stimax,'color',[.8 .8 .8]);
            
            clr = clrs(ac_idx,:);
            for c = 1:length(drugs_)
                drugax = findobj('type','axes','tag',[drugs_{c} '_c_' num2str(type_idx)]);
                line(x_,current_cycles(:,c),'parent',drugax,'color',clr,'tag',num2str(trial.params.freqs(r)),'DisplayName',ac.name);
                drawnow
            end
            drugax = findobj('type','axes','tag',['remainder_c_' num2str(type_idx)]);
            line(x_,current_cycles(:,c+1),'parent',drugax,'color',clr,'tag',num2str(trial.params.freqs(r)),'DisplayName',ac.name);

            x_start = x_(end) + lilgap;
            figure(figure7)
            drawnow;
        end
        for c = 1:length(drugs)
            drugax = findobj('type','axes','tag',[drugs_{c} '_c_' num2str(type_idx)]);
            line([0 x_(end)],[0 0],'parent',drugax,'color',clr,'DisplayName',ac.name);
            baseax = findobj('type','axes','tag',[drugs_{c} '_b_' num2str(type_idx)]);
            line(0,mean(baselinecurrent_(:,c)),'parent',baseax,'linestyle','none','marker','o','markeredgecolor',[0 0 0],'markerfacecolor','none');
            set([drugax baseax],'ylim',[-70 100])
        end
        drugax = findobj('type','axes','tag',['remainder_c_' num2str(type_idx)]);
        line([0 x_(end)],[0 0],'parent',drugax,'color',[.8 .8 .8],'DisplayName',ac.name);
        baseax = findobj('type','axes','tag',['remainder_b_' num2str(type_idx)]);
        line(0,mean(baselinecurrent_(:,end)),'parent',baseax,'linestyle','none','marker','o','markeredgecolor',[0 0 0],'markerfacecolor','none');
        set([drugax baseax],'ylim',[-70 100])

        
        % Plot Z_w for this cell
        
        % BODE PLOT
        magax = findobj('type','axes','tag',['Z_mag_' num2str(type_idx)]);
        % initial
        line(trial.params.freqs,abs(Z_w(:,1)),'parent',magax,...
            'color',[0 0 1],'linestyle','-',...
            'marker','o','markerfacecolor','none',...
            'tag','initial','displayname',ac.name);
        % final (all drugs)
        line(trial.params.freqs,abs(Z_w(:,end)),'parent',magax,...
            'color',[1 0 0],'linestyle','-',...
            'marker','o','markerfacecolor','none',...
            'tag','final','displayname',ac.name);
            
        phaseax = findobj('type','axes','tag',['Z_phase_' num2str(type_idx)]);
        % initial
        line(trial.params.freqs,angle(Z_w(:,1)),'parent',phaseax,...
            'color',[0 0 1],'linestyle','-',...
            'marker','o','markerfacecolor','none',...
            'tag','initial','displayname',ac.name);
        % final (all drugs)
        line(trial.params.freqs,angle(Z_w(:,end)),'parent',phaseax,...
            'color',[1 0 0],'linestyle','-',...
            'marker','o','markerfacecolor','none',...
            'tag','final','displayname',ac.name);

        % COMPLEX PLOT
%         Zax = findobj('type','axes','tag',['Z_' num2str(type_idx)]);
%         % initial
%         line(real(Z_w(:,1)),imag(Z_w(:,1)),'parent',Zax,...
%             'color',[0 0 1],'linestyle','-',...
%             'marker','o','markerfacecolor','none',...
%             'tag','initial','displayname',ac.name);
%         % final (all drugs)
%         line(real(Z_w(:,end)),imag(Z_w(:,end)),'parent',Zax,...
%             'color',[1 0 0],'linestyle','-',...
%             'marker','o','markerfacecolor','none',...
%             'tag','final','displayname',ac.name);

        
    end
end

%% Go through and average and clean up all the axes.

for type_idx = 1:length(geno_idx)
    DRUGS = {'AchI','TTX','4AP_TEA'};
    drugax = findobj('type','axes','tag',[DRUGS{1} '_c_' num2str(type_idx)]);
    for r = 1:length(trial.params.freqs)
        l = findobj(drugax,'type','line','tag',num2str(trial.params.freqs(r)));
        y = cell2mat(get(l,'ydata'));
        
        line(get(l(1),'xdata'),mean(y,1),'parent',drugax,'color',[0 0 1],'tag',['y_' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);
    end
    text(.0025, 100,['N=' num2str(length(l))],'parent',drugax,'verticalalignment','top','horizontalalignment','left');
    
    for c = 2:3
        drugax = findobj('type','axes','tag',[DRUGS{c} '_c_' num2str(type_idx)]);
        for r = 1:length(trial.params.freqs)
            l = findobj(drugax,'type','line','tag',num2str(trial.params.freqs(r)));
            y = cell2mat(get(l,'ydata'));
            
            line(get(l(1),'xdata'),mean(y,1),'parent',drugax,'color',[0 0 0],'tag',['y_' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);
        end
    end

    drugax = findobj('type','axes','tag',['remainder_c_' num2str(type_idx)]);
    for r = 1:length(trial.params.freqs)
        l = findobj(drugax,'type','line','tag',num2str(trial.params.freqs(r)));
        y = cell2mat(get(l,'ydata'));
        
        line(get(l(1),'xdata'),mean(y,1),'parent',drugax,'color',[1 0 0],'tag',['y_' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);
    end
    
    % magnitude
    magax = findobj('type','axes','tag',['Z_mag_' num2str(type_idx)]);
    set(magax,'xlim',[0 500],'ylim',[0 2E8])
   
    % initial
    l = findobj(magax,'type','line','tag','initial');
    set(l,'linestyle','none','markeredgecolor',[.7 .7 1]);
    y = cell2mat(get(l,'ydata'));
    line(get(l(1),'xdata'),mean(y,1),'parent',magax,...
        'color',[0 0 1],'linestyle','-',...
        'marker','o','markeredgecolor',[0 0 1],'markerfacecolor',[0 0 1],...
        'tag',['y_initial' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);

    % final (all drugs)
    l = findobj(magax,'type','line','tag','final');
    set(l,'linestyle','none','markeredgecolor',[1 .7 .7]);
    y = cell2mat(get(l,'ydata'));
    line(get(l(1),'xdata'),mean(y,1),'parent',magax,...
        'color',[1 0 0],'linestyle','-',...
        'marker','o','markeredgecolor',[1 0 0],'markerfacecolor',[1 0 0],...
        'tag',['y_initial' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);

    % phase
    phaseax = findobj('type','axes','tag',['Z_phase_' num2str(type_idx)]);
    set(phaseax,'xlim',[0 500],'ylim',[-pi/2 pi/4],'ytick',[-pi/2 -pi/4 0 pi/4],'yticklabel',{'-\pi/2','-\pi/4','0','\pi/4',})
    
    % initial
    l = findobj(phaseax,'type','line','tag','initial');
    set(l,'linestyle','none','markeredgecolor',[.7 .7 1]);
    y = cell2mat(get(l,'ydata'));
    line(get(l(1),'xdata'),mean(y,1),'parent',phaseax,...
        'color',[0 0 1],'linestyle','-',...
        'marker','o','markeredgecolor',[0 0 1],'markerfacecolor',[0 0 1],...
        'tag',['y_initial' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);

    % final (all drugs)
    l = findobj(phaseax,'type','line','tag','final');
    set(l,'linestyle','none','markeredgecolor',[1 .7 .7]);
    y = cell2mat(get(l,'ydata'));
    line(get(l(1),'xdata'),mean(y,1),'parent',phaseax,...
        'color',[1 0 0],'linestyle','-',...
        'marker','o','markeredgecolor',[1 0 0],'markerfacecolor',[1 0 0],...
        'tag',['y_initial' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);
 
end

savePDFandFIG(figure7,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure7',[],'Figure7');



