function h = roi(h,handles,savetag,varargin)
[protocol,dateID,flynum,cellnum,trialnum,D] = extractRawIdentifiers(h.name);
figpath = [D 'figs']; 
if ~exist(figpath,'dir')
    mkdir(figpath)
end
set(0, 'DefaultAxesFontName', 'Arial');

% make movie and pdf of each data file

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

%% exposure has not yet been processed.

if h.exposure(1) == 1 && ~islogical(h.exposure)
    exposure = h.exposure;
    exposure_1_0 = zeros(size(exposure));
    
    % turn exposure into a vector where the end of the exposure -> 1
    exposure_1_0(1:end-1) = exposure(1:end-1).*~exposure(2:end); 
    
    
    % Missed some exposures, find the closest samples
    % but there are also more exposures taken after the end of the
    % video
    % so, first check some things
        
    exp_idx = find(exposure_1_0);
    samples = diff(exp_idx);
    fr = mode(samples); % standard frame rate
    
    % the second exposure often takes a bit longer
    delayedexp = 0;
    if samples(1)>fr*1.1 || samples(1)<fr*.9
        delayedexp = 1;
    end
    
    % Fill in the exposures that must have happend
    missed = find(samples>1.95*fr&samples<2.05*fr);
    
    if samples(1)>1.95*fr && samples(1)<2.05*fr
        missed = missed(2:end);
    end

    exposure_1_0(exp_idx(missed)+fr) = 1;
            
    exp_idx = find(exposure_1_0);
    exposure_1_0(exp_idx>N) = 0;
    
    h.exposure = logical(exposure_1_0);
else
   error('Exposure vector is not well conditioned for current analysis'); 
end

%%
frame_times = t(h.exposure);

frame_nums = (1:length(frame_times))';
frame_roi = frame_nums(frame_times>=t_win(1)& frame_times<=t_win(end));

% t_ind_roi are the indx for the frames
t_idx_roi = find(h.exposure);
% t_idx_roi = t_idx_roi(frame_roi);

% open a movie
% output_video = [figpath '\' filename(1:end-4) '_Combined.avi'];
% 
% writerObj = VideoWriter(output_video,'Motion JPEG AVI');
% writerObj.Quality = 100;
% fps = 1/mean(diff(t(h.exposure)));
% writerObj.FrameRate = fps;
% open(writerObj);

displayf = figure;           
set(displayf,'position',[40 40 1280 1024]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

kk = 0;
frame0 = 1;
k0 = find(t(t_idx_roi)>0,1,'first');
while hasFrame(vid)
    kk = kk+1;
    if kk<k0
        readFrame(vid);
        continue
    elseif kk>frame_roi(end)
        break
    end
    
    mov3 = readFrame(vid);
    mov = mov3(:,:,1);
    scale = [quantile(mov(:),0.025) 2*quantile(mov(:),0.975)];
    im = imshow(mov,scale,'parent',dispax);
    hold(dispax,'on');
    
    if isfield(h,'ROI')
        for roi_ind = 1:length(h.ROI)
            line(h.ROI{roi_ind}(:,1),h.ROI{roi_ind}(:,2),'parent',roidrawax,'color',[1 0 0]);
        end
        button = questdlg('Make new ROI?','ROI','No');
    else 
        temp.ROI = getpref('quickshowPrefs','roiScimStackROI');
        for roi_ind = 1:length(temp.ROI)
            line(temp.ROI{roi_ind}(:,1),temp.ROI{roi_ind}(:,2),'parent',roidrawax,'color',[1 0 0]);
        end
        button = questdlg('Make new ROI?','ROI','No');   
        if strcmp(button,'No');
            h.ROI = temp.ROI;
        end
    end
    if strcmp(button,'Yes');
        h.ROI = {};
        roihand = imfreehand(roidrawax,'Closed',1);
        roi_temp = wait(roihand);
        h.ROI{1} = roi_temp;
        while ishandle(roifig) && sum(roi_temp(3:end)>2)
            roihand = imfreehand(roidrawax,'Closed',1);
            roi_temp = wait(roihand);
            if size(roi_temp,1)<=2
                break
            end
            h.ROI{end+1} = roi_temp;
        end
    end

    break
end


vid = VideoReader(moviename);

kk = 0;
I_traces = nan(N,length(h.ROI));

while hasFrame(vid)
    kk = kk+1;
    
    mov3 = readFrame(vid);
    mov = mov3(:,:,1);
    tic; fprintf('Calculating: ');
    for roi_ind = 1:length(data.ROI)
        I_masked = I0;
        roihand = impoly(roidrawax,data.ROI{roi_ind});
        mask = createMask(roihand);
        I_masked(~repmat(mask,[1 1 num_frame num_chan]))=nan;
        I_trace = squeeze(nanmean(nanmean(I_masked,2),1));
        I_traces(:,:,roi_ind) = I_trace;
    end
    toc, fprintf('Closing');
    close(roifig);
    toc

end


%% Save stuff in the trial

% It will be interesting to measure leg angles several times to measure
% variability in my detection

h.frame_roi = frame_roi;
% h.legposition = legposition;
trial = h;
% save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

fprintf(1,'Saving %d Frames (%d-%d of %d)\n\t for %s %s trial %s\n', ...
    length(frame_roi),...
    frame_roi(1),...
    frame_roi(end),...
    length(frame_nums),...
    [dateID '_' flynum '_' cellnum], protocol,trialnum);

close(displayf)
%% Plot stuff
    
% plot tarsus angle

% plot tibia angle



