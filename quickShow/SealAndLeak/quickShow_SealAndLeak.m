function quickShow_SealAndLeak(plotcanvas,obj,savetag)

x = ((1:obj.params.sampratein*obj.params.durSweep) - 1)/obj.params.sampratein;
voltage = obj.trial.voltage(1:length(x));
current = obj.trial.current(1:length(x));

% number of samples in a pulse
% chop y down
ppnts = obj.params.stepdur*obj.params.samprateout;
x = x(ppnts+1:end);
x = x(1:2*ppnts);

y = current;
base = mean(y(1:ppnts));
y = y(ppnts+1:end);
y = reshape(y,2*ppnts,obj.params.pulses);

y_bar = mean(y,2) - base;

stim = voltage;
stim = stim(ppnts+1:end);
stim = reshape(stim,2*ppnts,obj.params.pulses);

stim_bar = mean(stim,2);

% R = V/I(at end of step);
sealRes_Est1 = obj.params.stepamp/1000 / (y_bar(ppnts)*1e-12);
            
start = x(10);
finit = x(ppnts); %s
pulse_t = x(x>start & x<finit);
% TODO: handle the warnings
Icoeff = nlinfit(...
    pulse_t - pulse_t(1),...
    y_bar(x>start & x<finit)',...
    @exponential,...
    [max(y_bar)/3,max(y_bar),obj.params.stepdur]);
RCcoeff = Icoeff; RCcoeff(1:2) = obj.params.stepamp/1000 ./(RCcoeff(1:2)*1e-12); % 5 mV step/I_i or I_f

sealRes_Est2 = RCcoeff(1);

ax1 = subplot(3,1,3,'parent',plotcanvas);
plot(x,stim,'parent',ax1,'color',[0 0 1],'linewidth',1,'tag',savetag);
line(x,stim_bar,'parent',ax1,'color',[.7 0 0],'linewidth',1,'tag',savetag);
box off; set(gca,'TickDir','out');
xlabel('Time (s)'); xlim([x(1) x(end)]);
ylabel('mV'); %xlim([0 max(t)]);

ax2 = subplot(3,1,[1 2],'parent',plotcanvas);
plot(x,y,'parent',ax2,'color',[1 .7 .7],'linewidth',1,'tag',savetag); hold on
line(x,y_bar+base,'parent',ax2,'color',[.7 0 0],'linewidth',1,'tag',savetag);
line(x(x>start & x<finit),...
    exponential(Icoeff,pulse_t-pulse_t(1))+base,...
    'color',[0 1 1],'linewidth',1,'tag',savetag);

box off; set(gca,'TickDir','out');
xlabel('Time (s)'); xlim([x(1) x(end)]);
ylabel('pA'); %xlim([0 max(t)]);
                        
% write the value in the comments, make a guess based on value
% whether it's electrode, seal, CA, whole cell resistance, just
% for a checks
if sealRes_Est2<100e6
    guess = '''trode';
elseif sealRes_Est2<100e6
    guess = 'Cell-Attached';
elseif sealRes_Est2<4e9
    guess = 'Whole-Cell';
else
    guess = 'Seal';
end

str = sprintf('R (ohms): \n\test 1 (step end) = %.2e; \n\test 2 (exp fit) = %.2e; \n\tGuessing: %s',...
    sealRes_Est1,...
    sealRes_Est2,...
    guess);
