function [T,bT,fp,fp_time,T_params] = loadTableAndFPMatrix(CellID)
Dir = fullfile('F:\Acquisition\',CellID(1:6),CellID);

a = dir(fullfile(Dir,'*_MeasureTable.mat'));
measuretablestem = regexprep(a.name,CellID,'%s');
fpstem = regexprep(measuretablestem,'MeasureTable','ForceProbe');
paramTstem = regexprep(measuretablestem,'MeasureTable','Table');

T = load(fullfile(Dir,sprintf(measuretablestem,CellID)));
T = T.T;
fp = load(fullfile(Dir,sprintf(fpstem,CellID)));
fp_time = fp.forceProbeTime;
fp = fp.forceProbe;
T_params = load(fullfile(Dir,sprintf(paramTstem,CellID)));
T_params = T_params.T;

idx = ~T_params.excluded & ~isnan(T_params.arduino_duration);
fp = fp(:,idx);

bT = getBlockTable(T);

