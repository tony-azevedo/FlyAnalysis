% stupid script to add modes to some trials that didn't have it.
% cd C:\Users\tony\Raw_Data\170331\170331_F1_C1
cd C:\Users\tony\Raw_Data\170330\170330_F1_C1
cd C:\Users\tony\Raw_Data\170329\170329_F3_C1
%% 
rawfiles = dir('*_Raw_*');

figure
blocks = [];
mode_1 = {};
mode_2 = {};

cur_mode_1 = 'IClamp';
cur_mode_2 = 'IClamp';

for rf = 1:length(rawfiles)
    disp(rawfiles(rf).name)
    trial = load(rawfiles(rf).name);
    t = makeInTime(trial.params);
    if isfield(trial,'voltage_1') && ~isfield(trial.params,'mode_1')
        
        if ~any(trial.params.trialBlock==blocks)        
            plot(subplot(2,1,1),t,trial.voltage_1)
            plot(subplot(2,1,2),t,trial.voltage_2)
            title(subplot(2,1,1),regexprep(rawfiles(rf).name,'_','\\_'))
            
            ANSWER = inputdlg({'Mode 1','Mode 2'},'What mode?',1,{cur_mode_1,cur_mode_2});
            
            blocks = [blocks,trial.params.trialBlock];

            mode_1 = [mode_1,ANSWER(1)];
            mode_2 = [mode_2,ANSWER(2)];

            trial.params.mode_1 = mode_1{trial.params.trialBlock==blocks};
            trial.params.mode_2 = mode_2{trial.params.trialBlock==blocks};
            
            disp(trial.params.mode_1)
            disp(trial.params.mode_2)
            save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
            
            cur_mode_1 = ANSWER{1};
            cur_mode_2 = ANSWER{2};
        else
            trial.params.mode_1 = mode_1{trial.params.trialBlock==blocks};
            trial.params.mode_2 = mode_2{trial.params.trialBlock==blocks};
            save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
            
            disp(trial.params.mode_1)
            disp(trial.params.mode_2)
        end
        
    end
end