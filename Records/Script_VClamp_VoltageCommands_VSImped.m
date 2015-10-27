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

