%% Script to label points in randomly selected frames.
% Use Step1 code in python to collect random Frames. See Myconfig file for
% all the different inputs


%% Bodyparts
% define the body parts you want to label:
bodyparts = {'FemurTrochanterDorsal', 'FemurTrochanterVentral','FemurBristle3', 'FemurTip','FemurDorsalKneeBristle', 'FemurDorsalIndent','TibiaVentralKink','TibiaVentralMid','TibiaVentralBulge','TibiaDorsalBulge','TibiaDorsalMid','TibiaDorsalConstriction','Probe_end','Probe_shaft','EMG','Brightspot1','Brightspot2','Brightspot3'};
% which of those are going to move between frames?
movingparts = bodyparts([7:12]);
% which of those are NOT going to move between frames?
staticparts = bodyparts([1:6 13:length(bodyparts)]);

% navigate to the traing set folder created by Step1
cd 'C:'\Users\tony\Code\DeepLabCut_Tony\Generating_a_Training_Set\data-femurTibiaJoint_IR_test\

REWRITE = 0;
REWRITE_STATIC = 0;
REWRITE_MOVING = 0;

% find all the directories in the training set folder 
a = dir;
alidx = true(size(a));
for aidx = 1:length(a)
    if ~a(aidx).isdir || strcmp(a(aidx).name,'.') || strcmp(a(aidx).name,'..')
        alidx(aidx) = false;
    end
end
a = a(alidx);


%% Create the figure where you're going to click
close all
displayf = figure;
set(displayf,'position',[120 10 1280 1024],'tag','big_fig');

dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

