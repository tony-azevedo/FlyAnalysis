% load the trace you want to show
trace = 2;
obj.y = current;
% load data from folder

t = (1:data(trace).durSweep*data(trace).sampratein)/data(trace).sampratein;
obj.x = t;
pre = round(9/10000*data(trace).sampratein);

%%

a = gradient(obj.y);
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

pulse_t = obj.x(ind(1)-pre+1:ind(1)+deltax)-obj.x(ind(1));
pulse_t = pulse_t(:);
mat = nan(deltax+pre,length(ind));
for i = 1:length(ind)
    mat(:,i) = obj.y(ind(i)-pre+1:ind(i)+deltax);
end
if data(trace).sampratein <= 10000
    pulse_t = obj.x(ind(1)-(pre-1)+1:ind(1)+deltax)-obj.x(ind(1));
    pulse_t = pulse_t(:);
    
    diffmat = diff(mat);
    for i = 1:length(ind)
        rise = find(diffmat(1:(pre*8),i)==max(diffmat(1:(pre*8),i)));
        diffmat(:,i) = mat(rise-pre+1:rise+deltax,i);
        %RCtau = nlinfit(obj.x
    end
else
    diffmat = mat;
end

figure(1);
plot(pulse_t,diffmat,'color',[1 .7 .7])
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

RCcoeff = Icoeff; RCcoeff(1:2) = 0.005./(RCcoeff(1:2)*1e-12); % 5 mV step/I_i or I_f
line(pulse_t,pulseresp+base,'color',[.7 0 0],'linewidth',1);
box off; set(gca,'TickDir','out');
line(pulse_t(pulse_t>start & pulse_t<finit),...
    exponential(Icoeff,pulse_t(pulse_t>start & pulse_t<finit))+base,...
    'color',[.7 0 0],'linewidth',3);
ylims = get(gca,'ylim');
text(0.001, base+.9*(max(ylims)-base),sprintf('Ri=%.2e, Rs=%.2e, Cm = %.2e',RCcoeff(1),RCcoeff(2),RCcoeff(3)/RCcoeff(2)));
switch data(trace).recmode
    case 'VClamp'
        ylabel('I (pA)'); %xlim([0 max(t)]);
    case 'IClamp'
        ylabel('V_m (mV)'); %xlim([0 max(t)]);
end
xlim([-0.0005 finit]);
xlabel('Time (s)'); %xlim([0 max(t)]);
varargout = {RCcoeff(1),RCcoeff(2),RCcoeff(3)/RCcoeff(2)};
title(sprintf('%s - fly %s; Cell %s\n%s',data(trace).date,data(trace).flynumber,data(trace).cellnumber,data(trace).flygenotype))
