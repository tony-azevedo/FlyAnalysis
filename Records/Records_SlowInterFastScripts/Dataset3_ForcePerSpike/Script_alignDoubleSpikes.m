close all
DEBUG = 0;
comfig = figure('color',[1 1 1],'units','inches','position',[4 2 8 6]);
comax = subplot(1,1,1,'parent',comfig); comax.NextPlot = 'add';
% 
% panl = panel(N_spikes_fi);
% panl.pack('h',{1/2 1/2})  % phase plot on top
% panl(1).pack('v',{1/2 1/2})  % phase plot at left
% panl(2).pack('v',{1/2 1/2})  % two examples
% panl(1,1).pack('v',{1/2 1/2})  % spikes, emg, bar 1
% panl(1,2).pack('v',{1/2 1/2})  % spikes, emg, bar 2
% 
% panl.margin = [18 16 10 10];
% panl.descendants.margin = [8 8 8 8];
% 
% t_i_f = [-0.006 0.02];
% t_i_f = [-0.02 .13];

T_singleSpikes = T_FperSpike_0(T_FperSpike_0.NumSpikes==1 & T_FperSpike_0.Position==0,:);
T_doubleSpikes = T_FperSpike_0(T_FperSpike_0.NumSpikes==2 & T_FperSpike_0.Position==0,:);

% remove the ones with no whole cell recordings
T_singleSpikes = T_singleSpikes(~contains(T_singleSpikes.CellID,{'181219_F1_C1','180222_F1_C1'}),:);
T_doubleSpikes = T_doubleSpikes(~contains(T_doubleSpikes.CellID,{'181219_F1_C1','180222_F1_C1'}),:);
cellIDs = T_doubleSpikes.CellID;

emgpolarity = T_doubleSpikes.Position*0-1;
emgpolarity(contains(cellIDs,'180807_F1_C1')) = 1;
t_halfmax = nan(size(T_doubleSpikes.Position));
conductiondelay = nan(size(T_doubleSpikes.Position));

t_i_f = [-0.02 .25];

