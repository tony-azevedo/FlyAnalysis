%% force production vs start position

trjct1C1Sp_fi = figure;
trjct1C1Sp_fi.Color = [0 0 0];
trjct1C1Sp_fi.Units = 'inches';
trjct1C1Sp_fi.Position = [4 2 8 6];

panl = panel(trjct1C1Sp_fi);
panl.pack('v',{1/2 1/2})  % phase plot on top

panl.margin = [18 16 10 10];
panl.descendants.margin = [10 10 10 10];

tr_ph_ax = panl(1).select();

tr_ph_ax.Color = [0 0 0];
tr_ph_ax.XColor = [1 1 1];
tr_ph_ax.YColor = [1 1 1];
tr_ph_ax.TickDir = 'out';
tr_ph_ax.XLim = [-10 140];
tr_ph_ax.YLim = 1E3*[-5 7]; 
hold(tr_ph_ax,'on')

plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);

tr_ax = panl(2).select();
tr_ax.Color = [0 0 0];
tr_ax.XColor = [1 1 1];
tr_ax.YColor = [1 1 1];
tr_ax.TickDir = 'out';
tr_ax.XLim = t_i_f;
tr_ax.YLim = [-10 60]; 
hold(tr_ax,'on')

clrs_tw = parula(length(unique(dists))+1);
clrs_tw = clrs_tw(2:end,:);

clrs_ar = parula(length(setordridx)+1); 
clrs_ar = clrs_ar(2:end,:);

clear areaampsvsdist 
for set = setordridx
    trialnumlist = trials{set};
    dist = dists(set);
    tw_idx = find(dist==unique(dists));
    clr_tw = clrs_tw(tw_idx,:);
    N = 1;
    
    t_i_f = [-0.02 .13];
    
    areaamps = nan(size(trialnumlist));
    cnt = 0;

    for tr = trialnumlist
        trial = load(sprintf(trialStem,tr));
        if isfield(trial,'excluded') && trial.excluded
            continue;
        end
        
        if length(trial.spikes) ~= N
            continue
        end
        cnt = cnt+1;

        t = makeInTime(trial.params);
        trial2 = postHocExposure(trial,size(trial.forceProbeStuff.forceProbePosition,2));
        
        frame_times = t(trial2.exposure);
        ft = frame_times;
        
        t_sp = t(trial.spikes); 
        sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
        frame_win = frame_times>=t_sp+t_i_f(1) & frame_times <= t_sp+t_i_f(2);
        
        origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
        x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
        CoM = trial.forceProbeStuff.forceProbePosition';
        CoM = CoM*x_hat;
        origin = nanmean(CoM(ft>ft(6)&ft<0));  %handles.trial.forceProbeStuff.Origin'*x_hat;
        CoM = CoM - origin;
        CoM(isnan(CoM)) = 0;
        
        dCoMdt = diff(CoM)./diff(frame_times);
        CoM_s = CoM(2:end);
        ft_ph = ft(2:end);
             
        trjct_t = t_i_f+t_sp;
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);

        area_t = ft(trjct_win)-t_sp;
        comtraject = CoM(trjct_win);
        areaamps(cnt) = trapz(area_t(area_t>0&area_t<0.05)-t_sp,comtraject(area_t>0&area_t<0.05));

        brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',clr_tw,'tag',num2str(tr));
        
%         trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
%         phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clr_tw,'tag',num2str(tr));
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
    end
    areaampsvsdist{set} = areaamps(~isnan(areaamps));
end

area_tw_fi = figure;
area_tw_fi.Color = [0 0 0];
area_tw_fi.Units = 'inches';
area_tw_fi.Position = [4 2 8 6];

panl_tw = panel(area_tw_fi);
panl_tw.pack(1)  % phase plot on top

panl_tw.margin = [18 16 10 10];
panl_tw.descendants.margin = [10 10 10 10];

tw_ar_ax = panl_tw(1).select();

tw_ar_ax.Color = [0 0 0];
tw_ar_ax.XColor = [1 1 1];
tw_ar_ax.YColor = [1 1 1];
tw_ar_ax.TickDir = 'out';
tw_ar_ax.XLim = [-200 200];
tw_ar_ax.YLim = [0 1.5]; 
hold(tw_ar_ax,'on')

for set = setordridx

    clr_ar = clrs_ar(setordridx==set,:);
    plot(tw_ar_ax,dists(set)*ones(size(areaampsvsdist{set})),areaampsvsdist{set},'.','markeredgecolor',clr_ar)
    plot(tw_ar_ax,dists(set),mean(areaampsvsdist{set}),'o','markeredgecolor',clr_ar)        
end

