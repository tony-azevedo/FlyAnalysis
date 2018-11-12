%% Methods_DecideOnCompressionForGrayscaleAvi
vid = VideoReader(fullfile('F:\Acquisition\181007\181007_F1_C1','EpiFlash2CB2T_Image_181007_F1_C1_101_20181007T140028.avi'));

displayf = figure;
displayf.Position = [40 40 1280 1024];
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

I = vid.readFrame;
I = squeeze(double(I(:,:,1)));

colormap(dispax,'gray')
% im = imshow(smooshedframe,[2 8],'parent',dispax);
im = imshow(I,[0 2*quantile(I(:),0.975)],'parent',dispax);

txt = text(dispax,size(I,2)/3,20,'TXT');
txt.Position = [20 10 0]*size(I,2)/640;
txt.VerticalAlignment = 'top';
txt.Color = [1 1 1];
txt.FontSize = 18;
txt.FontName = 'Ariel';

txt.String = 'Greyscale AVI 320 MB';
    
    %%
I = vid.readFrame;
I = squeeze(double(I(:,:,1)));

im.CData = I;


%% Methods_DecideOnCompressionForGrayscaleAvi
vid = VideoReader(fullfile('F:\Acquisition\181007\181007_F1_C1','compressed','EpiFlash2CB2T_Image_181007_F1_C1_101_20181007T140028.avi'));

displayf = figure;
displayf.Position = [40 40 1280 1024];
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

I = vid.readFrame;
I = squeeze(double(I(:,:,1)));

colormap(dispax,'gray')
% im = imshow(smooshedframe,[2 8],'parent',dispax);
im = imshow(I,[0 2*quantile(I(:),0.975)],'parent',dispax);

txt = text(dispax,size(I,2)/3,20,'TXT');
txt.Position = [20 10 0]*size(I,2)/640;
txt.VerticalAlignment = 'top';
txt.Color = [1 1 1];
txt.FontSize = 18;
txt.FontName = 'Ariel';

txt.String = 'h264 compressed 15 MB';

%% 

I = vid.readFrame;
I = squeeze(double(I(:,:,1)));

im.CData = I;

%%
vid = VideoReader(fullfile('F:\Acquisition\181007\181007_F1_C1\mjpeg','EpiFlash2CB2T_Image_181007_F1_C1_101_20181007T140028.avi'));

displayf = figure;
displayf.Position = [40 40 1280 1024];
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

I = vid.readFrame;
I = squeeze(double(I(:,:,1)));

colormap(dispax,'gray')
% im = imshow(smooshedframe,[2 8],'parent',dispax);
im = imshow(I,[0 2*quantile(I(:),0.975)],'parent',dispax);

txt = text(dispax,size(I,2)/3,20,'TXT');
txt.Position = [20 10 0]*size(I,2)/640;
txt.VerticalAlignment = 'top';
txt.Color = [1 1 1];
txt.FontSize = 18;
txt.FontName = 'Ariel';

txt.String = 'mjpeg compressed 8 MB';

%% 

I = vid.readFrame;
I = squeeze(double(I(:,:,1)));

im.CData = I;