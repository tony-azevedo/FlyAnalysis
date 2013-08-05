% Lab Meeting 130805

%% first trial 130802 F1_C2
fig = figure(101);
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_27.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_130802_F1_C2.mat')
plotcanvas = fig;
obj.trial.params = data(27);
savetag = 'delete';
% setupStimulus
obj.x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(5,1,4,'parent',plotcanvas);
if length(obj.trial.params.recmode)>6, mode = obj.trial.params.recmode(1:6);
else mode = 'IClamp';
end
switch mode
    case 'VClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

ax = subplot(5,1,[1 2 3],'parent',plotcanvas);
switch mode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

title(ax,'Sweep trial 27, durSweep=5, 14:17:5')

ax = subplot(5,1,[5],'parent',plotcanvas); 
voltagefft = fft(voltage);
f = obj.trial.params.sampratein/length(obj.trial.voltage)*[0:length(obj.trial.voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
hold(ax,'on');
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylabel(ax,'V^2'); %xlim([0 max(t)]);
xlabel(ax,'Time (s)'); 


%%  FR vs I
fig = figure(101);
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_27.mat');

I = smooth(obj.trial.current,10000);
x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;

% plot(x,obj.trial.current); hold on
subplot(3,1,1)
plot(x,I,'r');

subplot(3,1,2)
plot(x,obj.trial.voltage),hold on

threshold = -40;
below = obj.trial.voltage <= threshold;
above = obj.trial.voltage > threshold;
cross_up = [below(1:end-1) & above(2:end); false];

plot(x(cross_up),threshold*cross_up(cross_up),'or');

window_t = .1;
noverlap_t = 0.1;
window = window_t * obj.trial.params.sampratein;
noverlap = noverlap_t * obj.trial.params.sampratein;

fr = [];
I = [];
istart = 0;
while istart + window < length(cross_up)
   fr(end+1) = sum(cross_up(istart+1:istart+window));
   I(end+1) = mean(obj.trial.current(istart+1:istart+window));
   istart = istart+noverlap;
end

fr = fr;

subplot(3,1,3)
plot(I,fr,'or');

%%  FR vs I 130802 F1_C2
fig = figure(102);
trials = [9:18, 24:27];
window_t = .1;
noverlap_t = 0.05;
frmat = [];
Imat = [];
for t = 1:length(trials)
    obj.trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat',trials(t));
    x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
   
    threshold = -40;
    below = obj.trial.voltage <= threshold;
    above = obj.trial.voltage > threshold;
    cross_up = [below(1:end-1) & above(2:end); false];

    window = window_t * obj.trial.params.sampratein;
    noverlap = noverlap_t * obj.trial.params.sampratein;
    
    fr = [];
    I = [];
    istart = 0;
    while istart + window < length(cross_up)
        fr(end+1) = sum(cross_up(istart+1:istart+window));
        I(end+1) = mean(obj.trial.current(istart+1:istart+window));
        istart = istart+noverlap;
    end
    %fr = fr/window_t;
    frmat(t,:) = fr;
    Imat(t,:) = I;
end
plot(Imat(:),frmat(:),'o'); hold on

%%  FR vs I 130701 F1_C1
fig = figure(101);
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_Raw_01-Jul-2013_F1_C1_16.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_01-Jul-2013_F1_C1.mat')
obj.trial.params = data(16);

I = smooth(obj.trial.current,10000);
x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;

% plot(x,obj.trial.current); hold on
subplot(3,1,1)
plot(x,I,'r');

subplot(3,1,2)
plot(x,obj.trial.voltage),hold on

threshold = -40;
below = obj.trial.voltage <= threshold;
above = obj.trial.voltage > threshold;
cross_up = [below(1:end-1) & above(2:end); false];

plot(x(cross_up),threshold*cross_up(cross_up),'or');

window_t = .1;
noverlap_t = 0.1;
window = window_t * obj.trial.params.sampratein;
noverlap = noverlap_t * obj.trial.params.sampratein;

fr = [];
I = [];
istart = 0;
while istart + window < length(cross_up)
   fr(end+1) = sum(cross_up(istart+1:istart+window));
   I(end+1) = mean(obj.trial.current(istart+1:istart+window));
   istart = istart+noverlap;
end

fr = fr;

subplot(3,1,3)
plot(I,fr,'or');


%%  FR vs I 130701 F1_C1
fig = figure(102);
trials = [6:20];
window_t = .1;
noverlap_t = 0.05;
frmat = [];
Imat = [];
for t = 1:length(trials)
    obj.trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_Raw_01-Jul-2013_F1_C1_%d.mat',trials(t));
    load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_01-Jul-2013_F1_C1.mat')
    obj.trial.params = data(trials(t));

    x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
   
    threshold = -40;
    below = obj.trial.voltage <= threshold;
    above = obj.trial.voltage > threshold;
    cross_up = [below(1:end-1) & above(2:end); false];

    window = window_t * obj.trial.params.sampratein;
    noverlap = noverlap_t * obj.trial.params.sampratein;
    
    fr = [];
    I = [];
    istart = 0;
    while istart + window < length(cross_up)
        fr(end+1) = sum(cross_up(istart+1:istart+window));
        I(end+1) = mean(obj.trial.current(istart+1:istart+window));
        istart = istart+noverlap;
    end
    %fr = fr/window_t;
    frmat(t,:) = fr;
    Imat(t,:) = I;
end
plot(Imat(:),frmat(:),'or');


%% oscillatory power vs holding potential 130730 F1C1 130802 F1C2 Rest

fig = figure(103);
subplot(4,4,9:16)
co = get(gca,'ColorOrder');

paths = {...
    'C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\Sweep_Raw_130730_F1_C1_%d.mat',...
    'C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat'};
trialscell = {...
    6:10,...
    1:5};
for p = 1:length(paths)
    clear peakpower peakfreq Vm
    trials = trialscell{p};
    for t = 1:length(trials)
        obj.trial = pathload(paths{p},trials(t));
        x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
                
        Vm(t) = mean(obj.trial.voltage);
        voltagefft = fft(obj.trial.voltage-mean(obj.trial.voltage));
        voltagefft = voltagefft.*conj(voltagefft);
        f = obj.trial.params.sampratein/length(obj.trial.voltage)*[0:length(obj.trial.voltage)/2];
        f = [f, fliplr(f(2:end-1))];
        %loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
        [pptemp,pftemp] = max(voltagefft(f>10));
        peakpower(t) = pptemp;
        peakfreq(t) = f(pftemp+(sum(f<=10)+1)/2);
    end
    peakpowercell{p} = peakpower;
    peakfreqcell{p} = peakfreq;
    Vm_cell{p} = Vm;
    
    line(Vm,peakfreq,'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor','none');
    
    meanpp(p) = mean(peakpower);
    meanpf(p) = mean(peakfreq);
    meanVm(p) = mean(Vm);
    line(meanVm(p),meanpf(p),'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor',co(p,:));
end

%% Examples
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_3.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_130802_F1_C2.mat')
plotcanvas = fig;
obj.params = data(3);
savetag = 'delete';
% setupStimulus
obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(4,4,3,'parent',plotcanvas);
switch mode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

ax = subplot(4,4,7,'parent',plotcanvas); 
voltagefft = fft(voltage);
f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
hold(ax,'on');
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylabel(ax,'V^2'); %xlim([0 max(t)]);
xlabel(ax,'Time (s)'); 
%% Examples
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_7.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_130802_F1_C2.mat')
plotcanvas = fig;
obj.params = data(3);
savetag = 'delete';
% setupStimulus
obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(4,4,1,'parent',plotcanvas);
switch mode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

ax = subplot(4,4,5,'parent',plotcanvas); 
voltagefft = fft(voltage);
f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
hold(ax,'on');
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylabel(ax,'V^2'); %xlim([0 max(t)]);
xlabel(ax,'Time (s)'); 
%% Examples
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_17.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_130802_F1_C2.mat')
plotcanvas = fig;
obj.params = data(3);
savetag = 'delete';
% setupStimulus
obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(4,4,2,'parent',plotcanvas);
switch mode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

ax = subplot(4,4,6,'parent',plotcanvas); 
voltagefft = fft(voltage);
f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
hold(ax,'on');
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylabel(ax,'V^2'); %xlim([0 max(t)]);
xlabel(ax,'Time (s)'); 
%% Examples
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_22.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_130802_F1_C2.mat')
plotcanvas = fig;
obj.params = data(3);
savetag = 'delete';
% setupStimulus
obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(4,4,4,'parent',plotcanvas);
switch mode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

ax = subplot(4,4,8,'parent',plotcanvas); 
voltagefft = fft(voltage);
f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
hold(ax,'on');
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylabel(ax,'V^2'); %xlim([0 max(t)]);
xlabel(ax,'Time (s)'); 



%% oscillatory power vs holding potential 130730 F1C1 130802 F1C2 Hyper

fig = figure(103);
subplot(4,4,9:16)
co = get(gca,'ColorOrder');

paths = {...
    'C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\Sweep_Raw_130730_F1_C1_%d.mat',...
    'C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat'};
trialscell = {...
    11:15,...
    6:8};
for p = 1:length(paths)
    clear peakpower peakfreq Vm
    trials = trialscell{p};
    for t = 1:length(trials)
        obj.trial = pathload(paths{p},trials(t));
        x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
                
        Vm(t) = mean(obj.trial.voltage);
        voltagefft = fft(obj.trial.voltage-mean(obj.trial.voltage));
        voltagefft = voltagefft.*conj(voltagefft);
        f = obj.trial.params.sampratein/length(obj.trial.voltage)*[0:length(obj.trial.voltage)/2];
        f = [f, fliplr(f(2:end-1))];
        %loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
        [pptemp,pftemp] = max(voltagefft(f>10));
        peakpower(t) = pptemp;
        peakfreq(t) = f(pftemp+(sum(f<=10)+1)/2);
    end
    peakpowercell{p} = peakpower;
    peakfreqcell{p} = peakfreq;
    Vm_cell{p} = Vm;
    
    line(Vm,peakfreq,'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor','none');
    
    meanpp(p) = mean(peakpower);
    meanpf(p) = mean(peakfreq);
    meanVm(p) = mean(Vm);
    line(meanVm(p),meanpf(p),'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor',co(p,:));
end

%% oscillatory power vs holding potential 130730 F1C1 130802 F1C2 Hyper

fig = figure(103);
subplot(4,4,9:16)
co = get(gca,'ColorOrder');

paths = {...
    'C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\Sweep_Raw_130730_F1_C1_%d.mat',...
    'C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat'};
trialscell = {...
    21:25,...
    14:18};
for p = 1:length(paths)
    clear peakpower peakfreq Vm
    trials = trialscell{p};
    for t = 1:length(trials)
        obj.trial = pathload(paths{p},trials(t));
        x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
                
        Vm(t) = mean(obj.trial.voltage);
        voltagefft = fft(obj.trial.voltage-mean(obj.trial.voltage));
        voltagefft = voltagefft.*conj(voltagefft);
        f = obj.trial.params.sampratein/length(obj.trial.voltage)*[0:length(obj.trial.voltage)/2];
        f = [f, fliplr(f(2:end-1))];
        %loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
        [pptemp,pftemp] = max(voltagefft(f>10));
        peakpower(t) = pptemp;
        peakfreq(t) = f(pftemp+(sum(f<=10)+1)/2);
    end
    peakpowercell{p} = peakpower;
    peakfreqcell{p} = peakfreq;
    Vm_cell{p} = Vm;
    
    line(Vm,peakfreq,'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor','none');
    
    meanpp(p) = mean(peakpower);
    meanpf(p) = mean(peakfreq);
    meanVm(p) = mean(Vm);
    line(meanVm(p),meanpf(p),'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor',co(p,:));
end

%% oscillatory power vs holding potential 130730 F1C1 130802 F1C2 Depolarized

fig = figure(103);
subplot(4,4,9:16)
co = get(gca,'ColorOrder');

paths = {...
    'C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat'};
trialscell = {...
    19:23};
for p = 1:length(paths)
    clear peakpower peakfreq Vm
    trials = trialscell{p};
    for t = 1:length(trials)
        obj.trial = pathload(paths{p},trials(t));
        x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
                
        Vm(t) = mean(obj.trial.voltage);
        voltagefft = fft(obj.trial.voltage-mean(obj.trial.voltage));
        voltagefft = voltagefft.*conj(voltagefft);
        f = obj.trial.params.sampratein/length(obj.trial.voltage)*[0:length(obj.trial.voltage)/2];
        f = [f, fliplr(f(2:end-1))];
        %loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
        [pptemp,pftemp] = max(voltagefft(f>10));
        peakpower(t) = pptemp;
        peakfreq(t) = f(pftemp+(sum(f<=10)+1)/2);
    end
    peakpowercell{p} = peakpower;
    peakfreqcell{p} = peakfreq;
    Vm_cell{p} = Vm;
    
    line(Vm,peakfreq,'linestyle','none','marker','o','markeredgecolor',co(p+1,:),'markerfacecolor','none');
    
    meanpp(p) = mean(peakpower);
    meanpf(p) = mean(peakfreq);
    meanVm(p) = mean(Vm);
    line(meanVm(p),meanpf(p),'linestyle','none','marker','o','markeredgecolor',co(p+1,:),'markerfacecolor',co(p+1,:));
end


%% Sensitivity to sine wave stimuli rest
fig = figure(104);
trials = 23:5:35;

load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_21.mat');

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_%d.mat',trials(t));
    resp(t,:) = trial.voltage;
end
x = ((1:trial.params.sampratein*trial.params.durSweep) - trial.params.preDurInSec*trial.params.sampratein)/trial.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title(sprintf('%s PiezoSine trials %d-%d, freq=%d, %.1f dis',...
    trial.params.date,trials(1),trials(end),trial.params.freq,trial.params.displacement))
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,trial.sgsmonitor)
xlabel('s')
ylabel('V')


%% Sensitivity to sine wave stimuli hyperpolarized
fig = figure(104);
%Show epochs 1:15 100 Hz average .5 disp. RINGING!!
%trials = 66:5:80;
trials = 98:5:110;

load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_81.mat');

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_%d.mat',trials(t));
    resp(t,:) = trial.voltage;
end
x = ((1:trial.params.sampratein*trial.params.durSweep) - trial.params.preDurInSec*trial.params.sampratein)/trial.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title(sprintf('%s PiezoSine trials %d-%d, freq=%d, %.1f dis',...
    trial.params.date,trials(1),trials(end),trial.params.freq,trial.params.displacement))
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,trial.sgsmonitor)
xlabel('s')
ylabel('V')

