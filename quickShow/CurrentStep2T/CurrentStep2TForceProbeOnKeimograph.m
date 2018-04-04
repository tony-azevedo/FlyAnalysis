function h = CurrentStep2TForceProbeOnKeimograph(h,handles,savetag)

if ~isfield(handles.trial,'forceProbeStuff')
    fprintf('No profiles\n');
    beep
    return
else
    I_profile = handles.trial.forceProbeStuff.keimograph;
end

ax = subplot(1,1,1,'parent',h);  cla(ax,'reset')
% im = imshow(I_profile,[0 2*quantile(I_profile(:),0.975)],'parent',ax);
h = pcolor(I_profile);
set(h,'EdgeColor','none');
colormap(ax,'gray')

fPP = 1:size(I_profile,2);

for kk = 1:size(I_profile,2)
    frame_mu = I_profile(:,kk);
    dark = mean(frame_mu(frame_mu<quantile(frame_mu(:),0.12)));

    [pk,loc] = max(frame_mu-dark);

    left = find(frame_mu(1:loc)-dark<pk*2/3,1,'last');
    right = find(frame_mu(loc:end)-dark<pk*4/5,1,'first')+loc;
    
    r_idx = left+1:right-1;
    com = sum(r_idx'.*frame_mu(r_idx))./sum(frame_mu(r_idx));
        
    fPP(kk) = com;
end
hold(ax,'on')
plot(1:size(I_profile,2),fPP,'marker','o','markersize',3,'markerfacecolor',[1 1 1],'markeredgecolor',[0 0 1],'linestyle','none');


% h2 = postHocExposure(handles.trial,size(I_profile,2));
% frame_times = x(h2.exposure);

% origin = find(handles.trial.forceProbeStuff.EvalPnts(1,:)==0&handles.trial.forceProbeStuff.EvalPnts(2,:)==0);
% x_hat = handles.trial.forceProbeStuff.EvalPnts(:,origin+1);
% CoM = handles.trial.forceProbeStuff.forceProbePosition';
% CoM = CoM*x_hat;

% plot(ax,frame_times,handles.trial.forceProbeStuff.forceProbePosition(1:length(frame_times))), hold(ax,'on');
% plot(ax,frame_times,handles.trial.forceProbeStuff.forceProbePosition(1:length(frame_times)),'.b'), hold(ax,'off');
% axis(ax,'tight')
% xlim(ax,[-trial.params.preDurInSec  trial.params.stimDurInSec+trial.params.postDurInSec])
% xlabel(ax,'s')
% ylabel(ax,'CoM (pixels)')

