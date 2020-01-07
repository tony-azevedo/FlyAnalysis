function trial = smoothOutBrightPixels(trial)
%% Set an ROI that avoids the trace of the probe
% I think I only need 1 for now, but I'll keep the option for multiple

displayf = figure;
displayf.Position = [0 0 1280 1064];
displayf.MenuBar = 'none';
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

colormap(dispax,'gray')

vid = VideoReader(trial.imageFile);
N = round(vid.Duration*vid.FrameRate);
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
t_f = trial.params.durSweep-5*1/vid.FrameRate;
if ~startAt0 && isempty(strfind(trial.params.protocol,'Sweep'))
    t_i = -trial.params.preDurInSec+t_i;
    t_f = trial.params.stimDurInSec-5*1/vid.FrameRate;
end
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

im = imshow(smooshedframe,[0 quantile(smooshedframe(:),0.975)],'parent',dispax);
%%
hold(dispax,'on');

if isfield(trial,'brightSpots2Smooth')
    for roi_ind = 1:length(trial.brightSpots2Smooth)
        line(...
            [trial.brightSpots2Smooth{roi_ind}(:,1);trial.brightSpots2Smooth{roi_ind}(1,1)],...
            [trial.brightSpots2Smooth{roi_ind}(:,2);trial.brightSpots2Smooth{roi_ind}(1,2)],...
            'parent',dispax,'color',[1 0 0]);
    end
    button = questdlg('Make new bright spot ROIs?','Spots','No');
else
    temp.ROI = getacqpref('quickshowPrefs','brightSpots2Smooth');
    for roi_ind = 1:length(temp.ROI)
        line(...
            [temp.ROI{roi_ind}(:,1);temp.ROI{roi_ind}(1,1)],...
            [temp.ROI{roi_ind}(:,2);temp.ROI{roi_ind}(1,2)],...
            'parent',dispax,'color',[1 0 0]);
    end
    button = questdlg('Make new ROI?','ROI','No');
    if strcmp(button,'No')
        trial.brightSpots2Smooth = temp.ROI;
    end
end
if strcmp(button,'Yes')
    trial.brightSpots2Smooth = {};
    roihand = impoly(dispax,'Closed',1);
    roi_temp = wait(roihand);
    trial.brightSpots2Smooth{1} = roi_temp;
    
    if size(roi_temp,1)<=2
        error('roi is not big enough')
    end
    while ishandle(displayf) && sum(roi_temp(3:end)>2)
        roihand = impoly(dispax,'Closed',1);
        roi_temp = wait(roihand);
        if size(roi_temp,1)<=2
            break
        end
        trial.brightSpots2Smooth{end+1} = roi_temp;
    end
    
%    Only need 1? Comment out the code below
    setacqpref('quickshowPrefs','brightSpots2Smooth',trial.brightSpots2Smooth)
    
elseif strcmp(button,'No')
elseif strcmp(button,'Cancel')
    return
end

%% Smooth out the spot to show

for roi_ind = 1:length(trial.brightSpots2Smooth)
    spot = trial.brightSpots2Smooth{roi_ind};
    centroid = mean(spot,1); centroids = repmat(centroid,size(spot,1),1);
    annulus = (spot-centroids)*2+centroids;
    
    line(...
        [annulus(:,1);annulus(1,1)],...
        [annulus(:,2);annulus(1,2)],...
        'parent',dispax,'color',[0 1 0]);
    line(centroid(1,1),centroid(1,2),'parent',dispax,'marker','o','markeredgecolor',[0 0 1],'markerfacecolor',[1 1 1]);
    
    spotmask = poly2mask(spot(:,1),spot(:,2),size(smooshedframe,1),size(smooshedframe,2));
    annulusmask = poly2mask(annulus(:,1),annulus(:,2),size(smooshedframe,1),size(smooshedframe,2));
    annulusvals = smooshedframe(annulusmask&~spotmask);
    I = mean(annulusvals);
    
    smooshedframe(spotmask) = I;
    im.CData = smooshedframe;
end

%%
save(trial.name,'-struct','trial')

pause(1)
close(displayf);


end