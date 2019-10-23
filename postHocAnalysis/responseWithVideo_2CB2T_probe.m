% function trial = responseWithVideo_2CB2T_probe(trial,handles,savetag,varargin)
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

% For these videos, start when the light comes on, end when it goes off.
% This variable, twin, though, determines what part of the trial to show.
% Show it all with t_win = [t(1) t(end)]
t_win = [t(1) t(end)];
t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];

% import movie
vid = VideoReader(moviename);
vidCa = VideoReader(trial.imageFile2);
N = length(trial.forceProbeStuff.CoM);
NCa = max(size(trial.clustertraces_NBCls));
hIR = postHocExposure(trial,N);
hCa = postHocExposure2(trial,NCa);

ft = makeFrameTime(trial);
ft2 = makeFrameTime2CB2T(trial);

frame_times = t(hIR.exposure);
frame_nums = (1:length(frame_times))';
frame_roi = frame_nums(frame_times>=t_win(1)& frame_times<=t_win(end));

% t_ind_roi are the indx for the frames
t_idx_prb = find(hIR.exposure);
t_idx_ca = find(hCa.exposure2);
% t_idx_roi = t_idx_roi(frame_roi);

% open a movie

%% what speed?
% factor = inputdlg('How Slow?','Movie speed',1,{'1'});
% factor = str2double(factor{1});
factor = 1;
if factor>10
    error('Choose a reasonable factor')
end

%% Set the scales
% IR
mov3 = readFrame(vid);
mov = mov3(:,:,1);
scale = [quantile(mov(:),0.025) 1.5*quantile(mov(:),0.975)];

% Ca
cl_traces = trial.clustertraces_NBCls;

% find bright image
[Y,I] = max(cl_traces,[],1);
scaleCa = [1 max(Y)];
treg = ft2(I(Y==max(Y)));
vidCa.CurrentTime = treg;

%% Start motion correction

% Start motion correction here
ref_frame = mov;
ref_FFT = fft2(ref_frame);

vidCa.CurrentTime = -t(1)+.1;
mov3 = readFrame(vidCa);
mov = mov3(:,:,1);
ref_frame_ca = mov;
ref_FFT_ca = fft2(ref_frame_ca);


fps = 1/mean(diff(t(hIR.exposure)));

% if the "use camera rate" button on the flycap software is not used, and
% the user inputs the number himself, the framerate of the video will
% differ from the frame rate of the exposures
if abs(fps-vid.FrameRate)/fps > .01
    warning('Exposures and video frame rate are inconsistent, using exposures for framerate information')
    N = min([N length(t_idx_prb)]);
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

%% Make the figure layout
displayf = figure;           
set(displayf,'position',[720 40 960 512+300],'color',[0 0 0]);

