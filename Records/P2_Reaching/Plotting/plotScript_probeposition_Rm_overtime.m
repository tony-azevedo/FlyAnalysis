figure
plot(T.trial,T.Vm_Delta/-5)
hold on
plot([T.trial(1) T.trial(end)],[1 1]*mean(T.Vm_Delta)/-5)
text(T.trial(1)+50,1,sprintf('%d Gohm',mean(T.Vm_Delta)/-5),'VerticalAlignment','bottom')
ylabel('R_m (G\Omega)')
xlabel('Trial #')
title(regexprep(cid,'_','\\_'))

figure
subplot(2,1,1)
plot(T.trial,-T.probe_position_init)
hold on
plot(T.trial(T.outcome==1),-T.probe_position_init(T.outcome==1),'.')
ylabel('Initial Probe (flipped)')
title(regexprep(cid,'_','\\_'))

subplot(2,1,2)
plot(T.trial,T.Vm_pretrial)
hold on
plot(T.trial(T.outcome==1),T.Vm_pretrial(T.outcome==1),'.')
ylabel('Initial Vm (mV)')
xlabel('Trial #')

