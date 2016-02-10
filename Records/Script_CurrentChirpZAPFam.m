function varargout = Script_CurrentChirpZAPFam(handles)

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);

x = makeTime(handles.trial.params);
xwin = x>=0+handles.trial.params.ramptime & x< handles.trial.params.stimDurInSec -handles.trial.params.ramptime;

y = zeros(length(x),length(trials));
u = CurrentChirpStim(handles.trial.params);
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.voltage;
end
y = mean(y,2);

y = y - mean(y);
u = u - mean(u(x<=0));

% ZAP calculation
Z = fft(y(xwin)) ./ fft(u(xwin));
f = trial.params.sampratein/length(x(xwin))*[0:length(x(xwin))/2]; f = [f, fliplr(f(2:end-1))];

Z_mag = real(abs(Z.*conj(Z)));
Z_phase = angle(Z);

f_ = f(1:length(f)/2);
Z_phase_ = Z_phase(1:length(f)/2)/(2*pi)*360;

freqBins = 2:1.8:handles.trial.params.freqEnd;
freqBins = sort(freqBins);
fsampled = freqBins(1:end-1);
Z_mag_sampled = freqBins(1:end-1);
Z_phase_sampled = freqBins(1:end-1);
for fb = 1:length(freqBins)-1
    f_wind = f >= freqBins(fb) & f<freqBins(fb+1);
    f_wind_ = f_ >= freqBins(fb) & f_<freqBins(fb+1);
    fsampled(fb) = mean(f(f_wind));
    Z_mag_sampled(fb) = mean(Z_mag(f_wind));
    Z_phase_sampled(fb) = mean(Z_phase_(f_wind_));
end

varargout = {Z,f,x,y,u,fsampled,Z_mag_sampled,Z_phase_sampled};
