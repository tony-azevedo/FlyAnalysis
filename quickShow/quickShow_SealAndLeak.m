function quickShow_SealAndLeak(plotcanvas,obj,savetag)

x = makeInTime(obj.trial.params);
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));

stim = zeros(2*obj.params.pulses,obj.params.stepdur*obj.params.sampratein);
stim(1:2:2*obj.params.pulses,:) = 1;
stim = stim';
stim = stim(:);

stim = stim * obj.params.stepamp;

ax1 = subplot(3,1,3,'parent',plotcanvas);
line(x,voltage,'parent',ax1,'color',[1 0 0],'linewidth',1,'tag',savetag);
line(x,stim,'parent',ax1,'color',[.8 .8 .8],'linewidth',1,'tag',savetag);
box off; set(gca,'TickDir','out'); axis tight;
xlabel('Time (s)'); xlim([x(1) x(end)]);
ylabel('mV'); %xlim([0 max(t)]);

ax2 = subplot(3,1,[1 2],'parent',plotcanvas);
line(x,current,'parent',ax2,'color',[1 0 0],'linewidth',1,'tag',savetag);
box off; set(gca,'TickDir','out'); axis tight;
xlabel('Time (s)'); xlim([x(1) x(end)]); 
ylabel('pA'); %xlim([0 max(t)]);
                        