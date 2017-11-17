%% Batch script for thresholding regions of interest for k_means
% for faster kmeans clustering of individual movies

% Assuming I'm in a directory where the movies are to be processed
if ~isempty(regexp(pwd,'compressed'))
    error('Not in the right directory')
end
    
protocol = 'EpiFlash2T';

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);
data = load(datastructfile); data = data.data;

D_shortened = [D 'compressed' filesep];

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

for tr_idx = trialnumlist %1:length(data)
    h = load(sprintf(trialStem,data(tr_idx).trial));

    waitbar(tr_idx/length(data),br);

    downsampledDataPath = regexprep(h.name,regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
    if exist(downsampledDataPath ,'file')
        tic
        fprintf('%s\n',h.name);
        trial = load(downsampledDataPath); % ~1 sec        
        trial = batchAskAboutThreshold(trial,h);
        
        toc
    else
        error('Down sampled file not available');
    end        
end

delete(br);

