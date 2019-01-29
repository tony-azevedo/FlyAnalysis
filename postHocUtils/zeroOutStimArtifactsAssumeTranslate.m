%function zeroOutStimArtifactsAssumeTranslate(trial)
%% Assume that the light transient gives a constant offset
% and that it takes one or two frames for the bar to move

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

%% Calculate pretrial mean and var for noise later
mu = mean(fps.CoM(ft<0&ft>-6*diff(ft(1:2))));
sigma = std(fps.CoM(ft<0&ft>-6*diff(ft(1:2))));

%%

% go through the movie around this point
[~,offset] = max(abs(diff(fps.CoM(pre_idx:pre_idx+3))));
offset_pre = fps.CoM(pre_idx+offset)-fps.CoM(pre_idx);

fps.CoM(pre_idx+1:post_idx-1) = fps.CoM(pre_idx+1:post_idx-1)-offset_pre;

% there are still two transients left. fill in
fps.CoM(pre_idx+1) = normrnd(median(fps.CoM([pre_idx pre_idx+2])),sigma/1.5); 
fps.CoM(post_idx) = normrnd(median(fps.CoM([post_idx-1 post_idx+1])),sigma/1.5); 

for idx = [pre_idx+1:post_idx+1]
    newcom_xy = (fps.CoM(idx)-origin_idx)*x_hat;
    fps.forceProbePosition(:,idx) = newcom_xy;
end
    
trial.forceProbeStuff.CoM = fps.CoM;
trial.forceProbeStuff.forceProbePosition = fps.forceProbePosition;
fprintf('LED artifact: Saving trial %s\n',trial.name);
save(trial.name, '-struct', 'trial')
    
