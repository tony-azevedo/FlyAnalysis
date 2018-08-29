
%% measure the pixel distance for 5X

displayf = figure;           
set(displayf,'position',[200 150 980 786],'color',[0 0 0]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 980 786]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');

% top origin
top = imread('B:\Raw_Data\RigSpecifications\ImageOfChamber_top_2017-09-28-133949-0000.bmp');
imshow(top)
ptop = impoint(dispax);
y1 = ptop.getPosition; %595.4388   45.5612

% bottom 898.2 um
bottom = imread('B:\Raw_Data\RigSpecifications\ImageOfChamber_bottom_2017-09-28-134157-0000.pgm');
imshow(bottom)
pbottom = impoint(dispax);
y2 = pbottom.getPosition; % 620.2551  936.3367

% left origin
left = imread('B:\Raw_Data\RigSpecifications\ImageOfChamber_left_2017-09-28-134307-0000.pgm');
imshow(left)
pleft = impoint(dispax);
x1 = pleft.getPosition; % 215.3571  289.8061

% right 603 um
right = imread('B:\Raw_Data\RigSpecifications\ImageOfChamber_right_2017-09-28-134338-0000.pgm');
imshow(right)
pright = impoint(dispax);
x2 = pright.getPosition; % 800.5000  278.0510

L_v = 898.2;
L_h = 603;

perpixel_y = L_v/sqrt((y2(2)-y1(2))^2+(y2(1)-y1(1))^2) % HAHA! resolution is 1 um per pixel! 1.0083
perpixel_x = L_h/sqrt((x2(2)-x1(2))^2+(x2(1)-x1(1))^2) % HAHA! resolution is 1 um per pixel! 1.04 
% AND!! the electrode is essentially perpendicular! since the non movement
% direction is close to 0;

%% measure the pixel distance for 2X

displayf = figure;           
set(displayf,'position',[200 150 980 786],'color',[0 0 0]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 980 786]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');

% top origin
top = imread('B:\Raw_Data\RigSpecifications\Basler acA1300-200um (22366722)_20180826_135436530_0001.tiff');
imshow(top)
ptop = impoint(dispax);
y1 = ptop.getPosition; %595.4388   45.5612

% bottom 768.00 um
bottom = imread('B:\Raw_Data\RigSpecifications\Basler acA1300-200um (22366722)_20180826_135523202_1666.tiff');
imshow(bottom)
pbottom = impoint(dispax);
y2 = pbottom.getPosition; % 620.2551  936.3367

% left origin
left = imread('B:\Raw_Data\RigSpecifications\Basler acA1300-200um (22366722)_20180826_140028477_0001.tiff');
imshow(left)
pleft = impoint(dispax);
x1 = pleft.getPosition; % 215.3571  289.8061

% right 650.4
right = imread('B:\Raw_Data\RigSpecifications\Basler acA1300-200um (22366722)_20180826_140129272_0001.tiff');
imshow(right)
pright = impoint(dispax);
x2 = pright.getPosition; % 800.5000  278.0510

L_v = 768.00;
L_h = 650.4;

perpixel_y = L_v/sqrt((y2(2)-y1(2))^2+(y2(1)-y1(1))^2) % HAHA! resolution is 2.5 um per pixel! 2.4914
perpixel_x = L_h/sqrt((x2(2)-x1(2))^2+(x2(1)-x1(1))^2) % HAHA! resolution is 2.5 um per pixel! 2.5405 
% AND!! the electrode is essentially perpendicular! since the non movement
% direction is close to 0;
