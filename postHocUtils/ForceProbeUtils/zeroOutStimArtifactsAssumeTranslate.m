%function zeroOutStimArtifactsAssumeTranslate(trial)
%% Assume that the light transient gives a constant offset
% and that it takes one or two frames for the bar to move

if ~isfield(trial.forceProbeStuff,'CoM')
    error('trial doesnt have a center of mass vector, problem')
end
h2 = postHocExposure(trial,length(trial.forceProbeStuff.CoM));
t = makeInTime(trial.params);
ft = t(h2.exposure);

fps = trial.forceProbeStuff;

if contains(trial.params.protocol,'Train')
    pre_idx = zeros(1,trial.params.nrepeats);
    post_idx = pre_idx;
    for fl = 1:length(pre_idx)
        flt = (fl-1)*trial.params.cycleDurInSec;
        pre_idx(fl) = find(ft<flt,1,'last');
        flt = flt+trial.params.flashDurInSec;
        post_idx(fl) = find(ft>flt,1,'first');
    end
elseif contains(trial.params.protocol,'EpiFlash')
    pre_idx = find(ft<0,1,'last');
    post_idx = find(ft>trial.params.stimDurInSec,1,'first');
end
origin_idx = find(fps.EvalPnts(1,:)==0&fps.EvalPnts(2,:)==0);
x_hat = fps.EvalPnts(:,origin_idx+1);

%% Calculate pretrial mean and var for noise later
mu = mean(fps.CoM(ft<0&ft>-6*diff(ft(1:2))));
sigma = std(fps.CoM(ft<0&ft>-6*diff(ft(1:2))));

%%

% go through the movie around this point
for i = 1:length(pre_idx)
    % skip this flash if the bar is moving too quickly
    if contains(trial.params.protocol,'Train')
        if abs((fps.CoM(pre_idx(i)) - fps.CoM(pre_idx(i)-1))) > sigma*5
            continue
        end
        if abs((fps.CoM(post_idx(i)+1) - fps.CoM(post_idx(i)))) > sigma*5
            continue
        end
    end
    
    [~,offset] = max(abs(fps.CoM(pre_idx(i))-fps.CoM(pre_idx(i)+1:pre_idx(i)+3)));
    offset_pre = fps.CoM(pre_idx(i)+offset)-fps.CoM(pre_idx(i));
    
    fps.CoM(pre_idx(i) + 1:post_idx(i) - 1) = fps.CoM(pre_idx(i)+1:post_idx(i)-1)-offset_pre;
    
    % there are still two transients left. smooth
    fps.CoM(pre_idx(i)+1) = normrnd(median(fps.CoM([pre_idx(i) pre_idx(i)+2])),sigma/2);
    fps.CoM(post_idx(i)) = normrnd(median(fps.CoM([post_idx(i)-1 post_idx(i)+1])),sigma/2);

    for idx = [pre_idx(i)+1:post_idx(i)+1]
        newcom_xy = (fps.CoM(idx)-origin_idx)*x_hat;
        fps.forceProbePosition(:,idx) = newcom_xy;
    end
    
end
    
trial.forceProbeStuff.CoM = fps.CoM;
trial.forceProbeStuff.forceProbePosition = fps.forceProbePosition;
fprintf('LED artifact: Saving trial %s\n',trial.name);
save(trial.name, '-struct', 'trial')
    
