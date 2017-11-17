%% Batch script for thresholding regions of interest for k_means
% for faster kmeans clustering of individual movies

% Assuming I'm in a directory where the movies are to be processed
if ~isempty(regexp(pwd,'sampleFrames'))
    error('Not in the right directory')
end
    
rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);
data = load(datastructfile); data = data.data;

D_shortened = [D 'sampleFrames' filesep];
if ~exist(D_shortened,'dir')
    mkdir(D_shortened)
end

close all

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

for tr_idx = trialnumlist % 21:length(data)
    h = load(sprintf(trialStem,data(tr_idx).trial));

    waitbar(tr_idx/length(data),br,regexprep(h.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));

    fprintf('%s\n',h.name);
    if isfield(h,'excluded') && h.excluded
        fprintf(' * Bad movie: %s\n',trial.name)
        continue
    end
    trial = probeLineROI(h);
end

delete(br);

