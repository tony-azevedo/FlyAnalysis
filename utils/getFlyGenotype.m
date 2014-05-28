function g = getFlyGenotype(s)

[fname,D] = strtok(fliplr(s),'\');
fname = fliplr(fname);
D = regexprep(fliplr(D(2:end)),'Acquisition','Raw_Data');
acq = dir(fullfile(D,'Acquisition*'));
if length(acq) == 0
    g = '';
    return
end    
acq = load(fullfile(D,acq(1).name));
g = acq.acqStruct.flygenotype;
