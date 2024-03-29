%% Script_Process_ParamTable_ForceProbeMat


%% Create a parameter table for each cell.

CellID = T_Reach.CellID;
cidx = 1;
T_row = T_Reach(cidx,:);

cid = CellID{cidx};
fprintf('Starting %s\n',cid);

% Dir = fullfile('F:\Acquisition\',cid(1:6),cid);
Dir = fullfile('D:\Data',cid(1:6),cid);

cd(Dir);

trialStem = [T_row.Protocol{1} '_Raw_' cid '_%d.mat'];

%% Create param table
tablefile = fullfile(Dir,[T_Reach.Protocol{cidx} '_' cid '_Table.mat']);
T_params = loadtable(tablefile); 
if ~any(contains(T_params.Properties.VariableNames,'excluded'))
    T_params = add2table_ExcludeFlag(T_params);
end
fprintf('Excluded trials:\n')
exctrls = T_params.trial(logical(T_params.excluded));
disp(exctrls')

if ~any(contains(T_params.Properties.VariableNames,'arduino_duration'))
    T_params = add2table_ArduinoDuration(T_params);
    T_params = excludeEmptyControlTrials(T_params);
end
if ~any(contains(T_params.Properties.VariableNames,'target1'))
    T_params = add2table_TargetLocation(T_params);
end
    
trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(T_params.trial(1)) '.mat']));

%% Load the processed table

measuretblname = fullfile(Dir,[T_Reach.Protocol{cidx} '_' cid '_MeasureTable.mat']);
if exist(measuretblname,'file')
    T = loadtable(measuretblname);
    [~,~,~,~,~,~,trialStem] = extractRawIdentifiers(measuretblname);
    
    T.Properties.UserData.trialStem = trialStem;
    T.Properties.UserData.Dir = Dir;
else
    T = [];
end

