
%% Other work flows

Workflow_35C09_180621_F3_C1_ForceProbePatching % non green, reductor non spiking

%% Slow Workflows

Workflow_35C09_180307_F2_C1_ForceProbePatching % very poor spike detection! 10kHz sampling, a little slow, Come back to this
Workflow_35C09_180313_F1_C1_ForceProbePatching % don't bother for now, not great spike detection

% Workflow_35C09_180111_F2_C1_ForceProbePatching
% Workflow_35C09_180621_F1_C1_ForceProbePatching % very nice cell, clear spikes
% Workflow_35C09_180628_F2_C1_ForceProbePatching
% Workflow_35C09_181014_F1_C1_ForceProbePatching % all done! Good spontaneous movements, an annotation about assistance reflex in Sweep2T. 
% Workflow_35C09_181021_F1_C1_ForceProbePatching % 
% Workflow_35C09_181024_F2_C1_ForceProbePatching
% Workflow_35C09_181127_F1_C1_ForceProbePatching
% Workflow_35C09_181127_F2_C1_ForceProbePatching
% Workflow_35C09_181128_F1_C1_ForceProbePatching
% Workflow_35C09_181128_F2_C1_ForceProbePatching


% Example spike injection in MLA
Workflow_iavChR_35C09_180328_F1_C1_ForceProbePatching % Still need to analyse a low intensity stim epiFlash set that was focused on the probe, will need to create a new probe tracking routine
Workflow_iavChR_35C09_180329_F1_C1_ForceProbePatching % This is an amazing cell! Alas, no EMG
Workflow_iavChR_35C09_180702_F1_C1_ForceProbePatching % Need current steps
Workflow_iavChR_35C09_180806_F1_C1_ForceProbePatching 

%% Fast work flows

% 81A07
Workflow_81A07_170921_F1_C1_ForceProbePatching
Workflow_81A07_171101_F1_C1_ForceProbePatching
Workflow_81A07_171102_F1_C1_ForceProbePatching
Workflow_81A07_171102_F2_C1_ForceProbePatching
Workflow_81A07_171103_F1_C1_ForceProbePatching
% Workflow_81A07_180308_F3_C1_ForceProbePatching
% Workflow_81A07_190123_F2_C1_ChRStimulation

%% Intermediate workflows
% Workflow_22A08_180222_F1_C1_ForceProbePatching % Not channel rhodopsin
% Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching
% Workflow_22A08_180807_F1_C1_ChRStimulation_ForceProbePatching % Red LED artifact (corrected 190128)
% % Workflow_22A08_181205_F1_C1_ForceProbePatching % some spikes not a lot
% Workflow_22A08_181219_F1_C1_ChRStimulation_KBoingTest % not patching, there are EMG spikes though which I can now extract
% Workflow_22A08_190110_F2_C1_ChRStimulation

%% Miscelaneous

% VT26027 - Extensor! Hard to see som bar movement in all but decent, kind
% of a reductor type recording. This is a (the?) slow extensor

%% Table of force production experiments, Fast and Inter

varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','NumSpikes','Peak','PeakErr','TimeToPeak','TimeToPeakErr'};
varTypes = {'string','string','string','double','double','string','double'};

sz = [1 length(varNames)];
data = cell(sz);
T_fastinter = cell2table(data);
T_fastinter.Properties.VariableNames = varNames;

