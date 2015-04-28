% Record_VoltageClamp

%% Checklist

analysis_cells = {...
'150420_F1_C1'
'150423_F1_C2'
'150425_F1_C1' % This
'150425_F1_C2'
'150425_F1_C3'
'150425_F1_C4'
'150425_F1_C5'
'150425_F2_C1'
'150425_F2_C2'
'150425_F2_C3'
'150426_F1_C1'
'150426_F2_C1' % iffy
'150427_F1_C1'
'150427_F1_C3'
};

analysis_cells_comment = {...
'QX-314, Cs, TTX afterward, 100Hz is a weird one, has ringing'
'QX-314, Cs, TTX afterward, blew up the cell, but saw large events. Probably a spiker'
'QX-314/Cs, Non-spiker, high-pass, based on low input resistance and small spikes in current clamp. unclamped spikes in voltage clamp, large depolarizations'

};

analysis_cells_genotype = {...
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
'GH86;pJFRC7'
};

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c);
    analysis_cell(c).genotype = analysis_cells_genotype(c);
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%%

cnt = find(strcmp(analysis_cells,'150420_F1_C1'));
% Cd first, then TTX.  Control is Cd
analysis_cell(cnt).PiezoStep_m80 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_109.mat';
analysis_cell(cnt).PiezoStep_m60 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_217.mat';
analysis_cell(cnt).PiezoStep_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_m40 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_0 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';

%%

cnt = find(strcmp(analysis_cells,'150423_F1_C2'));
% Cd first, then TTX.  Control is Cd
analysis_cell(cnt).SweepIClamp = 'C:\Users\Anthony Azevedo\Raw_Data\150423\150423_F1_C2\Sweep_Raw_150423_F1_C2_1.mat';
analysis_cell(cnt).SweepVClamp = 'C:\Users\Anthony Azevedo\Raw_Data\150423\150423_F1_C2\Sweep_Raw_150423_F1_C2_7.mat';
analysis_cell(cnt).PiezoStep_rest = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_m40 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_m20 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';
analysis_cell(cnt).PiezoStep_0 = 'C:\Users\Anthony Azevedo\Raw_Data\150326\150326_F1_C1\PiezoSine_Raw_150326_F1_C1_1.mat';


%% Comparison of time course of events in voltage clamp and current clamp - 150423_F1_C2

IClamptrial = load(analysis_cell(2).SweepIClamp);
VClamptrial = load(analysis_cell(2).SweepVClamp);

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,Dir,trialStem,dfile] = ...
    extractRawIdentifiers(analysis_cell(2).SweepIClamp);

Itrials = findLikeTrials('name',analysis_cell(2).SweepIClamp,'datastruct',data);
Vtrials = findLikeTrials('name',analysis_cell(2).SweepVClamp,'datastruct',data);

x = makeInTime(IClamptrial.params);
voltage = zeros(sum(x>0.06),length(Itrials));
current = zeros(sum(x>0.06),length(Vtrials));

for it_ind = 1:length(Itrials)
    IClamptrial = load([Dir sprintf(trialStem,Itrials(it_ind))]);
        
    voltage_temp = IClamptrial.voltage;
    voltage(:,it_ind) = voltage_temp(x>0.06);
end

for it_ind = 1:length(Vtrials)
    VClamptrial = load([Dir sprintf(trialStem,Vtrials(it_ind))]);
    
    current_temp = VClamptrial.current;
    current(:,it_ind) = current_temp(x>0.06);
end

x = x(x>0.06)-0.06;
f = VClamptrial.params.sampratein/length(x)*[0:length(x)/2]; f = [f, fliplr(f(2:end-1))];

fig = figure(1); clf
subplot(2,3,[1 2])
plot(x,voltage(:,1));
xlabel('s');
ylabel('mV');

subplot(2,3,[4 5])
plot(x,current(:,1));
linkaxes([subplot(2,3,[1 2]),subplot(2,3,[4 5])],'x')
xlabel('s');
ylabel('mV');

% subplot(2,3,3)
% [Py,f_pw] = pwelch(voltage-mean(voltage),VClamptrial.params.sampratein,[],[],VClamptrial.params.sampratein);
% loglog(subplot(2,3,3),f_pw,Py/diff(f(1:2)),'color',[.7 0 0]); hold on
% xlim([1 1000])
% ylim([10E-5 1])
% 
% subplot(2,3,6)
% [Py,f_pw] = pwelch(current-mean(current),VClamptrial.params.sampratein,[],[],VClamptrial.params.sampratein);
% loglog(subplot(2,3,6),f_pw,Py/diff(f(1:2)),'color',[.7 0 0]); hold on
% xlim([1 1000])
% ylim([10E-5 5])

% linkaxes([subplot(2,3,3),subplot(2,3,6)],'x')

subplot(2,3,3),hold on
x_cor_mean_volt = [];
for it_ind = 1:length(Itrials)
    [xcor, lags] = xcorr(voltage(:,it_ind)-mean(voltage(:,it_ind)));
    plot(lags/VClamptrial.params.sampratein,xcor,'color',[.8 .8 1]);
    if isempty(x_cor_mean_volt)
        x_cor_mean_volt=xcor;
    else
        x_cor_mean_volt = x_cor_mean_volt+xcor;
    end
end
x_cor_mean_volt = x_cor_mean_volt/length(Vtrials);
plot(lags/VClamptrial.params.sampratein,x_cor_mean_volt,'color',[0 0 .7]);
xlabel('s');
ylabel('mV^2');

subplot(2,3,6),hold on
x_cor_mean_curr = [];
for it_ind = 1:length(Vtrials)
    [xcor, lags] = xcorr(current(:,it_ind)-mean(current(:,it_ind)));
    plot(lags/VClamptrial.params.sampratein,xcor,'color',[.8 .8 1]);
    if isempty(x_cor_mean_curr)
        x_cor_mean_curr=xcor;
    else
        x_cor_mean_curr = x_cor_mean_curr+xcor;
    end
end
x_cor_mean_curr = x_cor_mean_curr/length(Vtrials);
plot(lags/VClamptrial.params.sampratein,x_cor_mean_curr,'color',[0 0 .7]);
xlabel('s');
ylabel('pA^2');


linkaxes([subplot(2,3,3),subplot(2,3,6)],'x')

xlim([-.04 .04])

%%
figure(2), hold on
plot(lags/VClamptrial.params.sampratein,x_cor_mean_curr/max(abs(x_cor_mean_curr)),'color',[0 .7 .7]);
plot(lags/VClamptrial.params.sampratein,x_cor_mean_volt/max(abs(x_cor_mean_volt)),'color',[1 0 1]);

