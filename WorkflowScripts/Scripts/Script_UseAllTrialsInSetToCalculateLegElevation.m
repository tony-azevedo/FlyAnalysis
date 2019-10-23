%% Script_UseAllTrialsInSetToCalculateLegElevation

%% Not Many points
DP = 1;
if DP
    f = figure;
    ax = subplot(1,1,1); ax.NextPlot = 'add';
end
trial = load(sprintf(trialStem,trialnumlist(1)));

Nr = size(trial.legPositions.Tibia_Projection,1);

Nrr = round(Nr*.1);
ellipsepoints = nan((Nr+Nrr)*length(trialnumlist),2);

origins = nan(length(trialnumlist),2);

cnt = 0;
for tr_idx = trialnumlist
    cnt = cnt+1;
    trial = load(sprintf(trialStem,tr_idx),'legPositions');
    
    lp = trial.legPositions;
    N = size(lp.Tibia_Projection,1);
    TP = lp.Tibia_Projection(:,1:2);
    %TP = TP - repmat(lp.Origin(1:2),N,1);
    
    origins(cnt,:) = lp.Origin(1:2);
    
    ellipsepoints((cnt-1)*(Nr)+(1:Nr),:) = TP;
end
origin = median(origins,1);
ellipsepoints = ellipsepoints-repmat(origin,size(ellipsepoints,1),1);

Nr = size(trial.legPositions.Tibia_Projection,1)*length(trialnumlist);
Nrr =  round(size(trial.legPositions.Tibia_Projection,1)*.1)*length(trialnumlist);

fidx = randperm(Nr,Nrr);

ellipsepoints(Nr+1:end,:) = -ellipsepoints(fidx,:);

% do a funny thing here where you artificially take few points and
% project them to the other side of the origin, ~10%

ellipsepoints = ellipsepoints(any(~isnan(ellipsepoints),2),:);
if DP
    plot(ax,ellipsepoints(:,1),ellipsepoints(:,2),'r.') 
    plot(ax,origins(:,1),origins(:,2),'co')
    plot(ax,origin(:,1),origin(:,2),'m+');
end


