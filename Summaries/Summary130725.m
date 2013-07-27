% Meeting with Rachel 130725

% Demonstrating artifact with model cell in patch mode
% Artifact was present after returning from lunch
% 763 trials had been run on piezoFeedbackCalibration script
% 1st trial at 11:34am
% found artifact at 1:00pm
% 

fig = figure(101);
%% first rial

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_Raw_130719_F0_C2_3.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_130719_F0_C2.mat')
plotcanvas = fig;
obj.params = data(3);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(3,1,[1 2],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
title('PiezoSine trial 3, freq=100, 13:05:2')

ax = subplot(3,1,3,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);

%% Show epochs 1:15 100 Hz average
trials = 1:15;
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_130719_F0_C2.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_Raw_130719_F0_C2_3.mat');

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130719\\130719_F0_C2\\PiezoSine_Raw_130719_F0_C2_%d.mat',trials(t)))
    resp(t,:) = current;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 1-15, freq=100, model cell patch outlet')
ylabel('pA')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('pA')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 31:35 After quick turn off V-Clamp
trials = 31:35;
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_130719_F0_C2.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_Raw_130719_F0_C2_3.mat');

resp = zeros(length(trials),length(voltage));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130719\\130719_F0_C2\\PiezoSine_Raw_130719_F0_C2_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 31:35, freq=100, V-Clamp mode')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 36:40 turned off, V-Clamp
trials = 36:40;
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_130719_F0_C2.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_Raw_130719_F0_C2_3.mat');

resp = zeros(length(trials),length(voltage));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130719\\130719_F0_C2\\PiezoSine_Raw_130719_F0_C2_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 36:40, Piezo off, V-Clamp mode')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 41:50 back on, I-Clamp
trials = 41:50;
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_130719_F0_C2.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_Raw_130719_F0_C2_3.mat');

resp = zeros(length(trials),length(voltage));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130719\\130719_F0_C2\\PiezoSine_Raw_130719_F0_C2_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 36:40, Piezo off, I-Clamp mode')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')


%% Show epochs 51:60 back on, V-Clamp
trials = 51:60;
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_130719_F0_C2.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130719\130719_F0_C2\PiezoSine_Raw_130719_F0_C2_3.mat');

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130719\\130719_F0_C2\\PiezoSine_Raw_130719_F0_C2_%d.mat',trials(t)))
    resp(t,:) = current;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 36:40, Piezo off, V-Clamp mode')
ylabel('pA')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('pA')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')