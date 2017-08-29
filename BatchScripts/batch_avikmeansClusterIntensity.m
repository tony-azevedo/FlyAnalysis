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
br.Position =  [1050    612    270    56];

for tr_idx = 1:length(data)
    waitbar(tr_idx/length(data),br);
    h = load(sprintf(trialStem,data(tr_idx).trial));
    fprintf('%s\n',h.name);
    
    [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,dataFile] = extractRawIdentifiers(h.name);
    if isfield(h,'badmovie')
        fprintf('\t ** Bad movie, moving on\n');
        continue
    end

    if ~isfield(h,'clmask')
        error('You need to run avi_kmeans first, or batch process')
    end
    
    checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(h.params.trial) '_' datestr(h.timestamp,29) '*.avi']));
    
    moviename = checkdir(1).name;
    
    t = makeInTime(h.params);
    
    t_win = [t(1) t(end)];
    t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];
    
    % import movie
    vid = VideoReader(moviename);
    N = vid.Duration*vid.FrameRate;
        
    kk = 0;
    
    clusters = unique(h.clmask);
    clusters = clusters(clusters~=0);
    I_traces = nan(N,length(clusters));
    
    br2 = waitbar(0,regexprep(sprintf(trialStem,h.params.trial),'_','\\_'));
    br2.Name = 'Frames';
    while hasFrame(vid)
        kk = kk+1;
        waitbar(kk/N,br2);
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        for cl = 1:length(clusters)
            I_masked = mov;
            I_cluster = I_masked(h.clmask==cl);            
            I_traces(kk,cl) = mean(I_cluster);
        end
    end
    close(br2)
    
    % Save stuff in the trial
    
    % It will be interesting to measure leg angles several times to measure
    % variability in my detection
    
    h.clustertraces = I_traces;
    % h.legposition = legposition;
    trial = h;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    
    fprintf(1,'Saving %d avi cluster traces for %s %s trial %s\n', ...
        size(I_traces,2),...
        [dateID '_' flynum '_' cellnum], protocol,trialnum);
    
    
    handles.trial = h;
    handles.prtclData = load(dataFile);
    handles.prtclData = handles.prtclData.data;
    %epiFlashFig = EpiFlash2TAviRoi([],handles,'');
end

delete(br);

