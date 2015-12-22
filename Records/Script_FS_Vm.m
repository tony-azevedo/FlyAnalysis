% Vm resistance
fig = figure;
ax = subplot(1,1,1); hold on

for ac_ind = 1:length(analysis_cell)
    ac = analysis_cell(ac_ind);
    
    if isempty(ac.SweepTrial)
        continue
    end
    fprintf('%s: ',ac.name)
    trial = load(ac.SweepTrial);
    h = getShowFuncInputsFromTrial(trial);
    
    trials = findLikeTrials('name',trial.name,'datastruct',h.prtclData);
    trials = excludeTrials('trials',trials,'name',trial.name);
    
    x = makeInTime(trial.params);
    
    voltage = trials;
    for t_ind = 1:length(trials);
        trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
        switch h.currentPrtcl
            case 'Sweep'
                voltage(t_ind) = mean(trial.voltage(x>0.1));
            otherwise
                yymmdd = trial.name(regexp(trial.name,'\\\d\d\d\d\d\d','once')+(1:6));
                if datenum(yymmdd,'yymmdd')<datenum('28-April-2015')
                    voltage(t_ind) = mean(trial.voltage(x<0));
                else
                    voltage(t_ind) = mean(trial.voltage(x<0 & x>x(1)+.07));
                end
                
        end
    end
    
    Vm = mean(voltage);
    fprintf('%.2f\n',Vm)

    plot(ax,0,Vm,'ob','displayname',ac.name,'tag',ac.genotype)
    
end
savePDFandFIG(fig,savedir(1:regexp(savedir,'Record_FS','end')),'Vm',[id,'Vm'])

