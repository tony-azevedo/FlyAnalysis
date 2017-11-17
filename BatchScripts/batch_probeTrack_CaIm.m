%% Componenents of the probe tracking algorithm and kmeans

protocol = 'EpiFlash2T';
% Assuming I'm in a directory where the movies are to be processed
if ~isempty(regexp(pwd,'compressed', 'once'))
    error('Not in the right directory')
end

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);


%% 170703_F1_C1
trial = load('B:\Raw_Data\170703\170703_F1_C1\EpiFlash2T_Raw_170703_F1_C1_15.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
trialnumlist = (11:25); % 170703_F1_C1      % great for kmeans, bar is stuck

%% 170705_F1_C1 ---- done ---
% trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
% [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
% cd(D)
% trialnumlist = (22:51); % 170705_F1_C1

%% 170707_F1_C1  % bar stuck, no good, rotated up, weird clusters
% trial = load('B:\Raw_Data\170707\170707_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
% [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
% cd(D)
% trialnumlist = (?); % 170707_F1_C1        

%% 170707_F2_C1 
trial = load('B:\Raw_Data\170707\170707_F2_C1\EpiFlash2T_Raw_170707_F2_C1_17.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
trialnumlist = (16:35); % 170707_F2_C1 

%% 170707_F3_C1 
trial = load('B:\Raw_Data\170707\170707_F3_C1\EpiFlash2T_Raw_170707_F3_C1_11.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
trialnumlist = (11:35); % 170707_F3_C1

%% First, load in the movie and pull out a few frames to mess with
%batch_probeTrackExtract

%% Then find the regions of the image to analyze (bar, where the leg is not)
%batch_probeLineROI

%% Then develop a model for the bar
%batch_probeTrackROI

%%
% First, load in the movie and average frames into bins
batch_avikmeansDecimate

%% Do stuff with the decimated data, like store a mean image
batch_avikmeansExtract

%%
% Then find the regions of the image to analyze (leg, where the bar is not)
batch_avikmeansThreshold

% Calculate kmeans clusters, perform watershed on density
% batch_avikmeansCalculation;

%% Calculate kmeans for different grouped trials
% 170703_F1_C1
groupedtrialnumlist = (12:20); % 170703_F1_C1 % stuck? % good clusters
groupedtrialnumlist = (?); % 170703_F1_C1 % stuck?
groupedtrialnumlist = (?); % 170703_F1_C1 % stuck?

% 170705_F2_C1
groupedtrialnumlist = (25:41);

% 170707_F2_C1
groupedtrialnumlist = (16:20); % 170707_F2_C1 % stuck? % good clusters
groupedtrialnumlist = (21:25); % 170707_F2_C1 % stuck?
groupedtrialnumlist = (26:30); % 170707_F2_C1 % stuck?
groupedtrialnumlist = (31:35); % 170707_F2_C1 % stuck?

% 170707_F3_C1
groupedtrialnumlist = (11:20); % 170707_F3_C1 % stuck? % good clusters
groupedtrialnumlist = (21:30); % 170707_F3_C1 % stuck?
groupedtrialnumlist = (31:35); % 170707_F3_C1 % stuck?

batch_avikmeansCalculation_v2

% Calculate F for each cluster
%batch_avikmeansClusterIntensity
batch_avikmeansClusterIntensity_v2

% may have to check this manually
batch_skootchExposure
knownSkootch = 1;
batch_skootchExposure_KnownSkootch

%
% batch_CaImMovie

