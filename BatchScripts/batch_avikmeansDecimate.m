%% Batch script for downsampling movies
% for faster kmeans clustering of individual movies

% Assuming I'm in a directory where the movies are to be processed
if ~isempty(regexp(pwd,'compressed'))
    error('Not in the right directory')
end
    
% protocol = 'EpiFlash2T';

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);
data = load(datastructfile); data = data.data;

D_shortened = [D 'compressed' filesep];
if ~exist(D_shortened,'dir')
    mkdir(D_shortened)
end

for tr_idx = 1:length(data)
    h = load(sprintf(trialStem,data(tr_idx).trial));
    
    % look for movie file
    checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(h.params.trial) '_' datestr(h.timestamp,29) '*.avi']));
    
    if ~length(checkdir)
        moviename = [regexprep(h.name, {'Acquisition','_Raw_'},{'Raw_Data','_Images_'}) '.avi'];
        foldername = regexprep(moviename, '.mat.avi','\');
        moviename = dir([foldername protocol '_Image_*']);
        moviename = [foldername moviename(1).name];
        fprintf(1,'Looking for a folder named %s\n',foldername);
    else
        moviename = checkdir(1).name;
    end
    filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];
    
    t = makeInTime(h.params);
    
    t_win = [t(1) t(end)];
    t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];
    
    % import movie
    vid = VideoReader(moviename);
    N = vid.Duration*vid.FrameRate;
    h2 = postHocExposure(h,N);
    
    %% Reduce the amount of data,
    % collapse the pixels into bins ~100 ms apart, and take only pixels crossing
    % threshold. Save the reduced data temporarily in a new folder. This is so
    % that I can batch run the data compression step and then quickly load in
    % a compressed file and run the k_means clustering on that.
    
    downsampledDataPath = regexprep(h.name,regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
    if exist(downsampledDataPath ,'file')
        tic
        fprintf('\t ** %s already created\n',downsampledDataPath)
        trial = load(downsampledDataPath); % ~1 sec
        toc
    else
        
        kk = 0;
        
        % find the first frame
        k0 = find(t(h2.exposure)>0,3,'first');
        k0 = k0(end);
        
        % find the last frame
        kf = find(t(h2.exposure)<=h.params.stimDurInSec,1,'last');
        % Delta frames is enough to make 10 ms;
        Dframes = floor(vid.FrameRate/10);
        % Frame_bins is the minimum frames
        Frame_bins = floor((sum(t(h2.exposure)>0&t(h2.exposure)<=h.params.stimDurInSec)-3)/Dframes);
        
        br = waitbar(0,regexprep(sprintf(trialStem,data(tr_idx).trial),'_','\\_'));
        br.Name = 'Frames';
        while hasFrame(vid)
            kk = kk+1;
            
            if kk<k0
                readFrame(vid);
                continue
            elseif kk>kf
                break
            end
            
            % Now that I've reached time 0;
            
            % read the first frame (unlikely to be very good, can throw it out)
            mov3 = readFrame(vid);
            % create a local matrix and a matrix of bins
            mov_bin = nan(size(mov3,1),size(mov3,2),Dframes);
            trial.downsampledImage = nan(size(mov3,1),size(mov3,2),Frame_bins);
            
            % start at the first bin
            frame_bin = 0;
            while frame_bin<Frame_bins
                frame_bin = frame_bin+1;
                waitbar(frame_bin/Frame_bins,br);
                
                % get X bins and average
                for jj = 1:Dframes
                    mov3 = readFrame(vid);
                    mov_bin(:,:,jj) = mov3(:,:,1);
                end
                trial.downsampledImage(:,:,frame_bin) = mean(mov_bin,3);
            end
            
            break
        end
        tic
        br.Name = 'Saving'; drawnow
        save(downsampledDataPath, '-struct', 'trial') % ~12 sec
        close(br)
        toc
    end
    
end
