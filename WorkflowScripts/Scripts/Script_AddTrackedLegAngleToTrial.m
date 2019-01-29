%% Script_AddTrackedLegAngleToTrial
DEBUG_PLOT = 0;
DEBUG_WATCHFIT = 0;
if DEBUG_PLOT
    f = figure; ax = subplot(1,1,1,'parent',f); ax.NextPlot = 'add';
    txt = text(ax,20,20,'TXT');
    txt.VerticalAlignment = 'top';
    txt.Color = [1 1 1];
    txt.FontSize = 14;
    txt.FontName = 'Ariel';
    txt.String ='txt';
end

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

cnt = 0;
for tr_idx = trialnumlist
    cnt = cnt+1;
    trial = load(sprintf(trialStem,tr_idx));
    waitbar(cnt/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
    
    if ~isfield(trial.legPositions,'Positions_Corrected')
        fprintf('%d: First, correct and smooth the DLC generated positions\n',trial.params.trial)
    
    elseif isfield(trial.legPositions,'Origin_3D')
        fprintf('\%d: Origin and elevation already calculated;\n',trial.params.trial)
        
        % Skip it
        
    elseif ~isfield(trial.legPositions,'Origin_3D')
        fprintf('%d: Fitting tibia lines, estimating origin\n',trial.params.trial);
        
        bdprts = trial.legPositions.Positions_Corrected.Properties.VariableNames;
        
        % assume femur doesn't move and use all points
        FemurCoords_x = trial.legPositions.Positions_Corrected{:,startsWith(bdprts,'Femur')& endsWith(bdprts,'_x') }(:);
        FemurCoords_y = trial.legPositions.Positions_Corrected{:,startsWith(bdprts,'Femur')& endsWith(bdprts,'_y') }(:);
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
            cla(ax), ax.NextPlot = 'add';
            im = imshow(frame,[0 128],'parent',ax);
            plot(ax,FemurCoords(:,1),FemurCoords(:,2),'.r')
            %             x = [min(FemurCoords_x(:)) max(FemurCoords_x(:))];
            %             y = FemurLine(1)*x+FemurLine(2);
            %             hl = plot(ax, x,y,'r' );
            plot(ax,FemurLine(1)+500*FemurLine(3)*[-1 1],FemurLine(2)+500*FemurLine(4)*[-1 1],'r')
            
            txt = text(ax,20,20,'TXT');
            txt.VerticalAlignment = 'top';
            txt.Color = [1 1 1];
            txt.FontSize = 14;
            txt.FontName = 'Ariel';
            txt.String ='Femur Line';

            pause(.1)
        end
        
        
        
        %% Then go through all the points in the Tibia coords and fit an
        % ellipse, with width constraints?
        
        TibiaCoords_x = trial.legPositions.Positions_Corrected{:,startsWith(bdprts,'Tibia')& endsWith(bdprts,'_x') };
        TibiaCoords_y = trial.legPositions.Positions_Corrected{:,startsWith(bdprts,'Tibia')& endsWith(bdprts,'_y') };
        vid.CurrentTime = 0;
        TibiaLine = nan(height(trial.legPositions.Positions_Corrected),4);
        weirdidx = false(height(trial.legPositions.Positions_Corrected),1);

        imgidx = 0;
        while imgidx < height(trial.legPositions.Positions_Corrected)
            
            
            imgidx = imgidx+1;
            xy = [TibiaCoords_x(imgidx,:)' TibiaCoords_y(imgidx,:)'];
            if any(isnan(xy(:)))
                weirdidx(imgidx) = true;
                if DEBUG_PLOT && DEBUG_WATCHFIT
                    frame = vid.readFrame;
                end

                continue
            end
            
            xy_centered = xy - repmat(mean(xy,1),size(xy,1),1);
            [U,S,V] = svd(xy_centered,0);
            direc = V(:,diag(S)==max(diag(S)));
            normal = V(:,diag(S)==min(diag(S)));
            TibiaLine(imgidx,:) = [mean(xy,1) direc(:)'];
            
            
            if DEBUG_PLOT && DEBUG_WATCHFIT %&& ~mod(imgidx,20)
                disp(vid.CurrentTime);
                frame = vid.readFrame;
                frame = double(squeeze(frame(:,:,1)));
                im.CData = frame;
                xy_fit = [direc'*max(xy_centered*direc);direc'*min(xy_centered*direc)] + repmat(mean(xy,1),2,1);
                if imgidx == 1
                    dots = plot(ax,TibiaCoords_x(imgidx,:),TibiaCoords_y(imgidx,:),'.c');
                    hl = plot(ax, xy_fit(:,1),xy_fit(:,2),'c' );
                else
                    dots.XData = TibiaCoords_x(imgidx,:); dots.YData = TibiaCoords_y(imgidx,:);
                    hl.XData = xy_fit(:,1); hl.YData = xy_fit(:,2);
                end
                drawnow
                pause(.005)
                txt.String = num2str(imgidx);
            end
        end    
        
        PA = TibiaLine(:,1:2);
        PB = TibiaLine(:,1:2);
        
        for imgidx = 1:height(trial.legPositions.Positions)
            
            vect = TibiaLine(imgidx,:);
            if any(isnan(vect))
                continue
            end

            PA(imgidx,:) = [vect(1) vect(2)];
            PB(imgidx,:) = [vect(1)-vect(3) vect(2)-vect(4)];
        end
        
        [origin,distances] = lineIntersect2D(PA(~weirdidx,:),PB(~weirdidx,:));
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
            
            vid.CurrentTime = 0;
            frame = vid.readFrame;
            frame = double(squeeze(frame(:,:,1)));
            
            cla(ax),ax.NextPlot = 'add';
            im = imshow(frame,[0 128],'parent',ax);
            hold(ax,'on')
            plot(ax,origin(1),origin(2),'ro');
            
            plot(ax,[origin(1) origin(1)+200*femurUnit(1)],[origin(2) origin(2)+200*femurUnit(2)],'r')
            txt = text(ax,20,20,'TXT');
            txt.VerticalAlignment = 'top';
            txt.Color = [1 1 1];
            txt.FontSize = 14;
            txt.FontName = 'Ariel';
            txt.String ='Tibia Lines from origin';

        end
        
        for imgidx = 1:size(TibiaLine,1)
            if any(isnan(TibiaLine(imgidx,:)))
                continue
            end

            xy = [TibiaCoords_x(imgidx,:)' TibiaCoords_y(imgidx,:)'];
            xy_fromOrigin = xy - repmat(origin,size(xy,1),1);
            
            r = xy_fromOrigin(:,1).^2 + xy_fromOrigin(:,2).^2; 
            r_top2 = sort(r,'descend');
            r_top2 = r==r_top2(1) | r==r_top2(2);
            direc = TibiaLine(imgidx,3:4);
            TibiaLine(imgidx,(1:2)) = direc*(mean(xy_fromOrigin(:,:),1)*direc') + origin;
            tibia_vect = TibiaLine(imgidx,1:2);
            
            if DEBUG_PLOT
                plot(ax,[origin(1) tibia_vect(1)],[origin(2) tibia_vect(2)],'c')
            end
        end
        
        %%
        
        trial.legPositions.Origin = origin;
        trial.legPositions.Femur = [femurUnit' 0];
        trial.legPositions.Tibia_Projection = TibiaLine;
        
        save(trial.name,'-struct','trial');
        
    end
end
