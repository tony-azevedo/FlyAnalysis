%% ForceProbe patcing workflow 171026_F2_C1

%% Extract spikes for different protocols
trial = load('B:\Raw_Data\171026\171026_F2_C1\EpiFlash2T_Raw_171026_F2_C1_7.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

% trialnumlist = 1:14; 
% tr = 9;
% for tr = 1:length(trialnumlist)
%     trial = load(sprintf(trialStem,trialnumlist(tr)));
%     if trial.excluded
%         continue;
%     end
% 
%     simpleExtractSpikes_HACK_current
%     pause(.5)
% end

trial = load('B:\Raw_Data\171026\171026_F2_C1\PiezoStep2T_Raw_171026_F2_C1_7.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);

trialnumlist = 1:18; 
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if trial.excluded
        continue;
    end

    simpleExtractSpikes_HACK_current
    pause(.5)
end


%%

protocol = 'EpiFlash2T';

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);

D_shortened = [D 'sampleFrames' filesep];
if ~exist(D_shortened,'dir')
    mkdir(D_shortened)
end

trialnumlist = (28:54); % 170920_F1_C1
trialnumlist = [25:91 93:138]; % 170920_F2_C1
trialnumlist = [139:210]; % 170920_F2_C1 other trials
trialnumlist = 2:21; % 170925_F0_C1  - plucking
trialnumlist = 7; % 170925_F0_C1  - plucking

% First, load in the movie and pull out a few frames to mess with
batch_probeTrackExtract
batch_probeTrackExtract_Sweep

% Then find the regions of the image to analyze (bar, where the leg is not)
batch_probeLineROI

% Then develop a model for the bar
batch_probeTrackROI

% Then skootch frames. To do so, look for a flash (aviroi) in the corner near the
% body and then run skootchExposure in Quickshow. Once you know how many
% frames, skootch them all
knownSkootch = 1;
% batch_undoSkootchExposure
batch_skootchExposure_KnownSkootch

%% some video making

trial = load('B:\Raw_Data\170925\170925_F0_C1\Sweep_Raw_170925_F0_C1_7.mat');
avi_scaled_bar