% Lab Meeting 130805

% 130730_F2_C1 was a good responding cell
% 

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
f = obj.trial.params.sampratein/length(voltage)*[0:length(voltage)/2]; 
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

fr = fr/window_t;

subplot(3,1,3)
plot(I,fr,'or');


%% oscillatory power vs holding potential

