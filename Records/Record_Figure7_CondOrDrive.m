%% Record of V-gated conductance analysis
close all

Record_VClampCurrentIsolation_Cells

savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation';

figure7_Sbtrct = figure;
figure7_Sbtrct.Units = 'inches';
set(figure7_Sbtrct,'color',[1 1 1],'position',[1 0 getpref('FigureSizes','NeuronTwoColumn'), 12])

pnl_S = panel(figure7_Sbtrct);
pnl_S.margin = [20 4 4 4];
pnl_S.pack('h',3)
lilgap = .004;

warning('off')
geno_idx = [3 1 2];

for type_idx = 1:length(geno_idx)
    DRUGS = {'AchI','TTX','4AP_TEA'};
    
    figurerows = [1 4*ones(size((1:length(DRUGS)+1)))];
    figurerows = num2cell(figurerows/sum(figurerows));
    pnl_S(type_idx).margin = [4 4 4 4];
    
    pnl_S(type_idx).pack('v',figurerows)
    stimax = pnl_S(type_idx,1).select();
    set(stimax,'tag',['stimax_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[],'ycolor',[1 1 1],'ytick',[]);

    for c = 1:length(DRUGS)
        drugax = pnl_S(type_idx,c+1).select();
        set(drugax,'tag',[DRUGS{c} '_c_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[])%,'ycolor',[1 1 1],'ytick',[]);
    end
    drugax = pnl_S(type_idx,c+2).select();
    set(drugax,'tag',['remainder_c_' num2str(type_idx)],'tickdir','out','xcolor',[1 1 1],'xtick',[])%,'ycolor',[1 1 1],'ytick',[]);   

end

%% Subtract currents and plot

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
            voltage = zeros(sum(xwin),1);
            voltage_ = zeros(sum(xwin),1);
            
            Z_ = zeros(sum(xwin_Z),size(trial_seeds_,2));
            for c = 1:size(trial_seeds_,2)
                trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds_(r,c))));
                
                trials = findLikeTrials('name',trial.name);

         % store that in some structure
                Z = zeros(size(xwin));
                s = VoltageSineStim(trial.params)/trial.params.amp;
                Vz = hilbert(s);
                
                voltage_ = zeros(sum(xwin),1);

                for t = 1:length(trials)
                    trial = load(fullfile(h.dir,sprintf(h.trialStem,trial_seeds_(r,c))));
                    trial.current = filtfilt(d1,trial.current);
                    Z = Z + trial.current;
                    current(:,c) = current(:,c)+trial.current(xwin);
                    voltage_ = voltage_ + trial.voltage(xwin);
                    baselinecurrent(r,c) = baselinecurrent(r,c)+mean(trial.current(x<0&x>-trial.params.preDurInSec+.075));
                end
                current(:,c) = current(:,c)/t;
                baselinecurrent(r,c) = baselinecurrent(r,c)/t;
                voltage = voltage + voltage_/t;

                Z = Z/t;
                Z = hilbert(Z - mean(Z(x>0&x<trial.params.stimDurInSec)));
                Z_(:,c) = 1E-3*Vz(xwin_Z)./(Z(xwin_Z)*1E-12);
                Z_w(r,c) = mean(Z_(:,c));
            end
            voltage = voltage/c;
            
            current_ = zeros(size(current,1),size(current,2)+1);
            current_(:,1) = current(:,1);
            % After getting all the conditions, subtract one from the next
            
            baselinecurrent_(r,1) = baselinecurrent(r,1);

            ENa = 1000*nernstPotential(130, 1.5,1);
            %ENa = 50;
            EK = 1000*nernstPotential(3,141,1);
            Erev = zeros(size(drugs));
            Erev(strcmp(drugs,'TTX')) = ENa;
            Erev(strcmp(drugs,'4AP_TEA')) = EK;
            g_diff = current_;
            for c = 2:size(current,2)
                current_(:,c) = current(:,c-1)-current(:,c);
                baselinecurrent_(r,c) = baselinecurrent(r,c-1)-baselinecurrent(r,c);
                g_diff(:,c) = current_(:,c)./(voltage-Erev(c));
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
            for c = 2:3 %size(current_cycles,2)
                y = zeros(N,length(diff(ascd)));
                y_inwin = g_diff(:,c);
                for dN = 1:length(diff(ascd))
                    y(:,dN) = y_inwin(ascd(dN):ascd(dN)+N-1);
                end
                current_cycles(:,c) = mean(y,2);
            end
            
            drugs_ = drugs;
            drugs_{strcmp(drugs_,AchI_drug)} = 'AchI';
            x_ = x_+x_start;
            
            
            % then plot in the appropriate window

            stimax = findobj(figure7_Sbtrct,'type','axes','tag',['stimax_' num2str(type_idx)]);
            line(x_,s_,'parent',stimax,'color',[.8 .8 .8]);
            
            clr = clrs(ac_idx,:);
            for c = 1:length(drugs_)
                drugax = findobj('type','axes','tag',[drugs_{c} '_c_' num2str(type_idx)]);
                line(x_,current_cycles(:,c),'parent',drugax,'color',clr,'tag',num2str(trial.params.freqs(r)),'DisplayName',ac.name);
                drawnow
            end
            drugax = findobj(figure7_Sbtrct,'type','axes','tag',['remainder_c_' num2str(type_idx)]);
            line(x_,current_cycles(:,c+1),'parent',drugax,'color',clr,'tag',num2str(trial.params.freqs(r)),'DisplayName',ac.name);

            x_start = x_(end) + lilgap;
            figure(figure7_Sbtrct)
            drawnow;
        end
        for c = 1:length(drugs)
            drugax = findobj('type','axes','tag',[drugs_{c} '_c_' num2str(type_idx)]);
            line([0 x_(end)],[0 0],'parent',drugax,'color',clr,'DisplayName',ac.name);
            baseax = findobj('type','axes','tag',[drugs_{c} '_b_' num2str(type_idx)]);
            line(0,mean(baselinecurrent_(:,c)),'parent',baseax,'linestyle','none','marker','o','markeredgecolor',[0 0 0],'markerfacecolor','none');
            set([drugax baseax],'ylim',[-.2 1])
        end
        drugax = findobj('type','axes','tag',['remainder_c_' num2str(type_idx)]);
        line([0 x_(end)],[0 0],'parent',drugax,'color',[.8 .8 .8],'DisplayName',ac.name);
        baseax = findobj('type','axes','tag',['remainder_b_' num2str(type_idx)]);
        line(0,mean(baselinecurrent_(:,end)),'parent',baseax,'linestyle','none','marker','o','markeredgecolor',[0 0 0],'markerfacecolor','none');
        set([drugax baseax],'ylim',[-70 100])
        
    end
