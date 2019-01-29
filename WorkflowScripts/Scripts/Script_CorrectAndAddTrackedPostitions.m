%% Script_CorrectAndAddTrackedPostitions
DEBUG_PLOT = 0;
DEBUG_WATCHFIT = 1;

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
    bodyparts = bodyparts(contains(bdprtcrds,{'Femur','Tibia'}) & contains(bdprtcrds,{'_x','_y'}));
    bodyparts = unique(bodyparts(2:end));

    imgidx = 1;
    if DEBUG_PLOT
        %% Proofread csv file to make sure positions are correct.
        vid = VideoReader(trial.imageFile);
        I = vid.readFrame;
        I = double(squeeze(I(:,:,1)));
        
        displayf = figure;
        set(displayf,'position',[120 10 fliplr(size(I))]+[0 0 0 10],'tag','big_fig');
        displayf.MenuBar = 'none';
        displayf.ToolBar = 'none';
        
        dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(size(I))]);
        set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
        colormap(dispax,'gray')
        
        clear pnt

        im = imshow(I,[0 1.6*quantile(I(:),0.975)],'parent',dispax);
        % ask to label each point static point in turn
        txt = text(dispax,size(I,2)/3,20,'TXT');
        txt.Position = [20 10 0]*size(I,2)/640;
        txt.VerticalAlignment = 'top';
        txt.Color = [1 1 1];
        txt.FontSize = 18;
        txt.FontName = 'Ariel';
        
        % put each body part on the image
        clrs = distinguishable_colors(length(bodyparts));

        try delete(pnt); catch e, end
        for bdidx = 1:length(bodyparts)
            T_X = trial.legPositions.Positions.([bodyparts{bdidx} '_x']);
            T_Y = trial.legPositions.Positions.([bodyparts{bdidx} '_y']);
            xy = [T_X(imgidx,1) T_Y(imgidx,1)];
            pnt(bdidx) = impoint(dispax,xy);
            pnt(bdidx).setColor(clrs(bdidx,:));
            pnt(bdidx).setString(bodyparts{bdidx});
        end
        
        button = questdlg('Are points correctly labeled?','Correct Labels?','Yes');
        uiwait();
        switch button
            case 'No'
                error('Ahhhhh! Where did I go wrong on this one?');
                
            case 'Cancel'
                return
            case 'Yes'
                fprintf('Continuing, saving positions')
        end
    end
    
    
    TibiaCoords_x = trial.legPositions.Positions{:,startsWith(bdprts,'Tibia')& endsWith(bdprts,'_x') };
    TibiaCoords_y = trial.legPositions.Positions{:,startsWith(bdprts,'Tibia')& endsWith(bdprts,'_y') };

    TibiaCoords_x = trial.legPositions.Positions(:,startsWith(bdprts,'Tibia')& endsWith(bdprts,'_x'));
    TibiaCoords_y = trial.legPositions.Positions(:,startsWith(bdprts,'Tibia')& endsWith(bdprts,'_y'));

    TibiaParts = regexprep(TibiaCoords_x.Properties.VariableNames,'_x','');
    TibiaParts = regexprep(TibiaParts,'Constriction','Kink');
    
    % compute pairwise distances for each point
    varTypes = cell(1,sum(1:size(TibiaCoords_x,2))); varTypes(:) = {'double'};
    D = table('Size',[size(TibiaCoords_x,1),sum(1:size(TibiaCoords_x,2))],'VariableTypes',varTypes);%T = table('Size',sz,'VariableTypes',varTypes)
    c = 0;
    varNames = varTypes;
    for c1 = 1:size(TibiaCoords_x,2)
        for c2 = c1:size(TibiaCoords_x,2)
            c = c+1;
            D{:,c} = sqrt((TibiaCoords_x{:,c1} - TibiaCoords_x{:,c2}).^2 + (TibiaCoords_y{:,c1} - TibiaCoords_y{:,c2}).^2);
            varNames{c} = [TibiaParts{c1} '_vs_' TibiaParts{c2}];
        end
    end
    D.Properties.VariableNames = varNames;
        
    distfig = figure;
    pairs = TibiaParts;
    for i = 1:length(TibiaParts)
        name = regexprep(TibiaParts{i},{'TibiaDorsal','TibiaVentral'},{'fore','aft'});
        name = [TibiaParts{i} '_vs_' regexprep(name,{'fore','aft'},{'TibiaVentral','TibiaDorsal'})];
        try plot(D.(name)); hold on, catch e, end
        pairs{i} = name;
    end
    
    
    if DEBUG_PLOT
        %% Look at how good the tracking is and apply median filter
        tcx = medfilt1(TibiaCoords_x,5,[],1,'omitnan','truncate');
        tcy = medfilt1(TibiaCoords_y,5,[],1,'omitnan','truncate');

        xlims = [min(TibiaCoords_x(:)) max(TibiaCoords_x(:))];
        ylims = [min(TibiaCoords_y(:)) max(TibiaCoords_y(:))];

        medfilterfig = figure;
        medfilterfig.Position = [171 78 1069 900];
        ax = subplot(2,2,1,'parent',medfilterfig);
%         plot(ax,TibiaCoords_y,'color',[.8 .8 .8]); hold(ax,'on')
        plot(ax,TibiaCoords_y); hold(ax,'on')
%         plot(ax,tcy); 
        ax.YLim = ylims;

        ax = subplot(2,2,4,'parent',medfilterfig);
%         plot(ax,TibiaCoords_x,'color',[.8 .8 .8]); hold(ax,'on')
        plot(ax,TibiaCoords_x); hold(ax,'on')
%         plot(ax,tcx); 
        ax.YLim = xlims;
        ax.View = [90 -90]
        
        ax = subplot(2,2,2,'parent',medfilterfig);
%         plot(ax,TibiaCoords_x,TibiaCoords_y,'color',[.8 .8 .8]); hold(ax,'on')
        plot(ax,TibiaCoords_x,TibiaCoords_y); hold(ax,'on')
%         plot(ax,tcx,tcy); 
%         axis(ax,'equal')
        ax.XLim = xlims;
        ax.YLim = ylims
        
    end    
    % save file (adds another 98 KB to file, not bad)
    save(trial.name, '-struct', 'trial')
    movefile(fullfile(D,trial.legPositions.filename),fullfile(D,'csv'))
    
    fprintf('%s: %d of %d body part coords\n',sprintf(trialStem,trial.params.trial),width(trial.legPositions.Positions),width(T2));
end



%% Everything below this will be deleted

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
