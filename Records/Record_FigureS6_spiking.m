%% Record_FigureS2_Spiking - examples of spiking in different cell classes
close all
savedir = '/Users/tony/Dropbox/RAnalysis_Data/Record_FS';
if ~isdir(savedir)
    mkdir(savedir)
end

Scripts = {
    'Script_Vm_HighFreqDepolB1s'
    'Script_Vm_BandPassHiB1s'
    'Script_Vm_BandPassLowB1s'
    'Script_Vm_LowPassB1s'
    };

figure2 = figure;
figure2.Units = 'inches';
set(figure2,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronTwoColumn') 6]);
pnl = panel(figure2);
pnl.margin = [16 16 4 4];

figurerows = [2 2];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);

pnl(1).pack('h',4)
pnl(2).pack('h',4)

%% Current injection for A2s

Script_Vm_HighFreqDepolB1s

% ---- A2 Step ----
ax_step = pnl(1,1).select();
trial = load(example_cell.CurrentStepTrialUp);
x = makeInTime(trial.params);
xwin = x>=-trial.params.preDurInSec+.07 &x<trial.params.stimDurInSec+abs(diff([trial.params.preDurInSec .07]));
line(x(xwin),trial.voltage(xwin),'parent',ax_step,'color',[0 0 0])
axis(ax_step,'tight');
text(-trial.params.preDurInSec+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))+3,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_step)

trial = load(example_cell.CurrentStepTrialDown);
x = makeInTime(trial.params);
xwin = x>=-trial.params.preDurInSec+.07 &x<trial.params.stimDurInSec+abs(diff([trial.params.preDurInSec .07]));
line(x(xwin),trial.voltage(xwin),'parent',ax_step,'color',[0 0 0])
axis(ax_step,'tight');
text(-trial.params.preDurInSec+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))-2,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_step)

set(ax_step,'ylim',[-40 -15],'xlim',[-.05 .2],'tickdir','out');


% ---- TTX ----
ax_step = pnl(2,1).select();
trial = load(example_cell.CurrentStepTrialUpTTX);
x = makeInTime(trial.params);
xwin = x>=-trial.params.preDurInSec+.07 &x<trial.params.stimDurInSec+abs(diff([trial.params.preDurInSec .07]));
line(x(xwin),trial.voltage(xwin),'parent',ax_step,'color',[0 0 0])
axis(ax_step,'tight');
text(-trial.params.preDurInSec+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))+3,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_step)

trial = load(example_cell.CurrentStepTrialDownTTX);
x = makeInTime(trial.params);
xwin = x>=-trial.params.preDurInSec+.07 &x<trial.params.stimDurInSec+abs(diff([trial.params.preDurInSec .07]));
line(x(xwin),trial.voltage(xwin),'parent',ax_step,'color',[0 0 0])
axis(ax_step,'tight');
text(-trial.params.preDurInSec+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))-2,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_step)

set(ax_step,'ylim',[-40 -15],'xlim',[-.05 .2],'tickdir','out');

%% Current Steps BPH

Script_Vm_BandPassHiB1s

ax_steps = pnl(1,2).select();
trial = load(example_cell.CurrentStepTrialWayDown);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',[0 0 1])
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))-25,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',[0 0 1])

trial = load(example_cell.CurrentStepTrialDown);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',.7*[1 1 1])
axis(ax_steps,'tight');
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))-12.5,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',.7*[1 1 1])

trial = load(example_cell.CurrentStepTrialUp);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',[1 0 0])
axis(ax_steps,'tight');
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))+12.5,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',.7*[1 0 0])

set(ax_steps,'ylim',[-120 10],'tickdir','out');

%% Spiking BPH

Script_Vm_BandPassHiB1s

gap = 0.1;

ax_sweep_spike = pnl(2,2).select();
trial = load(example_cell.SweepTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin)-example_cell.SpikeInterval(1),...
    trial.voltage(xwin),'parent',ax_sweep_spike,'color',[0 0 0])
text(.05*diff(example_cell.SpikeInterval),-20,[num2str(round(mean(trial.current))) ' pA'],'parent',ax_sweep_spike)

trial = load(example_cell.SpikeTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin)-example_cell.SpikeInterval(1)+diff(example_cell.SpikeInterval)+gap,...
    trial.voltage(xwin),'parent',ax_sweep_spike,'color',[0 0 0])
