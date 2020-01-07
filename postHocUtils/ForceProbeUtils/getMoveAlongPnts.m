function moveEvalPntsAlong = getMoveAlongPnts(h)
l = h.forceProbe_line;
p = h.forceProbe_tangent;

% probe_eval_points = turnLineIntoEvalPnts(l,p);
% recenter
l_0 = l - repmat(mean(l,1),2,1);
p_0 = p - mean(l,1);

% for my purposes, get the line equation (m,b)
m = diff(l(:,2))/diff(l(:,1));
b = l(1,2)-m*l(1,1);

% find y vector
barbar = l_0(2,:)/norm(l_0(2,:));

% project tangent point
p_scalar = barbar*p_0';

% find intercept, recenter
p_ = p_scalar*barbar+mean(l,1);

% rotate coordinates
R = [cos(pi/2) -sin(pi/2);
    sin(pi/2) cos(pi/2)];
l_r = (R*l_0')'/4;
upperright_ind = find(l_r(:,1)>l_r(:,2));
x = l_r(upperright_ind,:)/norm(l_r(upperright_ind,:));
l_r = l_r + repmat(p_,2,1);


%% now set up evaluation points
% find the edge of the image
if b<0
    p_edge = [-b/m 0];
else
    p_edge = [0  b];
end
l_eval = [p_;p_edge];

tangent_to_edge = l_eval - repmat(l_eval(1,:),2,1);
points2eval = (1:ceil(norm(tangent_to_edge(2,:))))-1;
barbar = tangent_to_edge(2,:)/norm(tangent_to_edge(2,:));

% eval points occur every pxl along l_eval
moveEvalPntsAlong = repmat(p_',1,length(points2eval))+barbar'*points2eval;
end
