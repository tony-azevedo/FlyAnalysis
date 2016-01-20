%% Voltage Sines

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

trial_seeds = reshape(trial_seeds(~isnan(trial_seeds)),length(trial.params.amps),length(trial.params.freqs),[]);


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
            
            templine = line(x(x>i&x<f),current(x>i&x<f),'color',clr,'displayname',tg,'parent',pnl(f_ind,2).select());
            if t_ind==1
                set(templine,'tag',['current_' num2str(trial.params.freq)]);
            end
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
                line(x(x>i&x<f),current_1(x>i&x<f),'color',clr,'tag',['rem_' num2str(trial.params.freq)],'parent',pnl(f_ind,2+t_ind).select());
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