for cidx = 1:length(cellIDs)
    
    cellid = cellIDs{cidx};
    T_cell = T_doubleSpikes(contains(T_doubleSpikes.CellID,cellid),:);
    trials = T_cell.Trialnums{1};
    
    trialStem = [T_cell.Protocol{1} '_Raw_' cellid '_%d.mat'];
    trial = load(['E:\Data\' cellid(1:6) '\' cellid '\' sprintf(trialStem,trials(1))]);
    t = makeInTime(trial.params);
    sp_win = t>=t_i_f(1) & t <=t_i_f(2);
    ft = makeFrameTime(trial);
    frame_win = ft>=t_i_f(1) & ft <=t_i_f(2);

    v_ = nan(sum(sp_win), length(trials));
    emg_ = nan(sum(sp_win), length(trials));
    CoM_ = nan(sum(frame_win), length(trials));
    comt_ = CoM_;

    cnt = 0;
    
    if DEBUG
        figure
        ax1 = subplot(2,1,1); ax1.XLim = [-0.005 .03]; ax1.NextPlot = 'add';
        ax2 = subplot(2,1,2); ax2.XLim = [-0.005 .03]; ax2.NextPlot = 'add';
    end
    for tr = trials'
        cnt = cnt+1;
        trial = load(['E:\Data\' cellid(1:6) '\' cellid '\' sprintf(trialStem,tr)]);
        if trial.excluded
            continue;
        end                
        ft = makeFrameTime(trial);
        
        
%         dCoMdt = diff(CoM)./diff(frame_times);
%         CoM_s = CoM(2:end);
%         ft_ph = ft(2:end);        
        
        trjct_t = t_i_f+t(trial.spikes(1));
        
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
        if sum(trjct_twin) > size(v_,1)
            trjct_twin = t>=trjct_t(1)&t<trjct_t(2);
        end
        if sum(trjct_twin) < size(v_,1)
            trjct_twin = t>=trjct_t(1)&t<=trjct_t(2)+0.5*1/trial.params.sampratein;
        end

        spike_i_idx = trial.spikes(1); % -4;
        v_(:,cnt) = trial.voltage_1(trjct_twin)-trial.voltage_1(spike_i_idx);
        emg_(:,cnt) = trial.current_2(trjct_twin)-trial.current_2(spike_i_idx);
        

        com = trial.forceProbeStuff.CoM;
        origin = mean(com(find(ft<t(trial.spikes(1)),4,'last')));
        com = com - origin;

        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct = com(trjct_win);
        trjct_ft = ft(trjct_win) - t(trial.spikes(1));
        if length(trjct) >= size(CoM_,1)
            CoM_(:,cnt) = trjct(1:size(CoM_,1));
            comt_(:,cnt) = trjct_ft(1:size(CoM_,1));
        elseif length(trjct) < size(CoM_,1)
            CoM_(1:length(trjct),cnt) = trjct;
            comt_(1:length(trjct),cnt) = trjct_ft;
        end        
        if DEBUG
            plot(ax1,t(sp_win),v_(:,cnt))
            plot(ax2,comt_(:,cnt),CoM_(:,cnt),'.','tag',num2str(tr))
        end
    end
    v = nanmean(v_,2);
    emg = nanmean(emg_,2);
    
    comt = comt_(:);
    CoM = CoM_(:);
    [comt,o] = sort(comt);
    CoM = CoM(o);
        
    % now the upswing of the twitch has been randomly sampled due to the
    % difference in the timing of the frame relative to the spike, but
    % there are some un-unique spike times, so smoothdata doesn't work
    % COM = smoothdata(CoM,'SamplePoints',comt,'loess');
    % just skootch the times to slightly different points
    [comt_smooth,a] = unique(comt);
    for r = 1:length(comt_smooth)
        if sum(comt==comt_smooth(r))>1
            comtidx = find(comt==comt_smooth(r));
            cnt = 1;
            for r2 = comtidx'
                comt(r2) = comt(r2)+cnt*1E-6;
                cnt = cnt+1;
            end
        end
    end
    if ~strcmp(cellid,'180405_F3_C1')
        max_CoM = mean(max(CoM_,[],1));
    elseif strcmp(cellid,'180405_F3_C1')
         max_CoM = mean(max(CoM_(trjct_ft<0.05,:),[],1));
    else 
        error('No case')
    end
    max_comt = find(CoM>=max_CoM,1,'first');
    if contains(T_singleSpikes.Cell_label{cidx},'fast')
        risingphase = comt > 0 & comt<comt(max_comt) & CoM > .1*max_CoM & CoM <.6*max_CoM;
    elseif contains(T_singleSpikes.Cell_label{cidx},'intermediate')
        risingphase = comt > diff(ft(1:2))*3/4 & comt<comt(max_comt);
    end
    m_risingphase = polyfit(comt(risingphase),CoM(risingphase),1);
    
    % compute half max rise time
    rise_t = t(sp_win);
    riseline = t(sp_win)*m_risingphase(1)+m_risingphase(2);
    rise_l = riseline>max_CoM*0.25 & riseline<max_CoM*0.75;
    if DEBUG
        plot(ax2,rise_t(rise_l),riseline(rise_l),'k')
    end
    t_halfmax(cidx) = rise_t(find(riseline>=max_CoM*0.5,1,'first'));
    
    % compute conduction delay
    if emgpolarity(cidx) == 1
        [~,cndctn_delay] = max(diff(emg));
    elseif emgpolarity(cidx) == -1
        [~,cndctn_delay] = max(diff(-emg));
    end
    cndctn_delay = cndctn_delay+sum(t<t_i_f(1));
    conductiondelay(cidx) = t(cndctn_delay);

    if any(contains({'170921_F1_C1','180807_F1_C1'},cellid))
        figure
        ax1 = subplot(4,1,1); ax1.NextPlot = 'add';
        title(ax1,cellid)
        %plot(ax1,t(sp_win),v_,'color',[1 .7 .7]);
        plot(ax1,t(sp_win),v-nanstd(v_,[],2)/sqrt(size(v_,2)),'color',[.5 .5 .5]);
        plot(ax1,t(sp_win),v+nanstd(v_,[],2)/sqrt(size(v_,2)),'color',[.5 .5 .5]);
        plot(ax1,t(sp_win),v,'color',[0 0 0]);
        
        ax2 = subplot(4,1,2); ax2.NextPlot = 'add';
        %plot(ax2,t(sp_win),emg_,'color',[1 .7 .7]);
%         plot(ax2,t(sp_win),emg-nanstd(emg_,[],2)/sqrt(size(emg_,2)),'color',[.9 .9 .9]);
%         plot(ax2,t(sp_win),emg+nanstd(emg_,[],2)/sqrt(size(emg_,2)),'color',[.9 .9 .9]);
        plot(ax2,t(sp_win),emg_,'color',[.5 .5 .5]);
        plot(ax2,[0 conductiondelay(cidx)],emg(t(sp_win)==conductiondelay(cidx))*[1 1],'color',[0 0 0]);
        
        ax3 = subplot(4,1,3:4); ax3.NextPlot = 'add';
        plot(ax3,comt_,CoM_,'color',[.8 .8 1],'linestyle','-');
        plot(ax3,comt,CoM,'color',[0 0 .7],'marker','.','markersize',2,'linestyle','none');
        plot(ax3,rise_t(rise_l),riseline(rise_l),'color',[0 0 .2]);
        plot(ax3,[0 t_halfmax(cidx)],max_CoM*0.5*[1 1],'color',[0 0 0]);
        
        linkaxes([ax1,ax2,ax3],'x')
        ax3.XLim = [-.02 .12];
        
        if contains({'170921_F1_C1'},cellid)
            ax3.YLim = [-20 90];
        elseif contains({'180807_F1_C1'},cellid)
            ax3.YLim = [-5 20];
        end

        
        %export_fig(gcf,[figureoutputfolder '\ForcePerspike2_' cellid '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
    end
    plot(comax,comt,CoM,'marker','.','markersize',2,'linestyle','none','tag',cellid);
    
end

twitchlines = findobj(comax,'type','line');

T_singleSpikes = addvars(T_singleSpikes,t_halfmax,conductiondelay);

%%
figure
ax = subplot(1,1,1); ax.NextPlot = 'add';
fastidx = contains(T_singleSpikes.Cell_label,'fast');
x = [zeros(sum(fastidx),1),zeros(sum(fastidx),1)+.2];
plot(ax,x'+1,[T_singleSpikes.EMG_delay(fastidx) T_singleSpikes.conductiondelay(fastidx)]','marker','o')

interidx = contains(T_singleSpikes.Cell_label,'intermediate');
x = [zeros(sum(interidx),1),zeros(sum(interidx),1)+.2] + [0 .02;0 0;0 0];
plot(ax,x'+2,[T_singleSpikes.EMG_delay(interidx) T_singleSpikes.conductiondelay(interidx)]','marker','o')

ax.XLim = [.5 2.5];

%%
figure
ax = subplot(1,1,1); ax.NextPlot = 'add';
fastidx = contains(T_singleSpikes.Cell_label,'fast');
x = zeros(sum(fastidx),1);
plot(x+1,T_singleSpikes.t_halfmax(fastidx),'marker','.','linestyle','none')

interidx = contains(T_singleSpikes.Cell_label,'intermediate');
x = zeros(sum(interidx),1);
plot(x+2,T_singleSpikes.t_halfmax(interidx),'marker','.','linestyle','none')

ax.XLim = [.5 2.5];

