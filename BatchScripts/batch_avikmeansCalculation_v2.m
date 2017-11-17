%% Batch script for thresholding regions of interest for k_means
% But only for trials I've closely looked and that are similar (ie same
% imaging field and length)

% Assuming I'm in a directory where the movies are to be processed
    
% get rid of the excluded trials (should have already done this)
trial = load(sprintf(trialStem,trialnumlist(1)));

if isfield(trial,'clmask')
    fprintf('clmask already run\n');
    return
end

excluded = zeros(size(trialnumlist));
for tr_idx = 1:length(trialnumlist)
    ex = load(sprintf(trialStem,trialnumlist(tr_idx)),'excluded');
    if isfield(ex,'excluded') && ex.excluded
        excluded(tr_idx) = 1;
    end
end
trialnumlist = trialnumlist(~excluded);


displayf = figure;
displayf.Position = [40 40 1280 1024];
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';
        
br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

colormap(dispax,'gray')

vid = VideoReader(trial.imageFile);
N = vid.Duration*vid.FrameRate;
for cnt = 1:5
    frame = readFrame(vid); 
end
frame = squeeze(frame(:,:,1));
startAt0 = false;
if sum(frame(:)>10) < numel(frame)/1000
    startAt0 = true;
end

h2 = postHocExposure(trial,N);
t = makeInTime(trial.params);
t_i = 5*1/vid.FrameRate;
if ~startAt0
    t_i = trial.params.preDurInSec+t_i;
end
t_f = trial.params.stimDurInSec-5*1/vid.FrameRate;
frames = find(t(h2.exposure)>t_i & t(h2.exposure)<t_f);

kk = 0;
while kk<frames(1)
    kk = kk+1;
    
    readFrame(vid);
    continue
end

smooshedframe = double(readFrame(vid));
smooshedframe = squeeze(smooshedframe(:,:,1));
smooshedframe(:) = 0; 
readFrame(vid); readFrame(vid);

for jj = 1:4
    mov3 = double(readFrame(vid));
    smooshedframe = smooshedframe+mov3(:,:,1);
end
for jj = 1:20
    mov3 = double(readFrame(vid));
    smooshedframe = smooshedframe+mov3(:,:,1);
end
smooshedframe = smooshedframe/24;

% creat a mask for the pixels above threshold
mask_ = poly2mask(trial.kmeans_ROI{1}(:,1),trial.kmeans_ROI{1}(:,2),size(smooshedframe,1),size(smooshedframe,2));
abvthresh = smooshedframe<=trial.kmeans_threshold & mask_;
abvthresh = imgaussfilt(double(abvthresh),3);
abvthresh = abvthresh>.1;
abvthresh = ~abvthresh&mask_;
abvthresh1D = abvthresh(:);

% create a mask for the bar
% the bar line turns into a rectangle centered on the intersection point
l = trial.forceProbe_line;
p = trial.forceProbe_tangent;
l_0 = l - repmat(mean(l,1),2,1);
p_0 = p - mean(l,1);

% for my purposes, get the line equation (m,b)
m = diff(l(:,2))/diff(l(:,1));
b = l(1,2)-m*l(1,1);

% find y vector
barbar = l_0(2,:)/norm(l_0(2,:));
barside = [barbar*norm(l_0(2,:));barbar*-norm(l_0(2,:))];

% project tangent point
p_scalar = barbar*p_0';

% find intercept, recenter
p_ = p_scalar*barbar+mean(l,1);

% rotate coordinates
R = [cos(pi/2) -sin(pi/2);
    sin(pi/2) cos(pi/2)];
