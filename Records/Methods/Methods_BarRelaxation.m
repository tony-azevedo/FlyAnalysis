close all

cd E:\Data\171019\Run3
%% samprate = 1200.48019 Hz
fs = 1200.48019;
fs = 1.20048019;

%% Background
moviename = 'Basler acA800-510um (22190106)_20171020_094336964.avi';
vid = VideoReader(moviename);

mov3 = vid.readFrame;
frame = squeeze(mov3(:,:,1));

N = round(vid.Duration*vid.FrameRate)-1;
bgprof = mean(frame,1);
bgprof = repmat(bgprof,N,1);

for i=2:N
    mov3 = vid.readFrame;
    frame = squeeze(mov3(:,:,1));
    bgprof(i+1,:) = mean(frame,1);
end

bgprof_ = mean(bgprof,1);
figure
plot(bgprof_)

%% measure the pixel distance of the micropipette
close all
% left origin
left = imread('Basler acA800-510um (22190106)_20171020_095821586_0001.tiff');
im = imshow(left,[])
pixeldistax = im.Parent;
pleft = impoint(pixeldistax);
x1 = pleft.getPosition; % 215.3571  289.8061

% right 603 um
right = imread('Basler acA800-510um (22190106)_20171020_095929209_0001.tiff');
im = imshow(right,[])
pixeldistax = im.Parent;
pright = impoint(pixeldistax);
x2 = pright.getPosition; % 800.5000  278.0510

% L_v = 898.2;
L_h = 600;

% perpixel_y = L_v/sqrt((y2(2)-y1(2))^2+(y2(1)-y1(1))^2) % HAHA! resolution is 1 um per pixel! 1.0083
perpixel_x = L_h/sqrt((x2(2)-x1(2))^2+(x2(1)-x1(1))^2) % HAHA! resolution is 1 um per pixel! 1.04 
perpixel_x = L_h/sqrt((x2(2)-x1(2))^2+(x2(1)-x1(1))^2) % HAHA! resolution is 1 um per pixel! 1.0024
% AND!! the electrode is essentially perpendicular! since the non movement
% direction is close to 0;


%%
close all
displayf = findobj('type','figure','tag','big_fig');
if isempty(displayf)
    displayf = figure;
    set(displayf,'position',[40 300 800 230],'tag','big_fig');
end
dispax = findobj(displayf,'type','axes','tag','dispax');
if isempty(dispax) 
    dispax = axes('parent',displayf,'units','pixels','position',[0 0 800 200],'tag','dispax');
    set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
    colormap(dispax,'gray')
end

profileFigure = findobj('type','figure','tag','profile_fig');
if isempty(profileFigure)
    profileFigure = figure;
    set(profileFigure,'position',[1332 549 560 420],'tag','profile_fig');
end
profileAxes = subplot(1,1,1); cla(profileAxes); hold(profileAxes,'off');


trajctFigure = findobj('type','figure','tag','position_fig');
if isempty(trajctFigure)
    trajctFigure = figure;
    set(trajctFigure,'position',[1332 38 560 420],'tag','position_fig');
end
trajectAxes = subplot(1,1,1,'parent',trajctFigure); cla(trajectAxes); hold(trajectAxes,'off');


%%
movienames = {
    'Basler acA800-510um (22190106)_20171020_094416346.avi'
    'Basler acA800-510um (22190106)_20171020_094442179.avi'
    'Basler acA800-510um (22190106)_20171020_094504339.avi'
    'Basler acA800-510um (22190106)_20171020_094523850.avi'
    'Basler acA800-510um (22190106)_20171020_094542948.avi'
    'Basler acA800-510um (22190106)_20171020_094558267.avi'
    'Basler acA800-510um (22190106)_20171020_094615683.avi'
    'Basler acA800-510um (22190106)_20171020_094635515.avi'
    'Basler acA800-510um (22190106)_20171020_094653835.avi'
    'Basler acA800-510um (22190106)_20171020_094725435.avi'
    'Basler acA800-510um (22190106)_20171020_094752139.avi'
    'Basler acA800-510um (22190106)_20171020_094815659.avi'
    'Basler acA800-510um (22190106)_20171020_094839827.avi'
    'Basler acA800-510um (22190106)_20171020_094900723.avi'
    'Basler acA800-510um (22190106)_20171020_094918483.avi'
    'Basler acA800-510um (22190106)_20171020_094937852.avi'
    'Basler acA800-510um (22190106)_20171020_095002499.avi'
    'Basler acA800-510um (22190106)_20171020_095027507.avi'
    'Basler acA800-510um (22190106)_20171020_095056979.avi'
    'Basler acA800-510um (22190106)_20171020_095142939.avi'
    'Basler acA800-510um (22190106)_20171020_095210107.avi'
    'Basler acA800-510um (22190106)_20171020_095230627.avi'
    'Basler acA800-510um (22190106)_20171020_095256707.avi'
    'Basler acA800-510um (22190106)_20171020_095321971.avi'
    'Basler acA800-510um (22190106)_20171020_095348027.avi'
    'Basler acA800-510um (22190106)_20171020_095406011.avi'
    'Basler acA800-510um (22190106)_20171020_095427987.avi'
    'Basler acA800-510um (22190106)_20171020_095452939.avi'
    'Basler acA800-510um (22190106)_20171020_095513731.avi'
    'Basler acA800-510um (22190106)_20171020_095532459.avi'
    'Basler acA800-510um (22190106)_20171020_095553219.avi'
    'Basler acA800-510um (22190106)_20171020_095613539.avi'
    'Basler acA800-510um (22190106)_20171020_095643395.avi'
    }

