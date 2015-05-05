% Script_VoltageClamp_SweepDiagnostics

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,Dir,trialStem,dfile] = ...
    extractRawIdentifiers(IClamptrial.name);

data = load(dfile); data = data.data;

Itrials = findLikeTrials('name',IClamptrial.name,'datastruct',data);

x = makeInTime(IClamptrial.params);
voltage = zeros(sum(x>p_p),length(Itrials));

for it_ind = 1:length(Itrials)
    IClamptrial = load([Dir sprintf(trialStem,Itrials(it_ind))]);
    
    voltage_temp = IClamptrial.voltage;
    voltage(:,it_ind) = voltage_temp(x>p_p);
end

x = x(x>p_p)-p_p;

plot(ax_trace,x,voltage(:,1),'color',dark_colr);
xlabel(ax_trace,'s');
ylabel(ax_trace,'mV');

x_cor_mean_volt = [];
for it_ind = 1:length(Itrials)
    [xcor, lags] = xcorr(voltage(:,it_ind)-mean(voltage(:,it_ind)),'unbiased');
    % plot(ax_corr,lags/VClamptrial.params.sampratein,xcor,'color',light_colr);
    if isempty(x_cor_mean_volt)
        x_cor_mean_volt=xcor;
    else
        x_cor_mean_volt = x_cor_mean_volt+xcor;
    end
end
x_cor_mean_volt = x_cor_mean_volt/length(Itrials);
plot(ax_corr,lags/IClamptrial.params.sampratein,x_cor_mean_volt,'color',dark_colr);
xlabel(ax_corr,'s');
ylabel(ax_corr,'mV^2');
xlim(ax_corr,[-0.01 .04])

% lags = lags/IClamptrial.params.sampratein;
% [pks,locs] = findpeaks(x_cor_mean_volt(lags>=0&lags<.04),'MINPEAKDISTANCE',0.002*IClamptrial.params.sampratein);%,lags(lags>-.001&lags<.04));
% lag_loc = lags(lags>0&lags<.04);
% plot(ax_peak,lag_loc(locs(1:min(20,length(locs)))),1:min(20,length(locs)),'.','color',dark_colr,'linestyle','none')
% xlim(ax_peak,[0 .04])