%% for each directory
for didx = 1:length(a)
    
    cd(a(didx).name);
    fprintf('%s\n',a(didx).name);
    uiwait(msgbox(['New video: ' a(didx).name],'New video','modal'));
    if exist([staticparts{1} '.csv']) && ~REWRITE
        fprintf('Bodypart files have been written, next folder\n');
        cd('..');
        continue
    end        

    imnames = dir('img*');

    if exist('staticpoints.csv') && ~REWRITE_STATIC
        T_static = readtable('staticpoints.csv');
        I = imread(imnames(1).name);
        I = double(I);
        I = squeeze(I(:,:,1));
        
        im = imshow(I,[0 1.6*quantile(I(:),0.975)],'parent',dispax);
        % ask to label each point static point in turn
        txt = text(dispax,800,50,'TXT');
        txt.Color = [1 1 1];
        txt.FontSize = 18;
        txt.FontName = 'Ariel';
        
    else
        
        % static points include: Femur, Probe, EMG
        % show first image
        I = imread(imnames(1).name);
        I = double(I);
        I = squeeze(I(:,:,1));
        
        im = imshow(I,[0 1.6*quantile(I(:),0.975)],'parent',dispax);
        % ask to label each point static point in turn
        txt = text(dispax,800,50,'TXT');
        txt.Color = [1 1 1];
        txt.FontSize = 18;
        txt.FontName = 'Ariel';
        
        for pidx = 1:length(staticparts)
            part = staticparts{pidx};
            txt.String = part;
            pnt(pidx) = impoint(dispax);
            pnts(pidx,:) = pnt(pidx).getPosition;
        end
        
        % Starting a table of static points
        sz = [length(imnames) 2*length(staticparts)+1];
        varTypes = repmat({'double'},1,2*length(staticparts));
        varTypes = ['string',varTypes];
        varNames = {'Img'};
        for pidx = 1:length(staticparts)
            varNames = [varNames {[staticparts{pidx} '_X'] [staticparts{pidx} '_Y']}];
        end
        T_static = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
        
        for pidx = 1:length(pnt)
            pos = pnt(pidx).getPosition;
            T_static{1,pidx*2} = pos(1);
            T_static{1,pidx*2+1} = pos(2);
        end
        
        % for each static part,
        txt.Position(1) = 670;
        for i = 1:length(imnames)
            % load up each image,
            I = imread(imnames(i).name);
            % put a big title on the image,
            txt.String = ['Move points : ' imnames(i).name ' (' num2str(i) ' of ' num2str(length(imnames)) ')'];
            I = double(I);
            I = squeeze(I(:,:,1));
            
            im.CData = I;
            
            % then wait for a button click or a space bar
            keydown = waitforbuttonpress;
            while keydown==0 || ~strcmp(' ',displayf.CurrentCharacter)
                disp(displayf.CurrentCharacter);
                keydown = waitforbuttonpress;
            end
            
            % record either the new position or the old
            T_static{i,1} = {imnames(i).name};
            for pidx = 1:length(pnt)
                pos = pnt(pidx).getPosition;
                T_static{i,pidx*2} = pos(1);
                T_static{i,pidx*2+1} = pos(2);
            end
        end
        
        % get rid of the Femur points
        delete(pnt)
        % save the static table to this point
        writetable(T_static,'staticpoints.csv','WriteRowNames',true)
    
    end
    
    % Now load up the first image again and ask about each of the
    % non-static points
    
    % Starting a table of tibia points    
    sz = [length(imnames) 2*length(movingparts)];
    varTypes = repmat({'double'},1,2*length(movingparts));
    varNames = {};
    for prtidx = 1:length(movingparts)
        varNames = [varNames {[movingparts{prtidx} '_X'] [movingparts{prtidx} '_Y']}];
    end
    T_moving = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

    
    % for each Tibia point
    txt.Position(1) = 670;
    
    for prtidx = 1:length(movingparts)
        
        
        part = movingparts{prtidx};
        uiwait(msgbox(['New Part: ' part],'New part','modal'));
        if exist([part '_points.csv']) && ~REWRITE_MOVING
            partpoints = readtable([part '_points.csv']);
            T_moving(:,prtidx*2-1:prtidx*2) = partpoints;
            fprintf('Loading previous points for %s. Continue to next part.\n',part);
            continue
        end

        I = imread(imnames(1).name);
        I = double(I);
        I = squeeze(I(:,:,1));
        im.CData = I;

        % put a big title on the image,
        txt.String = ['Find ' part ': ' imnames(1).name ' (' num2str(1) ' of ' num2str(length(imnames)) ')'];
        
        % put femur points on the image
        try delete(staticdots); catch e; end
        for sprtidx = 1:length(staticparts)
            pos(1) = T_static{1,sprtidx*2};
            pos(2) = T_static{1,sprtidx*2+1};
            staticdots(sprtidx) = line(pos(1),pos(2),'marker','.','markersize',10,'markerfacecolor',[.3 1 0],'markeredgecolor',[.3,1,0]);
        end

        % put any tibia points on the image
        try delete(movingdots); catch e; end
        for tprtidx = 1:prtidx-1
            pos(1) = T_moving{1,tprtidx*2-1};
            pos(2) = T_moving{1,tprtidx*2};
            movingdots(tprtidx) = line(pos(1),pos(2),'marker','.','markersize',10,'markerfacecolor',[.1 .5 0],'markeredgecolor',[.1 .5 0]);
        end

        % put the established point on the image        
        pnt = impoint(dispax);
        pos = pnt.getPosition;
        T_moving{1,prtidx*2-1} = pos(1);
        T_moving{1,prtidx*2} = pos(2);
        dot = line(pos(1),pos(2),'marker','.','markersize',10,'markerfacecolor',[.6 .2 1],'markeredgecolor',[.6,.2,1],'tag','curpart');

        displayf.Pointer = 'crosshair';
        % load up each image,
        
        delete(findobj('type','hggroup','tag','impoint'))

        for i = 2:length(imnames)
            % load up each image,
            I = imread(imnames(i).name);
            % put a big title on the image,
            txt.String = ['Move ' part ': ' imnames(i).name ' (' num2str(i) ' of ' num2str(length(imnames)) ')'];
            I = double(I);
            I = squeeze(I(:,:,1));
            
            im.CData = I;
            
            % put femur points on the image
            for sprtidx = 1:length(staticparts)
                staticdots(sprtidx).XData = T_static{i,sprtidx*2};
                staticdots(sprtidx).YData = T_static{i,sprtidx*2+1};
            end
            % put other tibia points on there
            for tprtidx = 1:prtidx-1
                movingdots(tprtidx).XData = T_moving{i,tprtidx*2-1};
                movingdots(tprtidx).YData = T_moving{i,tprtidx*2};
            end


            % then wait for a button click or a space bar
            keydown = waitforbuttonpress;
            while keydown~=0 && ~strcmp(' ',displayf.CurrentCharacter)
                disp(displayf.CurrentCharacter);
                keydown = waitforbuttonpress;
            end
            if keydown
                pos(1) = dot.XData;
                pos(2) = dot.YData;
            else
                pos = dispax.CurrentPoint;
                pos = pos(1,1:2);
            end
            dot.MarkerEdgeColor = [.5 0 .7];
            dot.MarkerFaceColor = [.5 0 .7];
            dot = line(pos(1),pos(2),'marker','.','markersize',10,'markerfacecolor',[.6 .2 1],'markeredgecolor',[.6,.2,1],'tag','curpart');

            T_moving{i,prtidx*2-1} = pos(1);
            T_moving{i,prtidx*2} = pos(2);
            % next image
        end

        delete(findobj('type','line','tag','curpart'))
        % save the part, just in case
        partpoints = T_moving(:,prtidx*2-1:prtidx*2);
        writetable(partpoints,[part '_points.csv'],'WriteRowNames',true)
        
    end
    % next Tibia part
    
    % put the parts together into table and save bodyparts
    staticparts = bodyparts([1:6 13:length(bodyparts)]);
    movingparts = bodyparts([7:12]);

    T_all = [T_static(:,(1:13)),T_moving,T_static(:,14:size(T_static,2))];
    
    for bprtidx = 1:length(bodyparts)
        part = bodyparts{bprtidx};
        T = T_all(:,[1,2*bprtidx:2*bprtidx+1]);
        T.Properties.VariableNames = {'Img','X','Y'};
        writetable(T,[part '.csv'],'WriteRowNames',true)
    end
    
    delete(txt);
    cd('..');
    pause(.5);