include = true(size(movienames));

positions = {};

for mns = 1:length(movienames)
    moviename = movienames{mns};
    % import movie
    vid = VideoReader(moviename);
    
    mov3 = vid.readFrame;
    frame = squeeze(mov3(:,:,1));
    
    N = 50;
    prof = mean(frame,1);
    prof = repmat(prof,N,1);
    
    for i=2:50
        mov3 = vid.readFrame;
        frame = squeeze(mov3(:,:,1));
        prof(i+1,:) = mean(frame,1);
    end
    
    barprof = mean(prof,1)-bgprof_;
    
    hold(profileAxes,'off');
    plot(profileAxes,mean(prof,1)); hold(profileAxes,'on');
    plot(profileAxes,bgprof_);
    plot(profileAxes,barprof);
    
    [l_r_edges,l_r_int] = peakfinder(barprof,[],2,1,false);
    
    l_ = find(barprof(1:l_r_edges(1))<1/3*l_r_int(2),1,'last');
    r_ = find(barprof(l_r_edges(2):end)<1/3*l_r_int(2),1,'first')+l_r_edges(2);
    barskeleton = barprof(l_:r_);
    barskel = barprof;
    barskel(:) = 0;
    barskel(1:length(barskeleton)) = barskeleton;
    plot(profileAxes,l_-1+(1:length(barskeleton)),barskeleton);
    plot(profileAxes,barskel);
    
    figure(profileFigure)
    
    
    %
    vid = VideoReader(moviename);
    
    N = round(vid.Duration*vid.FrameRate)-1;
    position = zeros(1,N);
    
    for i = 1:length(position)
        mov3 = vid.readFrame;
        frame = squeeze(mov3(:,:,1));
        prof = mean(frame,1)-bgprof_;
        [match,lags] = xcorr(prof,barskel,'coeff');
        position(i) = lags(match==max(match));
    end
    
    figure(trajctFigure)
    hold(trajectAxes,'off');
    plot(trajectAxes,(1:N),position)
    
    v = diff(position);
    [fast,snap] = min(v);
    hold(trajectAxes,'on');
    plot(trajectAxes,(1:N-1),(v-fast)/(max(v)-fast)*-diff([position(1) position(end)])+position(end))
    plot(trajectAxes,[snap snap],[min(position) max(position)],'color',[1 1 1]*.8)
    
    snaps(mns) = snap;

    %
    xlim(trajectAxes,snap-5+[1,27])

    %
    vid = VideoReader(moviename);
    
    N = round(vid.Duration*vid.FrameRate)-1;
    
    for i = 1:snap-5
        vid.readFrame;
    end
    
    hold(trajectAxes,'on')
    frnm = plot(trajectAxes,snap,position(snap),'ro');
    
    for i = 1:20
        mov3 = vid.readFrame;
        frame = squeeze(mov3(:,:,1));
        
        im = imshow(frame,[0 2*quantile(frame(:),0.975)],'parent',dispax);
        
        prof = mean(frame,1)-bgprof_;
        [match,lags] = xcorr(prof,barskel,'coeff');
        
        position_ = lags(match==max(match));
        
        hold(profileAxes,'off');
        plot(profileAxes,1:800,prof); hold(profileAxes,'on');
        plot(profileAxes,position_+(1:length(barskeleton)),barskeleton);
        
        frnm.XData = snap-5+i;
        frnm.YData = position(snap-5+i);
        
        drawnow
        figure(displayf)
        figure(profileFigure)
        figure(trajctFigure)
        pause
        
    end
    
    delete(frnm)
    drawnow

    
    button = questdlg('Include this video?','Include?','Yes');
    switch button
        case 'Yes'
            positions{mns} = position;
        case 'No'
            include(mns) = false;
        case 'Cancel'
            break
    end
end

%% 
% good.movienames = movienames(include);
% good.positions = positions(include);
% 
% save('processed','good')


%%
good = load('processed.mat'); good = good.good;

