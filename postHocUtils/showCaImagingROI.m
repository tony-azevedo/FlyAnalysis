%% Set an ROI that avoids the trace of the probe
% I think I only need 1 for now, but I'll keep the option for multiple

vid = VideoReader(trial.imageFile2);
t_i = 10*1/vid.FrameRate + trial.params.preDurInSec;
t_f = min([trial.params.stimDurInSec-5*1/vid.FrameRate,1]);

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

%%
displayf = figure;
displayf.Position = [40 40 640 512];
displayf.ToolBar = 'none';
dispax = axes('parent',displayf,'units','pixels','position',[0 0 640 512]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

colormap(dispax,'gray')
%im = imshow(smooshedframe,[2 8],'parent',dispax);
im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);

%%
hold(dispax,'on');

if isfield(trial,'kmeans_ROI')
    for roi_ind = 1:length(trial.kmeans_ROI)
        line(...
            [trial.kmeans_ROI{roi_ind}(:,1);trial.kmeans_ROI{roi_ind}(1,1)],...
            [trial.kmeans_ROI{roi_ind}(:,2);trial.kmeans_ROI{roi_ind}(1,2)],...
            'parent',dispax,'color',[1 0 0]);
    end
else
    error('NO ROI')
end
