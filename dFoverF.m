clear
close all

%[filename, pathname] = uigetfile('*.tif', 'Select TIF-file');
filebase = input('Enter basename of file:  ', 's');
num_frame = input('How many frames are in the stack? ');
filename=[filebase,'.tif'];
num_px = input ('How many pixels are there per line? ');

I = zeros([num_px num_px num_frame], 'double');  %preallocate 3-D array

%read in .tif file
for frame=1:num_frame
    [I(:,:,frame)] = imread(filename,frame);
end

%Add fourth dimension for compatibility with image functions
I_gs=zeros([num_px num_px 1 num_frame], 'double');
for frame=1:num_frame
    I_gs(:,:,1,frame)=I(:,:,frame);
end

%calculates a baseline image from frame bl_start through bl_end 

bl_start=input ('What is the number of the first frame in the baseline? ');
bl_end=input ('What is the number of the last frame in the baseline? ');
bl_numframes = (bl_end - bl_start)+1;
%I_F0=imlincomb((1/bl_numframes), I_gs(:,:,1,12), 0.125, I_gs(:,:,1,13), 0.125, I_gs(:,:,1,14), 0.125, I_gs(:,:,1,15), 0.125, I_gs(:,:,1,16), 0.125, I_gs(:,:,1,17), 0.125, I_gs(:,:,1,18), 0.125, I_gs(:,:,1,19));
%declare matrix to hold sum of all baseline images
image_sum=I_gs(:,:,1,bl_start);
start_count=bl_start + 1;
for f=start_count:bl_end
    image_sum = imadd(image_sum,I_gs(:,:,1,f));
end
I_F0=imdivide(image_sum, bl_numframes);

%calculate change in fluorescence frame by frame relative to baseline
I_dFovF = zeros([num_px num_px 1 num_frame], 'double'); 
for frame=1:num_frame
I_dFovF(:,:,1,frame) = 100*((I_gs(:,:,1,frame) ./ I_F0)-1);
end

%Set values above 500 to zero
I_dFovF_thr=zeros([num_px num_px 1 num_frame], 'double');
for frame=1:num_frame
    for row=1:num_px
        for column=1:num_px
            if I_dFovF(row,column,1,frame) >= 500
                I_dFovF_thr(row,column,1,frame)=0;
            else
                I_dFovF_thr(row,column,1,frame)=I_dFovF(row,column,1,frame);
            end
        end
    end
end

%apply Gaussian filter:
%rotationally symmetric Gaussian lowpass filter of size 5x5 with standard deviation
%sigma 2 (positive). 
G = fspecial('gaussian',[5 5],2);
I_dFovF_thr_filt = imfilter(I_dFovF_thr,G);

%plot montage of dFoverF images
figure
montage(I_dFovF_thr_filt)
colormap(jet)
caxis([1 150])
t=[num2str(filebase)];
title(t)