end

savePDFandFIG(figure7_Sbtrct,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8_Sinusoidal_voltage_commands\draft_material',[],['VoltageSineConductances_' sprintf('%.0f',ENa)]);


%% Go through and average and clean up all the axes.
% close(figure7_Sbtrct)
% close(figure7_Z)

ENastr = '115';
uiopen(['C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8_Sinusoidal_voltage_commands\draft_material\VoltageSineConductances_' ENastr '.fig'],1)
figure7_Sbtrct = gcf;


for type_idx = 1:length(geno_idx)
    DRUGS = {'AchI','TTX','4AP_TEA'};
    drugax = findobj(figure7_Sbtrct,'type','axes','tag',[DRUGS{1} '_c_' num2str(type_idx)]);
    %set(drugax,'ylim',[-50 80])
    
    for c = 2:3
        drugax = findobj(figure7_Sbtrct,'type','axes','tag',[DRUGS{c} '_c_' num2str(type_idx)]);
        set(drugax,'ylim',[-.2 1])
        for r = 1:length(trial.params.freqs)
            l = findobj(drugax,'type','line','tag',num2str(trial.params.freqs(r)));
            y = cell2mat(get(l,'ydata'));
            
            line(get(l(1),'xdata'),mean(y,1),'parent',drugax,'color',[0 0 0],'tag',['y_' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);
            sem_up = std(y,[],1)/sqrt(length(l));
            y_ = mean(y,1);
            sem_down = y_-sem_up;
            sem_up = y_+sem_up;
            
            line(get(l(1),'xdata'),sem_up,'parent',drugax,'color',[.7 .7 .7],'tag',['sem_up_' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);
            line(get(l(1),'xdata'),sem_down,'parent',drugax,'color',[.7 .7 .7],'tag',['sem_down_' num2str(trial.params.freqs(r))],'DisplayName',[num2str(trial.params.freqs(r)) ' Hz']);
            delete(l);
        end
    end

end

savePDF(figure7_Sbtrct,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8_Sinusoidal_voltage_commands\draft_material',[],['VoltageSineConductances_' ENastr]);



