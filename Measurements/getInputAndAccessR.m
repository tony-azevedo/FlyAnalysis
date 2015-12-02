function [Ri,Rs,varargout] = getInputAndAccessR(trial)

h = getShowFuncInputsFromTrial(trial);

Ri_map = nan(length(h.prtclData),2);
Rs_map = Ri_map;
Ri2_map = Ri_map;

for i = 1:length(h.prtclData)
    trl = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(i).trial)));   
    [inputRes_Est1,inputRes_Est2,accessRes_Est1,sealRes_Est1,fig] = calculateSealMeasurements(trl,trl.params);
    
    Ri_map(i,:) = [h.prtclData(i).trial,inputRes_Est1];
    Ri2_map(i,:) = [h.prtclData(i).trial,inputRes_Est2];
    Rs_map(i,:) = [h.prtclData(i).trial,accessRes_Est1];
    
    % keyboard
    
end

Ri = mean(Ri_map(:,2));
Rs = mean(Rs_map(:,2));

varargout = {Ri_map,Rs_map, mean(Ri2_map(:,2)),Ri2_map};