close all
N_trjct_fi = figure;
set(N_trjct_fi,'color',[0 0 0],'units','inches','position',[4 2 8 6]);

panl = panel(N_trjct_fi);
panl.pack('v',{1/2 1/2})  % phase plot on top

panl.margin = [18 16 10 10];
panl.descendants.margin = [10 10 10 10];

t_i_f = [-0.006 .13];


N_sp = 1:13;

clrs = parula(round(length(N_sp)*1.2));
clrs = clrs(end-length(N_sp)+1:end,:);


for n = 1:length(N_sp)
    N = N_sp(n);
    trialnumlist_ = trialnumlist(n_sp==N);
    
    tr_ph_ax = panl(1).select();
    
    set(tr_ph_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-10 140],'ylim',1E3*[-5 7]); hold(tr_ph_ax,'on')

    plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
    plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);
    
    tr_ax = panl(2).select();
    set(tr_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',t_i_f,'ylim',[-10 140]); hold(tr_ax,'on')

    for tr = trialnumlist_
        trial = load(sprintf(trialStem,tr));
        if trial.excluded
            continue;
        end

        if length(trial.spikes) ~= N
            continue
        end
        if n==2
            fr_12(tr-trialnumlist(1)+1) = 1/diff(trial.spikes(1:2));
        end
        
        t = makeInTime(trial.params);
        [~,sp_idx] = intersect(t,trial.spikes);
        
        trial2 = postHocExposure(trial);
        
        frame_times = t(trial2.exposure);
        ft = frame_times;
        
        sp_win = t>=trial.spikes(1)+t_i_f(1) & t<trial.spikes(1)+t_i_f(2);
        frame_win = frame_times>=trial.spikes(1)+t_i_f(1) & frame_times <= trial.spikes(1)+t_i_f(2);
        
        origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
        x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
        CoM = trial.forceProbeStuff.forceProbePosition';
        CoM = CoM*x_hat;
        origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
        CoM = CoM - origin;
        
        dCoMdt = diff(CoM)./diff(frame_times);
        CoM_s = CoM(2:end);
        ft_ph = ft(2:end);
        
        
        trjct_t = t_i_f+trial.spikes(1);
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
                
        brtrjct = plot(tr_ax, ft(trjct_win)-trial.spikes(1),CoM(trjct_win),'color',clrs(n,:),'tag',num2str(tr));
        
        trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
        phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:),'tag',num2str(tr));
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
        
    end
end
savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
savePDF(N_trjct_fi,savedir,[],sprintf('trajec_perN_%s_%d-%d',ID,trialnumlist(1),trialnumlist(end)))



