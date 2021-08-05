%% Script_Columbia_Talk

%% plotting trial 10 and the subsequent 300 s
% This calculates and plots the firing rate for trials 10:44 for a slow
% neuron. Used in John's talk to Columbia department. Interesting
% observations includes a reduction in spike rate when the fly resets, with
% a slow increase in the spike rate over time.

trial = load('F:\Acquisition\210604\210604_F1_C1\LEDFlashWithPiezoCueControl_Raw_210604_F1_C1_10.mat');

[~,~,~,~,~,D,trialStem,tfile,notesfile] = extractRawIdentifiers(trial.name);

fig = figure;
ax = subplot(1,1,1,'parent',fig);
ax.NextPlot = 'add';
spiketimes = [];
trials = 10:44;
starttimes = zeros(size(trials));
durs = starttimes;
cnt = 0;
for tr = 1:length(trials)
    cnt = cnt+1;
    trial = load(fullfile(D,sprintf(trialStem,trials(tr))));
    t = makeInTime(trial.params);    
    t_ = [t; makeInterTime(trial)];
    spiketimes = [trial.spikes(trial.spikes<length(t)), trial.intertrial.spikes];

    x = zeros(size(t_));
    x(spiketimes) = 1;
    
    fr = firingRate(t_,x,43/300);
    %[fr1, window] = smoothdata(x,'gaussian',round(50/300*trial.params.sampratein));
    %fr1 = fr1*300/50;
    
    plot(ax,t_(round(43/300*trial.params.sampratein):end)+trial.starttime,fr(round(43/300*trial.params.sampratein):end))
    starttimes(cnt) = trial.starttime;
%  durs(cnt) = trial.params.durSweep;
    drawnow
end

ax.XLim = [0 300] + starttimes(1);
