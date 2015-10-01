function newfig = PF_CurrentStepIV(pnl,obj,savetag)
% see also CurrentStepAverage

blocktrials = findBlockTrials(obj.trial,obj.prtclData);

x = makeInTime(obj.trial.params);

V_i = blocktrials;
V_p = blocktrials;
V_ss = blocktrials;
current = blocktrials;

for bt_ind = 1:length(blocktrials);
    obj.trial = load(fullfile(obj.dir,sprintf(obj.trialStem,blocktrials(bt_ind))));
    trials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData);
    voltage = zeros(size(x));
    for t_ind = 1:length(trials);
        trial = load(fullfile(obj.dir,sprintf(obj.trialStem,trials(t_ind))));
        voltage = voltage+trial.voltage(1:length(x));
    end 
    voltage = voltage/length(trials);
    current(bt_ind) = obj.trial.params.step;
    
    V_i(bt_ind) = mean(voltage(x>-.1&x<0));
    V_ss(bt_ind) = mean(voltage(x>obj.trial.params.stimDurInSec-.05& x<obj.trial.params.stimDurInSec));
    if current(bt_ind) > 0;
        V_p(bt_ind) = max(voltage(x>0));
    else
        V_p(bt_ind) = -max(-voltage(x>0));
    end
end
V_p = V_p-V_i;
V_ss = V_ss-V_i;

hold(pnl,'on')
plot(pnl,current,V_p,'color',[.7 .7 .7],'displayname','pk');
plot(pnl,current,V_ss,'color',[0 0 0],'displayname','ss');

