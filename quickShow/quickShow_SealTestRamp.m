% quickShow_sweep

trial = regexp(name,'_'); trial = str2num(name(trial(end)+1:end));
label = regexp(name,'\'); label = name(label(end)+1:end);
label = regexprep(label,'_','.');
figure(1);

stimx = [];
stim = [];
x = ((1:data(trial).sampratein*data(trial).durSweep) - 1)/data(trial).sampratein;

figure(1);
ax1 = subplot(2,2,3);

redlines = findobj(1,'Color',[1, 0, 0]);
set(redlines,'color',[1 .8 .8]);
bluelines = findobj(1,'Color',[0, 0, 1]);
set(bluelines,'color',[.8 .8 1]);
greylines = findobj(1,'Color',[.6 .6 .6]);
set(greylines,'color',[.8 .8 .8]);
pinklines = findobj(1,'Color',[.5 1 1]);
set(pinklines,'color',[.8 .8 .8]);

line(x,current,'parent',ax1,'color',[1 0 0],'linewidth',1);
box off; set(gca,'TickDir','out');
xlabel('Time (s)'); %xlim([0 max(t)]);
ylabel('pA'); %xlim([0 max(t)]);

ax2 = subplot(2,2,1);
line(x,voltage,'parent',ax2,'color',[.6 .6 .6],'linewidth',1);
%line(stimx,obj.stim,'parent',ax2,'color',[.5 1 1],'linewidth',1);
box off; set(gca,'TickDir','out');
xlabel('Time (s)'); %xlim([0 max(t)]);
ylabel('V (mV)'); %xlim([0 max(t)]);

linearRegion = x > .05 & x < data(trial).stimDurInSec-0.05; % stim window without the 50 ms on either end

% calculate seal resistance (mV/pA = GOhm)
ax3 = subplot(2,2,4);
p = polyfit(voltage(linearRegion),current(linearRegion),1);
line(voltage(linearRegion),current(linearRegion),'parent',ax3,'color',[1 0 0],'linewidth',1);
line(voltage(linearRegion),p(1)*voltage(linearRegion)+p(2),'parent',ax3,'color',[0 0 1],'linewidth',1);
xlabel('V (mV)'); ylabel('pA');
%     fitFn = p(1).*([1:length(rampSamps)]./data(n).sampratein) + p(2);
%     subplot(2,4,[3 4 7 8]); plot(fitFn,'r','linewidth',2);
sealRes = 1/p(1);   % seal resistance = 1/slope
disp(['seal resistance = ',num2str(sealRes),' gigaohms']);

title(ax3,['seal resistance = ',num2str(sealRes),' gigaohms'])
