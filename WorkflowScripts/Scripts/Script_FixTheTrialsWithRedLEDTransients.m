%% Script_FixTheTrialsWithRedLEDTransients

fid = fopen(fullfile(D,'RedLEDArifact.txt'),'r');
S = fscanf(fid,'%s');
expression = 'B:\\Raw_Data\\';
[drives,filenms] = regexp(S,expression,'match','split');
filenms = filenms(2:end);
if length(drives)~=length(filenms)
    error('Error spliting red LED artifact file')
end

for flnm = 1:length(filenms)
    trial = load(fullfile(drives{flnm},filenms{flnm}));
    redLEDArtifactClickyCorrect(trial)
end
fclose(fid);
fclose('all');
clear fid
