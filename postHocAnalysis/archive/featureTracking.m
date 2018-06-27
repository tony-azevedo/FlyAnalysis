function h = featureTracking(h,handles,savetag,varargin)
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

switch h.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch h.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   
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
output_video = [figpath '\' filename(1:end-4) '_Combined.avi'];

writerObj = VideoWriter(output_video,'Motion JPEG AVI');
writerObj.Quality = 100;
fps = 1/mean(diff(t(h.exposure)));
writerObj.FrameRate = fps;
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
v = h.(invec1)(t>=t_win(1)&t<=t_win(2));
v2 = h.(invec2)(t>=t_win(1)&t<=t_win(2));
y = nan(size(x));
y2 = nan(size(x));

if strcmp('EpiFlash',protocol)
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
        scale = [quantile(mov(:),0.025) 2*quantile(mov(:),0.975)];
        im = imshow(mov,scale,'initialmagnification',50,'parent',dispax);
        hold(dispax,'on');
        
        lastt_idx = 1;
        currt_idx = t_idx_roi(kk);
        y(lastt_idx+1:currt_idx) = v(lastt_idx+1:currt_idx);
        y2(lastt_idx+1:currt_idx) = v2(lastt_idx+1:currt_idx);

        voltage = plot(traceax,x,y,'color',[1 0 0]);
        voltage.YDataSource = 'y';
        %voltage.XDataSource = 'x';
        
        set(traceax,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',[min(v) max(v)],'xlim',[t_idx_roi(kk)-dT t_idx_roi(kk)],'color',[0 0 0]);

        voltage2 = plot(traceax2,x,y2,'color',[1 0 0]);
        voltage2.YDataSource = 'y2';
        %voltage.XDataSource = 'x';
        
        set(traceax2,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',[min(v2) max(v2)],'xlim',[t_idx_roi(kk)-dT t_idx_roi(kk)],'color',[0 0 0]);

        epi = plot(dispax,20,20,'o','markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1],'visible','off');
       
    else
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        scale = [quantile(mov(:),0.025) 1.5*quantile(mov(:),0.975)];

        set(im,'CData',mov);
        %set(dispax,'Clim',scale)

        if kk<=dE
            start_idx = 1;
        else
            start_idx = t_idx_roi(kk-dE);
        end
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
        set(traceax,'xlim',[t(t_idx_roi(kk))-dT t(t_idx_roi(kk))]);
        set(traceax2,'xlim',[t(t_idx_roi(kk))-dT t(t_idx_roi(kk))]);

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


