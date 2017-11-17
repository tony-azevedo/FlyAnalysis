function h = forceProbeTracking(h,varargin)
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
k0 = find(t(h2.exposure)>mean(diff(frame_times)),1,'first');
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
    
    if isfield(h,'forceProbe_line')
        line(h.forceProbe_line(:,1),h.forceProbe_line(:,2),'parent',dispax,'color',[1 0 0]);
        button = questdlg('Make new forceProbe_line?','forceProbe_line','No');
    else 
        temp.forceProbe_line = getpref('quickshowPrefs','forceProbeLine');
        line(temp.forceProbe_line(:,1),temp.forceProbe_line(:,2),'parent',dispax,'color',[1 0 0]);
        button = questdlg('Make new forceProbe_line?','forceProbe_line','No');   
        if strcmp(button,'No');
            h.forceProbe_line = temp.forceProbe_line;
        end
    end
    if strcmp(button,'Yes');
        roihand = imline(dispax);
        roi_temp = wait(roihand);
        h.forceProbe_line = roi_temp;
        setpref('quickshowPrefs','forceProbeLine',h.forceProbe_line)
    elseif strcmp(button,'No');
    elseif strcmp(button,'Cancel');
        return
    end
    
    if isfield(h,'forceProbe_tangent')
        line(h.forceProbe_tangent(:,1),h.forceProbe_tangent(:,2),'parent',dispax,'marker','o','markeredgecolor',[0 1 0]);
        button = questdlg('Make new forceProbeTangent?','forceProbeTangent','No');
    else 
        temp.forceProbe_tangent = getpref('quickshowPrefs','forceProbeTangent');
        line(temp.forceProbe_tangent(:,1),temp.forceProbe_tangent(:,2),'parent',dispax,'marker','o','markeredgecolor',[0 1 0]);
        button = questdlg('Make new forceProbeTangent?','forceProbeTangent','No');   
        if strcmp(button,'No');
            h.forceProbe_tangent = temp.forceProbe_tangent;
        end
    end
    if strcmp(button,'Yes');
        roihand = impoint(dispax);
        roi_temp = wait(roihand);
        h.forceProbe_tangent = roi_temp;
        setpref('quickshowPrefs','forceProbeTangent',h.forceProbe_tangent)
    elseif strcmp(button,'No');
    elseif strcmp(button,'Cancel');
        return
    end
    

    
    break
end

tangent = putTangentLineOn(h,dispax);
I = improfile(mov,tangent(:,1),tangent(:,2));

vid = VideoReader(moviename);

kk = 0;
I_profile = nan(length(I),N);

br = waitbar(0,'Frames');
while hasFrame(vid)
    kk = kk+1;
    waitbar(kk/N,br);
    mov3 = readFrame(vid);
    mov = mov3(:,:,1);
    I = improfile(mov,tangent(:,1),tangent(:,2));
    I_profile(:,kk) = I;
end
close(br)

%%
setpref('quickshowPrefs','forceProbeTangent',h.forceProbe_tangent)
setpref('quickshowPrefs','forceProbeLine',h.forceProbe_line)


%% Save stuff in the trial

h.forceprobeprofiles = I_profile;
% h.legposition = legposition;
trial = h;
save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

fprintf(1,'Saving %d force probe locations for %s %s trial %s\n', ...
    size(I_profile,2),...
    [dateID '_' flynum '_' cellnum], protocol,trialnum);

close(displayf)
%% Plot stuff

figure('position',[366   303   943   612])
ax = subplot(3,3,1);
im = imshow(mov,scale,'parent',ax);
line(tangent(:,1),tangent(:,2),'parent',ax,'color',[1 .3 .3]);
title(ax,'Line scan')

ax = subplot(3,1,2);
imagesc(I_profile);
xlabel(ax,'Frames')
ylabel(ax,'I profile')

r = repmat((1:size(I_profile,1))',1,N);
CoM = nansum(r.*I_profile,1)./nansum(I_profile,1);
CoM = CoM-mean(CoM(frame_times<0));

ax = subplot(3,1,3);
plot(ax,frame_times,CoM)
axis(ax,'tight')
xlabel(ax,'s')
ylabel(ax,'CoM (pixels)')

v = CoM;
v(2:end) = diff(CoM)/diff(frame_times(1:2));
v(1) = v(2);

    
ax = subplot(3,3,3);
% plot(ax,CoM,v)
x = 1:length(CoM);
z = zeros(size(x));
col = x;  % This is the color, vary with x in this case.
surface([CoM;CoM],[v;v],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',1);
    colormap(ax,parula)
xlabel(ax,'x (pixels)')
ylabel(ax,'dx/dt')

fn = [protocol '_Raw_' dateID '_' flynum '_' cellnum, '_LineScan_' num2str(round(tangent(1,1))) '_' num2str(round(tangent(2,2)))];
savePDFandFIG(gcf,'figs',[],fn);

function l_r = putTangentLineOn(h,dispax)

l = h.forceProbe_line;
p = h.forceProbe_tangent;

% recenter
l_0 = l - repmat(mean(l,1),2,1);
p_0 = p - mean(l,1);

% find y vector
y = l_0(1,:)/norm(l_0(1,:));

% project tangent point
p_scalar = y*p_0';

% find intercept, recenter
p_ = p_scalar*y+mean(l,1);

% rotate coordinates
R = [cos(pi/2) -sin(pi/2);
     sin(pi/2) cos(pi/2)];
l_r = (R*l_0')'/4;
upperright_ind = find(l_r(:,1)>l_r(:,2));
x = l_r(upperright_ind,:)/norm(l_r(upperright_ind,:));

% % find borders along these vectors
% bounds = get(dispax,'Position');
% bounds = reshape(bounds,2,[])';
% bounds = bounds - repmat(p_,2,1);
% 
% % find bounds in terms of rotated axis
% % far x wall (x = 1280) vs top y wall (y=0)
% topy_dist = bounds(1,2)/x(2);
% rightx_dist = bounds(2,1)/x(1);
% bound1_dist = min(abs([topy_dist rightx_dist]));
% 
% % far near x wall (x = 0) vs bottom y wall (y=1024)
% bottomy_dist = bounds(2,2);
% leftx_dist = bounds(1,1)/x(1);
% bound2_dist = -min(abs([bottomy_dist leftx_dist]));
% 
% l_r = [bound1_dist; bound2_dist]*x;
l_r = l_r + repmat(p_,2,1);

% find limits projected along x
line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);

line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3]);
