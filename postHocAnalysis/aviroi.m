function h = aviroi(h,varargin)
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
h2 = postHocExposure(h,N);

frame_times = t(h2.exposure);

frame_nums = (1:length(frame_times))';
frame_roi = frame_nums(frame_times>=t_win(1)& frame_times<=t_win(end));

displayf = figure;           
set(displayf,'position',[40 40 1280 1024]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

kk = 0;
k0 = find(t(h2.exposure)>0,1,'first');
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

    mask = {mov};

    scale = [quantile(mov(:),0.025) 2*quantile(mov(:),0.975)];
    im = imshow(mov,scale,'parent',dispax);
    hold(dispax,'on');
    
    if isfield(h,'ROI')
        for roi_ind = 1:length(h.ROI)
            line(h.ROI{roi_ind}(:,1),h.ROI{roi_ind}(:,2),'parent',dispax,'color',[1 0 0]);
        end
        button = questdlg('Make new ROI?','ROI','No');
    else 
        temp.ROI = getpref('quickshowPrefs','roiScimStackROI');
        for roi_ind = 1:length(temp.ROI)
            line(temp.ROI{roi_ind}(:,1),temp.ROI{roi_ind}(:,2),'parent',dispax,'color',[1 0 0]);
        end
        button = questdlg('Make new ROI?','ROI','No');   
        if strcmp(button,'No');
            h.ROI = temp.ROI;
        end
    end
    if strcmp(button,'Yes');
        h.ROI = {};
        roihand = imfreehand(dispax,'Closed',1);
        roi_temp = wait(roihand);
        h.ROI{1} = roi_temp;
        while ishandle(displayf) && sum(roi_temp(3:end)>2)
            roihand = imfreehand(dispax,'Closed',1);
            roi_temp = wait(roihand);
            if size(roi_temp,1)<=2
                break
            end
            h.ROI{end+1} = roi_temp;
        end
        setpref('quickshowPrefs','roiScimStackROI',h.ROI)

    elseif strcmp(button,'No');
    elseif strcmp(button,'Cancel');
        return
    end
    
    for roi_ind = 1:length(h.ROI)
        mask{roi_ind} = poly2mask(h.ROI{roi_ind}(:,1),h.ROI{roi_ind}(:,2),size(mov,1),size(mov,2));
    end

    break
end


vid = VideoReader(moviename);

kk = 0;
I_traces = nan(N,length(h.ROI));

br = waitbar(0,'Frames');
while hasFrame(vid)
    kk = kk+1;
    waitbar(kk/N,br);
    mov3 = readFrame(vid);
    mov = mov3(:,:,1);
    for roi_ind = 1:length(h.ROI)
        I_masked = mov;
        I_masked(~mask{roi_ind})=nan;
        I_trace = squeeze(nanmean(nanmean(I_masked,2),1));
        I_traces(kk,roi_ind) = I_trace;
    end
end
close(br)
%%
setpref('quickshowPrefs','roiScimStackROI',h.ROI)


%% Save stuff in the trial

% It will be interesting to measure leg angles several times to measure
% variability in my detection

h.roitraces = I_traces;
% h.legposition = legposition;
trial = h;
save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

fprintf(1,'Saving %d avi roi traces for %s %s trial %s\n', ...
    size(I_traces,2),...
    [dateID '_' flynum '_' cellnum], protocol,trialnum);

close(displayf)
%% Plot stuff

figure
% plot tarsus angle
for roi_ind = 1:length(h.ROI)
    subplot(size(I_traces,2),1,roi_ind)
    plot(frame_times,I_traces(:,roi_ind))
end
% plot tibia angle



