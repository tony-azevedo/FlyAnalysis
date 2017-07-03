function trial = skootchExposureNFramesRegardless(trial,varargin)


figure
N = size(trial.roitraces,1);
exp=postHocExposure(trial,N);
t = makeInTime(trial.params);
frame_times = t(exp.exposure);
plot(t,exp.exposure);hold on
plot(frame_times,trial.roitraces);
xlim([-5*(mean(diff(frame_times))) 2*(mean(diff(frame_times)))])


shift = inputdlg('Skootch #','',1,{'0'});
shift = str2double(shift{1});
if shift>10
    error('Choose a reasonable factor')
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

