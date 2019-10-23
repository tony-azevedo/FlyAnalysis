% function trial = responseWithVideo_2T_probe(trial,handles,savetag,varargin)
[protocol,dateID,flynum,cellnum,trialnum,D] = extractRawIdentifiers(trial.name);
figpath = [D 'figs']; 
if ~exist(figpath,'dir')
    mkdir(figpath)
end
set(0, 'DefaultAxesFontName', 'Arial');

% make movie and pdf of each data file
if ~isfield(trial,'forceProbeStuff')
    error('This trial has no probe stuff. Use responseWithVideo_2T_stationary instead');
end

checkdir = dir(trial.imageFile);
if isempty(checkdir)
    checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(trial.params.trial) '_' datestr(trial.timestamp,29) '*.avi']));
end

if isempty(checkdir)
    moviename = [regexprep(trial.name, {'Acquisition','_Raw_'},{'Raw_Data','_Images_'}) '.avi'];
    foldername = regexprep(moviename, '.mat.avi','\');
    moviename = dir([foldername protocol '_Image_*']);
    moviename = [foldername moviename(1).name];
    fprintf(1,'Looking for a folder named %s\n',foldername);
else
    moviename = checkdir(1).name;
end
filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];

switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   
t = makeInTime(trial.params);

t_win = [t(1) t(end)];
t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];

% import movie
vid = VideoReader(moviename);
N = round(vid.Duration*vid.FrameRate);
h2 = postHocExposure(trial,N);

frame_times = t(h2.exposure);

frame_nums = (1:length(frame_times))';
frame_roi = frame_nums(frame_times>=t_win(1)& frame_times<=t_win(end));

% t_ind_roi are the indx for the frames
t_idx_roi = find(h2.exposure);
% t_idx_roi = t_idx_roi(frame_roi);


%% what speed?
% factor = inputdlg('How Slow?','Movie speed',1,{'1'});
% factor = str2double(factor{1});
factor = 1;
if factor>10
    error('Choose a reasonable factor')
end

%% Set the scales
% IR
vid.CurrentTime = trial.params.preDurInSec;
mov3 = readFrame(vid);
mov = mov3(:,:,1);
scale = [quantile(mov(:),0.025) 1.5*quantile(mov(:),0.975)];
% scale(2) = 50;

