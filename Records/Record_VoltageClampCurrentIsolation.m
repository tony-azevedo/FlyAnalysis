%% Record of Low Frequency Responsive Cells
clear all

savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation';
if ~isdir(savedir)
    mkdir(savedir)
end
id = 'CI_';

%

analysis_cells = {...
'150617_F2_C1'
'150704_F1_C1'
'150706_F1_C1'
'150709_F1_C2'
'150715_F0_C1'

'150718_F1_C1'
'150720_F1_C2'
'150721_F2_C1'
'150722_F1_C2'
'150723_F1_C1'

'150730_F3_C1'
'150826_F1_C1'
'150826_F2_C1'
'150827_F2_C1'
'150902_F1_C1'

'150903_F1_C1'
'150903_F2_C1'
'150903_F3_C1'
'150911_F1_C1'
'150912_F1_C1'

'150912_F2_C1'  
'150913_F2_C1'  
'150922_F2_C1'  
'150923_F1_C1'  
'150926_F1_C1'  

'150727_F0_C0' % Model cell at the end
'150928_F0_C1'  
};

analysis_cells_comment = {...
    'Testing and analysis design';                  % 130911_F2_C1
    'Testing and analysis design, and drugs, 4AP->Cs->TTX->Cd';                  % 130911_F2_C1
    'Testing and analysis design, and drugs, TTX->4AP->Cs->Cd';                  % 130911_F2_C1
    'Testing and analysis design, and drugs, TTX->4AP->TEA->CsCd';                  % 130911_F2_C1
    'Model cell';                  % 130911_F2_C1
    
    'BPH. Think this could be publishable'
    'BPH. some weird stuff with TEA, I think'
    'BPL. ZD7288 did some weird stuff, but does take out Ih'
    'BPH. ZD does take out Ih'
    'BPL. But was a BPH. Also used Cs internal'
    
    'BPL. 0 Ca causes problems, lost it during TEA';
    'BPL. Fairly nice cell, not great access';
    'BPL. Blew this one up, unfortunately';
    'BPL. combined 4AP and TEA';
    'BPL. MLA block. Starting to think about how to block this strange persistent K current.'
    
    'BPL. Charybdotoxin attempts.'
    'BPH. Charybdotoxin attempts.'
    'BPL. Charybdotoxin attempts.'
    'BPL. What happens when blocking para with RNAi?'
    'BPL. What happens when blocking para with RNAi? Older fly, clear Na currents, perhaps too old?'

    'BPL. What happens when blocking para with RNAi? Younger fly, seems like there is not much left?'
    'BPH. Beautiful Cell in Fru Gal4, done the way it should be'
    'BPH. Beautiful Cell in Fru Gal4, now need to switch the order of the drugs'
    'BPL. Recovery of Na channels is somewhat slow. Also, this is simply a control cell to check for drift'
    'BPL. Need to see the impact of series resistance compensation'
    
    'Model cell';                  % 130911_F2_C1
    'Model cell. Series Resistance investigation';                  % 130911_F2_C1

    };

analysis_cells_genotype = {...
'pJFRC7/+;63A03-Gal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
'model cell'

'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'

'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'

'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'
'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'

'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'

'modelcell';                  % 130911_F2_C1
'modelcell';                  % 130911_F2_C1

};

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%
Script_VClamp_Cells
cnt = find(strcmp(analysis_cells,'150926_F1_C1')); % 150722_F1_C2
ac = analysis_cell(cnt);
Script_VClamp_VoltageCommandSetup
%Script_VClamp_VoltageCommands

%% 6 - BPH: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150718_F1_C1'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150718\150718_F1_C1\SealAndLeak_Raw_150718_F1_C1_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150718\150718_F1_C1\VoltageStep_Raw_150718_F1_C1_2.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150718\150718_F1_C1\VoltageStep_Raw_150718_F1_C1_21.mat';

%% 7 - BPH: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150720_F1_C2'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150720\150720_F1_C2\SealAndLeak_Raw_150720_F1_C2_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150720\150720_F1_C2\VoltageStep_Raw_150720_F1_C2_2.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150720\150720_F1_C2\VoltageStep_Raw_150720_F1_C2_22.mat';

