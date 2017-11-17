%% Componenents of the kmeans clustering algorithm

protocol = 'EpiFlash2T';
% Assuming I'm in a directory where the movies are to be processed
if ~isempty(regexp(pwd,'compressed', 'once'))
    error('Not in the right directory')
end

D_shortened = [D 'compressed' filesep];
if ~exist(D_shortened,'dir')
    mkdir(D_shortened)
end

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

% align the exposure and light step
% batch_skootchExposure

% create movies
% batch_avikmeansMovie