% %% Too Many points
% DP = 1;
% if DP
%     f = figure;
%     ax = subplot(1,1,1);
% end
% trial = load(sprintf(trialStem,trialnumlist(1)));
% 
% Nr = 100;
% Nrr = round(Nr*.1);
% ellipsepoints = nan(Nr+Nrr*length(trialnumlist),2);
% 
% ridx = randperm(Nr,Nr);
% cnt = 0;
% for tr_idx = trialnumlist
%     cnt = cnt+1;
%     trial = load(sprintf(trialStem,tr_idx));
%     
%     lp = trial.legPositions;
%     N = size(lp.Tibia_Projection,1);
%     TP = lp.Tibia_Projection(:,1:2);
%     TP = TP - repmat(lp.Origin(1:2),N,1);
%     TP_norm = sqrt(sum(TP.*TP,2));
%     
%     Tibia_Angle = acosd((TP * lp.Femur(1:2)')./TP_norm);
%     eta = var(Tibia_Angle);
%     
%     ridx = randperm(N,Nr);
%     while var(Tibia_Angle(ridx)) <= .8*eta
%         ridx = randperm(N,Nr);
%     end
%     eps = TP(ridx,:);
%     % do a funny thing here where you artificially take few points and
%     % project them to the other side of the origin, ~3%
%     fidx = randperm(Nr,Nrr);
%     epsf = [eps;-eps(fidx,:)];
%     ellipsepoints((cnt-1)*(Nr+Nrr)+(1:Nr+Nrr),:) = epsf;
% end
% if DP
%     plot(ax,ellipsepoints(:,1),ellipsepoints(:,2),'r.')
%     hold on
% end


%%
fprintf('\n: Fitting ellipse \t'),tic

if size(ellipsepoints,1)>1000
    a = zeros(6,1);
    b = a;
    alpha = a;
    z = [a,a];
    for i = 1:6
        fidx = randperm(size(ellipsepoints,1),1000);
        [z(i,:), a(i), b(i), alpha(i)] = fitellipse(ellipsepoints(fidx,:));
        %              z(i,:) = z_i; a(i) = a_i; b(i) = b_i;
        if DP
            plotellipse(z(i,:), a(i), b(i), alpha(i));
            drawnow;
        end
    end
    origin_est = mean(z,1)+origin;
    [axL,o] = sort([a;b]);
    minor = mean(axL(1:6));
    major = mean(axL(7:12));
    R = major;
    o = o(o<7);
    
    if abs(minor-a(1)) < abs(minor-b(1))
        alphag = (alpha(o(6))); % choose alpha that goes with one of the larger a's
        rot = mean(alpha(abs(alpha-alphag)<.2));
    else
        alphag = (alpha(o(1))); % choose alpha that goes with one of the smaller a's
        rot = mean(alpha(abs(alpha-alphag)>.5));
    end
    
else
    
    [z, a, b, alpha] = fitellipse(ellipsepoints);
    if DP
        plotellipse(z, a, b, alpha);
        drawnow;
    end
    origin_est = z(:)'+lp.Origin;
    minor = a;
    major = b;
    R = major;
    rot = alpha;
end



%% load trial and save ellipse, calculate angle

% allocate
tibia_vects = lp.Tibia_Projection(:,1:2);
tibia_vects_3D = [tibia_vects,tibia_vects(:,1)];

origin_3D = [origin_est,0];

f = figure;
f.Position = [680    32   560   480];
f.Color = [1    1 1];
ax5 = subplot(1,1,1,'parent',f); ax5.Position = [0.02 0.1 0.96 0.8];
if ~exist(fullfile(D,'trackedPositions'),'dir')
    mkdir(fullfile(D,'trackedPositions'))
end
for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));
    
    lp = trial.legPositions;
    N = size(lp.Tibia_Projection,1);
    
    tibia_vects_3D(:,1:2) = lp.Tibia_Projection(:,1:2)-repmat(origin_est,N,1);
    
    tibia_vects_3D(:,3) = sqrt(abs(repmat(R^2,N,1) - sum(tibia_vects_3D(:,1:2).^2,2)));
    proj = (tibia_vects_3D*lp.Femur')./R; % projection of tibia onto femur
    if any(proj>1)
        proj = proj-abs(max(proj)-1);
        if abs(max(proj)-1)>.1
            error('Something is wrong with the projection')
        end
    end
    
    lp.Origin_3D = origin_3D;
    lp.Tibia_Position = tibia_vects_3D;
    lp.Tibia_Angle =  real(acosd(proj));
    lp.Projection_Major = major;
    lp.Projection_Minor = minor;
    lp.Projection_Rotation = rot;
    trial.legPositions = lp;
    
    fprintf('%d: save trial \n',trial.params.trial)
    save(trial.name,'-struct','trial');
    
    cla(ax5)
    vid = VideoReader(trial.imageFile);
    vid.CurrentTime = 1;
    frame = rgb2gray(vid.readFrame);
    im = imshow(frame,[0 128],'InitialMagnification',75,'parent',ax5);
    hold(ax5,'on');
    
    plotellipse(ax5,origin_3D(1:2), major,minor, rot);
    plot3(ax5,origin_3D(1)+tibia_vects_3D(:,1),origin_3D(2)+tibia_vects_3D(:,2),origin_3D(3)+tibia_vects_3D(:,3),'c.');
    plot3(ax5,origin_3D(1)+300*[0,lp.Femur(1)], origin_3D(2)+300*[0,lp.Femur(2)],origin_3D(3)+300*[0,lp.Femur(3)],'r');
    ax5.CameraPosition = [-0.5057    7.9678    4.3156]*1E3;
    ax5.ZGrid = 'on';
    
    %     ax6 = subplot(2,1,2,'parent',f);
    %     el = plotellipse(ax6,origin_3D(1:2), major, minor, rot);
    %     el.ZData = 0*el.YData;
    %     hold(ax6,'on')
    %     plot3(ax6,origin_3D(1)+tibia_vects_3D(:,1),origin_3D(2)+tibia_vects_3D(:,2),origin_3D(3)+tibia_vects_3D(:,3),'m.');
    %     plot3(ax6,origin_3D(1)+300*[0,lp.Femur(1)], origin_3D(2)+300*[0,lp.Femur(2)],origin_3D(3)+300*[0,lp.Femur(3)],'r');
    %
    %     ax6.XGrid = 'on';
    %     ax6.YGrid = 'on';
    %     ax6.YDir = 'reverse';
    %     ax6.CameraPosition = [-2.8334    1.2368    2.0467]*1E3;
    
    fprintf('%d: save fig \n',trial.params.trial)
    
    saveas(f,fullfile(D,'trackedPositions',sprintf(regexprep(trialStem,{'_Raw_','.mat'},{'_TrackedPosFig_',''}),trial.params.trial)),'png');
end