%% 9 - BPH: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150722_F1_C2'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150722\150722_F1_C2\SealAndLeak_Raw_150722_F1_C2_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150722\150722_F1_C2\VoltageStep_Raw_150722_F1_C2_2.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150722\150722_F1_C2\VoltageStep_Raw_150722_F1_C2_22.mat';

%% 22 - BPH: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150913_F2_C1'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150913\150913_F2_C1\SealAndLeak_Raw_150913_F2_C1_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150913\150913_F2_C1\VoltageStep_Raw_150913_F2_C1_111.mat';
%'C:\Users\Anthony Azevedo\Raw_Data\150913\150913_F2_C1\VoltageStep_Raw_150913_F2_C1_254.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150913\150913_F2_C1\VoltageStep_Raw_150913_F2_C1_265.mat';

%% 23 - BPH: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150922_F2_C1'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150922\150922_F2_C1\SealAndLeak_Raw_150922_F2_C1_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150922\150922_F2_C1\VoltageStep_Raw_150922_F2_C1_343.mat';
%'C:\Users\Anthony Azevedo\Raw_Data\150923\150923_F1_C1\VoltageStep_Raw_150923_F1_C1_1.mat';
%'C:\Users\Anthony Azevedo\Raw_Data\150923\150923_F1_C1\VoltageStep_Raw_150923_F1_C1_430.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150922\150922_F2_C1\VoltageStep_Raw_150922_F2_C1_353.mat';

%% 8 - BPL: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150721_F2_C1'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150721\150721_F2_C1\SealAndLeak_Raw_150721_F2_C1_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150721\150721_F2_C1\VoltageStep_Raw_150721_F2_C1_2.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150721\150721_F2_C1\VoltageStep_Raw_150721_F2_C1_22.mat';

%% 12 - BPL: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150730_F3_C1'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150730\150730_F3_C1\SealAndLeak_Raw_150730_F3_C1_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150730\150730_F3_C1\VoltageStep_Raw_150730_F3_C1_32.mat'; % 0 Ca 200 Cd
%'C:\Users\Anthony Azevedo\Raw_Data\150730\150730_F3_C1\VoltageStep_Raw_150730_F3_C1_21.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150730\150730_F3_C1\VoltageStep_Raw_150730_F3_C1_42.mat';

%% 13 - BPL: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150826_F1_C1'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150826\150826_F1_C1\SealAndLeak_Raw_150826_F1_C1_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150826\150826_F1_C1\VoltageStep_Raw_150826_F1_C1_30.mat'; % Ca 100 uM Cd 200 uM
%'C:\Users\Anthony Azevedo\Raw_Data\150826\150826_F1_C1\VoltageStep_Raw_150826_F1_C1_15.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150826\150826_F1_C1\VoltageStep_Raw_150826_F1_C1_44.mat';

%% 15 - BPL: 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150827_F2_C1'));

analysis_cell(cnt).trials.SealNLeak = ...
'C:\Users\Anthony Azevedo\Raw_Data\150827\150827_F2_C1\SealAndLeak_Raw_150827_F2_C1_1.mat';

analysis_cell(cnt).trials.VStepCtrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150827\150827_F2_C1\VoltageStep_Raw_150827_F2_C1_16.mat'; % Ca 100 uM Cd 200 uM
%'C:\Users\Anthony Azevedo\Raw_Data\150827\150827_F2_C1\VoltageStep_Raw_150827_F2_C1_1.mat';

analysis_cell(cnt).trials.VStepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150827\150827_F2_C1\VoltageStep_Raw_150827_F2_C1_30.mat';

%% Calculate Na currents
BPLs = [8 11 12 14];
BPHs = [6 7 9 22 23];


bpl_acs = analysis_cell(BPLs);
bph_acs = analysis_cell(BPHs);


%% Calculate Ri

for c_ind = 1:length(bpl_acs)

    % load trial
    ac = bpl_acs(c_ind);
    
    % load trial
    trial = load(ac.trials.SealNLeak);
    [Ri_BPL(c_ind),access_BPL(c_ind),tempfig] = calculateSealMeasurements(trial,trial.params);
    close(tempfig);
end

for c_ind = 1:length(bph_acs)

    % load trial
    ac = bph_acs(c_ind);
    
    % load trial
    trial = load(ac.trials.SealNLeak);
    [Ri_BPH(c_ind),access_BPH(c_ind),tempfig] = calculateSealMeasurements(trial,trial.params);
    close(tempfig);
