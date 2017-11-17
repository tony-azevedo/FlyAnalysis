function mask = ulCornerWithBarMask(h,img)

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

% create a triangle polygon 
tri = [
    0   0
    0   200
    200 0];

iii = (tri(1,1)-p_(1))/x(1);
tri(2,2) = iii*x(2)+p_(2);

iii = (tri(1,2)-p_(2))/x(2);
tri(3,1) = iii*x(1)+p_(1);


mask = poly2mask(tri(:,1),tri(:,2),size(img,1),size(img,2));

% alphamask(mask,[0 0 1],.3,dispax);