N = length(good.positions{1});

close all
trajctFigure = findobj('type','figure','tag','position_fig');
if isempty(trajctFigure)
    trajctFigure = figure;
    set(trajctFigure,'position',[1332 38 560 420],'tag','position_fig');
end
trajectAxes = subplot(1,1,1,'parent',trajctFigure); cla(trajectAxes); hold(trajectAxes,'off');

phasef = findobj('type','figure','tag','phase_fig');
if isempty(phasef)
    phasef = figure;
    set(phasef,'position',[1332 38 560 420],'tag','phase_fig');
end
phaseAxes = subplot(1,1,1,'parent',phasef); cla(phaseAxes); hold(phaseAxes,'off');


trajects = zeros
for mns = 1:length(good.positions)
    position = good.positions{mns};

    v = diff(position);
    [fast,snap] = min(v);
    snaps(mns) = snap;
    position = position-round(mean(position(snap+(25:35))));

    plot(trajectAxes,(1:N)-snap,position,'color',[0    0.4470    0.7410],'tag',num2str(mns))
    
    hold(trajectAxes,'on');
    plot(trajectAxes,(1:N-1)-snap,v,'color',[0.8500    0.3250    0.0980])
    plot(trajectAxes,[snap snap],[min(position) max(position)],'color',[1 1 1]*.8)
    
    %
    xlim(trajectAxes,[-4,25])

    plot(phaseAxes,position(snap-1:snap+25),v(snap-1:snap+25)); hold(phaseAxes,'on');
end


%% Try aligning the trajectories in time a little better
DT = 30;
dt = 1/fs;
tr = zeros(length(good.positions),DT);
tr_dot = zeros(length(good.positions),DT-1);
for t = 1:size(tr,1)
    tr(t,:) = good.positions{t}(snaps(t):snaps(t)+DT-1);
    tr(t,:) = tr(t,:)-mean(tr(t,end-4:end));
    v = diff(tr(t,:))/dt;
    tr_dot(t,:) = v;
end

td = (1:DT-1)/fs;

figure
for t = 1:size(tr,1)
    v_ = tr_dot(t,:);
    tr_ = tr(t,1:length(v_));
    
    psolve = fminsearch(@(p) lsodeobjective([td(1) td(end)],[tr_;v_],p,[tr_(1),v_(1)]), [1 4]);
    
    soln(t,:) = psolve(:);

    clf
    subplot(2,1,1)
    plot(tr_,v_)
    hold on
    f = @(ts,y) lsode(ts,y, soln(t,1), soln(t,2));
    [t_,y] = ode45(f, [td(1) td(end)], [tr_(1),v_(1)]);
    plot(y(:,1),y(:,2))

    subplot(2,2,3)
    %x
    plot(td,tr_,'o','markeredgecolor',[0    0.4470    0.7410])
    hold on
    plot(t_,y(:,1),'color',[0    0.4470    0.7410])
    
    %vel
    subplot(2,2,4)
    plot(td,v_,'o','markeredgecolor',[0.8500    0.3250    0.0980])
    hold on
    plot(t_,y(:,2),'color',[0.8500    0.3250    0.0980])
    
    drawnow
end