%%
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
set(displayf,'position',[720 40 640 512+300],'color',[0 0 0]);
dispax = axes('parent',displayf,'units','pixels','position',[0 300 640 512]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

% voltage trace vs time
x = t(t>=t_win(1)&t<=t_win(2));
% % going to plot this trace over the video in blue
% x = x-x(1); x = x/x(end)*640;
v = trial.(invec1)(t>=t_win(1)&t<=t_win(2));
v2 = trial.(invec2)(t>=t_win(1)&t<=t_win(2));
y = nan(size(x));
y2 = nan(size(x));

ft = makeFrameTime(trial);
x_ft = ft(ft>=t_win(1)&ft<=t_win(2));

prb = trial.forceProbeStuff.CoM;
prb = prb(ft>=t_win(1)&ft<=t_win(2));
y3 = nan(size(prb));

if strcmp('EpiFlash2T',protocol)
    epistim = EpiFlashStim(trial.params);
    epistim = epistim(t>=t_win(1)&t<=t_win(2));
else
    epistim = x*0;
end
traceax = axes('parent',displayf,'units','pixels','position',[10 100 620 90]);
traceax2 = axes('parent',displayf,'units','pixels','position',[10 0 620 90]);
traceax3 = axes('parent',displayf,'units','pixels','position',[10 200 620 90]);
hold(traceax,'on');
hold(traceax2,'on');
hold(traceax3,'on');

dE = 40;
dT = abs(t(t_idx_roi(dE))-t(t_idx_roi(1)));

kk = 1;
frame0 = 1;

vid.CurrentTime = 0;


while hasFrame(vid)    
    if frame0
        frame0 = 0;
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
%         scale = [quantile(mov(:),0.025) 2*quantile(mov(:),0.975)];
%         im = imshow(mov,scale,'initialmagnification',50,'parent',dispax);
        im = imshow(mov,'initialmagnification',50,'parent',dispax);
        set(dispax,'Clim',scale)

        hold(dispax,'on');
        
        lastt_idx = 1;
        currt_idx = t_idx_roi(kk);
        y(lastt_idx+1:currt_idx) = v(lastt_idx+1:currt_idx);
        y2(lastt_idx+1:currt_idx) = v2(lastt_idx+1:currt_idx);

        % ---- plot voltage -----
        voltage = plot(traceax,x,y,'color',[1 1 1]);
        voltage.YDataSource = 'y';
        %voltage.XDataSource = 'x';
        
        xlims = [t(1) t(t_idx_roi(N))];
        dT = diff(xlims);
        xlims = xlims + [-.05*dT 0];
        ylims1 = [min(v)-1 max(v)+1];
        set(traceax,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims1,'xlim',xlims,'color',[0 0 0],'xcolor',[0 0 0],'ycolor',[0 0 0]);

        % ---- plot EMG -----
        voltage2 = plot(traceax2,x,y2,'color',[1 1 1 ]);
        voltage2.YDataSource = 'y2';
        %voltage.XDataSource = 'x';
       
        ylims2 = [min(v2)-1 max(v2)+1];
        % ylims2 = [-50 50];
        set(traceax2,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims2,'xlim',xlims,'color',[0 0 0],'xcolor',[0 0 0],'ycolor',[0 0 0]);


        % ---- plot Probe -----
        prb_CoM = plot(traceax3,x_ft,y3,'color',[1 0 0]);
        prb_CoM.YDataSource = 'y3';
        %voltage.XDataSource = 'x';

        ylims3 = [min(prb)-1 max(prb)+1];
        set(traceax3,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims3,'xlim',xlims,'color',[0 0 0],'xcolor',[0 0 0],'ycolor',[0 0 0]);

        %% make scale bars
        [~,outname] = fileparts(output_video);
        fprintf('Scalebars: %s\n',outname);
        
        % whole cell
        bary = appropriateScaleBar(ylims1);
        line((t(1)-.02*dT)*[1 1] ,ylims1(1)+.2*bary+[0 bary],'parent',traceax,'color',[1 1 1],'Linewidth',2);
        %         lab = text((t(1)-.02*dT),ylims(1)+.2*bary,[num2str(bary) ' mV'],'parent',traceax);
        %         set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 1 1])
        %         lab = text((t(1)+.05*dT),ylims(2)-.2*bary,'Membrane potential','parent',traceax);
        %         set(lab,'VerticalAlignment','top','HorizontalAlignment','left','color',[1 1 1])
        fprintf('%s\n',[num2str(bary) ' mV']);

        % EMG
        bary = appropriateScaleBar(ylims2);
        line((t(1)-.02*dT)*[1 1] ,ylims2(1)+.2*bary+[0 bary],'parent',traceax2,'color',[1 1 1],'Linewidth',2);
        %         lab = text((t(1)-.02*dT),ylims(1)+.2*bary,[num2str(bary) ' pA'],'parent',traceax2);
        %         set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 1 1])
        %         lab = text((t(1)+.05*dT),ylims(2)-.2*bary,'EMG','parent',traceax2);
        %         set(lab,'VerticalAlignment','top','HorizontalAlignment','left','color',[1 1 1])
        fprintf('%s\n',[num2str(bary) ' pA']);

        % Probe
        bary = appropriateScaleBar(ylims3);
        line((t(1)-.02*dT)*[1 1] ,ylims3(1)+.2*bary+[0 bary],'parent',traceax3,'color',[1 1 1],'Linewidth',2);
        % lab = text((t(1)-.02*dT),ylims(1)+.2*bary,[num2str(bary) ' um'],'parent',traceax3);
        % set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 1 1])
        % lab = text((t(1)+.05*dT),ylims(2)-.2*bary,'Probe position','parent',traceax3);
        % set(lab,'VerticalAlignment','top','HorizontalAlignment','left','color',[1 1 1])
        fprintf('%s\n',[num2str(bary) ' um']);

        % Time
        % barx = appropriateScaleBar(xlims);
        line([t(1) t(1)+0.2] ,ylims2(1)+0.1*diff(ylims2)*[1 1],'parent',traceax2,'color',[1 1 1],'Linewidth',2);
        % lab = text((t(1)-.02*dT),ylims(1)+.2*bary,[num2str(bary) ' um'],'parent',traceax3);
        % set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 1 1])
        % lab = text((t(1)+.05*dT),ylims(2)-.2*bary,'Probe position','parent',traceax3);
        % set(lab,'VerticalAlignment','top','HorizontalAlignment','left','color',[1 1 1])
        fprintf('%s\n',[num2str(0.2*1000) ' ms']);
        
        %% ---- put dot on probe -----
        origin = trial.forceProbeStuff.EvalPnts_y(:,1);
        prbxy = trial.forceProbeStuff.forceProbePosition(:,kk);
        prbxy = prbxy+origin;
        prbx = prbxy(1);
        prby = prbxy(2);
        
        prbdot = plot(dispax,prbxy(1),prbxy(2),'o','markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0],'visible','on');
        prbdot.XDataSource = 'prbx';
        prbdot.YDataSource = 'prby';
               
        % ---- put dot on video -----
        %epi = plot(dispax,20,20,'o','markerfacecolor',[1 1 1],'markeredgecolor',[1 1 1],'visible','off');

    else
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        set(im,'CData',mov);

        start_idx = 1;
        currt_idx = t_idx_roi(kk);
        y(start_idx:currt_idx) = v(start_idx:currt_idx);
        y(currt_idx:end) = nan;
        y(1:start_idx-1) = nan;

        y2(start_idx:currt_idx) = v2(start_idx:currt_idx);
        y2(currt_idx:end) = nan;
        y2(1:start_idx-1) = nan;

        y3(1:kk) = prb(1:kk);
        y3(kk:end) = nan;


        % ---- put dot on probe -----
        prbxy = trial.forceProbeStuff.forceProbePosition(:,kk);
        prbxy = prbxy+origin;
        prbx = prbxy(1);
        prby = prbxy(2);

        refreshdata([voltage],'caller');
        refreshdata([voltage2],'caller');
        refreshdata([prb_CoM],'caller');
        refreshdata([prbdot],'caller');

%         set(traceax,'xlim',[t_idx_roi(1) t_idx_roi(N)]);
%         set(traceax2,'xlim',[t_idx_roi(1) t_idx_roi(N)]);

    end
    kk = kk+1;
    frame = getframe(displayf); 
    writeVideo(writerObj,frame)
    
    lastt_idx = currt_idx;
end

close(writerObj)
%% Save stuff in the trial

% It will be interesting to measure leg angles several times to measure
% variability in my detection

trial.frame_roi = frame_roi;
% h.legposition = legposition;
trial = trial;
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



