%% Makes a calcium image with bar tracking, EMG, Ca intensities

% load trial of interest
fprintf('%s\n',trial.name);

cluster_idx = [1,2,5];

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,dataFile] = extractRawIdentifiers(trial.name);
if isfield(trial,'badmovie')
    fprintf('\t ** Bad movie, moving on\n');
    error('Bad movie');
end
if ~isfield(trial,'forceProbeStuff')
    fprintf('\t ** No Probe\n');
    error('No Probe');
end
figpath = [D 'CaImVids'];
if ~exist(figpath,'dir')
    mkdir(figpath)
end

smooshedImagePath = regexprep(trial.name,{'_Raw_','.mat'},{'_smooshed_', '.mat'});
iostr = load(smooshedImagePath);
scale = [quantile(iostr.smooshedframe(:),0.05) 1*quantile(iostr.smooshedframe(:),0.999)];
%scale = [];

filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];

switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end
t = makeInTime(trial.params);

t_win = [0 4];
t_idx_win = t>=t_win(1) & t<=t_win(end);
t_i_idx = find(t_idx_win,1,'first');

% import movie
vid = VideoReader(trial.imageFile);
N = vid.Duration*vid.FrameRate;
h2 = postHocExposure(trial,N);

frame_times = t(h2.exposure);

frame_nums = (1:length(frame_times))';
frame_roi = frame_nums(frame_times>=t_win(1)& frame_times<=t_win(end));
%frame_times = frame_times(frame_times>=t_win(1)& frame_times<=t_win(end));
frame_times_roi = frame_times(frame_roi);

% t_ind_roi are the indx for the frames
t_idx_roi = find(h2.exposure);
t_idx_roi = t_idx_roi(frame_roi)-t_i_idx;

% open a movie

% what speed?
%     factor = inputdlg('How Slow?','Movie speed',1,{'1'});
%     factor = str2double(factor{1});
%     if factor>10
%         error('Choose a reasonable factor')
%     end
factor = 1;

