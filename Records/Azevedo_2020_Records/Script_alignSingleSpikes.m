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

% remove the the whole cell spiking one
T_singleSpikes = T_singleSpikes(~contains(T_singleSpikes.CellID,{'180222_F1_C1'}),:); % '181219_F1_C1',
T_doubleSpikes = T_doubleSpikes(~contains(T_doubleSpikes.CellID,{'180222_F1_C1'}),:);

% remove the ones with no whole cell recordings for conduction velocity
T_singleSpikes_CV = T_singleSpikes(~contains(T_singleSpikes.CellID,{'181219_F1_C1'}),:); % '181219_F1_C1',
T_doubleSpikes_CV = T_doubleSpikes(~contains(T_doubleSpikes.CellID,{'181219_F1_C1'}),:);

cellIDs = T_singleSpikes.CellID;

emgpolarity = T_singleSpikes.Position*0-1;
emgpolarity(contains(cellIDs,'180807_F1_C1')) = 1;
t_halfmax = nan(size(T_singleSpikes.Position));
speed_1spike = nan(size(T_singleSpikes.Position));
conductiondelay = nan(size(T_singleSpikes.Position));

t_i_f = [-0.02 .25];

for cidx = 1:length(cellIDs)
    
    cellid = cellIDs{cidx};
    if strcmp(cellid,'181219_F1_C1')
        disp('181219_F1_C1')
        %continue
    end
    if strcmp(cellid,'190712_F1_C1')
        disp('190712_F1_C1')
        %continue
    end
    T_cell = T_singleSpikes(contains(T_singleSpikes.CellID,cellid),:);
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
        % for 190712_F1_C1, the spike detection was crap, so using EMG
        % spikes
        if strcmp(cellid,'190712_F1_C1')
            trjct_t = t_i_f+t(trial.EMGspikes(1));
        end
        
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
        if sum(trjct_twin) > size(v_,1)
            trjct_twin = t>=trjct_t(1)&t<trjct_t(2);
        end
        if sum(trjct_twin) < size(v_,1)
            trjct_twin = t>=trjct_t(1)&t<=trjct_t(2)+0.5*1/trial.params.sampratein;
        end

        spike_i_idx = trial.spikes(1); % -4;
        % for 190712_F1_C1, the spike detection was crap, so using EMG
        % spikes
        if strcmp(cellid,'190712_F1_C1')
            spike_i_idx = trial.EMGspikes(1); % -4;
        end

        v_(:,cnt) = trial.voltage_1(trjct_twin)-trial.voltage_1(spike_i_idx);
        emg_(:,cnt) = trial.current_2(trjct_twin)-trial.current_2(spike_i_idx);
        

        com = trial.forceProbeStuff.CoM;
        origin = mean(com(find(ft<t(trial.spikes(1)),4,'last')));
        % for 190712_F1_C1, the spike detection was crap, so using EMG
        % spikes
        if strcmp(cellid,'190712_F1_C1')
            origin = mean(com(find(ft<t(trial.EMGspikes(1)),4,'last')));
        end
        com = com - origin;

        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct = com(trjct_win);
        trjct_ft = ft(trjct_win) - t(trial.spikes(1));
        % for 190712_F1_C1, the spike detection was crap, so using EMG
        % spikes
        if strcmp(cellid,'190712_F1_C1')
            trjct_ft = ft(trjct_win) - t(trial.EMGspikes(1));
        end
        if length(trjct) >= size(CoM_,1)
            CoM_(:,cnt) = trjct(1:size(CoM_,1));
            comt_(:,cnt) = trjct_ft(1:size(CoM_,1));
        elseif length(trjct) < size(CoM_,1)
            CoM_(1:length(trjct),cnt) = trjct;
            comt_(1:length(trjct),cnt) = trjct_ft;
        end        
        if DEBUG
            plot(ax1,t(sp_win),v_(:,cnt))
            plot(ax1,t(sp_win),emg_(:,cnt))
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
    speed_1spike(cidx) = m_risingphase(1);
    
    % compute conduction delay
    if strcmp(cellid,'181219_F1_C1')
        disp('181219_F1_C1')
        %continue
    elseif ~strcmp(cellid,'181219_F1_C1')
        if emgpolarity(cidx) == 1
            [~,cndctn_delay] = max(diff(emg));
        elseif strcmp(cellid,'180308_F3_C1')
            inflpnt = smooth(diff(smooth(diff(smooth(v,10)),10)),10);
            % peak of spike inflcpnt = 1002;
            % EMG appears to occur before, but take the 1037 point
            %             figure
            %             plot(v), hold on
            %             plot(inflpnt*1000);
            %             plot(emg);
            %             plot(diff(-emg));
            
            cndctn_delay = 203+(203-196);
        elseif strcmp(cellid,'190710_F1_C1')
            inflpnt = smooth(diff(smooth(diff(smooth(v,10)),10)),10);
            % peak of spike inflcpnt = 1002;
            % EMG appears to occur before, but take the 1037 point
            
            [~,p] = findpeaks(-(emg-mean(emg(1:200))),'MinPeakDistance',20,'MinPeakProminence',1);
            cndctn_delay = min(p);
            
            cndctn_delay = 1037-2;
        elseif strcmp(cellid,'190712_F1_C1')
            inflpnt = smooth(diff(smooth(diff(smooth(v,10)),10)),10);
            % The peak of the average spike inflection point is 957
            
            [~,cndctn_delay] = max(diff(-emg));
            % The peak of the emg is 1011;
            
            % Is aligned to emg, should be aligned to spike
            % diff between spike and emg is 1011-957 = 54
            cndctn_delay = cndctn_delay+54;
        elseif emgpolarity(cidx) == -1
            [~,cndctn_delay] = max(diff(-emg));
        end
        cndctn_delay = cndctn_delay+sum(t<t_i_f(1));
        conductiondelay(cidx) = t(cndctn_delay);
    end

    % plot interesting ones
    if any(contains({'170921_F1_C1','190712_F1_C1'},cellid)) % 171102_F1_C1
        figure
        ax1 = subplot(4,1,1); ax1.NextPlot = 'add';
        title(ax1,cellid)
        %plot(ax1,t(sp_win),v_,'color',[1 .7 .7]);
        plot(ax1,t(sp_win),v-nanstd(v_,[],2)/sqrt(size(v_,2)),'color',[.5 .5 .5]);
        plot(ax1,t(sp_win),v+nanstd(v_,[],2)/sqrt(size(v_,2)),'color',[.5 .5 .5]);
        plot(ax1,t(sp_win),v,'color',[0 0 0]);
        
        ax2 = subplot(4,1,2); ax2.NextPlot = 'add';
        %plot(ax2,t(sp_win),emg_,'color',[1 .7 .7]);
        plot(ax2,t(sp_win),emg-nanstd(emg_,[],2)/sqrt(size(emg_,2)),'color',[.9 .9 .9]);
        plot(ax2,t(sp_win),emg+nanstd(emg_,[],2)/sqrt(size(emg_,2)),'color',[.9 .9 .9]);
        plot(ax2,t(sp_win),emg,'color',[.5 .5 .5]);
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
            
        
        %export_fig(gcf,[figureoutputfolder '\ForcePerspike1_' cellid '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
    end
    plot(comax,comt,CoM,'marker','.','markersize',2,'linestyle','none','tag',cellid);
    
end

T_singleSpikes = addvars(T_singleSpikes,t_halfmax,speed_1spike,conductiondelay);

% Currently 171102_F1_C1 is weird, inserting a new value
T_singleSpikes.t_halfmax(strcmp(T_singleSpikes.CellID,'171102_F1_C1')) = 0.0077;

%% average all the twitches some how

% twitchlines = flipud(findobj(comax,'type','line'));
% t_tw = t(sp_win);
% twitches = nan(length(t_tw),length(twitchlines));
% searchvect = [1 -1 -2 2 3 -3 -4 4 5 -5 -6 6 7 -7 -8 -9 -10 10];
% for l = 1:length(twitchlines)
%     x = twitchlines(l).XData;
%     y = twitchlines(l).YData;
%     for i = 1:length(x)
%         [~,idx] = min(abs(t_tw-x(i)));
%         if ~isnan(twitches(idx,l))
%             cnt = 1;
%             while (cnt<=length(searchvect) && (idx + searchvect(cnt)<1 || idx + searchvect(cnt) > length(x)))...
%                     || (cnt<=length(searchvect) && ~isnan(twitches(idx+searchvect(cnt),l)))
%                 cnt = cnt+1;
%             end
%             if cnt>length(searchvect)
%                 continue
%             else
%                 twitches(idx+searchvect(cnt),l) = y(i);
%                 searchvect = searchvect*-1;
%             end
%         else 
%             twitches(idx,l) = y(i);
%         end
%     end
% end
% figure
% ax = subplot(1,1,1); ax.NextPlot = 'add';
% % plot(ax,t_tw,twitches,'marker','.','markersize',2,'linestyle','none');
% 
% fastidx = contains(T_singleSpikes.Cell_label,'fast');
% 
% fast_tw = twitches(:,fastidx);
% for c =1:size(fast_tw,2)
%     smoothed_b = fillmissing(fast_tw(t_tw<.002,c),'movmean',round(0.002/diff(t_tw(1:2))));
%     fast_tw(t_tw<=0,c) = smoothed_b(1:sum(t_tw<=0));
%     smoothed_a = fillmissing(fast_tw(t_tw>-.002,c),'movmean',round(0.002/diff(t_tw(1:2))));
%     fast_tw(t_tw>=0,c) = smoothed_a(sum(t_tw<=0&t_tw>=-0.002):end);
% end
% fast_twitch = smooth(nanmean(fast_tw,2),100);
% fast_twitch_err = smooth(nanstd(fast_tw,[],2)/sqrt(sum(fastidx)),100);
% plot(ax,t_tw,fast_twitch,'color',[0 0 0]);
% plot(ax,t_tw,fast_twitch-fast_twitch_err,'color',[.7 .7 .7]);
% plot(ax,t_tw,fast_twitch+fast_twitch_err,'color',[.7 .7 .7]);
% 
% interidx = contains(T_singleSpikes.Cell_label,'intermediate');
% 
% inter_tw = twitches(:,interidx);
% for c =1:size(inter_tw,2)
%     smoothed_b = fillmissing(inter_tw(t_tw<.002,c),'movmean',round(0.002/diff(t_tw(1:2))));
%     inter_tw(t_tw<=0,c) = smoothed_b(1:sum(t_tw<=0));
%     smoothed_a = fillmissing(inter_tw(t_tw>-.002,c),'movmean',round(0.002/diff(t_tw(1:2))));
%     inter_tw(t_tw>=0,c) = smoothed_a(sum(t_tw<=0&t_tw>=-0.002):end);
% end
% inter_twitch = smooth(nanmean(inter_tw,2),100);
% inter_twitch_err = smooth(nanstd(inter_tw,[],2)/sqrt(sum(interidx)),100);
% plot(ax,t_tw,inter_twitch,'color',[1 0 1]);
% plot(ax,t_tw,inter_twitch-inter_twitch_err,'color',[1 .7 1]);
% plot(ax,t_tw,inter_twitch+inter_twitch_err,'color',[1 .7 1]);
% 
% export_fig(gcf,[figureoutputfolder '\MeanTwitches' cellid '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
% 

%% Conduction delay
cdfig = figure; cdfig.Units = 'inches'; cdfig.Position = [5 5 1.5 2.5];
ax = subplot(1,1,1); ax.NextPlot = 'add';
fastidx = contains(T_singleSpikes.Cell_label,'fast');
x = [zeros(sum(fastidx),1),zeros(sum(fastidx),1)+.2];
plot(ax,x'+1,[T_singleSpikes.EMG_delay(fastidx) T_singleSpikes.conductiondelay(fastidx)]','marker','o')

interidx = contains(T_singleSpikes.Cell_label,'intermediate');
x = [zeros(sum(interidx),1),zeros(sum(interidx),1)+.2]; %+ [0 .02;0 0;0 0];
plot(ax,x'+2,[T_singleSpikes.EMG_delay(interidx) T_singleSpikes.conductiondelay(interidx)]','marker','o')

ax.XLim = [.5 2.5];
ylabel(ax,'Conduction delay (s)')

p = ranksum(T_singleSpikes.conductiondelay(interidx),T_singleSpikes.conductiondelay(fastidx))

%% time to force production
fpfig = figure; fpfig.Units = 'inches'; fpfig.Position = [5 5 1.5 2.5];
ax = subplot(1,1,1,'parent',fpfig); ax.NextPlot = 'add';
fastidx = contains(T_singleSpikes.Cell_label,'fast');
x = zeros(sum(fastidx),1);
plot(x+1,T_singleSpikes.t_halfmax(fastidx),'marker','o','linestyle','none')

interidx = contains(T_singleSpikes.Cell_label,'intermediate');
x = zeros(sum(interidx),1);
plot(x+2,T_singleSpikes.t_halfmax(interidx),'marker','o','linestyle','none')
ylabel(ax,'T_{1/2} (s)')
ax.XLim = [.5 2.5];

p = ranksum(T_singleSpikes.t_halfmax(interidx),T_singleSpikes.t_halfmax(fastidx))

%% contraction speed
spfig = figure; spfig.Units = 'inches'; spfig.Position = [7 5 1.5 2.5];
ax = subplot(1,1,1,'parent',spfig); ax.NextPlot = 'add';
fastidx = contains(T_singleSpikes.Cell_label,'fast');
x = zeros(sum(fastidx),1);
plot(x+1,T_singleSpikes.speed_1spike(fastidx),'marker','o','linestyle','none')

interidx = contains(T_singleSpikes.Cell_label,'intermediate');
x = zeros(sum(interidx),1);
plot(x+2,T_singleSpikes.speed_1spike(interidx),'marker','o','linestyle','none')

ax.XLim = [.5 2.5];
% Scale the y-axis nicely
k = 0.2234; %N/m;
forceticks = [90 500 1000 1500 2000]/k;
ylabel(ax,'dF/dt (uN/s)')
% ax.YTick = forceticks;
% ax.YTickLabel = {'90' '500' '1000' '1500' '2000'};

p = ranksum(T_singleSpikes.speed_1spike(interidx),T_singleSpikes.speed_1spike(fastidx))
