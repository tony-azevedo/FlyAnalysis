% There is usually a current injection at the beginning of the Epiflash
% trials. Use this to measure input resistance.

CellID = T.CellID;
Protocol = T.Protocol;
Trials = T.Trialnums;
R_pulse = T.R_pulse;
for cidx = 1:length(CellID)
    cid = CellID{cidx};
    if isempty(Trials{strcmp(CellID,cid)})
        continue
    end
    Dir = fullfile('E:\Data',cid(1:6),cid);
    cd(Dir)
    trnums = Trials{cidx};
    trial = fullfile(Dir,[Protocol{cidx} '_Raw_' cid '_' num2str(trnums(1)) '.mat']);

    [~,~,~,~,~,~,trialStem] = extractRawIdentifiers(trial);
    
    R = nan(size(trnums));
    for cnt = 1:length(trnums)
        tr_idx = trnums(cnt);
        trial = load(sprintf(trialStem,tr_idx));
        if isfield(trial,'excluded') && trial.excluded
            continue;
        end
        t = makeInTime(trial.params);
        if strcmp(trial.params.protocol,'Sweep2T')
            stepamp = mean(trial.current_1(t>.01&t<.01+.05));
            stepamp = stepamp - mean(trial.current_1(t>.01+.05&t<.01+.05+.05));
            stepamp = stepamp*1E-12; % pA
            
            % slight delay (30 ms) in starting to measure voltage
            respamp = mean(trial.voltage_1(t>.01+.03&t<.01+.05));
            respamp = respamp - mean(trial.voltage_1(t>.01+.03+.05&t<.01+.05+.05));
            respamp = respamp*1E-3; % mV
        else
            stepamp = mean(trial.current_1(t>-trial.params.preDurInSec+.01&t<-trial.params.preDurInSec+.01+.05));
            stepamp = stepamp - mean(trial.current_1(t>-trial.params.preDurInSec+.01+.05&t<-trial.params.preDurInSec+.01+.05+.05));
            stepamp = stepamp*1E-12; % pA
            
            % slight delay (30 ms) in starting to measure voltage
            respamp = mean(trial.voltage_1(t>-trial.params.preDurInSec+.01+.03&t<-trial.params.preDurInSec+.01+.05));
            respamp = respamp - mean(trial.voltage_1(t>-trial.params.preDurInSec+.01+.03+.05&t<-trial.params.preDurInSec+.01+.05+.05));
            respamp = respamp*1E-3; % mV
        end
        
        R(cnt) = respamp/stepamp;
    end
    R_pulse{cidx} = nanmean(R);
    clear R;
end
T.R_pulse = R_pulse;