%% Look at how force increases with spike (from 0 set point)

close all
N_trjct_fi = figure;
N_trjct_fi.Color = [1 1 1];
N_trjct_fi.Units = 'inches';
N_trjct_fi.Position = [4 2 8 6];

panl = panel(N_trjct_fi);
panl.pack('v',{1})  % phase plot on top

panl.margin = [18 16 10 10];
panl.descendants.margin = [10 10 10 10];

t_i_f = [-0.006 .2];

tr_ax = panl(1).select();
% tr_ax.Color = [0 0 0];
% tr_ax.XColor = [1 1 1];
% tr_ax.YColor = [1 1 1];
tr_ax.TickDir = 'out';
tr_ax.XLim = t_i_f;
tr_ax.YLim = [-10 40]; 
hold(tr_ax,'on')

trialnumlist = [trials{1} trials{2}];
n_sp = zeros(size(trialnumlist));
fr_12 = zeros(size(trialnumlist));

cnt = 0;
t = makeInTime(trial.params);
for tr = trialnumlist
    trial = load(sprintf(trialStem,tr));
    cnt = cnt+1;
    if trial.excluded
        continue;
    end
    idx_gt_0 = find(t(trial.spikes)>0);
    n_sp(cnt) = sum(t(trial.spikes)>0);
    if n_sp(cnt)>1
        fr_12(cnt) = 1/diff(t(trial.spikes(idx_gt_0(1:2))));
    end
end

N_sp = unique(n_sp);
N_sp = N_sp(N_sp~=0);

clrs = parula(length(N_sp-1));
clrs = cat(1,[1 0 0],clrs);
for n = length(N_sp):-1:1
    N = N_sp(n);
    trialnumlist_ = trialnumlist(n_sp==N);
            
    tr_ax = panl(1).select();

    for tr = trialnumlist_
        trial = load(sprintf(trialStem,tr));
        if trial.excluded
            continue;
        end

        if length(trial.spikes) ~= N
            continue
        end
        
        t = makeInTime(trial.params);        
        ft = makeFrameTime(trial);
        
        t_sp = t(trial.spikes(find(t(trial.spikes)>0,1)));
        sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
        frame_win = ft>=t_sp+t_i_f(1) & ft <=t_sp+t_i_f(2);

        ft_idx = ft<0|ft>ft(find(ft>trial.params.stimDurInSec,1));
        
        CoM = trial.forceProbeStuff.CoM;
        origin = min(CoM(ft>ft(3)&ft<0));
        CoM = CoM - origin;
                
        trjct_t = t_i_f+t_sp;
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2) & ft_idx;
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
                
        brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',clrs(n,:),'tag',num2str(tr));
        
        %         trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
        %         phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:),'tag',num2str(tr));
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
        
    end
end
% savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% savePDF(N_trjct_fi,savedir,[],sprintf('trajec_perN_%s_%d-%d',ID,trialnumlist(1),trialnumlist(end)))
