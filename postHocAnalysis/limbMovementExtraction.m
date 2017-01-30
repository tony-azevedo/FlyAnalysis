function h = limbMovementExtraction(h,handles,savetag,varargin)
[protocol,dateID,flynum,cellnum,trialnum,init.fileroot] = extractRawIdentifiers(h.name);
init.figpath = [init.fileroot 'figs\']; 
if ~exist(init.figpath,'dir')
    mkdir(init.figpath)
end
init.make_movie = 0; %% save movie file
init.make_tifs = 0; %% save tif files for each frame
init.make_pdf = 1;
set(0, 'DefaultAxesFontName', 'Arial');

% make movie and pdf of each data file
filename = h.name;
moviename = [regexprep(filename, {'Acquisition','_Raw_'},{'Raw_Data','_Images_'}) '.avi'];
filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];


% import ephys data and select a window
fs = h.params.sampratein;
t = makeInTime(h.params);
f = figure;
hv = plot(t,h.voltage);
title('Select Analysis window');
roihand = imrect(get(hv,'parent'));
roi_temp = wait(roihand);
close(f);

% run some checks to see if some part of the video has been analysed.
annttdmovie = [init.figpath '\' filename(1:end-4) '_legposition.avi'];
if isfield(h,'legposition') 
    ync = questdlg('Cell has been analysed before. Overwrite?','Overwrite?','No');
    switch ync
        case 'No'
            if ~isfield(h,'legpositionlibrary')
                h.legpositionlibrary = nan(4,2,sum(h.exposure));
                h.frame_roi_library = nan(sum(h.exposure),1);
            end
            h.legpositionlibrary(:,:,h.frame_roi) = h.legposition;
            if length(dir(annttdmovie))
                movefile(annttdmovie,[annttdmovie(1:end-4) '_' num2str(min(h.frame_roi)) '-' num2str(max(h.frame_roi)) '.avi']);
            end
        case 'Yes'
        otherwise
            return
    end
end

if ~roi_temp(3)
    t_win = [t(1) t(end)];
    t_idx_win = [find(t>t_win(1),1) find(t<=t_win(end),1,'last')];
else
    t_win = [roi_temp(1) roi_temp(1)+roi_temp(3)];

    % t_ind_win are the indx for the start and end of the window
    t_idx_win = [find(t>t_win(1),1) find(t<=t_win(end),1,'last')];

    t_win = [t(t_idx_win(1)) t(t_idx_win(2))];
end

% frame_times is when the exposures happen in time
frame_times = t(h.exposure);

frame_nums = (1:length(frame_times))';
frame_roi = frame_nums(frame_times>t_win(1)& frame_times<=t_win(end));

% frame_times_roi are those in the window
frame_times_roi = frame_times(frame_roi);

% t_ind_roi are the indx for the frames
t_idx_roi = find(h.exposure);
t_idx_roi = t_idx_roi(frame_roi);


% import movie
vid = VideoReader(moviename);

% Write all frames into one struct array
mov(1:length(frame_roi)) = struct('cdata',zeros(vid.Height,vid.Width, 3,'uint8'),'colormap', gray(256),'legposition',[]);

total_frame_ind = 1;
kk = 0;
while hasFrame(vid)
    kk = kk+1;
    if kk<frame_roi(1)
        readFrame(vid);
        continue
    elseif kk>frame_roi(end)
        break
    end
    mov(total_frame_ind).cdata = readFrame(vid);
    total_frame_ind = total_frame_ind+1;
end

% open a movie

output_video = [init.figpath '\' filename(1:end-4) '_legposition.avi'];

writerObj = VideoWriter(output_video,'Motion JPEG AVI');
% writerObj.Quality = 100;
writerObj.FrameRate = vid.FrameRate;
open(writerObj);

%% Go through the frames, clicking on the femur, the tibia, the tarsus
measuref = figure;           
set(measuref,'position',[20 240 vid.Width vid.Height]);

camax = axes('parent',measuref,'units','normalized','position',[0 0 1 1]);
set(camax,'box','on','xtick',[],'ytick',[],'tag','camax');
colormap(camax,'gray')

displayf = figure;           
set(displayf,'position',[720 40 vid.Width vid.Height+200]);
dispax = axes('parent',displayf,'units','pixels','position',[0 200 vid.Width vid.Height]);
set(dispax,'box','on','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

% voltage trace vs time
x = t(t>=t_win(1)&t<=t_win(2));
v = h.voltage(t>=t_win(1)&t<=t_win(2));
y = nan(size(x));

traceax = axes('parent',displayf,'units','pixels','position',[0 0 vid.Width 200]);
set(traceax,'box','on','xtick',[],'ytick',[],'tag','traceax','ylim',[min(v) max(v)],'xlim',t_win);
hold(traceax,'on');

% angle trace vs exposure
f = frame_times_roi;
ti = nan(size(frame_times_roi));
ta = nan(size(frame_times_roi));

legposition = nan(4,2,length(mov));
for kk = 1:length(mov)
    imagesc(mov(kk).cdata,'parent',camax);    
    a = getline(camax);
    while size(a,1)~=4
        beep
        fprintf('Leg must have 4 points: femur, tib, tars ')
        a = getline(camax);
    end 
    mov(kk).legposition = a;
    legposition(:,:,kk) = a;
    
    % write the movie at the same time.
    
    if kk == 1
        im = imagesc(mov(kk).cdata,'parent',dispax);
        hold(dispax,'on');
        
        % get the ti and tarsal angles
        [~,ti(kk),ta(kk)] = legAngles(legposition(:,:,kk),'deg');
        
        lastt_idx = 1;
        currt_idx = t_idx_roi(kk)-t_idx_win(1);
        y(lastt_idx+1:currt_idx) = v(lastt_idx+1:currt_idx);
        voltage = plot(traceax,x,y,'color',[0 0 0]);
        voltage.YDataSource = 'y';
        %voltage.XDataSource = 'x';

        legx = a(:,1);
        legy = a(:,2);
        leg = plot(dispax,legx,legy,'color',[0 1 0]);
        leg.YDataSource = 'legy';
        leg.XDataSource = 'legx';

        % setup the ti and ta plots too
    else
        set(im,'CData',mov(kk).cdata);

        legx = a(:,1);
        legy = a(:,2);

        currt_idx = t_idx_roi(kk)-t_idx_win(1);
        y(lastt_idx+1:currt_idx) = v(lastt_idx+1:currt_idx);

        refreshdata([leg voltage],'caller');
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
h.legposition = legposition;
trial = h;
save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
fprintf(1,'Saving %d Frames (%d-%d of %d)\n\t for %s %s trial %s\n', ...
    length(mov),...
    frame_roi(1),...
    frame_roi(end),...
    length(frame_nums),...
    [dateID '_' flynum '_' cellnum], protocol,trialnum);


%% Plot stuff
    
% plot tarsus angle

% plot tibia angle



