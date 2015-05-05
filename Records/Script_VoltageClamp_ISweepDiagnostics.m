% Script_VoltageClamp_SweepDiagnostics

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,Dir,trialStem,dfile] = ...
    extractRawIdentifiers(VClamptrial.name);

data = load(dfile); data = data.data;

Vtrials = findLikeTrials('name',VClamptrial.name,'datastruct',data);

x = makeInTime(VClamptrial.params);
current = zeros(sum(x>p_p),length(Vtrials));

for it_ind = 1:length(Vtrials)
    VClamptrial = load([Dir sprintf(trialStem,Vtrials(it_ind))]);
    
    current_temp = VClamptrial.current;
    current(:,it_ind) = current_temp(x>p_p);
end

x = x(x>p_p)-p_p;

plot(ax_trace,x,current(:,1),'color',dark_colr);
xlabel(ax_trace,'s');
ylabel(ax_trace,'pA');

x_cor_mean_curr = [];
for it_ind = 1:length(Vtrials)
    [xcor, lags] = xcorr(current(:,it_ind)-mean(current(:,it_ind)),'unbiased');
    % plot(ax_corr,lags/VClamptrial.params.sampratein,xcor,'color',light_colr);
    if isempty(x_cor_mean_curr)
        x_cor_mean_curr=xcor;
    else
        x_cor_mean_curr = x_cor_mean_curr+xcor;
    end
end
x_cor_mean_curr = x_cor_mean_curr/length(Vtrials);
plot(ax_corr,lags/VClamptrial.params.sampratein,x_cor_mean_curr,'color',dark_colr);
xlabel(ax_corr,'s');
ylabel(ax_corr,'pA^2');
xlim(ax_corr,[-0.01 .04])

% lags = lags/VClamptrial.params.sampratein;
% [pks,locs] = findpeaks(x_cor_mean_curr(lags>=0&lags<.04),'MINPEAKDISTANCE',0.0005*VClamptrial.params.sampratein);%,lags(lags>-.001&lags<.04));
% lag_loc = lags(lags>0&lags<.04);
% plot(ax_peak,lag_loc(locs(1:min(20,length(locs)))),1:min(20,length(locs)),'.','color',dark_colr,'linestyle','none')
% xlim(ax_peak,[0 .04])