dispax = axes('parent',displayf,'units','pixels','position',[0 300 640 512]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
dispaxCa = axes('parent',displayf,'units','pixels','position',[640 300+256 320 256]);
set(dispaxCa,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispaxCa,'hot')

traceax = axes('parent',displayf,'units','pixels','position',[10 100 780 90]);
traceax2 = axes('parent',displayf,'units','pixels','position',[10 0 780 90]);
traceax3 = axes('parent',displayf,'units','pixels','position',[10 200 780 90]);
hold(traceax,'on');
hold(traceax2,'on');
hold(traceax3,'on');

%% Setup the traces
% voltage trace vs time
x = t(t>=t_win(1)&t<=t_win(2));

% v = trial.(invec1)(t>=t_win(1)&t<=t_win(2));
v2 = trial.(invec2)(t>=t_win(1)&t<=t_win(2));

% y = nan(size(x));
y2 = nan(size(x));

% calcium clusters vs time
x_ft2 = ft2(ft2>=t_win(1)&ft2<=t_win(2));
vidft2 = ft2(ft2>=t_win(1)&ft2<=t_win(2))-t(1);

hw = size(trial.clustertraces_NBCls);
cl_traces = (trial.clustertraces_NBCls - repmat(trial.F0_clustertraces_NBCls(1:hw(2)),hw(1),1))./repmat(trial.F0_clustertraces_NBCls(1:hw(2)),hw(1),1);
%prb = prb(ft>=t_win(1)&ft<=t_win(2));
ycl1 = nan(size(cl_traces,1),1);
ycl2 = ycl1;
ycl3 = ycl1;
ycl4 = ycl1;
ycl5 = ycl1;

% probe trace vs time
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

dE = 40;
dT = abs(t(t_idx_prb(dE))-t(t_idx_prb(1)));

frame0 = 1;

kk = 1; %find(ft>0,1);
% vid.CurrentTime = ft(find(ft>0,1)); % start at t = 0;
vid.CurrentTime = 0;
vidCa.CurrentTime = 0;

while hasFrame(vid)
    if frame0
        frame0 = 0;
        
        %% IR frame
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        [~, Greg] = dftregistration(ref_FFT,fft2(mov),1);
        mov = real(ifft2(Greg));

        im = imshow(mov,'initialmagnification',50,'parent',dispax);
        % already set scale % scale = [quantile(mov(:),0.025) 1.5*quantile(mov(:),0.975)];
        set(dispax,'Clim',scale)

        hold(dispax,'on');
        

        %% Ca frame
        mov3 = readFrame(vidCa);
        mov = mov3(:,:,1);

        % [~, Greg] = dftregistration(ref_FFT,fft2(mov),1);
        % mov = real(ifft2(Greg));

        imCa = imshow(mov,'initialmagnification',50,'parent',dispaxCa);
        % already set scale % scale = [quantile(mov(:),0.025) 1.5*quantile(mov(:),0.975)];
        set(dispaxCa,'Clim',scaleCa)

        hold(dispax,'on');
        
        
        %%
        lastt_idx = 0; % Plot from the beginning;
        currt_idx = t_idx_prb(kk);
        ca_idx = max([1 find(ft2 <= t(currt_idx))]);
        
        % ---- plot clusters -----
        ycl1(lastt_idx+1:ca_idx) = cl_traces(lastt_idx+1:ca_idx,1);
        ycl2(lastt_idx+1:ca_idx) = cl_traces(lastt_idx+1:ca_idx,2);
        ycl3(lastt_idx+1:ca_idx) = cl_traces(lastt_idx+1:ca_idx,3);
        ycl4(lastt_idx+1:ca_idx) = cl_traces(lastt_idx+1:ca_idx,4);
        ycl5(lastt_idx+1:ca_idx) = cl_traces(lastt_idx+1:ca_idx,5);
        
        hexclrs = [
            '3C489E'
            'D64C90'
            'F9A61A'
            '00FF00'
            '47DDFF'
            'ED4545'
            '03AC72'
            '3304AC'
            ];
        clrs = hex2rgb(hexclrs);

        cl1 = plot(traceax,x_ft2,ycl1,'color',clrs(2,:));
        cl2 = plot(traceax,x_ft2,ycl2,'color',clrs(3,:));
        cl3 = plot(traceax,x_ft2,ycl3,'color',clrs(1,:));
        cl4 = plot(traceax,x_ft2,ycl4,'color',clrs(4,:));
        cl5 = plot(traceax,x_ft2,ycl5,'color',clrs(5,:));
        cl1.YDataSource = 'ycl1';
        cl2.YDataSource = 'ycl2';
        cl3.YDataSource = 'ycl3';
        cl4.YDataSource = 'ycl4';
        cl5.YDataSource = 'ycl5';
        
        xlims = [t(1) t(t_idx_prb(N))];
        dT = diff(xlims);
        xlims = xlims + [-.05*dT 0];
        ylims1 = [min(cl_traces(:)) max(cl_traces(:))+1];
        set(traceax,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims1,'xlim',xlims,'color',[0 0 0],'xcolor',[0 0 0],'ycolor',[0 0 0]);

        % ---- plot EMG -----
        y2(lastt_idx+1:currt_idx) = v2(lastt_idx+1:currt_idx);
        voltage2 = plot(traceax2,x,y2,'color',[1 1 1 ]);
        voltage2.YDataSource = 'y2';
        %voltage.XDataSource = 'x';
       
        ylims2 = [min(v2)-1 max(v2)+1];
        set(traceax2,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims2,'xlim',xlims,'color',[0 0 0],'xcolor',[0 0 0],'ycolor',[0 0 0]);

        % ---- plot Probe -----
        prb_CoM = plot(traceax3,x_ft,y3,'color',[1 0 0]);
        prb_CoM.YDataSource = 'y3';
        %voltage.XDataSource = 'x';

        ylims3 = [min(prb)-1 max(prb)+1];
        set(traceax3,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims3,'xlim',xlims,'color',[0 0 0],'xcolor',[0 0 0],'ycolor',[0 0 0]);

        % ---- put dot on probe -----
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
        line([t(1) t(1)+1] ,ylims2(1)+0.1*diff(ylims2)*[1 1],'parent',traceax2,'color',[1 1 1],'Linewidth',2);
        % lab = text((t(1)-.02*dT),ylims(1)+.2*bary,[num2str(bary) ' um'],'parent',traceax3);
        % set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 1 1])
        % lab = text((t(1)+.05*dT),ylims(2)-.2*bary,'Probe position','parent',traceax3);
        % set(lab,'VerticalAlignment','top','HorizontalAlignment','left','color',[1 1 1])
        fprintf('%s\n',['1 s']);
        
    else
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        
        % Do motion correction here
        [~, Greg] = dftregistration(ref_FFT,fft2(mov),1);
        mov = real(ifft2(Greg));

        set(im,'CData',mov);

        start_idx = 1;
        currt_idx = t_idx_prb(kk);
        ca_idx = max([1 find(ft2 <= t(currt_idx),1,'last')]);
        
        vidCa.CurrentTime = vidft2(ca_idx);
        mov3 = readFrame(vidCa);
        mov = mov3(:,:,1);

        if t(t_idx_prb(kk))>0
            [~, Greg] = dftregistration(ref_FFT_ca,fft2(mov),1);
            mov = real(ifft2(Greg));
        end
        set(imCa,'CData',mov);

        
        ycl1(start_idx:ca_idx) = cl_traces(start_idx:ca_idx,1);
        ycl2(start_idx:ca_idx) = cl_traces(start_idx:ca_idx,2);
        ycl3(start_idx:ca_idx) = cl_traces(start_idx:ca_idx,3);
        ycl4(start_idx:ca_idx) = cl_traces(start_idx:ca_idx,4);
        ycl5(start_idx:ca_idx) = cl_traces(start_idx:ca_idx,5);
        ycl1(ca_idx+1:end) = nan;
        ycl2(ca_idx+1:end) = nan;
        ycl3(ca_idx+1:end) = nan;
        ycl4(ca_idx+1:end) = nan;
        ycl5(ca_idx+1:end) = nan;

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
        
        refreshdata(cl1,'caller');
        refreshdata(cl2,'caller');
        refreshdata(cl3,'caller');
        refreshdata(cl4,'caller');
        refreshdata(cl5,'caller');
        
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



