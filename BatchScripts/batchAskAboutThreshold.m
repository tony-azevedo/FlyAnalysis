function h = batchAskAboutThreshold(trial,h)
%% Set an ROI that avoids the trace of the probe
% I think I only need 1 for now, but I'll keep the option for multiple

displayf = figure;
set(displayf,'position',[40 40 1280 1024]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

smooshedframe = mean(trial.downsampledImage,3);
scale = [quantile(smooshedframe(:),0.75) 2*quantile(smooshedframe(:),0.975)];
% im = imshow(smooshedframe,scale,'parent',dispax);
im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);

hold(dispax,'on');

if isfield(h,'kmeans_ROI')
    for roi_ind = 1:length(h.kmeans_ROI)
        line(...
            [h.kmeans_ROI{roi_ind}(:,1);h.kmeans_ROI{roi_ind}(1,1)],...
            [h.kmeans_ROI{roi_ind}(:,2);h.kmeans_ROI{roi_ind}(1,2)],...
            'parent',dispax,'color',[1 0 0]);
    end
    button = questdlg('Make new ROI?','ROI','No');
else
    temp.ROI = getpref('quickshowPrefs','avi_kmeans_roi');
    for roi_ind = 1:length(temp.ROI)
        line(...
            [temp.ROI{roi_ind}(:,1);temp.ROI{roi_ind}(1,1)],...
            [temp.ROI{roi_ind}(:,2);temp.ROI{roi_ind}(1,2)],...
            'parent',dispax,'color',[1 0 0]);
    end
    button = questdlg('Make new ROI?','ROI','No');
    if strcmp(button,'No');
        h.kmeans_ROI = temp.ROI;
    end
end
if strcmp(button,'Yes');
    h.kmeans_ROI = {};
    roihand = impoly(dispax,'Closed',1);
    roi_temp = wait(roihand);
    h.kmeans_ROI{1} = roi_temp;
    
    if size(roi_temp,1)<=2
        error('roi is not big enough')
    end

%    Only need 1? Comment out the code below
    setpref('quickshowPrefs','avi_kmeans_roi',h.kmeans_ROI)
    
elseif strcmp(button,'No');
elseif strcmp(button,'Cancel');
    return
end

for roi_ind = 1:length(h.kmeans_ROI)
    mask{roi_ind} = poly2mask(h.kmeans_ROI{roi_ind}(:,1),h.kmeans_ROI{roi_ind}(:,2),size(smooshedframe,1),size(smooshedframe,2));
end


%% Set a threshold for pixel values for the mean
if isfield(h,'kmeans_threshold')
    % Set based on kmeans_threshold
    blwthresh = smooshedframe<h.kmeans_threshold & mask{1};
    hOVM = alphamask(blwthresh, [0 0 1],.1,dispax);

    button = questdlg('Change threshold?','Threshold','No');
else
    temp.threshold = getpref('quickshowPrefs','avi_kmeans_thresh');
    % Set scale on the threshold
    blwthresh = smooshedframe<temp.threshold & mask{1};
    hOVM = alphamask(blwthresh, [0 0 1],.1,dispax);
    
    button = questdlg('Change threshold?','Threshold','No');
    h.kmeans_threshold = temp.threshold;
end
abvthresh = ~blwthresh;

if strcmp(button,'Yes');
    threshcontrolfigure = figure;
    set(threshcontrolfigure,'position',[1433 564 133 420],'menu','none')
    sldr = uicontrol('Style','slider','parent',threshcontrolfigure);
    edtr = uicontrol('Style','edit','parent',threshcontrolfigure);
    sldr.Position = [20 20 20 380];
    edtr.Position = [60 380 60 20];
    edtr.Value = h.kmeans_threshold;
    edtr.String = num2str(edtr.Value);
    
    sldr.Max = 2*quantile(smooshedframe(:),0.975);
    sldr.Min = 0;
    sldr.Value = h.kmeans_threshold;

    sldr.Callback = @updateThreshold;
    edtr.Callback = @updateThreshold;
    uiwait(threshcontrolfigure)
    
    abvthresh = ~blwthresh;
    setpref('quickshowPrefs','avi_kmeans_thresh',h.kmeans_threshold)

    hold(dispax,'off');
    im = imshow(smooshedframe.*abvthresh,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);
    
elseif strcmp(button,'No');
    button = questdlg('Exclude based on imaging?','Exclude?','Yes');
    if strcmp(button,'Yes');
        h.excluded = 1;
        h.badmovie = 1;
        fprintf('Movie is bad');
    end
elseif strcmp(button,'Cancel');
    error('Cancelled');
end

trial = h;
save(trial.name,'-struct','trial')

im.Parent.CLim(1) = h.kmeans_threshold; drawnow

pause(1)
close(displayf);

% Callback function
    function updateThreshold(src,evnt)
        if strcmp(src.Style,'edit')
            src.Value = str2double(src.String);
        end
        h.kmeans_threshold = src.Value;
        sldr.Value = src.Value;
        edtr.Value = src.Value;
        edtr.String = num2str(edtr.Value);
        delete(hOVM);
        blwthresh = smooshedframe<h.kmeans_threshold & mask{1};
        blwthresh = smoothThreshold(blwthresh);

        hold(dispax,'on');

        hOVM = alphamask(blwthresh, [0 0 1],.3,dispax);
    end

    function out = smoothThreshold(in)
        out = imgaussfilt(double(in),3);
        out = out>.1;
    end

end