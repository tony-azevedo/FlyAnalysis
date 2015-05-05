% Script_VoltageClamp_VStep

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,Dir,trialStem,dfile] = ...
    extractRawIdentifiers(VClamptrial.name);
data = load(dfile); data = data.data;

x = makeInTime(VClamptrial.params);
current = VClamptrial.current;
voltage = VClamptrial.voltage;

voltage = voltage-mean(voltage(x<x(end)/4));
testoff = find(voltage>0,1,'last');
voltage(testoff:end) = -1;

pulses = diff(voltage>0);
pulse_t = find(pulses>0);

% Find the Break-in point
baseline = x<.5;
current_baseline_std = std(current(baseline));
threshold = 10;

break_in = find(abs(current-current_baseline_std) > threshold*current_baseline_std,1);
if isempty(break_in)
    break_in = 500;
end
pulse_t = pulse_t(pulse_t>break_in);
deltas = diff(pulse_t);
delta = mode(deltas);
pulse_t = pulse_t(deltas>=delta-1 & deltas<=delta+1);

current_traces = zeros(delta,length(pulse_t));
for pt_ind = 1:length(pulse_t)
    current_traces(:,pt_ind) = current(pulse_t(pt_ind)+1:pulse_t(pt_ind)+delta);
end

plot(ax_first,x(1:delta),mean(current_traces(:,1:20),2));
plot(ax_last,x(1:delta),mean(current_traces(:,end-20+1:end),2));
linkaxes([ax_first ax_last]);
xlim(ax_first,[x(1) x(delta)])

xlabel(ax_first,'s');
xlabel(ax_last,'s');
ylabel(ax_first,'pA');

text(x(round(delta/10)),max(get(ax_first,'ylim'))*.75,'steps 1-20','parent',ax_first);
text(x(round(delta/10)),max(get(ax_first,'ylim'))*.75,'last 20 steps','parent',ax_last);