end


%% Calculate Na currents

fig = figure;
pnl = panel(fig);
set(fig,'color',[1 1 1],'position',[382 652 1064 326]);
pnl.pack('h',{2/3 1/6 1/6})
pnl.margin = [18 18 10 10];

pnl(1).pack('h',{1/2 1/2})
pnl(1).margin = [18 2 10 2];

pnl(1,1).pack('v',{1/9 4/9 4/9})
pnl(1,2).pack('v',{1/9 4/9 4/9})

pnl(2).pack('h',{1/2 1/2})
pnl(2).margin = [18 10 2 10];

ylims = [Inf -Inf];

for c_ind = 1:length(bpl_acs)
    ac = bpl_acs(c_ind);
    
    % load trial
    trial = load(ac.trials.VStepCtrl);
    obj = getShowFuncInputsFromTrial(trial);
    
    % average trials
    trials = findLikeTrials('name',trial.name);
    current_ex = trial.current;
    current = trial.current;
    x = makeInTime(trial.params);
    for t_ind = 1:length(trials)
        trial = load(fullfile(obj.dir,sprintf(obj.trialStem,trials(t_ind))));
        current = current+trial.current;
    end
    current = current/length(trials);
    
    % define a window
    curr_i = mean(current(x<0&x>-.1));
    window = x>trial.params.stimDurInSec+0.0004 & x<trial.params.stimDurInSec+0.05;
    
    % calculate the peak current
    Na_ctrl(c_ind) = min(current(window))-curr_i;
    
    % do same for TTX 
    % load trial
    trial = load(ac.trials.VStepTTX);
    obj = getShowFuncInputsFromTrial(trial);
    
    % average trials
    trials = findLikeTrials('name',trial.name);
    current_ttx = trial.current;
    current_ttx_ex = trial.current;
    x = makeInTime(trial.params);
    for t_ind = 1:length(trials)
        trial = load(fullfile(obj.dir,sprintf(obj.trialStem,trials(t_ind))));
        current_ttx = current_ttx+trial.current;
    end
    current_ttx = current_ttx/length(trials);
    
    % define a window
    curr_i = mean(current_ttx(x<0&x>-.1));
    window = x>trial.params.stimDurInSec+0.0004 & x<trial.params.stimDurInSec+0.05;
    
    % calculate the peak current
    Na_ttx(c_ind) = min(current_ttx(window))-curr_i;    
end

plot(Ri_BPL/1E6,Na_ctrl,'parent',pnl(3).select(),'linestyle','none',...
    'marker','o','markersize',3,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1]);
hold(pnl(3).select(),'on')

% plot cntrl on left
pw = x>trial.params.stimDurInSec-.01 & x < trial.params.stimDurInSec+.01;
line(x(pw), trial.voltage(pw),'parent',pnl(1,1,1).select(),'color',[1 1 1]*.7);
line(x(pw), current_ex(pw),'parent',pnl(1,1,2).select(),'color',[1 1 1]*0);
line(x(pw), current_ttx_ex(pw),'parent',pnl(1,1,3).select(),'color',[1 1 1]*0);

plot([0 1],[Na_ctrl(:) Na_ttx(:)],'parent',pnl(2,1).select(),...
    'linestyle','-','color',[1 1 1]*.7,...
    'marker','o','markersize',3,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1]);

BPL_Na = Na_ctrl;

