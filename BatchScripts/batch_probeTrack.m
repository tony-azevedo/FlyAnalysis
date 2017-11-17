%% Componenents of the probe tracking algorithm and kmeans

protocol = 'EpiFlash2T';
% Assuming I'm in a directory where the movies are to be processed
if ~isempty(regexp(pwd,'compressed', 'once'))
    error('Not in the right directory')
end

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);

D_shortened = [D 'sampleFrames' filesep];
if ~exist(D_shortened,'dir')
    mkdir(D_shortened)
end

% trialnumlist = (8:151); % 81A07 neuron
trialnumlist = (25:41); % 1700705 example set for probe extraction

% First, load in the movie and pull out a few frames to mess with
batch_probeTrackExtract

% Then find the regions of the image to analyze (bar, where the leg is not)
batch_probeLineROI

% Then develop a model for the bar
batch_probeTrackROI

knownSkootch = 1;
batch_skootchExposure_KnownSkootch


% First, load in the movie and average frames into bins
batch_avikmeansDecimate

% Do stuff with the decimated data, like store a mean image
batch_avikmeansExtract

% Then find the regions of the image to analyze (leg, where the bar is not)
batch_avikmeansThreshold

% Calculate kmeans clusters, perform watershed on density
batch_avikmeansCalculation

% Calculate F for each cluster
batch_avikmeansClusterIntensity

% may have to check this manually
batch_skootchExposure

%
% batch_CaImMovie

