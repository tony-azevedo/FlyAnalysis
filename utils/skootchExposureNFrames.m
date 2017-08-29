function trial = skootchExposureNFrames(trial,varargin)

if isfield(trial,'clustertraces');
    tn = 'clustertraces';
else
    tn = 'roitraces';
end

figure

% This is the number of frames that are in the movie. But it assumes that
% the clustering or roi tracing is done on all the frames. Not necessarily
% true, going to make it true in the future, no frame roi for the avi
% analysis.

N = size(trial.(tn),1);
exp=postHocExposure(trial,N);
t = makeInTime(trial.params);
frame_times = t(exp.exposure);
plot(frame_times,trial.(tn));hold on
l_ = frame_times>=-7*(mean(diff(frame_times))) & frame_times<=3*(mean(diff(frame_times)));
ylims = [min(min(trial.(tn)(l_,:))) max(max(trial.(tn)(l_,:)))];
axis('tight')

plot(t,diff(ylims)*exp.exposure+min(ylims));
xlim([-8*(mean(diff(frame_times))) 7*(mean(diff(frame_times)))])
set(gca,'ylim',ylims);


shift = inputdlg('Skootch #','',1,{'0'});
shift = str2double(shift{1});
if shift>10
    error('Choose a reasonable factor')
end
if shift<=0
    fprintf('Nice! No shift\n')
    return
end

% What happens if the trial has already been skootched?
exp=postHocExposure(trial,N+shift);
exp.exposure(find(exp.exposure,shift,'first')) = 0;

% frame times may have fewer samples than the saved roi data
frame_times = t(exp.exposure);
exp_in_trial = min([size(trial.(tn),1),length(frame_times)]);
plot(frame_times(1:exp_in_trial),trial.(tn)(1:exp_in_trial,:));

button = questdlg('Skootch ok?','ROI','No');
if ~strcmp(button,'Yes')
    error('try again')
end


trial.exposure_raw = trial.exposure;
trial.exposure = exp.exposure;

save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

close(gcf);