clear Na_ctrl Na_ttx
for c_ind = 1:length(bph_acs)
    ac = bph_acs(c_ind);
    
    % load trial
    trial = load(ac.trials.VStepCtrl);
    obj = getShowFuncInputsFromTrial(trial);
    
    % average trials
    trials = findLikeTrials('name',trial.name);
    current_ex = trial.current;
    current = trial.current;
    x = makeInTime(trial.params);
    for t_ind = 1:length(trials)
        trial = load(fullfile(obj.dir,sprintf(obj.trialStem,trials(t_ind))));
        current = current+trial.current;
    end
    current = current/length(trials);
    
    % define a window
    curr_i = mean(current(x<0&x>-.1));
    window = x>trial.params.stimDurInSec+0.0004 & x<trial.params.stimDurInSec+0.05;
    
    % calculate the peak current
    Na_ctrl(c_ind) = min(current(window))-curr_i;
    
    % do same for TTX 
    % load trial
    trial = load(ac.trials.VStepTTX);
    obj = getShowFuncInputsFromTrial(trial);
    
    % average trials
    trials = findLikeTrials('name',trial.name);
    current_ttx = trial.current;
    current_ttx_ex = trial.current;
    x = makeInTime(trial.params);
    for t_ind = 1:length(trials)
        trial = load(fullfile(obj.dir,sprintf(obj.trialStem,trials(t_ind))));
        current_ttx = current_ttx+trial.current;
    end
    current_ttx = current_ttx/length(trials);
    
    % define a window
    curr_i = mean(current_ttx(x<0&x>-.1));
    window = x>trial.params.stimDurInSec+0.0004 & x<trial.params.stimDurInSec+0.05;
    
    % calculate the peak current
    Na_ttx(c_ind) = min(current_ttx(window))-curr_i;    
end
   
