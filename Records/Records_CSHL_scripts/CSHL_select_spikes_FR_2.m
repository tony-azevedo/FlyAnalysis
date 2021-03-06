close all
N_spikes_fi = figure;
set(N_spikes_fi,'color',[0 0 0],'units','inches','position',[4 2 8 6]);

panl = panel(N_spikes_fi);
panl.pack('h',{1/2 1/2})  % phase plot on top
panl(1).pack('v',{1/2 1/2})  % phase plot at left
panl(2).pack('v',{1/2 1/2})  % two examples
panl(1,1).pack('v',{1/2 1/2})  % spikes, emg, bar 1
panl(1,2).pack('v',{1/2 1/2})  % spikes, emg, bar 2

panl.margin = [18 16 10 10];
panl.descendants.margin = [];

t_i_f = [-0.006 0.09];

fr2_12 = fr_12(fr_12>0);
fr2_12 = sort(unique(fr2_12));
clrs = parula(round(length(fr2_12)*1.2));
clrs = clrs(end-length(fr2_12)+1:end,:);

N_sp = [1 2];
n_bar_ax = panl(2,1).select();
set(n_bar_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',t_i_f,'ylim',[-6 100]); hold(n_bar_ax,'on')

tr_ph_ax = panl(2,2).select();
set(tr_ph_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-10 100],'ylim',1E3*[-5 7]); hold(tr_ph_ax,'on')
plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);

for n = 1:2
    N = N_sp(n);
    n_sp_ax = panl(1,n,1).select();
    n_emg_ax = panl(1,n,2).select();
    
    set(n_sp_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',t_i_f,'ylim',[-15 8],'xtick',[]); hold(n_sp_ax,'on')
    set(n_emg_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',t_i_f,'ylim',[-120 40],'xtick',[]); hold(n_emg_ax,'on')
    
    
    for tr = trialnumlist
        trial = load(sprintf(trialStem,tr));
        if trial.excluded
            continue;
        end
        n_sp(tr-trialnumlist(1)+1) = length(trial.spikes);
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
        
        if n==2
            clr_sp = clrs(fr2_12==1/diff(trial.spikes),:);
            clr_trjct = clrs(fr2_12==1/diff(trial.spikes),:);
            clr_emg = clrs(fr2_12==1/diff(trial.spikes),:);
        else
            clr_sp = [1 1 1];
            clr_trjct = [1 1 1];
            clr_emg = [.8 0 0];
        end

        
        trjct_t = t_i_f+trial.spikes(1);
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
        
        spike_i_idx = find(t==trial.spikes(1),1,'first')-4;
        sptrjct = plot(n_sp_ax, t(trjct_twin)-trial.spikes(1),trial.voltage_1(trjct_twin)-trial.voltage_1(spike_i_idx),'color',clr_sp);
        emgtrjct = plot(n_emg_ax, t(trjct_twin)-trial.spikes(1),trial.current_2(trjct_twin),'color',clr_emg);
        
        brtrjct = plot(n_bar_ax, ft(trjct_win)-trial.spikes(1),CoM(trjct_win),'color',clr_trjct);
        
        trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
        phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clr_trjct);
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
        
    end
end
savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
savePDF(N_spikes_fi,savedir,[],sprintf('select_spikes_trajec_FR_%s_%d-%d',ID,trialnumlist(1),trialnumlist(2)))



