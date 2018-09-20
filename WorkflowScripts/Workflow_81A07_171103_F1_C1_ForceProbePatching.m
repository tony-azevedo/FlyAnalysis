%% ForceProbe patcing workflow 171103_F1_C1
trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_72.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials
% EpiFlash Sets - cause spikes and video movement
% Position 0 EpiFlash2T: 
trials{1} = 72:115;
% Position 100 EpiFlash2T:
trials{2} = 116:139;
% Position 200 EpiFlash2T: 
trials{3} = 140:163;
% Position -100 EpiFlash2T: 
trials{4} = 164:187;
% Position -200 EpiFlash2T:
trials{5} =  188:211;
% Position 0 EpiFlash2T more spikes: 
trials{6} = 212:223;
Nsets = length(trials);

dists = [200 100 0 -100 -200 0];

Nsets = length(trials);

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
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

%% Extract spikes

%% force production vs start position
t_i_f = [-0.02 .13];

trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_75.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
setordridx = [1 2 3 4, 5];

script_singleSpikeTwitchAtEachDistance


%% Look at how force increases with spike (from 0 set point)

close all
N_trjct_fi = figure;
N_trjct_fi.Color = [0 0 0];
N_trjct_fi.Units = 'inches';
N_trjct_fi.Position = [4 2 8 6];

panl = panel(N_trjct_fi);
panl.pack('v',{1/2 1/2})  % phase plot on top

panl.margin = [18 16 10 10];
panl.descendants.margin = [10 10 10 10];

t_i_f = [-0.006 .13];


N_sp = 1:13;

clrs = parula(round(length(N_sp)*1.2));
clrs = clrs(end-length(N_sp)+1:end,:);

tr_ph_ax = panl(1).select();

tr_ph_ax.Color = [0 0 0];
tr_ph_ax.XColor = [1 1 1];
tr_ph_ax.YColor = [1 1 1];
tr_ph_ax.TickDir = 'out';
tr_ph_ax.XLim = [-10 140];
tr_ph_ax.YLim = 1E3*[-5 7]; 
hold(tr_ph_ax,'on')

tr_ax = panl(2).select();
tr_ax.Color = [0 0 0];
tr_ax.XColor = [1 1 1];
tr_ax.YColor = [1 1 1];
tr_ax.TickDir = 'out';
tr_ax.XLim = t_i_f;
tr_ax.YLim = [-10 140]; 
hold(tr_ax,'on')

trialnumlist = [trials{1} trials{end}];
n_sp = zeros(size(trialnumlist));
fr_12 = zeros(size(trialnumlist));

cnt = 0;
for tr = trialnumlist
    trial = load(sprintf(trialStem,tr));
    cnt = cnt+1;
    if trial.excluded
        continue;
    end
    n_sp(cnt) = length(trial.spikes);
    if n_sp(cnt)>1
        fr_12(cnt) = 1/diff(trial.spikes(1:2));
    end
end

for n = 1:length(N_sp)
    N = N_sp(n);
    trialnumlist_ = trialnumlist(n_sp==N);
    
    tr_ph_ax = panl(1).select();
    
    plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
    plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);
    
    tr_ax = panl(2).select();

    for tr = trialnumlist_
        trial = load(sprintf(trialStem,tr));
        if trial.excluded
            continue;
        end

        if length(trial.spikes) ~= N
            continue
        end
        
        t = makeInTime(trial.params);        
        trial2 = postHocExposure(trial);
        
        frame_times = t(trial2.exposure);
        ft = frame_times;
        
        t_sp = t(trial.spikes(1));
        sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
        frame_win = frame_times>=t_sp+t_i_f(1) & frame_times <=t_sp+t_i_f(2);
        
        origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
        x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
        CoM = trial.forceProbeStuff.forceProbePosition';
        CoM = CoM*x_hat;
        origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
        CoM = CoM - origin;
        
        dCoMdt = diff(CoM)./diff(frame_times);
        CoM_s = CoM(2:end);
        ft_ph = ft(2:end);
        
        trjct_t = t_i_f+t_sp;
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
                
        brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',clrs(n,:),'tag',num2str(tr));
        
        trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
        phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:),'tag',num2str(tr));
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
        
    end
end
% savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% savePDF(N_trjct_fi,savedir,[],sprintf('trajec_perN_%s_%d-%d',ID,trialnumlist(1),trialnumlist(end)))

%% Look at rebound after perturbation

close all
N_trjct_fi = figure;
N_trjct_fi.Color = [0 0 0];
N_trjct_fi.Units = 'inches';
N_trjct_fi.Position = [4 2 8 6];

panl = panel(N_trjct_fi);
panl.pack('v',{1/3 2/3})  % phase plot on top

panl.margin = [18 16 10 10];
panl.descendants.margin = [10 10 10 10];

t_i_f = [-0.1 .27];



clrs = parula(round(length(N_sp)*1.2));
clrs = clrs(end-length(N_sp)+1:end,:);

tr_ph_ax = panl(1).select();

tr_ph_ax.Color = [0 0 0];
tr_ph_ax.XColor = [1 1 1];
tr_ph_ax.YColor = [1 1 1];
tr_ph_ax.TickDir = 'out';
tr_ph_ax.XLim = t_i_f;
tr_ph_ax.YLim =[-500 40]; 
hold(tr_ph_ax,'on')

