% quickShow_PiezoStep

trial = regexp(name,'_'); trial = str2num(name(trial(end)+1:end));
label = regexp(name,'\'); label = name(label(end)+1:end);
label = regexprep(label,'_','.');
label = [label ' - ' num2str(data(trial).displacement) ' V'];

% setupStimulus
x = ((1:data(trial).sampratein*data(trial).durSweep) - 1)/data(trial).sampratein; x = x(:);
voltage = voltage(1:length(x));
sgsmonitor = sgsmonitor(1:length(x));
%sgsmonitor = zeros(size(x));

% displayTrial
figure(1);
ax1 = subplot(3,1,[1 2]);

redlines = findobj(1,'Color',[1, 0, 0]);
set(redlines,'color',[1 .8 .8]);
bluelines = findobj(1,'Color',[0, 0, 1]);
set(bluelines,'color',[.8 .8 1]);

%line(obj.stimx,obj.generateStimulus,'parent',ax1,'color',[0 0 1],'linewidth',1);
% line(obj.x,voltage,'parent',ax1,'color',[1 0 0],'linewidth',1);
% line(obj.x,sgsmonitor,'parent',ax2,'color',[0 0 1],'linewidth',1);

[ax,l1,l2] = plotyy(x,sgsmonitor,x,voltage,'parent',ax1);
ax1 = ax(1);
ax2 = ax(2);
set(l1,'color',[1 1 1]*.7)
set(ax1,'ycolor',[1 1 1]*0,'ylim',[-2 10],'ytick',(-2:4:10))
set(l2,'color',[1 0 0])
set(ax2,'Ycolor',[1 0 0],'ylim',[-20,100],'ytick',(-200:40:20))

box off; set(gca,'TickDir','out');
switch data(trial).recmode
    case 'VClamp'
        ylabel('I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        ylabel(ax2,'V_m (mV)'); %xlim([0 max(t)]);
end
ylabel(ax1,'SGS monitor (V)'); %xlim([0 max(t)]);
xlabel('Time (s)'); %xlim([0 max(t)]);

title(label);

ax3 = subplot(3,1,3); cla
voltagefft = fft(voltage);
f = data(trial).sampratein/length(voltage)*[0:length(voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(f,voltagefft.*conj(voltagefft),'r')
box off; set(gca,'TickDir','out'); axis tight
ylabel('V^2'); %xlim([0 max(t)]);
xlabel('time (s)');
set(ax3,'Ycolor',[1 0 0])

title(ax1,label)
