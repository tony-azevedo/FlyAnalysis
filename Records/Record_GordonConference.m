%% Record for Gordon Conference, July 7/13-18, Lewiston Maine, poster

%% Figure 1A,B
% Use the anatomy and fly head schematic from the previous submission

%% Figure 1

% Low Frequency cell, down the row of middle amplitude % VT 30609
close all
figure(1)

analysis_cell.name = {  % 131015_F3_C1
    '140128_F1_C1';
    };
analysis_cell.comment = {
    'Low Frequency selective, very nice!'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_6.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_11.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_81.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoStep_Raw_140128_F1_C1_1.mat';
    };
analysis_cell.evidencecalls = {
    @UnabridgedSweep
    @PiezoSineMatrix
    @PiezoSineOsciRespVsFreq
    @PiezoStepAverage
    };

obj.currentPrtcl = 'PiezoSine';

trial = load(analysis_cell().exampletrials{3});
obj.trial = trial;
ind_ = regexp(trial.name,'_');
indDot = regexp(trial.name,'\.');
dfile = trial.name(~(1:length(trial.name) >= ind_(end) & 1:length(trial.name) < indDot(1)));
dfile = regexprep(dfile,'_Raw','');
dfile = regexprep(dfile,'Acquisition','Raw_Data');
prtclData = load(dfile);
obj.prtclData = prtclData.data;

