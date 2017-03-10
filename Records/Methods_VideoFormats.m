
cd C:\Users\tony\Code\FlyAnalysis\Records\Methods\VideoFormats


%moviename = 'avi_N250_2017-03-08-122549-0000.avi'        
% moviename = 'avi_N250_2017-03-08-122556-0000.avi'        
% moviename = 'mjpeg_N250_100_2017-03-08-122212-0000.avi'
% moviename = 'mjpeg_N250_100_2017-03-08-122243-0000.avi'  
% moviename = 'mjpeg_N250_100_2017-03-08-122336-0000.avi'  
moviename = 'mjpeg_N250_75_2017-03-08-122410-0000.avi'  
% moviename = 'mjpeg_N250_75_2017-03-08-122417-0000.avi'   
% moviename = 'mp4_N250_1M_2017-03-08-122016-0000.mp4'     
% moviename = 'mp4_N250_1M_2017-03-08-122027-0000.mp4'     
% moviename = 'mp4_N250_1M_2017-03-08-122112-0000.mp4'    

vid = VideoReader(moviename);

mov = readFrame(vid);
mov = mov(:,:,1);

figure
scale = [quantile(mov(:),0.025) quantile(mov(:),0.975)];
im = imshow(mov,[20 40],'initialmagnification',50);

% while hasFrame(vid)
%     mov = readFrame(vid);
%     mov = mov(:,:,1);
%     im.CData = mov;
%     
%     pause
% end
