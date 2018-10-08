function trial = slowAndAverageVideo(trial)
%% Set an ROI that avoids the trace of the probe
% I think I only need 1 for now, but I'll keep the option for multiple

displayf = figure;
displayf.Position = [40 40 640 512];
dispax = axes('parent',displayf,'units','pixels','position',[0 0 640 512]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

colormap(dispax,'gray')

vid = VideoReader(trial.imageFile2);
N = vid.Duration*vid.FrameRate;

[~,~,~,~,~,D] = extractRawIdentifiers(trial.name);
figpath = [D 'figs']; 
if ~exist(figpath,'dir')
    mkdir(figpath)
end

output_video = fullfile(figpath,[trial.imageFile2(1:end-4) '_slow2X_.avi']);

writerObj = VideoWriter(output_video,'Motion JPEG AVI');
writerObj.Quality = 100;
writerObj.FrameRate = vid.FrameRate;
open(writerObj);

t_i = 10*1/vid.FrameRate + trial.params.preDurInSec;
t_f = trial.params.stimDurInSec-5*1/vid.FrameRate;

vid.CurrentTime = t_i;

frame_0 = double(readFrame(vid));
im = imshow(frame_0,[2 18],'parent',dispax);

frame_1 = double(readFrame(vid));
frame = frame_1;

while vid.CurrentTime<t_f
    frame_2 = double(readFrame(vid));    

    frame = 1/3*(frame_2+frame_1+frame_0);
    im.CData = frame;
    drawnow
    
    wvframe = getframe(displayf);
    writeVideo(writerObj,wvframe)

    frame_0 = frame_1;
    frame_1 = frame_2;
end

close(writerObj)
