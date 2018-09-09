%
% There is usually a current injection at the beginning of the Epiflash
% trials. Use this to measure input resistance.

close all
N_spikes_fi = figure('color',[1 1 1],'units','inches','position',[4 2 8 6]);

panl = panel(N_spikes_fi);
panl.pack('h',{1/2 1/2})  % phase plot on top
panl(1).pack('v',{1/2 1/2})  % phase plot at left
panl(2).pack('v',{1/2 1/2})  % two examples
panl(1,1).pack('v',{1/2 1/2})  % spikes, emg, bar 1
panl(1,2).pack('v',{1/2 1/2})  % spikes, emg, bar 2

panl.margin = [18 16 10 10];
panl.descendants.margin = [8 8 8 8];

t_i_f = [-0.006 0.02];
t_i_f = [-0.02 .13];

n_sp = zeros(size(trialnumlist));
fr_12 = zeros(size(trialnumlist));

N_sp = [1 2];
clrs = [0 0 0; 0.0582    0.4677    0.8589; 0.9638    0.8659    0.1343];

n_bar_ax = panl(2,1).select();
n_bar_ax.TickDir = 'out';
n_bar_ax.XLim = t_i_f;
%     n_emg_ax.YLim = [-15 8];
n_bar_ax.XTick = [];
hold(n_bar_ax,'on')

% tr_ph_ax = panl(2,2).select();
% set(tr_ph_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',[-10 100],'ylim',1E3*[-5 7]); hold(tr_ph_ax,'on')
% plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
% plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);

for n = 2:-1:1
    N = N_sp(n);
    n_sp_ax = panl(1,n,1).select();
    n_emg_ax = panl(1,n,2).select();
    
    n_sp_ax.TickDir = 'out';
    n_sp_ax.XLim = t_i_f;
%     n_emg_ax.YLim = [-15 8];
    n_sp_ax.XTick = [];
    hold(n_sp_ax,'on')

    n_emg_ax.TickDir = 'out';
    n_emg_ax.XLim = t_i_f;
    n_emg_ax.YLim = [-120 40];
    n_emg_ax.XTick = [];
    hold(n_emg_ax,'on')
  
    
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
                
        frame_times = makeFrameTime(trial);
        ft = frame_times;
        
        sp_win = t>=t(trial.spikes(1))+t_i_f(1) & t<t(trial.spikes(1))+t_i_f(2);
        frame_win = frame_times>=t(trial.spikes(1))+t_i_f(1) & frame_times <= t(trial.spikes(1))+t_i_f(2);
        
        CoM = trial.forceProbeStuff.CoM;
        origin = min(CoM(ft>ft(3)&ft<0));
        CoM = CoM - origin;
        
%         dCoMdt = diff(CoM)./diff(frame_times);
%         CoM_s = CoM(2:end);
%         ft_ph = ft(2:end);        
        
        trjct_t = t_i_f+t(trial.spikes(1));
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
        
        spike_i_idx = trial.spikes(1)-4;
        sptrjct = plot(n_sp_ax, t(trjct_twin)-t(trial.spikes(1)),trial.voltage_1(trjct_twin)-trial.voltage_1(spike_i_idx),'color',clrs(n,:),'tag',num2str(tr));
        emgtrjct = plot(n_emg_ax, t(trjct_twin)-t(trial.spikes(1)),trial.current_2(trjct_twin),'color',[.8 0 0],'tag',num2str(tr));
        
        % get rid of artifact, if necessary
        trjct_win = ft>=trjct_t(1) & ft<=trjct_t(2) & ft>ft(find(ft>trial.params.stimDurInSec,1)+1);
        brtrjct = plot(n_bar_ax, ft(trjct_win)-t(trial.spikes(1)),CoM(trjct_win),'color',clrs(n,:));
        
%         trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
%         phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:));
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
        
    end
end
n_emg_ax.XTick = [0 .05 .1];
n_bar_ax.XTick = [0 .05 .1];
% savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% savePDF(N_spikes_fi,savedir,[],sprintf('select_spikes_trajec_short_%s_%d-%d',ID,trialnumlist(1),trialnumlist(2)))



