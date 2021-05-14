%% Script_MeasureMechStimResponses
DEBUG = 0;
if any(contains(T.Properties.VariableNames,'Vm_stim_on')) || ...
    any(contains(T.Properties.VariableNames,'Vm_stim_off')) || ...
    any(contains(T.Properties.VariableNames,'Vm_Delta')) || ...
    any(contains(T.Properties.VariableNames,'Vm_pretrial'))
    error('Delete Vm_stim, Vm_Delta, and Vm_pretrial variables')
end
%% Measure Stim response in trials (have to run this in addition to stim movement, which is based on forceprobe matrix)

ft_0i = ft(1:end-1)<=0 & ft(2:end)>0;
probe_position_init = zeros(size(T.arduino_duration));
Vm_stim_on = probe_position_init;
Vm_stim_off = probe_position_init;
Vm_Delta = probe_position_init;
Vm_pretrial = probe_position_init;

% note, teststep starts at 0.01, ends at 0.06 and is -5
if DEBUG
   f = figure;
   f.Position = [60 558 1679 420];
   ax = subplot(1,1,1); ax.NextPlot = 'add';
   text(ax,0,20,'rms = ');
end
T_row = T(1,:);
trial = load(fullfile(Dir,sprintf(trialStem,T_row.trial)));
x = makeInTime(trial.params);

% Vm_Delta windows
vm_dwin_pre = x<-trial.params.preDurInSec+.01;
vm_dwin = x>-trial.params.preDurInSec+.04 & x<-trial.params.preDurInSec+.06; % 20 ms

% Cue windows
% 50 ms before stim
preCueWin = x>-trial.params.cueDelayDurInSec-trial.params.cueStimDurInSec-.05; %-.85
preCueWin = preCueWin & x<-trial.params.cueDelayDurInSec-trial.params.cueStimDurInSec; %-.8

% after ramp to middle of stim
cueWin = x>-trial.params.cueDelayDurInSec-trial.params.cueStimDurInSec+trial.params.cueRampDurInSec; %-.73
cueWin = cueWin & x<-trial.params.cueDelayDurInSec-trial.params.cueStimDurInSec+trial.params.cueStimDurInSec/2; %-.65

% after ramps to before second ramp
cueEndWin = x>-trial.params.cueDelayDurInSec-2*trial.params.cueRampDurInSec; % -.64
cueEndWin = cueEndWin & x<-trial.params.cueDelayDurInSec-trial.params.cueRampDurInSec; %-0.57

% after ramp end for 50 ms
postCueWin = x>-trial.params.cueDelayDurInSec; %-.5
postCueWin = postCueWin & x<-trial.params.cueDelayDurInSec + .05; %-.45

% Pretrial window
preWin = x<0 & x>-trial.params.cueDelayDurInSec/2; %-.25 to 0

for tr = 1:size(T,1)
    % fprintf('Trial %d: \t',T.trial(tr));
    
    T_row = T(tr,:);
    trial = load(fullfile(Dir,sprintf(trialStem,T_row.trial)));
    Vm_pretrial(tr) = mean(trial.voltage_1(preWin));
    Vm_Delta(tr) = ...
        mean(trial.voltage_1(vm_dwin)) - ...
        mean(trial.voltage_1(vm_dwin_pre));

    preCueVm = mean(trial.voltage_1(preCueWin));
    cueVm = mean(trial.voltage_1(cueWin));
    cueEndVm = mean(trial.voltage_1(cueEndWin));
    postCueVm = mean(trial.voltage_1(postCueWin));

    Vm_stim_on(tr) = cueVm - preCueVm;
    Vm_stim_off(tr) = postCueVm - cueEndVm;
    
    probe_position_init(tr) = fp(ft_0i,tr);
    
    if DEBUG
        cla(ax)
        y = fp((ft<0),tr);
        y = y-min(y);
        y = y/max(y);
        y = y*-10-30;
        plot(ax,ft(ft<0),y);

        plot(ax,x(x<0),trial.voltage_1(x<0),'color',.9* [1 1 1]); 
        plot(ax,x([find(vm_dwin_pre,1,'first') find(vm_dwin_pre,1,'last')]),[1 1]*mean(trial.voltage_1(vm_dwin_pre)));
        plot(ax,x([find(vm_dwin,1,'first') find(vm_dwin,1,'last')]),[1 1]*mean(trial.voltage_1(vm_dwin)));
        plot(ax,x([find(preCueWin,1,'first') find(preCueWin,1,'last')]),[1 1]*preCueVm);
        plot(ax,x([find(cueWin,1,'first') find(cueWin,1,'last')]),[1 1]*cueVm);
        plot(ax,x([find(cueEndWin,1,'first') find(cueEndWin,1,'last')]),[1 1]*cueEndVm);
        plot(ax,x([find(postCueWin,1,'first') find(postCueWin,1,'last')]),[1 1]*postCueVm);
        plot(ax,x([find(preWin,1,'first') find(preWin,1,'last')]),[1 1]*Vm_pretrial(tr));

        pause
    end
end

T.Vm_stim_on = Vm_stim_on;
T.Vm_stim_off = Vm_stim_off;
T.Vm_Delta = Vm_Delta;
T.Vm_pretrial = Vm_pretrial;
T.probe_position_init = probe_position_init;

save(T.Properties.Description,'T')

