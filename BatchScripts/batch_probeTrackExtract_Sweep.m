%% Batch script for getting the first few frames of a movie
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D);

D_shortened = [D 'sampleFrames' filesep];
if ~exist(D_shortened,'dir')
    mkdir(D_shortened)
end

displayf = figure;
set(displayf,'position',[40 2 1280 1024]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

for tr_idx = trialnumlist %1:length(data)
    h = load(sprintf(trialStem,tr_idx));
    fprintf('%s\n',h.name)

    % look for movie file
    checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(h.params.trial) '_' datestr(h.timestamp,29) '*.avi']));
    
    if ~length(checkdir)
        h.exclude = 1;
        h.badmovie = 1;
        trial = h;
        save(trial.name,'-struct','trial');
        fprintf(' * No movie: %s\n',trial.name)
        continue
    elseif isfield(h,'excluded') && h.excluded
        fprintf(' * Bad movie: %s\n',trial.name)
        continue
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
    
    sampledDataPath = regexprep(h.name,regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
    sampledDataPath = regexprep(sampledDataPath,{'_Raw_','.mat'},{'_Image_', '.mat'});
    smooshedImagePath = regexprep(h.name,{'_Raw_','.mat'},{'_smooshed_', '.mat'});

    if exist(sampledDataPath ,'file')
        tic
        fprintf('\t ** already created %s \n',sampledDataPath)
        toc
    else
        
        kk = 0;
        denominator = 0;
        
        % find the first frame
        k0 = find(t(h2.exposure)>0,3,'first');
        k0 = k0(end);
        
        % find the last frame
        kf = find(t(h2.exposure)<=h.params.durSweep,1,'last');
        % Delta frames is 10;
        Dframes = 10; %floor(vid.FrameRate/10);
        % Frame_bins is the minimum frames
%         Frame_bins = floor((sum(t(h2.exposure)>0&t(h2.exposure)<=h.params.stimDurInSec)-3)/Dframes);

        br = waitbar(0,regexprep(sprintf(trialStem,tr_idx),'_','\\_'));
        br.Name = 'Frames';
        
        trial = h;
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
            trial.sampledImage = nan(size(mov3,1),size(mov3,2),Dframes);
            smooshedframe = zeros(size(mov3,1),size(mov3,2));
            
            % start at the first bin
            waitbar(kk/N,br);
            
            % get X bins and average
            for jj = 1:Dframes
                kk = kk+1;
                waitbar(kk/N,br);

                mov3 = double(readFrame(vid));
                
                trial.sampledImage(:,:,jj) = mov3(:,:,1);
                trial.sampledImage(1,1:4,jj) = mean(trial.sampledImage(1,:,jj));
                
                smooshedframe = smooshedframe+mov3(:,:,1);
                denominator = denominator+1;
            end
            
            tic
            save(sampledDataPath, '-struct', 'trial') % ~12 sec
            toc

            break
            
        end
        
        if ~exist(smooshedImagePath ,'file')
            while hasFrame(vid)
                kk = kk+1;
                
                if kk>kf
                    break
                end
            
                mov3 = double(readFrame(vid));
                
                trial.sampledImage(:,:,jj) = mov3(:,:,1);
                trial.sampledImage(1,1:4,jj) = mean(trial.sampledImage(1,:,jj));
                
                smooshedframe = smooshedframe+mov3(:,:,1);
                denominator = denominator+1;
                waitbar(kk/N,br);

            end
            smooshedframe = smooshedframe/denominator;
            save(smooshedImagePath,'smooshedframe');
            
            smooshedframe = smooshedframe-min(smooshedframe(:));
            smooshedframe = smooshedframe/max(smooshedframe(:));
            im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax); drawnow; hold(dispax,'off')
            smooshedImagePath = regexprep(h.name,{'_Raw_','.mat'},{'_smooshed_', '.png'});
            imwrite(smooshedframe,smooshedImagePath,'png')

        end
        delete(br)
    end
end
