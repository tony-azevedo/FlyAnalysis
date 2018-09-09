%% ForceProbe patcing workflow 180807_F1_C1
trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_26.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash Twitch movements

trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_26.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear trials 
trials{1} = 25:204; % Low
trials{2} = 205:258; % High 

examplespiketrials{1} = [168 199 150];
examplespiketrials{2} = [];

Nsets = length(trials);
    
trial = load(sprintf(trialStem,43));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% Sweep, random movments % Not that informative

trial = load('B:\Raw_Data\180807\180807_F1_C1\Sweep2T_Raw_180807_F1_C1_10.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear trials 
% Trials 1:5 show twitches in the muscle 
trials{1} = 6:10; % Low

Nsets = length(trials);
    
routine = {
    'probeTrackROI_IR' 
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

% Compare some trials: Inserted the red cube here
trial = load(sprintf(trialStem,31));
showProbeImage(trial)
trial = load(sprintf(trialStem,60));
showProbeImage(trial)

trialnumlist_specific = trials{1};
ZeroForce = 700;
Script_SetTheMinimumCoM_byHand

trial = load(sprintf(trialStem,225));
showProbeImage(trial)
trial = load(sprintf(trialStem,226));
showProbeImage(trial)

trialnumlist_specific = 205:225;
ZeroForce = 700;
Script_SetTheMinimumCoM_byHand

setpoint = mean(trial.forceProbeStuff.CoM(ft_idx' & trial.forceProbeStuff.CoM<quantile(trial.forceProbeStuff.CoM(:),0.05)))

% moved the red cube in. This shifts 0
trialnumlist_specific = 226:258;
ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand


% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% force production vs start position
t_i_f = [-0.02 .13];
trial = load('B:\Raw_Data\180308\180308_F3_C1\EpiFlash2T_Raw_180308_F3_C1_5.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);

setordridx = [1 2 3 4 5 6 7];

script_singleSpikeTwitchAtEachDistance

%% Look at how force increases with spike (from 0 set point)

Script_PlotTwitchesColoredBySpikeNumber

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


