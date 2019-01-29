
%% Other work flows

Workflow_35C09_180621_F3_C1_ForceProbePatching % non green, reductor non spiking

%% Slow Workflows
Workflow_35C09_180111_F2_C1_ForceProbePatching
Workflow_35C09_180307_F2_C1_ForceProbePatching
Workflow_35C09_180313_F1_C1_ForceProbePatching
Workflow_35C09_180621_F1_C1_ForceProbePatching
Workflow_35C09_180628_F2_C1_ForceProbePatching

% Example spike injection in MLA
Workflow_iavChR_35C09_180328_F1_C1_ForceProbePatching % Still need to analyse a low intensity stim epiFlash set that was focused on the probe, will need to create a new probe tracking routine
Workflow_iavChR_35C09_180329_F1_C1_ForceProbePatching % This is an amazing cell! Alas, no EMG
Workflow_iavChR_35C09_180702_F1_C1_ForceProbePatching % Need current steps
Workflow_iavChR_35C09_180806_F1_C1_ForceProbePatching % need current steps

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
Workflow_22A08_180405_F3_C1_ChRStimulation_ForceProbePatching
% Workflow_22A08_180807_F1_C1_ChRStimulation_ForceProbePatching % Red LED
% artifact (corrected 190128)
% % Workflow_22A08_181205_F1_C1_ForceProbePatching % some spikes not a lot
% % Workflow_22A08_181219_F1_C1_ChRStimulation_KBoingTest % not patching,
% there are EMG spikes though
% Workflow_22A08_190110_F2_C1_ChRStimulation

%% Miscelaneous

% VT26027 - Extensor! Hard to see som bar movement in all but decent, kind
% of a reductor type recording. This is a (the?) slow extensor

%% Table of force production experiments

varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','NumSpikes','Peak','PeakErr','TimeToPeak','TimeToPeakErr'};
varTypes = {'string','string','string','double','double','string','double'};

