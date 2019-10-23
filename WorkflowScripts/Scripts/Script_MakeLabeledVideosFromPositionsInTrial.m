%% Assume a trial has been loaded and that it has the positions already there
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

if ~exist(fullfile(D,'trackedVideos'),'dir')
    mkdir(fullfile(D,'trackedVideos'))
end
figpath = fullfile(D,'trackedVideos');

t = makeInTime(trial.params);
exp = postHocExposure(trial);

ft = t(exp.exposure);
vt = ft-ft(1);

fr_idx = 1;
vid = VideoReader(trial.imageFile);
vid.CurrentTime = 0; %weird_ft(1);

output_video = fullfile(figpath, [trial.imageFile(1:end-4) 'labeled_3X.avi']);
writerObj = VideoWriter(output_video,'Motion JPEG AVI');
writerObj.Quality = 100;
writerObj.FrameRate = floor(vid.FrameRate/3);
open(writerObj);

I = vid.readFrame;
I = double(squeeze(I(:,:,1)));

displayf = figure;
set(displayf,'position',[120 10 fliplr(size(I))]+[0 0 0 10],'tag','big_fig');
displayf.MenuBar = 'none';
displayf.ToolBar = 'none';

dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(size(I))]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

im = imshow(I,[0 1.6*quantile(I(:),0.975)],'parent',dispax);

txt = text(dispax,size(I,2)/3,20,'TXT');
txt.Position = [20 10 0]*size(I,2)/640;
txt.VerticalAlignment = 'top';
txt.Color = [1 1 1];
txt.FontSize = 18;
txt.FontName = 'Ariel';

clear pnt

% put each body part on the image
bodyparts = trial.legPositions.Positions.Properties.VariableNames(contains(trial.legPositions.Positions.Properties.VariableNames,'_x'));
bodyparts = regexprep(bodyparts,'_x','');
clrs = distinguishable_colors(length(bodyparts));

try delete(pnt); catch e, end

for bdidx = 1:length(bodyparts)
    T_X = trial.legPositions.Positions.([bodyparts{bdidx} '_x']);
    T_Y = trial.legPositions.Positions.([bodyparts{bdidx} '_y']);
    xy = [T_X(1,1) T_Y(1,1)];
    pnt(bdidx) = drawpoint(dispax,'Position',xy,'Color',clrs(bdidx,:));
    %     pnt(bdidx).setString(bodyparts{bdidx});
end
%pnt(contains(bodyparts,'TibiaVentralBulge')).Label = 'TibiaVentralBulge';
%pnt(contains(bodyparts,'TibiaVentralBulge')).Label = '';

% put femur on there
fem = trial.legPositions.Femur;
o = trial.legPositions.Origin_3D;
line([0 fem(1)]*250 + o(1),[0 fem(2)]*250 + o(2),'color',[0 .8 0],'parent',dispax)

% put tibia line on there
tbp = trial.legPositions.Tibia_Projection(1,:);
tbln = line([o(1) tbp(1)],[o(2) tbp(2)],'color',[0 .8 0],'parent',dispax);
angletext = text(o(1) - 30,o(2)-30,[num2str(trial.legPositions.Tibia_Angle(1)) char(176)],'parent',dispax,'color',[1 1 1],'HorizontalAlignment','right');

% start back at the first frame
vid.CurrentTime = 0;
while fr_idx <= length(ft) && vid.hasFrame    % load up each image,
    % put a big title on the image,
    txt.String = sprintf('(%d of %d)',fr_idx, length(ft));

    I = vid.readFrame;
    I = double(I);
    I = squeeze(I(:,:,1));
    
    im.CData = I;
    
    for bdidx = 1:length(bodyparts)
        T_X = trial.legPositions.Positions.([bodyparts{bdidx} '_x']);
        T_Y = trial.legPositions.Positions.([bodyparts{bdidx} '_y']);
        xy = [T_X(fr_idx,1) T_Y(fr_idx,1)];
        pnt(bdidx).Position = xy;
    end
    
    tbp = trial.legPositions.Tibia_Projection(fr_idx,:);
    tbln.XData = [o(1) tbp(1)];
    tbln.YData = [o(2) tbp(2)];
    angletext.String = [num2str(trial.legPositions.Tibia_Angle(fr_idx)) char(176)];
    
    drawnow;
    
    frame = getframe(displayf); 
    writeVideo(writerObj,frame)

    fr_idx = fr_idx+1;
end

close(writerObj)

fprintf('All done')
