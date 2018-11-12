%% Need to align the leg structure in the IR camera with leg in the CA camera

vid = VideoReader(trial.imageFile2);
t_i = 10*1/vid.FrameRate + trial.params.preDurInSec;
t_f = min([trial.params.stimDurInSec-10*1/vid.FrameRate,1]);


vid.CurrentTime = t_i;
cnt = 1;
frame3 = readFrame(vid);
frame = double(squeeze(frame3(:,:,1)));
while vid.CurrentTime<t_f
    cnt = cnt+1;
    frame3 = readFrame(vid);
    frame = frame+double(squeeze(frame3(:,:,1)));
    if ~mod(cnt,10)
        fprintf('.')
    end
end
fprintf('\n')

smooshedframe_Green = frame./cnt;
wh_Green = size(smooshedframe_Green);

green = trial.clmask(:,:,4)>0;
% green = smooshedframe_Green/max(smooshedframe_Green(:))>.33;


%%

vid = VideoReader(trial.imageFile);
t_i = 10*1/vid.FrameRate + trial.params.preDurInSec;
t_f = min([trial.params.stimDurInSec-10*1/vid.FrameRate,1]);

vid.CurrentTime = t_i;
cnt = 1;
frame3 = readFrame(vid);
frame = double(squeeze(frame3(:,:,1)));
while vid.CurrentTime<t_f
    cnt = cnt+1;
    frame3 = readFrame(vid);
    frame = frame+double(squeeze(frame3(:,:,1)));
    if ~mod(cnt,10)
        fprintf('.')
    end
end
fprintf('\n')

smooshedframe_IR = frame./cnt;

mask = smooshedframe_IR*0;

wh = size(smooshedframe_IR);

%%
displayf = figure;
displayf.Position = [40 40 fliplr(wh)];
displayf.ToolBar = 'none';
dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(wh)]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

colormap(dispax,'gray')
%im = imshow(smooshedframe,[2 8],'parent',dispax);
im = imshow(smooshedframe_IR,[0 2*quantile(smooshedframe_IR(:),0.975)],'parent',dispax);

% im = imshow(smooshedframe_Green,[0 2*quantile(smooshedframe_Green(:),0.975)],'parent',dispax);

X_offset = 640;
Y_offset = 0;
x_offset = getacqpref('FlyAnalysis','CaImgCam2X_Offset');
y_offset = getacqpref('FlyAnalysis','CaImgCam2Y_Offset');
theta = getacqpref('FlyAnalysis','CaImgCam2Rotation');

mask(Y_offset+1:min([Y_offset+ wh_Green(1),wh(1)]),X_offset+1:min([X_offset+ wh_Green(2),wh(2)])) = green;
green_1 = green;

a = alphamask(mask,[0 1 0],.5,dispax);
drawnow
pause(.5);

green_1 = imrotate(green,theta,'bilinear','crop');
green_1 = imtranslate(green_1,[x_offset y_offset],'linear','outputview','same','fillvalue',0);
mask(Y_offset+1:min([Y_offset+ wh_Green(1),wh(1)]),X_offset+1:min([X_offset+ wh_Green(2),wh(2)])) = green_1;
a.CData(:,:,2) = mask;
a.AlphaData = mask*.5;

txt = text(dispax,size(mask,2)/3,20,'Space bar to continue');
txt.Position = [20 10 0]*size(mask,2)/640;
txt.VerticalAlignment = 'top';
txt.Color = [1 1 1];
txt.FontSize = 18;
txt.FontName = 'Ariel';

drawnow;


%%
while 1
    keydown = waitforbuttonpress;
    while keydown==0 || ~any(strcmp({' ','j','J','k','K','i','I','l','L','e','E','r','R'},displayf.CurrentCharacter))
        %disp(displayf.CurrentCharacter);
        keydown = waitforbuttonpress;
    end
    cmd_key = displayf.CurrentCharacter;
    
    switch cmd_key
        case ' '
            fprintf('Done\n');
            break
        case 'j'
            x_offset = x_offset - .5;
        case 'J'
            x_offset = x_offset - 5;
        case 'k'
            y_offset = y_offset + .5;
        case 'K'
            y_offset = y_offset + 5;
        case 'i'
            y_offset = y_offset - .5;
        case 'I'
            y_offset = y_offset - 5;
        case 'l'
            x_offset = x_offset + .5;
        case 'L'
            x_offset = x_offset + 5;
        case 'e'
            theta = theta+.5;
        case 'E'
            theta = theta+2;
        case 'r'
            theta = theta-.5;
        case 'R'
            theta = theta-2;
        otherwise
    end
    green_1 = imrotate(green,theta,'bilinear','crop');
    green_1 = imtranslate(green_1,[x_offset y_offset],'linear','outputview','same','fillvalue',0);
    mask(Y_offset+1:min([Y_offset+ wh_Green(1),wh(1)]),X_offset+1:min([X_offset+ wh_Green(2),wh(2)])) = green_1;
    a.CData(:,:,2) = mask;
    a.AlphaData = mask*.5;
    drawnow;
end
%%
delete(a)

smooshedframe_Green_1 = imrotate(smooshedframe_Green,theta,'bilinear','crop');
smooshedframe_Green_1 = imtranslate(smooshedframe_Green_1,[x_offset y_offset],'linear','outputview','same','fillvalue',0);
smooshedframe_Green_1 = smooshedframe_Green_1/max(smooshedframe_Green_1(:))>.28;

mask(:,:) = nan;
mask(Y_offset+1:min([Y_offset+ wh_Green(1),wh(1)]),X_offset+1:min([X_offset+ wh_Green(2),wh(2)])) = smooshedframe_Green_1;
a = alphamask(mask,[0 1 0],.5,dispax);

%a = alphamask(mask,[0 1 0],.6,dispax);

%%
button = questdlg('SaveAlignment?','Alignment','No');
switch button
    case 'Yes'
        setacqpref('FlyAnalysis','CaImgCam2X_Offset',x_offset);
        setacqpref('FlyAnalysis','CaImgCam2Y_Offset',y_offset);
        setacqpref('FlyAnalysis','CaImgCam2Rotation',theta);
        fprintf('Saving Transform\n');
    case 'No'
    case 'Cancel'
end