sz = [2 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

T{1,:} = {'170921_F1_C1', '81A07',            'fast', 'EpiFlash2T','empty',[0                 ],  [],[22:151],0,0,0,0,0};% just 0 position
T{2,:} = {'171101_F1_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [],[16:330],0,0,0,0,0};% just 0 position
T{3,:} = {'171102_F1_C1', '81A07',            'fast', 'EpiFlash2T','empty',[ 0 100 200],          [],[23:81],0,0,0,0,0};
T{4,:} = {'171102_F2_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [],[47:173],0,0,0,0,0}; 
T{5,:} = {'171103_F1_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-200 -100 0 100 200], [],[72:223],0,0,0,0,0}; 
T{6,:} = {'180308_F3_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-150 -75 0 75 150],   [],[ 4:99],0,0,0,0,0};
T{6,:} = {'190123_F2_C1', '81A07',            'fast', 'EpiFlash2T','empty',[-150 -75 0 75 150],   [],[ 1:175],0,0,0,0,0};

T{7,:} = {'180222_F1_C1', '22A08',    'intermediate', 'CurrentStep2T','empty',[0               ], [],[98:126],0,0,0,0,0};
T{8,:} = {'180405_F3_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0                  ], [],[42:125],0,0,0,0,0};
T{9,:} = {'180807_F1_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0                  ], [],[25:258],0,0,0,0,0};
T{10,:} = {'181219_F1_C1', '22A08',    'intermediate', 'EpiFlash2T','empty',[0                  ], [],[17:159],0,0,0,0,0};

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
spike_1_idx = numspikes<=50 & peakerr>0;

T_123 = T_new_fastinter(spike_1_idx,:);
T_123 = T_123(:,[1 3 9 10 11 12 13]);

figure
ax = subplot(1,1,1); hold(ax,'on')
cids = unique(T_123.CellID);
for i = 1:length(cids)
    cid = cids{i};
    T_cid = T_123(strcmp(T_123.CellID,cid),:);
    l(i) = errorbar(ax,cell2mat(T_cid.NumSpikes),cell2mat(T_cid.Peak),cell2mat(T_cid.PeakErr));
end
ax.XLim = [.5 60];
 
ylabel(ax,'pixels'); 

ForcePerSpikeFig = gcf;
ForcePerSpikeAx = gca;

%% Table of force production in slow neurons

varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile','Positions','Position','Trialnums','NumSpikes','Peak','TimeToPeak','SpontFiringRate','SpontFiringRateErr'};

sz = [2 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;


T{1,:} = {'180111_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[0                 ], [],[5:54],0,0,0,0,0};
% T{2,:} = {'180307_F2_C1', '35C09',     'slow', 'CurrentStep2T','empty',[-150 -75  0 75 120], [],[24:73],[],[],[],[],[]}; % spikes are small
%T{2,:} = {'180313_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[12:61],[],[],[],0,0}; % questionable
T{2,:} = {'180621_F1_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:50],[],[],[],0,0};
T{3,:} = {'180628_F2_C1', '35C09',  'slow',     'CurrentStep2T','empty',[-150 -75  0 75 150], [],[17:58],[],[],[],0,0}; % MLA
T{4,:} = {'180328_F1_C1', '35C09/iav-LexA',     'slow',  'CurrentStep2T','empty',[-150 -75  0 75 150], [],[1:50],[],[],[],[],[]};
T{5,:} = {'180329_F1_C1', '35C09/iav-LexA',     'slow',  'CurrentStep2T','empty',[0                 ], [],[34:75],[],[],[],[],[]};
T{6,:} = {'180702_F1_C1', '35C09/iav-LexA',     'slow', 'CurrentStep2T','empty',[0                  ], [],[14:55],[],[],[],[],[]};

Script_estimateForcePerNSpikesCurve

T_new_slow = T_new

%% add slow neurons to F per Spike axis

ax = ForcePerSpikeAx;
maxspikenum = 0;
for cidx = 1:length(T_new_slow.CellID)
    numspikes = T_new_slow.NumSpikes{cidx};
    peak = T_new_slow.Peak{cidx};
    
    % fit line through 0 to peak vs numspikes
    m(cidx) = nlinfit(numspikes,peak,@linethrough0,.1);
    
    plot(ax,numspikes(numspikes>=20),peak(numspikes>=20),'.','tag',T_new_slow.CellID{cidx});
    maxspikenum = max([maxspikenum max(numspikes)]);
end
ax.XLim = [0, 60+1];

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

ForcePerSpikeAx.XLim = [.85 61]';


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
ax.YTick = [0 10 20 30 40];
ax.YTickLabel = {'0','10', '20','30','40'};
ylabel(ax,'Firing Rate (Hz)'); 


%% Example trials of motor neuron activity, emg, and bar

% ----- Fast -----
clear trials;
trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_37.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Inter
clear trials;
trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_68.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Slow random -----
clear trials;
trial = load('B:\Raw_Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_174.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\180621\180621_F3_C1\CurrentStep2T_Raw_180621_F3_C1_175.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamples_Spike_EMG_Probe

% ---- Slow -----
clear trials;
trial = load('B:\Raw_Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_89.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\180329\180329_F1_C1\CurrentStep2T_Raw_180329_F1_C1_91.mat');
% responseWithVideo_2T_script
trials(2) = trial;

Script_coupleExamplesOfSlowMN_Spikes_EMG_Probe

%% For the example cells, show aligned spikes and forces

% ---- Fast -----
trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 22:151; 
Script_alignSingleAndDoubleSpikes

% ---- Inter -----
trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_40.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 25:204; % Low
Script_alignSingleAndDoubleSpikes


%%

CSHL_select_spikes_FR

%%
CSHL_trajects_by_SpN

%% 

CSHL_1cell_1spike


%% Plot the area of the twtich, from 0 to .05 across distance

% time around the twitch to show
t_i_f = [-0.02 .13];
   
% ----------- 171103_F1_C1 ------------
trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_75.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
disp(trial.name), cd(D)
clear trials
% EpiFlash Sets - cause spikes and video movement
% Position 0 EpiFlash2T: 
trials{1} = 72:115;
% Position 100 EpiFlash2T:
trials{2} = 116:139;
% Position 200 EpiFlash2T: 
trials{3} = 140:163;
% Position -100 EpiFlash2T: 
trials{4} = 164:187;
% Position -200 EpiFlash2T:
trials{5} =  188:211;
% Position 0 EpiFlash2T more spikes: 
trials{6} = 212:223;
dists = [200 100 0 -100 -200 0];
setordridx = [1 2 3 4, 5];
script_singleSpikeTwitchAtEachDistance


% ----------- 180308_F3_C1 ------------
trial = load('B:\Raw_Data\180308\180308_F3_C1\EpiFlash2T_Raw_180308_F3_C1_5.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
disp(trial.name), cd(D)

clear trials 
trials{1} = 4:66; % 0
trials{2} = 70:99; % 0 
trials{3} = 100:129; % 75
trials{4} = 130:159; % 150
trials{5} = 161:190; % -75
trials{6} = 191:220; % -150
trials{7} = 221:242; % 0
trials{8} = 243:262; % 0 more spikes

dists = [0 0 75 150 -75 -150 0 0];
setordridx = [1 2 3 4 5 6 7];
script_singleSpikeTwitchAtEachDistance



