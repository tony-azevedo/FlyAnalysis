%% Assume a trial has been loaded and that it has the positions already there
t = makeInTime(trial.params);
exp = postHocExposure(trial);

%% checking to see whether other useful variables exist
if ~exist('weird_dists','var')
    fprintf('Have NOT found weird points \nwith distances outside of expected distributions');
else
    fprintf('Weird Points Found: use ''w'' to find the next one\n');
    if exist('Coords','var')
        fprintf('Coords Found\n');
    end
    if exist('bounds','var')
        fprintf('Bounds Found\n');
    end
    if exist('pairs','var')
        fprintf('Pairs Found\n');
    end
    if exist('TibiaParts','var')
        fprintf('TibiaParts Found\n');
    end
    np = trial.legPositions.Positions{:,:};
    npcn = trial.legPositions.Positions.Properties.VariableNames;
    
    weird_pnts_trl = isnan(trial.legPositions.Positions{:,:};
    
    dist_trl = PWDists{Coords{:,1}==trial.params.trial,:};
    SHOW_WEIRD_DISTANCES = 1;
    
    weirddist = gobjects(1,size(weird_dists_trl,2));
    delete(weirddist)
    
    fprintf('%d Weird frames left\n',sum(any(weird_dists_trl,2)));
end

%%

ft = t(exp.exposure);
vt = ft-ft(1);

fr_idx = 1;
vid = VideoReader(trial.imageFile);
vid.CurrentTime = 0; %weird_ft(1);
I = vid.readFrame;
I = double(squeeze(I(:,:,1)));

displayf = figure;
set(displayf,'position',[534 16 fliplr(size(I))]+[0 0 0 10],'tag','big_fig');
displayf.MenuBar = 'none';
displayf.ToolBar = 'none';

dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(size(I))]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

im = imshow(I,[0 1.6*quantile(I(:),0.975)],'parent',dispax);

clear pnt

% ask to label each point static point in turn
txt = text(dispax,size(I,2)/3,20,'TXT');
txt.Position = [20 10 0]*size(I,2)/640;
txt.VerticalAlignment = 'top';
txt.Color = [1 1 1];
txt.FontSize = 18;
txt.FontName = 'Ariel';

% put each body part on the image
bodyparts = trial.legPositions.Positions.Properties.VariableNames(contains(trial.legPositions.Positions.Properties.VariableNames,'_x'));
bodyparts = regexprep(bodyparts,'_x','');
changedpnts = false(size(bodyparts));
clrs = distinguishable_colors(length(bodyparts));

try delete(pnt); catch e, end

for bdidx = 1:length(bodyparts)
    xidx = contains(npcn,[bodyparts{bdidx} '_x']);
    yidx = contains(npcn,[bodyparts{bdidx} '_y']);
    xy = [np(fr_idx,xidx) np(fr_idx,yidx)];
    pnt(bdidx) = drawpoint(dispax,'Position',xy,'Color',clrs(bdidx,:),'Label',bodyparts{bdidx});
    if SHOW_WEIRD_DISTANCES % && sum(weird_pnts_trl(fr_idx,:))
        pnt(bdidx).Color = [.8 .8 .8];
        pnt(bdidx).Label = '';
    end
end

