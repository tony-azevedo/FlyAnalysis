%% Script_AddTrackedPositionsAndLegAngle
DEBUG_PLOT = 0;
DEBUG_WATCHFIT = 0;

if ~exist(fullfile(D,'csv'),'dir')
    mkdir(fullfile(D,'csv'))
end
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

% Skip it if there is already a field
if isfield(trial ,'legPositions') %&& isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
    fprintf('%d: Positions already extracted from csv;\n',trial.params.trial)
    
elseif ~isfield(trial,'legPositions')
    
    % look for the image 1 .csv file, add the raw data to the trial
    % file, then move the file
    csvname = dir(regexprep(trial.imageFile,'.avi','DeepCut_*_FemurTibiaJoint*.csv'));
    trial.legPositions.filename = csvname.name;
    opts = detectImportOptions(trial.legPositions.filename);
    T = readtable(trial.legPositions.filename);
    bodyparts = T{1,:};
    coordvals = T{2,:};
    bdprtcrds = bodyparts;
    
    for s_idx = 1:length(bodyparts)
        bdprtcrds{s_idx} = [bodyparts{s_idx} '_' coordvals{s_idx}];
    end
    T_0 = preview(trial.legPositions.filename,opts);
    T2 = readtable(trial.legPositions.filename,opts);
    
    T2.Properties.VariableNames = bdprtcrds;
    
    % strip down the table to Femur and Tibia XY points (and index)
    trial.legPositions.Positions = T2(:,[1 find(contains(bdprtcrds,{'Femur','Tibia'}) & contains(bdprtcrds,{'_x','_y'}))]) ;
    
    % save file (adds another 98 KB to file, not bad)
    save(trial.name, '-struct', 'trial')
    movefile(fullfile(D,trial.legPositions.filename),fullfile(D,'csv'))
    
    fprintf('%s: %d of %d body part coords\n',sprintf(trialStem,trial.params.trial),width(trial.legPositions.Positions),width(T2));
end

if isfield(trial.legPositions,'Origin_4D')
    fprintf('\%d: Origin and elevation already calculated;\n',trial.params.trial)
    
    % Skip it
    
