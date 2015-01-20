obj.trial = trial;
[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

% Bring up the quickShow_sweep Fig
figure
if backgroundCorrectionFlag
    quickShow_Sweep(gcf,obj,'No Save','BGCorrectImages',true);
else
    quickShow_Sweep(gcf,obj,'No Save','BGCorrectImages',false);
end

dfofax = findobj(gcf,'tag','quickshow_dFoverF_ax');
dFtrace = get(findobj(dfofax,'type','line'),'ydata');

% Find the Break-in point
t = makeInTime(trial.params);
current = trial.current(1:length(t));
baseline = t<.5;
current_baseline_std = std(trial.current(baseline));
threshold = 10;

switch analysis_cell(c_ind).name
    case '140206_F1_C1'
        break_in = 595501;
    case '140602_F1_C1'
        break_in = 56500;
    case '140602_F2_C1'
        break_in = 89205;
    otherwise
        break_in = find(abs(current-current_baseline_std) > threshold*current_baseline_std,1);
end

commandvoltage(c_ind) = mean(trial.voltage(t<break_in)); %#ok<SAGROW>
deltaT = t(break_in);
breakinDeltaT(c_ind) = deltaT;

% Change the time base (exposure time and t);
et = trial.exposure_time-deltaT;
t = t-deltaT;

% The exposures are within 20 ms of break-in
% This is regardless of sampling rate
frame_window = et >= -dT_exposure_window & et <= dT_exposure_window;
et_window = et(frame_window);
et_window = et_window(:);
frame_window = find(frame_window);

figure(gcf)
subplot(3,1,1), hold on
plot(t+deltaT,ones(size(t)) * threshold*current_baseline_std,'k:');
plot(t+deltaT,ones(size(t)) * -threshold*current_baseline_std,'k:');

if backgroundCorrectionFlag
    breakin_dF = dFoverF_bgcorr_trace(obj.trial);
else
    breakin_dF = dFoverF_withbg_trace(obj.trial);
end

% Fit a line to baseline and an exponential to the decay.  Subtract off the decay from the initial points
coef = [-40, 40,3];
exp_base = et(et>0 & et<4);

[exp_coeffout(c_ind,:),resid,jacob,covab,mse] = nlinfit(...
    exp_base(:)',...
    breakin_dF(et>0 & et<4),...
    @exponential,coef); %#ok<SAGROW>
parci = nlparci(exp_coeffout(c_ind,:),resid,'jacobian',jacob);

base_base = et(et>-.5 & et<0);
base_coeffout(c_ind,:) = polyfit(...
    base_base(:)',...
    breakin_dF(et>-.5 & et<0),...
    1);
breakin_dF_model = [...
    base_coeffout(c_ind,1)*et_window(et_window <= 0) + base_coeffout(c_ind,2); ...
    exponential(exp_coeffout(c_ind,:),et_window(et_window > 0))];

% Plot
subplot(3,1,2), hold on
plot(...
    et(et>-.5 & et<0)+deltaT,...
    base_coeffout(c_ind,1)*et(et>-.5 & et<0) + base_coeffout(c_ind,2));
plot(...
    et(et>-.5 & et<0)+deltaT,...
    breakin_dF(et>-.5 & et<0),'m');

subplot(3,1,2), hold on
plot(...
    et(et>0)+deltaT,...
    exponential(exp_coeffout(c_ind,:),et(et>0)));
plot(...
    et(et>0)+deltaT,...
    breakin_dF(et>0),'g');


breakin_dF = breakin_dF(frame_window);
breakin_dF_traces(c_ind,:) = breakin_dF; %#ok<SAGROW>

detrend = breakin_dF(:);
detrend(et_window <= 0) = ... % detrend baseline
    detrend(et_window <= 0) - ...
    breakin_dF_model(et_window <= 0);
detrend(et_window <= 0) = ... % add back final baseline point
    detrend(et_window <= 0) + ...
    repmat(breakin_dF_model(find(et_window<=0,1,'last')),size(et_window(et_window <= 0)));
detrend(et_window > 0) = ... % detrend baseline
    detrend(et_window > 0) - ...
    breakin_dF_model(et_window > 0);
detrend(et_window > 0) = ... % add back final baseline point
    detrend(et_window > 0) + ...
    repmat(breakin_dF_model(find(et_window>0,1,'first')),size(et_window(et_window > 0)));

breakin_dF_detrended(c_ind,:) = detrend;
breakin_dF_dF_detrended(c_ind,:) = detrend-mean(detrend(et_window<=0),1);

breakin_dF_model_traces(c_ind,:) = breakin_dF_model' - breakin_dF_model(find(et_window<=0,1,'last')); %#ok<SAGROW>
breakin_dF_dF(c_ind,:) = breakin_dF - mean(breakin_dF(et_window<=0)); %#ok<SAGROW>
breakin_exposure_time_windows(c_ind,:) = et_window; %#ok<SAGROW>

eval(['export_fig ', ...
    [savedir ['break-in_long_',dateID,'_',flynum,'_',cellnum]],...
    ' -pdf -transparent'])

axs = findobj(gcf,'type','axes');
for ax = axs'
    %ax
    set(ax,'xlim',[et_window(1)+deltaT   et_window(end)+deltaT]);
end
set(dfofax,'ylim',[min(dFtrace(frame_window)), max(dFtrace(frame_window))]);

eval(['export_fig ', ...
    [savedir ['break-in_',dateID,'_',flynum,'_',cellnum]],...
    ' -pdf -transparent'])