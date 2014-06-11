function ft = dFoverF_withbg_trace(trial)
% see also dFoverF_trace
exp_t = trial.exposure_time;

if sum(exp_t<0)
    bsln = exp_t<0 & exp_t>exp_t(1)+.02;
else
    bsln = exp_t<1 & exp_t>exp_t(1)+.02;
end

ft = 100 * (trial.roiFluoTrace/nanmean(trial.roiFluoTrace(bsln)) - 1);
