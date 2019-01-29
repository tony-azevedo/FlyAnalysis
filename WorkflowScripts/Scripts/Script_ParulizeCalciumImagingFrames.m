%% Script for turning an EpiFlashMovie into a parulized movie
% But only for trials I've closely looked and that are similar (ie same
% imaging field and length)

% Assuming I'm in a directory where the movies are to be processed
close all
%%
vid = VideoReader(trial.imageFile2);
t_i = trial.params.preDurInSec; % give it 50 ms after light turns on
t_f = trial.params.stimDurInSec+trial.params.preDurInSec;

t = makeInTime(trial.params);
t2 = postHocExposure2(trial,vid.Duration*vid.FrameRate);
ft = t(t2.exposure2);

vid.CurrentTime = t_i;
cnt = 1;
frame3 = readFrame(vid);
frame = double(squeeze(frame3(:,:,1)));
minpixval = Inf;
maxpixval = -Inf;
while vid.CurrentTime<t_f
    cnt = cnt+1;
    frame3 = readFrame(vid);
    frame = double(squeeze(frame3(:,:,1)));
    smooshedframe = smooshedframe+frame;
    if ~mod(cnt,10)
        fprintf('.')
    end
    minpixval = min([minpixval quantile(frame(:),.02)]);
    maxpixval = max([maxpixval quantile(frame(:),.99)]);
    
end
fprintf('\n')

smooshedframe = smooshedframe./cnt;

wh = fliplr(size(smooshedframe));

%%
D = fileparts(trial.name);
figpath = fullfile(D,'figs');
if ~exist(figpath,'dir')
    mkdir(figpath)
end

% factor = inputdlg('How Slow?','Movie speed',1,{'1'});
% factor = str2double(factor{1});
factor = 8;
if factor>10
    error('Choose a reasonable factor')
end

output_video = [figpath '\' trial.imageFile2(1:end-4) '_Paru_' num2str(factor) 'X.avi'];

writerObj = VideoWriter(output_video,'Archival');
% writerObj.Quality = 100;

writerObj.FrameRate = vid.FrameRate/factor;
open(writerObj);

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

im = imshow(smooshedframe,'parent',dispax);

set(dispax,'Clim',[minpixval 1.1*maxpixval])

%%
% if isfield(trial,'MNStimROI')
%     for roi_ind = 1:length(trial.ROI)
%         line(trial.ROI{roi_ind}(:,1),trial.ROI{roi_ind}(:,2),'parent',dispax,'color',[1 0 0]);
%     end
%     button = questdlg('Make new ROI?','ROI','No');
% else
%     if ~isacqpref('quickshowPrefs','MNStimROI')
%         setacqpref('quickshowPrefs','MNStimROI',{[
%             1.1800    0.0260
%             1.1800    0.0980
%             1.2730    0.1010]*1E3});
% 
%     end
%     temp.ROI = getacqpref('quickshowPrefs','MNStimROI');
%     for roi_ind = 1:length(temp.ROI)
%         line(temp.ROI{roi_ind}(:,1),temp.ROI{roi_ind}(:,2),'parent',dispax,'color',[1 0 0]);
%     end
%     button = questdlg('Make new ROI?','ROI','No');
%     if strcmp(button,'No')
%         trial.ROI = temp.ROI;
%     end
% end
temp.ROI = getacqpref('quickshowPrefs','MNStimROI');
trial.ROI = temp.ROI;
button = 'No';
if strcmp(button,'Yes')
    trial.ROI = {};
    roihand = drawfreehand(dispax,'Closed',1);
    trial.ROI{1} = roihand.Position;
    while isvalid(displayf) && size(roihand.Position,1)>2
        roihand = drawfreehand(dispax,'Closed',1);
        if size(roihand.Position,1)<=2
            break
        end
        trial.ROI{end+1} = roihand.Position;
    end
    setacqpref('quickshowPrefs','MNStimROI',trial.ROI)
    
elseif strcmp(button,'No')
elseif strcmp(button,'Cancel')
    return
end

for roi_ind = 1:length(trial.ROI)
    mask{roi_ind} = poly2mask(trial.ROI{roi_ind}(:,1),trial.ROI{roi_ind}(:,2),size(frame,1),size(frame,2));
end

setacqpref('quickshowPrefs','MNStimROI',trial.ROI)

%% Write the movie

colormap(dispax,'parula')
colormap(displayf,'parula')
vid.CurrentTime = t_i;
kk = find(ft-ft(1)<t_i,1,'last');

I_traces = nan(N,length(trial.ROI));

while vid.CurrentTime<t_f
    kk = kk+1;
    frame_in = double(rgb2gray(readFrame(vid)));
    im.CData = frame_in;
    drawnow
    
    for roi_ind = 1:length(trial.ROI)
        I_masked = frame_in;
        I_masked(~mask{roi_ind})=nan;
        I_trace = squeeze(nanmean(nanmean(I_masked,2),1));
        I_traces(kk,roi_ind) = I_trace;
    end

    frame_out = getframe(dispax);
    writeVideo(writerObj,frame_out)
    %pause
end

close(writerObj)


%% Save stuff in the trial

% It will be interesting to measure leg angles several times to measure
% variability in my detection

trial.roitraces = I_traces;
% h.legposition = legposition;
save(trial.name, '-struct', 'trial');

fprintf(1,'Saving %d avi roi traces for %s\n', ...
    size(I_traces,2),...
    trial.name);

close(displayf)

%% Plot stuff

figure
for roi_ind = 1:length(trial.ROI)
    subplot(size(I_traces,2),1,roi_ind)
    plot(ft,I_traces(:,roi_ind))
end

drawnow