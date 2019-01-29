function v = lowPassFilterMembraneVoltage(v,fs,d1)

if ~ischar(fs)
    fs = num2str(fs);
end
base = v(1);
v = filter(d1,v-base)+base;

% d1 = designfilt('lowpassiir','FilterOrder',12,'PassbandFrequency',3e3,'PassbandRipple',0.2,'SampleRate',10e3);