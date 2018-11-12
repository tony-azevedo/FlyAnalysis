%% Batch script for thresholding regions of interest for k_means
% But only for trials I've closely looked and that are similar (ie same
% imaging field and length)

% Assuming I'm in a directory where the movies are to be processed
    
% get rid of the excluded trials (should have already done this)
trial = load(sprintf(trialStem,trialnumlist(1)));

if isfield(trial,'clmask')
    fprintf('clmask already run\n');
    %return
end

excluded = zeros(size(trialnumlist));
for tr_idx = 1:length(trialnumlist)
    ex = load(sprintf(trialStem,trialnumlist(tr_idx)),'excluded');
    if isfield(ex,'excluded') && ex.excluded
        excluded(tr_idx) = 1;
    end
end
trialnumlist = trialnumlist(~excluded);
        
br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

%%
vid = VideoReader(trial.imageFile2);
t_i = 0.05 + trial.params.preDurInSec; % give it 50 ms after light turns on
t_f = min([trial.params.stimDurInSec-5*1/vid.FrameRate,0.5]);

vid.CurrentTime = t_i;
cnt = 1;
frame3 = readFrame(vid);
frame = double(squeeze(frame3(:,:,1)));
while vid.CurrentTime<t_f
    cnt = cnt+1;
    frame3 = readFrame(vid);
    frame = frame+double(squeeze(frame3(:,:,1)));
    if ~mod(cnt,10)
        fprintf('.')
    end
end
fprintf('\n')

smooshedframe = frame./cnt;

wh = fliplr(size(smooshedframe));

%%
displayf = figure;
displayf.Position = [40 40 wh];
displayf.ToolBar = 'none';
dispax = axes('parent',displayf,'units','pixels','position',[0 0 wh]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

colormap(dispax,'gray')

im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);
%%

% creat a mask for the pixels above threshold
mask_ = poly2mask(trial.kmeans_ROI{1}(:,1),trial.kmeans_ROI{1}(:,2),size(smooshedframe,1),size(smooshedframe,2));
abvthresh = smooshedframe<=trial.kmeans_threshold & mask_;
abvthresh = imgaussfilt(double(abvthresh),3);
abvthresh = abvthresh>.1;
abvthresh = ~abvthresh&mask_;
abvthresh1D = abvthresh(:);

hOVM = alphamask(abvthresh, [0 0 1],.1,dispax);


%% open the video and create a matrix for the pixels in ROI X total frames
vid.CurrentTime = t_i;
N = vid.Duration*vid.FrameRate;
t = makeInTime(trial.params);
% t_i = 0.05;
t_f = trial.params.stimDurInSec-5*1/vid.FrameRate;

cam2 = postHocExposure2(trial,N);
frames = find(t(cam2.exposure2)>t_i & t(cam2.exposure2)<t_f);

cam1 = postHocExposure(trial,length(trial.legPositions.Tibia_Angle));
cam1frametimes = t(cam1.exposure);

fctr = vid.FrameRate/50; % pretend you're sampling at 50 hz;
N = floor(length(frames)/fctr); % average over enough frames to make it 50 Hz 

chnksz = floor(10000/N);
totalframes = N*length(trialnumlist);
pixels = nan(sum(abvthresh1D),min([chnksz*N,totalframes]));

frm = smooshedframe;

%%
for chnk_idx = 1:chnksz:length(trialnumlist)
    for tr_idx = chnk_idx:min([length(trialnumlist)-chnk_idx+1,chnk_idx+chnksz-1])
        tr_num = trialnumlist(tr_idx);
        trial = load(sprintf(trialStem,tr_num));
        fprintf('%s\n',trial.name);
        