l_r = (R*l_0')'/4;
upperright_ind = find(l_r(:,1)>l_r(:,2));
x = l_r(upperright_ind,:)/norm(l_r(upperright_ind,:));
l_r = l_r + repmat(p_,2,1);

barright = barside+repmat(x*trial.forceProbeStuff.barmodel(3)*2,2,1);
barleft = barside+repmat(x*-trial.forceProbeStuff.barmodel(3)*2,2,1);

line(barright(:,1)+trial.forceProbeStuff.Origin(1),barright(:,2)+trial.forceProbeStuff.Origin(2),'parent',dispax,'color',[.7 .7 .7]);
line(barleft(:,1)+trial.forceProbeStuff.Origin(1),barleft(:,2)+trial.forceProbeStuff.Origin(2),'parent',dispax,'color',[1 .7 .7]);

bar = [barright;flipud(barleft)];
barmask = poly2mask(bar(:,1)+trial.forceProbeStuff.Origin(1),bar(:,2)+trial.forceProbeStuff.Origin(2),size(smooshedframe,1),size(smooshedframe,2));

im = imshow(smooshedframe,[0 quantile(smooshedframe(:),0.975)],'parent',dispax); hold(dispax,'on');
% im = imshow(barmask,[],'parent',dispax);
barshadow = alphamask(barmask, [1 1 0],.3,dispax);

% open the video and creat a matrix for the pixels in ROI X total frames
vid = VideoReader(trial.imageFile);
N = vid.Duration*vid.FrameRate;
h2 = postHocExposure(trial,N);
t = makeInTime(trial.params);
t_i = 5*1/vid.FrameRate;
t_f = trial.params.stimDurInSec-5*1/vid.FrameRate;
frames = find(t(h2.exposure)>t_i & t(h2.exposure)<t_f);
N = length(frames);

pixels = nan(sum(abvthresh1D),length(trialnumlist)*N);


%%
for tr_idx = 1:length(trialnumlist)
    tr_num = trialnumlist(tr_idx);
    trial = load(sprintf(trialStem,tr_num));
    fprintf('%s\n',trial.name);
    
    waitbar((tr_num-trialnumlist(1)+1)/length(trialnumlist),br);
    
    vid = VideoReader(trial.imageFile); %#ok<TNMLP>
    
    br_frame = waitbar(0,regexprep(sprintf(trialStem,tr_num),'_','\\_'));
    br_frame.Name = 'Frames';
        
    kk = 0;
    idx = 0;
    while hasFrame(vid)
        kk = kk+1;
        
        if kk<frames(1)
            readFrame(vid);
            continue
        elseif kk>frames(end)
            break
        end
        waitbar(kk/length(frames),br_frame);
        
        idx = idx+1;
        
        % Now that I've reached the flash point;        
        img3 = double(readFrame(vid));
        img = img3(:,:,1);  
        
        % nan out the pixels near the bar;
        barmask = poly2mask(...
            bar(:,1)+trial.forceProbeStuff.Origin(1)+trial.forceProbeStuff.forceProbePosition(1,kk),...
            bar(:,2)+trial.forceProbeStuff.Origin(2)+trial.forceProbeStuff.forceProbePosition(2,kk),...
            size(smooshedframe,1),size(smooshedframe,2));
        img(~abvthresh|barmask) = nan;
        im.CData = img;
        barshadow.CData(:,:,1) = barmask;
        
        pixels(:,(tr_idx-1)*N+idx) = img(abvthresh1D);
        
    end
    close(br_frame)
end
 
%%
N_cl = 5;
        
excludeframes = any(isnan(pixels),1);

[idx1,C1]=kmeans(pixels(:,~excludeframes),N_cl,'Distance','correlation','Replicates',4);
        
clmask0 = zeros(size(smooshedframe));
clmask = zeros(size(smooshedframe));
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
    
    clmask(clmask==cl) = 0;
    clmask(currcl) = cl;
end

% line(...
%     [h.kmeans_ROI{1}(:,1);h.kmeans_ROI{1}(1,1)],...
%     [h.kmeans_ROI{1}(:,2);h.kmeans_ROI{1}(1,2)],...
%     'parent',dispax,'color',[1 0 0]);

clusterImagePath = sprintf(regexprep(trialStem,{'_Raw_','.mat','_%d'},{'_kmeansCluster_', '','_SelectTrials_%dCl_%d-%d'}),N_cl,trialnumlist(1),trialnumlist(end));
text(10,1000,regexprep(clusterImagePath,'\_','\\_'),'parent',dispax,'fontsize',10,'color',[1 1 1],'verticalAlignment','bottom')
saveas(displayf,[D,clusterImagePath],'png')
hold(dispax,'off');

%%
       
plotclusterfig = figure;
plotclusterfig.Position = [1196 44 560 420];
ax = subplot(1,1,1);

for cl = 1:N_cl
    hold(ax,'on')
    plot(nanmean(pixels(idx1==cl,:),1),'color',clrs(cl,:));
end
        
% Store the cluster pixels,
% these will be used to plot the clusters for all frames in the movie.

for t_idx = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(t_idx)));
    trial.clmask = clmask;
    save(trial.name, '-struct', 'trial')
end

delete(br);

