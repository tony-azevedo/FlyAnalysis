% Meeting with Rachel 130801

% 130730_F2_C1 was a good responding cell
% 

fig = figure(101);
%% first trial

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_1.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
plotcanvas = fig;
obj.params = data(1);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(3,1,[1 2],'parent',plotcanvas);
if length(obj.params.recmode)>6, mode = obj.params.recmode(1:6);
else mode = 'IClamp';
end
switch mode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (mV)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
title(ax,'PiezoSine trial 1, freq=25, 14:29:5')

ax = subplot(3,1,3,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);


%% Show epochs 1:15 25 Hz average .5 disp.
trials = 1:5:11;
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_1.mat')

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 1-15, freq=25, .5V disp')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 1:15 50 Hz average .5 disp.
trials = 2:5:15;
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_2.mat')

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 1-15, freq=50, .5 dis')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 1:15 100 Hz average .5 disp. RINGING!!
trials = 3:5:15;
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_3.mat')

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 1-15, freq=100, .5 dis')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 1:15 200 Hz average .5 disp.
trials = 4:5:15;
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_4.mat')

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 1-15, freq=200, .5 dis')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 1:15 400 Hz average .5 disp.
trials = 5:5:15;
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_5.mat')

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 1-15, freq=400, .5 dis')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 1:15 400 Hz average .5 disp.
clf
trials = 181:5:195;
nondrugtrials = 1:5:11;
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_5.mat')

% trials = 1:5:11;
% load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
% load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_1.mat')
% 
% resp = zeros(length(trials),length(current));
% for t = 1:length(trials)
%     load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
%     resp(t,:) = voltage;
% end
% obj.params = data(trials(1));
% x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;
% 
% subplot(3,1,1)
% plot(x,resp')
% title('PiezoSine trials 1-15, freq=25, .5V disp')
% ylabel('mV')
% 
% subplot(3,1,2)
% plot(x,mean(resp))
% ylabel('mV')
% 
% subplot(3,1,3)
% plot(x,sgsmonitor)
% xlabel('s')
% ylabel('V')

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
nondrugresp = zeros(length(nondrugtrials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',nondrugtrials(t)))
    nondrugresp(t,:) = voltage;
end

obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 1-15, freq=25, .5 dis, TTX')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(nondrugresp),'color',[.5 .5 1]), hold on
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')

%% Show epochs 1:15 100 Hz average .5 disp.
trials = 183:5:195;
nondrugtrials = 3:5:15;
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_5.mat')

% trials = 1:5:11;
% load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_130730_F1_C1.mat')
% load('C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\PiezoSine_Raw_130730_F1_C1_1.mat')
% 
% resp = zeros(length(trials),length(current));
% for t = 1:length(trials)
%     load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
%     resp(t,:) = voltage;
% end
% obj.params = data(trials(1));
% x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;
% 
% subplot(3,1,1)
% plot(x,resp')
% title('PiezoSine trials 1-15, freq=25, .5V disp')
% ylabel('mV')
% 
% subplot(3,1,2)
% plot(x,mean(resp))
% ylabel('mV')
% 
% subplot(3,1,3)
% plot(x,sgsmonitor)
% xlabel('s')
% ylabel('V')

resp = zeros(length(trials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
nondrugresp = zeros(length(nondrugtrials),length(current));
for t = 1:length(trials)
    load(sprintf('C:\\Users\\Anthony Azevedo\\Raw_Data\\130730\\130730_F1_C1\\PiezoSine_Raw_130730_F1_C1_%d.mat',nondrugtrials(t)))
    nondrugresp(t,:) = voltage;
end

obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,1)
plot(x,resp')
title('PiezoSine trials 1-15, freq=25, .5 dis, TTX')
ylabel('mV')

subplot(3,1,2)
plot(x,mean(nondrugresp),'color',[.5 .5 1]), hold on
plot(x,mean(resp))
ylabel('mV')

subplot(3,1,3)
plot(x,sgsmonitor)
xlabel('s')
ylabel('V')