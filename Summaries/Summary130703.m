% Meeting with Rachel 130703

% plotting results from 130626 F2_C1, 130628 F1_C1, 130701 F1_C1.
% All VT30609, but all seem to be different.  130626 bears some resemblance
% to F1_C1 in terms of spiking at rest, though they don't really look like
% spikes (see sweep of 130626), where at 130701 really has nice spike, but
% also appears frequency tuned


%% 130626 Sweep to remind about cell-attached spikes
fig = figure('color',[1 1 1]);
orient(fig,'landscape');

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\26-Jun-2013\26-Jun-2013_F2_C1\Sweep_Raw_26-Jun-2013_F2_C1_1.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\26-Jun-2013\26-Jun-2013_F2_C1\Sweep_26-Jun-2013_F2_C1.mat')
plotcanvas = fig;
obj.params = data(1);
savetag = 'delete';

obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(3,3,[1,2,4, 5]);
switch obj.params.recmode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight'); xlabel(ax,'Time (s)'); 
xlim(ax,[2,7])

ax = subplot(3,3,[7 8],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlim(ax,[2,7])

% displayTrial
ax = subplot(1,3,3);
switch obj.params.recmode
    case 'VClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight'); xlabel(ax,'Time (s)'); 
xlim(ax,[5.13,5.15])


%% Sweep

fig = figure('color',[1 1 1]);
orient(fig,'landscape');

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\Sweep_Raw_28-Jun-2013_F1_C1_7.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\Sweep_28-Jun-2013_F1_C1.mat')
obj.params = data(7);
savetag = 'delete';

obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(1,3,[1,2]);
switch obj.params.recmode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight'); xlabel(ax,'Time (s)'); 

%% Spikes

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\Sweep_Raw_28-Jun-2013_F1_C1_7.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\Sweep_28-Jun-2013_F1_C1.mat')
obj.params = data(7);
savetag = 'delete';

obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(1,3,3);
switch obj.params.recmode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight'); xlabel(ax,'Time (s)'); 
xlim(ax,[3.2,3.5])

%% Steps small
fig = figure('color',[1 1 1]);
%orient(fig,'landscape');

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_Raw_28-Jun-2013_F1_C1_6.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(6);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
ax = subplot(9,2,[1 3]);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out');  axis(ax,'tight');
ylim(ax,[-75 -30])

ax = subplot(9,2,17);
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight'); xlabel(ax,'Time (s)'); 
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[0 3])


%% steps large
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_Raw_28-Jun-2013_F1_C1_17.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(17);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
ax = subplot(9,2,[2 4],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-75 -30])

ax = subplot(9,2,[18],'parent',plotcanvas);
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight'); xlabel(ax,'Time (s)'); 
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[0 3])

%% steps hyperpolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_Raw_28-Jun-2013_F1_C1_46.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(46);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
ax = subplot(9,2,[5 7],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-75 -30])


%% steps hyperpolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_Raw_28-Jun-2013_F1_C1_42.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(42);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
ax = subplot(9,2,[6 8],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-75 -30])

%% steps small curare
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_Raw_28-Jun-2013_F1_C1_52.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(52);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
ax = subplot(9,2,[9 11],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-75 -30])

%% small step ttx
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_Raw_28-Jun-2013_F1_C1_92.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(92);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
ax = subplot(9,2,[13 15],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-75 -30])

%% large step ttx
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_Raw_28-Jun-2013_F1_C1_84.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoStep_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(84);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
ax = subplot(9,2,[14 16],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-75 -30])

%% Sine 200 Hz depolarized
fig = figure('color',[1 1 1]);
%orient(fig,'landscape');

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_1.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(1);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,3,[1 4],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-80 -25])

ax = subplot(5,3,13,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[1 6])
text(.1,1.5,'\Delta x = 1')

%% Sine 200 Hz hyperpolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_76.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(76);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,3,[7 10],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-80 -25])

%% sine 400 Hz depolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_36.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(36);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,3,[2 5],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-80 -25])

