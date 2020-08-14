% There is usually a current injection at the beginning of the Epiflash
% trials. Use this to measure input resistance.

CellID = T.CellID;
Protocol = T.Protocol;
Trials = T.Trialnums;
R_pulse = T.R_pulse;
cellsvnippets = nan(length(CellID),5000);
cellsinippets = nan(length(CellID),5000);
for cidx = 1:length(CellID)
    cid = CellID{cidx};
    if isempty(Trials{strcmp(CellID,cid)})
        fprintf('No trials\n')
        continue
    end
    Dir = fullfile('E:\Data',cid(1:6),cid);
    cd(Dir)
    trnums = Trials{cidx};
    trial = fullfile(Dir,[Protocol{cidx} '_Raw_' cid '_' num2str(trnums(1)) '.mat']);

    [~,~,~,~,~,~,trialStem] = extractRawIdentifiers(trial);
    
    R = nan(size(trnums));
    isnippets = nan(length(trnums),5000);
    vsnippets = nan(length(trnums),5000);
    for cnt = 1:length(trnums)
        tr_idx = trnums(cnt);
        trial = load(sprintf(trialStem,tr_idx));
        if (isfield(trial,'excluded') && trial.excluded) || trial.params.sampratein < 50000
            fprintf('Short samp rate\n')
            continue;
        end
        t = makeInTime(trial.params);
        if strcmp(trial.params.protocol,'Sweep2T')
            isnippets(cnt,:) = trial.current_1(t>=0&t<.01+.05+.04);
            stepamp = mean(trial.current_1(t>.01&t<.01+.05));
            stepamp = stepamp - mean(trial.current_1(t>.01+.05&t<.01+.05+.05));
            stepamp = stepamp*1E-12; % pA
            
            % slight delay (30 ms) in starting to measure voltage
            vsnippets(cnt,:) = trial.voltage_1(t>=0&t<.01+.05+.04);
            respamp = mean(trial.voltage_1(t>.01+.03&t<.01+.05));
            respamp = respamp - mean(trial.voltage_1(t>.01+.03+.05&t<.01+.05+.05));
            respamp = respamp*1E-3; % mV
        else
            isnippets(cnt,:) = trial.current_1(t>=-trial.params.preDurInSec&t<-trial.params.preDurInSec+.01+.05+.04);
            stepamp = mean(trial.current_1(t>-trial.params.preDurInSec+.01&t<-trial.params.preDurInSec+.01+.05));
            stepamp = stepamp - mean(trial.current_1(t>-trial.params.preDurInSec+.01+.05&t<-trial.params.preDurInSec+.01+.05+.05));
            stepamp = stepamp*1E-12; % pA
            
            % slight delay (30 ms) in starting to measure voltage
            vsnippets(cnt,:) = trial.voltage_1(t>=-trial.params.preDurInSec&t<-trial.params.preDurInSec+.01+.05+.04);
            respamp = mean(trial.voltage_1(t>-trial.params.preDurInSec+.01+.03&t<-trial.params.preDurInSec+.01+.05));
            respamp = respamp - mean(trial.voltage_1(t>-trial.params.preDurInSec+.01+.03+.05&t<-trial.params.preDurInSec+.01+.05+.05));
            respamp = respamp*1E-3; % mV
        end
        R(cnt) = respamp/stepamp;
    end
    cellsvnippets(cidx,:) = nanmean(vsnippets,1);
    cellsinippets(cidx,:) = nanmean(isnippets,1);
    R_pulse{cidx} = nanmean(R);
    clear R;
end
T.R_pulse = R_pulse;

Pulses.voltage = cellsvnippets;
Pulses.current = cellsinippets;
Pulses.cells = T.CellID;
Pulses.label = T.Cell_label;

%%

Pulses.voltage = cellsvnippets(~isnan(cellsvnippets(:,1)),:);
Pulses.current = cellsinippets(~isnan(cellsinippets(:,1)),:);
Pulses.cells = T.CellID(~isnan(cellsvnippets(:,1)));
Pulses.label = T.Cell_label(~isnan(cellsvnippets(:,1)));


%%
save('E:\Data\temp\iv_pulses_for_neuron','-struct','Pulses','-v7')
save('E:\Data\temp\iv_pulses_for_neuron_v7_3','-struct','Pulses','-v7.3')