dispax.NextPlot = 'add';
[path, fn,ext] = fileparts(trial.name);
% for i = 1:length(imnames)
while fr_idx <= length(ft)
    % load up each image,
    % put a big title on the image,
    vid.CurrentTime = vt(fr_idx);
    txt.String = sprintf('%s:\n%g (%d of %d)',regexprep(fn,'\_','\\_'),ft(fr_idx), fr_idx, length(ft));
    I = vid.readFrame;
    I = double(I);
    I = squeeze(I(:,:,1));
    
    im.CData = I;
    
    for bdidx = 1:length(bodyparts)
        xidx = contains(npcn,[bodyparts{bdidx} '_x']);
        yidx = contains(npcn,[bodyparts{bdidx} '_y']);
        xy = [np(fr_idx,xidx) np(fr_idx,yidx)];
        pnt(bdidx).Position = xy;
        if SHOW_WEIRD_DISTANCES % && sum(weird_pnts_trl(fr_idx,:))
            pnt(bdidx).Color = [.8 .8 .8];
            pnt(bdidx).Label = '';
        end
    end
    
    if SHOW_WEIRD_DISTANCES && sum(weird_dists_trl(fr_idx,:))
        changed_comps = false(size(pairs));
        for bdidx = find(changedpnts)
            chngdprt = bodyparts{bdidx};
            changed_comps = changed_comps | contains(pairs,chngdprt);
        end
        
        weird_pnts_fr = find(weird_dists_trl(fr_idx,:) | any(changed_comps,1));
        dist_fr = dist_trl(fr_idx,:);
        for wp = weird_pnts_fr
            weird_parts = pairs(:,wp);
            
            xidx = contains(npcn,[weird_parts{1,:} '_x']);
            yidx = contains(npcn,[weird_parts{1,:} '_y']);
            pos1 = [np(fr_idx,xidx) np(fr_idx,yidx)];
            xidx = contains(npcn,[weird_parts{2,:} '_x']);
            yidx = contains(npcn,[weird_parts{2,:} '_y']);
            pos2 = [np(fr_idx,xidx) np(fr_idx,yidx)];
            
            pairwiseD = sqrt((pos1(1) - pos2(1)).^2 + (pos1(2) - pos2(2)).^2);
            weird = pairwiseD < bounds(1,wp) || pairwiseD > bounds(2,wp);
            
            if weird_dists_trl(fr_idx,wp)
                p1idx = contains(bodyparts,weird_parts{1,:});
                p2idx = contains(bodyparts,weird_parts{2,:});
                pnt(p1idx).Color = clrs(p1idx,:);
                uidx = isstrprop(bodyparts{p1idx},'upper') ;
                pnt(p1idx).Label = bodyparts{p1idx}(uidx);
                pnt(p2idx).Color = clrs(p2idx,:);
                uidx = isstrprop(bodyparts{p2idx},'upper') ;
                pnt(p2idx).Label = bodyparts{p2idx}(uidx);
            end
            
            if weird
                delete(weirddist(wp))
                weirddist(wp) = plot(dispax,[pos1(1) pos2(1)] , [pos1(2) pos2(2)],'Color',[1 1 1]); %#ok<*SAGROW>
                %uistack(weirddist(wp),'top')
                
            elseif ~weird && isvalid(weirddist(wp))
                delete(weirddist(wp))
                weirddist(wp) = plot(dispax,[pos1(1) pos2(1)] , [pos1(2) pos2(2)],'Color',[0 1 0]); %#ok<*SAGROW>
                %uistack(weirddist(wp),'top')
                
            end
        end
        
    end
    
    
    % Allow user to move the points around a little
    % then wait for a button click or a space bar
    keydown = waitforbuttonpress;
    while keydown==0 || ~any(strcmp({' ','j','k','g','w','r','s','q'},displayf.CurrentCharacter))
        %disp(displayf.CurrentCharacter);
        keydown = waitforbuttonpress;
    end
    cmd_key = displayf.CurrentCharacter;
    
    % Put the new positions back into the matrix
    for bdidx = 1:length(bodyparts)
        pos = pnt(bdidx).Position;
        
        xidx = contains(npcn,[bodyparts{bdidx} '_x']);
        yidx = contains(npcn,[bodyparts{bdidx} '_y']);
        
        if pos(1) ~= np(fr_idx,xidx) || pos(2) ~= np(fr_idx,yidx)
            np(fr_idx,xidx) = pos(1);
            np(fr_idx,yidx) = pos(2);
            changedpnts(bdidx) = true;
        end
    end
    
    switch cmd_key
        case ' '
            fr_idx = fr_idx+1;
        case 'j'
            fr_idx = fr_idx+1;
        case 'k'
            fr_idx = fr_idx-1;
            if fr_idx<1
                fr_idx=1;
            end
        case 'g'
            fr = inputdlg('Which frame?','Go To:',1);
            try fr = str2double(fr);
            catch e
                continue
            end
            fr_idx = max([fr,1]);
            fr_idx = min(fr_idx,length(ft));
        case 'w'
            weird_frms = any(weird_dists_trl,2);
            fr = find(weird_frms(fr_idx+1:end))+fr_idx;
            if ~isempty(fr)
                fr_idx = max([fr(1),1]);
            else
                fr_idx = 1;
                fr = find(weird_frms(fr_idx+1:end))+fr_idx;
            end
            fr_idx = min(fr_idx,length(weird_frms));

            fprintf('%d Weird frames left\n',length(fr));

            
        case 'r' % Reload: recalculate whether the points are normal


        case 'q'
            fprintf('quitting\n')
            delete(weirddist)
            clear weirddist
            break
            
        case 's' % save the new positions to the trial
            fprintf('Saving new positions, can always go back to original ones\n')
            trial.legPositions.Positions{:,:} = np;
            trial.legPositions.PositionsChanged = 1;
                        
            % Recalulate the number of weird frames after having gone
            % through the corrections
            if SHOW_WEIRD_DISTANCES
                fprintf('Weird Trials start:\t %d\n',sum(any(weird_dists_trl,2)));
                pairwiseD = double(weird_dists_trl);
                weird_points_post = false(size(pairwiseD));
                for c = 1:size(pairs,2)
                    part1 = pairs{1,c};
                    part2 = pairs{2,c};
                    p1col1 = contains(npcn,[part1 '_x']);
                    p1col2 = contains(npcn,[part1 '_y']);
                    p2col1 = contains(npcn,[part2 '_x']);
                    p2col2 = contains(npcn,[part2 '_y']);

                    pairwiseD(:,c) = sqrt((np(:,p1col1) - np(:,p2col1)).^2 + (np(:,p1col2) - np(:,p2col2)).^2);
                    weird_points_post(:,c) = pairwiseD(:,c) >= max(bounds(:,c)) | pairwiseD(:,c) <= min(bounds(:,c));
                end
                                
                % For each distance comparison, determine weird ones
                weird_frames = any(weird_points_post,2);
                fprintf('%d frames are weird\n',sum(weird_frames));
            end
            save(trial.name,'-struct','trial');
            
            break
        otherwise
    end
    
    if ~strcmp(cmd_key,'r')
        delete(weirddist);
        changedpnts(:) = false;
    end
    
end


fprintf('All done\n')
close(displayf)