%% Sensitivity to sine wave stimuli mecamylamine
fig = figure(104);
%Show epochs 1:15 100 Hz average .5 disp. RINGING!!
%trials = 66:5:80;
trials = 126:5:140;
trials = 143:5:155;

load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_81.mat');

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_%d.mat',trials(t));
    resp(t,:) = trial.voltage;
end
x = ((1:trial.params.sampratein*trial.params.durSweep) - trial.params.preDurInSec*trial.params.sampratein)/trial.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title(sprintf('%s PiezoSine trials %d-%d, freq=%d, %.1f dis',...
    trial.params.date,trials(1),trials(end),trial.params.freq,trial.params.displacement))
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,trial.sgsmonitor)
xlabel('s')
ylabel('V')

%% Sensitivity to sine wave stimuli TTX
fig = figure(104);
%Show epochs 1:15 100 Hz average .5 disp. RINGING!!
trials = 233:5:245;

load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_81.mat');

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_%d.mat',trials(t));
    resp(t,:) = trial.voltage;
end
x = ((1:trial.params.sampratein*trial.params.durSweep) - trial.params.preDurInSec*trial.params.sampratein)/trial.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title(sprintf('%s PiezoSine trials %d-%d, freq=%d, %.1f dis',...
    trial.params.date,trials(1),trials(end),trial.params.freq,trial.params.displacement))
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,trial.sgsmonitor)
xlabel('s')
ylabel('V')


