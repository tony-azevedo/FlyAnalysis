function ft = dFoverF_bgcorr_trace(trial)
exp_t = trial.exposure_time;

if sum(exp_t<0)
    bsln = exp_t<0 & exp_t>exp_t(1)+.02;
else
    bsln = exp_t<1 & exp_t>exp_t(1)+.02;
end

numerator = trial.roiFluoTrace - trial.backGroundTrace;
denominator = nanmean(numerator(bsln));

ft = 100 * (numerator/denominator - 1);
