%% Script_MeasurePrePostStimMovement
DEBUG = 0;
fprintf('Measuring force probe stimulus movement\n')
if any(contains(T.Properties.VariableNames,'rms_trial_mvmt')) || ...
    any(contains(T.Properties.VariableNames,'cue_mvmt')) || ...
    any(contains(T.Properties.VariableNames,'var_mvmt'))
    error('Delete rms_trial_mvmt, cue_mvmt, and var_mvmt variables')
end

fprintf('Measuring voltage responses to mechanical cue\n')

%% Measure movement in trials

ft_0i = ft(1:end-1)<=0 & ft(2:end)>0;
trial_f_init = zeros(size(T.arduino_duration));
rms_trial_mvmt = trial_f_init;
pre_trial_mvmt = rms_trial_mvmt;
var_trial_mvmt = rms_trial_mvmt;

if DEBUG
   f = figure;
   f.Position = [60 558 1679 420];
   ax = subplot(1,1,1); ax.NextPlot = 'add';
   text(ax,0,20,'rms = ');
end
for tr = 1:size(T,1)
    % fprintf('Trial %d: \t',T.trial(tr));
    
    T_row = T(tr,:);
    trial_f_init(tr) = fp(ft_0i,tr);

    y = fp(:,tr);

    % how much probe movement from perturbation?
    ft_premech_idx = find(ft<-(T_row.cueDelayDurInSec + T_row.cueStimDurInSec),1,'last');
    ft_endmech_idx = find(ft<-(T_row.cueDelayDurInSec + T_row.cueRampDurInSec),1,'last');
    f_premech = mean(y(ft_premech_idx+(-2:0)));
    f_mech = mean(y(ft_endmech_idx+(-20:0)));
    pre_trial_mvmt(tr) = f_mech-f_premech; % positive is extension
    
    % how much probe movement during trial?
    baseline = mean(y(ft>-(T_row.cueStimDurInSec) & ft<0));
    if T_row.outcome >=5
        fprintf('Trial %d is long \n',T_row.trial);
        trial = load(fullfile(Dir,sprintf(trialStem,T_row.trial)));
        x = cat(1,makeInTime(trial.params),makeInterTime(trial));
        y_ = cat(2,trial.probe_position,trial.intertrial.probe_position);
        rms_trial_mvmt(tr) = sqrt(mean((y_(x>0)-baseline).^2));
        rms_short = sqrt(mean((y_(x>0&x<=ft(end))-baseline).^2));
        var_trial_mvmt(tr) = var(y(ft>0));
        if DEBUG
            cla(ax)
            plot(ax,ft,fp(:,tr));
            plot(ax,x,y_);
            plot(ax,[ft(1) ft(ft_0i)],baseline*[1 1]);
            plot(ax,[x(1) x(end)],(baseline+rms_trial_mvmt(tr))*[1 1]);
            ax.XLim = [x(1),x(end)];
            str = {
                ['long rms = ', num2str(rms_trial_mvmt(tr)), ' vs. dwnsmpl rms = ', num2str(sqrt(mean((y(ft>0)-baseline).^2)))]
                ['short rms = ', num2str(rms_short), ' vs. dwnsmpl rms = ', num2str(sqrt(mean((y(ft>0)-baseline).^2)))]
                };
            text(ax,0,baseline+rms_trial_mvmt(tr),str,'VerticalAlignment','bottom');
            pause
        end
    else 
        rms_trial_mvmt(tr) = sqrt(mean((y(ft>0)-baseline).^2));
        var_trial_mvmt(tr) = var(y(ft>0));
    end
end

T.rms_mvmt = rms_trial_mvmt;
T.cue_mvmt = pre_trial_mvmt;
T.var_mvmt = var_trial_mvmt;

save(T.Properties.Description,'T')
fprintf('Done measuring force probe stimulus movement\n')
