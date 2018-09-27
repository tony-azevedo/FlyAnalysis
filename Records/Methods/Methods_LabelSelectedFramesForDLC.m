%% Script to label points in randomly selected frames.
% Use Step1 code in python to collect random Frames. See Myconfig file for
% all the different inputs
trial = load('B:\Raw_Data\180621\180621_F3_C1\EpiFlash2T_Raw_180621_F3_C1_6.mat'); %#ok<*NASGU>
trial = load('B:\Raw_Data\180621\180621_F3_C1\EpiFlash2T_Raw_180621_F3_C1_8.mat'); %#ok<*NASGU>
trial = load('B:\Raw_Data/180628/180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_14.mat');
trial = load('B:\Raw_Data/180628/180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_11.mat');
trial = load('B:\Raw_Data/180628/180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_10.mat');
trial = load('B:\Raw_Data/180628/180628_F2_C1\EpiFlash2T_Raw_180628_F2_C1_8.mat');

%% Run the Step 1 for these files
% Deciding right now not to crop, but if I do, call this to get points

pos = [105 165 1175 859];

showProbeImage(trial)
%%
dispax = gca
h = imrect(dispax,pos)
pos = h.getPosition
x1 = round(pos(1));
x2 = round(pos(1)+pos(3));
y1 = round(pos(2));
y2 = round(pos(2)+pos(4));

%% Thinking about how many points to label

% Femur points (Decided on 6)
% ["FemurTrochanterDorsal", "FemurTrochanterDorsal","FemurBristle3", "FemurTip","FemurDorsalKneeBristle", "FemurDorsalIndent"]
%%% ventral trochanter connect
%%% dorsal trochater connect
%%% dorsal indent
% dorsal round
%%% dorsal knee bristle
%%% tip
%%% Bristle B3
% Bristle B2

% Tibia points
% ["TibiaVentralKink","TibiaVentralMid","TibiaVentralBulge","TibiaDorsalBulge","TibiaDorsalMid","TibiaDorsalConstriction"]
% ventral kink
% distal ventral bulge
% dorsal bulge
% dorsal constriction
% approximately ventral 
% approximately dorsal

% Probe
% EMG

%% Bodyparts
bodyparts = {'FemurTrochanterDorsal', 'FemurTrochanterVentral','FemurBristle3', 'FemurTip','FemurDorsalKneeBristle', 'FemurDorsalIndent','TibiaVentralKink','TibiaVentralMid','TibiaVentralBulge','TibiaDorsalBulge','TibiaDorsalMid','TibiaDorsalConstriction','Probe_end','Probe_shaft','EMG','Brightspot1','Brightspot2','Brightspot3'};
cd 'C:'\Users\tony\Code\DeepLabCut_Tony\Generating_a_Training_Set\data-femurTibiaJoint_IR\

REWRITE = 0;
REWRITE_STATIC = 0;
REWRITE_TIBIA = 0;
a = dir('EpiFlash2T*');

staticparts = bodyparts([1:6 13:length(bodyparts)]);
tibiaparts = bodyparts([7:12]);

%% Go through em all
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
    if exist('FemurTrochanterDorsal.csv') && ~REWRITE
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
    sz = [length(imnames) 2*length(tibiaparts)];
    varTypes = repmat({'double'},1,2*length(tibiaparts));
    varNames = {};
    for prtidx = 1:length(tibiaparts)
        varNames = [varNames {[tibiaparts{prtidx} '_X'] [tibiaparts{prtidx} '_Y']}];
    end
    T_tibia = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

    
    % for each Tibia point
    txt.Position(1) = 670;
    
    for prtidx = 1:length(tibiaparts)
        
        
        part = tibiaparts{prtidx};
        uiwait(msgbox(['New Part: ' part],'New part','modal'));
        if exist([part '_points.csv']) && ~REWRITE_TIBIA
            partpoints = readtable([part '_points.csv']);
            T_tibia(:,prtidx*2-1:prtidx*2) = partpoints;
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
        try delete(tibiadots); catch e; end
        for tprtidx = 1:prtidx-1
            pos(1) = T_tibia{1,tprtidx*2-1};
            pos(2) = T_tibia{1,tprtidx*2};
            tibiadots(tprtidx) = line(pos(1),pos(2),'marker','.','markersize',10,'markerfacecolor',[.1 .5 0],'markeredgecolor',[.1 .5 0]);
        end

        % put the established point on the image        
        pnt = impoint(dispax);
        pos = pnt.getPosition;
        T_tibia{1,prtidx*2-1} = pos(1);
        T_tibia{1,prtidx*2} = pos(2);
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
                tibiadots(tprtidx).XData = T_tibia{i,tprtidx*2-1};
                tibiadots(tprtidx).YData = T_tibia{i,tprtidx*2};
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

            T_tibia{i,prtidx*2-1} = pos(1);
            T_tibia{i,prtidx*2} = pos(2);
            % next image
        end

        delete(findobj('type','line','tag','curpart'))
        % save the part, just in case
        partpoints = T_tibia(:,prtidx*2-1:prtidx*2);
        writetable(partpoints,[part '_points.csv'],'WriteRowNames',true)
        
    end
    % next Tibia part
    
    % put the parts together into table and save bodyparts
    staticparts = bodyparts([1:6 13:length(bodyparts)]);
    tibiaparts = bodyparts([7:12]);

    T_all = [T_static(:,(1:13)),T_tibia,T_static(:,14:size(T_static,2))];
    
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


