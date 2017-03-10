function h = responseWithVideo_triggeronly(h,handles,savetag,varargin)
[protocol,dateID,flynum,cellnum,trialnum,init.fileroot] = extractRawIdentifiers(h.name);
init.figpath = [init.fileroot 'figs\']; 
if ~exist(init.figpath,'dir')
    mkdir(init.figpath)
end
set(0, 'DefaultAxesFontName', 'Arial');

% make movie and pdf of each data file
filename = h.name;
moviename = [regexprep(filename, {'Acquisition','_Raw_'},{'Raw_Data','_Images_'}) '.avi'];
checkdir = dir(moviename);
if ~length(checkdir)
    foldername = regexprep(moviename, '.mat.avi','\');
    moviename = dir([foldername protocol '_Image_*']);
    moviename = [foldername moviename(1).name];
    fprintf(1,'Looking for a folder named %s\n',foldername);
end
filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];

switch h.params.mode; case 'VClamp', invec = 'current'; case 'IClamp', invec = 'voltage'; otherwise invec = 'voltage'; end   
t = makeInTime(h.params);


t_win = [t(1) t(end)];
t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];

% frame_times is when the exposures happen in time
h.exposure(1) = 1;
h.exposure(find(h.exposure,1,'last')) = 0;
frame_times = t(h.exposure);

frame_nums = (1:length(frame_times))';
frame_roi = frame_nums(frame_times>=t_win(1)& frame_times<=t_win(end));

% t_ind_roi are the indx for the frames
t_idx_roi = find(h.exposure);
% t_idx_roi = t_idx_roi(frame_roi);

% import movie
vid = VideoReader(moviename);

% open a movie
output_video = [init.figpath '\' filename(1:end-4) '_Combined.avi'];

writerObj = VideoWriter(output_video,'Motion JPEG AVI');
% writerObj.Quality = 100;
writerObj.FrameRate = vid.FrameRate;
open(writerObj);

displayf = figure;           
set(displayf,'position',[720 40 640 512+200]);
dispax = axes('parent',displayf,'units','pixels','position',[0 200 640 512]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

% voltage trace vs time
x = t(t>=t_win(1)&t<=t_win(2));
% % going to plot this trace over the video in blue
% x = x-x(1); x = x/x(end)*640;
v = h.(invec)(t>=t_win(1)&t<=t_win(2));
y = nan(size(x));

if strcmp('EpiFlash',protocol)
    epistim = EpiFlashStim(h.params);
    epistim = epistim(t>=t_win(1)&t<=t_win(2));
else
    epistim = x*0;
end
traceax = axes('parent',displayf,'units','pixels','position',[0 0 640 200]);
set(traceax,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',[min(v) max(v)],'xlim',t_win);
hold(traceax,'on');

kk = 0;
frame0 = 1;
while hasFrame(vid)
    kk = kk+1;
    if kk<frame_roi(1)
        readFrame(vid);
        continue
    elseif kk>frame_roi(end)
        break
    end
    
    if frame0
        frame0 = 0;
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        scale = [quantile(mov(:),0.025) 2*quantile(mov(:),0.975)];
        im = imshow(mov,scale,'initialmagnification',50,'parent',dispax);
        hold(dispax,'on');
        
        lastt_idx = 1;
        currt_idx = t_idx_roi(kk)-t_idx_win(1);
        y(lastt_idx+1:currt_idx) = v(lastt_idx+1:currt_idx);
        voltage = plot(traceax,x,y,'color',[0 0 0]);
        voltage.YDataSource = 'y';
        %voltage.XDataSource = 'x';
        
        epi = plot(dispax,20,20,'o','markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1],'visible','off');
       
    else
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        scale = [quantile(mov(:),0.025) 1.5*quantile(mov(:),0.975)];

        set(im,'CData',mov);
        %set(dispax,'Clim',scale)

        currt_idx = t_idx_roi(kk)-t_idx_win(1);
        y(lastt_idx+1:currt_idx) = v(lastt_idx+1:currt_idx);
        
        if epistim(currt_idx)>.2
            set(epi,'visible','on');
        else
            set(epi,'visible','off');
        end
        refreshdata([voltage],'caller');
    end
    frame = getframe(displayf); 
    writeVideo(writerObj,frame)
    
    lastt_idx = currt_idx;
end

close(writerObj)
%% Save stuff in the trial

% It will be interesting to measure leg angles several times to measure
% variability in my detection

h.frame_roi = frame_roi;
% h.legposition = legposition;
trial = h;
% save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
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



