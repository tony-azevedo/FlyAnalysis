function varargout = getScimImageStack(data,params,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('NewROI','Yes',@ischar);
p.addParameter('dFoFfig',[],@isnumeric);
p.addParameter('MotionCorrection',true,@islogical);
p.addParameter('MakeMovie',false,@islogical);
p.addParameter('MovieLocation','',@ischar);
p.addParameter('Channels',[1 2],@isnumeric);
p.addParameter('PlotFlag',true,@islogical);
p.addParameter('Masks',{},@iscell);

parse(p,varargin{:});

varargout = {[]};

imdir = regexprep(data.name,{'Raw','.mat','Acquisition'},{'Images','','Raw_Data'});
if ~isdir(imdir)
    error('No Camera Input: Exiting %s routine',mfilename);
end
% if isempty(p.Results.dFoFfig)
%     fig = findobj('tag',mfilename);
% else
%     fig = p.Results.dFoFfig;
% end
% if isempty(fig);
%     if ~ispref('AnalysisFigures') ||~ispref('AnalysisFigures',mfilename) % rmpref('AnalysisFigures','powerSpectrum')
%         proplist = {...
%             'tag',mfilename,...
%             'Position',[1030 10 560 450],...
%             'NumberTitle', 'off',...
%             'Name', mfilename,... % 'DeleteFcn',@obj.setDisplay);
%             };
%         setpref('AnalysisFigures',mfilename,proplist);
%     end
%     proplist =  getpref('AnalysisFigures',mfilename);
%     fig = figure(proplist{:});
% end

button = p.Results.NewROI;

%%  Load the frames from the Image directory
%[filename, pathname] = uigetfile('*.tif', 'Select TIF-file');
imagefiles = dir(fullfile(imdir,[params.protocol '_Image_*']));
if length(imagefiles)==0
    error('No Camera Input: Exiting %s routine',mfilename);
end
i_info = imfinfo(fullfile(imdir,imagefiles(1).name));
chans = regexp(i_info(1).ImageDescription,'state.acq.acquiringChannel\d=1');
num_chan = length(chans);

num_frame = round(length(i_info)/num_chan);
im = imread(fullfile(imdir,imagefiles(1).name),'tiff','Index',1,'Info',i_info);
num_px = size(im);

exp_t = makeScimStackTime(i_info,num_frame,params);

I0 = zeros([num_px(:); num_frame; num_chan]', 'double');  %preallocate 3-D array
%read in .tif files
[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(data.name);
fprintf([protocol '_' dateID '_' flynum '_' cellnum '_' trialnum '\n'])
tic; fprintf('Loading: '); 
for frame=1:num_frame
    for chan = 1:num_chan
        [I0(:,:,frame,chan)] = imread(fullfile(imdir,imagefiles(1).name),'tiff',...
            'Index',(2*(frame-1)+chan),'Info',i_info);
    end
end
toc


%% Do motion correction here

I = I0;
if p.Results.MotionCorrection
    ref_frame = I(:,:,1,2);
    ref_FFT = fft2(ref_frame);
    for frame=2:num_frame
        [~, Greg] = dftregistration(ref_FFT,fft2(I(:,:,frame,2)),1);
        I(:,:,frame,2) = real(ifft2(Greg));
    end
end

%% Spatial filter frames here
% gauss_filter = fspecial('gaussian', [3 3], 1.5);
% I_processed = I;
% for ch_ind = 1:num_chan
%     for fr_ind = 1:num_frame
%         I_processed(:,:,fr_ind,ch_ind) = imfilter(I(:,:,fr_ind,ch_ind), gauss_filter, 'replicate');
%     end
% end
% 
% % figure
% % subplot(1,2,1)
% % imshow(I(:,:,20,ch_ind),[])
% % subplot(1,2,2)
% % imshow(I_processed(:,:,20,ch_ind),[])
% % pause
% 
% % pixel_1_initial = squeeze(I(32,32,:,2));
% % pixel_2_initial = squeeze(I(1,1,:,2));
% I = I_processed;

%% Filter over frames here
I_processed = I;

sigma = 1;
fsize = size(I_processed,3);
x = linspace(-fsize+1,fsize,2*fsize);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); 

for i=1:size(I_processed,1)
  for j=1:size(I_processed,2)
    I_processed(i,j,:,2) = conv(squeeze(I_processed(i,j,:,2)), gaussFilter, 'same');
  end
end

% figure
% subplot(1,1,1), hold on
% 
% plot(pixel_1_initial,'b')
% plot(squeeze(I(32,32,:,2)),'r')
% plot(squeeze(I_processed(32,32,:,2)),'k','Linewidth',1)
% 
% plot(pixel_2_initial,'color',[.8 .8 1])
% plot(squeeze(I(1,1,:,2)),'color',[1 .8 .8])
% plot(squeeze(I_processed(1,1,:,2)),'color',[.8 .8 .8],'Linewidth',1)
% pause

I = I_processed;
I = squeeze(I(:,:,:,2));
varargout = {I};


function exp_t = makeScimStackTime(i_info,num_frame,params)
dscr = i_info(1).ImageDescription;
strstart = regexp(dscr,'state.acq.frameRate=','end');
strend = regexp(dscr,'state.acq.frameRate=\d*\.\d*','end');
delta_t = 1/str2double(dscr(strstart+1:strend));
t = makeInTime(params);
exp_t = [fliplr([-delta_t:-delta_t:t(1)]), 0:delta_t:t(end)];
exp_t = exp_t(1:num_frame);