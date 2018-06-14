function v = filterMembraneVoltage(v,fs)

if ~ischar(fs)
    fs = num2str(fs);
end
d1 = getacqpref('FlyAnalysis',['VoltageFilter_fs' fs]);
base = v(1);
v = filter(d1,v-base)+base;
