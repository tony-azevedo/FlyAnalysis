%% ForceProbe patcing workflow 180111_F2_C1
trial = load('B:\Raw_Data\180111\180111_F2_C1\CurrentStep2T_Raw_180111_F2_C1_2.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step to get force
trial = load('B:\Raw_Data\180111\180111_F2_C1\CurrentStep2T_Raw_180111_F2_C1_2.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 4:22;
trials{2} = 23:42;
trials{3} = 43:54;
Nsets = length(trials);

% check the location
trial = load(sprintf(trialStem,35));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR'
    'probeTrackROI_IR'
    };

%% epi flash random movements

trial = load('B:\Raw_Data\180111\180111_F2_C1\EpiFlash2T_Raw_180111_F2_C1_8.mat');
[~,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 1:9;
% trials{2} = 10:19; % these trials have no probe. Nice images though!
% running this now
Nsets = length(trials);
    
trial = load(sprintf(trialStem,3));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    };

%% Run scripts one at a time

% Set probe line 
Script_SetProbeLine 

% double check some trials
trial = load(sprintf(trialStem,66));
showProbeLocation(trial)

% trial = probeLineROI(trial);

% Find an area to smooth out the pixels
Script_FindAreaToSmoothOutPixels

% Track the bar
Script_TrackTheBarAcrossTrialsInSet

% Find the trials with Red LED transients and mark them down
% Script_FindTheTrialsWithRedLEDTransients % Using UV Led

% Fix the trials with Red LED transients and mark them down
% Script_FixTheTrialsWithRedLEDTransients % Using UV Led

% Find the minimum CoM, plot a few examples from each trial block and check.
% Script_FindTheMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated
Script_LookAtTrialsWithMinimumCoM %% can run this any time, but probably best after all the probe positions have been calculated

trialnumlist_specific = 226:258;
ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand


% Extract spikes
Script_ExtractSpikesFromInterestingTrials


%% skootch the exposures
for set = 1:Nsets
    knownSkootch = 1;
    trialnumlist = trials{set};
    % batch_undoSkootchExposure
    batch_skootchExposure_KnownSkootch
end

%% Epi flash trials

%% Extract spikes

%% force production vs start position
t_i_f = [-0.02 .13];

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

trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_75.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);

clrs = parula(Nsets+1);
clrs = clrs(2:end,:);
setordridx = [3, 2, 1, 4, 5];
for set = 1:length(trials)-1
    trialnumlist = trials{setordridx(set)};
    clr = clrs(set,:);
    N = 1;
    
    t_i_f = [-0.02 .13];
        
    for tr = trialnumlist
        trial = load(sprintf(trialStem,tr));
        if isfield(trial,'excluded') && trial.excluded
            continue;
        end
        
        if length(trial.spikes) ~= N
            continue
        end
        
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
        origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
        CoM = CoM - origin;
        CoM(isnan(CoM)) = 0;
        
        dCoMdt = diff(CoM)./diff(frame_times);
        CoM_s = CoM(2:end);
        ft_ph = ft(2:end);
             
        trjct_t = t_i_f+t_sp;
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
        
        brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',clr,'tag',num2str(tr));
        
        trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
        phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clr,'tag',num2str(tr));
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
    end
end

%% Look at how force increases with spike (from 0 set point)

% close all
% N_trjct_fi = figure;
% N_trjct_fi.Color = [0 0 0];
% N_trjct_fi.Units = 'inches';
% N_trjct_fi.Position = [4 2 8 6];
% 
% panl = panel(N_trjct_fi);
% panl.pack('v',{1/2 1/2})  % phase plot on top
% 
% panl.margin = [18 16 10 10];
% panl.descendants.margin = [10 10 10 10];
% 
% t_i_f = [-0.006 .13];
% 
% 
% N_sp = 1:13;
% 
% clrs = parula(round(length(N_sp)*1.2));
% clrs = clrs(end-length(N_sp)+1:end,:);
% 
% tr_ph_ax = panl(1).select();
% 
% tr_ph_ax.Color = [0 0 0];
% tr_ph_ax.XColor = [1 1 1];
% tr_ph_ax.YColor = [1 1 1];
% tr_ph_ax.TickDir = 'out';
% tr_ph_ax.XLim = [-10 140];
% tr_ph_ax.YLim = 1E3*[-5 7]; 
% hold(tr_ph_ax,'on')
% 
% tr_ax = panl(2).select();
% tr_ax.Color = [0 0 0];
% tr_ax.XColor = [1 1 1];
% tr_ax.YColor = [1 1 1];
% tr_ax.TickDir = 'out';
% tr_ax.XLim = t_i_f;
% tr_ax.YLim = [-10 140]; 
% hold(tr_ax,'on')
% 
% trialnumlist = [trials{1} trials{end}];
% n_sp = zeros(size(trialnumlist));
% fr_12 = zeros(size(trialnumlist));
% 
% cnt = 0;
% for tr = trialnumlist
%     trial = load(sprintf(trialStem,tr));
%     cnt = cnt+1;
%     if trial.excluded
%         continue;
%     end
%     n_sp(cnt) = length(trial.spikes);
%     if n_sp(cnt)>1
%         fr_12(cnt) = 1/diff(trial.spikes(1:2));
%     end
% end
% 
% for n = 1:length(N_sp)
%     N = N_sp(n);
%     trialnumlist_ = trialnumlist(n_sp==N);
%     
%     tr_ph_ax = panl(1).select();
%     
%     plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
%     plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);
%     
%     tr_ax = panl(2).select();
% 
%     for tr = trialnumlist_
%         trial = load(sprintf(trialStem,tr));
%         if trial.excluded
%             continue;
%         end
% 
%         if length(trial.spikes) ~= N
%             continue
%         end
%         
%         t = makeInTime(trial.params);        
%         trial2 = postHocExposure(trial);
%         
%         frame_times = t(trial2.exposure);
%         ft = frame_times;
%         
%         t_sp = t(trial.spikes(1));
%         sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
%         frame_win = frame_times>=t_sp+t_i_f(1) & frame_times <=t_sp+t_i_f(2);
%         
%         origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
%         x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
%         CoM = trial.forceProbeStuff.forceProbePosition';
%         CoM = CoM*x_hat;
%         origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
%         CoM = CoM - origin;
%         
%         dCoMdt = diff(CoM)./diff(frame_times);
%         CoM_s = CoM(2:end);
%         ft_ph = ft(2:end);
%         
%         trjct_t = t_i_f+t_sp;
%         trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
%         trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
%                 
%         brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',clrs(n,:),'tag',num2str(tr));
%         
%         trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
%         phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:),'tag',num2str(tr));
%         
%         %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%         %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%         %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%         
%         
%     end
% end
% % savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% % savePDF(N_trjct_fi,savedir,[],sprintf('trajec_perN_%s_%d-%d',ID,trialnumlist(1),trialnumlist(end)))