elseif ~isfield(trial.legPositions,'Origin_4D')
    fprintf('%d: Fitting tibia lines, estimating origin\n',trial.params.trial);
    
    bdprts = trial.legPositions.Positions.Properties.VariableNames;
    
    % assume femur doesn't move and use all points
    FemurCoords_x = trial.legPositions.Positions{:,startsWith(bdprts,'Femur')& endsWith(bdprts,'_x') }(:);
    FemurCoords_y = trial.legPositions.Positions{:,startsWith(bdprts,'Femur')& endsWith(bdprts,'_y') }(:);
    FemurCoords = [FemurCoords_x,FemurCoords_y];
    
    Femur_centered = FemurCoords - repmat(mean(FemurCoords,1),size(FemurCoords,1),1);
    [U,S,V] = svd(Femur_centered,0);
    direc = V(:,diag(S)==max(diag(S)));
    normal = V(:,diag(S)==min(diag(S)));
    FemurLine = [mean(FemurCoords,1) direc(:)'];
    
    if DEBUG_PLOT
        vid = VideoReader(trial.imageFile);
        vid.CurrentTime = 1;
        frame = vid.readFrame;
        frame = double(squeeze(frame(:,:,1)));
        figure, ax = subplot(1,1,1);
        im = imshow(frame,[0 128]);
        hold on
        plot(FemurCoords(:,1),FemurCoords(:,2),'.r')
        x = [min(FemurCoords_x(:)) max(FemurCoords_x(:))];
        y = FemurLine(1)*x+FemurLine(2);
        hl = plot(ax, x,y,'r' );
        plot(ax,FemurLine(1)+500*FemurLine(3)*[-1 1],FemurLine(2)+500*FemurLine(4)*[-1 1],'r')
    end
    
    
    
    %% Then go through all the points in the Tibia coords and fit an
    % ellipse, with width constraints?
    
    TibiaCoords_x = trial.legPositions.Positions{:,startsWith(bdprts,'Tibia')& endsWith(bdprts,'_x') };
    TibiaCoords_y = trial.legPositions.Positions{:,startsWith(bdprts,'Tibia')& endsWith(bdprts,'_y') };
    vid.CurrentTime = 0;
    TibiaLine = zeros(height(trial.legPositions.Positions),4);
    imgidx = 0;
    
    while imgidx < height(trial.legPositions.Positions)
        
        imgidx = imgidx+1;
        xy = [TibiaCoords_x(imgidx,:)' TibiaCoords_y(imgidx,:)'];
        xy_centered = xy - repmat(mean(xy,1),size(xy,1),1);
        [U,S,V] = svd(xy_centered,0);
        direc = V(:,diag(S)==max(diag(S)));
        normal = V(:,diag(S)==min(diag(S)));
        TibiaLine(imgidx,:) = [mean(xy,1) direc(:)'];
        
        xy_fit = [direc'*max(xy_centered*direc);direc'*min(xy_centered*direc)] + repmat(mean(xy,1),2,1);
        
        if DEBUG_WATCHFIT
            frame = vid.readFrame;
            frame = double(squeeze(frame(:,:,1)));
            im.CData = frame;
            if imgidx == 1
                dots = plot(ax,TibiaCoords_x(imgidx,:),TibiaCoords_y(imgidx,:),'.c');
                hl = plot(ax, xy_fit(:,1),xy_fit(:,2),'c' );
            else
                dots.XData = TibiaCoords_x(imgidx,:); dots.YData = TibiaCoords_y(imgidx,:);
                hl.XData = xy_fit(:,1); hl.YData = xy_fit(:,2);
            end
            drawnow
            pause(.005)
        end
    end
    
    
    PA = TibiaLine(imgidx,1:2);
    PB = TibiaLine(imgidx,1:2);
    
    for imgidx = 1:height(trial.legPositions.Positions)
        vect = TibiaLine(imgidx,:);
        
        PA(imgidx,:) = [vect(1) vect(2)];
        PB(imgidx,:) = [vect(1)-vect(3) vect(2)-vect(4)];
    end
    
    [origin,distances] = lineIntersect2D(PA,PB);
    FemurLine(1:2) = origin;
    
    % establish orientation of FemurLine (assuming it's oriented in
    % standard direction (up and to right from joint)
    if FemurLine(3)<0 || FemurLine(4)>0
        FemurLine(3:4) = FemurLine(3:4)*-1;
    end
    
    
    %% Now use the intercept point to calculate angle and radius from mean of tibia points
    
    tibiaAngleLength = PA;
    tibiaRadiansLength = PA;
    tibia_vects = TibiaLine(:,1:2)-repmat(origin,size(TibiaLine,1),1);
    femurUnit = FemurLine(3:4)';
    
    if DEBUG_PLOT
        figure
        ax3 = subplot(1,1,1);
        vid.CurrentTime = 0;
        frame = vid.readFrame;
        frame = double(squeeze(frame(:,:,1)));
        
        im = imshow(frame,[0 128]);
        hold(ax3,'on')
        plot(ax3,origin(1),origin(2),'ro');
        
        plot(ax3,[origin(1) origin(1)+200*femurUnit(1)],[origin(2) origin(2)+200*femurUnit(2)],'r')
    end
    
    for imgidx = 1:size(TibiaLine,1)
        xy = [TibiaCoords_x(imgidx,:)' TibiaCoords_y(imgidx,:)'];
        xy_fromOrigin = xy - repmat(origin,size(xy,1),1);

        r = xy_fromOrigin(:,1).^2 + xy_fromOrigin(:,2).^2; r_top2 = sort(r,'descend');
        r_top2 = r==r_top2(1) | r==r_top2(2);
        direc = TibiaLine(imgidx,3:4);
        TibiaLine(imgidx,(1:2)) = direc*(mean(xy_fromOrigin(r_top2,:),1)*direc') + origin;
        tibia_vect = TibiaLine(imgidx,1:2);

        if DEBUG_PLOT
            plot(ax3,[origin(1) tibia_vect(1)],[origin(2) tibia_vect(2)],'c')
        end
    end
    
    legPositions.filename = trial.legPositions.filename;
    legPositions.Positions = trial.legPositions.Positions;
  
    legPositions.Origin = origin;
    legPositions.Femur = [femurUnit' 0];
    legPositions.Tibia_Projection = TibiaLine;
    % trial.legPositions.Tibia_Angle = acosd(trial.legPositions.Tibia_Projection * repmat(femurUnit_plane(1:2),N,1))
    % trial.legPositions.Tibia_Length = sqrt(trial.legPositions.Tibia_Projection(:,1).^2 + trial.legPositions.Tibia_Projection(:,2).^2);

    trial.legPositions = legPositions;
    save(trial.name,'-struct','trial');

end

% 
% if ~isfield(trial.legPositions,'Tibia_ProjectionElipse')
%     % Finally, fit an ellipse and assume the plane is rotated off horizontal
%     fprintf('\n%d: Fitting ellipse \t',trial.params.trial),tic
%     % do a funny thing here where you artificially take few points and
%     % project them to the other side of the origin, ~3%
%     fakevects = -1*tibia_vects(randi(size(tibia_vects,1),round(size(tibia_vects,1)/33),1),:);
%     elvect = [tibia_vects;fakevects];
%     [z, a, b, alpha] = fitellipse(elvect);
%     toc
%     
%     origin_est = origin+z';
%     R = mean(tibiaAngleLength(tibiaAngleLength(:,2)>quantile(tibiaAngleLength(:,2),.95),2));
%     
%     tibia_vects = TibiaLine(:,1:2)-repmat(origin_est,size(TibiaLine,1),1);
%     origin_est(3) = 0;
%     tibia_vects_plane = [tibia_vects,zeros(size(TibiaLine,1),1)];
%     tibia_vects_3D = tibia_vects_plane;
%     tibiaAngleLength_elavated = tibiaAngleLength;
%     
%     femurUnit_plane = [femurUnit;0];
%     
%     if DEBUG_PLOT
%         figure
%         ax4 = subplot(1,1,1);
%         plot3(ax4,origin_est(1),origin_est(2),origin_est(3),'mo');
%         hold(ax4,'on')
%         ax4.XGrid = 'on';
%         ax4.YGrid = 'on';
%     end
%     for imgidx = 1:size(TibiaLine,1)
%         %fprintf('\n%d:',imgidx);
%         tibia_vect = tibia_vects_plane(imgidx,:);
%         tibia_vect(3) = sqrt(abs(R^2 - norm(tibia_vect(1:2))^2));
%         tibia_vects_3D(imgidx,:) = tibia_vect;
%         tibiaAngleLength_elavated(imgidx,:) = [acosd((tibia_vect*femurUnit_plane)/norm(tibia_vect)) norm(tibia_vect)];
%         if DEBUG_PLOT
%             plot3(ax4,[origin_est(1) origin_est(1)+tibia_vect(1)],[origin_est(2) origin_est(2)+tibia_vect(2)],[origin_est(3) origin_est(3)+tibia_vect(3)],'c')
%         end
%     end
%     
%     trial.legPositions.Origin_3D = origin_est;
%     %trial.legPositions.Tibia_3D_polar = tibiaAngleLength_elavated;
%     trial.legPositions.Tibia_3D = tibia_vects_3D;
%     trial.legPositions.Femur_3D = femurUnit_plane;
%     % trial.legPositions.Tibia_Projection = tibia_vects;
%     % trial.legPositions.Tibia_Projection_polar = tibiaAngleLength; % get this with 
%     %[trial.legPositions.Tibia_Projection * repmat(femurUnit_plane(1:2),N,1),
%     %    sqrt(trial.legPositions.Tibia_Projection(:,1).^2 + trial.legPositions.Tibia_Projection(:,2).^2)];
%     trial.legPositions.Tibia_Angle = tibiaAngleLength_elavated(:,1);
%     trial.legPositions.elevationAngle = acosd(b/a);
%     trial.legPositions.Tibia_ProjectionElipse = [z, a, b, alpha];
%     
%     fprintf('\t%d: Saving trial\t\n',trial.params.trial)
%     
%     save(trial.name,'-struct','trial');
%     if DEBUG_PLOT
%         pause, close all
%     end
%     
%     
%     f = figure;
%     f.Position = [680    32   560   964];
%     ax5 = subplot(2,1,1,'parent',f); ax5.Position = [0.02 0.5838 0.96 0.4];
%     vid = VideoReader(trial.imageFile);
%     vid.CurrentTime = 1;
%     frame = vid.readFrame;
%     frame = double(squeeze(frame(:,:,1)));
%     im = imshow(frame,[0 128],'InitialMagnification',75,'parent',ax5);
%     hold(ax5,'on');
%     
%     plotellipse(ax5,origin+z', a, b, alpha);
%     plot3(ax5,origin_est(1)+tibia_vects_3D(:,1),origin_est(2)+tibia_vects_3D(:,2),origin_est(3)+tibia_vects_3D(:,3),'c.');
%     plot3(ax5,origin_est(1)+300*[0,femurUnit_plane(1)], origin_est(2)+300*[0,femurUnit_plane(2)],origin_est(3)+300*[0,femurUnit_plane(3)],'r');
%     
%     ax6 = subplot(2,1,2,'parent',f);
%     el = plotellipse(ax6,origin+z', a, b, alpha);
%     el.ZData = 0*el.YData;
%     hold(ax6,'on')
%     plot3(ax6,origin_est(1)+tibia_vects_3D(:,1),origin_est(2)+tibia_vects_3D(:,2),origin_est(3)+tibia_vects_3D(:,3),'m.');
%     plot3(ax6,origin_est(1)+300*[0,femurUnit_plane(1)], origin_est(2)+300*[0,femurUnit_plane(2)],origin_est(3)+300*[0,femurUnit_plane(3)],'r');
%     
%     ax6.XGrid = 'on';
%     ax6.YGrid = 'on';
%     ax6.YDir = 'reverse';
%     ax6.CameraPosition = [-2.8334    1.2368    2.0467]*1E3;
%     
%     
%     saveas(f,fullfile(D,'trackedPositions',sprintf(regexprep(trialStem,{'_Raw_','.mat'},{'_TrackedPosFig_',''}),trial.params.trial)),'png');
%     close(f)
% end

