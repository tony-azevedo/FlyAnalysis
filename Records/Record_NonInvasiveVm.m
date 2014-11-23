%% Record Non Invasive Measurement of membrane potential

cnt = 1; 
analysis_cell(cnt).name = {...  % 131015_F3_C1
    '141118_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\141118\141118_F1_C1\VoltageCommand_Raw_141118_F1_C1_4.mat';
    };

%%
c_ind = 1;
trial = load(analysis_cell(c_ind).exampletrials{1});

x = makeInTime(trial.params);

figure
subplot(2,1,1)
plot(x(x>=.15&x<.35),trial.current(x>=.15&x<.35))
axis('tight')

subplot(2,1,2)
plot(x(x>=.15&x<.35),trial.voltage(x>=.15&x<.35))
axis('tight')

%%
seal_currentfit = trial.current(x>=.205&x<.235);
seal_coef = polyfit(x(x>=.205&x<.235),seal_currentfit,1);

figure
subplot(2,1,1)
plot(x(x>=.205&x<.3),trial.current(x>=.205&x<.3))
axis('tight')

corrected_for_seal = trial.current(x>=.205&x<.3) - (seal_coef(1)*x(x>=.205&x<.3)+seal_coef(2));

subplot(2,1,2)
plot(trial.voltage(x>=.205&x<.3),corrected_for_seal)
set(gca,'xdir','reverse')
axis('tight')

