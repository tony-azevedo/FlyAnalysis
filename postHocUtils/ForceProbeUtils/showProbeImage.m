function trial = showProbeImage(trial)
%% Set an ROI that avoids the leg, just gets the probe
% I think I only need 1 for now, but I'll keep the option for multiple
% (storing in cell vs matrix)


try vid = VideoReader(trial.imageFile);
catch e
    if strcmp(e.message,'The filename specified was not found in the MATLAB path.')
        [~,~,~,~,~,D] = extractRawIdentifiers(trial.name);
        disp('Not in raw data folder')
        disp(D)
        vid = VideoReader(fullfile(D,trial.imageFile));
    else
        e.rethrow
    end
end
    
N = vid.Duration*vid.FrameRate;
h2 = postHocExposure(trial,N);

smooshedframe = double(readFrame(vid));
smooshedframe = squeeze(smooshedframe(:,:,1));

for jj = 1:10
    mov3 = double(readFrame(vid));
    smooshedframe = smooshedframe+mov3(:,:,1);
end
smooshedframe = smooshedframe/11;

    displayf = figure;
    set(displayf,'position',[40 2 1280 1024],'tag','big_fig');

    dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
    set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
    colormap(dispax,'gray')

im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);

figure(displayf)

