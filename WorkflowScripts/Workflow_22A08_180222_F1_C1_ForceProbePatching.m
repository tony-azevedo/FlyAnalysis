%% ForceProbe patcing workflow 180222_F1_C1
trial = load('B:\Raw_Data\180222\180222_F1_C1\CurrentStep2T_Raw_180222_F1_C1_98.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step movements

trial = load('B:\Raw_Data\180222\180222_F1_C1\CurrentStep2T_Raw_180222_F1_C1_98.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 98:126; 
Nsets = length(trials);
    
trial = load(sprintf(trialStem,100));
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

ZeroForce = 700-(setpoint-700);
Script_SetTheMinimumCoM_byHand

% Extract spikes
Script_ExtractSpikesFromInterestingTrials

%% Epi flash trials

%% Extract spikes

% This was agonizing for this cell, very annoying

%% Align spikes and bar trajectories for current injection

trial = load('B:\Raw_Data\180222\180222_F1_C1\CurrentStep2T_Raw_180222_F1_C1_98.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials    
clear spike_trajects alt_trajects ctr_trajects bar_trajects bar_t_trajects bar_ctr_trajects

trialnumlist = 98:126; 

cnt = 0;

for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));
    if ~isfield(trial,'forceProbeStuff') || ~isfield(trial,'spikes') || length(trial.spikes)~=1 || trial.params.step~=200
        continue
    end
    
    cnt = cnt+1;
    spikes = trial.spikes;
tn(cnt) = trial.params.trial;
    t = makeInTime(trial.params);
    spikes = t(spikes);
    
    fs = trial.params.sampratein; %% sample rate
    switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
    switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end
    
    patch = trial.(invec1);
    altin = trial.(invec2);
    bar = trial.forceProbeStuff.CoM;

    ft = postHocExposure(trial);
    sri = trial.params.sampratein;
    ft = ft.exposure;
    frametimes = t(ft);
    frames = find(ft);
    fr = sri/median(diff(frames));
    
    DT = .1;
    DT_pre = 0.02;
    DT_pre = ceil(DT_pre*fr)/fr;
    DT = ceil(DT*fr)/fr; % 20 ms window
    DT_post = DT-DT_pre;
    DF_pre = DT_pre*fr;
    DF_post = DT_post*fr;

    % if there is a single spikes
    for sp_idx = 1
        % find it,
        spidx = find(t==spikes(sp_idx));
        [~,fridx] = min(abs(frametimes-t(spidx)));
        if spidx+DT_post*sri>length(altin)
            break
        end
        if fridx+DF_post>length(bar)
            break
        end
        spike_trajects(:,cnt) = patch(spidx-DT_pre*sri+1:spidx+DT_post*sri);
        alt_trajects(:,cnt) = altin(spidx-DT_pre*sri+1:spidx+DT_post*sri);
        
        randidx = randi([round(trial.params.sampratein*DT) length(altin)-round(trial.params.sampratein*DT)],1);
        ctr_trajects(:,cnt) = altin(randidx-DT_pre*sri+1: randidx+DT_post*sri);
        
        fridx_rnd = randi([round(fr*DT) length(bar)-round(fr*DT)],1);
        
        sp_idx
        bar_trajects(:,cnt) = bar(fridx-DF_pre+1:fridx+DF_post)-bar(fridx);
        bar_t_trajects(:,cnt) = frametimes(fridx-DF_pre+1:fridx+DF_post)-t(spidx);
        bar_ctr_trajects(:,cnt) = bar(fridx_rnd-DF_pre+1:fridx_rnd+DF_post)-bar(fridx_rnd);
    end
    % select out the bar trajectory
    % select out the EMG
    % Align
    % Average
    % plot
end

figure
ax1 = subplot(3,1,1);
t_win = (0-DT_pre*sri+1:0+DT_post*sri)/sri;
plot(ax1,t_win,spike_trajects,'color',[1 .7 .7]); hold on
ylim(ax1,[-50 10])

ax2 = subplot(3,1,2);
plot(ax2,t_win,alt_trajects,'color',[1 .7 .7]); hold on
ylim(ax2,[-50 10])

ax3 = subplot(3,1,3);
plot(ax3,bar_t_trajects,bar_trajects,'color',[1 .7 .7])
ylim(ax3,[-3 8])

xlim([ax1,ax2,ax3],[-DT_pre DT_post])