%% Look at rebound after perturbation

% close all
% N_trjct_fi = figure;
% N_trjct_fi.Color = [0 0 0];
% N_trjct_fi.Units = 'inches';
% N_trjct_fi.Position = [4 2 8 6];
% 
% panl = panel(N_trjct_fi);
% panl.pack('v',{1/3 2/3})  % phase plot on top
% 
% panl.margin = [18 16 10 10];
% panl.descendants.margin = [10 10 10 10];
% 
% t_i_f = [-0.1 .27];
% 
% 
% 
% clrs = parula(round(length(N_sp)*1.2));
% clrs = clrs(end-length(N_sp)+1:end,:);
% 
% tr_ph_ax = panl(1).select();
% 
% tr_ph_ax.Color = [0 0 0];
% tr_ph_ax.XColor = [1 1 1];
% tr_ph_ax.YColor = [1 1 1];
% tr_ph_ax.TickDir = 'out';
% tr_ph_ax.XLim = t_i_f;
% tr_ph_ax.YLim =[-500 40]; 
% hold(tr_ph_ax,'on')
% 
% tr_ax = panl(2).select();
% tr_ax.Color = [0 0 0];
% tr_ax.XColor = [1 1 1];
% tr_ax.YColor = [1 1 1];
% tr_ax.TickDir = 'out';
% tr_ax.XLim = t_i_f;
% tr_ax.YLim = [-10 40]; 
% hold(tr_ax,'on')
% 
% trialnumlist = [trials{1} trials{end}];
% 
% N = 1;
% tr_ax = panl(2).select();
% 
% for tr = trialnumlist
%     trial = load(sprintf(trialStem,tr));
%     if trial.excluded
%         continue;
%     end
%     
%     if length(trial.spikes) ~= N
%         continue
%     end
%     
%     t = makeInTime(trial.params);
%     trial2 = postHocExposure(trial);
%     
%     frame_times = t(trial2.exposure);
%     ft = frame_times;
%     
%     t_sp = t(trial.spikes(1));
%     sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
%     frame_win = frame_times>=t_sp+t_i_f(1) & frame_times <=t_sp+t_i_f(2);
%     
%     origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
%     x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
%     CoM = trial.forceProbeStuff.forceProbePosition';
%     CoM = CoM*x_hat;
%     origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
%     CoM = CoM - origin;
%     
%     dCoMdt = diff(CoM)./diff(frame_times);
%     CoM_s = CoM(2:end);
%     ft_ph = ft(2:end);
%     
%     trjct_t = t_i_f+t_sp;
%     trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
%     trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
%     
%     brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',[0 .4 .74],'tag',num2str(tr));
%     
% %     trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
%     %phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:),'tag',num2str(tr));
%     
%     %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%     %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%     %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%     
%     
% end
% % savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% % savePDF(N_trjct_fi,savedir,[],sprintf('trajec_perN_%s_%d-%d',ID,trialnumlist(1),trialnumlist(end)))
% lines = findobj(tr_ax,'type','line');
% xdata = []; ydata = [];
% for l = lines
%     xdata = cat(2,xdata,lines.XData);
%     ydata = cat(2,ydata,lines.YData);
% end
% [xdata_o,order] = sort(xdata);
% 
% ydata_o = smooth(ydata(order),30);
% brtrjct = plot(tr_ax, xdata_o,ydata_o,'color',[0.9763    0.9831    0.0538],'tag','smoothed','linewidth',2);
% 
% trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_75.mat');
% tr_ph_ax = panl(1).select();
% brtrjct = plot(tr_ph_ax, t-t(trial.spikes(1)),trial.current_2,'color',[1 0 0],'tag','smoothed','linewidth',1);
% 


