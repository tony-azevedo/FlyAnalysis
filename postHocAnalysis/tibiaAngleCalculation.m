function h = tibiaAngleCalculation(trial,varargin)

f = figure;
f.Position = [1360    32   560   964];
ax5 = subplot(2,1,1,'parent',f); ax5.Position = [0.02 0.5838 0.96 0.4];
vid = VideoReader(trial.imageFile);
vid.CurrentTime = 1;
frame = vid.readFrame;
frame = double(squeeze(frame(:,:,1)));
im = imshow(frame,[0 128],'InitialMagnification',75,'parent',ax5);
hold(ax5,'on');

lp = trial.legPositions;

plotellipse(ax5,lp.Origin_3D(1:2), a, b, alpha);
plot3(ax5,origin_est(1)+tibia_vects_3D(:,1),origin_est(2)+tibia_vects_3D(:,2),origin_est(3)+tibia_vects_3D(:,3),'c.');
plot3(ax5,origin_est(1)+300*[0,femurUnit_plane(1)], origin_est(2)+300*[0,femurUnit_plane(2)],origin_est(3)+300*[0,femurUnit_plane(3)],'r');

ax6 = subplot(2,1,2,'parent',f);
el = plotellipse(ax6,origin+z', a, b, alpha);
el.ZData = 0*el.YData;
hold(ax6,'on')
plot3(ax6,origin_est(1)+tibia_vects_3D(:,1),origin_est(2)+tibia_vects_3D(:,2),origin_est(3)+tibia_vects_3D(:,3),'m.');
plot3(ax6,origin_est(1)+300*[0,femurUnit_plane(1)], origin_est(2)+300*[0,femurUnit_plane(2)],origin_est(3)+300*[0,femurUnit_plane(3)],'r');

ax6.XGrid = 'on';
ax6.YGrid = 'on';
ax6.YDir = 'reverse';
ax6.CameraPosition = [-2.8334    1.2368    2.0467]*1E3;

