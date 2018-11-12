function trial = batchAskAboutThreshold(trial)
%% Set an ROI that avoids the trace of the probe
% I think I only need 1 for now, but I'll keep the option for multiple

vid = VideoReader(trial.imageFile2);
t_i = 10*1/vid.FrameRate + trial.params.preDurInSec;
t_f = trial.params.stimDurInSec-5*1/vid.FrameRate;


vid.CurrentTime = t_i;
cnt = 1;
frame = double(readFrame(vid));
while vid.CurrentTime<t_f
    cnt = cnt+1;
    frame = frame+double(readFrame(vid));
    if ~mod(cnt,10)
        fprintf('.')
    end
end
fprintf('\n')

smooshedframe = frame./cnt;

%%
displayf = figure;
displayf.Position = [40 40 640 512];
dispax = axes('parent',displayf,'units','pixels','position',[0 0 640 512]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

colormap(dispax,'gray')
im = imshow(smooshedframe,[2 8],'parent',dispax);
% im = imshow(frame,[0 quantile(frame(:),0.975)],'parent',dispax);
%%
hold(dispax,'on');

if isfield(trial,'kmeans_ROI')
    for roi_ind = 1:length(trial.kmeans_ROI)
        line(...
            [trial.kmeans_ROI{roi_ind}(:,1);trial.kmeans_ROI{roi_ind}(1,1)],...
            [trial.kmeans_ROI{roi_ind}(:,2);trial.kmeans_ROI{roi_ind}(1,2)],...
            'parent',dispax,'color',[1 0 0]);
    end
    button = questdlg('Make new ROI?','ROI','No');
else
    temp.ROI = getacqpref('quickshowPrefs','avi_kmeans_roi');
    for roi_ind = 1:length(temp.ROI)
        line(...
            [temp.ROI{roi_ind}(:,1);temp.ROI{roi_ind}(1,1)],...
            [temp.ROI{roi_ind}(:,2);temp.ROI{roi_ind}(1,2)],...
            'parent',dispax,'color',[1 0 0]);
    end
    button = questdlg('Make new ROI?','ROI','No');
    if strcmp(button,'No')
        trial.kmeans_ROI = temp.ROI;
    end
end
if strcmp(button,'Yes')
    trial.kmeans_ROI = {};
    roihand = impoly(dispax,'Closed',1);
    roi_temp = wait(roihand);
    trial.kmeans_ROI{1} = roi_temp;
    
    if size(roi_temp,1)<=2
        error('roi is not big enough')
    end

%    Only need 1? Comment out the code below
    setacqpref('quickshowPrefs','avi_kmeans_roi',trial.kmeans_ROI)
    
elseif strcmp(button,'No')
elseif strcmp(button,'Cancel')
    return
end

for roi_ind = 1:length(trial.kmeans_ROI)
    mask{roi_ind} = poly2mask(trial.kmeans_ROI{roi_ind}(:,1),trial.kmeans_ROI{roi_ind}(:,2),size(smooshedframe,1),size(smooshedframe,2));
end


%% Set a threshold for pixel values for the mean
if isfield(trial,'kmeans_threshold')
    % Set based on kmeans_threshold
    blwthresh = smooshedframe<trial.kmeans_threshold & mask{1};
    blwthresh = imgaussfilt(double(blwthresh),3)>.1;
    hOVM = alphamask(blwthresh, [0 0 1],.3,dispax);
    hOVM.Tag = 'blwthresh';
    
    button = questdlg('Change threshold?','Threshold','No');
else
    temp.threshold = getacqpref('quickshowPrefs','avi_kmeans_thresh');
    % Set scale on the threshold
    blwthresh = smooshedframe<temp.threshold & mask{1};
    blwthresh = imgaussfilt(double(blwthresh),3)>.1;

    hOVM = alphamask(blwthresh, [0 0 1],.1,dispax);
    hOVM.Tag = 'blwthresh';
    
    button = questdlg('Change threshold?','Threshold','No');
    trial.kmeans_threshold = temp.threshold;
end
abvthresh = ~blwthresh;

if strcmp(button,'Yes')
    threshcontrolfigure = figure;
    set(threshcontrolfigure,'position',[1433 564 133 420],'menu','none')
    sldr = uicontrol('Style','slider','parent',threshcontrolfigure);
    edtr = uicontrol('Style','edit','parent',threshcontrolfigure);
    sldr.Position = [20 20 20 380];
    edtr.Position = [60 380 60 20];
    edtr.String = num2str(edtr.Value);
    edtr.UserData = sldr;
    
    sldr.Max = 2*quantile(smooshedframe(:),0.975);
    sldr.Min = 0;
    sldr.Value = min([trial.kmeans_threshold,sldr.Max]);
    edtr.Value = sldr.Value;
    edtr.String = num2str(edtr.Value);

    sldr.Callback = {@updateThreshold,smooshedframe,mask{1},sldr,edtr,dispax};
    edtr.Callback = {@updateThreshold,smooshedframe,mask{1},sldr,edtr,dispax};

    uiwait(threshcontrolfigure)

    hOVM =findobj(dispax,'Tag','blwthresh');
    trial.kmeans_threshold = hOVM.UserData;
    abvthresh = hOVM.AlphaData;
    setacqpref('quickshowPrefs','avi_kmeans_thresh',trial.kmeans_threshold)

    hold(dispax,'off');
    im = imshow(smooshedframe.*(~abvthresh>0),[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);
    
elseif strcmp(button,'No')
    button = questdlg('Exclude based on imaging?','Exclude?','No');
    if strcmp(button,'Yes')
        trial.excluded = 1;
        trial.badmovie = 1;
        fprintf('Movie is bad');
    end
elseif strcmp(button,'Cancel')
    error('Cancelled');
end

save(trial.name,'-struct','trial')

im.Parent.CLim(1) = trial.kmeans_threshold; drawnow

% pause(1)
% close(displayf);

% Callback function

end