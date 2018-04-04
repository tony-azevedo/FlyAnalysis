function h = responseWithVideo_2T_stationary(h,handles,savetag,varargin)
[protocol,dateID,flynum,cellnum,trialnum,D] = extractRawIdentifiers(h.name);
figpath = [D 'figs']; 
if ~exist(figpath,'dir')
    mkdir(figpath)
end
set(0, 'DefaultAxesFontName', 'Arial');

% make movie and pdf of each data file

checkdir = dir(h.imageFile);
if isempty(checkdir)
    checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(h.params.trial) '_' datestr(h.timestamp,29) '*.avi']));
end

if isempty(checkdir)
    moviename = [regexprep(h.name, {'Acquisition','_Raw_'},{'Raw_Data','_Images_'}) '.avi'];
    foldername = regexprep(moviename, '.mat.avi','\');
    moviename = dir([foldername protocol '_Image_*']);
    moviename = [foldername moviename(1).name];
    fprintf(1,'Looking for a folder named %s\n',foldername);
else
    moviename = checkdir(1).name;
end
filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];

switch h.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch h.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   
t = makeInTime(h.params);

t_win = [t(1) t(end)];
t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];

% import movie
vid = VideoReader(moviename);
N = round(vid.Duration*vid.FrameRate);
h2 = postHocExposure(h,N);

frame_times = t(h2.exposure);

frame_nums = (1:length(frame_times))';
frame_roi = frame_nums(frame_times>=t_win(1)& frame_times<=t_win(end));

% t_ind_roi are the indx for the frames
t_idx_roi = find(h2.exposure);
% t_idx_roi = t_idx_roi(frame_roi);

% open a movie

% what speed?
factor = inputdlg('How Slow?','Movie speed',1,{'1'});
factor = str2double(factor{1});
if factor>10
    error('Choose a reasonable factor')
end

% scale?
scaletime = inputdlg('Scale? When?','Start scaling',1,{'NaN'});
scaletime = str2double(scaletime{1});
notscaled = 1;
if isnan(scaletime)
    notscaled = 0;
    warning('Not scaling intensity')
end
if scaletime == -1
    scaletime = t_win(1);
end

fps = 1/mean(diff(t(h2.exposure)));

% if the "use camera rate" button on the flycap software is not used, and
% the user inputs the number himself, the framerate of the video will
% differ from the frame rate of the exposures
if abs(fps-vid.FrameRate)/fps > .01
    warning('Exposures and video frame rate are inconsistent, using exposures for framerate information')
    N = min([N length(t_idx_roi)]);
    if N<vid.Duration*vid.FrameRate
        warning('Fewer exposures during the trial than in entire video');
    end
end
fps = fps/factor;
if factor>1
    fps = round(fps);
end

output_video = [figpath '\' filename(1:end-4) '_R1R2_' num2str(factor) 'X.avi'];

writerObj = VideoWriter(output_video,'Motion JPEG AVI');
writerObj.Quality = 100;
writerObj.FrameRate = fps;
open(writerObj);

displayf = figure;           
set(displayf,'position',[720 40 640 512+200],'color',[0 0 0]);
dispax = axes('parent',displayf,'units','pixels','position',[0 200 640 512]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

% voltage trace vs time
x = t(t>=t_win(1)&t<=t_win(2));
% % going to plot this trace over the video in blue
% x = x-x(1); x = x/x(end)*640;
v = h.(invec1)(t>=t_win(1)&t<=t_win(2));
v2 = h.(invec2)(t>=t_win(1)&t<=t_win(2));
y = nan(size(x));
y2 = nan(size(x));

if strcmp('EpiFlash2T',protocol)
    epistim = EpiFlashStim(h.params);
    epistim = epistim(t>=t_win(1)&t<=t_win(2));
else
    epistim = x*0;
end
traceax = axes('parent',displayf,'units','pixels','position',[0 100 640 100]);
traceax2 = axes('parent',displayf,'units','pixels','position',[0 0 640 100]);
hold(traceax,'on');
hold(traceax2,'on');

dE = 40;
dT = abs(t(t_idx_roi(dE))-t(t_idx_roi(1)));

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
%         scale = [quantile(mov(:),0.025) 2*quantile(mov(:),0.975)];
%         im = imshow(mov,scale,'initialmagnification',50,'parent',dispax);
        im = imshow(mov,'initialmagnification',50,'parent',dispax);
        hold(dispax,'on');
        
        lastt_idx = 1;
        currt_idx = t_idx_roi(kk);
        y(lastt_idx+1:currt_idx) = v(lastt_idx+1:currt_idx);
        y2(lastt_idx+1:currt_idx) = v2(lastt_idx+1:currt_idx);

        voltage = plot(traceax,x,y,'color',[1 0 0]);
        voltage.YDataSource = 'y';
        %voltage.XDataSource = 'x';
        
        xlims = [t(1) t(t_idx_roi(N))];
        dT = diff(xlims);
        xlims = xlims + [-.05*dT 0];
        ylims = [min(v)-1 max(v)+1];
        set(traceax,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims,'xlim',xlims,'color',[0 0 0]);

        % make scale bars
        bary = appropriateScaleBar(ylims);
        line((t(1)-.02*dT)*[1 1] ,ylims(1)+[0 bary],'parent',traceax,'color',[1 0 0]);
        lab = text((t(1)-.02*dT),ylims(1),[num2str(bary) ' mV'],'parent',traceax);
        set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 0 0])
        
        voltage2 = plot(traceax2,x,y2,'color',[1 0 0]);
        voltage2.YDataSource = 'y2';
        %voltage.XDataSource = 'x';
        
        ylims = [min(v2)-1 max(v2)+1];
        set(traceax2,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims,'xlim',xlims,'color',[0 0 0]);

        epi = plot(dispax,20,20,'o','markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1],'visible','off');
       
        % make scale bars
        bary = appropriateScaleBar(ylims);
        line((t(1)-.02*dT)*[1 1] ,ylims(1)+[0 bary],'parent',traceax2,'color',[1 0 0]);
        lab = text((t(1)-.02*dT),ylims(1),[num2str(bary) ' pA'],'parent',traceax2);
        set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 0 0])

    else
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        scale = [quantile(mov(:),0.025) 1.5*quantile(mov(:),0.975)];

        set(im,'CData',mov);
        if frame_times(kk)>scaletime && notscaled && any(scale>50)
            notscaled = 0;

            scale = [quantile(mov(:),0.025) 1.5*quantile(mov(:),0.975)];
            set(dispax,'Clim',scale)
        end

%         if kk<=dE
            start_idx = 1;
%         else
%             start_idx = t_idx_roi(kk-dE);
%         end
        currt_idx = t_idx_roi(kk);
        y(start_idx:currt_idx) = v(start_idx:currt_idx);
        y(currt_idx:end) = nan;
        y(1:start_idx-1) = nan;

        y2(start_idx:currt_idx) = v2(start_idx:currt_idx);
        y2(currt_idx:end) = nan;
        y2(1:start_idx-1) = nan;

        if epistim(currt_idx)>.2
            set(epi,'visible','on');
        else
            set(epi,'visible','off');
        end
        refreshdata([voltage],'caller');
        refreshdata([voltage2],'caller');
%         set(traceax,'xlim',[t_idx_roi(1) t_idx_roi(N)]);
%         set(traceax2,'xlim',[t_idx_roi(1) t_idx_roi(N)]);

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