tr_ax = panl(2).select();
tr_ax.Color = [0 0 0];
tr_ax.XColor = [1 1 1];
tr_ax.YColor = [1 1 1];
tr_ax.TickDir = 'out';
tr_ax.XLim = t_i_f;
tr_ax.YLim = [-10 40]; 
hold(tr_ax,'on')

trialnumlist = [trials{1} trials{end}];

N = 1;
tr_ax = panl(2).select();

for tr = trialnumlist
    trial = load(sprintf(trialStem,tr));
    if trial.excluded
        continue;
    end
    
    if length(trial.spikes) ~= N
        continue
    end
    
    t = makeInTime(trial.params);
    trial2 = postHocExposure(trial);
    
    frame_times = t(trial2.exposure);
    ft = frame_times;
    
    t_sp = t(trial.spikes(1));
    sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
    frame_win = frame_times>=t_sp+t_i_f(1) & frame_times <=t_sp+t_i_f(2);
    
    origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
    x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
    CoM = trial.forceProbeStuff.forceProbePosition';
    CoM = CoM*x_hat;
    origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
    CoM = CoM - origin;
    
    dCoMdt = diff(CoM)./diff(frame_times);
    CoM_s = CoM(2:end);
    ft_ph = ft(2:end);
    
    trjct_t = t_i_f+t_sp;
    trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
    trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
    
    brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',[0 .4 .74],'tag',num2str(tr));
    
%     trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
    %phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:),'tag',num2str(tr));
    
    %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
    %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
    %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
    
    
end
% savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% savePDF(N_trjct_fi,savedir,[],sprintf('trajec_perN_%s_%d-%d',ID,trialnumlist(1),trialnumlist(end)))
lines = findobj(tr_ax,'type','line');
xdata = []; ydata = [];
for l = lines
    xdata = cat(2,xdata,lines.XData);
    ydata = cat(2,ydata,lines.YData);
end
[xdata_o,order] = sort(xdata);

ydata_o = smooth(ydata(order),30);
brtrjct = plot(tr_ax, xdata_o,ydata_o,'color',[0.9763    0.9831    0.0538],'tag','smoothed','linewidth',2);

trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_75.mat');
tr_ph_ax = panl(1).select();
brtrjct = plot(tr_ph_ax, t-t(trial.spikes(1)),trial.current_2,'color',[1 0 0],'tag','smoothed','linewidth',1);


%% Also used the LED to drive spikes in the leg
trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_265.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials
% EpiFlash2T
trials{1} = 252:279;
Nsets = length(trials);

% Set probe line 
trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_265.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

close all
% Go through all the sets of trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
    br.Position =  [1050    251    270    56];
    
    % set probeline for a few test movies
    for tr_idx = trialnumlist(1:4) 
        h = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(h.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        fprintf('%s\n',h.name);
        if isfield(h,'excluded') && h.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        trial = probeLineROI(h);
    end
    
    % just set the line for the rest of the trials
    temp.forceProbe_line = getpref('quickshowPrefs','forceProbeLine');
    temp.forceProbe_tangent = getpref('quickshowPrefs','forceProbeTangent');

    for tr_idx = trialnumlist(5:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.forceProbe_line = temp.forceProbe_line;
        trial.forceProbe_tangent = temp.forceProbe_tangent;
        fprintf('Saving bar and tangent in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
    
    delete(br);
end

% double check some trials
% trial = load(sprintf(trialStem,15));
% showProbeLocation(trial)

% trial = probeLineROI(trial);

%% Detect the bar for all the trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};

    batch_probeTrackROI
end

%% Also used the LED to excite the fly and get it to move on it's own
trial = load('B:\Raw_Data\171103\171103_F1_C1\Sweep2T_Raw_171103_F1_C1_20.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials
% Sweep with LED on the eye ball 
trials{1} = 6:35;
Nsets = length(trials);

% Set probe line 
trial = load('B:\Raw_Data\171103\171103_F1_C1\Sweep2T_Raw_171103_F1_C1_20.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

close all
% Go through all the sets of trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
    br.Position =  [1050    251    270    56];
    
    % set probeline for a few test movies
    for tr_idx = trialnumlist(1:4) 
        h = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(h.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        fprintf('%s\n',h.name);
        if isfield(h,'excluded') && h.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        trial = probeLineROI(h);
    end
    
    % just set the line for the rest of the trials
    temp.forceProbe_line = getpref('quickshowPrefs','forceProbeLine');
    temp.forceProbe_tangent = getpref('quickshowPrefs','forceProbeTangent');

    for tr_idx = trialnumlist(5:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.forceProbe_line = temp.forceProbe_line;
        trial.forceProbe_tangent = temp.forceProbe_tangent;
        fprintf('Saving bar and tangent in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
    
    delete(br);
end

% double check some trials
% trial = load(sprintf(trialStem,15));
% showProbeLocation(trial)

% trial = probeLineROI(trial);

% Detect the bar for all the trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};

    batch_probeTrackROI
end
