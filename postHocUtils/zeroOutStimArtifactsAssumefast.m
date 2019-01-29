function zeroOutStimArtifactsAssumefast(trial)
%% This routine doesn't work if there is no probe CoM vector

if ~isfield(trial.forceProbeStuff,'CoM')
    error('trial doesnt have a center of mass vector, problem')
end
vid = VideoReader(trial.imageFile);
N = round(vid.Duration*vid.FrameRate);
h2 = postHocExposure(trial,N);
t = makeInTime(trial.params);
ft = t(h2.exposure);

fps = trial.forceProbeStuff;

pre_idx = find(ft<0,1,'last');
post_idx = find(ft>trial.params.stimDurInSec,1,'first');

origin_idx = find(fps.EvalPnts(1,:)==0&fps.EvalPnts(2,:)==0);
x_hat = fps.EvalPnts(:,origin_idx+1);

newfps = fps;

%% Calculate pretrial mean and var for noise later
mu = mean(fps.CoM(ft<0&ft>-12*diff(ft(1:2))));
sigma = std(fps.CoM(ft<0&ft>-12*diff(ft(1:2))));


%%

% go through the movie around this point
idx = pre_idx;
while idx < post_idx
    idx = idx+1;
    
    % Bar hasn't moved
    newcom = normrnd(mu,sigma/1.5);
    newcom_xy = (newcom-origin_idx)*x_hat;
    newfps.forceProbePosition(:,idx) = newcom_xy;
    newfps.CoM(idx) = newcom;
end

trial.forceProbeStuff = newfps;
fprintf('LED artifact: Saving trial %s\n',trial.name);
save(trial.name, '-struct', 'trial')
    
