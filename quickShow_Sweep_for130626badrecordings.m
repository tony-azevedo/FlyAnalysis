% quickShow_sweep

trial = regexp(name,'_'); trial = str2num(name(trial(end)+1:end));
label = regexp(name,'\'); label = name(label(end)+1:end);
label = regexprep(label,'_','.');
figure(1);

% setupStimulus
obj.stimx = [];
obj.stim = [];
obj.x = ((1:data(trial).sampratein*data(trial).durSweep) - 1)/data(trial).sampratein;

% displayTrial
redlines = findobj(1,'Color',[1, 0, 0]);
set(redlines,'color',[1 .8 .8]);

ax1 = subplot(5,1,1);
line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax1);

ax2 = subplot(5,1,[2 3]);
switch data(trial).recmode
    case 'VClamp'
        ylabel('I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax2);
    case 'IClamp'
        ylabel('V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax2);
end
box off; set(gca,'TickDir','out');

xlabel('Time (s)'); 
axis tight
%ylim([-80 -60]);
%xlim([0 max(t)]);

ax3 = subplot(5,1,[4 5]); cla
voltagefft = fft(voltage);
f = data(trial).sampratein/length(voltage)*[0:length(voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(f,voltagefft.*conj(voltagefft),'r')
box off; set(gca,'TickDir','out');
ylabel('V^2'); %xlim([0 max(t)]);
xlabel('time (s)');

title(ax1,label)

data(trial).scaledcurrentscale
