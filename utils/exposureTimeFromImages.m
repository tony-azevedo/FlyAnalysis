function varargout = exposureTimeFromImages(trial,imdir)

fprintf(1,'\t**Making exposure timeline from files: \n\t%s\n',imdir);
imagefiles = dir(fullfile(imdir,[trial.params.protocol '_Image_*']));

x = makeInTime(trial.params);
fs = trial.params.durSweep/length(imagefiles);
if fs > .01
    fs = round(fs*100)/100;
elseif fs > .001
    fs = round(fs*1000)/1000;
end
fprintf(1,'\t**Exposure time: %.3f s\n',fs);
exposure_time = 0.001 + (0:fs:trial.params.durSweep)+x(1); % frames start 1 ms after trial starts
exposure_time = exposure_time(1:length(imagefiles));

exposure = x;
exposure(:) = 0;

sampt = x(2)-x(1);
for t_ind = 1:length(exposure_time)
    find(x>exposure_time(t_ind)-5*eps & x<exposure_time(t_ind)+5*eps);
    exposure(...
        x>exposure_time(t_ind)-sampt/4 & x<exposure_time(t_ind)+sampt/4 ...
        ) = 1;
end
exposure = logical(exposure);
varargout = {exposure_time,exposure};