%%
figure
plot(td,tr(:,1:length(v_))','o','markeredgecolor',[0    0.4470    0.7410])
hold on
plot(td,tr_dot','o','markeredgecolor',[0.8500    0.3250    0.0980])

f = @(ts,y) lsode(ts,y, mean(soln(:,1)), mean(soln(:,2)));
[t_,y] = ode45(f, linspace(td(1),td(end),1500), [tr_(1),v_(1)]);

l(1) = plot(t_,y(:,1),'color',[0    0.4470    0.7410]);
l(2) = plot(t_,y(:,2),'color',[0.8500    0.3250    0.0980]);

legend(l,{'position','velocity'})

text(15,100,sprintf('y'''' + %.2fy'' +%.2fy = 0',mean(soln(:,1)),mean(soln(:,2))))

%% Now find where y' = 0
A = mean(soln(:,1)); % [s^-1] or 1E3 [ms^-1]
B = mean(soln(:,2)); % [ms^-2] or [(1E-3 s)^-2] = 1E6 [s^-2]

y_d_cross0 = find(y(:,2)>=0,1,'first');
y_dd = - (A*y(y_d_cross0,2) + B*y(y_d_cross0,1)); %um/s/s

% y_dd = -B y; m*y_dd = -k y; k/m = B; k = 0.2234 %
% Methods_ForceProbeCalibration % https://en.wikipedia.org/wiki/Harmonic_oscillator
k = 0.2234; % N/m
m = 0.2234/mean(soln(:,2)); %[mg/s/s]/[1/ms/ms] = [mg]; 0.1702 mg

w_0 = sqrt(B);
eta = A/w_0/2; % A = 2*eta*w_0;
w_1 = w_0*sqrt(1-eta^2);
f = w_1/2/pi;
T = 1/f; % 5.8 ms

c = eta*2*sqrt(m*k); % 0.1377 [kg]/[s]

tau = 1/(w_0*eta); % 2.5 ms

idx = find(y(:,2)==max(y(:,2)));
plot([t_(idx) t_(idx)+T],[100 100],'color',[1 1 1]*.7,'linewidth',2)

%% Now put into natural units
A = mean(soln(:,1)); % [s^-1] or 1E3 [ms^-1]
B = mean(soln(:,2)); % [ms^-2] or [(1E-3 s)^-2] = 1E6 [s^-2]

A_ = A*1E3;
B_ = B*1E6;

fs_ = 1200.48019;
td_ = (1:DT-1)/fs_;

tr_dot_ = tr_dot*1E3;
tr_ = mean(tr(:,1:length(v_)),1);
v_ = mean(tr_dot_(:,1:length(v_)),1);

figure
subplot(2,1,1)
plot(td_,tr(:,1:length(v_))','o','markeredgecolor',[0    0.4470    0.7410])
hold on
ylabel('\mum')
subplot(2,1,2)
plot(td_,tr_dot_','o','markeredgecolor',[0.8500    0.3250    0.0980])
hold on
ylabel('\mum/s')
xlabel('s')

f = @(ts,y) lsode(ts,y, A_, B_);
[t_,y] = ode45(f, linspace(td_(1),td_(end),1500), [tr_(1),v_(1)]);

l(1) = plot(subplot(2,1,1),t_,y(:,1),'color',[0    0.4470    0.7410]);
l(2) = plot(subplot(2,1,2),t_,y(:,2),'color',[0.8500    0.3250    0.0980]);

% legend(l,'position','velocity')

text(subplot(2,1,2),0.012,-1E5,sprintf('y'''' + %.2fy'' +%.2fy = 0',A_,B_))

%%
A = mean(soln(:,1)); % [s^-1] or 1E3 [ms^-1]
B = mean(soln(:,2)); % [ms^-2] or [(1E-3 s)^-2] = 1E6 [s^-2]


A_ = A*1E3;
B_ = B*1E6;
    % [1m/1E6um]*[1/1E-3s]
    % [1m/1E6um]*[1/1E-3s]*[1/1E-3s]

fs_ = 1200.48019;
td_ = (1:DT-1)/fs_;

tr_ = tr*1E-6;                          % um*[1m/1E6um]
x_ = mean(tr_(:,1:length(v_)),1);  
tr_dot_ = tr_dot*1E-3;                  % um/ms * [1m/1E6um]*[1E3ms/s]
v_ = mean(tr_dot_(:,1:length(v_)),1);

figure
subplot(2,1,1)
plot(td_,tr_(:,1:length(v_))','o','markeredgecolor',[0    0.4470    0.7410])
hold on
ylabel('m')
subplot(2,1,2)
plot(td_,tr_dot_','o','markeredgecolor',[0.8500    0.3250    0.0980])
hold on
ylabel('m/s')

f = @(ts,y) lsode(ts,y, A_, B_);
[t_,y] = ode45(f, linspace(td_(1),td_(end),1500), [x_(1),v_(1)]);

l(1) = plot(subplot(2,1,1),t_,y(:,1),'color',[0    0.4470    0.7410]);
l(2) = plot(subplot(2,1,2),t_,y(:,2),'color',[0.8500    0.3250    0.0980]);

% legend(l,'position','velocity')

text(subplot(2,1,2),0.012,-1E-1,sprintf('y'''' + %.2fy'' +%.2fy = 0',A_,B_))

y_d_cross0 = find(y(:,2)>=0,1,'first');
y_dd = - (A*y(y_d_cross0,2) + B*y(y_d_cross0,1)); %um/s/s

% y_dd = -B y; m*y_dd = -k y; k/m = B; k = 0.2234 % forceProbeCalibration
k = 0.2234; % N/m or 
m = 0.2234/B_; %[mg/s/s]/[1/ms/ms] = [mg]; 0.1702 mg or 1.7E-7 kg

w_0 = sqrt(B_);         % 1.15 *1E3 s^-1 
eta = A_/w_0/2;         % A = 2*eta*w_0;
w_1 = w_0*sqrt(1-eta^2);% 1.07 *1E3 s^-1 
f = w_1/2/pi;
T = 1/f;                % 5.9 ms

c = eta*2*sqrt(m*k); % 0.1377E-3 [kg]/[s]

tau = 1/(w_0*eta); % 2.5 ms

% idx = find(y(:,2)==max(y(:,2)));
% plot([t_(idx) t_(idx)+T],[100 100],'color',[1 1 1]*.7,'linewidth',2)
