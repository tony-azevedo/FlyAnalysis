yyddmm = ac.name(1:6);
trial = load([fullfile('C:\Users\Anthony Azevedo\Raw_Data\',yyddmm,ac.name) '\PiezoSine_Raw_' ac.name '_1.mat']);  
h = getShowFuncInputsFromTrial(trial);

% VClamp
VClampCtrlSineTrial = [];

for didx = 1:length(h.prtclData)
    if isempty(h.prtclData(didx).tags)
        if ...
                isempty(VClampCtrlSineTrial) && ...
                strcmp(h.prtclData(didx).mode,'VClamp')
            
            excluded = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial)),'excluded');
            if ~isempty(fieldnames(excluded)) && excluded.excluded
                continue
            end
            VClampCtrlSineTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
        end
    end
end