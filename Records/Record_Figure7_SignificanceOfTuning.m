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

figure7_Amps = figure;
figure7_Amps.Units = 'inches';
set(figure7_Amps,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneColumn'), 5])

pnl_A = panel(figure7_Amps);
pnl_A.margin = [16 16 10 10];
pnl_A.pack('h',2)

pnl_A(1).pack('v',2);
ampax = pnl_A(1,1).select();
set(ampax,'tag',[DRUGS{2} '_a_2'],'tickdir','out','xcolor',[1 1 1],'xtick',[])%,'ycolor',[1 1 1],'ytick',[]);
ampax = pnl_A(1,2).select();
set(ampax,'tag',[DRUGS{3} '_a_2'],'tickdir','out','xcolor',[1 1 1],'xtick',[])%,'ycolor',[1 1 1],'ytick',[]);

pnl_A(2).pack('v',2);
ampax = pnl_A(2,1).select();
set(ampax,'tag',[DRUGS{2} '_a_3'],'tickdir','out','xcolor',[1 1 1],'xtick',[])%,'ycolor',[1 1 1],'ytick',[]);
ampax = pnl_A(2,2).select();
set(ampax,'tag',[DRUGS{3} '_a_3'],'tickdir','out','xcolor',[1 1 1],'xtick',[])%,'ycolor',[1 1 1],'ytick',[]);

%% Subtract currents and plot

warning('off')
geno_idx = [3 1 2];
for type_idx = 2:length(geno_idx)
    DRUGS = {'AchI','TTX','4AP_TEA'};
    
    g_idx = find(genotype_idx==geno_idx(type_idx));

    clrs = distinguishable_colors(length(g_idx),{'w','k',[1 1 0],[1 1 1]*.8});
    clrs(:) = .8;
    for ac_idx = 1:length(g_idx)
        current_amp_vs_freq = zeros(4,2);
        freq = zeros(4);

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
                yhigh = zeros(N,length(diff(ascd)));
                %y_inwin = g_diff(:,c);
                y_inwin = current_(:,c);
                for dN = 1:length(diff(ascd))
                    yhigh(:,dN) = y_inwin(ascd(dN):ascd(dN)+N-1);
                end
                current_cycles(:,c) = mean(yhigh,2);
                current_amp_vs_freq(r,c-1) = max(current_cycles(:,c)-min(current_cycles(:,c)));
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
            set([drugax baseax],'ylim',[-50 80])
        end
        drugax = findobj('type','axes','tag',['remainder_c_' num2str(type_idx)]);
        line([0 x_(end)],[0 0],'parent',drugax,'color',[.8 .8 .8],'DisplayName',ac.name);
        baseax = findobj('type','axes','tag',['remainder_b_' num2str(type_idx)]);
        line(0,mean(baselinecurrent_(:,end)),'parent',baseax,'linestyle','none','marker','o','markeredgecolor',[0 0 0],'markerfacecolor','none');
        set([drugax baseax],'ylim',[-70 100])
        
        for c = 2:length(drugs_)            
            ampaxdrug = findobj('type','axes','tag',[drugs_{c} '_a_' num2str(type_idx)]);
            line(trial.params.freqs,current_amp_vs_freq(:,c-1),'parent',ampaxdrug,'color',clr,'tag',num2str(ac_idx),'DisplayName',ac.name);
            drawnow
        end

    end
end

% savePDFandFIG(figure7_Sbtrct,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8_Sinusoidal_voltage_commands\draft_material',[],['VoltageSineConductances_' sprintf('%.0f',ENa)]);
%% Clean up and look at frequency dependence of K current
B1highKNormax = findobj('type','axes','tag','TTX_a_2'); cla(B1highKNormax)
B1mlKNormax = findobj('type','axes','tag','TTX_a_3'); cla(B1mlKNormax)

B1highKax = findobj('type','axes','tag','4AP_TEA_a_2');
set(B1highKax,'box','off','tickdir','out','xcolor',[0 0 0],'xtick',[25 100 141 200])%,'ycolor',[1 1 1],'ytick',[]);
xlabel(B1highKax,'f (Hz)');
ylabel(B1highKax,'Amp');

l = findobj(B1highKax,'type','line');
yhigh = get(l(1),'YData');
yhigh = repmat(yhigh,length(l),1);
xhigh = get(l(1),'YData');
xhigh = repmat(xhigh,length(l),1);
for l_ = 1:length(l)
    z = copyobj(l(l_),B1highKNormax);
    z.YData = z.YData/mean(z.YData);
    yhigh(l_,:) = z.YData;
    xhigh(l_,:) = z.XData;
end

a = xhigh(:,2:end);
a = a(:);

b = yhigh(:,2:end);
b = b(:);

[R,P]=corrcoef(a,b)
line(xhigh(1,2:end),[1 1 1],'parent',B1highKNormax,'color',[1 0 0]);
text(xhigh(1,end),1,['R=' num2str(R(1,2)) '; P=' num2str(P(1,2))],'parent',B1highKNormax,'HorizontalAlignment','right','VerticalAlignment','bottom');

set(B1highKNormax,'box','off','tickdir','out','xcolor',[0 0 0],'xtick',[25 100 141 200])%,'ycolor',[1 1 1],'ytick',[]);
xlabel(B1highKNormax,'f (Hz)');
ylabel(B1highKNormax,'Amp/mean(Amp)');
title(B1highKNormax,'B1-high');

% - B1 mid low
B1midlowKax = findobj('type','axes','tag','4AP_TEA_a_3');
set(B1midlowKax,'box','off','tickdir','out','xcolor',[0 0 0],'xtick',[25 100 141 200])%,'ycolor',[1 1 1],'ytick',[]);
xlabel(B1midlowKax,'f (Hz)');
ylabel(B1midlowKax,'Amp');

l = findobj(B1midlowKax,'type','line');
yml = get(l(1),'YData');
yml = repmat(yml,length(l),1);
xml = get(l(1),'YData');
xml = repmat(xml,length(l),1);
for l_ = 1:length(l)
    z = copyobj(l(l_),B1mlKNormax);
    z.YData = z.YData/mean(z.YData);
    yml(l_,:) = z.YData;
    xml(l_,:) = z.XData;
end

a = xml(:,2:end);
a = a(:);

b = yml(:,2:end);
b = b(:);

[R,P]=corrcoef(a,b)
line(xhigh(1,2:end),[1 1 1],'parent',B1mlKNormax,'color',[1 0 0]);
text(xhigh(1,end),1,['R=' num2str(R(1,2)) '; P=' num2str(P(1,2))],'parent',B1mlKNormax,'HorizontalAlignment','right','VerticalAlignment','bottom');

set(B1mlKNormax,'tickdir','out','xcolor',[0 0 0],'xtick',[25 100 141 200])%,'ycolor',[1 1 1],'ytick',[]);
xlabel(B1mlKNormax,'f (Hz)');
ylabel(B1mlKNormax,'Amp/mean(Amp)');
title(B1mlKNormax,'B1-mid/low');

savePDFandFIG(figure7_Amps,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure8_Sinusoidal_voltage_commands',[],['Figure8_AmplitudeVsFreqCorr']);