end
% next directory


%% Proofreading step
cd 'C:'\Users\tony\Code\DeepLabCut_Tony\Generating_a_Training_Set\data-femurTibiaJoint_IR_test\

% find all the directories in the training set folder 
a = dir;
alidx = true(size(a));
for aidx = 1:length(a)
    if ~a(aidx).isdir || strcmp(a(aidx).name,'.') || strcmp(a(aidx).name,'..')
        alidx(aidx) = false;
    end
end
a = a(alidx);

% Create the figure where you're going to click
close all
displayf = figure;
set(displayf,'position',[120 10 1280 1024],'tag','big_fig');

dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

% if subsequent steps (Step2,Step3, etc) are run, then csv files will be
% renamed to xls files. If so, these xls files cannot be read
% into matlab. Change them back if you want to edit them.
XLS_EDIT_OK = 1;

clrs = distinguishable_colors(length(bodyparts));
for didx = 1:length(a)
%    
    cd(a(didx).name);
    fprintf('%s\n',a(didx).name);
    uiwait(msgbox(['Proofreading video: ' a(didx).name],'New video','modal'));

    % For each of the body points, find the file that goes with it.
    for bdidx = 1:length(bodyparts)
        fname = dir([bodyparts{bdidx} '.csv']);
        if isempty(fname)
            fname = dir([bodyparts{bdidx} '.xls']);
            if isempty(fname)
                uiwait(msgbox(['No Part File: ' bodyparts{bdidx}],'Error: No locations','modal'));
                cd('..');
                break
            else
    % if it's an xls, ask about editing it
                if XLS_EDIT_OK
                    uiwait(msgbox(['Part files are xls, changing to .csv: ' bodyparts{bdidx}],'Error: No csv','modal'));
                    fname1 = fname(1).name;
                    movefile(fname1,[bodyparts{bdidx} '.csv']);
                    fname = dir([bodyparts{bdidx} '.csv']);
                else
                    cd('..');
                    break
                end
            end
        end
        fname = fname(1).name;
    % Create a table for each body part
        eval(['T_' bodyparts{bdidx} ' = readtable(''' fname ''');']);
        eval(['T_' bodyparts{bdidx} '.Properties.RowNames = T_' bodyparts{bdidx} '.Img;']);        
    end
    
    eval(['T_cnt = T_' bodyparts{bdidx} ';'])
    
    % Go through each image
    imnames = T_cnt.Img;
    
    I = imread(T_cnt.Img{1});
    I = double(I);
    I = squeeze(I(:,:,1));
        
    im = imshow(I,[0 1.6*quantile(I(:),0.975)],'parent',dispax);
    % ask to label each point static point in turn
    txt = text(dispax,800,50,'TXT');
    txt.Color = [1 1 1];
    txt.FontSize = 18;
    txt.FontName = 'Ariel';
        
    % put each body part on the image
    try delete(pnt); catch e, end
    for bdidx = 1:length(bodyparts)
        eval(['T_cnt = T_' bodyparts{bdidx} ';']);
        xy = T_cnt(imnames{1},2:3);
        pnt(bdidx) = impoint(dispax,[xy.X,xy.Y]);
        pnt(bdidx).setColor(clrs(bdidx,:));
    end

    txt.Position(1) = 620;
    for i = 1:length(imnames)
        % load up each image,
        I = imread(imnames{i});
        % put a big title on the image,
        txt.String = ['Move points (then hit space bar): ' imnames{i} ' (' num2str(i) ' of ' num2str(length(imnames)) ')'];
        I = double(I);
        I = squeeze(I(:,:,1));
        
        im.CData = I;

        for bdidx = 1:length(bodyparts)
            eval(['T_cnt = T_' bodyparts{bdidx} ';']);
            xy = T_cnt(imnames{i},2:3);
            pnt(bdidx).setPosition([xy.X,xy.Y]);
        end
        
        % Allow user to move the points around a little
        % then wait for a button click or a space bar
        keydown = waitforbuttonpress;
        while keydown==0 || ~strcmp(' ',displayf.CurrentCharacter)
            disp(displayf.CurrentCharacter);
            keydown = waitforbuttonpress;
        end
        
        % record either the new position or the old
        for bdidx = 1:length(bodyparts)
            pos = pnt(bdidx).getPosition;
            eval(['T_' bodyparts{bdidx} '{''' imnames{i} ''',2} = ' num2str(pos(1)) ';']);
            eval(['T_' bodyparts{bdidx} '{''' imnames{i} ''',3} = ' num2str(pos(2)) ';']);
        end
    end
    
    for bdidx = 1:length(bodyparts)
        eval(['writetable(T_' bodyparts{bdidx} ',''' [bodyparts{bdidx} '.csv'] ''',''WriteRowNames'',false);']);
    end
    % next directory
    cd('..')
end

fprintf('All done')