fps = 1/mean(diff(t(h2.exposure)))/factor;
output_video = [figpath '\' filename(1:end-4) '_FClusters_EMG_Bar.avi'];

writerObj = VideoWriter(output_video,'Motion JPEG AVI');
writerObj.Quality = 100;
writerObj.FrameRate = fps;
open(writerObj);

displayf = figure;
set(displayf,'position',[100 10 960 768+240],'color',[0 0 0]);
dispax = axes('parent',displayf,'units','pixels','position',[0 240 960 768]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

% voltage trace vs time
x = t(t_idx_win);
% % going to plot this trace over the video in blue
% x = x-x(1); x = x/x(end)*640;

% only look at EMG for now
% v = h.(invec1)(t>=t_win(1)&t<=t_win(2));
v = trial.(invec2)(t_idx_win);

if size(trial.clustertraces,1)<size(trial.clustertraces,2)
    trial.clustertraces = trial.clustertraces';
end
v2 = trial.clustertraces(frame_roi,:);
v2 = v2./repmat(mean(v2(2:6),1),length(frame_roi),1);
N_cl = size(trial.clustertraces,2);
y = nan(size(x));
y2 = nan(size(v2));

if strcmp('EpiFlash2T',protocol)
    epistim = EpiFlashStim(trial.params);
    epistim = epistim(t_idx_roi+t_i_idx);
else
    epistim = x*0;
end
traceax = axes('parent',displayf,'units','pixels','position',[0 140 960 100]);
traceax2 = axes('parent',displayf,'units','pixels','position',[0 40 960 100]);
% LabelAx = axes('parent',displayf,'units','pixels','position',[0 0 960 40]);
hold(traceax,'on');
hold(traceax2,'on');

% how far off the labels are from the start of the trial
dE = 40;
dT = abs(t(t_idx_roi(dE))-t(t_idx_roi(1)));

kk = 0;
tt = 0;
frame0 = 1;
notscaled = 1;

while hasFrame(vid)
    kk = kk+1;
    % readFrame(vid);
    if kk<frame_roi(1)
        readFrame(vid);
        continue
    elseif kk>frame_roi(end)
        break
    end
    tt = tt+1;
    if frame0
        frame0 = 0;
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        
        im = imshow(mov,scale,'parent',dispax);
        hold(dispax,'on');
        %clrs = parula(N_cl);
        clrs = get(dispax,'colorOrder');
        for cl_idx = 1:size(trial.clustertraces,2) % cluster_idx
            clmask = trial.clmask==cl_idx;
            ii = find(sum(clmask,1),1,'first');
            jj = find(clmask(:,ii),1,'first');
            % alphamask(clmask,clrs(cl_idx,:),.1,dispax);
            % clmask = bwperim(clmask,8);
            clmask = bwtraceboundary(clmask,[jj,ii],'E',8);
            h = line(clmask(:,2),clmask(:,1),'parent',dispax,'color',clrs(cl_idx,:));
            %line(h.ROI{cl_idx}(:,1),h.ROI{cl_idx}(:,2),'parent',dispax,'color',clrs(cl_idx,:));
        end
        
        lastt_idx = 0;
        currt_idx = t_idx_roi(tt);
        y(lastt_idx+1:currt_idx) = v(lastt_idx+1:currt_idx);
        y2(1:tt,:) = v2(1:tt,:);
        
        voltage = plot(traceax,x,y,'color',[1 0 0]);
        voltage.YDataSource = 'y';
        %voltage.XDataSource = 'x';
        
        xlims = t_win;
        dT = diff(xlims);
        xlims = xlims + [-.05*dT 0];
        ylims = [min(v)-1 max(v)+1];
        set(traceax,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',ylims,'xlim',xlims,'color',[0 0 0]);
        
        % make scale bars
        bary = appropriateScaleBar(ylims);
        line((t(t_i_idx)-.02*dT)*[1 1] ,ylims(1)+[0 bary],'parent',traceax,'color',[1 0 0]);
        lab = text((t(t_i_idx)-.02*dT),ylims(1),[num2str(bary) ' pA'],'parent',traceax);
        set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 0 0])
        
        for cl_idx = 1:size(trial.clustertraces,2)
            ycol = ['ycol' num2str(cl_idx)];
            eval([ycol ' = y2(:,cl_idx);']);
            clusterIntensity(cl_idx) = plot(traceax2,frame_times_roi,y2(:,cl_idx),'color',clrs(cl_idx,:));
            hold(traceax2,'on');
            
            clusterIntensity(cl_idx).YDataSource = ycol;
        end
        %voltage.XDataSource = 'x';
        
        set(traceax2,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',[.9 max(v2(:))],'xlim',xlims,'color',[0 0 0]);
        
        hold(dispax,'on')
        %epi = plot(dispax,20,20,'o','markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1],'visible','off');
        
        barposition_x = trial.forceProbeStuff.forceProbePosition(1,kk)+ trial.forceProbeStuff.Origin(1);
        barposition_y = trial.forceProbeStuff.forceProbePosition(2,kk)+ trial.forceProbeStuff.Origin(2);
        barspot = plot(dispax,barposition_x,barposition_y,'o','markerfacecolor',[.5 1 .5],'markeredgecolor',[1 0 1]);
        barspot.XDataSource = 'barposition_x';
        barspot.YDataSource = 'barposition_y';
        
        % make scale bars
        F_min = min(min(v2(3:end-3,:)))*.92;
        bary = appropriateScaleBar([F_min max(v2(:))]);
        line((t(t_i_idx)-.02*dT)*[1 1] ,F_min+[0 bary],'parent',traceax2,'color',[1 0 0]);
        lab = text((t(t_i_idx)-.02*dT),F_min,[num2str(bary) ' F/F'],'parent',traceax2);
        set(lab,'Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','left','color',[1 0 0])
        
%         set(LabelAx,'box','off','xtick',[],'ytick',[],'tag','traceax','ylim',[0 1],'xlim',[0 1],'color',[0 0 0]);
%         fn = text(.05, .9,...
%             regexprep([filename(1:end-4) '_FClusters_' num2str(factor) 'X.avi'],'_','\\_'),...
%             'parent',LabelAx,'fontsize',24,'fontname','Arial','color',[1 1 1],'VerticalAlignment','top');
    else
        mov3 = readFrame(vid);
        mov = mov3(:,:,1);
        
        set(im,'CData',mov);
        
        %         if kk<=dE
        start_idx = 1;
        %         else
        %             start_idx = t_idx_roi(kk-dE);
        %         end
        currt_idx = t_idx_roi(tt);
        y(start_idx:currt_idx) = v(start_idx:currt_idx);
        y(currt_idx+1:end) = nan;
        %y(1:start_idx-1) = nan;
        
        y2(start_idx:tt,:) = v2(start_idx:tt,:);
        y2(currt_idx:end,:) = nan;
        y2(1:start_idx-1) = nan;
        
        barposition_x = trial.forceProbeStuff.forceProbePosition(1,kk)+ trial.forceProbeStuff.Origin(1);
        barposition_y = trial.forceProbeStuff.forceProbePosition(2,kk)+ trial.forceProbeStuff.Origin(2);
        
        refreshdata([voltage,barspot],'caller');
        
        for cl_idx = cluster_idx
            ycol = ['ycol' num2str(cl_idx)];
            eval([ycol ' = y2(:,cl_idx);']);
        end
        refreshdata(clusterIntensity,'caller');
        
        %         if epistim(currt_idx)>.2
        %             set(epi,'visible','on');
        %         else
        %             set(epi,'visible','off');
        %         end
        
        %         set(traceax,'xlim',[t_idx_roi(1) t_idx_roi(N)]);
        %         set(traceax2,'xlim',[t_idx_roi(1) t_idx_roi(N)]);
        
    end
    frame = getframe(displayf);
    writeVideo(writerObj,frame)
    
    lastt_idx = currt_idx;
end

close(writerObj)

fprintf(1,'Saving %d Frames (%d-%d of %d)\n\t for %s %s trial %s\n', ...
    length(frame_roi),...
    frame_roi(1),...
    frame_roi(end),...
    length(frame_nums),...
    [dateID '_' flynum '_' cellnum], protocol,trialnum);

close(displayf)