%         waitbar((tr_num-trialnumlist(1)+1)/length(trialnumlist),br);
        br_frame = waitbar(0,regexprep(sprintf(trialStem,tr_num),'_','\\_'));
        br_frame.Name = 'Frames';
        
        vid = VideoReader(trial.imageFile2); %#ok<TNMLP>
        vid.CurrentTime = t_i;       

        frmcnt = 0;
        ta = trial.legPositions.Tibia_Angle;
        
        while frmcnt < N 
            frmcnt = frmcnt+1;
            % fprintf('frmcnt %d: ',frmcnt);
            
            frmrgb = readFrame(vid);
                
            cam1FrameTimesOverCam2Frame = cam1frametimes > vid.CurrentTime - 1/vid.FrameRate & cam1frametimes <= vid.CurrentTime;
            anglesOverFrames = ta(cam1FrameTimesOverCam2Frame);
                
            if any(anglesOverFrames < 35)
                continue;
            end
            if length(size(frmrgb))==2
                frm = double(frmrgb(:,:,1));
            else
                frm = double(squeeze(frmrgb(:,:,1)));
            end
            % fprintf(' 1 - %.3f\t',vid.CurrentTime);
            cnt = 2;
            while cnt<=fctr
                cnt = cnt+1;
                if length(size(frmrgb))==2
                    frm = frm+double(readFrame(vid));
                else
                    frmrgb = readFrame(vid);
                    frm = double(squeeze(frmrgb(:,:,1)));
                end
                % fprintf(' %d - %.3f\t',cnt,vid.CurrentTime);

            end 
            % fprintf('\n');
            waitbar(frmcnt/N,br_frame);
                        
            % nan out the pixels near the bar;
            if isfield(trial,'forceProbeStuff')
                barmask = poly2mask(...
                    bar(:,1)+trial.forceProbeStuff.Origin(1)+trial.forceProbeStuff.forceProbePosition(1,kk),...
                    bar(:,2)+trial.forceProbeStuff.Origin(2)+trial.forceProbeStuff.forceProbePosition(2,kk),...
                    size(smooshedframe,1),size(smooshedframe,2));
                frm(~abvthresh|barmask) = nan;
                im.CData = frm;
                barshadow.CData(:,:,1) = barmask;
            end
            
            pixels(:,((tr_idx-1)+chnk_idx)*N+frmcnt) = frm(abvthresh1D);
           
        end
        close(br_frame)

        %
    end
    Ns_cl = 3:8;
    clmask = zeros([size(smooshedframe) length(Ns_cl)]);
    excludeframes = any(isnan(pixels),1);
    
    % ************** --------- *************** %
    for N_cl = Ns_cl
        fprintf('Running kmeans on pixel data (%d clusters): ',N_cl); tic
        [idx1,C1]=kmeans(pixels(:,~excludeframes),N_cl,'Distance','correlation','Replicates',4);
        toc
        
        clmask0 = zeros(size(smooshedframe));
        clmask_N = zeros(size(smooshedframe));
        clmask0(abvthresh) = idx1;
        
        clrs = parula(N_cl);
        
        hold(dispax,'off')
        im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax); hold(dispax,'on');
        
        for cl = 1:N_cl
            hold(dispax,'on')
            alphamask(clmask0==cl,clrs(cl,:),.3,dispax);
        end
        
        % Then watershed the k_means clusters
        
        % calculate the density of the cluster points
        for cl = 1:N_cl
            currcl = clmask0==cl;
            currcl = imgaussfilt(double(currcl),3);
            currcl = currcl>.75;
            alphamask(currcl,clrs(cl,:),.5,dispax);
            
            clmask_N(clmask_N==cl) = 0;
            clmask_N(currcl) = cl;
        end
        
        % line(...
        %     [h.kmeans_ROI{1}(:,1);h.kmeans_ROI{1}(1,1)],...
        %     [h.kmeans_ROI{1}(:,2);h.kmeans_ROI{1}(1,2)],...
        %     'parent',dispax,'color',[1 0 0]);
        
        clusterImagePath = sprintf(regexprep(trialStem,{'_Raw_','.mat','_%d'},{'_kmeansCluster_', '','_SelectTrials_%dCl_%d-%d'}),N_cl,chnk_idx,tr_idx);
        text(10,1000,regexprep(clusterImagePath,'\_','\\_'),'parent',dispax,'fontsize',10,'color',[1 1 1],'verticalAlignment','bottom')
        
        if ~exist([D,'clusters\'],'dir')
            mkdir([D,'clusters\'])
        end
        saveas(displayf,[D,'clusters\',clusterImagePath],'png')
        hold(dispax,'off');
        
        plotclusterfig = figure;
        plotclusterfig.Position = [1196 44 560 420];
        ax = subplot(1,1,1);
        
        for cl = 1:N_cl
            hold(ax,'on')
            plot(nanmean(pixels(idx1==cl,:),1),'color',clrs(cl,:));
        end
        
        clmask(:,:,Ns_cl==N_cl) = clmask_N;
    end
    
    % ************** save clmask for all the trials *************** %
    fprintf('Saving clustermasks: ');

    for t_idx = chnk_idx:tr_idx
        trial = load(sprintf(trialStem,trialnumlist(t_idx)));
        fprintf('%s\n',trial.name);
        trial.clmask = clmask;
        save(trial.name, '-struct', 'trial')
    end
    setacqpref('quickshowPrefs','clmask',trial.clmask);

    delete(br);
end