trialStem = [trial.name((1:length(trial.name)) <= ind_(end)) '%d' trial.name(1:length(trial.name) >= indDot(1))];
trialStem = regexprep(trialStem,'Acquisition','Raw_Data');
obj.trialStem = regexprep(trialStem,'\\','\\\');
obj.trialStem = fliplr(trialStem);
slash = regexp(obj.trialStem,'\\');
obj.trialStem = fliplr(obj.trialStem(1:slash(1)-1));

obj.dir = fliplr(dfile);
slash = regexp(obj.dir,'\\');
obj.dir = fliplr(obj.dir(slash(1)+1:end));
%
figA = PiezoSineMatrix([],obj,'');

ch = get(figA,'children');

low = ch(2);
mid = ch(14);
high = ch(26);

hs = [low mid high];

sps = {
    [1,4] 7
    [10 13] 16
    [19 22] 25
};
for p_ind = 1:length(hs)
    axs = get(hs(p_ind),'children');
    
    ax = subplot(15,3,sps{p_ind,1} + 6,'parent',1);
    pos2 = get(ax,'position');
    delete(ax);
    set(axs(2),'position',pos2,'parent',1);
    set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(axs(2),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    set(axs(2),'ylim',[-48.5390  -20.9780])
    set(axs(2),'xlim',[-.1  .4])
    title(axs(2),'');
    ylabel(axs(2),'');
    
    ax = subplot(15,3,sps{p_ind,2} + 6,'parent',1);
    pos1 = get(ax,'position');
    pos1(4) = max(pos1(4),pos2(4)/2);
    delete(ax);
    set(axs(1),'position',pos1,'parent',1);
    set(axs(1),'xlim',[-.1  .4])
    delete(findobj(axs(1),'type','text'))
    title(axs(1),'');
    ylabel(axs(1),'');
    
end
set(axs(2),'YTick',[-45 -35 -25])
set(axs(2),'Ycolor',[0 0 0])

set(axs(1),'YTick',[4.6 5.4])
set(axs(1),'Ycolor',[0 0 0])


close(figA)
% Fig 1D
PiezoSineOsciRespVsFreq([],obj,'');
figA = 200;

ax = subplot(15,3,[28 31 34 37] + 6,'parent',1);
pos = get(ax,'position');
delete(ax);
axs = get(figA,'children');
set(axs(2),'position',pos,'parent',1);
set(axs(2),'xlim',[25 400]);
set(axs(2),'TickDir','out')
title(axs(2),'');

close(figA)
close(101)


% Fig 1E
% Mid Range non-spiking % VT30609
% analysis_cell.name = { % '131126_F2_C2'; 'Mid range, spiking. Awesome! hyperpolarization changes the filter of the membrane'
%     '131122_F2_C1';
%     };
% analysis_cell.comment = {
%     'Midrange non-spiking'
%     };
% analysis_cell.exampletrials = {...
%     'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_10.mat';
%     };
% analysis_cell.evidencecalls = {
%     'PiezoSineMatrix'
%     'PiezoSineOsciRespVsFreq'
%     };

% BS cell
analysis_cell.name = { % 
    '131126_F2_C2'; 
    };
analysis_cell.comment = {
    'Mid range, spiking. Awesome! hyperpolarization changes the filter of the membrane'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_36.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_28.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_18.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_4.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_9.mat';
    };
analysis_cell.evidencecalls = {
    @PiezoSineMatrix
    @PiezoSineOsciRespVsFreq
    @PiezoStepAverage
    @CurrentSineAverage
    @CurrentSineVvsFreq
    @UnabridgedSweep
    };


trial = load(analysis_cell.exampletrials{1});
obj.trial = trial;
ind_ = regexp(trial.name,'_');
indDot = regexp(trial.name,'\.');
dfile = trial.name(~(1:length(trial.name) >= ind_(end) & 1:length(trial.name) < indDot(1)));
dfile = regexprep(dfile,'_Raw','');
dfile = regexprep(dfile,'Acquisition','Raw_Data');
prtclData = load(dfile);
obj.prtclData = prtclData.data;

trialStem = [trial.name((1:length(trial.name)) <= ind_(end)) '%d' trial.name(1:length(trial.name) >= indDot(1))];
trialStem = regexprep(trialStem,'Acquisition','Raw_Data');
obj.trialStem = regexprep(trialStem,'\\','\\\');
obj.trialStem = fliplr(trialStem);
slash = regexp(obj.trialStem,'\\');
obj.trialStem = fliplr(obj.trialStem(1:slash(1)-1));

obj.dir = fliplr(dfile);
slash = regexp(obj.dir,'\\');
obj.dir = fliplr(obj.dir(slash(1)+1:end));

%
figA = PiezoSineMatrix([],obj,'');

ch = get(figA,'children');

low = ch(2);
mid = ch(8);
high = ch(14);

hs = [low mid high];

sps = {
    [2 5] 8
    [11 14] 17
    [20 23] 26
};
for p_ind = 1:length(hs)
    axs = get(hs(p_ind),'children');
    
    ax = subplot(15,3,sps{p_ind,1} + 6,'parent',1);
    pos2 = get(ax,'position');
    delete(ax);
    set(axs(2),'position',pos2,'parent',1);
    set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(axs(2),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    set(axs(2),'ylim',[-48.5390  -20.9780])
    set(axs(2),'xlim',[-.1  .4])
    title(axs(2),'');
    ylabel(axs(2),'');
    
    ax = subplot(15,3,sps{p_ind,2} + 6,'parent',1);
    pos1 = get(ax,'position');
    pos1(4) = max(pos1(4),pos2(4)/2);
    delete(ax);
    set(axs(1),'position',pos1,'parent',1);
    set(axs(1),'xlim',[-.1  .4])
    delete(findobj(axs(1),'type','text'))
    title(axs(1),'');
    ylabel(axs(1),'');
end
close(figA)


% Fig 1F
% Tuning curve, amplitude, rather than normalized
% BS cell
% BS cell
PiezoSineOsciRespVsFreq([],obj,'');
figA = 200;

ax = subplot(15,3,[29 32 35 38] + 6,'parent',1);
pos = get(ax,'position');
delete(ax);
axs = get(figA,'children');
set(axs(2),'position',pos,'parent',1);
set(axs(2),'xlim',[25 400]);
set(axs(2),'TickDir','out')
title(axs(2),'');
close(figA)

% Fig 1G
% High Freq rectifying.
analysis_cell.name = {
    '131211_F1_C2'; 
    };
analysis_cell.comment = {
    'High Frequency selective,'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_56.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoStep_Raw_131211_F1_C2_1.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentSine_Raw_131211_F1_C2_16.mat';
    };
analysis_cell.evidencecalls = {
    @PiezoSineMatrix
    @PiezoSineDepolSelectivity
    @PiezoStepAverage
    };
trial = load(analysis_cell.exampletrials{1});
obj.trial = trial;
ind_ = regexp(trial.name,'_');
indDot = regexp(trial.name,'\.');
dfile = trial.name(~(1:length(trial.name) >= ind_(end) & 1:length(trial.name) < indDot(1)));
dfile = regexprep(dfile,'_Raw','');
dfile = regexprep(dfile,'Acquisition','Raw_Data');
prtclData = load(dfile);
obj.prtclData = prtclData.data;

trialStem = [trial.name((1:length(trial.name)) <= ind_(end)) '%d' trial.name(1:length(trial.name) >= indDot(1))];
trialStem = regexprep(trialStem,'Acquisition','Raw_Data');
obj.trialStem = regexprep(trialStem,'\\','\\\');
obj.trialStem = fliplr(trialStem);
slash = regexp(obj.trialStem,'\\');
obj.trialStem = fliplr(obj.trialStem(1:slash(1)-1));

obj.dir = fliplr(dfile);
slash = regexp(obj.dir,'\\');
obj.dir = fliplr(obj.dir(slash(1)+1:end));
%
figA = PiezoSineMatrix([],obj,'');

ch = get(figA,'children');

low = ch(2);
mid = ch(8);
high = ch(20);

hs = [low mid high];

sps = {
    [3 6] 9
    [12 15] 18
    [21 24] 27
};
for p_ind = 1:length(hs)
    axs = get(hs(p_ind),'children');
    
    ax = subplot(15,3,sps{p_ind,1} + 6,'parent',1);
    pos2 = get(ax,'position');
    delete(ax);
    set(axs(2),'position',pos2,'parent',1);
    set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(axs(2),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    set(axs(2),'ylim',[-48.5390  -20.9780])
    set(axs(2),'xlim',[-.1  .4])
    title(axs(2),'');
    ylabel(axs(2),'');
    
    ax = subplot(15,3,sps{p_ind,2} + 6,'parent',1);
    pos1 = get(ax,'position');
    pos1(4) = max(pos1(4),pos2(4)/2);
    delete(ax);
    set(axs(1),'position',pos1,'parent',1);
    set(axs(1),'xlim',[-.1  .4])
    delete(findobj(axs(1),'type','text'))
    title(axs(1),'');
    ylabel(axs(1),'');
end
close(figA)

% Fig 1H
% Tuning curve, amplitude, rather than normalized
PiezoSineDepolRespVsFreq([],obj,'');
figA = 200;

ax = subplot(15,3,[30 33 36 39] + 6,'parent',1);
pos = get(ax,'position');
delete(ax);
axs = get(figA,'children');
set(axs,'position',pos,'parent',1);
set(axs,'xlim',[25 400]);
set(axs,'TickDir','out')
title(axs,'');
close(figA)


% Steps

analysis_cell.name = {  % 131015_F3_C1
    '140128_F1_C1';
    };
analysis_cell.comment = {
    'Low Frequency selective, very nice!'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_6.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_11.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_81.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoStep_Raw_140128_F1_C1_1.mat';
    };
analysis_cell.evidencecalls = {
    @UnabridgedSweep
    @PiezoSineMatrix
    @PiezoSineOsciRespVsFreq
    @PiezoStepAverage
    };

obj.currentPrtcl = 'PiezoStep';

trial = load(analysis_cell().exampletrials{4});
obj.trial = trial;
ind_ = regexp(trial.name,'_');
indDot = regexp(trial.name,'\.');
dfile = trial.name(~(1:length(trial.name) >= ind_(end) & 1:length(trial.name) < indDot(1)));
dfile = regexprep(dfile,'_Raw','');
dfile = regexprep(dfile,'Acquisition','Raw_Data');
prtclData = load(dfile);
obj.prtclData = prtclData.data;

trialStem = [trial.name((1:length(trial.name)) <= ind_(end)) '%d' trial.name(1:length(trial.name) >= indDot(1))];
trialStem = regexprep(trialStem,'Acquisition','Raw_Data');
obj.trialStem = regexprep(trialStem,'\\','\\\');
obj.trialStem = fliplr(trialStem);
slash = regexp(obj.trialStem,'\\');
obj.trialStem = fliplr(obj.trialStem(1:slash(1)-1));

obj.dir = fliplr(dfile);
slash = regexp(obj.dir,'\\');
obj.dir = fliplr(obj.dir(slash(1)+1:end));

% Step response
figA = PiezoStepAverage([],obj,'');

ch = get(figA,'children');
ax = subplot(15,3,[1 4],'parent',1);
pos = get(ax,'position');
delete(ax);
axs = get(figA,'children');
set(axs(2),'position',pos,'parent',1);
title(axs(2),'');
ylabel(axs(2),'');
set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
set(axs(2),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
set(axs(2),'ylim',[-48.5390  -20.9780])
set(axs(2),'xlim',[-0.1    0.4])

l = findobj(axs(1),'type','line');
x = get(l,'xData');
y = get(l,'yData');
set(l,'ydata',y-52,'parent',axs(2))

close(figA)

% BS cell Steps
analysis_cell.name = { % 
    '131126_F2_C2'; 
    };
analysis_cell.comment = {
    'Mid range, spiking. Awesome! hyperpolarization changes the filter of the membrane'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_36.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_28.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_18.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_4.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_9.mat';
    };
analysis_cell.evidencecalls = {
    @PiezoSineMatrix
    @PiezoSineOsciRespVsFreq
    @PiezoStepAverage
    @CurrentSineAverage
    @CurrentSineVvsFreq
    @UnabridgedSweep
    };

obj.currentPrtcl = 'PiezoStep';

trial = load(analysis_cell.exampletrials{2});
obj.trial = trial;
ind_ = regexp(trial.name,'_');
indDot = regexp(trial.name,'\.');
dfile = trial.name(~(1:length(trial.name) >= ind_(end) & 1:length(trial.name) < indDot(1)));
dfile = regexprep(dfile,'_Raw','');
dfile = regexprep(dfile,'Acquisition','Raw_Data');
prtclData = load(dfile);
obj.prtclData = prtclData.data;

trialStem = [trial.name((1:length(trial.name)) <= ind_(end)) '%d' trial.name(1:length(trial.name) >= indDot(1))];
trialStem = regexprep(trialStem,'Acquisition','Raw_Data');
obj.trialStem = regexprep(trialStem,'\\','\\\');
obj.trialStem = fliplr(trialStem);
slash = regexp(obj.trialStem,'\\');
obj.trialStem = fliplr(obj.trialStem(1:slash(1)-1));

obj.dir = fliplr(dfile);
slash = regexp(obj.dir,'\\');
obj.dir = fliplr(obj.dir(slash(1)+1:end));

% Step response
figA = PiezoStepAverage([],obj,'');

ch = get(figA,'children');
ax = subplot(15,3,[2 5],'parent',1);
pos = get(ax,'position');
delete(ax);
axs = get(figA,'children');
set(axs(2),'position',pos,'parent',1);
title(axs(2),'');
ylabel(axs(2),'');
set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
set(axs(2),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
set(axs(2),'ylim',[-48.5390  -20.9780])
set(axs(2),'xlim',[-0.1    0.4])

l = findobj(axs(1),'type','line');
x = get(l,'xData');
y = get(l,'yData');
set(l,'ydata',y-52,'parent',axs(2))

close(figA)

% High Freq rectifying. Step response
analysis_cell.name = {
    '131211_F1_C2'; 
    };
analysis_cell.comment = {
    'High Frequency selective,'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_56.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoStep_Raw_131211_F1_C2_1.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentSine_Raw_131211_F1_C2_16.mat';
    };
analysis_cell.evidencecalls = {
    @PiezoSineMatrix
    @PiezoSineDepolSelectivity
    @PiezoStepAverage
    };

obj.currentPrtcl = 'PiezoStep';

trial = load(analysis_cell.exampletrials{2});
obj.trial = trial;
ind_ = regexp(trial.name,'_');
indDot = regexp(trial.name,'\.');
dfile = trial.name(~(1:length(trial.name) >= ind_(end) & 1:length(trial.name) < indDot(1)));
dfile = regexprep(dfile,'_Raw','');
dfile = regexprep(dfile,'Acquisition','Raw_Data');
prtclData = load(dfile);
obj.prtclData = prtclData.data;

trialStem = [trial.name((1:length(trial.name)) <= ind_(end)) '%d' trial.name(1:length(trial.name) >= indDot(1))];
trialStem = regexprep(trialStem,'Acquisition','Raw_Data');
obj.trialStem = regexprep(trialStem,'\\','\\\');
obj.trialStem = fliplr(trialStem);
slash = regexp(obj.trialStem,'\\');
obj.trialStem = fliplr(obj.trialStem(1:slash(1)-1));

obj.dir = fliplr(dfile);
slash = regexp(obj.dir,'\\');
obj.dir = fliplr(obj.dir(slash(1)+1:end));

% Step response
figA = PiezoStepAverage([],obj,'');

ch = get(figA,'children');
ax = subplot(15,3,[3 6],'parent',1);
pos = get(ax,'position');
delete(ax);
axs = get(figA,'children');
set(axs(2),'position',pos,'parent',1);
title(axs(2),'');
ylabel(axs(2),'');
set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
set(axs(2),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
set(axs(2),'ylim',[-48.5390  -20.9780])
set(axs(2),'xlim',[-0.1    0.4])

l = findobj(axs(1),'type','line');
x = get(l,'xData');
y = get(l,'yData');
set(l,'ydata',y-52,'parent',axs(2))

close(figA)


%% 
% Export the fig
export_fig C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\Figure_1 -pdf -transparent


%% Figure 2A
% Oscillations, non-Spiking
% Mid Range % VT30609
% analysis_cell.name = {
%     '131122_F2_C1';
%     };
% analysis_cell.comment = {
%     'Midrange non-spiking, no evidence of nonspiking though!'
%     };
% analysis_cell.exampletrials = {...
%     'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\Sweep_Raw_131122_F2_C1_8.mat';
%     'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\CurrentSine_Raw_131122_F2_C1_1.mat';
%     };
% analysis_cell.evidencecalls = {
% @CurrentSineSelectivity    
% };
% 
% analysis_cell.name = {
%     '131217_F1_C1';
%     };
% analysis_cell.comment = {
%     'Midrange non-spiking'
%     };
% analysis_cell.exampletrials = {...
% 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F1_C1\Sweep_Raw_131217_F1_C1_1.mat';
%     };
% analysis_cell.evidencecalls = {
% @CurrentSineSelectivity    
% };
% 
% analysis_cell.name = {
%     '131211_F2_C1';
%     };
% analysis_cell.comment = {
%     'Midrange non-spiking, only current plateaus'
%     };
% analysis_cell.exampletrials = {...
% 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_76.mat';
%     };
% analysis_cell.evidencecalls = {
% @CurrentSineSelectivity    
% };

analysis_cell.name = {
    '131126_F2_C3';
    };
analysis_cell.comment = {
    'Midrange non-spiking,'
    };
analysis_cell.exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\Sweep_Raw_131126_F2_C3_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\Sweep_Raw_131126_F2_C3_6.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\PiezoSine_Raw_131126_F2_C3_9.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\CurrentSine_Raw_131126_F2_C3_21.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\CurrentSine_Raw_131126_F2_C3_27.mat';
    };
analysis_cell.evidencecalls = {
@UnabridgedSweep  
@PiezoSineMatrix
@PiezoSineOsciRespVsFreq
@CurrentSineSelectivity
};

%% Figure 2B
% BS cell
figure(2)
analysis_cell.name = { % 
    '131126_F2_C2'; 
    };
analysis_cell.comment = {
    'Mid range, spiking. Awesome! hyperpolarization changes the filter of the membrane'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_36.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_28.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_18.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_4.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_9.mat';
    };
analysis_cell.evidencecalls = {
    @PiezoSineMatrix
    @PiezoSineOsciRespVsFreq
    @PiezoStepAverage
    @CurrentSineAverage
    @CurrentSineVvsFreq
    @UnabridgedSweep
    };

figA = figure;
trial = load(analysis_cell().exampletrials{5});
obj.trial = trial;

[obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

figA = UnabridgedSweep(figA,obj,'');
axsA = findobj(figA,'type','axes');
axsA = axsA(1);

figB = figure;
trial = load(analysis_cell().exampletrials{6});
obj.trial = trial;

[obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

figB = UnabridgedSweep(figB,obj,'');
axsB = findobj(figB,'type','axes');
axsB = axsB(1);

ax = subplot(1,2,1,'parent',2);
pos = get(ax,'position');
delete(ax);
set(axsA,'position',pos,'parent',2)
set(axsA,'xlim',[3.2  3.55])
set(axsA,'ylim',[ -85.6025   11.6207])
set(axsA,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
title(axsA,'');

ax = subplot(1,2,2,'parent',2);
pos = get(ax,'position');
delete(ax);
set(axsB,'position',pos,'parent',2)
set(axsB,'xlim',[3.2  3.55])
set(axsB,'ylim',[ -85.6025   11.6207])
set(axsB,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
set(axsB,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
title(axsB,'');
ylabel(axsB,'');

set(findobj(2,'type','line'),'color',[0 0 0]);
set(2,'position',[560   804   560   144])
close(figA,figB);

%% Export Figure 2
export_fig C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\Figure_2 -pdf -transparent

%% Figure 3
% Figure 3A
% Image of a cell
figure(3);

analysis_cell.name = { % 
    '140121_F2_C1'
    };
open C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\DFImage.fig
im = get(get(findobj(gcf,'type','axes'),'children'),'CData');
close gcf

subplot(2,3,3,'parent',3)
imshow(im,[])

% Figure 3B 
% Break-In, Fluorescence, voltage
'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';

open C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\DFatBreakin.fig
figA = gcf;

ax = subplot(4,3,[1,2],'parent',3);
pos = get(ax,'position');
delete(ax);
voltax = subplot(3,1,3,'parent',figA);
set(voltax,'position',pos,'parent',3,'ylim',[-52 -44]);
title(voltax,'');
xlabel(voltax,'');

ax = subplot(4,3,[4 5],'parent',3);
pos = get(ax,'position');
delete(ax);
currax = subplot(3,1,1,'parent',figA);
set(currax,'position',pos,'parent',3);
title(currax,'');
xlabel(currax,'');

ax = subplot(4,3,[7 8 10 11],'parent',3);
pos = get(ax,'position');
delete(ax);
fluoax = subplot(3,1,2,'parent',figA);
set(fluoax,'position',pos,'parent',3);
title(fluoax,'');
xlabel(fluoax,'Time (s)');
set(fluoax,'ylim',[-1 3])
set(fluoax,'xlim',[3.15 3.45])
y = get(get(fluoax,'children'),'yData');
x = get(get(fluoax,'children'),'xData');

ax = axes('Position',[.43 .15 .19 .1],'units','normalized','parent',3);
% set(ax,'position',[.43 .15 .19 .1])
plot(ax,x,y), axis(ax,'tight'),box(ax,'off'),set(ax,'TickDir','out')

close(figA)

% Figure 3C
% Fluorescence change in B1 and non-B1 vs holding potential
open C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\DFoverFvsDV.fig
figA = gcf;

ax = subplot(4,3,[9 12],'parent',3);
pos = get(ax,'position');
delete(ax);
dFoverFvsVax = findobj(figA,'type','axes','-not','tag','legend');
set(dFoverFvsVax,'position',pos,'parent',3);
set(dFoverFvsVax,'xlim',[-55 -35])
xlabel(dFoverFvsVax,'V_{Hold} (mV)');
set(dFoverFvsVax,'TickDir','out')
l = findobj(dFoverFvsVax,'linestyle',':','YData',[0 0]);
set(l,'xdata',[-55 -35])
close(figA)

%% Export fig
export_fig C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\Figure_3 -pdf -transparent


%% Figure 4A 
% AVLP 140 Hz selective

figure(4)
analysis_cell.name = { % 
    '140219_F3C4'; 
    };
analysis_cell.comment = {
    'This was mostly responsive to 140Hz.  Great Courtship song response.'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoSine_Raw_140219_F3_C4_7.mat';
    };
analysis_cell.evidencecalls = {
    };

trial = load(analysis_cell.exampletrials{1});
obj.trial = trial;

[obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;


% figA_old = PiezoSineMatrix([],obj,'');
% figA = copyfig(figA_old);
% 
% ch = get(figA,'children');
% 
% low = ch(18);
% mid = ch(28);
% high = ch(38);
% 
% hs = [low mid high];
% 
% sps = {
%     [1 3] 5
%     [7 9] 11
%     [13 15] 17
% };
% for p_ind = 1:length(hs)
%     axs = get(hs(p_ind),'children');
%     
%     ax = subplot(12,2,sps{p_ind,1},'parent',4);
%     pos2 = get(ax,'position');
%     delete(ax);
%     set(axs(2),'position',pos2,'parent',4);
%     set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
%     set(axs(2),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
%     set(axs(2),'ylim',[-48.5390  -15])
%     set(axs(2),'xlim',[-.1  .55])
%     set(axs(2),'YTick',[-40 -20])
%     set(axs(2),'Ycolor',[0 0 0])
%     title(axs(2),'');
%     ylabel(axs(2),'');
%     
%     ax = subplot(12,2,sps{p_ind,2},'parent',4);
%     pos1 = get(ax,'position');
%     pos1(4) = max(pos1(4),pos2(4)/2);
%     delete(ax);
%     set(axs(1),'position',pos1,'parent',4);
%     set(axs(1),'xlim',[-.1  .4])
%     delete(findobj(axs(1),'type','text'))
%     title(axs(1),'');
%     ylabel(axs(1),'');
%     set(axs(1),'ylim',[4.54  5.4])
%     set(axs(1),'xlim',[-.1  .55])
%     set(axs(1),'YTick',[4.6 5.4])
%     set(axs(1),'Ycolor',[0 0 0])
% 
% end
% 
% close(figA)

PiezoSineDepolRespVsFreq([],obj,'');
figB_old = 200;

figB = copyfig(figB_old);

ax = subplot(15,3,[1 4 7],'parent',4);
pos = get(ax,'position');
delete(ax);
axs = get(figB,'children');
set(axs,'position',pos,'parent',4);
set(axs,'xlim',[25 400]);
set(axs,'ylim',[0 6]);
set(axs,'TickDir','out')
title(axs,'');

close(figB);

open C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\AVLP_Sine_BWCS.fig
figB = gcf;

axs = get(figB,'children');

ax = subplot(5,3,[7 10],'parent',4);
pos2 = get(ax,'position');
delete(ax);
set(axs(2),'position',pos2,'parent',4);
set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
set(axs(2),'ylim',[-52  -15])
set(axs(2),'xlim',[-.4    1.6]);
set(axs(2),'YTick',[-50 -40 -30 -20])
title(axs(2),'');

ax = subplot(5,3,13,'parent',4);
pos1 = get(ax,'position');
pos1(4) = max(pos1(4),pos2(4)/2);
delete(ax);
set(axs(1),'position',pos1,'parent',4);
title(axs(1),'');
set(axs(1),'ylim',[3.7773    5.8852]);
set(axs(1),'xlim',[-.4    1.5]);


% Figure 4B
% AVLP High Frequency selective.

analysis_cell.name = { % 
    '140110_F1C1'; 
    };
analysis_cell.comment = {
    'This was mostly responsive to 140Hz.  Great Courtship song response.'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoSine_Raw_140110_F1_C1_120.mat';
    };
analysis_cell.evidencecalls = {
    };

trial = load(analysis_cell.exampletrials{1});
obj.trial = trial;

[obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

% figC_old = PiezoSineMatrix([],obj,'');

%
% figC = copyfig(figC_old);
% 
% ch = get(figC,'children');
% 
% low = ch(13);
% mid = ch(19);
% 
% hs = [low mid];
% 
% sps = {
%     [2 4] 6
%     [8 10] 12
% };
% for p_ind = 1:length(hs)
%     axs = get(hs(p_ind),'children');
%     
%     ax = subplot(12,2,sps{p_ind,1},'parent',4);
%     pos2 = get(ax,'position');
%     delete(ax);
%     set(axs(2),'position',pos2,'parent',4);
%     set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
%     set(axs(2),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
%     set(axs(2),'ylim',[-48.5390  -15])
%     set(axs(2),'xlim',[-.1  .55])
%     set(axs(2),'YTick',[-40 -20])
%     set(axs(2),'Ycolor',[0 0 0])
%     title(axs(2),'');
%     ylabel(axs(2),'');
%     
%     ax = subplot(12,2,sps{p_ind,2},'parent',4);
%     pos1 = get(ax,'position');
%     pos1(4) = max(pos1(4),pos2(4)/2);
%     delete(ax);
%     set(axs(1),'position',pos1,'parent',4);
%     set(axs(1),'xlim',[-.1  .4])
%     delete(findobj(axs(1),'type','text'))
%     title(axs(1),'');
%     ylabel(axs(1),'');
%     set(axs(1),'ylim',[4.54  5.4])
%     set(axs(1),'xlim',[-.1  .55])
%     set(axs(1),'YTick',[4.6 5.4])
%     set(axs(1),'Ycolor',[0 0 0])
% 
% end
% 
% close(figC)

PiezoSineDepolRespVsFreq([],obj,'');
figD_old = 200;

figD = copyfig(figD_old);

ax = subplot(15,3,[2 5 8],'parent',4);
pos = get(ax,'position');
delete(ax);
axs = get(figD,'children');
set(axs,'position',pos,'parent',4);
set(axs,'xlim',[25 400]);
set(axs,'ylim',[0 6]);
set(axs,'TickDir','out')
title(axs,'');

open C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\AVLP_Pulse_BWCS.fig
figD = gcf;

axs = get(figD,'children');

ax = subplot(5,3,[8 11],'parent',4);
pos2 = get(ax,'position');
delete(ax);
set(axs(2),'position',pos2,'parent',4);
set(axs(2),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
set(axs(2),'ylim',[-52  -15])
set(axs(2),'xlim',[-.4    1.6]);
set(axs(2),'YTick',[-50 -40 -30 -20])
title(axs(2),'');

ax = subplot(5,3,[14],'parent',4);
pos1 = get(ax,'position');
pos1(4) = max(pos1(4),pos2(4)/2);
delete(ax);
set(axs(1),'position',pos1,'parent',4);
title(axs(1),'');
ylabel(axs(1),'');
set(axs(1),'ylim',[3.7773    5.8852]);
set(axs(1),'xlim',[-.4    1.6]);

%% Export fig
export_fig C:\Users\Anthony' Azevedo'\Dropbox\NRSA_Resubmit\Figures\Figure_4 -pdf -transparent