%% Courtship song and other stimuli
fig = figure(105);
stimtrain = wavread('CourtshipSong.wav');
Fs = 40000;
ramptime = .02;
% sound(stimtrain,Fs)
subplot(3,1,1)

stim = [0*(1:Fs)';stimtrain;0*(1:Fs)'];
x = ((1:length(stim))-Fs)/Fs;
stimpnts = Fs+1:Fs+length(stimtrain);
clear window
w = window(@triang,2*ramptime*Fs);
w = [w(1:ramptime*Fs);...
    ones(length(stimpnts)-length(w),1);...
    w(ramptime*Fs+1:end)];

stim(stimpnts) = stim(stimpnts).*w;

plot(x,stim,'k'); hold on
plot(x(Fs+1:Fs+28000),stim(Fs+1:Fs+28000),'r');
plot(x(Fs+28000+1:Fs+length(stimtrain)),stim(Fs+28000+1:Fs+length(stimtrain)),'b');

subplot(3,1,[2 3])
[Pxx,f] = pwelch(stimtrain,[],[],[],40000);
loglog(f(f<2000),Pxx(f<2000),'k'); hold on
[Pxx,f] = pwelch(stimtrain(28000:end),[],[],[],40000);
loglog(f(f<2000),Pxx(f<2000),'r'); hold on
[Pxx,f] = pwelch(stimtrain(1:28000),[],[],[],40000);
loglog(f(f<2000),Pxx(f<2000),'b'); hold on

%% Compare polarities of 130730 F1C1
fig = figure(106);
trials = 18:5:33;

load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_18.mat');

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t));
    resp(t,:) = trial.voltage;
end
x = ((1:trial.params.sampratein*trial.params.durSweep) - trial.params.preDurInSec*trial.params.sampratein)/trial.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title(sprintf('%s PiezoSine trials %d-%d, freq=%d, %.1f dis',...
    trial.params.date(1:6),trials(1),trials(end),trial.params.freq,trial.params.displacement))
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,trial.sgsmonitor)
xlabel('s')
ylabel('V')

trials = 23:5:35;

load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_23.mat');

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\PiezoSine_Raw_130802_F1_C2_%d.mat',trials(t));
    resp(t,:) = trial.voltage;
end
x = ((1:trial.params.sampratein*trial.params.durSweep) - trial.params.preDurInSec*trial.params.sampratein)/trial.params.sampratein;

subplot(3,1,2)
hold on, plot(x,mean(resp))
%xlim([-.2,.3])
%ylabel('mV')