T_fastinter{1,:} = {    '170921_F1_C1', '81A07',            'fast', 'EpiFlash2T','empty',[0                 ],  [],[22:151],0,0,0,0,0};% just 0 position
T_fastinter{end+1,:} = {'171101_F1_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [],[16:330],0,0,0,0,0};% just 0 position
T_fastinter{end+1,:} = {'171102_F1_C1', '81A07',            'fast', 'EpiFlash2T','empty',[ 0 100 200],          [],[23:81],0,0,0,0,0};
T_fastinter{end+1,:} = {'171102_F2_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [],[47:173],0,0,0,0,0}; 
T_fastinter{end+1,:} = {'171103_F1_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [],[72:223],0,0,0,0,0}; 
T_fastinter{end+1,:} = {'180308_F3_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-150 -75 0 75 150],   [],[ 4:99],0,0,0,0,0};
% Just an incredible cell. Perfect twitches
T_fastinter{end+1,:} = {'190123_F3_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-150 -75 0 75 150],   [],[ 1:175],0,0,0,0,0};

% T(8)
% relatively few trials 
T_fastinter{end+1,:} = {'180222_F1_C1', '22A08',    'intermediate', 'CurrentStep2T','empty',[0               ], [],[98:126],0,0,0,0,0};
T_fastinter{end+1,:} = {'180405_F3_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0                  ], [],[42:125],0,0,0,0,0};
T_fastinter{end+1,:} = {'180807_F1_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0                  ], [],[25:258],0,0,0,0,0};
% K-Boing cell, fits nicely for 2 spikes, not for 3
T_fastinter{end+1,:} = {'181219_F1_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0                  ], [],[17:66,100:159],0,0,0,0,0};
T_fastinter{end+1,:} = {'190110_F2_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0                  ], [],[13:166],0,0,0,0,0};
%T(12)

T = T_fastinter;

Script_estimateForcePerSpikeCurves
T_new_fastinter = T_new;


%% Peak Force per spike
numspikes = cell2mat(T_new_fastinter.NumSpikes);
spike_1_idx = numspikes==1;

T_1 = T_new_fastinter(spike_1_idx,:);
T_1 = T_1(:,[3 10 11 12 13])

%% time to Peak Force per spike

numspikes = cell2mat(T_new_fastinter.NumSpikes);
spike_1_idx = numspikes==1;

T_1 = T_new_fastinter(spike_1_idx,:);
T_1 = T_1(:,[3 10 11 12 13])

%% Peak Force per spike over 3 spikes
numspikes = cell2mat(T_new_fastinter.NumSpikes);
% spike_1_idx = numspikes==1|numspikes==2 | numspikes == 3;
peakerr = cell2mat(T_new_fastinter.PeakErr);
spike_1_idx = numspikes<=30 & peakerr>0 ;

T_123 = T_new_fastinter(spike_1_idx,:);
T_123 = T_123(:,[1 3 8 9 10 11 12 13]);

figure
ax = subplot(1,1,1); hold(ax,'on')
cids = unique(T_123.CellID);
for i = 1:length(cids)
    cid = cids{i};
    T_cid = T_123(strcmp(T_123.CellID,cid),:);
    l(i) = errorbar(ax,cell2mat(T_cid.NumSpikes),cell2mat(T_cid.Peak),cell2mat(T_cid.PeakErr));
    l(i).DisplayName = cid;
    l(i).Tag = [T_cid.Cell_label{1} '_' cid];
end
ax.XLim = [.5 60];
 
ylabel(ax,'pixels'); 

ForcePerSpikeFig = gcf;
ForcePerSpikeAx = gca;

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

fastpoints = findobj(ax,'-regexp', 'tag', 'fast_'); 
for c = 1:length(fastpoints)
    fastpoints(c).Color = [0 0 0];
end
interpoints = findobj(ax,'-regexp', 'tag', 'intermediate_');
for c = 1:length(interpoints)
    interpoints(c).Color = [1 0 1];
end

%% Table of force production in slow neurons

varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','AtropineTrialnums','MLATrialnums','NumSpikes','Peak','TimeToPeak','SpontFiringRate','SpontFiringRateErr'};

sz = [1 length(varNames)];
data = cell(sz);
T_slow = cell2table(data);
T_slow.Properties.VariableNames = varNames;

T_slow{1,:} = {'180111_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0                 ], [],[5:54],[],[],0,0,0,0,0};
% T{2,:} = {'180307_F2_C1', '35C09',     'slow', 'CurrentStep2T','empty',[-150 -75  0 75 120], [],[24:73],[],[],[],[],[]}; % spikes are small
% T{2,:} = {'180313_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[12:61],[],[],[],0,0}; % questionable
T_slow{end+1,:} = {'180621_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:50],[],[],[],[],[],0,0};
T_slow{end+1,:} = {'180628_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[17:58],[],[59:64],[],[],[],0,0}; % MLA
T_slow{end+1,:} = {'181014_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[12:66],[],[67:171],[],[],[],0,0}; % 
T_slow{end+1,:} = {'181021_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[6:60 ],[],[      ],[],[],[],0,0}; % 
T_slow{end+1,:} = {'181024_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[6:60 ],[],[61:110],[],[],[],0,0}; % 
% some seizures in this one, not great, eg Trial 14
% T{end+1,:} = {'181127_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:35 ],[],[      ],[],[],[],0,0}; % 
T_slow{end+1,:} = {'181127_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:35 ],[],[36:70 ],[],[],[],0,0}; % 
T_slow{end+1,:} = {'181128_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:55 ],[],[56:105],[],[],[],0,0}; % 
T_slow{end+1,:} = {'181128_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:50 ],[],[101:155],[],[],[],0,0}; % MLA
% T{end+1,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow',  'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:50],[],[],[],[],[]};
% T{end+1,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow',  'CurrentStep2T','empty',[0                 ], [],[34:75],[],[],[],[],[]};
% T{end+1,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', 'CurrentStep2T','empty',[0                  ], [],[14:55],[],[],[],[],[]};

T = T_slow;
Script_estimateForcePerNSpikesCurve
% T_new_slow = T_new

% Script_compareMLAToControl
% T_slow_ControlVsMLA = T_new

%% add slow neurons to F per Spike axis

ax = ForcePerSpikeAx;
maxspikenum = 0;
for cidx = 1:length(T_new_slow.CellID)
    numspikes = T_new_slow.NumSpikes{cidx};
    peak = T_new_slow.Peak{cidx};
    
    % fit line through 0 to peak vs numspikes
    m(cidx) = nlinfit(numspikes,peak,@linethrough0,.1);
    
    plot(ax,numspikes(numspikes>=20),peak(numspikes>=20),'.','tag',['slow_' T_new_slow.CellID{cidx}]);
    maxspikenum = max([maxspikenum max(numspikes)]);
end
ax.XLim = [0, 60+1];

slowpoints = findobj(ax,'-regexp', 'tag', 'slow_');
x = []; y = [];
for i = 1:length(slowpoints)
    x = cat(2,x,slowpoints(i).XData);
    y = cat(2,y,slowpoints(i).YData);
end
m = nlinfit(x,y,@linethrough0,.1);
plot(ax,[min(x),max(x)],m*([min(x),max(x)]),'k');

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

ForcePerSpikeAx.XLim = [.85 61]';

for c = 1:length(slowpoints)
    slowpoints(c).Color = [0 .7 0];
end

%% Plot firing rate

figure
ax = subplot(1,1,1); hold(ax,'on')

% dumb script showing no spikes for fast and intermediate

fastintercells = unique(T_123.CellID);
fastinterlabel = unique(T_123.Cell_label);

for f = 1:length(fastintercells)
    cidx = find(strcmp(T_123.CellID,fastintercells{f}),1)
    label = find(strcmp(fastinterlabel,T_123.Cell_label{cidx}))
    plot(ax,label+normrnd(0,.02,1),0,'o','tag',fastintercells{f})
end

for s = 1:length(T_new_slow.CellID)
    errorbar(ax,3+normrnd(0,.02,1),T_new_slow.SpontFiringRate{s},T_new_slow.SpontFiringRateErr{s},'o','tag',fastintercells{f})
end

ax.XTick = [1 2 3];
ax.XTickLabel = {'fast','intermediate','slow'};
 
ax.YLim = [-2 60];
ax.YTick = [0 10 20 30 40 50 60];
ax.YTickLabel = {'0','10', '20','30','40','50','60'};
ylabel(ax,'Firing Rate (Hz)'); 


%% Example trials of motor neuron activity, emg, and bar

% ----- Fast -----
clear trials;
trial = load('E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('E:\Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_37.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Inter
clear trials;
trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_68.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Slow random -----
clear trials;
trial = load('E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_174.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('E:\Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Slow -----
clear trials;
trial = load('E:\Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_89.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('E:\Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_91.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamplesOfSlowMN_Spikes_EMG_Probe

%% For the example cells, show aligned spikes and forces

% ---- Fast -----
trial = load('E:\Data\190123\190123_F3_C1\EpiFlash2T_Raw_190123_F3_C1_78.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 1:175; 
Script_alignSingleAndDoubleSpikes

% ---- Inter -----
trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 25:204; % Low
Script_alignSingleAndDoubleSpikes

%% For the example cell 181014_F1_C1, spike with and without MLA

% ---- Fast -----
trial = load('E:\Data\190123\190123_F3_C1\EpiFlash2T_Raw_190123_F3_C1_78.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 1:175; 
Script_alignSingleAndDoubleSpikes

% ---- Inter -----
trial = load('E:\Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 25:204; % Low
Script_alignSingleAndDoubleSpikes


%% Across cells, calculate conduction velocity

numspikes = cell2mat(T_new_fastinter.NumSpikes);
% spike_1_idx = numspikes==1|numspikes==2 | numspikes == 3;
peakerr = cell2mat(T_new_fastinter.PeakErr);
spike_1_idx = numspikes<=30 & peakerr>0 ;

T_123 = T_new_fastinter(spike_1_idx,:);
T_123 = T_123(:,[1 3 8 9 10 11 12 13]);

figure
ax = subplot(1,1,1); hold(ax,'on')
cids = unique(T_123.CellID);
for i = 1:length(cids)
    cid = cids{i};
    T_cid = T_123(strcmp(T_123.CellID,cid),:);
    l(i) = errorbar(ax,cell2mat(T_cid.NumSpikes),cell2mat(T_cid.Peak),cell2mat(T_cid.PeakErr));
    l(i).DisplayName = cid;
    l(i).Tag = [T_cid.Cell_label{1} '_' cid];
end
ax.XLim = [.5 60];
 
ylabel(ax,'pixels'); 

ForcePerSpikeFig = gcf;
ForcePerSpikeAx = gca;

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

fastpoints = findobj(ax,'-regexp', 'tag', 'fast_'); 
for c = 1:length(fastpoints)
    fastpoints(c).Color = [0 0 0];
end
interpoints = findobj(ax,'-regexp', 'tag', 'intermediate_');
for c = 1:length(interpoints)
    interpoints(c).Color = [1 0 1];
end
