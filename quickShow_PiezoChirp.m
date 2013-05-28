% quickShow_sweep

trial = regexp(name,'_'); trial = str2num(name(trial(end)+1:end));
label = regexp(name,'\'); label = name(label(end)+1:end);
label = regexprep(label,'_','.');
obj.y = voltage;

% setupStimulus
obj.x = ((1:data(trial).sampratein*data(trial).durSweep) - 1)/data(trial).sampratein;

% displayTrial
figure(1);
ax1 = subplot(4,4,[1 2 3 5 6 7 9 10 11]);

redlines = findobj(1,'Color',[1, 0, 0]);
set(redlines,'color',[1 .8 .8]);
bluelines = findobj(1,'Color',[0, 0, 1]);
set(bluelines,'color',[.8 .8 1]);

%line(obj.stimx,obj.generateStimulus,'parent',ax1,'color',[0 0 1],'linewidth',1);
line(obj.x,voltage,'parent',ax1,'color',[1 0 0],'linewidth',1);
box off; set(gca,'TickDir','out');
switch data(trial).recmode
    case 'VClamp'
        ylabel('I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        ylabel('V_m (mV)'); %xlim([0 max(t)]);
end
xlabel('Time (s)'); %xlim([0 max(t)]);

ax2 = subplot(4,4,[13 14 15]);
line(obj.x,sgsmonitor,'parent',ax2,'color',[0 0 1],'linewidth',1);
box off; set(gca,'TickDir','out');

ax3 = subplot(3,4,[4 8]);

sgsfft = real(fft(sgsmonitor).*conj(fft(sgsmonitor)));
sgsf = data(trial).sampratein/length(sgsmonitor)*[0:length(sgsmonitor)/2]; sgsf = [sgsf, fliplr(sgsf(2:end-1))];

respfft = real(fft(voltage.*conj(fft(voltage))));
respf = data(trial).sampratein/length(voltage)*[0:length(voltage)/2]; respf = [respf, fliplr(respf(2:end-1))];

%             stim = obj.generateStimulus;
%             stimfft = real(fft(stim).*conj(fft(stim)));
%             stimf = obj.params.samprateout/length(stim)*[0:length(stim)/2]; stimf = [stimf, fliplr(stimf(2:end-1))];

[C,IA,IB] = intersect(respf,sgsf);
stimratio = respfft(IA)./sgsfft(IB);

%loglog(stimf,stimfft/max(stimfft(stimf>obj.params.freqstart & stimf<obj.params.freqstop))), hold on;
loglog(sgsf,sgsfft/max(sgsfft(sgsf>data(trial).freqstart & sgsf<data(trial).freqstop)),'b'), hold on;
loglog(respf,respfft/max(respfft(respf>data(trial).freqstart & respf<data(trial).freqstop)),'r'), hold on;
loglog(C,stimratio/max(stimratio(C>data(trial).freqstart & C<data(trial).freqstop/2)),'k'), hold on;

%line(obj.x,obj.sensorMonitor,'parent',ax2,'color',[0 0 1],'linewidth',1);
box off; set(gca,'TickDir','out');
xlim([data(trial).freqstart data(trial).freqstop*.95])
