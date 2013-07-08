function quickShow_SealAndLeakExternal(plotcanvas,obj,savetag)

x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));

pre = round(9/10000*obj.params.sampratein);

a = gradient(current);
aa = gradient(a);
pulseon_crit1 = a > max(a)/2;
pulseon_crit2 = aa < min(aa)/2;

pulseon = pulseon_crit1(1:end-1) & pulseon_crit2(2:end);
pulseon(end+1) = false;
pulseon = [0;diff(pulseon)];
pulseon = pulseon>0;

ind = find(pulseon);
deltax = min(diff(ind));
ind = ind(1:end-1);
if ind(1) <= pre
    ind = ind(2:end);
end

pulse_t = x(ind(1)-pre+1:ind(1)+deltax)-x(ind(1));
pulse_t = pulse_t(:);
mat = nan(deltax+pre,length(ind));
for i = 1:length(ind)
    mat(:,i) = current(ind(i)-pre+1:ind(i)+deltax);
end
if obj.params.sampratein <= 10000
    pulse_t = x(ind(1)-(pre-1)+1:ind(1)+deltax)-x(ind(1));
    pulse_t = pulse_t(:);
    
    diffmat = diff(mat);
    for i = 1:length(ind)
        rise = find(diffmat(1:(pre*8),i)==max(diffmat(1:(pre*8),i)));
        diffmat(:,i) = mat(rise-pre+1:rise+deltax,i);
        %RCtau = nlinfit(x
    end
else
    diffmat = mat;
end

pulseresp = mean(diffmat,2);
base = mean(pulseresp(1:6));
pulseresp = pulseresp-base;
start = .0002;
finit = .007; %s
Icoeff = nlinfit(...
    pulse_t(pulse_t>start & pulse_t<finit),...
    pulseresp(pulse_t>start & pulse_t<finit),...
    @exponential,...
    [pulseresp(1),max(pulseresp),0.004]);

ax1 = subplot(3,1,[1 2],'parent',plotcanvas);
plot(pulse_t,diffmat,'color',[1 .7 .7],'parent',ax1)
RCcoeff = Icoeff; RCcoeff(1:2) = 0.005./(RCcoeff(1:2)*1e-12); % 5 mV step/I_i or I_f
line(pulse_t,pulseresp+base,'color',[.7 0 0],'linewidth',1,'parent',ax1);
box off; set(gca,'TickDir','out');
line(pulse_t(pulse_t>start & pulse_t<finit),...
    exponential(Icoeff,pulse_t(pulse_t>start & pulse_t<finit))+base,...
    'color',[.7 0 0],'linewidth',3,'parent',ax1);
ylims = get(ax1,'ylim');
text(0.001, base+.9*(max(ylims)-base),sprintf('Ri=%.2e, Rs=%.2e, Cm = %.2e',RCcoeff(1),RCcoeff(2),RCcoeff(3)/RCcoeff(2)));
switch obj.params.recmode
    case 'VClamp'
        ylabel('I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        ylabel('V_m (mV)'); %xlim([0 max(t)]);
end
xlim([-0.0005 finit]);
xlabel(ax1,'Time (s)'); %xlim([0 max(t)]);
title(ax1,sprintf('%s - fly %s; Cell %s\n%s',obj.params.date,obj.params.flynumber,obj.params.cellnumber,obj.params.flygenotype))

ax2 = subplot(3,1,3,'parent',plotcanvas); 
line(x,current,'parent',ax2,'color',[0 0 1],'tag',savetag);
ylabel(ax2,'pA'); %xlim([0 max(t)]);
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
xlabel(ax2,'Time (s)'); %xlim([0 max(t)]);