axis(ax_sweep_spike,'tight');
text(diff(example_cell.SpikeInterval)+gap+.05*diff(example_cell.SpikeInterval),...
    -20,[num2str(round(mean(trial.current))) ' pA'],'parent',ax_sweep_spike)

set(ax_sweep_spike,'ylim',[-90 0],'tickdir','out');


%% Current Steps BPM

Script_Vm_BandPassLowB1s

ax_steps = pnl(1,3).select();
trial = load(example_cell.CurrentStepTrialWayDown);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',[0 0 1])
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))-25,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',[0 0 1])

trial = load(example_cell.CurrentStepTrialDown);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',.7*[1 1 1])
axis(ax_steps,'tight');
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))-12.5,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',.7*[1 1 1])

trial = load(example_cell.CurrentStepTrialUp);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',[1 0 0])
axis(ax_steps,'tight');
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))+12.5,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',.7*[1 0 0])

set(ax_steps,'ylim',[-120 10],'tickdir','out');

%% Non spiking BPM

Script_Vm_BandPassLowB1s

gap = 0.1;

ax_sweep_spike = pnl(2,3).select();
trial = load(example_cell.SweepTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin)-example_cell.SpikeInterval(1),...
    trial.voltage(xwin),'parent',ax_sweep_spike,'color',[0 0 0])
text(.05*diff(example_cell.SpikeInterval),-20,[num2str(round(mean(trial.current))) ' pA'],'parent',ax_sweep_spike)

trial = load(example_cell.SpikeTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin)-example_cell.SpikeInterval(1)+diff(example_cell.SpikeInterval)+gap,...
    trial.voltage(xwin),'parent',ax_sweep_spike,'color',[0 0 0])
axis(ax_sweep_spike,'tight');
text(diff(example_cell.SpikeInterval)+gap+.05*diff(example_cell.SpikeInterval),...
    -20,[num2str(round(mean(trial.current))) ' pA'],'parent',ax_sweep_spike)

set(ax_sweep_spike,'ylim',[-90 0],'tickdir','out');

%% Current Steps BPL

Script_Vm_LowPassB1s

ax_steps = pnl(1,4).select();
trial = load(example_cell.CurrentStepTrialWayDown);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',[0 0 1])
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))-25,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',[0 0 1])

trial = load(example_cell.CurrentStepTrialDown);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',.7*[1 1 1])
axis(ax_steps,'tight');
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))-12.5,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',.7*[1 1 1])

trial = load(example_cell.CurrentStepTrialUp);
x = makeInTime(trial.params);
xwin = x>=-.2&x<.7;
line(x(xwin),trial.voltage(xwin),'parent',ax_steps,'color',[1 0 0])
axis(ax_steps,'tight');
text(-.2+.075,...
    mean(trial.voltage(x>=-trial.params.preDurInSec+.07 &x<0))+12.5,...
    [num2str(round(mean(trial.params.step))) ' pA'],'parent',ax_steps,'color',.7*[1 0 0])

set(ax_steps,'ylim',[-120 10],'tickdir','out');

%% Non spiking BPL

Script_Vm_LowPassB1s

gap = 0.1;

ax_sweep_spike = pnl(2,4).select();
trial = load(example_cell.SweepTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin)-example_cell.SpikeInterval(1),...
    trial.voltage(xwin),'parent',ax_sweep_spike,'color',[0 0 0])
text(.05*diff(example_cell.SpikeInterval),-20,[num2str(round(mean(trial.current))) ' pA'],'parent',ax_sweep_spike)

trial = load(example_cell.SpikeTrial);
x = makeInTime(trial.params);
xwin = x>=example_cell.SpikeInterval(1)&x<example_cell.SpikeInterval(2);
line(x(xwin)-example_cell.SpikeInterval(1)+diff(example_cell.SpikeInterval)+gap,...
    trial.voltage(xwin),'parent',ax_sweep_spike,'color',[0 0 0])
axis(ax_sweep_spike,'tight');
text(diff(example_cell.SpikeInterval)+gap+.05*diff(example_cell.SpikeInterval),...
    -20,[num2str(round(mean(trial.current))) ' pA'],'parent',ax_sweep_spike)

set(ax_sweep_spike,'ylim',[-90 0],'tickdir','out');


% savePDF(figure2,'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure6',[],'Figure2_spiking')