ax = subplot(5,3,14,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[1 6])
text(.1,1.5,'\Delta x = 1')

%% sine 400 Hz hyperpolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_85.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(85);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,3,[8 11],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-80 -25])


%% 650 Hz depolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_62.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(62);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,3,[3 6],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-80 -25])

ax = subplot(5,3,15,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[1 6])

text(.1,4,'\Delta x = 6')
%% 650 Hz hyperpolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_111.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(111);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,3,[9 12],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-80 -25])


%% 300Hz  before curare
fig = figure('color',[1 1 1]);
%orient(fig,'landscape');

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_153.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(153);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,2,[1 3],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-60 -25])

ax = subplot(5,2,[9],'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[1 6])


%% 300Hz Curare
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_181.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(181);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,2,[5 7],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-60 -25])

%% 300 Hz artifact
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_Raw_28-Jun-2013_F1_C1_245.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\PiezoSine_28-Jun-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(245);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(5,2,[6 8],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-60 -25])

ax = subplot(5,2,[10],'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[1 6])


%% Sweep 130701

fig = figure('color',[1 1 1]);
orient(fig,'landscape');

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_Raw_01-Jul-2013_F1_C1_22.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(22);
savetag = 'delete';
% setupStimulus
obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(5,1,4,'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

ax = subplot(5,1,[1 2 3],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

%% Spikes

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\Sweep_Raw_28-Jun-2013_F1_C1_7.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\28-Jun-2013\28-Jun-2013_F1_C1\Sweep_28-Jun-2013_F1_C1.mat')
obj.params = data(7);
savetag = 'delete';

obj.x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(1,3,3);
switch obj.params.recmode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight'); xlabel(ax,'Time (s)'); 
xlim(ax,[3.2,3.5])

%% 130701 Sine 50 Hz depolarized
fig = figure('color',[1 1 1]);
%orient(fig,'landscape');

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_57.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(57);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[1 4],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-70 -40])

ax = subplot(7,3,19,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[1 6])
text(.1,1.5,'\Delta x = 3')

%% Sine 50 Hz hyperpolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_87.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(87);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[7 10],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-100 10])

%% Sine 50 Hz Curare
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_156.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(156);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[13 16],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-70 -40])


%% 130701 Sine 100 Hz depolarized

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_61.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(61);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[2 5],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-70 -40])

ax = subplot(7,3,20,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[1 6])
text(.1,1.5,'\Delta x = 3')

%% Sine 100 Hz hyperpolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_88.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(88);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[8 11],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-100 10])

%% Sine 100 Hz curare
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_157.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(157);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[14 17],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-70 -40])

%% 130701 Sine 200 Hz depolarized

obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_62.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(62);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[3 6],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-70 -40])

ax = subplot(7,3,21,'parent',plotcanvas); 
line(x,sgsmonitor,'parent',ax,'color',[0 0 1],'tag',savetag);
ylabel(ax,'SGS monitor (V)'); %xlim([0 max(t)]);
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
xlabel(ax,'Time (s)'); %xlim([0 max(t)]);
ylim(ax,[1 6])
text(.1,1.5,'\Delta x = 3')

%% Sine 200 Hz hyperpolarized
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_92.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(92);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[9 12],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-100 10])

%% Sine 200 Hz curare
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_Raw_01-Jul-2013_F1_C1_158.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\PiezoSine_01-Jul-2013_F1_C1.mat')
plotcanvas = fig;
obj.params = data(158);
savetag = 'delete';

% setupStimulus
x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein; x = x(:);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));
sgsmonitor = obj.trial.sgsmonitor(1:length(x));

% displayTrial
ax = subplot(7,3,[15 18],'parent',plotcanvas);
switch obj.params.recmode
    case 'VClamp'
        line(x,current,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        line(x,voltage,'parent',ax,'color',[1 0 0],'tag',savetag);
        ylabel(ax,'V_m (mV)'); %xlim([0 max(t)]);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylim(ax,[-70 -40])

