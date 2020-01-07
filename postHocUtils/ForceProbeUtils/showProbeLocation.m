function trial = showProbeLocation(trial)
%% Set an ROI that avoids the leg, just gets the probe
% I think I only need 1 for now, but I'll keep the option for multiple
% (storing in cell vs matrix)

displayf = findobj('type','figure','tag','big_fig');
if isempty(displayf) || length(displayf)>1
    if length(displayf)>1
        delete(displayf);
    end
    displayf = figure;
    set(displayf,'position',[40 2 1280 1024],'tag','big_fig');
end
dispax = findobj('type','axes','tag','dispax');
if isempty(dispax)
    dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
    set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
    colormap(dispax,'gray')
end

%%

vid = VideoReader(trial.imageFile);
N = vid.Duration*vid.FrameRate;
h2 = postHocExposure(trial,N);

smooshedframe = double(readFrame(vid));
smooshedframe = squeeze(smooshedframe(:,:,1));

for jj = 1:10
    mov3 = double(readFrame(vid));
    smooshedframe = smooshedframe+mov3(:,:,1);
end
smooshedframe = smooshedframe/11;

im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);
hold(dispax,'on');

%%
if ~isfield(trial,'forceProbe_line')
error('Location Unknown!')
end

line(trial.forceProbe_line(:,1),trial.forceProbe_line(:,2),'parent',dispax,'color',[0 1 0],'tag','oldbar');
line(trial.forceProbe_tangent(:,1),trial.forceProbe_tangent(:,2),'parent',dispax,'marker','o','markeredgecolor',[0 1 0],'tag','oldpoint');

[~,~,l_r,~,p_] = probeCoordinates(trial);

line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);
line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3]);

figure(displayf)

