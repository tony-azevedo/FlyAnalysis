
t_i_f = [-0.02 .13];

% N = 1;

for tr = trialnumlist
    trial = load(sprintf(trialStem,tr));
    if isfield(trial,'excluded') && trial.excluded
        continue;
    end
    
    if length(trial.spikes) ~= N
        continue
    end
    
    t = makeInTime(trial.params);
    [~,sp_idx] = intersect(t,trial.spikes);
    
    trial2 = postHocExposure(trial,size(trial.forceProbeStuff.forceProbePosition,2));
    
    frame_times = t(trial2.exposure);
    ft = frame_times;
    
%     t_sp = trial.spikes(1)-0.009; % A HACK! get better at measuring EMG spikes
    t_sp = trial.spikes(1); % A HACK! get better at measuring EMG spikes
    sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
    frame_win = frame_times>=t_sp+t_i_f(1) & frame_times <= t_sp+t_i_f(2);
    
    origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
    x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
    CoM = trial.forceProbeStuff.forceProbePosition';
    CoM = CoM*x_hat;
    origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
    CoM = CoM - origin;
    CoM(isnan(CoM)) = 0;
    
    dCoMdt = diff(CoM)./diff(frame_times);
    CoM_s = CoM(2:end);
    ft_ph = ft(2:end);
    
    
    trjct_t = t_i_f+trial.spikes(1);
    trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
    trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
    
    brtrjct = plot(tr_ax, ft(trjct_win)-trial.spikes(1),CoM(trjct_win),'color',clr,'tag',num2str(tr));
    
    trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
    phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clr,'tag',num2str(tr));
    
    %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
    %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
    %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
    
    
end



