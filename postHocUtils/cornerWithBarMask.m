function l_r = cornerWithBarMask(h,img)

l = h.forceProbe_line;
p = h.forceProbe_tangent;

% recenter
l_0 = l - repmat(mean(l,1),2,1);
p_0 = p - mean(l,1);

% find y vector
y = l_0(1,:)/norm(l_0(1,:));

% project tangent point
p_scalar = y*p_0';

% find intercept, recenter
p_ = p_scalar*y+mean(l,1);

% rotate coordinates
R = [cos(pi/2) -sin(pi/2);
    sin(pi/2) cos(pi/2)];
l_r = (R*l_0')'/4;
upperright_ind = find(l_r(:,1)>l_r(:,2));
x = l_r(upperright_ind,:)/norm(l_r(upperright_ind,:));

% % find borders along these vectors
% bounds = get(dispax,'Position');
% bounds = reshape(bounds,2,[])';
% bounds = bounds - repmat(p_,2,1);
%
% % find bounds in terms of rotated axis
% % far x wall (x = 1280) vs top y wall (y=0)
% topy_dist = bounds(1,2)/x(2);
% rightx_dist = bounds(2,1)/x(1);
% bound1_dist = min(abs([topy_dist rightx_dist]));
%
% % far near x wall (x = 0) vs bottom y wall (y=1024)
% bottomy_dist = bounds(2,2);
% leftx_dist = bounds(1,1)/x(1);
% bound2_dist = -min(abs([bottomy_dist leftx_dist]));
%
% l_r = [bound1_dist; bound2_dist]*x;
l_r = l_r + repmat(p_,2,1);

% find limits projected along x
line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);

line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3]);

end