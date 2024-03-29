function T = cleanUpMeasureTable(T) % get rid of any trials that are excluded

measuretablename = T.Properties.Description;
T
T_params_new = load(regexprep(measuretablename,'Measure','')); 
T_params_new = T_params_new.T;
excludedTrialSet = T_params_new.trial(logical(T_params_new.excluded));

[trials2cleanout,IA,IB] = intersect(excludedTrialSet,T.trial);
if isempty(trials2cleanout)
    fprintf('Measurement trial is already cleaned out!\n');
    save(T.Properties.Description,'T')
    fprintf('Writing cleaned out trial\n');
end
fprintf('Cleaning out trials: \n');
disp(T.trial(IB));

[fig] = plotChunkOfLongTrials(T(IB,:),'Cleaned out trials');%,fplims);

idx = ~ismember(T.trial,trials2cleanout);

T = T(idx,:);

save(T.Properties.Description,'T')
fprintf('Writing cleaned out trial\n');