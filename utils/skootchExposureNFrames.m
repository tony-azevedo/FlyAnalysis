function trial = skootchExposureNFrames(trial,varargin)


figure
N = size(trial.roitraces,1);
exp=postHocExposure(trial,N);
t = makeInTime(trial.params);
frame_times = t(exp.exposure);
plot(frame_times,trial.roitraces);hold on
l_ = frame_times>=-7*(mean(diff(frame_times))) & frame_times<=3*(mean(diff(frame_times)));
ylims = [min(min(trial.roitraces(l_,:))) max(max(trial.roitraces(l_,:)))];
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

exp=postHocExposure(trial,N+shift);
exp.exposure(find(exp.exposure,shift,'first')) = 0;

frame_times = t(exp.exposure);
plot(frame_times(1:size(trial.roitraces,1)),trial.roitraces);

button = questdlg('Skootch ok?','ROI','No');
if ~strcmp(button,'Yes')
    error('try again')
end


trial.exposure_raw = trial.exposure;
trial.exposure = exp.exposure;

save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

close(gcf);