plot(Ri_BPH/1E6,Na_ctrl,'parent',pnl(3).select(),'linestyle','none',...
    'marker','o','markersize',3,'markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0]);

% plot cntrl on left
pw = x>trial.params.stimDurInSec-.01 & x < trial.params.stimDurInSec+.01;
line(x(pw), trial.voltage(pw),'parent',pnl(1,2,1).select(),'color',[1 1 1]*.7);
line(x(pw), current_ex(pw),'parent',pnl(1,2,2).select(),'color',[1 1 1]*0);
line(x(pw), current_ttx_ex(pw),'parent',pnl(1,2,3).select(),'color',[1 1 1]*0);

plot([0 1],[Na_ctrl(:) Na_ttx(:)],'parent',pnl(2,2).select(),...
    'linestyle','-','color',[1 1 1]*.7,...
    'marker','o','markersize',3,'markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0]);

BPH_Na = Na_ctrl;

% Clean up
axis(pnl(1,1,1).select(),'tight')
set(pnl(1,1,1).select(),'ytick',[],'yticklabel',{},'ycolor',[1 1 1],'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

axis(pnl(1,2,1).select(),'tight')
set(pnl(1,2,1).select(),'ytick',[],'yticklabel',{},'ycolor',[1 1 1],'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

curr_ylims = [-900 100];

axis(pnl(1,1,2).select(),'tight')
set(pnl(1,1,2).select(),'ylim',curr_ylims,'ytick',[-500 0],'yticklabel',{},'ycolor',[0 0 0],'xtick',[trial.params.stimDurInSec,trial.params.stimDurInSec+.005],'xticklabel',{},'xcolor',[0 0 0]);

axis(pnl(1,1,3).select(),'tight')
set(pnl(1,1,3).select(),'ylim',curr_ylims,'ytick',[],'yticklabel',{},'ycolor',[1 1 1],'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

axis(pnl(1,2,2).select(),'tight')
set(pnl(1,2,2).select(),'ylim',curr_ylims,'ytick',[],'yticklabel',{},'ycolor',[1 1 1],'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

axis(pnl(1,2,3).select(),'tight')
set(pnl(1,2,3).select(),'ylim',curr_ylims,'ytick',[],'yticklabel',{},'ycolor',[1 1 1],'xtick',[],'xticklabel',{},'xcolor',[1 1 1]);

curr_ylims = [-1400 0];
xlims = [-.2 1.2];
set(pnl(2,1).select(),'ylim',curr_ylims,'xlim',xlims,'xtick',[0 1],'xticklabel',{'ctrl','ttx'});
set(pnl(2,2).select(),'ylim',curr_ylims,'xlim',xlims,'xtick',[0 1],'xticklabel',{'ctrl','ttx'},'ytick',[],'yticklabel',{},'ycolor',[1 1 1]);

ylabel(pnl(2,1).select(),'pA');

ylabel(pnl(2,1).select(),'pA');
ylabel(pnl(3).select(),'pA');
ylabel(pnl(3).select(),'pA');
xlabel(pnl(3).select(),'M\Omega');

pnl.fontsize = 10;
%pnl.fontname = 'Tahoma';

fn = fullfile(savedir,'BPLvsBPH_Na_currents.pdf');
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

%% access and R_i comparison
figure
plot(access_BPH,BPH_Na,'r.'), hold on
plot(access_BPL,BPL_Na,'b.');


%% Noise Spectra 
close all

cnt = find(strcmp(analysis_cells,'150722_F1_C2'));

analysis_cell(cnt).trials.SweepCntrl = ...
'C:\Users\Anthony Azevedo\Raw_Data\150722\150722_F1_C2\Sweep_Raw_150722_F1_C2_7.mat';

analysis_cell(cnt).trials.SweepTTX = ...
'C:\Users\Anthony Azevedo\Raw_Data\150722\150722_F1_C2\Sweep_Raw_150722_F1_C2_14.mat';

analysis_cell(cnt).trials.SweepCd = ...
'C:\Users\Anthony Azevedo\Raw_Data\150722\150722_F1_C2\Sweep_Raw_150722_F1_C2_47.mat';

ac = analysis_cell(cnt);

%Create a figure with the number of columns drugs
fig = figure();
set(fig,'color',[1 1 1],'units','inches','position',[1 3 10 5],'name',[ac.name{1} '_SweepPowerSpectra']);
pnl = panel(fig);
pnl.margin = [20 20 6 12];
pnl.pack('h',3);
pnl.de.margin = [20 18 2 2];

conditions = {'SweepCntrl','SweepTTX','SweepCd'};
trial = load(ac.trials.(conditions{1}));
x = makeInTime(trial.params);
snipwin = x>2 &x<2.2;

for c_ind = 1:length(conditions)
trial = load(ac.trials.(conditions{c_ind}));
h = getShowFuncInputsFromTrial(trial);

trials = findLikeTrials('name',trial.name,'datastruct',h.prtclData);

ylims = [Inf -Inf];
ylims_voltage = [Inf -Inf];

pnl(c_ind).pack('v',{1/3 2/3});
AvePower = [];
for bt_ind = 1:length(trials)
    
    %     load the trial
    trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(bt_ind))));
    x = makeInTime(trial.params);
    
    %     get the voltage after the teststep
    voltage = trial.voltage;
    voltage = voltage(x>=.1);
    voltage = voltage-mean(voltage);
    
    f = trial.params.sampratein/length(voltage)*[0:length(voltage)/2]; f = [f, fliplr(f(2:end-1))];
    Y = real(fft(voltage).*conj(fft(voltage)));
    Y = Y/sum(Y);
    %line(f,Y/diff(f(1:2)),'color',[1 .7 .7],'tag','fft','parent',ax);
    [Py,f] = pwelch(voltage-mean(voltage),trial.params.sampratein,[],[],trial.params.sampratein);
    %line(f,Py/diff(f(1:2)),'color',[.7 0 0],'parent',ax);
    %set(ax,'xscale','log','yscale','log')
    if isempty(AvePower), AvePower = Py;
    else AvePower = AvePower+Py; end
end
line(x(snipwin),trial.voltage(snipwin),'color',[0 0 0],'parent',pnl(c_ind,1).select());
set(pnl(c_ind,1).select(),'xlim',[2 2.2],'ylim',[-50 -36])

%     average the power spectra and plot
AvePower = smooth(AvePower/length(trials),1);
line(f,AvePower/diff(f(1:2)),'color',[.7 0 0],'parent',pnl(c_ind,2).select());
set(pnl(c_ind,2).select(),'xscale','log','yscale','log','xlim',[3 400],'ylim',[5E-7 1E-2])
set(pnl(c_ind,2).select(),'xscale','log','yscale','log','xlim',[3 400],'ylim',[5E-7 1E-2],...
    'ytick',[],'xtick',[1E1 1E2])
end
ylabel(pnl(1,1).select(),'mV');
xlabel(pnl(1,1).select(),'s');

ylabel(pnl(1,2).select(),'PSD (mV^2/Hz)');
xlabel(pnl(1,2).select(),'Hz');
set(pnl(1,2).select(),'ytick',[1E-5 1E-3],'xtick',[1E1 1E2])
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%xlabel(pnl(length(blocktrials),3).select(),regexprep(ac.name{1},'_','.'));

fn = fullfile(savedir,[ac.name{1}, '_SweepPowerSpectra.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
